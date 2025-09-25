# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM golang:1.25 AS build

COPY --from=xx / /

SHELL ["/bin/bash", "-c"]

ENV GO111MODULE=on \
    GOPATH=/go \
    SRC_ROOT=$GOPATH/src/github.com/fatedier/frp \
    CGO_ENABLED=0 \
    LDFLAGS="-s -w"

ARG VERSION=0.65.0 # github-releases/fatedier/frp

RUN --mount=type=tmpfs,target=/tmp \
    <<EOF
    set -xe
    mkdir -p "$SRC_ROOT"
    curl -Lo /tmp/frp.tar.gz "https://github.com/fatedier/frp/archive/refs/tags/v${VERSION}.tar.gz"
    tar -zxf /tmp/frp.tar.gz --strip-components=1 -C "$SRC_ROOT"
    cd $SRC_ROOT
    go mod download
EOF

COPY frp-autoconf.go /go/

ARG TARGETPLATFORM
ARG TARGETARCH

RUN <<EOF
    set -xe
    cd $SRC_ROOT

    xx-go --wrap
    if [ "$TARGETARCH" = "mips" ] || [ "$TARGETARCH" = "mipsle" ]; then
        export GOMIPS=softfloat
    fi

    make frpc
    strip bin/frpc || true
    xx-verify bin/frpc
    mkdir -p /build/usr/bin
    cp bin/frpc /build/usr/bin/frpc

    mkdir -p /build/etc
    cp ./conf/frpc.toml /build/etc/frpc.toml

    go build -trimpath -ldflags "$LDFLAGS" -o /build/frp-autoconf /go/frp-autoconf.go
    strip /build/frp-autoconf || true
    xx-verify /build/frp-autoconf
    xx-go --unwrap
EOF

FROM scratch

COPY --from=build /build/ /

ARG VERSION=0.65.0 # github-releases/fatedier/frp
LABEL version=${VERSION}

ENTRYPOINT ["/frp-autoconf"]
CMD ["/usr/bin/frpc", "-c", "/etc/frpc.toml"]
