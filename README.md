# Description 

This microservice provides a mechanism to collect Junos `show commands` from Junos Devices.  
It uses Ansible. 

# Requirements

Install Docker 

# Inputs

You need to provide 2 files:
- A YAML file to indicate the list of desired `show commands`.   
- An Ansible Inventory file (`hosts`) with following variables:
  - `ansible_host`: IP of the device
  - `netconf_port`: netconf port to use to connect to devices
  - `ansible_ssh_user`: Username to use for the connection
  - `ansible_ssh_pass`: Password to use for the connection


# Usage

Pull the image
```
$ docker pull jnprautomate/junos-command-collector
```
Verify
```
$ docker images jnprautomate/junos-command-collector
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
jnprautomate/junos-command-collector   latest              e77270e113e8        16 seconds ago      361MB
```
List running containers  
there is no container instanciated with the above image
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Create this structure
- `inputs` directory
   - with an ansible `hosts` file
   - A YAML file to indicate the list of desired `show commands`      
```

```
Ansible inventory example: 
```
$ more inputs/hosts
[demo]
demo-qfx10k2-14    ansible_host=172.25.90.67
demo-qfx10k2-15    ansible_host=172.25.90.68

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

Run the microservice: This will instanciate a container, execute the service, and remove the container.  
```
$ docker run -it --rm -v ${PWD}/inputs:/inventory -v ${PWD}/outputs:/outputs jnprautomate/junos-command-collector
Collect Junos commands
  > Check inventory file
  > Inventory file found (inputs/inventory.ini)
  > Collect Junos commands

PLAY [collect data from devices] **************************************************************************************************************

TASK [include_vars] ***************************************************************************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-configuration : Create output directory for device] *****************************************************************************
changed: [demo-qfx10k2-14]
changed: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in text format from devices] **************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-configuration : Copy collected configuration in a local directory] **************************************************************
changed: [demo-qfx10k2-15]
changed: [demo-qfx10k2-14]

TASK [collect-configuration : Collect configuration in set format from devices] ***************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in json format from devices] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : Collect configuration in xml format from devices] ***************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-configuration : copy collected configuration in a local directory] **************************************************************
skipping: [demo-qfx10k2-14]
skipping: [demo-qfx10k2-15]

TASK [collect-commands : Create output directory for device] **********************************************************************************
ok: [demo-qfx10k2-15]
ok: [demo-qfx10k2-14]

TASK [collect-commands : Pass the junos commands and save the output] *************************************************************************
ok: [demo-qfx10k2-15] => (item=show chassis hardware)
ok: [demo-qfx10k2-14] => (item=show chassis hardware)
ok: [demo-qfx10k2-15] => (item=show version)
ok: [demo-qfx10k2-14] => (item=show version)

PLAY RECAP ************************************************************************************************************************************
demo-qfx10k2-14            : ok=6    changed=2    unreachable=0    failed=0
demo-qfx10k2-15            : ok=6    changed=2    unreachable=0    failed=0
```
List the containers. The container doesnt exist anymore
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
Here's the output generated
```
$ tree
.
├── inputs
│   ├── collector-details.yml
│   └── inventory.ini
└── outputs
    ├── demo-qfx10k2-14
    │   ├── configuration-demo-qfx10k2-14.conf
    │   ├── show chassis hardware.txt
    │   └── show version.txt
    └── demo-qfx10k2-15
        ├── configuration-demo-qfx10k2-15.conf
        ├── show chassis hardware.txt
        └── show version.txt

4 directories, 8 files

```

