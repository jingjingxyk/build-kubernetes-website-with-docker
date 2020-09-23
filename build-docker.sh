#!/bin/env sh

HUGO_VERSION='0.64.0'
TIME=`date "+%Y%m%d"`
# VERSION=${TIME}
# IMAGE="${DOCKER_IMAGE}:${VERSION}"

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

KUBE_VERSION=`kubelet --version |  awk -F ' ' '{print $2}'`
list=$(kubeadm config images list --kubernetes-version=${KUBE_VERSION})
for line in ${list}
do
    echo ${line}
    docker pull ${line}
done

rm -rf ${KUBE_VERSION}
if [ ! -d ${KUBE_VERSION}  ];then
  echo "创建文件夹${KUBE_VERSION}";
  mkdir ./${KUBE_VERSION}
else
  echo "${KUBE_VERSION} 文件夹已存在"
fi
ls -lah ${KUBE_VERSION}
for line in ${list}
do
   echo ${line}
   name=$(echo ${line} | sed -r 's/.*\/(.*):.*/\1/')
   echo ${name}
   docker    save -o "./${KUBE_VERSION}/kubernetes-${name}.tar" ${line}
done

tar -czvf "kubernetes-${KUBE_VERSION}.tar.gz" "./${KUBE_VERSION}"
curl -L https://istio.io/downloadIstio | sh -
wget https://github.com/istio/istio/releases/download/1.7.1/istioctl-1.7.1-linux-amd64.tar.gz
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.19.0/crictl-v1.19.0-linux-amd64.tar.gz
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.16.1/calicoctl
ls -lh .
git clone https://github.com/kubernetes/website.git
cd website
#VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
git fetch --tags
#VERSION=$(`git describe --abbrev=0`)
#TIME=`date "+%Y%m%d%H%M"`
TIME=`date "+%Y%m%d"`
#TIME=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
#TIME=`date +"%Y%m%dT%H%M%S%z"`
GIT_REVISION=`git log -1 --pretty=format:"%h"`
#VERSION=${TIME}_${GIT_REVISION}
VERSION=${KUBE_VERSION}
DOCKER_IMAGE="wenba100xie/kubernetes-website"
IMAGE="${DOCKER_IMAGE}:kubernetes-${VERSION}"
echo ${VERSION}
echo ${IMAGE}
echo ${VERSION}
cd ..


DOCKER_HUB_TAG_API="https://registry.hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags/?page=1&page_size=365"
echo ${DOCKER_HUB_TAG_API}
curl -s -S ${DOCKER_HUB_TAG_API} | \
sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
grep '"name"' | \
awk -F\" '{print $4;}' | \
sort -fu  | \
grep -wq ${VERSION} &&  echo "Yes,最新版本已经存在,终止构建"  && echo "开始构建新版本"
echo "构建环境详情"
cat /etc/os-release
uname -a && cat /proc/version
echo "ip是:"
curl -s ip.sb
cal
date -u +"%Y-%m-%dT%H:%M:%SZ"
date +%Y-%m-%dT%H:%M:%S%z
env

docker search wenba100xie

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile  .    --build-arg HUGO_VERSION=${HUGO_VERSION}
echo "${DOCKER_PASSWORD}" | docker login  -u ${DOCKER_USER} --password-stdin
docker push ${IMAGE}
