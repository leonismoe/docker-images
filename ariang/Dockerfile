FROM alpine AS prepare

RUN set -xe \
    && apk add --no-cache git make gcc libc-dev \
    && mkdir /build \
    && cd /build \
    && git clone --depth=1 https://github.com/BR903/ELFkickers.git \
    && cd ELFkickers \
    && make PROGRAMS=sstrip \
    && cp sstrip/sstrip /build \
    && cd .. \
    && rm -rf ELFkickers \
    && apk del make gcc libc-dev

WORKDIR /build
ARG CHECKOUT_VERSION
ARG NODE_VERSION=10.24.1

RUN set -xe \
    && apk add --no-cache curl xxd qpdf \
    && curl -sSO https://unofficial-builds.nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64-musl.tar.xz \
    && tar -Jxf node-v${NODE_VERSION}-linux-x64-musl.tar.xz \
    && rm -f node-v${NODE_VERSION}-linux-x64-musl.tar.xz \
    && export PATH=/build/node-v${NODE_VERSION}-linux-x64-musl/bin:$PATH \
    && git clone https://github.com/mayswind/AriaNg.git \
    && cd AriaNg \
    && export LATEST_VERSION=`git tag --sort=v:refname | grep '^\d' | tail -n1` \
    && export VERSION="${CHECKOUT_VERSION:-$LATEST_VERSION}" \
    && echo VERSION=$VERSION > /build/.env \
    && echo LATEST_VERSION=$LATEST_VERSION >> /build/.env \
    && git checkout $VERSION \
    && npm i \
    && npx gulp build-bundle \
    && cp dist/index.html /build/ \
    && cd /build \
    && rm -rf AriaNg node-v${NODE_VERSION}-linux-x64-musl \
    && zlib-flate -compress=9 < index.html > index.html.deflate \
    && xxd -i index.html.deflate > index_html_deflate.c \
    && apk del curl xxd qpdf

ARG MUSLCC_TARGET
FROM muslcc/x86_64:${MUSLCC_TARGET} AS build

COPY --from=prepare /build /build
COPY httpd.c /build

WORKDIR /build

RUN set -xe \
    && sed -i "s/\\\${CONTENT_LENGTH}/$(stat -c%s index.html.deflate)/" httpd.c \
    && gcc -Os --static -s -fno-stack-protector -ffunction-sections -fdata-sections -Wl,--gc-sections httpd.c -o httpd \
    && /build/sstrip httpd


FROM scratch

COPY --from=build /build/httpd /ariang

ARG VERSION
LABEL version=${VERSION}

EXPOSE 8080
CMD ["/ariang"]
