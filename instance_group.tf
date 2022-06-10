// Create SA
resource "yandex_iam_service_account" "editornetology" {
  folder_id = local.folder_id
  name      = "editornetology"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "editornetology" {
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.editornetology.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "cca-static-key" {
  service_account_id = yandex_iam_service_account.editornetology.id
  description        = "static access key for object storage"
}



resource "yandex_compute_instance_group" "group-15-2" {
  name                = "group-15-2"
  folder_id           = local.folder_id
  service_account_id  = "${yandex_iam_service_account.editornetology.id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    scheduling_policy {
      preemptible = true
    }
    resources {
      core_fraction = 5
      cores         = 2
      memory        = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network-1.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet-public.id}"]
      nat = true
    }
    metadata = {
      ssh-keys = "maxn:${file(var.ssh-keys)}"
      user-data = "#cloud-config \nwrite_files:\n- content: <!DOCTYPE HTML><html><head></head><body><img src='https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-netology.bucket}/${yandex_storage_object.picture_15_2.key}'></body></html>\n  path: /var/www/html/test152.html\n  permissions: '0644'"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
    startup_duration = 10
  }

  health_check {
    interval = 10
    timeout = 3
    unhealthy_threshold = 2
    healthy_threshold = 2
    http_options {
      path = "/test152.html"
      port = 80
    }
  }

  load_balancer {
    target_group_name = "tg15-2"
    max_opening_traffic_duration = 30
  }

}
