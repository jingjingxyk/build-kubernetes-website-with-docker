#!/bin/env bash
set -eux

day=`date "+%Y%m%d"`

export DOCKER_BUILDKIT=1
##developer.chrome.com
developer_chrome_com_image="docker.io/wenba100xie/developer.chrome.com:$day";
docker build -t $developer_chrome_com_image -f Dockerfile .

docker push $developer_chrome_com_image

ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:developer.chrome.com-$day"

docker tag ${IMAGE} $aliyun_image



docker tag $developer_chrome_com_image $ali_image
#docker push $ali_image

