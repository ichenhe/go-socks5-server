FROM golang:1.18-alpine as builder

RUN apk --no-cache add ca-certificates

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o app . && \
    mv -f app /usr/local/bin/app

FROM alpine:latest as prod

RUN apk --no-cache add ca-certificates tzdata

RUN mkdir -p /root/go-socks5
WORKDIR /root/go-socks5
COPY --from=builder /usr/local/bin/app .
RUN chmod +x ./app

CMD ["./app"]
