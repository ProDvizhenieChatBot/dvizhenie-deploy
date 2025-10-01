module "app" {
  source = "./vm-instance"

  cloud-init     = data.cloudinit_config.cloud-init.rendered
  docker-compose = local.docker-compose

  sa-id = var.service-account-id
  sg-id = yandex_vpc_security_group.instance-security-group.id

  subnet-id   = var.subnet-id
  zone        = var.zone
  device-name = local.device-name

  postgres-password-hash = local.postgres-password-hash
  default-user           = var.default-user
  ssh-key                = var.vm-ssh-key-path
}
