terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 4.0"
        }
    }

    backend "azurerm" {
        # resource_group_name  = "achinta-dev"
        # storage_account_name = "terrastorage1"
        # container_name       = "terra-remote"
        # key                  = "dev.tfstate"
    }
}

provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
    
}


