# VPC Network

resource "yandex_vpc_network" "network" {
  name = var.network.name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.network.subnetwork-name
  network_id     = yandex_vpc_network.network.id
  zone           = var.zone
  v4_cidr_blocks = ["10.5.0.0/24"]
}
