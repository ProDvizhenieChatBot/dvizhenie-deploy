# IAM: create service account and bind permissions
resource "yandex_iam_service_account" "sa" {
  name        = var.service-account-name
  description = "Сервисный аккаунт для загрузки контейнеров из docker registry"
}

resource "yandex_resourcemanager_folder_iam_binding" "image-puller" {
  folder_id = var.folder-id
  role      = "container-registry.images.puller"
  members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "logging-writer" {
  folder_id = var.folder-id
  role      = "logging.writer"
  members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}
