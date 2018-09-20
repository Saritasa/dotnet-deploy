ASP.NET Core Deployment on Linux
================================

Set up Build Server
-------------------

Install .NET Core SDK, PowerShell Core, psake.

You can do it with Ansible:

```sh
ansible-galaxy install brentwg.powershell geerlingguy.jenkins geerlingguy.nginx ocha.dotnet-core
ansible-playbook -i inventory.yml --limit buildservers buildserver.yml -Kv
```

Set up Web Server
-----------------

Edit `inventory.yml`. Set correct values:

- hostname
- site_name
- service_name
- deploy_username
- deploy_key
- ansible_username

Install Ansible modules:

```sh
ansible-galaxy install brentwg.powershell geerlingguy.jenkins geerlingguy.nginx ocha.dotnet-core
```

Execute Ansible playbook:

```sh
cd ansible
ansible-playbook -i inventory.yml --limit webservers web.yml -Kv
```

Scaffold Scripts
----------------

Install Yeoman.

```powershell
npm i -g yo
```

Install generator.

```powershell
npm i -g generator-psgallery
```

Go to project directory and run generator.

```powershell
yo psgallery
```

Choose following options:

```
? Where are project source files located (relative to BuildTasks.ps1)? ..\src
? Select all used project types: Web
? Is .NET Core used? Yes
? Do you need GitFlow helper tasks? No
? Do you need to run NUnit or xUnit tests? No
? Do you need admin tasks, remote management capabilities? No
? Select services which you want to control from PowerShell:
```

Execute suggested commands to update `.gitignore` and add scripts to Git stage. Edit generated `BuildTasks.ps1`, `PublishTasks.ps1` scripts.

Required Software
-----------------

You need following software installed:

- [psake](https://github.com/psake/psake)
- [Git](https://git-scm.com/)
- [.NET Core SDK 2.1](https://www.microsoft.com/net/download)

Build Project
-------------

Make sure you have [psake](https://chocolatey.org/packages/psake) task runner installed.

Copy `Config.Development.ps1.template` to `Config.Development.ps1`. Edit properties. Execute command in repository root:

```powershell
psake build
```

Clean
-----

Execute command to remove build artifacts and temporary files:

```powershell
psake clean
```

Publish
-------

### Development

Edit properties in `Config.Development.ps1`. Execute command:

```powershell
psake publish-web
```

### Staging

Edit properties in `Config.Staging.ps1`. Execute command:

```powershell
psake publish-web -properties "@{Environment='Staging'}"
```

### Production

Edit properties in `Config.Production.ps1`. Execute command:

```powershell
psake publish-web -properties "@{Environment='Production'}"
```

Add any additional properties.

You may use environment variable also:

```powershell
$env:Environment = 'Production'
psake publish-service
```

Use Secret Config
-----------------

### Local Run

Copy `SecretConfig.Production.ps1.template` somewhere. Edit properties. Execute command:

```powershell
$env:Environment = 'Production'
$env:SecretConfigPath = 'C:\Path\To\SecretConfig.Production.ps1'
psake publish-web
```

### Jenkins

Create a credential with **secret file** type. Add credential parameter to job with `SecretConfig` name. Add following code to pipeline:

```groovy
    environment {
        SecretConfigPath = credentials("${env.SecretConfig}")
    }
```

Create SSH credential with `deployuser` name. Use it in `sshagent` block:

```groovy
    script {
        sshagent(['deployuser']) {
            sh script: "psake publish-web"
        }
    }
```

Articles
--------

- [Config Transformations](docs/ConfigTransformations.md)
- [Psake on Linux](docs/PsakeOnLinux.md)
