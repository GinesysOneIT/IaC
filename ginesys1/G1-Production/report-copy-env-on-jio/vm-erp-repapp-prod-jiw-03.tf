variable "vm_name" {
  type    = string
  default = "vm-erp-repapp-prod-jiw-03"
}



resource "azurerm_network_interface" "app-nic-03" {
  location            = "jioindiawest"
  name                = "nic-${var.vm_name}"
  resource_group_name = "rg-report-prod-jiw"
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/c9599934-9aad-4b75-958c-3a9b48faf5d5/resourceGroups/rg-system-prod-jiw/providers/Microsoft.Network/virtualNetworks/vnet-prod-jiw-01/subnets/snet-rep-prod-jiw-01"
  }


}

resource "azurerm_virtual_machine" "vm-app-03" {
  location              = "jioindiawest"
  name                  = var.vm_name
  network_interface_ids = [azurerm_network_interface.app-nic-03.id]
  resource_group_name   = "rg-report-prod-jiw"
  tags = {
    BACode      = "None"
    Billing     = "CustomerShared"
    CreatedBy   = "AbdurRashidMondal"
    CreatedOn   = "2024-12-05"
    Division    = "None"
    Environment = "Production"
    Instance    = "${var.vm_name}"
    LifeSpan    = "Permanent"
    Owner       = "SoumyadipBhattacharya"
    Product     = "ERP-Report"
    Purpose     = "ReportService"
    SubOwner    = "None"
    Usage       = "General_(Regular)"
    User        = "CustomerGroup"
  }
  vm_size = "Standard_D4as_v5"
  boot_diagnostics {
    enabled     = true
    storage_uri = "https://storageerpreportlogging.blob.core.windows.net/"
  }
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
  storage_os_disk {
    caching         = "ReadWrite"
    create_option   = "Attach"
    managed_disk_id = azurerm_managed_disk.app-disk-03.id
    name            = "disk-os_${var.vm_name}"
    os_type         = "Windows"
  }
}
