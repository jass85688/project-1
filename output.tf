output "virtual_machine_name" {
    value = azurerm_virtual_machine.main.name
}

output "storage_account_location" {
    value = azurerm_storage_account.storage_acc.location
}