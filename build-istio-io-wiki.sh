#!/bin/env bash
set -eux

day=`date "+%Y%m%d"`

sudo apt install -y git curl wget sudo python3 python3-pip


git clone https://github.com/istio/istio.io.git


#istio-io website
cd istio.io
#ls -lah
git pull
make build
cd ..
mv istio.io/public/ build-istio-io-docs/
cd build-istio-io-docs/
sh build.sh
