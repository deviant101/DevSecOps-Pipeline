terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  
  tags = {
    Environment = "Production"
    Project     = "SSD-DevSecOps"
    ManagedBy   = "Terraform"
  }
}

# App Service Plan (Linux-based for containers)
resource "azurerm_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.sku_name
  
  tags = {
    Environment = "Production"
    Project     = "SSD-DevSecOps"
  }
}

# Linux Web App for Containers
resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id
  
  site_config {
    always_on = var.sku_name != "F1" ? true : false  # Free tier doesn't support always_on
    
    application_stack {
      docker_registry_url      = "https://ghcr.io"
      docker_image_name        = var.docker_image
      docker_registry_username = var.github_username
      docker_registry_password = var.github_token
    }
    
    health_check_path = "/ready"
  }
  
  app_settings = {
    "MONGO_URI"                       = var.mongo_uri
    "WEBSITES_PORT"                   = "3000"
    "DOCKER_ENABLE_CI"                = "true"
    "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.github_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.github_token
  }
  
  https_only = true
  
  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    
    application_logs {
      file_system_level = "Information"
    }
  }
  
  tags = {
    Environment = "Production"
    Project     = "SSD-DevSecOps"
  }
}
