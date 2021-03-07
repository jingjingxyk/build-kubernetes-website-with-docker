#!/bin/env sh


istio_io_image="docker.io/wenba100xie/istio-io-websiete-mirror:$day";

docker build -t $istio_io_image -f Dockerfile .
docker push $istio_io_image
ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:istio-io-websiete-mirror-$day"
docker tag $istio_io_image $ali_image
#docker push $ali_image
