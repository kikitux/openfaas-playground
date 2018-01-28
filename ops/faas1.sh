#!/usr/bin/env bash

if [ ! ${1} ]; then
  echo "err: this script requires argument numnodes"
  exit 1
fi

export numnodes=${@}

pushd /vagrant/ops
#swarm
if [ -f /root/.swarm ]; then
  echo "info: docker swarm conf already happen, skipping"
  echo "info: if you need to tear this down, use vagrant destroy/up"
else
  docker swarm init --advertise-addr 192.168.99.101 | tee swarm.log | grep '192.168.99.101' | tee swarm.sh
  docker node ls &>/dev/null && touch /root/.swarm

  if [ ${numnodes} -ne 1 ]; then
    for x in `seq 2 ${numnodes}` ; do
      ssh faas${x} bash /vagrant/ops/swarm.sh
    done
  fi
fi

docker node ls
if [ $? -ne 0 ]; then
  echo "err: docker swarm not working"
  echo "err: failing now"
  exit 1
fi

#deploy portainer
docker run -d -p 9000:9000 --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

#faas
[ -d /usr/local/faas ] || {
  pushd /usr/local
  git clone https://github.com/openfaas/faas
  cd faas
  #./build.sh 
  ./deploy_stack.sh
  popd
}

pushd /vagrant

#faas-cli
which  faas-cli &>/dev/null || curl -sSL https://cli.openfaas.com | sudo sh
faas-cli list
if [ $? -ne 0 ]; then
  echo "err: faas-cli cant talk to faas on localhost:8080"
  echo "err: failing now"
  exit 1
fi


