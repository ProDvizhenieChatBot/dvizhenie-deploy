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

variable "s3" {
  description = "s3 bucket"
  type = object({
    endpoint-url = string
    public-url = string
    aws-access-key-id = string
    aws-secret-access-key = string
    bucket-name = string
  })
  sensitive = true
}

variable "telegram-bot-token" {
  description = "telegram-bot-token"
  type = string
  sensitive = true
}

variable "mini-app-url" {
  description = "MiniApp URL"
  type = string
}
