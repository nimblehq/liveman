ARG ELIXIR_IMAGE_VERSION=1.12.1
ARG ERLANG_IMAGE_VERSION=24.0.1
ARG RELEASE_IMAGE_VERSION=3.13.3

FROM hexpm/elixir:${ELIXIR_IMAGE_VERSION}-erlang-${ERLANG_IMAGE_VERSION}-alpine-${RELEASE_IMAGE_VERSION} AS build

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
      nodejs \
      npm \
      git \
      build-base && \
    mix local.rebar --force && \
    mix local.hex --force

WORKDIR /app

COPY . .

ENV MIX_ENV=prod

# Install and compile dependencies
RUN mix do deps.get, deps.compile

# Build assets
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# Compile and build app release
RUN mix do compile, release

#
# Release
#
FROM alpine:${RELEASE_IMAGE_VERSION} AS app

RUN apk update && \
    apk add --no-cache \
    libstdc++ \
    libgcc \
    bash \
    openssl-dev

WORKDIR /opt/app
EXPOSE 4000

RUN addgroup -g 1000 appuser && \
		adduser -u 1000 -G appuser -g appuser -s /bin/sh -D appuser && \
		chown 1000:1000 /opt/app

COPY --from=build --chown=1000:1000 /app/_build/prod/rel/liveman ./
COPY bin/start.sh ./bin/start.sh

USER appuser

CMD bin/start.sh
