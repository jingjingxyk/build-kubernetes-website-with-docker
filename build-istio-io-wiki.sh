#!/bin/env bash
set -eux

day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip


git clone https://github.com/istio/istio.io.git --depth=1


#istio-io website
cd istio.io
#ls -lah
git pull
make build
wget -O public/robots.txt https://www.xieyaokun.com/robots.txt
cd ..
mv istio.io/public/ build-istio-io-docs/
cd build-istio-io-docs/
sh build.sh
