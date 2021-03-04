FROM golang AS build

SHELL ["/bin/bash", "-c"]

ENV GO111MODULE=on \
    GOPATH=/go \
    SRC_ROOT=$GOPATH/src/github.com/fatedier/frp \
    DIST_ROOT=/build \
    CGO_ENABLED=0 \
    LDFLAGS="-s -w"

# download sources
RUN set -xe \
    && git clone https://github.com/fatedier/frp.git $SRC_ROOT \
    && mkdir -p $DIST_ROOT

# checkout version
ARG VERSION
RUN set -xe \
    && cd $SRC_ROOT \
    && export LATEST_VERSION=`git tag --sort=v:refname | grep '^v' | tail -n1 | tr -d v` \
    && export VERSION="${VERSION:-$LATEST_VERSION}" \
    && echo VERSION=$VERSION >> $DIST_ROOT/.env \
    && echo LATEST_VERSION=$LATEST_VERSION >> $DIST_ROOT/.env \
    && echo "VCS_REF=$(git rev-list --abbrev-commit -1 v$VERSION)" >> $DIST_ROOT/.env \
    && echo "BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" >> $DIST_ROOT/.env \
    && git checkout v$VERSION

# prepare dependencies and static resources
RUN set -xe \
    && cd $SRC_ROOT \
    && go mod download -x \
    && cp -rf ./conf $DIST_ROOT/

# cross build
ARG OS
ARG ARCH
RUN set -xe \
    && cd $SRC_ROOT \
    && source $DIST_ROOT/.env \
    && GOOS=$OS GOARCH=$ARCH go build -trimpath -ldflags "$LDFLAGS" -o $DIST_ROOT/frpc ./cmd/frpc


FROM scratch

COPY --from=build /build/frpc /frpc
COPY --from=build /build/conf/frpc.ini /etc/frpc.ini

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      maintainer="Leonismoe <leonismoe@gmail.com>" \
      org.label-schema.name="frpc" \
      org.label-schema.version=$VERSION \
      org.label-schema.description="A fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet." \
      org.label-schema.url="https://github.com/fatedier/frp" \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/fatedier/frp.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name frpc --restart=always -p 7000:7000 -p 7000:7000/udp -p 7001:7001/udp -v /path/to/frpc.ini:/etc/frpc.ini leonismoe/frpc"

CMD ["/frpc", "-c", "/etc/frpc.ini"]
