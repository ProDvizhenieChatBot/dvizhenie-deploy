# Nginx configuration

## Create TLS certificates

```
brew install mkcert
mkcert -install         # Установить локальный CA, если не поставить, то доверия не будет по умолчанию (но это не мешает)
```

Создаем серты:

```
mkcert dvizhenie.internal "*.dvizhenie.internal"
```

`*-key.pem` — это `.key` для Nginx
`*.pem` — это `.crt` для Nginx
