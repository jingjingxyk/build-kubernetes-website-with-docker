#!/bin/env sh 
HUGO_VERSION='0.64.0'
TIME=`date "+%Y%m%d"`
VERSION=${TIME}
IMAGE="jingjingxyk/kubernetes-website:latest-${VERSION}"
#docker build -t ${IMAGE} -f ./Dockerfile  .  --force-rm=true --no-cache=true --pull=true  --build-arg HUGO_VERSION=${HUGO_VERSION}
docker build -t ${IMAGE} -f ./Dockerfile  .    --build-arg HUGO_VERSION=${HUGO_VERSION}
echo "${{ secrets.DOCKER-PASSWORD }}" | docker login  -u jingjingxyk --password-stdin
docker push ${IMAGE}
