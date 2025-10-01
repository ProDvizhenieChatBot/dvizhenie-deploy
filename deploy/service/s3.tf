# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service-account-id
  description        = "Static access key for S3"
}

# Создание S3 bucket
resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key

  bucket = var.bucket-name

  # Настройка ACL (необязательно)
  # acl = "private"

  # Включение версионирования (необязательно)
  versioning {
    enabled = false
  }

  # Настройка CORS (необязательно)
  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["GET", "PUT", "POST"]
  #   allowed_origins = ["*"]
  #   max_age_seconds = 3600
  # }

  # Настройка lifecycle (необязательно)
  # lifecycle_rule {
  #   id      = "delete-old-objects"
  #   enabled = true
  #   
  #   expiration {
  #     days = 90
  #   }
  # }
}