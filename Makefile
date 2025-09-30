# Эта переменная в env'ах нужна для docker-compose: локальные пути будут определяться корректно
export PWD := $(shell pwd)

hello:
	@echo 'Build Dvizhenie ChatBot project'

deps-init:
	@echo 'Pull project and dependencies recursively'
	@git pull --recurse-submodules
