FROM elixir:1.6-alpine as builder

ARG API_VSN
ARG REGULAR_CHAMPIONSHIP_VSN
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm APP_NAME=derivco
ENV REGULAR_CHAMPIONSHIP_VSN=$REGULAR_CHAMPIONSHIP_VSN
ENV API_VSN=$API_VSN
RUN env
WORKDIR /opt/app
RUN mix local.rebar --force \
    && mix local.hex --force
COPY . .
RUN mix do deps.get, deps.compile, compile
RUN mix release --env=prod --verbose \
    && mv _build/prod/rel/${APP_NAME} /opt/release \
    && mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server

FROM alpine:latest
ARG API_VSN
RUN env
RUN apk update && apk --no-cache --update add bash openssl-dev
RUN touch "/opt/app/lib/api-${API_VSN}/log/info.log"
RUN ln -sf "/dev/stdout /opt/app/lib/api-${API_VSN}/log/info.log"
ENV PORT=80 MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
COPY --from=builder /opt/release .
