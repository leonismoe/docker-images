#!/bin/sh

set -e

PROJECT_DIR="$1"
if [ -z "$PROJECT_DIR" ]; then
    echo "usage: $0 <project-path>" >&2
    exit 1
fi

if [ -f "$PROJECT_DIR/.srcinfo" ]; then
    . "$PROJECT_DIR/.srcinfo"
fi

if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="$(basename "$PROJECT_DIR")"
fi

if [ -z "$DOCKER_REPO" ]; then
    if [ ! -z "$DOCKERHUB_NAMESPACE" ]; then
        DOCKER_REPO="$DOCKERHUB_NAMESPACE/$PROJECT_NAME"
    elif [ ! -z "$GHCR_REPO" ]; then
        DOCKER_REPO="$GHCR_REPO"
    elif [ ! -z "$GHCR_NAMESPACE" ]; then
        DOCKER_REPO="$GHCR_NAMESPACE/$PROJECT_NAME"
    else
        DOCKER_REPO="localhost/$PROJECT_NAME"
    fi
fi

if [ -f "$PROJECT_DIR/test.sh" ]; then
    cd $PROJECT_DIR
    DOCKER_REPO="$DOCKER_REPO" ./test.sh

elif [ -f "$PROJECT_DIR/build.sh" ]; then
    cd $PROJECT_DIR
    TEST=1 DOCKER_REPO="$DOCKER_REPO" ./build.sh

elif [ -f "$PROJECT_DIR/subprojects.txt" ]; then
    echo "error: project $(dirname "$PROJECT_DIR") contains sub projects, please test them individually" >&2
    exit 1

elif [ -f "$PROJECT_DIR/Dockerfile" ]; then
    cd $PROJECT_DIR

    docker buildx build --pull -t $DOCKER_REPO:test .
    docker rmi $DOCKER_REPO:test

else
    echo "error: $PROJECT_DIR does not contain a build.sh or Dockerfile" >&2
    exit 1
fi
