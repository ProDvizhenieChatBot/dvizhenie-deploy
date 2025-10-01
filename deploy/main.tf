# # Если SSH ключ еще не делали, создаем
# resource "null_resource" "vm-ssh-key" {
#   # triggers = {
#   #   # Триггер активируется только если файла нет
#   #   file_missing = fileexists(local.ssh-key-file-path) ? "file-exists" : uuid()
#   # }
#   # count = fileexists(local.ssh-key-file-path) ? 0 : 1

#   provisioner "local-exec" {
#     command = "ssh-keygen -t ed25519 -f ${local.ssh-key-file-name}"
#   }
# }

resource "tls_private_key" "vm-ssh-key" {
  algorithm = "ED25519"
}

resource "local_file" "vm-ssh-key-priv" {
  content         = tls_private_key.vm-ssh-key.private_key_openssh
  filename        = local.ssh-key-file-name
  file_permission = "0600"
}

resource "local_file" "vm-ssh-key-pub" {
  content         = tls_private_key.vm-ssh-key.public_key_openssh
  filename        = "${local.ssh-key-file-name}.pub"
  file_permission = "0644"
}

resource "null_resource" "htpasswd" {
  provisioner "local-exec" {
    command = "htpasswd -bc ${local.htpasswd-file-path} ${var.user-admin-creds.login} ${var.user-admin-creds.password}"
  }
}

module "preparation" {
  source = "./infra"

  zone      = local.ycloud.zone
  cloud-id  = var.cloud-id
  folder-id = var.folder-id
  network = {
    name            = "network"
    subnetwork-name = "subnet-a"
  }

  parent-domain = {
    domain    = local.dns.parent-domain
    zone-name = "parent-zone"
  }
  service-domain = {
    value     = local.dns.service-domain
    zone-name = "service-zone"
  }
  logging-group-name   = "logs"
  registry-name        = "default"
  service-account-name = "sa-dvizhenie"

  providers = {
    yandex = yandex.with-project-info
  }
}

resource "null_resource" "build-docker-images" {
  # Собираем докер-образ для бекенда и грузим в Container Registry
  provisioner "local-exec" {
    command = "cd ${path.module}/../dependencies/backend && make image ${module.preparation.container-registry-id}"
  }

  # Собираем докер-образ для HQ и грузим в Container Registry
  provisioner "local-exec" {
    command = "cd ${path.module}/../dependencies/hq && make image ${module.preparation.container-registry-id}"
  }

  # Собираем докер-образ для Widget и грузим в Container Registry
  provisioner "local-exec" {
    command = "cd ${path.module}/../dependencies/widget && make image ${module.preparation.container-registry-id}"
  }

  depends_on = [module.preparation]
}

module "service" {
  source = "./service"

  environment           = local.service.environment
  app-name              = local.service.name
  zone                  = local.ycloud.zone
  service-account-id    = module.preparation.service-account-id
  network-id            = module.preparation.network-id
  subnet-id             = module.preparation.subnet-id
  default-user          = local.connection.default-user
  vm-ssh-key-path       = local.connection.ssh-key.path
  logging-group-id      = module.preparation.logging-group-id
  cert-privkey          = module.preparation.privkey
  cert-chain            = module.preparation.chain
  configs-path          = local.configs.service
  postgres-config       = local.postgres-service
  postgres-secrets      = var.postgres-secrets
  container-registry-id = module.preparation.container-registry-id
  dns = {
    hq     = "admin.${local.dns.service-domain}"
    api    = "api.${local.dns.service-domain}"
    widget = "widget.${local.dns.service-domain}"
  }
  htpasswd-path  = local.htpasswd-file-path
  domain-zone-id = module.preparation.domain-zone-id

  bucket-name        = var.bucket-name
  telegram-bot-token = var.telegram-bot-token
  mini-app-url       = var.mini-app-url

  depends_on = [
    null_resource.build-docker-images,
    null_resource.htpasswd,
    local_file.vm-ssh-key-priv,
    local_file.vm-ssh-key-pub
  ]

  providers = {
    yandex = yandex.with-project-info
  }
}
