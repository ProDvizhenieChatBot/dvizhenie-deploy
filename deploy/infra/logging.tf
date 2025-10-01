# Logging

resource "yandex_logging_group" "group" {
  name             = var.logging-group-name
  retention_period = "168h" # 7d
}
