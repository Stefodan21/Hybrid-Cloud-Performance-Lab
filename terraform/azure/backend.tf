Terraform {
  required_version = ">= 0.12"
  
    backend "azurerm" {
      use_azuread_auth = true
      tenant_id = "84c31ca0-ac3b-4eae-ad11-519d80233e6f"
      storage_account_name = "sttradeeastus001"
      container_name = "terraform"
      key = "terraform.tfstate"
    }

    required_providers {
      azurerm = "5.0.1"
    }
    
    
}