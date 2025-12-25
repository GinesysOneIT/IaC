variable "vm_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "reference_os_disk_id" {
  description = "Source OS disk ID"
  type        = string
  default     = "/subscriptions/4f070ccd-0168-41ab-a9a4-c13e2dd2626c/resourceGroups/rg-erp-control-ci/providers/Microsoft.Compute/disks/disk-os_vm-ginapp-template-sml-01"
}

variable "vm_size" {
  type = string
}

variable "subnet_id" {
  type = string
  default = "/subscriptions/4f070ccd-0168-41ab-a9a4-c13e2dd2626c/resourceGroups/rg-system-prod-ci/providers/Microsoft.Network/virtualNetworks/vnet-prod-ci-01/subnets/snet-erp-prod-01"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "https_iis_hostname" {
  type    = string
}

variable "system_name" {
  type    = string
}