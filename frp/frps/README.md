# frps
[frp](https://github.com/fatedier/frp) server for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps) [![](https://images.microbadger.com/badges/version/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps)

# Usage
``` sh
docker run -d --name frps --restart=unless-stopped -v /path/to/frps.ini:/etc/frps.ini leonismoe/frps
```

Note: You should publish the ports you needed. For example:
``` sh
docker run -d --name frps --restart=unless-stopped \
  -p 7000:7000 \
  -p 7000:7000/udp \
  -p 7001:7001/udp \
  -p 7500:7500 \
  -p 8000-10000:8000-10000 \
  -p 8000-10000:8000-10000/udp \
  -v /path/to/frps.ini:/etc/frps.ini \
  leonismoe/frps
```

## Supported architectures
* `linux/amd64`
* `linux/i386`
* `linux/arm`
* `linux/arm64`
* `linux/mips64`
* `linux/mips64le`
* `linux/mips` (manifest unsuppported)
* `linux/mipsle` (manifest unsuppported)

## Breaking Changes
Starting from `v0.35.1`:
* `linux/amd64` and `linux/x86_64` images are now prefixed with `amd64-`
* `linux/386` images are now prefixed with `386-` rather than `i386-`
* non-prefixed and `latest` images now support multiarch (excluding `mips` and `mipsle`)
