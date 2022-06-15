resource "yandex_kms_symmetric_key" "kms-bucket" {
  lifecycle {
    prevent_destroy = true
  }

  name              = "bucket-sym-key"
  description       = "encrypt bucket 15.3"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // equal to 1 year
  folder_id = local.folder_id

}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = local.folder_id

  role   = "kms.keys.encrypterDecrypter"
  member = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

