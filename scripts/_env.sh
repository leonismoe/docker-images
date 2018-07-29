#!/bin/sh

cd frp
export FRP_LATEST_VERSION=`git tag --sort=v:refname | grep '^v' | tail -n1 | tr -d v`
export FRP_VERSION="${FRP_VERSION:-$FRP_LATEST_VERSION}"
export FRP_VCS_REF=`git rev-list --abbrev-commit -1 v$FRP_VERSION`
cd ..

export DOCKER_BUILD_OPTS="--build-arg BUILD_DATE=$FRP_DOCKER_IMAGE_BUILD_DATE --build-arg VCS_REF=$FRP_VCS_REF --build-arg VERSION=$FRP_VERSION"
if [ ! -z "$DOCKERFILE_PATH" ]; then
    export DOCKER_BUILD_OPTS="--file $DOCKERFILE_PATH $DOCKER_BUILD_OPTS"
fi
