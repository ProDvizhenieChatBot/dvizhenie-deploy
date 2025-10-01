# Setup parent domain zone
# https://yandex.cloud/ru/docs/compute/tutorials/bind-domain-vm/terraform
# resource "yandex_dns_zone" "parent-domain-zone" {
#   name        = var.parent-domain.zone-name
#   description = "Parent domain zone"

#   zone   = "${var.parent-domain.domain}."
#   public = true
# }

data "yandex_dns_zone" "parent-domain-zone" {
  dns_zone_id = "dns4cbtg0kv67r4hesao"
}

# Создание зоны DNS для сервиса
resource "yandex_dns_zone" "service-domain-zone" {
  name        = var.service-domain.zone-name
  description = "Service domain zone"

  zone   = "${var.service-domain.value}."
  public = true
}
