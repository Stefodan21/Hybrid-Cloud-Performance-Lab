Terraform {
  required_version = ">= 0.12"
  
    backend "azurerm" {
      use_azuread_auth = true
      tenant_id = var.tenant_id
      storage_account_name = var.storage_account_name
      container_name = var.container_name
      key = "terraform.tfstate"
    }

    required_providers {
      azurerm = "5.0.1"
    }
    
    
}