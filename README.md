# Derivco Technical test

Implemented Requirements:
* Create a Dockerfile for the application
* Create a Docker Compose file for the application with 1 HAProxy instance load balancing
traffic across 3 instances of the application above Docker Compose environment
* Document the solution to make it easy to onboard new developers to the project
* Document the HTTP API

## Docker

There are two docker files, one for the application and another for the proxy.

### Elixir Dockerfile

The main application docker file takes advantage of [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/ "Use milti-stage build"). In first stage the the build extends from `elixir:1.6-alpine` which contains all the requirements for generating the app release.

Once a release has been generated it is copied from the build mentioned above into another stage that inherits from `alpine:latest`. This proccess allow producing the final images as much slim as possible.

This docker file also contains an entrypoint. This has been added to be able view the logs produceby the application on the terminal wher `docker-compose up` was run. To do this the entrypoint executes the release and then redirects the output to ```/stdeout```.

```bash
echo "Running $@" 
exec "$@" > /dev/stdout
```

### haproxy Dockerfile

This docker file is simplier. It extends from `haproxy:1.7-alpine`, so it is also slim because is the alpine version. Then it copies the config file from `haproxy/haproxy.cfg`.

### haproxy configuration

The global and dafults configuration has been copied from the [examples](https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#2.5) section in the docs. 

There is an special configuration set in this file to be able to run docker-compose with the --scale parameter. This configuration defines a dns resolver that points to `127.0.0.11:53` which the ip where docker dns server is listening to.

```config
resolvers dns
  nameserver docker_dns 127.0.0.11:53
  resolve_retries       3
  timeout retry         1s
  ...
```

## Elixir application

The elixir code has been implemented in two applications under an umbrella project. Both applications are supervised. The `RegularChampionship` application is a `GenServer` that loads the `data.csv` file on it's initialitzation and stores the data in it's state.

The csv rows are mapped into strucs defined in this application. This has done this way to take advantage of combining them with elixir protocols. This makes the code of the send and encode `Plug` quite close to modification but it can easily be extended by creating more structs and more protocol implementations that define the way those structs need to be encoded.

This is not part of `RegularChampionship`, but helps understand the objective behind mapping everyhting into structs.

Plug
```elixir
defmodule Api.Router do
  .....

  plug(EncodeSend)
end
```

```elixir
  defp format_output("application/json", data), do: Json.encode(data)
  defp format_output("application/octet-stream", data), do: Protobuf.encode(data)
  defp format_output("application/protobuf", data), do: Protobuf.encode(data)
end
```

## Regular championship dependency tree

```bash
regular_championship
├── elixir
├── logger
│   └── elixir
├── runtime_tools
├── exprotobuf
│   ├── elixir
│   └── gpb
├── poison
│   └── elixir
└── csv
    ├── elixir
    └── parallel_stream
        └── elixir
```

The `Api` project contains the minimal required packages to implement an http server with a routing system. `Plug` has been used to implement the different middlewares. It also contains the ```protocols``` and their implementation to achive the encoding by struct mentioned above.

The api router:

```elixir

defmodule Api.Router do
  alias Api.{Plug.ContentAccept, Plug.EncodeSend, Controller}
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(:match)
  plug(ContentAccept)
  plug(:dispatch)

  get "/league-season" do
    Controller.league_season(conn)
  end

  get "/league/:league/season/:season" do
    Controller.results(conn)
  end

  match _ do
    Controller.respond_not_found(conn, "Route not found")
  end

  plug(EncodeSend)
end
```

## Api dependency tree
```bash
api
├── elixir
├── logger
│   └── elixir
├── cowboy
│   ├── crypto
│   ├── cowlib
│   │   └── crypto
│   └── ranch
│       └── ssl
│           ├── crypto
│           └── public_key
│               ├── asn1
│               └── crypto
├── plug
│   ├── elixir
│   ├── logger
│   ├── mime
│   │   ├── elixir
│   │   └── logger
│   └── plug_crypto
│       ├── elixir
│       └── crypto
├── plug_cowboy
│   ├── elixir
│   ├── logger
│   ├── cowboy
│   └── plug
└── poison
    └── elixir
```

## Make file

To make easier the development proces and help other developers set their environment
a Makefile with useful tasks has been implemented

```
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

build: ## builds the image containing the release
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
```

## Notes

* pre_commit package has been added to run ```mix format``` and ```mix test``` before each commit this package overrides the pre-commit hook.
* there is a `.tool_versions` file in the umbrella root path, run asdf install to ensure use the same versions defined at an application level.

Enjoy!
