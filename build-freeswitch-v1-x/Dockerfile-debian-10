FROM debian:buster

ARG proxy_url=""
ENV http_proxy=$proxy_url
ENV https_proxy=$proxy_url
RUN echo $http_proxy && echo $https_proxy


RUN apt-get update -y &&  apt-get install -y gnupg2 wget lsb-release netcat iproute2 socat curl wget python3 python3-pip

RUN wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add -

RUN echo "deb http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list

# you may want to populate /etc/freeswitch at this point.
# if /etc/freeswitch does not exist, the standard vanilla configuration is deployed
RUN apt-get update && apt-get install -y freeswitch-meta-all
ENV http_proxy ''
ENV https_proxy ''
