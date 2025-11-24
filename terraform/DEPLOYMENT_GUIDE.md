# Azure Web App Deployment Setup Guide

## Overview
This guide shows how to deploy the Solar System app to Azure Web App using Terraform **from the GitHub Actions pipeline**.

## Prerequisites
1. Azure subscription
2. Azure CLI installed locally (for initial setup only)
3. GitHub repository access

## Step 1: Create Azure Service Principal

Run this command to create a service principal for GitHub Actions:

```bash
az ad sp create-for-rbac \
  --name "github-actions-solar-system" \
  --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --sdk-auth
```

Replace `{subscription-id}` with your Azure subscription ID.

This outputs JSON credentials. **Save the entire JSON output.**

## Step 2: Create Terraform State Storage (Optional but Recommended)

Create a storage account for Terraform state:

```bash
# Create resource group for Terraform state
az group create --name tfstate-rg --location "East US"

# Create storage account (name must be globally unique)
az storage account create \
  --name tfstatesolarunique123 \
  --resource-group tfstate-rg \
  --location "East US" \
  --sku Standard_LRS

# Create container
az storage container create \
  --name tfstate \
  --account-name tfstatesolarunique123
```

**Important**: Update `terraform/backend.tf` with your unique storage account name.

## Step 3: Configure GitHub Secrets

Add these secrets to GitHub repository (Settings → Secrets and variables → Actions):

### Required Secrets (8 total):

1. **AZURE_CREDENTIALS**
   - The complete JSON from Step 1
   
2. **ARM_CLIENT_ID**
   - From JSON: `clientId` value

3. **ARM_CLIENT_SECRET**
   - From JSON: `clientSecret` value

4. **ARM_SUBSCRIPTION_ID**
   - From JSON: `subscriptionId` value

5. **ARM_TENANT_ID**
   - From JSON: `tenantId` value

6. **AZURE_WEBAPP_NAME**
   - Choose a globally unique name (e.g., `solar-system-devsecops-yourname123`)

7. **MONGO_URI**
   - Your MongoDB Atlas connection string
   - Format: `mongodb+srv://user:pass@cluster.mongodb.net/solar-system`

8. **GITHUB_TOKEN**
   - Already exists automatically in GitHub Actions
   - No action needed

## Step 4: Update Terraform Backend (if using remote state)

Edit `terraform/backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatesolarunique123"  # Your unique name
    container_name       = "tfstate"
    key                  = "solar-system.terraform.tfstate"
  }
}
```

**OR** delete `backend.tf` to use local state (simpler for demo projects).

## Step 5: Deploy via GitHub Actions

The pipeline will automatically:
1. Run `terraform init`
2. Run `terraform plan`
3. Run `terraform apply`
4. Deploy the latest Docker image
5. Restart the Web App
6. Run health checks

### Trigger Deployment

```bash
git add .
git commit -m "Deploy Azure Web App via Terraform"
git push origin main
```

Watch the pipeline in GitHub Actions → Deploy to Azure Web App job.

## Step 6: Verify Deployment

After pipeline completes:

1. **Check GitHub Actions logs** for the webapp URL
2. **Visit your app**: `https://<AZURE_WEBAPP_NAME>.azurewebsites.net`
3. **Health check**: `https://<AZURE_WEBAPP_NAME>.azurewebsites.net/ready`

## Pipeline Behavior

### First Run
- Creates all Azure resources (Resource Group, App Service Plan, Web App)
- Configures container settings
- Pulls image from GHCR
- Takes ~3-5 minutes

### Subsequent Runs
- Updates existing resources if Terraform code changed
- Restarts Web App to pull latest image
- Takes ~1-2 minutes

## Local Terraform Testing (Optional)

If you want to test Terraform locally before pushing:

```bash
cd terraform

# Create terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit with your values

# Login to Azure
az login

# Export ARM variables
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_SUBSCRIPTION_ID="..."
export ARM_TENANT_ID="..."

# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply
```

## Monitoring

### View Deployment Logs
In GitHub Actions → Deploy to Azure Web App job

### View Application Logs
```bash
az webapp log tail \
  --resource-group rg-solar-system \
  --name <AZURE_WEBAPP_NAME>
```

### View Terraform State
```bash
cd terraform
terraform show
```

## Costs

- **B1 Tier** (default): ~$13/month
- **Storage account** for Terraform state: ~$0.50/month
- **F1 Tier** (free option): $0/month (60 CPU min/day limit)

To use free tier, add to `terraform/variables.tf` default:
```hcl
default = "F1"
```

## Cleanup

### Option 1: Via Terraform (Recommended)
```bash
cd terraform
terraform destroy
```

### Option 2: Via Azure Portal
Delete the resource group `rg-solar-system`

### Option 3: Via Azure CLI
```bash
az group delete --name rg-solar-system --yes
```

## Troubleshooting

### Pipeline fails at Terraform Init
- Check ARM_* secrets are correctly set
- Verify storage account name in backend.tf exists

### Pipeline fails at Terraform Apply
- Check AZURE_WEBAPP_NAME is globally unique
- Verify service principal has Contributor role
- Check all required secrets are set

### Web App shows "Application Error"
Check logs:
```bash
az webapp log download \
  --resource-group rg-solar-system \
  --name <AZURE_WEBAPP_NAME> \
  --log-file app-logs.zip
```

### Container not pulling from GHCR
- Verify GitHub Container Registry image exists
- Check GITHUB_TOKEN has packages:read permission (automatic)
- Ensure image is public or credentials are correct

### MongoDB connection failing
- Verify MONGO_URI secret is correct
- Check MongoDB Atlas IP whitelist (allow 0.0.0.0/0 or Azure IPs)

## Advanced Configuration

### Custom Domain
Add to `main.tf`:
```hcl
resource "azurerm_app_service_custom_hostname_binding" "custom" {
  hostname            = "app.yourdomain.com"
  app_service_name    = azurerm_linux_web_app.webapp.name
  resource_group_name = azurerm_resource_group.rg.name
}
```

### Auto-Scaling
Add to `main.tf`:
```hcl
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-config"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_service_plan.app_plan.id

  profile {
    name = "AutoScale"
    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }
  }
}
```

## Security Best Practices

1. ✅ HTTPS enforced by default
2. ✅ Secrets stored in GitHub Secrets (encrypted)
3. ✅ MongoDB URI not exposed in code
4. ✅ Service principal with least privilege (Contributor on subscription)
5. ✅ Health checks enabled
6. ✅ Container registry authentication configured
