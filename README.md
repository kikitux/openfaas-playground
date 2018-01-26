# openfaas-playground
a vagrant project to get openfaas on your laptop

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

`export DOCKER_HOST=tcp://localhost:2375`

`docker node ls`

```
0  (master) $ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
iilumy3xqznbp5hmuvimpmlg5 *   faas1               Ready               Active              Leader
4haixnr636ymahj8nnu5z1mof     faas2               Ready               Active              
0  (master) $ 
```

## Desctiption of whats here

todo

