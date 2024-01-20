# frpc

[frp](https://github.com/fatedier/frp) is a fast reverse proxy that allows you to expose a local server located behind a NAT or firewall to the Internet. It currently supports **TCP** and **UDP**, as well as **HTTP** and **HTTPS** protocols, enabling requests to be forwarded to internal services via domain name.

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/leonismoe/frpc) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/leonismoe/frpc)

## Usage

``` sh
docker run -d --name frpc --restart=always -v /path/to/frpc.toml:/etc/frpc.toml leonismoe/frpc
```
