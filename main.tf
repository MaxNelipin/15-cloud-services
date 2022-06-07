# Подключение к дефолту

provider "yandex" {
  token     = "AQAAAAAFrwZGAATuwVY7-f9XRESeqhtszNIx5Kc"
  cloud_id  = "b1ghq301023687quik6d"
  folder_id = "b1gpooj85mh91so024vc"
  zone      = "ru-central1-a"
}

# Создание отдельного VPC и папки
resource "yandex_resourcemanager_cloud" "vpc-15" {
  name = "vpc-15"
  organization_id = "bpftkk6beuqrt5904cft"
}

#resource "yandex_resourcemanager_folder" "folder-15" {
 # name = "folder-15"
  #cloud_id = yandex_resourcemanager_cloud.vpc-15.id
#}




