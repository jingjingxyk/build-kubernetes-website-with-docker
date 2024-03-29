#!/bin/env sh
set -eux
export DOCKER_BUILDKIT=1

HUGO_VERSION='0.86.1'
TIME=`date "+%Y%m%d"`
# VERSION=${TIME}
# IMAGE="${DOCKER_IMAGE}:${VERSION}"




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

# ovn
git clone https://github.com/ovn-org/ovn.git
tar -czvf ovn.tar.gz ovn
git clone https://github.com/openvswitch/ovs.git
tar -czvf ovs.tar.gz ovs
rm -rf ovn
rm -rf ovs

# istio
curl -L https://istio.io/downloadIstio | sh -
#wget https://github.com/istio/istio/releases/download/1.9.0/istio-1.9.0-linux-amd64.tar.gz
#wget https://github.com/istio/istio/releases/download/1.9.0/istioctl-1.9.0-linux-amd64.tar.gz
# docker-compose
#wget https://github.com/docker/compose/releases/download/1.28.5/docker-compose-Linux-x86_64
#wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-amd64.tar.gz

#dashboard
# https://github.com/kubernetes/dashboard
wget -O Kubernetes-Dashboard-v2.0.4.yaml https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml


# calico
# https://calico.dengxiaci.com/getting-started/kubernetes/self-managed-onprem/onpremises#install-calico-with-kubernetes-api-datastore-more-than-50-nodes
#wget -O calico-tigera-operator.yaml  https://docs.projectcalico.org/manifests/tigera-operator.yaml
#wget -O calico-custom-resources.yaml  https://docs.projectcalico.org/manifests/custom-resources.yaml
curl -O -L  https://projectcalico.org/builds/calicoctl
curl https://docs.projectcalico.org/manifests/calico.yaml -O

# metrics-server
wget -O metrics-server-components-v0.4.2.yaml https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.4.2/components.yaml

#curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
#harbor
wget https://github.com/goharbor/harbor/releases/download/v2.2.0/harbor-online-installer-v2.2.0.tgz

#symfony
wget https://github.com/symfony/cli/releases/download/v4.21.2/symfony_linux_amd64.gz

#cephadm
sudo curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm


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


docker search wenba100xie


#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true

docker build -t "wenba100xie/kubernetes-website:wiki-${VERSION}" -f ./Dockerfile  .    --build-arg HUGO_VERSION=${HUGO_VERSION}
docker push "wenba100xie/kubernetes-website:wiki-${VERSION}"

aliyun_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:kubernetes-website-wiki-${VERSION}";
docker tag "wenba100xie/kubernetes-website:wiki-${VERSION}" $aliyun_image
#docker push $aliyun_image


#k8s-need-docker-to-tar
docker build -t ${IMAGE} -f ./Dockerfile2  .
if [ "$old_build_tag" = "${IMAGE_TAG}" ];then
   echo "Yes,最新版本kubernetes 安装包已经存在,终止bernets-tools构建推送"
   exit 0
else
  docker push ${IMAGE}
  aliyun_image="registry.cn-beijing.aliyuncs.com/jingjingxyk-public/app:kubernetes-website-${IMAGE_TAG}";
#  docker push $aliyun_image
fi



