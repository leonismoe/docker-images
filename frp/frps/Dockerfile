# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM golang AS build

COPY --from=xx / /

SHELL ["/bin/bash", "-c"]

ENV GO111MODULE=on \
    GOPATH=/go \
    SRC_ROOT=$GOPATH/src/github.com/fatedier/frp \
    CGO_ENABLED=0 \
    LDFLAGS="-s -w"

ARG GIT_BRANCH

RUN <<EOF
    set -xe
    git clone --depth 1 --branch $GIT_BRANCH https://github.com/fatedier/frp.git $SRC_ROOT
    cd $SRC_ROOT
    go mod download
EOF

COPY frp-autoconf.go /go/

ARG TARGETPLATFORM
ARG TARGETARCH

RUN <<EOF
    set -xe
    cd $SRC_ROOT

    if [ "$TARGETARCH" = "mips" ] || [ "$TARGETARCH" = "mipsle" ]; then
        export GOMIPS=softfloat
    fi

    mkdir -p /build/etc
    xx-go build -trimpath -ldflags "$LDFLAGS" -o /build/frps ./cmd/frps
    strip /build/frps || true
    xx-verify /build/frps
    cp ./conf/frps.toml /build/etc/frps.toml

    xx-go build -trimpath -ldflags "$LDFLAGS" -o /build/frp-autoconf /go/frp-autoconf.go
    strip /build/frp-autoconf || true
    xx-verify /build/frp-autoconf
EOF

FROM scratch

COPY --from=build /build/ /

ARG VERSION
LABEL version=${VERSION}

ENTRYPOINT ["/frp-autoconf"]
CMD ["/frps", "-c", "/etc/frps.toml"]
