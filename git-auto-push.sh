#!/bin/env sh

#!/bin/sh
TIME=`date "+%Y%m%d%H%M"`
git add .
git commit -a -m "auto commit  ${TIME}"
git push -u origin master



GIT_REVISION=`git log -1 --pretty=format:"%h"`
version=${TIME}_${GIT_REVISION}
tag_name=release-v${version}

hostname
env

ls -al | grep "^-" | awk '{print $9}'
exit 0


#!/bin/sh
__CURRENT__=`pwd`
__DIR__=$(cd "$(dirname "$0")";pwd)
cd ${__DIR__} &&
git add -A && \
git commit -m "[`date '+%Y/%m/%d %H:%M'`] Auto update by script" && \
git push --force && \
cd ${__CURRENT__}
