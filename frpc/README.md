# frpc
[frp](https://github.com/fatedier/frp) client for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc) [![](https://images.microbadger.com/badges/version/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc)

## Supported architectures
* `x86_64`, `amd64`
* `i386` (Tags are prefixed with `i386-`)
* `arm32v6` (Tags are prefixed with `arm32v6-`)
* `arm64v8` (Tags are prefixed with `arm64v8-`)

# Usage
``` sh
docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc
```
