#!/bin/sh

cd AriaNg
export ARIANG_LATEST_VERSION=`git tag --sort=v:refname | tail -n1`
export ARIANG_VERSION="${ARIANG_VERSION:-$ARIANG_LATEST_VERSION}"
export ARIANG_VCS_REF=`git rev-list --abbrev-commit -1 $ARIANG_VERSION`
cd ..

export DOCKER_BUILD_OPTS="--build-arg BUILD_DATE=$ARIANG_DOCKER_IMAGE_BUILD_DATE --build-arg VCS_REF=$ARIANG_VCS_REF --build-arg VERSION=$ARIANG_VERSION"
if [ ! -z "$DOCKERFILE_PATH" ]; then
    export DOCKER_BUILD_OPTS="--file $DOCKERFILE_PATH $DOCKER_BUILD_OPTS"
fi
