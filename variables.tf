variable "resource_group_name" {
  default = "LabTFResourceGroup"
}

variable "resource_group_location" {
  default = "eastus"
}

variable "ubuntu" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}