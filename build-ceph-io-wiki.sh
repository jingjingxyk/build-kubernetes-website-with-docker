#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip

sudo wget -O main.zip  https://github.com/ceph/ceph/archive/refs/heads/main.zip
sudo unzip main.zip
sudo mv ceph-main ceph

# sudo git clone  https://github.com/ceph/ceph.git --depth=1 --progress --recursive

cd  ceph
sudo  sh -c '/bin/echo -e "y\ny\n"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc

ls  -lh  ./build-doc
sudo wget -O ./build-doc/output/robots.txt https://www.xieyaokun.com/robots.txt
sudo mv   ./build-doc/output ../ceph-build-docs/ceph-output

# start build ceph docs with docker
cd ..
cd ceph-build-docs
sh build.sh
