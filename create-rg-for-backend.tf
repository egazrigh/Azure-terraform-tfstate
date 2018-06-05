variable "location" {
  description = "Azure region name"
  default     = "westeurope"
}

provider "azurerm" {}

resource "random_integer" "be" {
  min = 1000
  max = 99999
}

resource "azurerm_resource_group" "terraform-backend-azure" {
  name     = "rg-for-shared-tfstates"
  location = "${var.location}"
}

resource "azurerm_storage_account" "terraform-backend-storage" {
  name                      = "terratfstateseric${random_integer.be.result}"
  resource_group_name       = "${azurerm_resource_group.terraform-backend-azure.name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_blob_encryption    = true
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "terraform-backendcontainer" {
  name                  = "tfstates"
  resource_group_name   = "${azurerm_resource_group.terraform-backend-azure.name}"
  storage_account_name  = "${azurerm_storage_account.terraform-backend-storage.name}"
  container_access_type = "private"

  #waiting for Storage Soft Delete Support #1070
}

output "resource_group_name" {
  description = "Resource group value to use to configure backends"
  value       = "${azurerm_resource_group.terraform-backend-azure.name}"
}

output "storageaccount-for-tfstates" {
  description = "Storage account value to use to configure backends"
  value       = "${azurerm_storage_account.terraform-backend-storage.name}"
}

output "container-for-tfstates" {
  description = "Container value to use to configure backends"
  value       = "${azurerm_storage_container.terraform-backendcontainer.name}"
}

/*
## USAGE
terraform {
  backend "azurerm" {
    storage_account_name = "terratfstateseric51537"
    container_name       = "tfstates"
    key                  = "createbackendstorage.terraform.tfstate"
  }
}
*/

