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
  subscription_id = "93f3f03d-d297-4d9f-b5cb-258adeaf5a38" # Replace with your Azure Subscription ID
}
