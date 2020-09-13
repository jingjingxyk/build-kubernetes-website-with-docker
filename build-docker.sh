#!/bin/env sh

HUGO_VERSION='0.64.0'
TIME=`date "+%Y%m%d"`
# VERSION=${TIME}
# IMAGE="${DOCKER_IMAGE}:${VERSION}"

git clone https://github.com/kubernetes/website.git
cd website
#VERSION=$(git describe --tags `git rev-list --tags --max-count=1`)
git fetch --tags
#VERSION=$(`git describe --abbrev=0`)
TIME=`date "+%Y%m%d%H%M"`
GIT_REVISION=`git log -1 --pretty=format:"%h"`
VERSION=${TIME}_${GIT_REVISION}
IMAGE="${DOCKER_IMAGE}:${VERSION}"
echo ${IMAGE}
echo ${VERSION}

git checkout ${VERSION}
cd ..

DOCKER_HUB_TAG_API="https://registry.hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags/?page=1&page_size=365"
echo ${DOCKER_HUB_TAG_API}
curl -s -S ${DOCKER_HUB_TAG_API} | \
sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
grep '"name"' | \
awk -F\" '{print $4;}' | \
sort -fu  | \
grep -wq ${VERSION} &&  echo "Yes,最新版本已经存在,终止构建"  && exit 0


docker search wenba100xie

#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true
docker build -t ${IMAGE} -f ./Dockerfile  .    --build-arg HUGO_VERSION=${HUGO_VERSION}
echo "${DOCKER_PASSWORD}" | docker login  -u ${DOCKER_USER} --password-stdin
docker push ${IMAGE}
