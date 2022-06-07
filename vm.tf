resource "yandex_compute_image" "ubuntu-lat" {
  name = "ubuntu-lat"
  source_family = "ubuntu-2004-lts"
  #folder_id = yandex_resourcemanager_cloud.vpc-15.id
}

resource "yandex_compute_instance" "vm-public" {
  name = "vm-public"
  #folder_id = yandex_resourcemanager_cloud.vpc-15.id
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-lat.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }
  resources {
    core_fraction = 5
    cores = 2
    memory = 2
  }
  metadata = { ssh-keys = "maxn:${file(var.ssh-keys)}" }
}

resource "yandex_compute_instance" "vm-nat" {
  name = "vm-nat"
  #folder_id = yandex_resourcemanager_cloud.vpc-15.id
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    ip_address = "192.168.10.254"
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }
  resources {
    core_fraction = 5
    cores = 2
    memory = 2
  }
}


resource "yandex_compute_instance" "vm-private" {
  name = "vm-private"
  #folder_id = yandex_resourcemanager_cloud.vpc-15.id
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu-lat.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-private.id
    nat       = false
  }

  scheduling_policy {
    preemptible = true
  }
  resources {
    core_fraction = 5
    cores = 2
    memory = 2
  }

  metadata = { ssh-keys = "maxn:${file(var.ssh-keys)}" }
}