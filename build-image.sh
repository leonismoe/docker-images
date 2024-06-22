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

if [ -z "$GHCR_REPO" ] && [ ! -z "$GHCR_NAMESPACE" ]; then
    GHCR_REPO="$GHCR_NAMESPACE/$PROJECT_NAME"
fi

if [ -z "$DOCKER_REPO" ]; then
    if [ ! -z "$DOCKERHUB_NAMESPACE" ]; then
        DOCKER_REPO="$DOCKERHUB_NAMESPACE/$PROJECT_NAME"
    elif [ ! -z "$GHCR_REPO" ]; then
        DOCKER_REPO="$GHCR_REPO"
    fi
fi

if [ -z "$DOCKER_REPO" ]; then
    echo "error: DOCKER_REPO is not set" >&2
    exit 1
fi

if [ -f "$PROJECT_DIR/build.sh" ]; then
    cd "$PROJECT_DIR"
    DOCKER_REPO="$DOCKER_REPO" GHCR_REPO="$GHCR_REPO" ./build.sh

elif [ -f "$PROJECT_DIR/subprojects.txt" ]; then
    echo "error: project $(dirname "$PROJECT_DIR") contains sub projects, please build them individually" >&2
    exit 1

elif [ -f "$PROJECT_DIR/Dockerfile" ]; then
    cd "$PROJECT_DIR"

    VERSION="$(grep -oP '(?<=ARG VERSION=)\S+' Dockerfile | head -n1)"
    PLATFORM=linux/amd64,linux/arm64,linux/arm/v7,linux/386,linux/riscv64
    if [ -f supported-platforms.txt ]; then
        PLATFORM="$(paste -sd',' supported-platforms.txt)"
    elif [ -f "../supported-platforms.txt" ]; then
        PLATFORM="$(paste -sd',' ../supported-platforms.txt)"
    fi

    set -x

    docker buildx build --pull --push \
        -t "$DOCKER_REPO:$VERSION" \
        --platform "$PLATFORM" \
        .

    if [ "$LATEST" = '1' ]; then
        docker buildx imagetools create -t "$DOCKER_REPO:latest" "$DOCKER_REPO:$VERSION"
    fi

    if [ ! -z "$GHCR_REPO" ] && [ "$GHCR_REPO" != "$DOCKER_REPO" ]; then
        docker buildx imagetools create -t "$GHCR_REPO:$VERSION" "$DOCKER_REPO:$VERSION"

        if [ "$LATEST" = '1' ]; then
            docker buildx imagetools create -t "$GHCR_REPO:latest" "$GHCR_REPO:$VERSION"
        fi
    fi

else
    echo "error: $PROJECT_DIR does not contain a build.sh or Dockerfile" >&2
    exit 1
fi
