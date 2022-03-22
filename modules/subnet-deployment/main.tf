resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.${var.prefix_count}.0/24"]
} 

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dynamic security_rule {
    for_each = {
      "Inbound" = var.inbound_ports
      "Outbound" = var.outbound_ports
    }
    content {
      name                       = security_rule.key
      priority                   = 100
      direction                  = security_rule.key
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_public_ip" "example" {
  for_each            = var.hosts
  name                = "example-PIP-${each.key}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "example" {
  for_each            = azurerm_public_ip.example
  name                = "example-nic-${each.key}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal-${each.key}"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  for_each            = azurerm_network_interface.example
  name                = "example-machine-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    each.value.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.hosts[each.key].publisher
    offer     = var.hosts[each.key].offer
    sku       = var.hosts[each.key].sku
    version   = var.hosts[each.key].version
  }
}