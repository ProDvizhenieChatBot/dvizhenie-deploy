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