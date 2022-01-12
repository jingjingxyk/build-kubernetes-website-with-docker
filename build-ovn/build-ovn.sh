#!/bin/env bash

__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__}

set -eux
sudo apt install -y  \
gcc clang make cmake autoconf automake openssl python3 python3-pip unbound libtool  netcat curl  graphviz
#apt install -y openvswitch-switch openvswitch-common
#apt remove -y openvswitch-switch openvswitch-common

git clone https://github.com/openvswitch/ovs.git
cd ${__DIR__}/ovs
mkdir ${__DIR__}/ovs/build
./boot.sh
cd ${__DIR__}/ovs/build
../configure
make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l`
sudo make install
cd ${__DIR__}
# /usr/local/bin/
#libtool: install: /usr/bin/install -c utilities/ovs-appctl /usr/local/bin/ovs-appctl
#libtool: install: /usr/bin/install -c utilities/ovs-testcontroller /usr/local/bin/ovs-testcontroller
#libtool: install: /usr/bin/install -c utilities/ovs-dpctl /usr/local/bin/ovs-dpctl
#libtool: install: /usr/bin/install -c utilities/ovs-ofctl /usr/local/bin/ovs-ofctl
#libtool: install: /usr/bin/install -c utilities/ovs-vsctl /usr/local/bin/ovs-vsctl
#libtool: install: /usr/bin/install -c ovsdb/ovsdb-tool /usr/local/bin/ovsdb-tool
#libtool: install: /usr/bin/install -c ovsdb/ovsdb-client /usr/local/bin/ovsdb-client
#libtool: install: /usr/bin/install -c vtep/vtep-ctl /usr/local/bin/vtep-ctl

git clone https://github.com/ovn-org/ovn.git
cd ${__DIR__}/ovn
mkdir ${__DIR__}/ovn/build
./boot.sh
cd ${__DIR__}/ovn/build
../configure   --with-ovs-source=${__DIR__}/ovs/ --with-ovs-build=${__DIR__}/ovs/build
make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l`
sudo make install

cd ${__DIR__}
#libtool: install: /usr/bin/install -c utilities/ovn-nbctl /usr/local/bin/ovn-nbctl
#libtool: install: /usr/bin/install -c utilities/ovn-sbctl /usr/local/bin/ovn-sbctl
#libtool: install: /usr/bin/install -c utilities/ovn-ic-nbctl /usr/local/bin/ovn-ic-nbctl
#libtool: install: /usr/bin/install -c utilities/ovn-ic-sbctl /usr/local/bin/ovn-ic-sbctl
#libtool: install: /usr/bin/install -c utilities/ovn-trace /usr/local/bin/ovn-trace
#libtool: install: /usr/bin/install -c utilities/ovn-appctl /usr/local/bin/ovn-appctl
#libtool: install: /usr/bin/install -c controller/ovn-controller /usr/local/bin/ovn-controller
#libtool: install: /usr/bin/install -c controller-vtep/ovn-controller-vtep /usr/local/bin/ovn-controller-vtep
#libtool: install: /usr/bin/install -c northd/ovn-northd /usr/local/bin/ovn-northd
#libtool: install: /usr/bin/install -c ic/ovn-ic /usr/local/bin/ovn-ic

##  start the Open vSwitch daemons.
export PATH=$PATH:/usr/local/share/openvswitch/scripts
##ovs-ctl start

##  Starting OVN Central services

export PATH=$PATH:/usr/local/share/ovn/scripts
##ovn-ctl start_northd
##ovn-ctl start_controller
