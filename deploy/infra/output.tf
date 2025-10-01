# Common output

output "service-account-id" {
  value = yandex_iam_service_account.sa.id
}

output "network-id" {
  value = yandex_vpc_network.network.id
}

output "subnet-id" {
  value = yandex_vpc_subnet.subnet.id
}

output "container-registry-id" {
  value = yandex_container_registry.default.id
}

output "logging-group-id" {
  value = yandex_logging_group.group.id
}

# DNS output

output "domain-zone-id" {
  value = yandex_dns_zone.service-domain-zone.id
}

# Certificates output

output "cert_id" {
  description = "Certificate ID"
  value       = data.yandex_cm_certificate.cert-domain.id
}

output "not_after" {
  description = "Certificate end valid period"
  value       = data.yandex_cm_certificate.cert-domain.not_after
}

output "chain" {
  value = join("\n", data.yandex_cm_certificate_content.cert-domain-content.certificates)
}

output "privkey" {
  value     = data.yandex_cm_certificate_content.cert-domain-content.private_key
  sensitive = true
}
