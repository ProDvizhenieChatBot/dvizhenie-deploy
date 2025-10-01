locals {
  device-name            = "${var.app-name}-pgdata" # Название виртуального диска для YCloud для связки VM и облачного ресурса в Docker Compose
  postgres-password-hash = sha256("${var.postgres-secrets.password}-${var.environment}")
}

variable "environment" {
  description = "Service environment"
  type        = string
  default     = "testing" # testing | production
}

variable "app-name" {
  description = "Service name"
  type        = string
}

variable "zone" {
  description = "В каком DC разместить сервис"
  type        = string
  # default     = "ru-central1-a"
}

variable "service-account-id" {
  # Roles: container-registry.images.puller
  description = "Service Account"
  type        = string
}

variable "network-id" {
  description = "VPC Network ID"
  type        = string
}

variable "subnet-id" {
  description = "VPC subnet id"
  type        = string
}

variable "default-user" {
  description = "SSH user"
  type        = string
}

variable "vm-ssh-key-path" {
  description = "ssh key path"
  type        = string
}

variable "logging-group-id" {
  description = "Logging group ID"
  type        = string
}

# TLS Certificate

variable "cert-privkey" {
  description = "certificate privkey"
  type        = string
  sensitive   = true
}

variable "cert-chain" {
  description = "certificate chain"
  type        = string
}

# Services

variable "configs-path" {
  description = "Путь до конфигов для разворачивания инфры"
  type        = string
}

# Postgres

variable "postgres-config" {
  description = "Postgres Config"
  type = object({
    # Это имя контейнера, а не реальный хост!
    local-host = string
    # Вообще, это константа, на нее мы не влияем, но нам ее надо перекидывать
    local-port  = number
    remote-port = number
  })
}

variable "postgres-secrets" {
  description = "Postgres credentials"
  type = object({
    db       = string
    user     = string
    password = string
  })
  sensitive = true
}

# variable "postgres-password-hash" {
#   # Сменили пароль — диск с данными пересоздаем?
#   # Пока не знаю как лучше
#   description = "Хеш пароля к Postgres"
#   type        = string
#   sensitive   = true
# }

variable "dns" {
  description = "Адреса сервисов"
  type = object({
    hq  = string
    api = string
  })
}

variable "container-registry-id" {
  type = string
}

variable "htpasswd-path" {
  type = string
}

variable "domain-zone-id" {
  type = string
}