#!/bin/env sh
set -exu

__CURRENT__=`pwd`
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__} &&


TIME=`date "+%Y%m%d%H%M"`

git add .

git commit -a -m "[`date '+%Y/%m/%d %H:%M'`] Auto update by script"
git push -u origin master --force

GIT_REVISION=`git log -1 --pretty=format:"%h"`
version=${TIME}_${GIT_REVISION}
tag_name=release-v${version}

#hostname
#env

ls -al | grep "^-" | awk '{print $9}'

