# VM Deployment Module (`module-deploy-new-vm`)

## Overview

This Terraform module automates the provisioning of virtual machines for new **Ginesys** client deployments. It handles resource creation, tagging, and prepares the VM for application-level configuration.

---

## Prerequisites

Before using this module, ensure the following requirements are met:

* **Source Template:** The source VM template must contain the latest `Setup.ps1` script at `C:\CloudAdmin\Setup.ps1`. This script is triggered during provisioning to configure the environment.
* **Local CLI Tool:** Ensure `gincloud` CLI (**v1.7.4 or later**) is installed on the machine running Terraform. This tool is required for automated DNS record management.

---

## Usage

```hcl
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
  https_iis_hostname   = "testtemplate.ginesys.cloud"
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






```

---

## Inputs

| Name | Description | Type | Required | Default |
| --- | --- | --- | --- | --- |
| `vm_name` | The name of the virtual machine resource in Azure. | `string` | **Yes** | - |
| `system_name` | The internal OS hostname (often matches the Tenant Code). | `string` | **Yes** | - |
| `https_iis_hostname` | The FQDN used for IIS bindings and application access. | `string` | **Yes** | - |
| `resource_group_name` | The name of the Azure Resource Group. | `string` | **Yes** | - |
| `location` | Azure region where resources will be deployed. | `string` | No | `"centralindia"` |
| `vm_size` | The SKU/Size of the virtual machine. | `string` | No | `"Standard_D2as_v5"` |
| `tags` | A map of tags to apply to all created resources. | `map(string)` | No | `{}` |
| `subnet_id` | The full resource ID of the target subnet. | `string` | No | *See variables.tf* |
| `reference_os_disk_id` | Resource ID of the managed disk used as a template. | `string` | No | *See variables.tf* |

---

## Outputs

| Name | Description |
| --- | --- |
| `vm_id` | The unique Azure Resource ID of the virtual machine. |
| `public_ip` | The public IP address assigned to the VM (if applicable). |
| `private_ip` | The private IP address within the VNET. |

---

## Requirements

| Requirement | Version |
| --- | --- |
| **Terraform** | `>= 1.0.0` |
| **AzureRM Provider** | `>= 4.0.0` |
| **gincloud CLI** | `>= 1.7.4` |

---

## License

© 2025 **Ginesys Systems Limited**. All rights reserved.