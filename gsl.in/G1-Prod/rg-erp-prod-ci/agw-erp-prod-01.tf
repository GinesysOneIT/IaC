# Applcation Gateway info like name , snet id etc
variable application_gateway_info {
  type = object({
    name        : string
    subnet_id   : string
    resource_group_name : string
  })
  default = {
    name      = "agw-erp-prod-01"
    resource_group_name = "rg-erp-prod-ci"
    subnet_id = "/subscriptions/4f070ccd-0168-41ab-a9a4-c13e2dd2626c/resourceGroups/rg-system-prod-ci/providers/Microsoft.Network/virtualNetworks/vnet-prod-ci-01/subnets/AzureAppGatewaySubnet"
  }
  description = "Applcation Gateway info like name , snet id etc"
}

# map of vm name and their private IPs and application configured dns to be added to backend address pool
variable application_backend {
  type = map(object({
    ip_address = string
    fqdn       = string
  }))
  default = {
    "erp-ideal-prod" = {
      ip_address = "10.10.10.10"
      fqdn       = "erp-ideal-prod.ginesys.cloud"
    }
  }
  description = "map of vm name and their private IPs and application configured dns to be added to backend address pool"
}


variable tags {
  type = map(string)
  default = {
    BACode      = "None"
    Billing     = "Internal"
    CreatedBy   = "ArindamBanerjee"
    CreatedOn   = "2025-12-02"
    Division    = "TechTeam" 
    Environment = "DevStage"
    LifeSpan    = "Permanent" 

    Owner       = "RajarshiBasuRoy"
    Product     = "ERP"
    Purpose     = "Connectivity"
    Usage       = "Platform"  
    ValidTill   = "None"
  }
  description = "Tags to be applied to resources"
}





data "azurerm_resource_group" "resource_group_for_all_components" {
  name = var.application_gateway_info.resource_group_name
}

resource "azurerm_public_ip" "public_ip_for_this_applicationgateway" {
  name                = "pip_${var.application_gateway_info.name}"
  location            = data.azurerm_resource_group.resource_group_for_all_components.location
  resource_group_name = data.azurerm_resource_group.resource_group_for_all_components.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
  tags = var.tags
}


resource "azurerm_application_gateway" "agw-erp-prod-01" {
  enable_http2                      = true
  fips_enabled                      = false
  force_firewall_policy_association = false
  location                          = data.azurerm_resource_group.resource_group_for_all_components.location
  name                              = var.application_gateway_info.name
  resource_group_name               = data.azurerm_resource_group.resource_group_for_all_components.name
  tags = var.tags


  dynamic "backend_address_pool" {
    for_each = var.application_backend

    content {
      name         = "backpool_${backend_address_pool.key}"
      ip_addresses = backend_address_pool.value.ip_address != "" ? [backend_address_pool.value.ip_address] : []
      fqdns        = []
    }
  }


  backend_http_settings {
    cookie_based_affinity               = "Disabled"
    name                                = "setting_http"
    pick_host_name_from_backend_address = false
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    
    name                                = "setting_erp-ideal-stage_https"
    pick_host_name_from_backend_address = false
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    name                                = "setting_erp-report-stage_https"
    pick_host_name_from_backend_address = false
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }

  frontend_ip_configuration {
    name                            = "frontend_public_ip_configuration"
    private_ip_address_allocation   = "Dynamic"
    public_ip_address_id            = azurerm_public_ip.public_ip_for_this_applicationgateway.id
  }

  frontend_port {
    name = "port_443"
    port = 443
  }
  frontend_port {
    name = "port_80"
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.application_gateway_info.subnet_id
  }
  global {
    request_buffering_enabled  = true
    response_buffering_enabled = false
  }

 

  dynamic "http_listener" {
    for_each = var.application_backend

    content {
      name                           = "listener_${http_listener.key}_https"
      frontend_ip_configuration_name = "frontend_public_ip_configuration"
      frontend_port_name             = "port_443"
      host_name                      = http_listener.value.fqdn
      protocol                       = "Https"
      require_sni                    = true
      ssl_certificate_name           = "ssl-cert-wildcard-ginesys-cloud"
    }
  }

  
  identity {
    identity_ids = ["/subscriptions/93f3f03d-d297-4d9f-b5cb-258adeaf5a38/resourceGroups/rg-system-stage/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mngid_erp_systems_stage"]
    type         = "UserAssigned"
  }

  dynamic "request_routing_rule" {
    for_each = var.application_backend

    content {
      name                       = "rule_${request_routing_rule.key}_https"
      rule_type                  = "Basic"
      http_listener_name         = "listener_${request_routing_rule.key}_https"
      backend_address_pool_name  = "backpool_${request_routing_rule.key}"
      backend_http_settings_name = "setting_http"
      priority                   = 100 + index(keys(var.application_backend), request_routing_rule.key)
    }
  }


  sku {
    capacity = 1
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }
  ssl_certificate {

    key_vault_secret_id = "https://keyvaulterpstage01.vault.azure.net:443/secrets/ssl-cert-wildcard-ginesys-cloud/"
    name                = "ssl-cert-wildcard-ginesys-cloud"

  }
}
