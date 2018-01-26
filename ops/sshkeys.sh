#!/usr/bin/env bash

if [ ! ${1} ]; then
  echo "err: this script requires argument numnodes"
  exit 1
fi

export numnodes=${@}
export baseip="192.168.99"

mkdir -p ~/.ssh
chmod 0700 ~/.ssh

#check for private key for vm-vm comm
[ -f /vagrant/ops/id_rsa ] || {
  ssh-keygen -t rsa -f /vagrant/ops/id_rsa -q -N ''
}
#deploy key
[ -f ~/.ssh/id_rsa ] || {
    cp /vagrant/ops/id_rsa ~/.ssh/id_rsa
    chmod 0600 ~/.ssh/id_rsa
}
#allow ssh passwordless
grep 'root@faas' ~/.ssh/authorized_keys &>/dev/null || {
  cat /vagrant/ops/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
}
#exclude faas* from host checking
cat > ~/.ssh/config <<EOF
Host faas*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
#populate /etc/hosts
cat >/etc/hosts <<EOF
127.0.0.1 localhost
EOF
for x in `seq 1 $numnodes`; do
  grep ${baseip}.${x} /etc/hosts &>/dev/null || {
      echo ${baseip}.$[100+x] faas${x} | sudo tee -a /etc/hosts &>/dev/null
  }
done
#end script
