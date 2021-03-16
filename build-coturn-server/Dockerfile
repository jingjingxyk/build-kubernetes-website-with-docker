FROM debian:buster
# 启动非交互模式：
ENV DEBIAN_FRONTEND=noninteractive
# README.md
# https://github.com/coturn/coturn/blob/master/INSTALL
# https://github.com/coturn/coturn/blob/master/docker/coturn/Dockerfile

RUN  apt update -y
RUN apt install -y sudo
RUN sudo apt install -y \
ca-certificates \
git wget curl \
gcc \
openssl libssl-dev \
sqlite \
libsqlite-dev \
libevent-dev \
libpq-dev \
libmariadbd-dev libmariadb-dev \
libevent-dev

#https://github.com/mongodb/mongo-c-driver/
RUN sudo apt install -y \
 libbson-dev  libmongoc-dev \
libhiredis-dev
RUN sudo apt install -y -y make cmake g++ gdebi-core
RUN sudo apt install -y initscripts net-tools pkg-config sqlite3 libsqlite3-dev

ENV BUILD_PREFIX /usr/local/src
ENV INSTALL_PREFIX /usr/local
WORKDIR $BUILD_PREFIX

RUN git clone https://github.com/coturn/coturn.git
#ADD ./coturn /coturn
# Build Coturn
WORKDIR ${BUILD_PREFIX}/coturn
RUN ./configure -h
RUN make
RUN make install


# set startup parameters
# SUTN/TURN PORTS
EXPOSE 3478 3479 3478/udp 3479/udp 80 80/udp
EXPOSE 5349 5350 5349/udp 5350/udp 443 443/udp
# CLI
EXPOSE 5766
# Relay Ports
EXPOSE 49152-65535 49152-65535/udp

#COPY ./docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]
RUN cp /usr/local/etc/turnserver.conf.default  /usr/local/etc/turnserver.conf
WORKDIR ${INSTALL_PREFIX}
CMD ${INSTALL_PREFIX}/bin/turnserver

# cat /usr/local/share/doc/turnserver/postinstall.txt
# install examples/etc/turnserver.conf /usr/local/etc/turnserver.conf.default
# install turndb/schema.sql /usr/local/share/doc/turnserver
