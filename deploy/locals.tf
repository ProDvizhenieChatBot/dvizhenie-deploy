locals {
  ssh-key-file-name  = "ycvm"
  ssh-key-file-path  = pathexpand("${path.module}/${local.ssh-key-file-name}")
  htpasswd-file-path = pathexpand("${path.module}/.htpasswd")

  connection = {
    default-user = "yc-user"
    ssh-key = {
      filename = local.ssh-key-file-name
      path     = local.ssh-key-file-path
    }
  }
}

locals {
  service = {
    name        = "dvizhenie"
    environment = "testing"
  }

  dns = {
    parent-domain  = "ikemurami.com"
    service-domain = "${local.service.name}.ikemurami.com"
  }

  api-service = {

  }

  bot-service = {

  }

  storage-service = {

  }

  hq-service = {

  }

  postgres-service = {
    local-host  = "postgres-service"
    local-port  = 5432
    remote-port = 5432
  }
}

locals {
  ycloud = {
    zone                 = "ru-central1-a"
    folder-name          = "dvizhenie-life"
    registry-name        = "default"
    logging-group-name   = "logs"
    service-account-name = "sa"
    network = {
      name            = "network"
      subnetwork-name = "subnet-a"
    }
  }
}

locals {
  configs = {
    service = pathexpand("${path.module}/../configs")
  }
}