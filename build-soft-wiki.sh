#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip
sudo git clone  https://github.com/ceph/ceph.git
cd  ceph
sudo  sh -c '/bin/echo -e "\ny\ny"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc

ls  -lh  ./build-doc
sudo mv   ./build-doc/output ../ceph-build-docs/ceph-output

cd ..
cd ceph-build-docs
sh docker-build.sh
cd ..

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
docker push $ali_image


git clone https://github.com/projectcalico/calico.git

##calico-docs
calico_io_image="docker.io/wenba100xie/projectcalico-docs:$Day";
docker build -t $calico_io_image -f Dockerfile-calico-io .
docker push calico_io_image

ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:projectcalico-docs-$Day"
docker tag $calico_io_image $ali_image
docker push $ali_image
