provider "azurerm" {
  features { 
  }
  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "code-vnet" {
  name = "codex-vnet"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "code-subnet" {
  name = "codex-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.code-vnet.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "code-public-ip" {
  name = "codex-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = "codexdev"
}

resource "azurerm_network_interface" "code-nic" {
  name = "codex-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 ip_configuration {
   name = "codex-ipconfig"
   private_ip_address_allocation = "Dynamic"
   subnet_id = azurerm_subnet.code-subnet.id
   public_ip_address_id = azurerm_public_ip.code-public-ip.id
 }

}

# resource "azurerm_network_security_group" "code-nsg" {
#   name = "devxserver-nsg"
#   resource_group_name = "Coderserver-RG"
#   location = "Central India"
# }
resource "azurerm_network_security_group" "code-nsg" {
  name = "codex-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 330
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-8080PORT"
    priority                   = 350
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "code-nsg-nic" {
 network_interface_id = azurerm_network_interface.code-nic.id 
 network_security_group_id = azurerm_network_security_group.code-nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "codexdev-server"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [ 
    azurerm_network_interface.code-nic.id
   ]
 disable_password_authentication = false
 admin_username = "deepanshu"
 admin_password = "deepanshu@123"
 size = "Standard_D2as_v5"
 zone = 2
  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }

  source_image_id = var.source_image_url
}





output "public_ip" {
  value = azurerm_public_ip.code-public-ip.ip_address
}

output "dns_name" {
  value = azurerm_public_ip.code-public-ip.fqdn
}