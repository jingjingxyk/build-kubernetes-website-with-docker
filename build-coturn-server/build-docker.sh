#!/bin/bash

set -e
export DOCKER_BUILDKIT=1
# shellcheck disable=SC2006
TIME=`date "+%Y%m%d"`
VERSION="dev-"${TIME}
IMAGE="wenba100xie/coturn:${VERSION}"
docker build -t "$IMAGE" -f Dockerfile .
docker push "$IMAGE"
