resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = var.location
}

module "network" {
  source = "../04-Modules/modules/network"
  project    = var.project
  location   = var.location
  environment = var.environment
  rg_name = azurerm_resource_group.main.name
  address_space = var.address_space
}

resource "azurerm_network_security_rule" "allow_8080" {
  resource_group_name = azurerm_resource_group.main.name
  name                = "allow-8080"
  priority            = 1000
  direction           = "Inbound"
  access              = "Allow"
  protocol            = "Tcp"
  source_port_range   = "*"
  destination_port_range = "8080"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  network_security_group_name = module.network.network_security_group_name
}

resource "azurerm_public_ip" "this" {
  name                = "${local.prefix}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku = "Standard"

  domain_name_label   = var.domain_name_label
  tags                = local.common_tags
}

resource "azurerm_network_interface" "this" {
  name                = "${local.prefix}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = local.common_tags 
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "${local.prefix}-uai"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  tags                = local.common_tags
}

data "azurerm_container_registry" "this" {
  resource_group_name = var.acr_rg_name
  name                = var.acr_name
}


resource "azurerm_role_assignment" "name" {
  principal_id   = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = "AcrPull"
  scope          = data.azurerm_container_registry.this.id
}


resource "azurerm_linux_virtual_machine" "main" {
  name                = "${local.prefix}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.tpl", {}))

  depends_on = [ azurerm_role_assignment.name ]
}

locals {
  script = <<-EOT
    #!/bin/bash
    set -e
    
    # Wait for cloud-init to complete
    /usr/bin/cloud-init status --wait
    
    # Wait for docker service to be ready
    while ! systemctl is-active --quiet docker; do
      sleep 5
    done
    
    # Add user to docker group if not already done
    sudo usermod -aG docker ${var.admin_username}
    
    # Login to Azure
    az login --identity
    
    # Login to ACR
    az acr login --name ${data.azurerm_container_registry.this.name}
    
    # Run container
    sudo docker pull ${data.azurerm_container_registry.this.name}.azurecr.io/workshop-app:latest
    sudo docker run -d -p 8080:8080 --name workshop-app --restart unless-stopped ${data.azurerm_container_registry.this.name}.azurecr.io/workshop-app:latest
  EOT
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_linux_virtual_machine.main]

  create_duration = "120s"
}

resource "azurerm_virtual_machine_extension" "example" {
  name                 = "custom-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = jsonencode({
    #"commandToExecute" : "sh ${local.script}"
    "script": base64encode(local.script)
  })
  depends_on = [ time_sleep.wait_30_seconds ]
}

output "url" {
  value = "http://${azurerm_public_ip.this.domain_name_label}.${azurerm_public_ip.this.location}.cloudapp.azure.com:8080"
}