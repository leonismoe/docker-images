# frp
A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet.

## Locally Build Instructions
``` sh
cd frpc
export DOCKER_REPO=leonismoe/frpc
./hooks/build
```

If using `zsh`, you need run the following commands first:
``` sh
set -o shwordsplit
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
