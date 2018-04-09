FROM alpine

RUN apk --no-cache add curl jq && \
    FRP_RELEASE_DATA=$(curl https://api.github.com/repos/fatedier/frp/releases/latest | jq -r '.assets[] | select(.name | contains("linux_amd64"))') && \
    FRP_TARBALL_FILE=$(echo $FRP_RELEASE_DATA | jq -r '.name') && \
    echo $FRP_RELEASE_DATA | jq -r '.browser_download_url' | xargs curl -LO && \
    apk --no-cache del curl jq && \
    tar zxf $FRP_TARBALL_FILE && \
    rm -f $FRP_TARBALL_FILE && \
    mv $(basename $FRP_TARBALL_FILE .tar.gz) /usr/local/frp && \
    cp /usr/local/frp/frps_full.ini /etc/frps.ini

EXPOSE 80/tcp 443/tcp 3001/tcp 3001/udp 3003/tcp 3003/udp 7000/tcp 7000/udp 7001/udp 7500/tcp

CMD ["/usr/local/frp/frps", "-c", "/etc/frps.ini"]
