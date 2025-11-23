output "webapp_url" {
  description = "URL of the deployed Web App"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}

output "webapp_name" {
  description = "Name of the Web App"
  value       = azurerm_linux_web_app.webapp.name
}

output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "webapp_id" {
  description = "Resource ID of the Web App"
  value       = azurerm_linux_web_app.webapp.id
}
