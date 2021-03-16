#!/bin/env bash
set -eux

sudo ps -ef
sudo free -m
echo "开始新的构建，构建准备环境环境详情如下"
cat /etc/os-release
uname -a && cat /proc/version
echo "ip是:"
curl -s ip.sb
cal
date -u +"%Y-%m-%dT%H:%M:%SZ"
date +%Y-%m-%dT%H:%M:%S%z
#env

sudo apt-get -y  autoremove
sudo apt-get update -y
#sudo apt-get update
#sudo apt-get autoclean            #    清理旧版本的软件缓存
#sudo apt-get clean                 #   清理所有软件缓存
#sudo apt-get autoremove            # 删除系统不再使用的孤立软件

sudo apt-get remove -y docker docker-engine docker.io containerd runc containernetworking-plugins

sudo apt install -y git curl wget sudo python3 python3-pip

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"


sudo apt-get install -y docker-ce docker-ce-cli containerd.io apt-transport-https curl git cmake make

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

#cd /var/lib/dpkg
#sudo rm -rf info
#sudo mkdir info
#sudo apt-get upgrade -y
#
sudo apt update -y
sudo apt-get install -y kubelet kubeadm kubectl



echo "${DOCKER_PASSWORD}" | docker login  -u ${DOCKER_USER} --password-stdin

echo "${DOCKER_ALI_PASSWORD}" | docker login  -u ${DOCKER_ALI_USER}  registry.cn-beijing.aliyuncs.com --password-stdin
