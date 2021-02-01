# Episode 3 - Introduction to Playbooks

[Ansible 101 - Episode 3 - Introduction to Playbooks](https://www.youtube.com/watch?v=WNmKjtWtqIc&t=0s)

## Development Environment

[ssh-enabled-centos](https://github.com/joomanba/ssh-enabled-docker/tree/master/centos)

```bash
docker run -d --name centos01 --privileged -it joomanba/ssh-enabled-centos
docker run -d --name centos02 --privileged -it joomanba/ssh-enabled-centos
cat ~/.ssh/id_rsa.pub | docker exec -i centos1  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub | docker exec -i centos2  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
```

## Running Ansible Playbook

```bash
ansible-playbook playbook.yml

TASK [Ensure Apache is started now and at boot] **********************************************************************************************************************
fatal: [172.17.0.3]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}
fatal: [172.17.0.2]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}


```

## Limiting playbooks to particular hosts and groups

```bash
ansible-playbook playbook.yml ec2 --limit 172.17.0.2
```

## Ansible Inventory

```bash
ansible-inventory --list
```

## Issues

Caused by Apache empty configuration

```bash
ansible ec2 -a "systemctl status httpd.service"

172.17.0.3 | FAILED | rc=3 >>
* httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:httpd.service(8)non-zero return code
172.17.0.2 | FAILED | rc=3 >>
* httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Thu 2021-01-28 05:24:18 UTC; 1h 19min ago
     Docs: man:httpd.service(8)
  Process: 1130 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 1130 (code=exited, status=1/FAILURE)


```
