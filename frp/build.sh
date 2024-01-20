#!/bin/sh

set -e

PROGRAM="$1"
if [ "$PROGRAM" != "frps" ] && [ "$PROGRAM" != "frpc" ]; then
    echo "usage: $0 <PROGRAM>" >&2
    echo >&2
    echo "  PROGRAM: frps or frpc" >&2
    exit 1
fi

DOCKER_REPO="${DOCKER_REPO:-"leonismoe/$PROGRAM"}"

LATEST=0

if [ -z "$VERSION" ]; then
    GIT_BRANCH="$(curl -fsSL https://github.com/fatedier/frp/releases.atom | grep -oE 'releases/tag/[^"]+' | head -n1 | cut -d/ -f3)"
    VERSION="${GIT_BRANCH#v}"
    LATEST=1
else
    VERSION="${VERSION#v}"
    GIT_BRANCH="v${VERSION}"
fi

docker buildx build --pull --push \
    -t $DOCKER_REPO:$VERSION \
    -f $PROGRAM/Dockerfile \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v6,linux/arm/v7,linux/386,linux/ppc64le,linux/s390x,linux/mips,linux/mipsle,linux/mips64,linux/mips64le,linux/riscv64 \
    --build-arg VERSION=$VERSION \
    --build-arg GIT_BRANCH=$GIT_BRANCH \
    .

if [ $LATEST -eq 1 ]; then
    docker buildx imagetools create -t $DOCKER_REPO:latest $DOCKER_REPO:$VERSION
fi

if [ ! -z "$GHCR_REPO" ]; then
    docker buildx imagetools create -t $GHCR_REPO:$VERSION $DOCKER_REPO:$VERSION
    if [ $LATEST -eq 1 ]; then
        docker buildx imagetools create -t $GHCR_REPO:latest $DOCKER_REPO:$VERSION
    fi
fi
