# dvizhenie-deploy

Для разворачивания проекта в чатбота для Фонда Продвижение выполняем следующие шаги:

1. Заводим аккаунт в Yandex Cloud, создаем организацию, облако, каталог
2. Копируем [variables.tfvars.tpl](./deploy/variables.tfvars.tpl) рядом в `variables.tfvars` и заполняем значения:

- `cloud-id` — ID облака в Yandex Cloud
- `folder-id` — ID каталога в Yandex Cloud
- `postgres-secret` — имя базы, пользователь и пароль для подключения
- `user-admin-creds` — admin пользователь в админке
- `telegram-bot-token` — токен телеграм-бота
- `mini-app-url` — ссылка, где будет расположен miniapp для телеграмма (https://{WIDGET-URL}/tg-mini-app)
- `bucket-name` — название бакета

3. Запускаем это все (переходим в директорию deploy):

```
export YC_TOKEN="$(yc iam create-token)"
make init
make plan
make apply
```

Инфраструктуре нужно время чтобы полностью подняться, через пару минут заходим на VM и проверяем, что все запустилось:

```
ssh -l yc-user -i ycvm <IP-addr>
docker ps -a
```

## Если что-то не так

1. Смотрим логи cloud-init (`/var/log/cloud-init*.log`)
2. Пробуем прямо на тачке поднять инфру, смотрим ошибки

```
cd /etc/dvizhenie/docker-compose
docker compose build
docker compose up
```
