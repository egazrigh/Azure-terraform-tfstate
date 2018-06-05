# Azure-terraform-tfstate
This terraform create a resource group and storage account on Azure to store .tfstate files from various projects
The storage account name is randomized.

# Usage
Configure another terraform project with this backend and the output of this file

```
 terraform {
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = "YOURPROJECTNAME.terraform.tfstate" 
  }
 }
```
