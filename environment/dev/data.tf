data "azurerm_subnet" "data-subnet" {
  name                 = "humaraSUBNET"
  virtual_network_name = "humaraVNET"
  resource_group_name  = "humaraRG"
  depends_on = [ module.SUBNET ]
}

data "azurerm_subnet" "data-subnet-bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = "humaraVNET"
  resource_group_name  = "humaraRG"
  depends_on = [ module.BASTION_SUBNET ]
}


data "azurerm_public_ip" "data-pip-bastion" {
  name                = "humaraBASTIONPIP"
  resource_group_name = "humaraRG"
    depends_on = [ module.BASTION_PIP ]
}

data "azurerm_public_ip" "data-pip-lb" {
  name                = "humaraLBPIP"
  resource_group_name = "humaraRG"
    depends_on = [ module.LB_PIP ]
}

data "azurerm_network_security_group" "data-nsg" {
  name                = "humaraNSG"
  resource_group_name = "humaraRG"
    depends_on = [ module.NSG ]
}

#KeyVault Details
data "azurerm_key_vault" "data-kv" {
  name                = "tijori"
  resource_group_name = "bappa-remotestate-rg"
}

data "azurerm_key_vault_secret" "username" {
  name         = "username"
  key_vault_id = data.azurerm_key_vault.data-kv.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "password"
  key_vault_id = data.azurerm_key_vault.data-kv.id
}
