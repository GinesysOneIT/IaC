data "azurerm_resource_group" "rg-system-prod-jiw" {
  name = "rg-system-prod-jiw"
}

data "azurerm_virtual_network" "vnet-prod-jiw-01" {
  name                = "vnet-prod-jiw-01"
  resource_group_name = data.azurerm_resource_group.rg-system-prod-jiw.name
}

data "azurerm_subnet" "AzureAppGatewaySubnet" {
  name                 = "snet-erp-appgate-prod-01"
  resource_group_name  = data.azurerm_resource_group.rg-system-prod-jiw.name
  virtual_network_name = data.azurerm_virtual_network.vnet-prod-jiw-01.name
}

resource "azurerm_public_ip" "pip_appgate-prod-01" {
  name                = "pip_appgate-prod-01"
  resource_group_name = data.azurerm_resource_group.rg-system-prod-jiw.name
  location            = data.azurerm_resource_group.rg-system-prod-jiw.location
  allocation_method   = "Static"
}

# since these variables are re-used - a locals block makes this more maintainable


resource "azurerm_application_gateway" "app-gateway" {
  name                = "agw-report-prod-01"
  resource_group_name = data.azurerm_resource_group.rg-system-prod-jiw.name
  location            = data.azurerm_resource_group.rg-system-prod-jiw.location
  tags = {
    BACode               = "None"
    Billing              = "CustomerShared"
    CreatedBy            = "RajarshiBasuRoy"
    CreatedOn            = "2024-05-28"
    Division             = "None"
    Environment          = "Production"
    LifeSpan             = "Permanent"
    Owner                = "SoumyadipBhattacharya"
    Product              = "ERP-Report"
    Purpose              = "ReportService"
    SubOwner             = "NabenduRoyChowdhury"
    Usage                = "General_(Regular)"
    is_resourceId_common = "True"
  }
  zones = ["1"]
  autoscale_configuration {
    max_capacity = 3
    min_capacity = 2
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = []
    name         = "agw-repbackpool-private-prod-02"
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = []
    name         = "agw-repbackpool-private-prod-04"
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = []
    name         = "agw-repbackpool-public-prod-01"
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = []
    name         = "agw-repbackpool-public-prod-02"
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = []
    name         = "agw-repbackpool-public-prod-03"
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Disabled"

    name = "agw-reportbackend-setting-private-03"

    pick_host_name_from_backend_address = false
    port                                = 80

    protocol                       = "Http"
    request_timeout                = 10
    trusted_root_certificate_names = []
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Enabled"

    name = "agw-reportbackend-setting-private-01"

    pick_host_name_from_backend_address = false
    port                                = 80
    probe_name                          = "repapi-health-probe-01"
    protocol                            = "Http"
    request_timeout                     = 3000
    trusted_root_certificate_names      = []
  }
  backend_http_settings {
    affinity_cookie_name  = "ApplicationGatewayAffinity"
    cookie_based_affinity = "Enabled"

    name = "agw-reportbackend-setting-private-02"

    pick_host_name_from_backend_address = false
    port                                = 81

    protocol                       = "Http"
    request_timeout                = 3000
    trusted_root_certificate_names = []
  }

  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIpIPv4"
    public_ip_address_id = azurerm_public_ip.pip_appgate-prod-01.id
  }
  frontend_ip_configuration {
    name                          = "appGwPrivateFrontendIpIPv4"
    private_ip_address            = "172.24.0.1"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.azurerm_subnet.AzureAppGatewaySubnet.id
  }

  frontend_port {
    name = "port_43310"
    port = 43310
  }
  frontend_port {
    name = "port_43311"
    port = 43311
  }
  frontend_port {
    name = "port_443"
    port = 443
  }
  frontend_port {
    name = "port_80"
    port = 80
  }
  frontend_port {
    name = "port_81"
    port = 81
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = data.azurerm_subnet.AzureAppGatewaySubnet.id
  }
  http_listener {

    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_43310"

    host_names  = []
    name        = "agw-reportlistener-private-03"
    protocol    = "Http"
    require_sni = false


    custom_error_configuration {
      custom_error_page_url = "https://storageaccounterpreport.z29.web.core.windows.net/maintenance.html"
      status_code           = "HttpStatus502"
    }
  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_43310"
    host_name                      = "erpreports.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-otherreport-https-03"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

    custom_error_configuration {
      custom_error_page_url = "https://storageaccounterpreport.z29.web.core.windows.net/maintenance.html"
      status_code           = "HttpStatus502"
    }
  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = "erpreports.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-otherreport"
    protocol                       = "Http"
    require_sni                    = false


    custom_error_configuration {
      custom_error_page_url = "https://storageaccounterpreport.z29.web.core.windows.net/maintenance.html"
      status_code           = "HttpStatus502"
    }
  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_81"
    host_name                      = "erpreports.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-otherreport-https-02"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

    custom_error_configuration {
      custom_error_page_url = "https://storageaccounterpreport.z29.web.core.windows.net/maintenance.html"
      status_code           = "HttpStatus502"
    }
  }
  http_listener {

    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_43311"

    host_names  = []
    name        = "agw-reportlistener-private-43311"
    protocol    = "Http"
    require_sni = false


  }
  http_listener {

    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_80"

    host_names  = []
    name        = "agw-reportlistener-private-01"
    protocol    = "Http"
    require_sni = false


  }
  http_listener {

    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_81"

    host_names  = []
    name        = "agw-reportlistener-private-02"
    protocol    = "Http"
    require_sni = false


  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_43311"
    host_name                      = "erpreportsapi.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-docreport-https-43311"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = "erpreports.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-otherreport-https"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = "erpreports02.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-otherreport-02-https"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = "erpreportsapi.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-docreport-https"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = "erpreportsapi.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-docreport"
    protocol                       = "Http"
    require_sni                    = false


  }
  http_listener {

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_81"
    host_name                      = "erpreportsapi.ginesys.cloud"
    host_names                     = []
    name                           = "agw-reportlistener-public-docreport-https-02"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "SSL_cert_wildcard_ginesys.cloud"

  }
  probe {
    host                                      = "172.16.192.4"
    interval                                  = 30
    minimum_servers                           = 0
    name                                      = "repapi-health-probe-01"
    path                                      = "/ReportAPI/api.asmx/InitializeApi"
    pick_host_name_from_backend_http_settings = false
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    match {
      body        = ""
      status_code = ["200-399"]
    }
  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-02"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-private-01"
    name                       = "agw-reportroute-private-01"
    priority                   = 2


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-02"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-public-docreport-https"
    name                       = "agw-reportroute-public-docreport"
    priority                   = 3


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-02"
    backend_http_settings_name = "agw-reportbackend-setting-private-02"
    http_listener_name         = "agw-reportlistener-private-02"
    name                       = "agw-reportroute-private-02"
    priority                   = 8


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-02"
    backend_http_settings_name = "agw-reportbackend-setting-private-02"
    http_listener_name         = "agw-reportlistener-public-docreport-https-02"
    name                       = "agw-reportroute-public-docreport-02"
    priority                   = 7


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-04"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-private-43311"
    name                       = "agw-reportroute-private-43311-80"
    priority                   = 12


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-private-prod-04"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-public-docreport-https-43311"
    name                       = "agw-reportroute-public-docreport-43311-80"
    priority                   = 11


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-public-prod-01"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-public-otherreport-https"
    name                       = "agw-reportroute-public-otherreport"
    priority                   = 4


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-public-prod-01"
    backend_http_settings_name = "agw-reportbackend-setting-private-02"
    http_listener_name         = "agw-reportlistener-public-otherreport-https-02"
    name                       = "agw-reportroute-public-otherreport-03"
    priority                   = 6


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-public-prod-02"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-public-otherreport-02-https"
    name                       = "agw-reportroute-public-otherreport-02"
    priority                   = 5


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-public-prod-03"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-private-03"
    name                       = "agw-reportroute-private-03"
    priority                   = 10


    rule_type = "Basic"

  }
  request_routing_rule {
    backend_address_pool_name  = "agw-repbackpool-public-prod-03"
    backend_http_settings_name = "agw-reportbackend-setting-private-01"
    http_listener_name         = "agw-reportlistener-public-otherreport-https-03"
    name                       = "agw-reportroute-public-otherreport-04"
    priority                   = 9


    rule_type = "Basic"

  }
  sku {
    capacity = 0
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }
  ssl_certificate {

    name = "SSL_cert_wildcard_ginesys.cloud"

  }


}
