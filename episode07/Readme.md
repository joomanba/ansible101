# Episode 7 - Ansible Galaxy, ansible-lint, and Molecule testing

[Ansible 101 - Episode 7 - Ansible Galaxy, ansible-lint, and Molecule testing](https://www.youtube.com/watch?v=FaXVZ60o8L8&t=0s)

[https://ansible.jeffgeerling.com/](https://ansible.jeffgeerling.com/)

## 목차
[1. Ansible Galaxy](#ansible-galaxy)

[2. Chapter 13 - Testing and CI for Ansible Content](#chapter-13---testing-and-ci-for-ansible-content)

## Ansible Galaxy
[THERE'S A ROLE FOR THAT! HOW TO EVALUATE COMMUNITY ROLES FOR YOUR PLAYBOOK](https://www.ansible.com/theres-a-role-for-that)

[homebrew](https://galaxy.ansible.com/geerlingguy/homebrew)

```shell
ansible-galaxy role install geerlingguy.homebrew
```

*ansible.cfg*
```yaml
[defaults]
nocows = True
roles_path = ./roles
```

*requirements.yml*
```yaml
---
roles:
  - name: elliotweiser.osx-command-line-tools
    version: 2.3.0
  - name: geerlingguy.homebrew
    version: 3.1.0
```

```shell
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml -K
```

## Chapter 13 - Testing and CI for Ansible Content

![Testing](images/images001.png)

### debugging

```yaml
---
- hosts: localhost
  gather_facts: no
  connection: local

  tasks:
    - name: Register the output of the 'uptime' command.
      command: uptime
      register: system_uptime

    - name: Print the registered output of the 'uptime' command.
      debug:
        var: system_uptime.stdout

    - name: Print a message if a command resulted in a change.
      debug:
        msg: "Command resulted in a change"
      when: system_uptime is changed
```
### fail and assert

```yaml
---
- hosts: 127.0.0.1
  gather_facts: no
  connection: local

  vars:
    should_fail_via_fail: false
    should_fail_via_assert: false
    should_fail_via_complex_assert: false

  tasks:
    - name: Fail if conditions warrant a failure
      fail:
        msg: "There was an epic failure"
      when: should_fail_via_fail

    - name: Stop playbook if an assertion isn't validated
      assert:
        that: "should_fail_via_assert != true"

    - name: Assertion can have contain condtions.
      assert:
        that:
          - should_fail_via_fail != true
          - should_fail_via_assert != true
          - should_fail_via_complex_assert != true
```

### Linting YAML with yamllint

```shell
pip3 install yamllint

> yamllint .
./lint-example.yml
  1:1       warning  missing document start "---"  (document-start)
  2:17      warning  truthy value should be one of [false, true]  (truthy)
  7:22      error    trailing spaces  (trailing-spaces)
  8:31      warning  too few spaces before comment  (comments)
  12:34     error    no new line character at the end of file  (new-line-at-end-of-file)

```

*.yamllint*
```yaml
---
extends: default

rules:
    truthy:
        allowed-values:
            - 'true'
            - 'false'
            - 'yes'
            - 'no'
```

```shell
> yamllint .

>  echo $?                                        
0
```

### Performing a --syntax-check

```yaml
- hosts: localhost
  gather_facts: false
  connection: local

  tasks:
    # Syntax check will pass whether or not this file exists
    - include_tasks: date.yml

    # This will cause a failure, since it can be checked statically.
    - import_tasks: free.yml

    - name: Print a debug message
      debug:
        msg: "Hello there."
```

```shell
> ansible-playbook syntax-check.yml --syntax-check

playbook: syntax-check.yml
```

### Linting Ansible content with ansible-lint

*main.yml (before)*

```yaml
---
- hosts: localhost
  gather_facts: false
  connection: local

  tasks:
    - shell: uptime
      register: system_uptime

    - name: Print the registered output of the 'uptime' command.
      debug:
        var: system_uptime.stdout
```

```shell
pip3 install ansible-lint

> ansible-lint main.yml
command-instead-of-shell: Use shell only when shell functionality is required
main.yml:7 Task/Handler: shell  uptime

no-changed-when: Commands should not change things if nothing needs doing
main.yml:7 Task/Handler: shell  uptime

unnamed-task: All tasks should be named
main.yml:7 Task/Handler: shell  uptime
```

*main.yml (after)*

```shell
---
- hosts: localhost
  gather_facts: false
  connection: local

  tasks:
    - name: Get system uptime
      command: uptime
      changed_when: false
      register: system_uptime

    - name: Print the registered output of the 'uptime' command.
      debug:
        var: system_uptime.stdout
```

[Ansible Lint Rules](https://ansible-lint.readthedocs.io/en/latest/default_rules.html#meta-incorrect)

### Automated testing and development with Molecule

[Ansible Molecule](https://molecule.readthedocs.io/en/latest/)
