## config
numnodes = 2
## end config

info = <<-'EOF'

  ___                   _____           ____
 / _ \ _ __   ___ _ __ |  ___|_ _  __ _/ ___|
| | | | '_ \ / _ \ '_ \| |_ / _` |/ _` \___ \
| |_| | |_) |  __/ | | |  _| (_| | (_| |___) |
 \___/| .__/ \___|_| |_|_|  \__,_|\__,_|____/
      |_|


OpenFaas is configured to run at http://localhost:8080
once vagrant up finish try:
faas-cli list

to connect to docker daemon in the vm faas1 use:
export DOCKER_HOST=tcp://localhost:2375

then run:
docker node ls

test it works:
curl -d "hello" http://localhost:8080/function/func_echoit
curl -d "" http://localhost:8080/function/nodeinfo

building a new faas:
cd playground
faas-cli template pull
faas-cli new --list
faas-cli new hello --lang=dockerfile
faas-cli build -f hello.yml
faas-cli deploy -f hello.yml

go to the webpage and play: http://localhost:8080

EOF

## don't modify
lan = "192.168.99"
Vagrant.configure("2") do |config|
  config.vm.box = "cbednarski/ubuntu-1604"
  #to avoid Inappropriate ioctl for device in messages
  #config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
  numnodes.downto(1).each do |i|
    config.vm.define vm_name = "faas%01d" % i do |faas|
      #hostname
      faas.vm.hostname = vm_name
      #network
      faas.vm.network :private_network, ip: "#{lan}.#{100+i}"
      #setup ssh passwordless
      faas.vm.provision "shell", privileged: true, path: "ops/sshkeys.sh", args: numnodes
      #setup packaes and docker
      faas.vm.provision "shell", privileged: true, path: "ops/provision.sh", args: numnodes

      # only of first node
      if i==1 
        faas.vm.provision "shell", path: "ops/faas1.sh", args: numnodes
        # port forward to easy access for docker and faas-cli
        faas.vm.network "forwarded_port", guest: 2375, host: 2375 #docker
        faas.vm.network "forwarded_port", guest: 8080, host: 8080 #openfaas ui
        faas.vm.network "forwarded_port", guest: 9000, host: 9000 #portainer
        puts info if ARGV[0] == "status"
      end
    end
  end
end
