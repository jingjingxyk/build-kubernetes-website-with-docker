set -eux

mkdir /tmp/developer-chrome-com
docker run --rm -v /tmp/developer-chrome-com:/workspace  -w /workspace node:15-alpine \
/bin/sh -c "
set -eux
pwd
apk add curl git wget python python3
git clone https://github.com/GoogleChrome/developer.chrome.com.git
cd developer.chrome.com
if [ -d node_modules ] ;then rm -rf node_modules; fi
npm ci
npm run production
cp -r dist/en/* dist/
curl -o dist/robots.txt  https://www.xieyaokun.com/robots.txt
"

cp -r /tmp/developer-chrome-com/developer.chrome.com/dist/  build-developer-chrome-com
cd build-developer-chrome-com
sh build.sh
