# frpc
[frp](https://github.com/fatedier/frp) client for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/leonismoe/frpc) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/leonismoe/frpc)

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
* `linux/amd64` and `linux/x86_64` images are now prefixed with `amd64-`
* `linux/386` images are now prefixed with `386-` rather than `i386-`
* non-prefixed and `latest` images now support multiarch (excluding `mips` and `mipsle`)
