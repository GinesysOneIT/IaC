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
    "vm-erp-rmbayepl-prod-ci" = {
      ip_address = "172.16.226.80"
      ginesys_url       = "nunk.ginesys.cloud"
    },
    "vm-erp-fashor-prod-ci" = {
      ip_address = "172.16.226.20"
      ginesys_url       = "fashor.ginesys.cloud"
    },
  }
  description = "map of vm name and their private IPs and application configured dns to be added to backend address pool"
}


variable tags {
  type = map(string)
  default = {
    BACode      = "None"
    Billing     = "Internal"
    CreatedBy   = "Terraform"
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
