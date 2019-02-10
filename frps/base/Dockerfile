FROM golang:1.12-rc

ARG VERSION

ENV GOPATH=/go \
    SRC_ROOT=$GOPATH/src/github.com/fatedier/frp \
    DIST_ROOT=/frp-dist

RUN apt-get update \
    && apt-get upgrade -y \
    && git clone https://github.com/fatedier/frp.git $SRC_ROOT \
    && cd $SRC_ROOT \
    && export LATEST_VERSION=`git tag --sort=v:refname | grep '^v' | tail -n1 | tr -d v` \
    && export VERSION="${VERSION:-$LATEST_VERSION}" \
    && export VCS_REF=`git rev-list --abbrev-commit -1 v$VERSION` \
    && export BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    && export CGO_ENABLED=0 \
    && export GOOS=linux \
    && export LDFLAGS='-s -w' \
    && export GOARCH=386      && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=amd64    && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=arm      && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=arm64    && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=mips64   && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=mips64le && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=mips     && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && export GOARCH=mipsle   && go build -ldflags "$LDFLAGS" -o $DIST_ROOT/$GOARCH/frps ./cmd/frps \
    && cp -rf ./conf $DIST_ROOT/ \
    && cp -rf ./assets/static $DIST_ROOT/ \
    && echo $LATEST_VERSION > $DIST_ROOT/.LATEST_VERSION \
    && echo $VERSION > $DIST_ROOT/.VERSION \
    && echo $VCS_REF > $DIST_ROOT/.VCS_REF \
    && echo $BUILD_DATE > $DIST_ROOT/.BUILD_DATE
