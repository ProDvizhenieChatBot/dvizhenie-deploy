variable "cloud-id" {
  description = "YCloud cloud ID"
  type        = string
}

variable "folder-id" {
  description = "YCloud folder ID"
  type        = string
}

variable "registry-name" {
  description = "Docker registry name"
  type        = string
  default     = "default"
}

variable "service-account-name" {
  type = string
}

variable "logging-group-name" {
  description = "Логи сервиса"
  type        = string
  default     = "logs"
}

# Network

variable "network" {
  # Настраиваем сеть
  description = "Service network"
  type = object({
    name            = string
    subnetwork-name = string
  })
  default = {
    name            = "network"
    subnetwork-name = "subnet-a"
  }
}

variable "zone" {
  description = "В каком DC разместить сервис"
  type        = string
  default     = "ru-central1-a"
}

# DNS

variable "parent-domain" {
  # Настраиваем зону для родительского домена, сами сервисы будут на дочерних доменах
  description = "Parent domain zone"
  type = object({
    domain    = string
    zone-name = string
  })
  default = null
}

variable "service-domain" {
  # Настраиваем зону для домена сервиса и выписываем сертификаты
  description = "Service domain zone"
  type = object({
    value     = string
    zone-name = string
  })
}