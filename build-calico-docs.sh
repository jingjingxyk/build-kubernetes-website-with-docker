#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`



git clone https://github.com/projectcalico/calico.git

##calico-docs
calico_io_image="docker.io/wenba100xie/projectcalico-docs:$Day";
docker build -t $calico_io_image -f Dockerfile-calico-io .
docker push calico_io_image

ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:projectcalico-docs-$Day"
docker tag $calico_io_image $ali_image
#docker push $ali_image
