resource "azurerm_managed_disk" "os_disk_copy" {

  name                = "disk_os_${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = "Premium_LRS"
  create_option        = "Copy"
  source_resource_id   = var.reference_os_disk_id
  tags                = var.tags

  # Add these two lines to match the actual state in Azure
  hyper_v_generation   = "V2"
  os_type              = "Windows"

  # ADD THIS BLOCK
  lifecycle {
    ignore_changes = [
      create_option,
      source_resource_id,
    ]
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "pip_${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags

  domain_name_label = "${var.vm_name}"
  
}

resource "azurerm_network_interface" "nic" {
  name                = "nic_${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}





resource "azurerm_virtual_machine" "vm" {

  name                = "${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size
  tags                = var.tags

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  delete_os_disk_on_termination = false

  storage_os_disk {
    name            = azurerm_managed_disk.os_disk_copy.name
    managed_disk_id = azurerm_managed_disk.os_disk_copy.id
    create_option   = "Attach"
    os_type         = "Windows"
  }


  os_profile_windows_config {
        provision_vm_agent       = true
    }
}




output "vm_ids" {
  value = azurerm_virtual_machine.vm[*].id
}

resource "azurerm_virtual_machine_extension" "run_ps" {
  name                 = "run-post-config"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

   settings = <<SETTINGS
 {
  "commandToExecute": "powershell -ExecutionPolicy Bypass -File C:\\CloudAdmin\\Setup.ps1 -IISHostname ${var.https_iis_hostname} -NewOSHostname ${var.system_name} -RestartVM"
 }
SETTINGS

}


resource "null_resource" "dns_config" {

  triggers = {
    dns_name   = var.https_iis_hostname
    dns_target = azurerm_public_ip.pip.fqdn
  }

  # ---------- CREATE ----------
  provisioner "local-exec" {
    command = "gincloud dns create ${self.triggers.dns_name} ${self.triggers.dns_target} --type CNAME --domain ginesys.cloud --overwrite"
  }

  # ---------- DESTROY ----------
  provisioner "local-exec" {
    when    = destroy
    command = "gincloud dns delete ${self.triggers.dns_name} --type CNAME --domain ginesys.cloud --confirm"
  }
}