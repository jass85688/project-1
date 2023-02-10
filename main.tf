# creating new user1
resource "azuread_user" "az_user_1" {
  display_name        = "Jaspal Singh"
  user_principal_name = "Jaspal@hashicorp"
}

# creating new user2
resource "azuread_user" "az_user_2" {
  display_name        = "Ibrahim Ozbekler"
  user_principal_name = "Ibrahim@hashicorp"
  force_password_change = true
}

# creating new users for aws
resource "aws_iam_user" "aws_users" {
  for_each = toset(var.aws_usernames)
  name     = each.value
}

# creating a bucket 
resource "aws_s3_bucket" "s3_buckets" {
  count         = length(var.s3_bucket_names)
  bucket        = var.s3_bucket_names[count.index]
  acl           = "private"
  region        = "us-east-1"
  force_destroy = true

  tags = {
    name = "S3 bucket"
    environment = "staging"
  }
}

# creating a resource group
resource "azurerm_resource_group" "project_res_gp" {
  name     = "project_res_gp"
  location = "West Europe"
}

# creating new virtual machine
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.project_res_gp.location
  resource_group_name = azurerm_resource_group.project_res_gp.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.project_res_gp.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.project_res_gp.location
  resource_group_name = azurerm_resource_group.project_res_gp.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.project_res_gp.location
  resource_group_name   = azurerm_resource_group.project_res_gp.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

# creating storage account on azure
resource "azurerm_storage_account" "storage_acc" {
  name                     = var.storage_acc_name
  resource_group_name      = azurerm_resource_group.project_res_gp.name
  location                 = azurerm_resource_group.project_res_gp.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    name = "Storage account"
    environment = "staging"
  }
}
