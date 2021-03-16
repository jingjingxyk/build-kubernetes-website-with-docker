#!/bin/bash

set -e
export DOCKER_BUILDKIT=1
docker build -t wenba100xie/coturn:2020-11-26 -f Dockerfile .
docker save -o /data/yaokun/coturn-docker-latest.tar wenba100xie/coturn:2020-11-26
