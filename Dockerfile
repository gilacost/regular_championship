FROM elixir:alpine

#elixir compilation and assets compilation
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm PHOENIX_SUBDIR=apps/website APP_NAME=padelify
WORKDIR /opt/app
RUN mix local.rebar --force \
    && mix local.hex --force
COPY . .
RUN mix do deps.get, deps.compile, compile
RUN mix release --env=prod --verbose \
    && mv _build/prod/rel/${APP_NAME} /opt/release \
    && mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server

#final ultra slim build
FROM alpine:latest
RUN apk update && apk --no-cache --update add bash openssl-dev
ENV PORT=8080 MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
EXPOSE ${PORT}
COPY --from=0 /opt/release .
CMD ["/opt/app/bin/start_server", "foreground"]
