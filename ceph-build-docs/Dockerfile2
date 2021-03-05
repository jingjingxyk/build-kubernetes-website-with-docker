FROM ubuntu:18.04 AS builder
RUN apt update -y
RUN apt install -y git curl wget sudo python3 python3-pip
RUN git clone  https://github.com/ceph/ceph.git
WORKDIR /ceph
RUN sh -c '/bin/echo -e "\ny\ny"' | sudo apt-get install `cat doc_deps.deb.txt`
RUN apt install -y python
RUN admin/build-doc
RUN curl --silent --remote-name --location https://github.com/ceph/ceph/raw/octopus/src/cephadm/cephadm
RUN mv cephadm build-doc


#FROM node:14-alpine AS ceph-io
#RUN apk update
#RUN apk add autoconf git cmake make cmake gcc automake libtool
#RUN apk add build-base pkgconfig  nasm
#RUN git clone -b develop  https://github.com/ceph/ceph.io.git
#WORKDIR /ceph.io
#RUN npm install -d
#RUN npm run build


FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html
COPY --from=builder /ceph/build-doc/output /usr/share/nginx/html
#COPY --from=ceph-io /ceph.io/dist/ /usr/share/nginx/html
