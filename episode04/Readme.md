# Episode 4 - Your first real-world playbook

[Ansible 101 - Episode 4 - Your first real-world playbook](https://www.youtube.com/watch?v=SLW4LX7lbvE&t=0s)

[Ansible 101 Live Stream Episode 4 Agenda](https://github.com/geerlingguy/ansible-for-devops/issues/235)

[geerlingguy/dotfiles](https://github.com/geerlingguy/dotfiles)

[https://ansible.jeffgeerling.com/](https://ansible.jeffgeerling.com/)

## Development Environment

[ubuntu-ssh-enabled](https://github.com/mmumshad/ubuntu-ssh-enabled)

```bash
docker run -d --name server1 mmumshad/ubuntu-ssh-enabled
cat ~/.ssh/id_rsa.pub | docker exec -i server1  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
```

## Running Ansible Playbook

Checking Syntax of playbook

```bash
ansible-playbook main.yml --syntax-check
```

```bash
ansible-playbook main.yml
```

## Issues
