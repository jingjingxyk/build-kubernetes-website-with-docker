#!/bin/env bash

set -e
export DOCKER_BUILDKIT=1
TIME=`date "+%Y%m%d"`
VERSION=${TIME}
IMAGE="wenba100xie/janus:${VERSION}"

docker build -t "$IMAGE" -f Dockerfile .
docker push "$IMAGE"

aliyun_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:janus-${VERSION}";
docker tag ${IMAGE} $aliyun_image
#docker push $aliyun_image
