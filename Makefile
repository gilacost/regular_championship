# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help source_env build up
SHELL := /bin/bash

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

source_env: ## Sources reqired ENV to build the image with the release 
		source ./.env

build: ## builds the image containing the release
		make source_env
	  docker-compose build 
	   
up: ## runs the container 
		make source_env
	  docker-compose up

conf: ## shows docker-compose config 
	  docker-compose config
