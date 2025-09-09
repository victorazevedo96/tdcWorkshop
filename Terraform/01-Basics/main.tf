# Configuração dos providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Conectar ao Azure
# Para selecionar a subscription, configurar variavel de ambiente ARM_SUBSCRIPTION_ID
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "basic-resource-group"
  location = "eastus"

  tags = {
    environment = "Workshop"
  }
}
