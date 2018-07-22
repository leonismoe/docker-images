FROM alpine

COPY --chown=root:root frp_linux /usr/local/frp/
RUN ln -s /usr/local/frp/frpc.ini /etc/frpc.ini

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      org.label-schema.name="frpc" \
      org.label-schema.version=$VERSION \
      org.label-schema.url="https://github.com/fatedier/frp" \
      org.label-schema.description="A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet." \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/fatedier/frp.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name frpc --restart=always -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc"

CMD ["/usr/local/frp/frpc", "-c", "/etc/frpc.ini"]
