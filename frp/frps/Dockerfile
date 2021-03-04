FROM golang AS build

ENV GO111MODULE=on \
    GOPATH=/go \
    SRC_ROOT=$GOPATH/src/github.com/fatedier/frp \
    DIST_ROOT=/build

# download sources
RUN set -xe \
    && git clone https://github.com/fatedier/frp.git $SRC_ROOT

# checkout version
ARG VERSION
RUN set -xe \
    && cd $SRC_ROOT \
    && export LATEST_VERSION=`git tag --sort=v:refname | grep '^v' | tail -n1 | tr -d v` \
    && export VERSION="${VERSION:-$LATEST_VERSION}" \
    && echo VERSION=$VERSION > $DIST_ROOT/.env \
    && echo LATEST_VERSION=$LATEST_VERSION >> $DIST_ROOT/.env \
    && echo "VCS_REF=$(git rev-list --abbrev-commit -1 v$VERSION)" >> $DIST_ROOT/.env \
    && echo "BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" >> $DIST_ROOT/.env \
    && git checkout v$VERSION

# prepare static resources
RUN set -xe \
    && cd $SRC_ROOT \
    && cp -rf ./conf $DIST_ROOT/ \
    && make file

# cross build
ARG OS
ARG ARCH
RUN set -xe \
    && cd $SRC_ROOT \
    && source $DIST_ROOT/.env \
    && [ ! -z "$ARCH" ] && GOOS=$OS GOARCH=$ARCH go build -trimpath -ldflags "$LDFLAGS" -o $DIST_ROOT/frps ./cmd/frps


FROM scratch

COPY --from=build /build/frps /frps
COPY --from=build /build/conf/frps_full.ini /etc/frps.ini

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      maintainer="Leonismoe <leonismoe@gmail.com>" \
      org.label-schema.name="frps" \
      org.label-schema.version=$VERSION \
      org.label-schema.description="A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet." \
      org.label-schema.url="https://github.com/fatedier/frp" \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/fatedier/frp.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name frps --restart=always -p 7000:7000 -p 7000:7000/udp -p 7001:7001/udp -v /path/to/frps.ini:/etc/frps.ini leonismoe/frps"

CMD ["/frps", "-c", "/etc/frps.ini"]
