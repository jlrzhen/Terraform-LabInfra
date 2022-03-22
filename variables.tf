variable "resource_group_name" {
  default = "LabTFResourceGroup"
}

variable "resource_group_location" {
  default = "eastus"
}

variable "ubuntu_f2" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
    size      = "Standard_F2"
  }
}

variable "ubuntu_av2" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
    size      = "Standard_A2_v2"
  }
}