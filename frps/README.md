# frps
[frp](https://github.com/fatedier/frp) server for amd64 linux.

A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

[![](https://images.microbadger.com/badges/image/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps) [![](https://images.microbadger.com/badges/version/leonismoe/frps.svg)](https://microbadger.com/images/leonismoe/frps)

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
2. Program `/usr/local/frp/frps` was moved to `/frps`
3. The following architecture prefixes were changed:
   * `arm32v6` -> `arm`
   * `arm64v8` -> `arm64`

# Usage
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
