FROM scratch

# see `hooks` and `base/Dockerfile` for details
COPY frp-builds/amd64/frpc /
COPY frp-builds/conf/frpc.ini /etc/frpc.ini

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      maintainer="Leonismoe <leonismoe@gmail.com>" \
      org.label-schema.name="frpc" \
      org.label-schema.version=$VERSION \
      org.label-schema.url="https://github.com/fatedier/frp" \
      org.label-schema.description="A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet." \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/fatedier/frp.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc"

CMD ["/frpc", "-c", "/etc/frpc.ini"]
