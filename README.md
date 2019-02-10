# frp
A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

## Supported architectures
* `x86_64`, `amd64` (No prefixes)
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
2. The following programs were moved:
   * `/usr/local/frp/frpc` -> `/frpc`
   * `/usr/local/frp/frps` -> `/frps`
3. The following architecture prefixes were changed:
   * `arm32v6` -> `arm`
   * `arm64v8` -> `arm64`
