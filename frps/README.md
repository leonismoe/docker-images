# frps
[frp](https://github.com/fatedier/frp) server for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps) [![](https://images.microbadger.com/badges/version/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps)

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
docker run -d --name frps --restart=always -v /path/to/frps.ini:/etc/frps.ini leonismoe/frps
```

Note: You should publish the ports you needed. For example:
``` sh
docker run -d --name frps --restart=always \
  -p 7000:7000 \
  -p 7000:7000/udp \
  -p 7001:7001/udp \
  -p 7500:7500 \
  -p 8000-10000:8000-10000 \
  -p 8000-10000:8000-10000/udp \
  -v /path/to/frps.ini:/etc/frps.ini \
  leonismoe/frps
```
