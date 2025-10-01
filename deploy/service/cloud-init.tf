locals {
  base-dir = "/etc/${var.app-name}"
}

locals {
  cert-fullchain-path = "${local.base-dir}/certs/${var.app-name}.crt"
  cert-privkey-path   = "${local.base-dir}/certs/${var.app-name}.key"
}

locals {
  fluentbit-docker-host = "fluentbit"
  fluentbit-docker-port = 24224
}

locals {
  # nginx_services = [
  #   for service in var.services : {
  #     path = "${local.base-dir}/nginx/templates/${service.name}.conf.template"
  #     content = templatefile("${var.configs-path}/nginx/templates/service.conf.template", {
  #       DOMAIN             = service.domain
  #       SERVICE_NAME       = service.name
  #       NGINX_SERVICE_HOST = format("$%s_host", service.name)
  #       DOCKER_HOST        = service.docker.docker-host
  #       DOCKER_PORT        = service.docker.docker-port
  #     })
  #   }
  # ]

  nginx_services = [
    {
      path = "${local.base-dir}/nginx/templates/hq.conf.template",
      content = templatefile("${var.configs-path}/nginx/templates/hq.conf.template", {
        DOMAIN = var.dns.hq
      })
    },
    {
      path = "${local.base-dir}/nginx/templates/backend.conf.template",
      content = templatefile("${var.configs-path}/nginx/templates/backend.conf.template", {
        DOMAIN = var.dns.api
      })
    }
  ]

  nginx_certificates = [
    {
      path    = local.cert-privkey-path
      content = var.cert-privkey
    },
    {
      path    = local.cert-fullchain-path
      content = var.cert-chain
    }
  ]

  postgres_init = [
    {
      # Задаем пароль при инициализации базы
      path = "/etc/init.sql"
      content = templatefile("${var.configs-path}/postgres/init.sql", {
        POSTGRES_USER     = var.postgres-secrets.user
        POSTGRES_PASSWORD = var.postgres-secrets.password
      })
    }
  ]

  nginx_configs = [
    {
      path    = "${local.base-dir}/nginx/http.conf"
      content = file("${var.configs-path}/nginx/http.conf")
    },
    {
      path = "${local.base-dir}/nginx/ssl/certificates.conf"
      content = templatefile("${var.configs-path}/nginx/ssl/certificates.conf", {
        # Где внутри контейнера nginx будут лежать сертификаты
        CERTIFICATE_CHAIN = "/etc/ssl/${var.app-name}.crt"
        CERTIFICATE_KEY   = "/etc/ssl/${var.app-name}.key"
      })
    },
    {
      path    = "${local.base-dir}/nginx/ssl/params.conf"
      content = file("${var.configs-path}/nginx/ssl/params.conf")
    },
    {
      path    = "${local.base-dir}/nginx/templates/reject-rule.conf.template"
      content = file("${var.configs-path}/nginx/templates/reject-rule.conf.template")
    },
    {
      path    = "${local.base-dir}/nginx/.htpasswd",
      content = local.htpasswd_file_content
    }
  ]

  nginx_fluentbit = [
    {
      path = "${local.base-dir}/fluentbit/fluentbit.conf"
      content = templatefile("${var.configs-path}/fluentbit/fluentbit.conf", {
        FLUENT_BIT_HOST = local.fluentbit-docker-host
        FLUENT_BIT_PORT = local.fluentbit-docker-port
        YC_GROUP_ID     = var.logging-group-id
      })
    },
    {
      path    = "${local.base-dir}/fluentbit/parsers.conf"
      content = file("${var.configs-path}/fluentbit/parsers.conf")
    }
  ]

  docker-compose-configs = [
    {
      path    = "${local.base-dir}/docker-compose/docker-compose.yml",
      content = local.docker-compose
    }
  ]

  service-configs = [
    {
      path = "${local.base-dir}/service/bot_service.env",
      content = templatefile("${var.configs-path}/service/bot_service.env", {
        TELEGRAM_BOT_TOKEN = var.telegram-bot-token
        MINI_APP_URL = var.mini-app-url
      })
    },
    {
      path = "${local.base-dir}/service/db_service.env",
      content = templatefile("${var.configs-path}/service/db_service.env", {
        POSTGRES_LOCAL_HOST = var.postgres-config.local-host
        POSTGRES_DB = var.postgres-secrets.db
        POSTGRES_USER = var.postgres-secrets.user
        POSTGRES_PASSWORD = var.postgres-secrets.password
      })
    },
    {
      path = "${local.base-dir}/service/hq_service.env",
      content = file("${var.configs-path}/service/hq_service.env")
    },
    {
      path = "${local.base-dir}/service/storage_service.env",
      content = templatefile("${var.configs-path}/service/storage_service.env", {
        S3_ENDPOINT_URL = var.s3.endpoint-url
        S3_PUBLIC_URL = var.s3.public-url
        MINIO_ROOT_USER = var.s3.aws-access-key-id
        MINIO_ROOT_PASSWORD = var.s3.aws-secret-access-key
        MINIO_BUCKET_NAME = var.s3.bucket-name
      })
    }
  ]
}

locals {
  htpasswd_file_content = fileexists(var.htpasswd-path) ? file(var.htpasswd-path) : ".htpasswd will be generated during apply"
  ssh_pub_key_content   = fileexists("${var.vm-ssh-key-path}.pub") ? file("${var.vm-ssh-key-path}.pub") : "# SSH key will be generated during apply"
}

locals {
  write_files = concat(
    local.nginx_certificates,
    local.postgres_init,
    local.nginx_configs,
    local.nginx_fluentbit,
    local.nginx_services,
    local.docker-compose-configs
  )
  base-cloud-init = {
    # User setup configuration
    ssh_pwauth = false
    users = [
      {
        name  = var.default-user
        sudo  = "ALL=(ALL) NOPASSWD:ALL"
        shell = "/bin/bash"
        ssh_authorized_keys = [
          local.ssh_pub_key_content
        ]
      }
    ]
    runcmd = [
      "echo 'Hello, World!' > /etc/hello-world.txt",
      "chmod 666 /var/run/docker.sock"
    ]
    // Move configs to VM
    write_files = local.write_files
  }
  cloud-init-yaml = yamlencode(
    local.base-cloud-init
  )
}

data "cloudinit_config" "cloud-init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = local.cloud-init-yaml
  }
}
