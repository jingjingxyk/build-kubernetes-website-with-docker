#!/bin/env sh

DOCKER_IMAGE='wenba100xie/kubernetes-website'
DOCKER_IMAGE='library/php'
         #  https://registry.hub.docker.com/v2/repositories/wenba100xie/kubernetes-website/tags/
         #   https://hub.docker.com/v2/repositories/library/php/tags/?page=1&page_size=250


VERSION='zts-buster'


curl -s -S "https://registry.hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags/?page=1&page_size=365" | \
sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
grep '"name"' | \
awk -F\" '{print $4;}' | \
sort -fu  | \
grep -wq ${VERSION} &&  echo "Yes,已经存在终止构建程序"  && exit 0


#sed -e "s/^/${Repo}:/"


