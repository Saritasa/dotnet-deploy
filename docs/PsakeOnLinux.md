Psake on Linux
==============

Here's a small instruction how to use psake on Linux.

- Install PowerShell Core

    https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6

- Clone psake repository

    ```sh
    git clone https://github.com/psake/psake /opt/psake
    ```

- Create wrapper

    ```sh
    sudo sh -c 'echo "#!/bin/env sh\npwsh -Command \"& /opt/psake/src/psake.ps1 \$@; if (\\\$psake.build_success -eq \\\$false) { exit 1 } else { exit 0 }\"" > /usr/bin/psake'
    sudo chmod +x /usr/bin/psake
    ```

    It will create following script:

    ```sh
    #!/usr/bin/env sh
    pwsh -Command "& /opt/psake/src/psake.ps1 $@; if (\$psake.build_success -eq \$false) { exit 1 } else { exit 0 }"
    ```

You may use Ansible to do the actions above. Tested on Ubuntu Server 18.04.

```yaml
- hosts: buildserver

  roles:
    - brentwg.powershell

  vars:
    ansible_become: true

  tasks:
    - name: Clone psake repository
      git:
        repo: 'https://github.com/psake/psake'
        dest: /opt/psake
    - name: Create psake wrapper
      copy:
        content: |
          #!/usr/bin/env sh
          pwsh -Command "& /opt/psake/src/psake.ps1 $@; if (\$psake.build_success -eq \$false) { exit 1 } else { exit 0 }"
        dest: /usr/bin/psake
        mode: 0755

  pre_tasks:
    - name: Enable Universe repository
      apt_repository:
        repo: deb http://archive.ubuntu.com/ubuntu bionic universe
      become: yes
```
