# kubernetes calico istio janus ceph document website docker image
1. [kubernetes website mirror](https://hub.docker.com/repository/docker/wenba100xie/kubernetes-website/tags?page=1&ordering=last_updated)
1. [calico website mirror](https://hub.docker.com/repository/docker/wenba100xie/calico-docs/tags?page=1&ordering=last_updated)
1. [coturn website mirror](https://hub.docker.com/repository/docker/wenba100xie/coturn/tags?page=1&ordering=last_updated)
1. [developer.chrome.com website mirror](https://hub.docker.com/repository/docker/wenba100xie/developer.chrome.com/tags?page=1&ordering=last_updated)
1. [ceph website mirror](https://hub.docker.com/repository/docker/wenba100xie/ceph-docs/tags?page=1&ordering=last_updated)

## coturn freeswitch janus nginx-quic image
1.  [coturn](https://hub.docker.com/repository/docker/wenba100xie/coturn/tags?page=1&ordering=last_updated)
1.  [freeswitch](https://hub.docker.com/repository/docker/wenba100xie/freeswitch/tags?page=1&ordering=last_updated)
1.  [janus](https://hub.docker.com/repository/docker/wenba100xie/janus/tags?page=1&ordering=last_updated)
1.  [nginx-quic image]()




## docker use proxy down image  ; 使用代理下载容器镜像
1. docker.io (docker hub公共镜像库)
2. gcr.io (Google container registry)
3. k8s.gcr.io (等同于gcr.io/google-containers)
4. https://console.cloud.google.com/gcr/images/google-containers/GLOBAL
5. quay.io (Red Hat运营的镜像库)
6. ghcr.io (github 运营的镜像库)

## docker proxy configure  ; docker 代理 配置
```shell
proxy_url=http://your-domain:8118

line_number=$(grep -n '\[Service\]' /lib/systemd/system/docker.service | cut -d ':' -f 1 ) && echo $line_number
sed -i "${line_number}a\Environment=https_proxy=${proxy_url}" /lib/systemd/system/docker.service
sed -i "${line_number}a\Environment=http_proxy=${proxy_url}" /lib/systemd/system/docker.service
sed -i "${line_number}a\Environment=\"NO_PROXY=localhost,127.0.0.1,192.168.0.1/24\"" /lib/systemd/system/docker.service

systemctl daemon-reload
systemctl restart docker
cat /lib/systemd/system/docker.service
docker info


```

## proxy tool  代理工具
```shell
cat <<EOF | tee proxy.sh
# your proxy server ip
ip=proxy.example.com

# your proxy server ssh key
keyfile=/key.pem

{
    ssh -o StrictHostKeyChecking=no \
    -o ExitOnForwardFailure=yes \
    -o TCPKeepAlive=yes \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3 \
    -i $keyfile \
    -v -CTg \
    -D  0.0.0.0:8118 \
    root@$ip
} || {
    echo $?
}
EOF

# note you can use [autossh ] keep ssh live
apt install -y autossh
```

## test
```shell

# 1. 只显示目录

ls -F | grep "/$"
ls -al | grep "^d"
# 2. 只显示文件
ls -al | grep "^-"


 ls -al | grep "^-" | awk '{print $9}' >  soft-list.txt

 # ls | while read line; do  echo $line ;done
#  i=0 ; while true ;  do  sleep 10 && clear && echo $((i++))  ; done


#find ./ -nouser  |xargs rm –rf
```
