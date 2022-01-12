FROM debian:buster
# 启动非交互模式：
ENV DEBIAN_FRONTEND=noninteractive


RUN apt update -y && apt install -y  git wget curl
RUN apt  install  -y libmicrohttpd-dev libjansson-dev \
                     	libssl-dev  libsofia-sip-ua-dev libglib2.0-dev \
                     	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
                     	libconfig-dev pkg-config gengetopt libtool automake
RUN mkdir /tools/
WORKDIR /tools/
# libsrtp-dev
#RUN wget https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz

RUN apt install -y  python3 ninja-build python3-pip sudo
RUN pip3 install meson

RUN git clone https://gitlab.freedesktop.org/libnice/libnice.git/
# cd libnice
WORKDIR /tools/libnice
RUN apt install -y cmake make
RUN apt install -y golang
RUN meson --prefix=/usr build && ninja -C build && sudo ninja -C build install

WORKDIR /tools/
RUN wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz
RUN tar xfv v2.3.0.tar.gz
#cd libsrtp-2.2.0
WORKDIR /tools/libsrtp-2.3.0
RUN ./configure --prefix=/usr --enable-openssl
RUN make shared_library && sudo make install

WORKDIR /tools/
RUN git clone https://boringssl.googlesource.com/boringssl
#cd boringssl
WORKDIR /tools/boringssl
# Don't barf on errors
RUN sed -i s/" -Werror"//g CMakeLists.txt
# Build
RUN mkdir -p build
#cd build
WORKDIR /tools/boringssl/build
RUN cmake -DCMAKE_CXX_FLAGS="-lrt" ..
RUN make
#cd ..
WORKDIR /tools/boringssl/
# Install
RUN mkdir -p /opt/boringssl
RUN cp -R include /opt/boringssl/
RUN mkdir -p /opt/boringssl/lib
RUN cp build/ssl/libssl.a /opt/boringssl/lib/
RUN cp build/crypto/libcrypto.a /opt/boringssl/lib/

WORKDIR /tools/
RUN git clone https://github.com/sctplab/usrsctp
#cd usrsctp
WORKDIR /tools/usrsctp
RUN ./bootstrap
RUN ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6
RUN make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l` && sudo make install

WORKDIR /tools/
RUN git clone https://github.com/warmcat/libwebsockets.git
#cd libwebsockets
WORKDIR /tools/libwebsockets
# If you want the stable version of libwebsockets, uncomment the next line
# git checkout v3.2-stable
RUN mkdir build
#cd build
WORKDIR /tools/libwebsockets/build
# See https://github.com/meetecho/janus-gateway/issues/732 re: LWS_MAX_SMP
# See https://github.com/meetecho/janus-gateway/issues/2476 re: LWS_WITHOUT_EXTENSIONS
RUN cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic"  ..
RUN make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l` && sudo make install

RUN apt install -y libnanomsg-dev

WORKDIR /tools/
RUN git clone https://github.com/eclipse/paho.mqtt.c.git
#cd paho.mqtt.c
WORKDIR /tools/paho.mqtt.c
RUN make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l` && sudo make install

WORKDIR /tools/
RUN git clone https://github.com/alanxz/rabbitmq-c
#cd rabbitmq-c
WORKDIR /tools/rabbitmq-c
RUN git submodule init
RUN git submodule update
RUN mkdir build && cd build
WORKDIR /tools/rabbitmq-c/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr ..
RUN make -j `grep "processor" /proc/cpuinfo | sort -u | wc -l` && sudo make install

RUN apt  install -y  graphviz
RUN apt  install -y  doxygen=1.8.13-*



WORKDIR /tools/
RUN git clone https://github.com/meetecho/janus-gateway.git
#cd janus-gateway
WORKDIR /tools/janus-gateway
RUN sh autogen.sh
RUN ./configure --prefix=/opt/janus
RUN make
RUN make install
RUN make configs
# /etc/janus/janus.jcfg
WORKDIR /opt/janus/bin/
#nohup /opt/janus/bin/janus -b -L /var/log/janus.log >/dev/null 2>&1 &
