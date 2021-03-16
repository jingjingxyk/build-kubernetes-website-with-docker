set -eux

mkdir /tmp/developer-chrome-com
docker run --rm -v /tmp/developer-chrome-com:/workspace  -w /workspace node:15-alpine \
/bin/sh -c "
pwd
apk add curl git wget
git clone https://github.com/GoogleChrome/developer.chrome.com.git
cd developer.chrome.com
if [ -d node_modules ] ;then rm -rf node_modules; fi
npm install  -ddd
npm run production
cp dist/en/* dist/
"

cp -r /tmp/developer-chrome-com/developer.chrome.com/dist/  build-developer-chrome-com
cd build-developer-chrome-com
sh build-docker.sh
