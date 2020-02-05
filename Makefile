APP_ENV ?= development
APP_NAME:=tico

console:
	docker-compose run --rm ruby sh

start:
	docker build \
		--build-arg USER=$(APP_NAME) \
		--build-arg UID=$$(id -u) \
		--build-arg GID=$$(id -u) \
		--tag $(APP_NAME)/ruby:$(APP_ENV) \
		--target $(APP_ENV) \
		-f Dockerfile .
	docker-compose up

.PHONY: build console start
