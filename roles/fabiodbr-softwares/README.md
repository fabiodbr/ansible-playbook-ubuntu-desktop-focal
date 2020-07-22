Ansible Role: fabiodbr-softwares
=========

This role installs softwares.

Requirements
------------

None.

Role Variables
--------------

user
anaconda_url
anaconda_md5
rstudio_version

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
    - role: fabiodbr-softwares
      become: yes
      vars:
        install:
          - anaconda
          - apt-packages
          - bash-powerline-shell
          - google-chrome
          - docker-ce
          - gimp
          - gnome-themes-github
          - gnome-theme-flat-remix
          - google-cloud-sdk
          - graphics-drivers
          - keybase
          - menlo-font
          - meslolgs-font # vscode terminal font
          - nerdfonts
          - paper-icon-theme
          - python3-packages
          - R-base
          - R-studio
          - terminator
          - typora
          - virtualbox
          - visual-studio-code
          - vscode-extensions
```

License
-------

MIT

Author Information
------------------

This role was created in 2020 by [Fabio Rizzi](https://github.com/fabiodbr).
