#!/bin/bash

day=`date "+%Y%m%d%H%M"`
day=`date "+%Y%m%d"`
image="wenba100xie/ceph-docs:${day}"
export DOCKER_BUILDKIT=1
docker build -t $image  -f Dockerfile .  --progress=plain
docker push $image


ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:ceph-docs-${day}"
docker tag $image $ali_image
#docker push $ali_image
