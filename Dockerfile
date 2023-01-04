FROM alpine AS build-c

RUN apk update && apk add gcc musl-dev
ADD . /src
RUN cc -Wall -static /src/addmount.c -o /src/addmount

FROM golang:alpine AS build-go
ENV CGO_ENABLED=0
WORKDIR /src
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go build -trimpath -ldflags="-s -w" -o bin/addmountserver

FROM alpinelinux/docker-cli

RUN apk update && apk add jq
COPY ./add-mount-helper.sh /usr/local/bin/
COPY --from=build-c /src/addmount /usr/local/bin/
COPY --from=build-go /src/bin/addmountserver /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/addmountserver"]
