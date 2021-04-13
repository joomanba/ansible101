# Episode 2 - Ad-hoc tasks and Inventory

[Ansible 101 - Episode 2 - Ad-hoc tasks and Inventory](https://www.youtube.com/watch?v=7kVfqmGtDL8&t=0s)

## Development Environment

[ubuntu-ssh-enabled](https://github.com/mmumshad/ubuntu-ssh-enabled)

```bash
docker run -d --name server1 mmumshad/ubuntu-ssh-enabled
docker run -d --name server2 mmumshad/ubuntu-ssh-enabled

# execute 'ssh-key-gen -t rsa' in containers created above

cat ~/.ssh/id_rsa.pub | docker exec -i server1  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub | docker exec -i server2  /bin/bash -c "cat >> /root/.ssh/authorized_keys"
```

## Inventory file for multiple servers

ansible.cfg

```bash
[defaults]
inventory = inventory
```

inventory

```bash
# Application Servers
[app]
172.17.0.2

# Database Servers
[db]
172.17.0.3

# Group has all the Servers
[multi:children]
app
db

# Variables for all the Servers
[multi:vars]
ansible_ssh_user=root
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Ansible ad-hoc commands

```bash
ansible multi -a "date"                                                            
172.17.0.2 | CHANGED | rc=0 >>
Wed Jan 27 01:29:23 UTC 2021
```

Increase the value of Ansible fork to speed up the process of running commands on tens or hundreds of servers

```bash
ansible multi -a "date" -f 2
```

Run Ansible asynchronously

```bash
# -b BECOME_METHOD
# -B SECONDS, --background SECONDS run asynchronously, failing after X seconds (default=N/A)

> ansible -i inventory multi -b -B 600 -P 0 -a "apt update"
172.17.0.2 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "ansible_job_id": "238657224285.1323",
    "changed": true,
    "finished": 0,
    "results_file": "/root/.ansible_async/238657224285.1323",
    "started": 1
}

> ansible -i inventory multi -b -m async_status -a "jid=238657224285.1323"
172.17.0.2 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "ansible_job_id": "238657224285.1323",
    "changed": true,
    "cmd": [
        "apt",
        "update"
    ],
    "delta": "0:00:02.616362",
    "end": "2021-01-27 01:47:58.134048",
    "finished": 1,
    "rc": 0,
    "start": "2021-01-27 01:47:55.517686",
    "stderr": "\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.",
    "stderr_lines": [
        "",
        "WARNING: apt does not have a stable CLI interface. Use with caution in scripts."
    ],
```

```bash
ansible multi -b -m shell -a "tail /var/log/messages | grep ansible-command | wc -1"
```
