variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-solar-system"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "plan-solar-system"
}

variable "app_name" {
  description = "Name of the Web App (must be globally unique)"
  type        = string
  default     = "solar-system-devsecops"
}

variable "sku_name" {
  description = "SKU name for App Service Plan (F1=Free, B1=Basic, S1=Standard, P1V2=Premium)"
  type        = string
  default     = "F1"  # Free tier - perfect for demo/academic projects
}

variable "docker_image" {
  description = "Docker image name with tag from GitHub Container Registry"
  type        = string
  default     = "deviant101/solar-system:latest"
}

variable "github_username" {
  description = "GitHub username for container registry authentication"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub Personal Access Token for pulling images from GHCR"
  type        = string
  sensitive   = true
}

variable "mongo_uri" {
  description = "MongoDB connection string"
  type        = string
  sensitive   = true
}
