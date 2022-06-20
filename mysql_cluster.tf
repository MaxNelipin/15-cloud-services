resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-15-4.id
  name       = "netology_db"
  depends_on = [yandex_mdb_mysql_cluster.cluster-mysql-15-4]
}


resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-15-4.id
  name       = "netology_user"
  password   = "p@ssw)rd00000"


  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }


  connection_limits {
    max_questions_per_hour   = 1000
    max_updates_per_hour     = 2000
    max_connections_per_hour = 3000
    max_user_connections     = 4000
  }

  global_permissions = ["PROCESS"]

  authentication_plugin = "SHA256_PASSWORD"
}


resource "yandex_mdb_mysql_cluster" "cluster-mysql-15-4" {
  name                = "cluster-mysql-15-4"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.network-1.id
  version             = "8.0"
  folder_id           = local.folder_id
  deletion_protection = true
  #user                = yandex_mdb_mysql_user.netology_user.id
  #database            = yandex_mdb_mysql_database.netology_db.id

  backup_window_start {
    hours   = 23
    minutes = 59
  }
  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-private.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.subnet-private-b.id
  }

  host {
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.subnet-private-c.id
  }

}
