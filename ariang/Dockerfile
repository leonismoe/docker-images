# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM alpine:edge AS xbuild

COPY --from=xx / /

ARG VERSION=1.3.8 # github-releases/mayswind/AriaNg

RUN <<EOF
    set -ex
    if [ ! -z "$ALPINE_MIRROR_HOST" ]; then
        sed -i "s/dl-cdn.alpinelinux.org/$ALPINE_MIRROR_HOST/g" /etc/apk/repositories
    fi
EOF

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    --mount=type=cache,target=/var/lib/apk,sharing=locked \
    --mount=type=tmpfs,target=/var/cache \
    --mount=type=tmpfs,target=/var/lock \
    --mount=type=tmpfs,target=/var/log \
    --mount=type=tmpfs,target=/var/tmp \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/run \
    <<EOF
    set -ex

    apk add clang curl git libarchive-tools libcap lld make
EOF

RUN <<EOF
    set -ex

    mkdir -p /build
    cd /build
    git clone --depth 1 https://github.com/BR903/ELFkickers.git
    cd ELFkickers
    make PROGRAMS=sstrip
    cp sstrip/sstrip /usr/local/bin
EOF

RUN <<EOF
    set -ex

    mkdir -p /build
    cd /build
    git clone --depth 1 https://github.com/emikulic/darkhttpd.git
EOF

RUN <<EOF
    set -ex

    mkdir -p /build/root/www
    cd /build/root/www
    curl -Lo /tmp/ariang.zip "https://github.com/mayswind/AriaNg/releases/download/$VERSION/AriaNg-$VERSION.zip"
    bsdtar -xf /tmp/ariang.zip -C /build/root/www
EOF

ARG TARGETPLATFORM

RUN --mount=type=cache,target=/var/cache/apk,id=apk-cache-$TARGETARCH$TARGETVARIANT,sharing=locked \
    --mount=type=cache,target=/var/lib/apk,id=apk-lib-$TARGETARCH$TARGETVARIANT,sharing=locked \
    --mount=type=tmpfs,target=/var/cache \
    --mount=type=tmpfs,target=/var/lock \
    --mount=type=tmpfs,target=/var/log \
    --mount=type=tmpfs,target=/var/tmp \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/run \
    <<EOF
    set -ex

    xx-apk add gcc musl-dev
EOF

RUN <<EOF
    set -ex

    cd /build/darkhttpd
    make darkhttpd CC=xx-clang CFLAGS='-static -Os -D_FORTIFY_SOURCE=2 -Dstrip=true -fstack-clash-protection -fstack-protector-strong -pipe -Wall -Wextra -Werror=format-security -Werror=implicit-function-declaration -Wl,-z,defs -Wl,-z,now -Wl,-z,relro -Wl,-z,noexecstack'
    setcap cap_net_bind_service=+ep darkhttpd
    sstrip darkhttpd || true
    xx-verify darkhttpd

    mkdir -p /build/root/etc
    cp darkhttpd /build/root/darkhttpd
    echo 'nobody:x:65534:65534:nobody:/www:/darkhttpd' > /build/root/etc/passwd
    echo 'nobody:x:65534:' > /build/root/etc/group
EOF

FROM scratch

COPY --from=xbuild /build/root/ /

ARG VERSION=1.3.8 # github-releases/mayswind/AriaNg
LABEL version=${VERSION}

EXPOSE 8080

ENTRYPOINT ["/darkhttpd"]
CMD ["/www", "--chroot", "--uid", "nobody", "--gid", "nobody", "--port", "8080"]
