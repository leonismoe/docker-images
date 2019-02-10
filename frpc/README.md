# frpc
[frp](https://github.com/fatedier/frp) client for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc) [![](https://images.microbadger.com/badges/version/leonismoe/frpc.svg)](https://microbadger.com/images/leonismoe/frpc)

## Supported architectures
* `x86_64`, `amd64`
* `i386` (Prefixed with `i386-`)
* `arm`
  * 32 bits (eg. `armv6`, `armv7`): `arm-`
  * 64 bits (eg. `armv8`): `arm64-`
* `mips`
  * 32 bits, big endian: `mips-`
  * 32 bits, little endian: `mipsle-`
  * 64 bits, big endian: `mips64-`
  * 64 bits, little endian: `mips64le-`

## Breaking Changes
Starting from `v0.23.3`:
1. Base image was changed from `alpine` to `scratch`
2. Program `/usr/local/frp/frpc` was moved to `/frpc`
3. The following architecture prefixes were changed:
   * `arm32v6` -> `arm`
   * `arm64v8` -> `arm64`

# Usage
``` sh
docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc
```
