
resource "azurerm_managed_disk" "state-disk-01" {
  create_option                     = "Import"
  hyper_v_generation                = "V2"
  image_reference_id                = ""
  location                          = "jioindiawest"
  name                              = "disk-os_vm-erp-repstate-prod-jiw-01"
  network_access_policy             = "AllowAll"
  on_demand_bursting_enabled        = false
  optimized_frequent_attach_enabled = false
  os_type                           = "Windows"
  performance_plus_enabled          = false
  public_network_access_enabled     = true
  resource_group_name               = "rg-report-prod-jiw"
  source_uri                        = "https://storageerpreportlogging.blob.core.windows.net/transfer/tmp_snap_disk-os_vm-erp-repstate-prod-01.vhd"
  storage_account_id                = "/subscriptions/c9599934-9aad-4b75-958c-3a9b48faf5d5/resourceGroups/rg-report-prod-jiw/providers/Microsoft.Storage/storageAccounts/storageerpreportlogging"
  storage_account_type              = "Premium_LRS"
  tags = {
    CreatedBy = "AbdurRashidMondal"
    CreatedOn = "2024-12-04"
  }
  tier                   = "P10"
  trusted_launch_enabled = false
}
