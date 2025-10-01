# Создание ресурсной записи типа А на наши сервисы
resource "yandex_dns_recordset" "record-api" {
  zone_id = var.domain-zone-id
  name    = "${var.dns.api}."
  type    = "A"
  ttl     = 600
  data    = [module.app.external-ip]
}

resource "yandex_dns_recordset" "record-web" {
  zone_id = var.domain-zone-id
  name    = "${var.dns.hq}."
  type    = "A"
  ttl     = 600
  data    = [module.app.external-ip]
}

resource "yandex_dns_recordset" "record-widget" {
  zone_id = var.domain-zone-id
  name    = "${var.dns.widget}."
  type    = "A"
  ttl     = 600
  data    = [module.app.external-ip]
}
