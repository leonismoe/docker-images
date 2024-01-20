# frps

[frp](https://github.com/fatedier/frp) is a fast reverse proxy that allows you to expose a local server located behind a NAT or firewall to the Internet. It currently supports **TCP** and **UDP**, as well as **HTTP** and **HTTPS** protocols, enabling requests to be forwarded to internal services via domain name.

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/leonismoe/frps) ![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/leonismoe/frps)

## Usage

``` sh
docker run -d --name frps --restart=unless-stopped -v /path/to/frps.toml:/etc/frps.toml leonismoe/frps
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
  -v /path/to/frps.toml:/etc/frps.toml \
  leonismoe/frps
```
