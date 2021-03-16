FROM centos:7
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
RUN curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

#RUN wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
RUN sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache
#RUN yum update -y

RUN yum install -y \
ca-certificates \
git wget curl \
gcc \
openssl-devel \
sqlite \
sqlite-devel \
libevent \
libevent-devel \
postgresql-devel \
mysql-devel

RUN yum install -y \
epel \
mongo-c-driver  libbson \
hiredis \
hiredis-devel
RUN yum install -y make cmake g++
RUN yum -y install initscripts net-tools

#ENV BUILD_PREFIX /usr/local/src
#RUN git clone https://github.com/coturn/coturn.git
ADD ./coturn /coturn
# Build Coturn
WORKDIR coturn
RUN ./configure
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

#WORKDIR ${INSTALL_PREFIX}
#CMD ${INSTALL_PREFIX}/bin/turnserver

