module "vm-erp-teplate-test" {
  source = "../../../modules/module-deploy-new-vm"

  tags = {
    # Always changed tags
    GinesysUrl = ""
    Instance= ""
    BACode = ""
    SvcStartOn = ""
    CreatedOn = ""
    CreatedBy = ""
    
    
    # Somtiomes changed tags
    Owner = "RajarshiBasuRoy"
    SubOwner = "None"
    Division = "None"

    # Rarely changed tags
    Application = "GinesysERP"
    Billing = "CustomerDedicated"
    DeploymentType = "Live"
    Environment = "Production" 
    LifeSpan = "Permanent"
    Product = "ERP"
    Purpose = "GinesysHosting"
    Usage = "General_(Regular)"
    User = "Customer"

  }
  
  # always change variables
  https_iis_hostname   = "test.ginesys.com"
  system_name         = "TEMPLATE"
  vm_name        = "vm-erp-teplate-test"


  # sometimes changed variables
  vm_size               = "Standard_D2as_v5"
  resource_group_name   = "rg-erp-prod-ci"


  # already set in variables.tf with default values changes if required
  #subnet_id             = "/subscriptions/4f070ccd-0168-41ab-a9a4-c13e2dd2626c/resourceGroups/rg-system-prod-ci/providers/Microsoft.Network/virtualNetworks/vnet-prod-ci-01/subnets/snet-erp-prod-01"
  #reference_os_disk_id = "/subscriptions/4f070ccd-0168-41ab-a9a4-c13e2dd2626c/resourceGroups/rg-erp-control-ci/providers/Microsoft.Compute/disks/disk-os_vm-ginapp-template-sml-01"


  # rarely changed variables
  location              = "centralindia"

  }




