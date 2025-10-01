terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  alias     = "with-project-info"
  cloud_id  = var.cloud-id
  folder_id = var.folder-id
}