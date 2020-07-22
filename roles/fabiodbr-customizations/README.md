Ansible Role: Focal-Customizations
=========

A personal customization for softwares used in Ubuntu 20.04 (focal fossa).

Requirements
------------

The softwares listed.

Role Variables
--------------

Dependencies
------------

None.

Example Playbook
----------------

```yaml
---
- hosts: localhost
  connection: local
  roles:
    - role: fabiodbr-customizations
      become: yes
      vars:
        configure:
          - color-emoji
          - gnome-keyring-credential-helper
          - remove-ubuntu-dock
          - sudoers
          - terminator-nord-theme
          - timedatectl
          - tmp.mount
```

License
-------

MIT

Author Information
------------------

This role was created in 2020 by [Fabio Rizzi](https://github.com/fabiodbr).
