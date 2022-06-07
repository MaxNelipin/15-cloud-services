output "internal_ip_address_vm_public" {
  value = yandex_compute_instance.vm-public.network_interface.0.ip_address
}

output "external_ip_address_vm_public" {
  value = yandex_compute_instance.vm-public.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_private" {
  value = yandex_compute_instance.vm-private.network_interface.0.ip_address
}


