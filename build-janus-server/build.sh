#!/bin/env bash

set -e
export DOCKER_BUILDKIT=1
TIME=`date "+%Y%m%d%H%M"`
VERSION="dev-"${TIME}
IMAGE="wenba100xie/janus:${VERSION}"

docker build -t "$IMAGE" -f Dockerfile .
docker push "$IMAGE"
