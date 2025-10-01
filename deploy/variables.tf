variable "cloud-id" {
  description = "YCloud cloud ID"
  type        = string
}

variable "folder-id" {
  description = "YCloud folder ID"
  type        = string
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

variable "user-admin-creds" {
  description = "Admin access credentials"
  type = object({
    login    = string
    password = string
  })
  sensitive = true
}

variable "bucket-name" {
  description = "s3 bucket name"
  type        = string
}

variable "telegram-bot-token" {
  description = "telegram-bot-token"
  type        = string
  sensitive   = true
}

variable "mini-app-url" {
  description = "MiniApp URL"
  type        = string
}
