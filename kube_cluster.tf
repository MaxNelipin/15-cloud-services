resource "yandex_kubernetes_cluster" "cluster-kube-15-4" {
  name        = "cluster-kube-15-4"
  description = "description"

  network_id = yandex_vpc_network.network-1.id

  cluster_ipv4_range = "10.10.0.0/16"
  service_ipv4_range = "10.20.0.0/16"

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.subnet-public.zone
        subnet_id = yandex_vpc_subnet.subnet-public.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-public-b.zone
        subnet_id = yandex_vpc_subnet.subnet-public-b.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-public-c.zone
        subnet_id = yandex_vpc_subnet.subnet-public-c.id
      }
    }

    version   = "1.19"
    public_ip = true


    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-bucket.id
  }

  service_account_id      = yandex_iam_service_account.netology-kube.id
  node_service_account_id = yandex_iam_service_account.netology-kube.id

  release_channel = "STABLE"

  network_policy_provider = "CALICO"
  depends_on              = [
    yandex_resourcemanager_folder_iam_binding.editor_netology-kube,
    yandex_resourcemanager_folder_iam_binding.images-puller,
    yandex_iam_service_account.netology-kube
  ]

}

resource "yandex_kubernetes_node_group" "node-group-15-4-a" {
  cluster_id = yandex_kubernetes_cluster.cluster-kube-15-4.id
  name       = "node-group-15-4-a"

  version = "1.19"


  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat        = true
      subnet_ids = [
        "${yandex_vpc_subnet.subnet-public.id}"
      ]
    }

    metadata = { ssh-keys = "maxn:${file(var.ssh-keys)}" }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone      = "ru-central1-a"
      #subnet_id = yandex_vpc_subnet.subnet-public.id
    }

  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}

resource "yandex_kubernetes_node_group" "node-group-15-4-b" {
  cluster_id = yandex_kubernetes_cluster.cluster-kube-15-4.id
  name       = "node-group-15-4-b"

  version = "1.19"


  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat        = true
      subnet_ids = [
        "${yandex_vpc_subnet.subnet-public-b.id}"
      ]
    }

    metadata = { ssh-keys = "maxn:${file(var.ssh-keys)}" }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone      = "ru-central1-b"
      #subnet_id = yandex_vpc_subnet.subnet-public.id
    }

  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}


resource "yandex_kubernetes_node_group" "node-group-15-4-c" {
  cluster_id = yandex_kubernetes_cluster.cluster-kube-15-4.id
  name       = "node-group-15-4-c"

  version = "1.19"


  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat        = true
      subnet_ids = [
        "${yandex_vpc_subnet.subnet-public-c.id}"
      ]
    }

    metadata = { ssh-keys = "maxn:${file(var.ssh-keys)}" }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone      = "ru-central1-c"
      #subnet_id = yandex_vpc_subnet.subnet-public.id
    }

  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}