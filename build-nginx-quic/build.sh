#!/bin/env bash

set -eux
export DOCKER_BUILDKIT=1
TIME=`date "+%Y%m%d%H%M"`
VERSION="dev-"${TIME}
IMAGE="wenba100xie/nginx-quick-http3:${VERSION}"

docker build -t "$IMAGE" -f Dockerfile .
docker push "$IMAGE"
