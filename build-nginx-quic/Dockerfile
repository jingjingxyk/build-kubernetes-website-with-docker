FROM debian:buster
# 启动非交互模式：
ENV DEBIAN_FRONTEND=noninteractive


RUN set -eux ;\
apt update -y ;\
apt install -y \
git wget curl ca-certificates bzip2 gawk    mercurial;
RUN apt install -y openssl cmake ninja-build golang

RUN git clone https://github.com/google/boringssl.git
WORKDIR /boringssl
RUN mkdir build
#cd build
WORKDIR /boringssl/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -GNinja ..
RUN ninja
RUN hg clone -b quic https://hg.nginx.org/nginx-quic
WORKDIR /nginx-quic
# cd nginx-quic
RUN ./auto/configure \
 --with-debug\
--with-http_v3_module       \
--with-http_quic_module \
--with-stream_quic_module \
--with-cc-opt="-I../boringssl/include"   \
--with-ld-opt="-L../boringssl/build/ssl  \
              -L../boringssl/build/crypto"
