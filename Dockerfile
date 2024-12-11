FROM nats:2.10.9-alpine3.19 AS nats
LABEL authors="jorgeley@silentpush.com"

RUN adduser nats --system
RUN chown -R nats:nogroup /etc/nats
RUN apk update
RUN apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go
COPY . .
USER nats
RUN touch /home/nats/nats.log
RUN go install github.com/nats-io/nats-top@latest

ENTRYPOINT nats-server -l /home/nats/nats.log --http_port 8222 -DV && /home/nats/go/bin/nats-top
