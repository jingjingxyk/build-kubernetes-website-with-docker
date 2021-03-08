#!/bin/sh


TIME=`date "+%Y%m%d%H%M"`
TIME=`date "+%Y%m%d"`
VERSION="debian-10-buster-v1.10.x-"${TIME}
IMAGE="wenba100xie/freeswitch:${VERSION}"
export DOCKER_BUILDKIT=1
docker build -t ${IMAGE} -f Dockerfile .
docker push ${IMAGE}
