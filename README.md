# openfaas-playground
a vagrant project to get openfaas on your laptop

![photo](https://github.com/kikitux/openfaas-playground/raw/master/screenshots//playground1.png)

dependencies:
- virtualbox
- vagrant
- faas-cli
- docker binaries

## TL;DR

```
vagrant up
vagrant status
```

## Number of nodes

By default the cluster is made of 2 nodes, however you can [update this on Vagrantfile](https://github.com/kikitux/openfaas-playground/blob/master/Vagrantfile#L2) to have multiples nodes

```
## config
numnodes = 5
## end config
```

## Long description of usage

Once all the dependencies are installed, the following will happen:

vagrant will create a two (2) node multi-machine setup, and install docker and openfaas

then will create a swarm cluster, make the 2nd node join and install openfaas

`vagrant up` creates the vms
`vagrant status` will display the current status of the vms and some information

```
0  (master) $ vagrant status

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

building a new faas:
cd playground
faas-cli template pull
faas-cli new --list
faas-cli new hello --lang=dockerfile
faas-cli build -f hello.yml
faas-cli deploy -f hello.yml

go to the webpage and play: http://localhost:8080

Current machine states:

faas2                     running (virtualbox)
faas1                     running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
0  (master) $ 
```

`faas-cli list`

```
0  (master) $ faas-cli list
Function                      	Invocations    	Replicas
func_decodebase64             	0              	1    
func_echoit                   	0              	1    
func_hubstats                 	0              	1    
func_webhookstash             	0              	1    
func_markdown                 	0              	1    
func_base64                   	0              	1    
func_wordcount                	0              	1    
func_nodeinfo                 	0              	1    
```

You can configure `DOCKER_HOST` variable so docker client on your computer can talk to the daemon on the vm
```
export DOCKER_HOST=tcp://localhost:2375
0  (master) $ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
iilumy3xqznbp5hmuvimpmlg5 *   faas1               Ready               Active              Leader
4haixnr636ymahj8nnu5z1mof     faas2               Ready               Active              
0  (master) $ 
```

## desctiption of whats here

Vagrant is a tool to create repeatable environments so the developer can focus on the code instead of the infrastructure.

This project will do on start:
- download vm template
- configure ssh password less between the nodes
- deploy guest, 2 by default, you can scale to more
- install and configure docker
- create docker swarm cluster

on node1 faas1:
- install and deploy openfaas
- install openfaas-cli
- install portainer

## extra stuff

### portainer

portainer is a ui to visualise and manage docker hosts and integrate with swarm.

![cluster](https://github.com/kikitux/openfaas-playground/raw/master/screenshots/portainer4.png)

head to [http://localhost:9000/](http://localhost:9000/) and setup the initial password



