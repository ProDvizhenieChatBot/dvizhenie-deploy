# Эта переменная в env'ах нужна для docker-compose: локальные пути будут определяться корректно
export PWD := $(shell pwd)

BRANCH = $(word 2,$(MAKECMDGOALS))

# Предотвращаем выполнение аргумента как цели
$(BRANCH):
	@:

hello:
	@echo 'Build Dvizhenie ChatBot project'

deps-init:
	@echo 'Pull project and dependencies recursively'
	@git pull --recurse-submodules

deps:
	@echo 'Pull dependencies'
	@git submodule update --init --recursive
	# TODO: @git submodule foreach 'git checkout $(BRANCH) && git pull'
	@git submodule foreach 'git checkout main && git pull'

l-deploy:
	# Останавливаем контейнеры, если запущены
	