terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c9599934-9aad-4b75-958c-3a9b48faf5d5" # Replace with your Azure Subscription ID
}
