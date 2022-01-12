#!/bin/env bash
set -eux

__CURRENT__=`pwd`
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

day=`date "+%Y%m%d"`

export DOCKER_BUILDKIT=1
##calico-docs
calico_io_image="docker.io/wenba100xie/calico-docs:$day";
cp ${__DIR__}/../robots.txt .
docker build -t $calico_io_image -f Dockerfile . --progress=plain

docker push $calico_io_image

ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:calico-docs-$day"



docker tag $calico_io_image $ali_image
#docker push $ali_image

