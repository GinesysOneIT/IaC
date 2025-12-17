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
  subscription_id = "4f070ccd-0168-41ab-a9a4-c13e2dd2626c" # Replace with your Azure Subscription ID
}
