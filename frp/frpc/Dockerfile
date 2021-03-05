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
    && go mod download \
    && cp -rf ./conf $DIST_ROOT/

# cross build
ARG OS
ARG ARCH
ARG GOMIPS
RUN set -xe \
    && cd $SRC_ROOT \
    && . $DIST_ROOT/.env \
    && GOOS=$OS GOARCH=$ARCH go build -trimpath -ldflags "$LDFLAGS" -o $DIST_ROOT/frpc ./cmd/frpc


FROM scratch

COPY --from=build /build/frpc /frpc
COPY --from=build /build/conf/frpc.ini /etc/frpc.ini

ARG VERSION

LABEL version=$VERSION

CMD ["/frpc", "-c", "/etc/frpc.ini"]
