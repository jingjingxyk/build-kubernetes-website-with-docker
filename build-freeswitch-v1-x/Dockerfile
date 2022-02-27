FROM debian:11

ARG proxy_url=""
ENV http_proxy=$proxy_url
ENV https_proxy=$proxy_url
RUN echo $http_proxy && echo $https_proxy


RUN apt-get update -y &&  apt-get install -y gnupg2 wget lsb-release \
netcat iproute2 socat curl wget python3 python3-pip \
tcpdump tini uuid uuid-runtime lsof  iproute2 net-tools  iputils-ping vim \
xz-utils git

RUN wget -O /usr/share/keyrings/freeswitch-archive-keyring.gpg https://files.freeswitch.org/repo/deb/debian-release/freeswitch-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/freeswitch-archive-keyring.gpg] http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list
# you may want to populate /etc/freeswitch at this point.
# if /etc/freeswitch does not exist, the standard vanilla configuration is deployed
RUN apt-get update && apt-get install -y freeswitch-meta-all
RUN  apt-get clean &&  apt-get autoclean
ENV http_proxy ''
ENV https_proxy ''

#RUN git clone -b master https://github.com/pjsip/pjproject.git --depth=1 --progress && \
#   cd pjproject &&  ./configure &&  make dep && make clean && make
