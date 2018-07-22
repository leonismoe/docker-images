# frpc
[frp](https://github.com/fatedier/frp) client for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc) [![](https://images.microbadger.com/badges/version/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc)

## Supported architectures
* `x86_64`, `amd64`
* `i386`
* `arm32v6`
* `arm64v8`

## Latest tags
* `x86_64-${VERSION}`, `amd64-${VERSION}`, `x86_64-latest`, `amd64-latest`, `${VERSION}`, `latest`
* `i386-${VERSION}`, `i386-latest`
* `arm32v6-${VERSION}`, `arm32v6-latest`
* `arm64v8-${VERSION}`, `arm64v8-latest`

# Run
``` sh
docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc
```
