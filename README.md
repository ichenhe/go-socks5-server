# go-socks5-server

Simple socks5 server based on [things-go/go-socks5](https://github.com/things-go/go-socks5). Supports anonymous access or multi-user authentication.

## Quick Start

### Docker

```shell
docker run --name go-socks-server -p 1080:1080 -e GO_SOCKS_PORT=1080 -d ichenhe/go-socks5-server
```

## Configuration

Please add env variable to configure this server.

| Env Variable   | Default | Explain                                      |
| -------------- | ------- | -------------------------------------------- |
| TZ             | UTC     | Time Zone                                    |
| GO_SOCKS_PORT  | 1080    | Listening Port                               |
| GO_SOCKS_AUTHS | EMPTY   | `user1:pwd1:user2:pwd2`... EMPTY for no auth |

## Test

Run:

```shell
curl "https://github.com" --socks5 localhost:1080 -U "user:password"
```
