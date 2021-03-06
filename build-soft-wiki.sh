#!/bin/env bash
set -eux

sudo apt install -y git curl wget sudo python3 python3-pip
sudo git clone  https://github.com/ceph/ceph.git
cd  ceph
sudo  sh -c '/bin/echo -e "\ny\ny"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc
ls  -lh  admin
ls  -lh  .
exit 0
mv   admin/build-doc/output ../ceph-build-docs/ceph-output

cd ..
sh ceph-build-docs/docker-build.sh


git clone https://github.com/istio/istio.io.git


#istio-io website
cd istio.io
#ls -lah
git pull
make build
cd ..
#docker build -t docker.io/wenba100xie/istio-io-websiete-mirror -f Dockerfile-Istio-io .
#docker push wenba100xie/istio-io-websiete-mirror:latest
# ali_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:"
git clone https://github.com/projectcalico/calico.git


#cd ..
##calico-docs

#docker build -t docker.io/wenba100xie/projectcalico-docs:latest -f Dockerfile-calico-io .
#docker push wenba100xie/projectcalico-docs:latest:latest

