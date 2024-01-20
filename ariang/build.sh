#!/bin/sh

set -e

DOCKER_REPO="${DOCKER_REPO:-leonismoe/ariang}"

LATEST=0

if [ -z "$VERSION" ]; then
    GIT_BRANCH="$(curl -fsSL https://github.com/mayswind/AriaNg/releases.atom | grep -oE 'releases/tag/[^"]+' | head -n1 | cut -d/ -f3)"
    VERSION=${GIT_BRANCH#v}
    LATEST=1
else
    GIT_BRANCH="$VERSION"
fi

docker buildx build --pull --push \
    -t $DOCKER_REPO:$VERSION \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v6,linux/arm/v7,linux/386,linux/ppc64le,linux/s390x,linux/riscv64 \
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
