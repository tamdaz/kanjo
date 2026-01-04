# >>>>>> build

FROM crystallang/crystal:1.18.2-alpine AS build

WORKDIR /app

COPY shard.yml /app/
COPY src ./src
COPY public ./public
COPY templates ./templates

RUN apk add --no-cache sqlite sqlite-static \
    libmagic libmagic-static && \
    shards install && \
    shards build kanjo --release --static --no-debug --progress --stats

# <<<<<< build

# >>>>>> drift

FROM codeberg.org/tamdaz/drift:0.3.6 AS drift

# >>>>>> prod

FROM alpine:3.23 AS prod

LABEL org.opencontainers.image.source="https://github.com/tamdaz/kanjo"
LABEL org.opencontainers.image.description="A web application that stores the daily journals and assess emotions."

WORKDIR /app

COPY --from=build /app/bin/kanjo /app/bin/kanjo
COPY --from=build /app/public ./public
COPY --from=build /app/templates ./templates
COPY --from=drift /usr/local/bin/drift /usr/local/bin/drift

COPY database ./database
COPY docker-entrypoint.sh /app/

RUN mkdir -p /app/data

EXPOSE 3000

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]

# <<<<<< prod