locals {
  docker-compose = templatefile("${var.configs-path}/tpl.docker-compose.yml", {
    PWD = local.base-dir

    DEFAULT_USER = var.default-user
    DEVICE_NAME  = local.device-name
    YC_GROUP_ID  = var.logging-group-id

    POSTGRES_LOCAL_HOST  = var.postgres-config.local-host
    POSTGRES_LOCAL_PORT  = var.postgres-config.local-port
    POSTGRES_REMOTE_PORT = var.postgres-config.remote-port
    POSTGRES_DB          = var.postgres-secrets.db
    POSTGRES_USER        = var.postgres-secrets.user
    POSTGRES_PASSWORD    = var.postgres-secrets.password

    FLUENT_BIT_HOST = local.fluentbit-docker-host
    FLUENT_BIT_PORT = local.fluentbit-docker-port

    BACKEND_API_DOCKER_IMAGE     = "cr.yandex/${var.container-registry-id}/backend-api:0.1"
    BACKEND_BOT_DOCKER_IMAGE     = "cr.yandex/${var.container-registry-id}/backend-bot:0.1"
    BACKEND_STORAGE_DOCKER_IMAGE = "cr.yandex/${var.container-registry-id}/backend-storage:0.1"
    HQ_FRONTEND_DOCKER_IMAGE     = "cr.yandex/${var.container-registry-id}/hq:0.1"
    WIDGET_FRONTEND_DOCKER_IMAGE = "cr.yandex/${var.container-registry-id}/widget:0.1"
    NGINX_ALPINE_DOCKER_IMAGE    = "cr.yandex/${var.container-registry-id}/nginx:alpine"
    POSTGRES_ALPINE_DOCKER_IMAGE = "cr.yandex/${var.container-registry-id}/postgres:alpine"
  })
}