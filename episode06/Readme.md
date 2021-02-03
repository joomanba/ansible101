# Episode 6 - Ansible Vault and Roles

[Ansible 101 - Episode 6 - Ansible Vault and Roles](https://www.youtube.com/watch?v=JFweg2dUvqM&t=911s)

[https://ansible.jeffgeerling.com/](https://ansible.jeffgeerling.com/)

## Development Environment

## Encrypting a vars file with Vault

[Youtube Clip](https://www.youtube.com/watch?v=JFweg2dUvqM&t=840s)

```bash

> ansible-vault encrypt vars/api_key.yml

> ansible-playbook main.yml             
ERROR! Attempting to decrypt but no vault secrets found

> ansible-playbook main.yml --ask-vault-pass
Vault password: 

> ansible-playbook main.yml --vault-password-file ~/.ansible/api-key-pass.txt

> ansible-vault decrypt vars/api_key.yml    

> ansible-vault encrypt vars/api_key.yml 

> ansible-vault edit vars/api_key.yml   

> ansible-vault rekey vars/api_key.yml

```

```bash

# vars/api_key.yml
---
myapp_git_repo: url_here
myapp_api_key: "**********"

```

## Task features - conditionals and tags

```bash

# main.yml
  tasks:
    - name: Echo the API key which was injected into the env
      shell: echo $API_KEY
      environment:
        API_KEY: "{{ myapp_api_key }}"
      register: echo_result
      when:
      changed_when:
      failed_when:
      ignore_errors: true
      tags:
        - api
        - echo

> ansible-playbook main.yml --tags api

```

## Includes and imports

```bash

  handlers:
    - import_tasks: handlers/apache.yml

  tasks:
    - import_tasks: tasks/apache.yml

```

## Caution about dynamic tasks

```bash

    - include_tasks: tasks/log.yml 

    - name: Check for existing log files in dynamic log_file_paths variable
      find:
        paths: "{{ item }}"
        patterns: '*.log'
      register: found_log_file_paths
      with_item: "{{ log_file_paths }}"

```

## Playbook includes

```bash

  handlers:
    - import_tasks: handlers/apache.yml

  tasks:
    - import_tasks: tasks/apache.yml       

- import_playbook: app.yml


```

## Node.js playbook example

```bash

---
- hosts: centos
  become: yes

  vars:
    node_apps_location: /usr/local/opt/node

  tasks:
    - name: Install EPEL repo.
      yum: name=epel-release state=present

    - name: Install Node.js and npm.
      yum: name=npm state=present enablerepo=epel

    - name: Install Forever (to run our Node.js app).
      npm: name=forever global=yes state=present

    - name: Ensure Node.js app folder exists.
      file: "path={{ node_apps_location }} state=directory"

    - name: Copy example Node.js app to server.
      copy: "src=app dest={{ node_apps_location }}"

    - name: Install app dependencies defined in package.json.
      npm: "path={{ node_apps_location }}/app"

    - name: Check list of running Node.js apps.
      command: forever list
      register: forever_list
      changed_when: false

    - name: Start example Node.js app.
      command: "forever start {{ node_apps_location }}/app/app.js"
      when: "forever_list.stdout.find(node_apps_location + '/app/app.js') == -1"

```

## Roles

```bash
  
  ...
  roles:
    - nodejs

  tasks:

```

```bash

# roles/nodejs/meta/main.yml

    ---
    dependencies: []

# roles/nodejs/tasks/main.yml
    ---
    - name: Install Node.js (npm plus all its dependencies).
      yum: name=npm state=present enablerepo=epel

    - name: Install forever module (to run our Node.js app).
      npm: name=forever global=yes state=present

```

## Real-world flexible role usage

```bash

#solr/roles
> ansible-galaxy role init test

```

```bash

---
- hosts: centos
  become: yes

  vars:
    firewall_log_dropped_packets: false

  roles:
    - geerlingguy.ntp
    - geerlingguy.firewall
    - geerlingguy.java
    - geerlingguy.solr
    - geerlingguy.jenkins


```

## The Golden Hammer

## Issues
