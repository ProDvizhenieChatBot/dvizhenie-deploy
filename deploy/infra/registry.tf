# Setup Container registry
resource "yandex_container_registry" "default" {
  name      = var.registry-name
  folder_id = var.folder-id
}
