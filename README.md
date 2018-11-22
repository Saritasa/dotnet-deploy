Windows Service Deployment
==========================

Set up Server
-------------

### Enable WinRM

Enable WinRM over HTTPS on server, generate certificate, add firewall rule:

```powershell
Install-PackageProvider NuGet -Force; Install-Module Saritasa.WinRM -Force; Install-WinrmHttps
```

More details: [WinRM Configuration](https://github.com/Saritasa/PSGallery/blob/master/docs/WinRMConfiguration.md)

### Trust Server

Add client to trusted certificate authorities list on build server or developer PC:

```powershell
Install-Module Saritasa.Web -Force
Import-TrustedSslCertificate web.saritasa.local 5986
```

### Configure Server

Edit `inventory.yml`. Set correct values:

- hostname
- ansible_username
- ansible_password

Execute Ansible playbook:

```sh
cd ansible
ansible-playbook -i inventory.yml app.yml -v
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
? Select all used project types: Windows Service
? Is .NET Core used? No
? Do you need GitFlow helper tasks? No
? Do you need to run NUnit or xUnit tests? No
```

Execute suggested commands to update `.gitignore` and add scripts to Git stage. Edit generated `BuildTasks.ps1`, `PublishTasks.ps1` scripts.

Required Software
-----------------

You need following software installed:

- [Visual Studio 2017](https://www.visualstudio.com/downloads/)
- [psake](https://github.com/psake/psake)
- [Git](https://git-scm.com/)
- [NuGet](https://www.nuget.org/)

You can easily install most software with Chocolatey package manager. To do that run `PowerShell` as administrator and type commands:

```
PS> iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
PS> choco install psake git nuget.commandline
```

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
psake publish-service
```

### Staging

Edit properties in `Config.Staging.ps1`. Execute command:

```powershell
psake publish-service -properties "@{Environment='Staging'}"
```

### Production

Edit properties in `Config.Production.ps1`. Execute command:

```powershell
psake publish-service -properties "@{Environment='Production'}"
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
psake publish-service
```

### Jenkins

Create a credential with **secret file** type. Add credential parameter to job with `SecretConfig` name. Add following code to pipeline:

```groovy
    environment {
        SecretConfigPath = credentials("${env.SecretConfig}")
    }
```

Articles
--------

[Config Transformations](docs/ConfigTransformations.md)
