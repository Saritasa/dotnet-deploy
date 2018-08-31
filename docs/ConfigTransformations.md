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
copy-configs (psake)  | Copy App.Development.config.template to App.Development.config.
copy-configs (psake)  | Replace variable placeholders with values in App.Development.config.
BeforeBuild (MSBuild) | Apply App.Development.config transformation to App.config.

### Second Development Build

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Execute `psake build` or run project in Visual Studio.
BeforeBuild (MSBuild) | Apply App.Development.config transformation to App.config.

### Change Development Setting

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Modify App.Development.config transformation.
Developer             | Execute `psake build` or run project in Visual Studio.
BeforeBuild (MSBuild) | Apply App.Development.config transformation to App.config.

Production
----------

Actor                  | Action
---------------------- | ----------------------------------------------------------------
Jenkins                | Set `Environment` and `SecretConfigPath` environment variables.
Jenkins                | Execute `psake clean`.
clean (psake)          | Revert all changes in working copy.
Jenkins                | Execute `psake publish-web`.
copy-configs (psake)   | Replace variable placeholders with values in App.Production.config.
update-version (psake) | Execute `GitVersion /updateassemblyinfo`.
GitVersion             | Add or update AssemblyVersion, AssemblyInformationalVersion, AssemblyFileVersion attributes.
