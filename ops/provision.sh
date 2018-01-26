#!/usr/bin/env bash

#disable ipv6
cat >/etc/sysctl.d/99-noipv6.conf <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
sysctl -p
EOF

#base pks
PKG="git vim sysstat"
which ${PKG} &>/dev/null || {
  apt-get update
  apt-get install -y git vim
}

#install docker
apt-get remove -y docker docker-engine docker.io
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

docker version
if [ $? -ne 0 ]; then
  echo "err: docker is not running"
  echo "err: failing now"
  exit 1
else
  docker run hello-world
fi


#configure docker port
[ -f /etc/systemd/system/docker.service.d/docker.conf ] || {
  mkdir -p /etc/systemd/system/docker.service.d
  cat > /etc/systemd/system/docker.service.d/docker.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
EOF
  systemctl daemon-reload
  systemctl restart docker
}
