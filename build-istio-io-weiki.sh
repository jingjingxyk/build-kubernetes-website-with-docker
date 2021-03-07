#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip


git clone https://github.com/istio/istio.io.git


#istio-io website
cd istio.io
#ls -lah
git pull
make build
cd ..
istio_io_image="docker.io/wenba100xie/istio-io-websiete-mirror:$Day";
docker build -t $istio_io_image -f Dockerfile-Istio-io .
docker push $istio_io_image
ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:istio-io-websiete-mirror-$Day"
docker tag $istio_io_image $ali_image
#docker push $ali_image
