#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip
sudo git clone  https://github.com/ceph/ceph.git
cd  ceph
sudo  sh -c '/bin/echo -e "y\ny\n"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc

ls  -lh  ./build-doc
sudo mv   ./build-doc/output ../ceph-build-docs/ceph-output

# start build ceph docs with docker
cd ..
cd ceph-build-docs
sh build.sh
