APP_NAME ?= `grep 'app:' mix.exs | sed 's/,//' | cut -d ':' -f3`
APP_VERSION ?= `grep 'version:' mix.exs | cut -d '"' -f2`
APP_ORG ?= cjayross
BUILD ?= `git rev-parse --short HEAD`

all: build

build:
	docker build \
		-t $(APP_ORG)/$(APP_NAME):$(APP_VERSION)-$(BUILD) \
		-t $(APP_ORG)/$(APP_NAME):latest .
