# Episode 5 - Playbook handlers, environment vars, and variables

[Ansible 101 - Episode 5 - Playbook handlers, environment vars, and variables](https://www.jeffgeerling.com/blog/2020/ansible-101-jeff-geerling-youtube-streaming-series#e05)

[https://ansible.jeffgeerling.com/](https://ansible.jeffgeerling.com/)

## Development Environment

[ubuntu-ssh-enabled](https://github.com/joomanba/ssh-enabled-docker/tree/master/ubuntu)

```bash
docker run -d -p 8080:8080 -p 80:80 --name centos --privileged -it joomanba/ssh-enabled-centos
cat ~/.ssh/id_rsa.pub | docker exec -i centos  /bin/bash -c "cat >> /centos/.ssh/authorized_keys"

ssh-keygen -R 172.17.0.2

ssh -i ~/.ssh/id_rsa  root@172.17.0.2
```

## Playbook handlers

```bash
    handlers:
        - name: restart apache 
          service:
            name: httpd
            state: restarted
          notify: restart memcached
        
        - name: restart memcached
          service:
            name: memcached
            state: restarted
    tasks:
        ...
        - name: Copy test config file
          copy:
            src: files/test.conf
            dest: /etc/httpd/conf.d/test.conf
          notify: 
            - restart apache

```

## Environments variables

```bash
    tasks:
        - name: Add an environment variable to the remote user's shell
          lineinfile:
            dest: "~/.bash_profile"
            regexp: '^ENV_VAR= '
            line: 'ENV_VAR=value'
          become: false
```

```bash

  vars:
    key: value

  vars_files:
    - vars/main.yml

  vars:
    proxy_vars:
      http_proxy: http://exmple-proxy:80/
      https_proxy: https:/example-proxy:80/

  environment:
    http_proxy: http://exmple-proxy:80/
    https_proxy: https:/example-proxy:80/

  tasks:
    - name: Get the value of an environment variable
      shell: 'source ~/.bash_profile && echo $ENV_VAR'
      register: foo
      become: false

    - debug: msg="The variable is {{ foo.stdout }}"

    - name: Download a file
      get_url:
        url: http://ipv4.download.thkinkbroadband.com/20MB.zip
        dest: /tmp
      environment: proxy_vars

```

## Dynamic variable files for multi-OS

```bash
  # vars/apache_RedHat.yml, apache_Debian.yml
  vars_files:
    - vars/apache_default.yml
    - vars/apache_{{ ansible_os_family }}.yml

```

```bash

  # Arbitrary task here, not needed but the point is you can have any generic tasks directly in main.yml
  - name: get the date
    shell: `date`
    register: date

  - include: debian.yml
    when: ansible_os_family == 'Debian'

  - include: redhat.yml
    when: ansible_os_family == 'RedHat'

```

```bash

    pre_tasks:
    - name: Load variable files
      include_vars: "{{ item }}"
      with_first_found:
        - "vars/apache_{{ ansible_os_family }}.yml"
        - "vars/apache_default.yml"

```

## Ansible facts and setup module

```bash

  ansible centos -m setup

  gather_facts: false # can't find 'ansible_os_family'

```

## Registered variables

```bash

  tasks:
    - name: Ensure Apache is installed
      package:
        name: "{{ apache_package }}"
        state: present
      register: foo

    - debug: var=foo #foo.rc

```

## facter and ohai

```bash

  gather_facts: true

```

## Preview of Ansible Vault

## Issues

1. "Service is in unknown state" in ansible

    Changing 'centos:lastest' to 'geerlingguy/docker-centos7-ansible' in CentOS Docker base image

2. fatal: [172.17.0.2]: FAILED! => {"msg": "Missing sudo password"}

    ```bash
    ansible-playbook --ask-become-pass apache.yml
    ```

    ```bash
   sudo visudo # /etc/sudoers

    root    ALL=(ALL)       ALL                
    test1   ALL=(ALL)       ALL # Initial Password Asked
    test2   ALL=(ALL)       NOPASSWD: ALL # No Password Ashed
    ```
