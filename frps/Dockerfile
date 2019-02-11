FROM scratch

# see `hooks` and `base/Dockerfile` for details
COPY frp-builds/amd64/frps /
COPY frp-builds/static /static
COPY frp-builds/conf/frps_full.ini /etc/frps.ini

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      maintainer="Leonismoe <leonismoe@gmail.com>" \
      org.label-schema.name="frps" \
      org.label-schema.version=$VERSION \
      org.label-schema.url="https://github.com/fatedier/frp" \
      org.label-schema.description="A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet." \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/fatedier/frp.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name frps --restart=always -p 7000:7000 -p 7000:7000/udp -p 7001:7001/udp -v /path/to/frps.ini:/etc/frps.ini leonismoe/frps"

EXPOSE 80/tcp 443/tcp 3001/tcp 3001/udp 3003/tcp 3003/udp 7000/tcp 7000/udp 7001/udp 7500/tcp

CMD ["/frps", "-c", "/etc/frps.ini"]
