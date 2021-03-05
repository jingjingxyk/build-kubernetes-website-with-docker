#!/bin/env sh
set -eux
export DOCKER_BUILDKIT=1

HUGO_VERSION='0.64.0'
TIME=`date "+%Y%m%d"`
# VERSION=${TIME}
# IMAGE="${DOCKER_IMAGE}:${VERSION}"
sudo apt-get update -y
#sudo apt-get update
sudo apt-get autoclean            #    清理旧版本的软件缓存
sudo apt-get clean                 #   清理所有软件缓存
sudo apt-get autoremove            # 删除系统不再使用的孤立软件

sudo apt-get remove -y docker docker-engine docker.io containerd runc containernetworking-plugins
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


sudo apt-get install -y docker-ce docker-ce-cli containerd.io


sudo apt install -y git curl wget sudo python3 python3-pip
sudo git clone  https://github.com/ceph/ceph.git
cd  ceph
sudo  sh -c '/bin/echo -e "\ny\ny"' | sudo apt-get install `cat doc_deps.deb.txt`
sudo  admin/build-doc

mv   admin/build-doc/output ../ceph-build-docs/ceph-output
sudo curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
sudo  mv cephadm ../ceph-build-docs/ceph-output/
cd ..
sh ceph-build-docs/docker-build.sh

git clone https://github.com/istio/istio.io.git
#git clone https://github.com/projectcalico/calico.git

#istio-io website
cd istio.io
#ls -lah
git pull
make build
cd ..


#docker build -t docker.io/wenba100xie/istio-io-websiete-mirror -f Dockerfile-Istio-io .
#docker push wenba100xie/istio-io-websiete-mirror:latest
#cd ..
##calico-docs

#docker build -t docker.io/wenba100xie/projectcalico-docs:latest -f Dockerfile-calico-io .
#docker push wenba100xie/projectcalico-docs:latest:latest



sudo ps -ef
sudo free -m
 sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

#cd /var/lib/dpkg
#sudo rm -rf info
#sudo mkdir info
#sudo apt-get upgrade -y
#
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl






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
mkdir tools
mv "kubernetes-${KUBE_VERSION}.tar.gz" tools
cd tools

#curl -L https://istio.io/downloadIstio | sh -
wget https://github.com/istio/istio/releases/download/1.9.0/istio-1.9.0-linux-amd64.tar.gz
wget https://github.com/istio/istio/releases/download/1.9.0/istioctl-1.9.0-linux-amd64.tar.gz
wget https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-amd64.tar.gz
# https://github.com/kubernetes/dashboard
wget -O Kubernetes-Dashboard-v2.0.4.yaml https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
# calico
wget -O calico-tigera-operator.yaml  https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget -O calico-custom-resources.yaml  https://docs.projectcalico.org/manifests/custom-resources.yaml
# metrics-server
wget -O metrics-server-components-v0.4.2.yaml https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml

curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.17.0/calicoctl-linux-amd64
wget https://github.com/goharbor/harbor/releases/download/v2.1.1/harbor-online-installer-v2.1.1.tgz
wget https://github.com/symfony/cli/releases/download/v4.21.2/symfony_linux_amd64.gz

docker pull k8s.gcr.io/metrics-server/metrics-server:v0.4.2
docker save -o metrics-server-v0.4.2.tar k8s.gcr.io/metrics-server/metrics-server:v0.4.2

ls -lh .
cd .. # 返回构建根目录
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
IMAGE_TAG="kubernetes-tools-${VERSION}"
IMAGE="${DOCKER_IMAGE}:${IMAGE_TAG}"
echo ${VERSION}
echo ${IMAGE}
echo ${VERSION}
cd ..


DOCKER_HUB_TAG_API="https://registry.hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags/?page=1&page_size=365"
echo ${DOCKER_HUB_TAG_API}
old_build_tag=$(curl -s  ${DOCKER_HUB_TAG_API} | \
sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
grep '"name"' | \
awk -F\" '{print $4;}' | \
awk   '/^'${IMAGE_TAG}'$/{print $1}' )



echo "开始新的构建，构建准备环境环境详情如下"
cat /etc/os-release
uname -a && cat /proc/version
echo "ip是:"
curl -s ip.sb
cal
date -u +"%Y-%m-%dT%H:%M:%SZ"
date +%Y-%m-%dT%H:%M:%S%z
env

docker search wenba100xie

echo "${DOCKER_PASSWORD}" | docker login  -u ${DOCKER_USER} --password-stdin

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true

docker build -t 'wenba100xie/kubernetes-website:latest' -f ./Dockerfile  .    --build-arg HUGO_VERSION=${HUGO_VERSION}
docker push 'wenba100xie/kubernetes-website:latest'


#k8s-need-docker-to-tar
docker build -t ${IMAGE} -f ./Dockerfile2  .
if [ "$old_build_tag" = "${IMAGE_TAG}" ];then
   echo "Yes,最新版本kubernetes 安装包已经存在,终止构建推送"
   exit 0
fi
docker push ${IMAGE}
