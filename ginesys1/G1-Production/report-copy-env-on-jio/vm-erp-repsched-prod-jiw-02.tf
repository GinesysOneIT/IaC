variable "vm_name_sched_02" {
  type    = string
  default = "vm-erp-repsched-prod-jiw-02"
}



resource "azurerm_network_interface" "sched-nic-02" {
  location            = "jioindiawest"
  name                = "nic-${var.vm_name_sched_02}"
  resource_group_name = "rg-report-prod-jiw"
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/c9599934-9aad-4b75-958c-3a9b48faf5d5/resourceGroups/rg-system-prod-jiw/providers/Microsoft.Network/virtualNetworks/vnet-prod-jiw-01/subnets/snet-rep-prod-jiw-01"
  }


}

resource "azurerm_virtual_machine" "vm-sched-02" {
  location              = "jioindiawest"
  name                  = var.vm_name_sched_02
  network_interface_ids = [azurerm_network_interface.sched-nic-02.id]
  resource_group_name   = "rg-report-prod-jiw"
  os_profile {
    computer_name  = "rep-sched-02"
    admin_username = "cloudadmin"
    admin_password = "A@s$ecur!T33"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  tags = {
    BACode      = "None"
    Billing     = "CustomerShared"
    CreatedBy   = "AbdurRashidMondal"
    CreatedOn   = "2024-12-05"
    Division    = "None"
    Environment = "Production"
    Instance    = "${var.vm_name_sched_02}"
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
    caching       = "ReadWrite"
    create_option = "FromImage"
    name          = "disk-os-${var.vm_name_sched_02}"
    disk_size_gb  = 128
    os_type       = "Windows"


  }

  storage_image_reference {

    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
