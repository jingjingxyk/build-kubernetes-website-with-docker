#!/bin/env bash
set -eux

day=`date "+%Y%m%d"`

export DOCKER_BUILDKIT=1
##calico-docs
calico_io_image="docker.io/wenba100xie/calico-docs:$day";
docker build -t $calico_io_image -f Dockerfile .

docker push $calico_io_image

ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:calico-docs-$day"
docker tag $calico_io_image $ali_image
#docker push $ali_image
