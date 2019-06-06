# Description 

This microservice provides a mechanism to collect Junos `show commands` from Junos Devices.  
It uses Ansible. 

# Requirements

Install Docker 

# Microservice inputs

You need to provide 2 files:
- A YAML file `show-commands-to-collect.yml` to indicate the list of Junos `show commands` you want to collect.   
- An Ansible Inventory file (`hosts`) with following variables:
  - `ansible_host`: IP of the device
  - `ansible_ssh_user`: Username to use for the connection
  - `ansible_ssh_pass`: Password to use for the connection


# Usage

Create this structure
- `inputs` directory
   - with an ansible `hosts` file
   - A YAML file to indicate the list of desired `show commands`      

Ansible inventory example: 
```
$ more inputs/hosts
[spines]
demo-qfx10k2-14   ansible_host=172.25.90.67
demo-qfx10k2-15   ansible_host=172.25.90.68

[leaves]
demo-qfx5110-9	  ansible_host=172.25.90.63
demo-qfx5110-10	  ansible_host=172.25.90.64

[all:vars]
netconf_port=830
ansible_ssh_user=ansible
ansible_ssh_pass=juniper123
```

Configure the details you want to collect. 
Example:   
```
$ more inputs/collector-details.yml

---
cli:
  - "show chassis hardware"
  - "show version"
```

Pull the image
```
$ docker pull ksator/collect-junos-command
```
Verify
```
$ docker images ksator/collect-junos-command
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
```

Run the microservice
This will instanciate a container, execute the service, and stop the container and remove the container.    
```
$ docker run -it --rm -v ${PWD}/inputs:/inputs -v ${PWD}/outputs:/outputs ksator/collect-show-commands
```
List the containers.  
The container doesnt exist anymore
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Here's the output generated
```
$ tree

```

