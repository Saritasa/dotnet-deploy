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
copy-configs (psake)  | Copy Web.Development.config.template to Web.Development.config.
copy-configs (psake)  | Replace variable placeholders with values in Web.Development.config.
BeforeBuild (MSBuild) | Apply Web.Development.config transformation to Web.config.

### Second Development Build

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Execute `psake build` or run project in Visual Studio.
BeforeBuild (MSBuild) | Apply Web.Development.config transformation to Web.config.

### Change Development Setting

Actor                 | Action
--------------------- | ----------------------------------------------------------------
Developer             | Modify Web.Development.config transformation.
Developer             | Execute `psake build` or run project in Visual Studio.
BeforeBuild (MSBuild) | Apply Web.Development.config transformation to Web.config.

Production
----------

Actor                  | Action
---------------------- | ----------------------------------------------------------------
Jenkins                | Set `Environment` and `SecretConfigPath` environment variables.
Jenkins                | Execute `psake clean`.
clean (psake)          | Revert all changes in working copy.
Jenkins                | Execute `psake publish-web`.
copy-configs (psake)   | Replace variable placeholders with values in Web.Production.config.
update-version (psake) | Add or update AssemblyVersion, AssemblyInformationalVersion, AssemblyFileVersion attributes.
