.DEFAULT_GOAL = help
SHELL=bash

TAG=nightly-2020-09-18

require-%:
	if [ "${${*}}" = "" ]; then \
	        @echo "ERROR: Environment variable not set: \"$*\""; \
	        @exit 1; \
	fi

## Docker build
build:
	docker image build . -f Dockerfile -t $(TAG)

## Github docker login
login:
	docker login https://ghcr.io

## Push to Github docker regitry
push: require-VERSION
	docker tag $(TAG) ghcr.io/psibi/stack-docker/$(TAG):$(VERSION)
	docker push ghcr.io/psibi/stack-docker/$(TAG):$(VERSION)

## Pull
pull:
	docker pull ghcr.io/psibi/stack-docker/$(TAG):1.0

## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
