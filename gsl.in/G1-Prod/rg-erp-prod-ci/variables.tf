# Applcation Gateway info like name , snet id etc
variable application_gateway_info {
  type = object({
    name        = string
    subnet_id   = string
    resource_group_name = string
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
    ginesys_url       = string
  }))
  default = {
    "vm-erp-intrend-prod-ci" = {
      ip_address = "172.16.226.138"
      ginesys_url       = "intrend.ginesys.cloud"
    },
    "vm-erp-cityhubretails-prod-ci" = {
      ip_address = "172.16.224.101"
      ginesys_url       = "cityhubretails.ginesys.cloud"
    },
    "vm-erp-radheshyamstore-prod-ci" = {
      ip_address = "172.16.226.139"
      ginesys_url       = "radheshyamstore.ginesys.cloud"
    },
    "vm-erp-a1bazaar-prod-ci" = {
      ip_address = "172.16.224.102"
      ginesys_url       = "a1bazaar.ginesys.cloud"
    },
    "vm-erp-thesajelife-prod-ci" = {
      ip_address = "172.16.224.100"
      ginesys_url       = "thesajelife.ginesys.cloud"
    },
    
  }
  description = "map of vm name and their private IPs and application configured dns to be added to backend address pool"
}


variable tags {
  type = map(string)
  default = {
    BACode      = "None"
    Billing     = "CustomerShared"
    CreatedBy   = "AbdurRashidMondal"
    IaC = "Terraform"
    CreatedOn   = "2025-12-18"
    Division    = "None" 
    Environment = "Production"
    LifeSpan    = "Permanent" 
    Owner       = "RajarshiBasuRoy"
    Product     = "ERP"
    Purpose     = "Connectivity"
    Usage       = "Platform"  
    ValidTill   = "None"
  }
  description = "Tags to be applied to resources"
}
