# Build Instructions
``` sh
$ export FRP_DOCKER_IMAGE_BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
$ git clone https://github.com/fatedier/frp.git
$ cd frp
$ export FRP_LATEST_VERSION=`git tag --sort=v:refname | grep '^v' | tail -n1 | tr -d v`
$ [ -z "$FRP_VERSION" ] && export FRP_VERSION=$FRP_LATEST_VERSION
$ export FRP_VCS_REF=`git rev-list --abbrev-commit -1 v$FRP_VERSION`
$ cd ..

$ curl -LO https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz
$ tar zxf frp_${FRP_VERSION}_linux_amd64.tar.gz -C frps
$ tar zxf frp_${FRP_VERSION}_linux_amd64.tar.gz -C frpc
$ rm -f frps/frp_${FRP_VERSION}_linux_amd64/frpc*
$ rm -f frpc/frp_${FRP_VERSION}_linux_amd64/frps*

$ docker build --pull --tag leonismoe/frps:v$FRP_VERSION \
               --build-arg BUILD_DATE=$FRP_DOCKER_IMAGE_BUILD_DATE \
               --build-arg VCS_REF=$FRP_VCS_REF \
               --build-arg VERSION=$FRP_VERSION ./frps

$ docker build --pull --tag leonismoe/frpc:v$FRP_VERSION \
               --build-arg BUILD_DATE=$FRP_DOCKER_IMAGE_BUILD_DATE \
               --build-arg VCS_REF=$FRP_VCS_REF \
               --build-arg VERSION=$FRP_VERSION ./frpc

$ [ "$FRP_VERSION" == "$FRP_LATEST_VERSION" ] && docker tag leonismoe/frps:v$FRP_VERSION leonismoe/frps:latest
$ [ "$FRP_VERSION" == "$FRP_LATEST_VERSION" ] && docker tag leonismoe/frpc:v$FRP_VERSION leonismoe/frpc:latest
```
