output "external-ip" {
  value = module.app.external-ip
}

output "s3" {
  value = {
    aws-access-key-id     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    aws-secret-access-key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket-name           = var.bucket-name
  }
  sensitive = true
}
