FROM alpine

RUN apk --no-cache add curl jq && \
    FRP_RELEASE_DATA=$(curl https://api.github.com/repos/fatedier/frp/releases/latest | jq -r '.assets[] | select(.name | contains("linux_amd64"))') && \
    FRP_TARBALL_FILE=$(echo $FRP_RELEASE_DATA | jq -r '.name') && \
    echo $FRP_RELEASE_DATA | jq -r '.browser_download_url' | xargs curl -LO && \
    apk --no-cache del curl jq && \
    tar zxf $FRP_TARBALL_FILE && \
    rm -f $FRP_TARBALL_FILE && \
    mv $(basename $FRP_TARBALL_FILE .tar.gz) /usr/local/frp && \
    cp /usr/local/frp/frpc.ini /etc/frpc.ini

CMD ["/usr/local/frp/frpc", "-c", "/etc/frpc.ini"]
