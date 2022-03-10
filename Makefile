APP_ENV ?= prod
APP_REGION ?= us-east-1
APP_NAME ?= `grep 'app:' mix.exs | sed 's/,//' | cut -d ':' -f3`
APP_VERSION ?= `grep 'version:' mix.exs | cut -d '"' -f2`
APP_ORG ?= 935436410671.dkr.ecr.$(APP_REGION).amazonaws.com
BUILD ?= `git rev-parse --short HEAD`

all: build

build:
	docker build \
		--build-arg MIX_ENV=$(APP_ENV) \
		-t $(APP_ORG)/$(APP_NAME):$(APP_VERSION)-$(BUILD)-$(APP_ENV) .

push:
	docker push $(APP_ORG)/$(APP_NAME):$(APP_VERSION)-$(BUILD)-$(APP_ENV)
