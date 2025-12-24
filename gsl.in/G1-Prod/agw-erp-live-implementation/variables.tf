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
    "vm-erp-brandstore-prod-ci" = {
      ip_address = "172.16.226.7"
      ginesys_url = "brandstore.ginesys.cloud"
    },
    "vm-erp-raisinglobal-prod-ci" = {
      ip_address = "172.16.226.75"
      ginesys_url = "raisinglobal.ginesys.cloud"
    },
    "vm-erp-befitclothing-prod-ci" = {
      ip_address = "172.16.226.6"
      ginesys_url = "befitclothing.ginesys.cloud"
    },
    "vm-erp-ridhimehra-prod-ci" = {
      ip_address = "172.16.225.86"
      ginesys_url = "ridhimehra.ginesys.cloud"
    },
    "vm-erp-texonltd-prod-ci" = {
      ip_address = "172.16.225.90"
      ginesys_url = "texonltd.ginesys.cloud"
    },
    "vm-erp-phonex-prod-ci" = {
      ip_address = "172.16.226.68"
      ginesys_url = "phonex.ginesys.cloud"
    },
    "vm-erp-gnretail-prod-ci" = {
      ip_address = "172.16.224.112"
      ginesys_url = "gnretail.ginesys.cloud"
    },
    "vm-erp-zykazfashion-prod" = {
      ip_address = "172.16.225.122"
      ginesys_url = "zykazfashion.ginesys.cloud"
    },
    "vm-erp-dmsfouraces-prod" = {
      ip_address = "172.16.225.123"
      ginesys_url = "dmsfouraces.ginesys.cloud"
    },
    "vm-erp-shrujanchanda-prod-ci" = {
      ip_address = "172.16.225.98"
      ginesys_url = "shrujanchanda.ginesys.cloud"
    },
    "vm-erp-citytrns-prod-ci" = {
      ip_address = "172.16.225.137"
      ginesys_url = "citytrends.ginesys.cloud"
    },
    "vm-erp-mithaipotlam-prod-ci" = {
      ip_address = "172.16.225.233"
      ginesys_url = "mithaipotlam.ginesys.cloud"
    },
    "vm-erp-kashishuae-prod-ci" = {
      ip_address = "172.16.225.220"
      ginesys_url = "kashishuae.ginesys.cloud"
    },
    "vm-erp-budgetshop-prod-ci" = {
      ip_address = "172.16.226.8"
      ginesys_url = "budgetshop.ginesys.cloud"
    },
    "vm-erp-kgbstores-prod-ci" = {
      ip_address = "172.16.225.221"
      ginesys_url = "kgbstores.ginesys.cloud"
    },
    "vm-erp-kapasepaithani-prod-ci" = {
      ip_address = "172.16.225.218"
      ginesys_url = "kapasepaithani.ginesys.cloud"
    },
    "vm-erp-chotteylal-prod-ci" = {
      ip_address = "172.16.225.136"
      ginesys_url = "chotteylal.ginesys.cloud"
    },
    "vm-erp-shayartex-prod-ci" = {
      ip_address = "172.16.226.91"
      ginesys_url = "shayartex.ginesys.cloud"
    },
    "vm-erp-uniseoul-prod-ci" = {
      ip_address = "172.16.226.119"
      ginesys_url = "uniseoul.ginesys.cloud"
    },
    "vm-erp-occasion-prod-ci" = {
      ip_address = "172.16.226.65"
      ginesys_url = "occasion.ginesys.cloud"
    },
    "vm-erp-ghadgeclothing-prod-ci" = {
      ip_address = "172.16.225.159"
      ginesys_url = "ghadgeclothing.ginesys.cloud"
    },
    "vm-erp-chintamanis-prod-ci" = {
      ip_address = "172.16.225.135"
      ginesys_url = "chintamanis.ginesys.cloud"
    },
    "vm-erp-varundha-prod-ci" = {
      ip_address = "172.16.225.92"
      ginesys_url = "varundha.ginesys.cloud"
    },
    "vm-erp-rithika-prod-ci" = {
      ip_address = "172.16.225.249"
      ginesys_url = "rithika.ginesys.cloud"
    },
    "vm-erp-blingroom-prod-ci" = {
      ip_address = "172.16.225.35"
      ginesys_url = "blingroom.ginesys.cloud"
    },
    "vm-erp-kkaprc-prod-ci" = {
      ip_address = "172.16.226.46"
      ginesys_url = "kkaprc.ginesys.cloud"
    },
    "vm-erp-fancymall-prod-ci" = {
      ip_address = "172.16.226.19"
      ginesys_url = "fancymall.ginesys.cloud"
    },
    "vm-erp-nmfrontieruk-prod-ci" = {
      ip_address = "172.16.226.62"
      ginesys_url = "nmfrontieruk.ginesys.cloud"
    },
    "vm-erp-ekdant-prod-ci" = {
      ip_address = "172.16.226.16"
      ginesys_url = "ekdant.ginesys.cloud"
    },
    "vm-erp-educee-prod-ci" = {
      ip_address = "172.16.226.14"
      ginesys_url = "educee.ginesys.cloud"
    },
    "vm-erp-sabkaabazar-prod-ci" = {
      ip_address = "172.16.226.82"
      ginesys_url = "sabkaabazar.ginesys.cloud"
    },
    "vm-erp-elkkaretail-prod-ci" = {
      ip_address = "172.16.226.17"
      ginesys_url = "elkkaretail.ginesys.cloud"
    },
    "vm-erp-tonirossi-prod-ci" = {
      ip_address = "172.16.226.115"
      ginesys_url = "tonirossi.ginesys.cloud"
    },
    "vm-erp-kapoor-prod-ci" = {
      ip_address = "172.16.226.42"
      ginesys_url = "kapoor.ginesys.cloud"
    },
    "vm-erp-rkclothing-prod-ci" = {
      ip_address = "172.16.225.250"
      ginesys_url = "rkclothing.ginesys.cloud"
    },
    "vm-erp-lambodara-prod-ci" = {
      ip_address = "172.16.225.227"
      ginesys_url = "lambodara.ginesys.cloud"
    },
    "vm-erp-arbaztextiles-prod-ci" = {
      ip_address = "172.16.224.163"
      ginesys_url = "arbaztextiles.ginesys.cloud"
    },
    "vm-erp-sbaazarmetro-prod-ci" = {
      ip_address = "172.16.226.88"
      ginesys_url = "sbaazarmetro.ginesys.cloud"
    },
    "vm-erp-rkfamilystore-prod-ci" = {
      ip_address = "172.16.225.251"
      ginesys_url = "rkfamilystore.ginesys.cloud"
    },
    "vm-erp-nidhidecor-prod-ci" = {
      ip_address = "172.16.226.59"
      ginesys_url = "nidhidecor.ginesys.cloud"
    },
    "vm-erp-nohmapparels-prod-ci" = {
      ip_address = "172.16.226.63"
      ginesys_url = "nohmapparels.ginesys.cloud"
    },
    "vm-erp-calcuttajun-prod-ci" = {
      ip_address = "172.16.226.9"
      ginesys_url = "calcuttajun.ginesys.cloud"
    },
    "vm-erp-arnika-prod-ci" = {
      ip_address = "172.16.226.3"
      ginesys_url = "arnika.ginesys.cloud"
    },
    "vm-erp-egloindia-prod-ci" = {
      ip_address = "172.16.226.15"
      ginesys_url = "egloindia.ginesys.cloud"
    },
    "vm-erp-sithara-prod" = {
      ip_address = "172.16.225.82"
      ginesys_url = "sithara.ginesys.cloud"
    },
    "vm-erp-sulsaho-prod" = {
      ip_address = "172.16.225.134"
      ginesys_url = "sulsaho.ginesys.cloud"
    },
    "vm-erp-kalyanbahrain-prod-ci" = {
      ip_address = "172.16.226.38"
      ginesys_url = "kalyanbahrain.ginesys.cloud"
    },
    "vm-erp-solitario-prod-ci" = {
      ip_address = "172.16.226.99"
      ginesys_url = "solitario.ginesys.cloud"
    },
    "vm-erp-pizunalinens-prod-ci" = {
      ip_address = "172.16.226.71"
      ginesys_url = "pizunalinens.ginesys.cloud"
    },
    "vm-erp-tiramisu-prod-ci" = {
      ip_address = "172.16.226.114"
      ginesys_url = "tiramisu.ginesys.cloud"
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
