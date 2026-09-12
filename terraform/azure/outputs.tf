output "azure_vm_names" {
  description = "Names of the Azure virtual machines."
  value       = azurerm_linux_virtual_machine.app[*].name
}

output "azure_vm_private_ips" {
  description = "Private IP addresses assigned to the Azure virtual machines."
  value       = azurerm_network_interface.app[*].private_ip_address
}

output "azure_load_balancer_public_ip_id" {
  description = "Public IP resource ID attached to the Azure load balancer."
  value       = azurerm_public_ip.appip.id
}