resource "yandex_vpc_network" "network-1" {
  name = "network1"
  #folder_id = yandex_resourcemanager_cloud.vpc-15.id
}

resource "yandex_vpc_subnet" "subnet-public" {
  name           = "subnet-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]

}

resource "yandex_vpc_subnet" "subnet-public-b" {
  name           = "subnet-public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.11.0/24"]

}

resource "yandex_vpc_subnet" "subnet-public-c" {
  name           = "subnet-public-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.12.0/24"]

}

resource "yandex_vpc_subnet" "subnet-private" {
  name           = "subnet-private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance.id
}

resource "yandex_vpc_subnet" "subnet-private-b" {
  name           = "subnet-private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.21.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance.id
}

resource "yandex_vpc_subnet" "subnet-private-c" {
  name           = "subnet-private-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.22.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance.id
}


resource "yandex_vpc_route_table" "nat-instance" {
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "192.168.10.254"
  }
}