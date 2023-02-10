terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "5c212cc7-efda-4f36-aa97-66a95a4c80a7"
  features {
    
  }
  
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}