module "RG" {
  source              = "../../RG"
  resource_group_name = "humaraRG"
  location            = "westus"
  
}

module "VNET" {
  source              = "../../VNET"
  vnet_name           = "humaraVNET"
  vnet_address_space  = "10.0.0.0/16"
  location            = "westus"
  resource_group_name = "humaraRG"
  depends_on = [ module.RG ]
}

module "SUBNET" {
  source                = "../../SUBNET"
  subnet_name           = "humaraSUBNET"
  subnet_address_prefix = "10.0.1.0/24"
  vnet_name             = "humaraVNET"
  resource_group_name   = "humaraRG"
  depends_on = [ module.VNET ]
}

module "BASTION_SUBNET" {
    source                = "../../SUBNET"
    subnet_name           = "AzureBastionSubnet"
    subnet_address_prefix = "10.0.2.0/27"
    vnet_name             = "humaraVNET"
    resource_group_name   = "humaraRG"
    depends_on = [ module.VNET ]
}

module "NSG" {
  source              = "../../NSG"
  nsg_name            = "humaraNSG"
  location            = "westus"
  resource_group_name = "humaraRG"
  depends_on = [ module.RG ]
}

module "NSG_SUBNET_MAP" {
  source = "../../NSG_SUBNET_MAP"
  subnet_id = data.azurerm_subnet.data-subnet.id
  nsg_id    = data.azurerm_network_security_group.data-nsg.id
  depends_on = [ module.NSG, module.SUBNET ]
}

module "BASTION_PIP" {
    source              = "../../PIP"
    pip_name            = "humaraBASTIONPIP"
    location            = "westus"
    resource_group_name = "humaraRG"
    depends_on = [ module.RG ]
}

module "BASTION_HOST" {
    source              = "../../BASTION_HOST"
    bastion_name        = "humaraBASTION"
    location            = "westus"
    resource_group_name = "humaraRG"
    bastion_subnet_id   = data.azurerm_subnet.data-subnet-bastion.id
    bastion_pip_id      = data.azurerm_public_ip.data-pip-bastion.id
    depends_on = [ module.BASTION_SUBNET, module.BASTION_PIP ]
}

module "LB_PIP" {
  source              = "../../PIP"
  pip_name            = "humaraLBPIP"
  location            = "westus"
  resource_group_name = "humaraRG"
  depends_on = [ module.RG ]
  
}

module "LB" {
  source              = "../../LB"
  lb_name             = "humaraLB"
  location            = "westus"
  resource_group_name = "humaraRG"
  pip_id              = data.azurerm_public_ip.data-pip-lb.id
  depends_on = [ module.LB_PIP, module.RG, module.BASTION_HOST ]
}


module "VM1" {
  source              = "../../VM"
  vm_name             = "humaraVM1"
  nic_name            = "humaraNIC1"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  location            = "westus"
  resource_group_name = "humaraRG"
  subnet_id           = data.azurerm_subnet.data-subnet.id
  depends_on = [ module.SUBNET, module.NSG_SUBNET_MAP ]
}

module "VM2" {
  source              = "../../VM"
  vm_name             = "humaraVM2"
  nic_name            = "humaraNIC2"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  location            = "westus"
  resource_group_name = "humaraRG"
  subnet_id           = data.azurerm_subnet.data-subnet.id
  depends_on = [ module.SUBNET, module.NSG_SUBNET_MAP ]
}


# module "SQL" {
#   source              = "../../SQL"
#   sql_server_name     = "humarasqlerver"
#   sql_database_name   = "humaradatabase"
#   sql_admin_username  = data.azurerm_key_vault_secret.username.value
#   sql_admin_password  = data.azurerm_key_vault_secret.password.value
#   location            = "westus"
#   resource_group_name = "humaraRG"
#   depends_on = [ module.RG ]
# }

module "KEY_VAULT" {
    source              = "../../KV"
    key_vault_name     = "humaraKeyVault1234"
    location            = "westus"
    resource_group_name = "humaraRG"
    depends_on = [ module.RG ]
}