#!/bin/bash
set -x

apt update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt update
apt install -y docker-ce

mkdir /etc/squid
cat | tee /etc/squid/squid.conf <<EOF
visible_hostname squid

#Handling HTTP requests
http_port 3129 intercept
acl allowed_http_sites dstdomain .amazonaws.com
#acl allowed_http_sites dstdomain [you can add other domains to permit]
http_access allow allowed_http_sites

#Handling HTTPS requests
https_port 3130 cert=/etc/squid/ssl/squid.pem ssl-bump intercept
acl SSL_port port 443
http_access allow SSL_port
acl allowed_https_sites ssl::server_name .amazonaws.com
#acl allowed_https_sites ssl::server_name [you can add other domains to permit]
acl step1 at_step SslBump1
acl step2 at_step SslBump2
acl step3 at_step SslBump3
ssl_bump peek step1 all
ssl_bump peek step2 allowed_https_sites
ssl_bump splice step3 allowed_https_sites
ssl_bump terminate step2 all

http_access deny all
EOF

docker pull karlhopkinsonturrell/squid-alpine
docker run -it -d --net host \
    --mount type=bind,src=/etc/squid/squid.conf,dst=/etc/squid/squid.conf \
    karlhopkinsonturrell/squid-alpine

iptables -t nat -I PREROUTING 1 -s 10.0.2.0/24 -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -t nat -I PREROUTING 1 -s 10.0.2.0/24 -p tcp --dport 443 -j REDIRECT --to-port 3130

