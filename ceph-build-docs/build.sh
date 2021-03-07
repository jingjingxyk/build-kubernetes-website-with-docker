#!/bin/bash
day=`date "+%Y%m%d"`
day=`date "+%Y%m%d%H%M"`
image="wenba100xie/ceph-docs:${day}"
export DOCKER_BUILDKIT=1
docker build -t $image  -f Dockerfile .
docker push $image


ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:ceph-docs-${day}"
docker tag $image $ali_image
docker push $ali_image
