terraform {
  required_version = ">= 1.3.0"
  
  backend "azurerm" {
    use_azuread_auth = true
    tenant_id = var.tenant_id
    storage_account_name = var.storage_account_name
    container_name = var.container_name
    key = "terraform.tfstate"
  }

  required_providers {

    azurerm = {
      source = "hashicorp/azurerm"
      version = "5.0.1"
    }
  }
    
    
}