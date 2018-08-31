Config Transformations
======================

Development
-----------

### First Development Build

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Copy Config.Development.ps1.template to Config.Development.ps1.
Developer             | Modify properties in Config.Development.ps1.
Developer             | Execute `psake build`.
copy-configs (psake)  | Copy appsettings.Development.json.template to appsettings.Development.json.
copy-configs (psake)  | Replace variable placeholders with values in appsettings.Development.json.

### Second Development Build

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Execute `psake build` or run project in Visual Studio.

### Change Development Setting

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Modify settings in appsettings.Development.json.
Developer             | Execute `psake build` or run project in Visual Studio.

Production
----------

Actor                  | Action
---------------------- | ----------------------------------------------------------------
Jenkins                | Set `Environment` and `SecretConfigPath` environment variables.
Jenkins                | Execute `psake clean`.
clean (psake)          | Revert all changes in working copy.
Jenkins                | Execute `psake publish-web`.
copy-configs (psake)   | Replace variable placeholders with values in appsettings.Production.json.
update-version (psake) | Replace Version and AssemblyVersion values in project file.
