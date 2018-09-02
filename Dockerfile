FROM node:8 AS build-stage

ARG VERSION

RUN set -xe \
    && git clone https://github.com/mayswind/AriaNg.git \
    && cd AriaNg \
    && git checkout $VERSION \
    && node -v \
    && npm -v \
    && npm install -g gulp-cli \
    && npm install \
    && gulp clean build


FROM alpine

RUN set -xe  \
    && apk add --no-cache nginx tzdata \
    && mkdir -p /run/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY --chown=root:root nginx-ariang.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:www-data --from=build-stage /AriaNg/dist/ /usr/share/nginx/html/

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL version=$VERSION \
      maintainer="Leonismoe <leonismoe@gmail.com>" \
      org.label-schema.name="AriaNG" \
      org.label-schema.version=$VERSION \
      org.label-schema.url="https://github.com/mayswind/AriaNg" \
      org.label-schema.description="AriaNg, a modern web frontend making aria2 easier to use." \
      org.label-schema.build_date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/mayswind/AriaNg.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd="docker run -d --name ariang -p 6080:80 leonismoe/ariang"

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
