.DEFAULT_GOAL = help
SHELL=bash

require-%:
	if [ "${${*}}" = "" ]; then \
	        @echo "ERROR: Environment variable not set: \"$*\""; \
	        @exit 1; \
	fi

## Docker build
build:
	docker image build . -f Dockerfile -t nightly-2020-09-18

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
