# Build Instructions
## frps
``` sh
$ export BUILD_DIR=frps-builds

$ cd frps
$ docker build --pull -t frps-temp --build-arg VERSION=0.24.0 ./base
$ ctid=$(docker create frps-temp)
$ docker cp $ctid:/frp-dist $(pwd)/$BUILD_DIR
$ docker rm -fv $ctid
$ docker rmi frps-temp

$ export DOCKER_REPO=leonismoe/frps
$ export BUILD_DATE=`cat $BUILD_DIR/.BUILD_DATE`
$ export LATEST_VERSION=`cat $BUILD_DIR/.LATEST_VERSION`
$ export VERSION=`cat $BUILD_DIR/.VERSION`
$ export VCS_REF=`cat $BUILD_DIR/.VCS_REF`

$ docker build -t $DOCKER_REPO:v$VERSION \
               --build-arg BUILD_DATE=$BUILD_DATE \
               --build-arg VCS_REF=$VCS_REF \
               --build-arg VERSION=$VERSION ./frps

$ rm -rf ./$BUILD_DIR
$ [ "$VERSION" == "$LATEST_VERSION" ] && docker tag $DOCKER_REPO:v$VERSION $DOCKER_REPO:latest
```

## frpc
``` sh
$ export BUILD_DIR=frpc-builds

$ cd frpc
$ docker build --pull -t frpc-temp --build-arg VERSION=0.24.0 ./base
$ ctid=$(docker create frpc-temp)
$ docker cp $ctid:/frp-dist $(pwd)/$BUILD_DIR
$ docker rm -fv $ctid
$ docker rmi frpc-temp

$ export DOCKER_REPO=leonismoe/frpc
$ export BUILD_DATE=`cat $BUILD_DIR/.BUILD_DATE`
$ export LATEST_VERSION=`cat $BUILD_DIR/.LATEST_VERSION`
$ export VERSION=`cat $BUILD_DIR/.VERSION`
$ export VCS_REF=`cat $BUILD_DIR/.VCS_REF`

$ docker build -t $DOCKER_REPO:v$VERSION \
               --build-arg BUILD_DATE=$BUILD_DATE \
               --build-arg VCS_REF=$VCS_REF \
               --build-arg VERSION=$VERSION ./frpc

$ rm -rf ./$BUILD_DIR
$ [ "$VERSION" == "$LATEST_VERSION" ] && docker tag $DOCKER_REPO:v$VERSION $DOCKER_REPO:latest
```
