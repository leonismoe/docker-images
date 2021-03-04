# frpc
[frp](https://github.com/fatedier/frp) client for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc) [![](https://images.microbadger.com/badges/version/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc)

# Usage
``` sh
docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc
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
* `amd64` and `x86_64` images are prefixed with `amd64-`
* non-prefixed and `latest` images now support multiarch (excluding `mips` and `mipsle`)
