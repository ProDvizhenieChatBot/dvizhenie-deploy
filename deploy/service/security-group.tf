# Security group

resource "yandex_vpc_security_group" "instance-security-group" {
  # https://yandex.cloud/ru/docs/vpc/concepts/security-groups
  name       = "app-security-group"
  network_id = var.network-id

  ingress {
    description    = "Allow SSH"
    protocol       = "ANY"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   description    = "Allow Postgres"
  #   protocol       = "TCP"
  #   port           = var.postgres-config.remote-port
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   description    = "Allow Fluentd"
  #   protocol       = "ANY" # TCP | UDP
  #   port           = 24224
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
