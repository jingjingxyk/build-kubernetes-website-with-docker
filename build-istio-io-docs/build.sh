#!/bin/env sh

day=`date "+%Y%m%d"`
istio_io_image="docker.io/wenba100xie/istio-io-websiete-mirror:$day";

docker build -t $istio_io_image -f Dockerfile . --progress=plain
docker push $istio_io_image
ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:istio-io-websiete-mirror-$day"
docker tag $istio_io_image $ali_image
#docker push $ali_image
