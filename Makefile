# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
SHELL := /bin/bash
INSTANCES = 2 # 2 instance by default
CFLAGS = -c -g -D $(INSTANCES)

help: ## This help.
		@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

source_env: ## sources reqired ENV to build the image with the release
		source ./.env

build: ## builds the image containing the releases
		make source_env
		docker-compose build --no-cache

up: ## runs n containers, run it like make INSTANCES=n to instantiate n api containers
		make source_env
		docker-compose up --scale api=${INSTANCES}

conf: ## shows docker-compose config 
		docker-compose config

down: ## stops and removes the containers 
		docker-compose down

rmi: ## removes all generated doker images
		docker rmi -f $$(docker images -q)

docs: ## generate docs and opens the index.html
		mix deps.get
		mix compile
		mix docs
		open doc/index.html
