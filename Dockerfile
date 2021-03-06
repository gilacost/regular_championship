#BUILD STAGE

# use alpine linux distribution for slim builds
FROM elixir:1.7-alpine as builder
# arguments received from docker-compose file, for some reason
# are not available if I run RUN env
ARG API_VSN
ARG REGULAR_CHAMPIONSHIP_VSN
ARG PERIC_VSN

RUN env

ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm APP_NAME=peric
ENV REGULAR_CHAMPIONSHIP_VSN=$REGULAR_CHAMPIONSHIP_VSN
ENV API_VSN=$API_VSN
ENV PERIC_VSN=$PERIC_VSN
WORKDIR /opt/app
RUN mix local.rebar --force \
    && mix local.hex --force
COPY . .

RUN mix do deps.get, deps.compile, compile
RUN mix release --env=prod --verbose\
    && mv _build/prod/rel/${APP_NAME} /opt/release \
    && mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server

#RELEASE STAGE
FROM alpine:latest
RUN apk update && apk --no-cache --update add bash openssl-dev
ENV PORT=80 MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
COPY --from=builder /opt/release .
COPY ./entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
