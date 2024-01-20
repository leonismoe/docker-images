# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM node:lts AS build

ARG GIT_BRANCH

RUN <<EOF
    set -ex
    if [ ! -z "$NPM_REGISTRY" ]; then
        npm config set registry $NPM_REGISTRY
    fi

    mkdir -p /build
    cd /build
    git clone --depth 1 --branch $GIT_BRANCH https://github.com/mayswind/AriaNg.git
    cd AriaNg
    npm install
    npm run build
EOF

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM alpine:edge AS xbuild

COPY --from=xx / /

RUN <<EOF
    set -ex
    if [ ! -z "$APK_MIRROR" ]; then
        sed -i "s/dl-cdn.alpinelinux.org/$APK_MIRROR/g" /etc/apk/repositories
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

    apk add clang git libcap lld make
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
    make darkhttpd-static CC=xx-clang CFLAGS='-Os -D_FORTIFY_SOURCE=2 -Dstrip=true -fstack-clash-protection -fstack-protector-strong -pipe -Wall -Wextra -Werror=format-security -Werror=implicit-function-declaration -Wl,-z,defs -Wl,-z,now -Wl,-z,relro -Wl,-z,noexecstack'
    setcap cap_net_bind_service=+ep darkhttpd-static
    sstrip darkhttpd-static || true
    xx-verify darkhttpd-static

    mkdir -p /build/root/etc
    cp darkhttpd-static /build/root/darkhttpd
    echo 'nobody:x:65534:65534:nobody:/www:/darkhttpd' > /build/root/etc/passwd
    echo 'nobody:x:65534:' > /build/root/etc/group
EOF

COPY --from=build /build/AriaNg/dist /build/root/www

FROM scratch

COPY --from=xbuild /build/root/ /

ARG VERSION
LABEL version=${VERSION}

EXPOSE 8080

ENTRYPOINT ["/darkhttpd"]
CMD ["/www", "--chroot", "--uid", "nobody", "--gid", "nobody", "--port", "8080"]
