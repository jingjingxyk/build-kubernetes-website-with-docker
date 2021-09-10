#!/bin/sh


TIME=`date "+%Y%m%d%H%M"`
TIME=`date "+%Y%m%d"`
VERSION="debian-10-buster-v1.10.x-"${TIME}
IMAGE="wenba100xie/freeswitch:${VERSION}"

export DOCKER_BUILDKIT=1
docker build -t ${IMAGE} -f Dockerfile . --build-arg proxy_url=$proxy_url --progress=plain
docker push ${IMAGE}
aliyun_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:freeswitch-debian-10-buster-v1.10.x-${VERSION}";
docker tag ${IMAGE} $aliyun_image
#docker push $aliyun_image
