# Chapter 4 - Ansible Playbooks

## Development Environment

[ssh-enabled-centos](https://github.com/joomanba/ssh-enabled-docker/tree/master/centos)

```bash
docker run -d --name centos01 --privileged -it joomanba/ssh-enabled-centos
docker run -d --name centos02 --privileged -it joomanba/ssh-enabled-centos
cat ~/.ssh/id_rsa.pub | docker exec -i centos1  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub | docker exec -i centos2  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
```
