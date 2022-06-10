resource "yandex_lb_network_load_balancer" "nlb15-2" {
  name = "nlb15-2"

  listener {
    name = "list-for-picture"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.group-15-2.load_balancer[0].target_group_id}"

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}