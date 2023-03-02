#!/bin/env bash
set -eux

Day=`date "+%Y%m%d"`

__DIR__=$(
  cd "$(dirname "$0")"
  pwd
)
cd ${__DIR__}

sudo apt install -y git curl wget sudo python3 python3-pip unzip zip

:<<'EOF'
sudo wget -O main.zip  https://github.com/ceph/ceph/archive/refs/heads/main.zip
sudo unzip main.zip
sudo mv ceph-main ceph
EOF

# sudo git clone  https://github.com/ceph/ceph.git --depth=1 --progress --recursive

sudo git clone --depth=1 --progress  https://github.com/ceph/ceph.git
cd ${__DIR__}/ceph

sudo bash ./install-deps.sh
sudo git submodule update --init --recursive

sudo  bash -c '/bin/echo -e "y\ny\n"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc

ls  -lh  ./build-doc
sudo wget -O ./build-doc/output/robots.txt https://www.xieyaokun.com/robots.txt
sudo mv   ./build-doc/output ${__DIR__}/ceph-build-docs/ceph-output

# start build ceph docs with docker
cd ${__DIR__}
cd ceph-build-docs
sh build.sh
