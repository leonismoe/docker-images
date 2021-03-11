FROM mhart/alpine-node:10 AS build

RUN set -xe \
    && apk add --update git vim make gcc musl-dev qpdf \
    && mkdir /build

WORKDIR /build
COPY httpd.c /build

RUN set -xe \
    && git clone --depth=1 https://github.com/BR903/ELFkickers.git \
    && cd ELFkickers \
    && make install PROGRAMS=sstrip

ARG CHECKOUT_VERSION

RUN set -xe \
    && git clone https://github.com/mayswind/AriaNg.git \
    && cd AriaNg \
    && export LATEST_VERSION=`git tag --sort=v:refname | grep '^\d' | tail -n1` \
    && export VERSION="${CHECKOUT_VERSION:-$LATEST_VERSION}" \
    && echo VERSION=$VERSION > /build/.env \
    && echo LATEST_VERSION=$LATEST_VERSION >> /build/.env \
    && git checkout $VERSION \
    && npm i \
    && npx gulp build-bundle \
    && cd .. \
    && zlib-flate -compress < AriaNg/dist/index.html > index.html.deflate \
    && xxd -i index.html.deflate > index_html_deflate.c \
    && sed -i "s/\\\${CONTENT_LENGTH}/$(stat -c%s index.html.deflate)/" httpd.c \
    && gcc -Os --static -s -fno-stack-protector -ffunction-sections -fdata-sections -Wl,--gc-sections httpd.c -o httpd \
    && sstrip httpd


FROM scratch

COPY --from=build /build/httpd /ariang

ARG VERSION
LABEL version=${VERSION}

EXPOSE 8080
CMD ["/ariang"]
