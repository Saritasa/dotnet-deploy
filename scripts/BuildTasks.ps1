Properties `
{
    $Configuration = $null
    $MaxWarnings = 0
    $InformationalVersion = $null
    $MajorMinorPatch = $null
}

$root = $PSScriptRoot
$src = Resolve-Path "$root\..\src"
$workspace = Resolve-Path "$root\.."

Task pre-build -depends copy-configs, update-version -description 'Copy configs, update version, restore NuGet packages.' `
{
    Initialize-MSBuild


    Invoke-NugetRestore -SolutionPath "$src\DeployDemo.sln"

}

Task build -depends pre-build -description '* Build all projects.' `
    -requiredVariables @('Configuration') `
{


    $buildParams = @("/p:Environment=$Environment")
    Invoke-ProjectBuild -ProjectPath "$src\DeployDemo.sln" -Configuration $Configuration `
        -BuildParams $buildParams

}

Task clean -description '* Clean up workspace.' `
{
    Exec { git clean -xdf -e packages/ -e node_modules/ }
}

Task copy-configs -description 'Create configs based on App.config.template and Web.config.template if they don''t exist.' `
{
    $configFilename = "$workspace\Config.$Environment.ps1"
    $templateFilename = "$workspace\Config.$Environment.ps1.template"

    if (!(Test-Path $configFilename) -and (Test-Path $templateFilename))
    {
        Write-Warning "Did you forget to copy $templateFilename to $($configFilename)?"
        return
    }



    $projectName = 'DeployDemo.Service'
    $templateFile = "$src\$projectName\App.$Environment.config.template"
    $configFile = "$src\$projectName\App.$Environment.config"


    if (!(Test-Path $configFile))
    {
        Copy-Item $templateFile $configFile
    }

    Update-VariablesInFile -Path $configFile `
        -Variables `
            @{
                DatabaseServer = $DatabaseServer
                DatabaseUsername = $DatabaseUsername
                DatabasePassword = $DatabasePassword
            }


}

Task update-version -depends get-version -description 'Replace package version in web project.' `
    -requiredVariables @('MajorMinorPatch', 'InformationalVersion') `
{
    if ($Environment -eq 'Development') # It's a developer machine.
    {
        return
    }

    Update-AssemblyInfoFile -Path $src -AssemblyVersion $AssemblySemVer `
        -AssemblyFileVersion $AssemblySemVer -AssemblyInfoVersion $InformationalVersion
}

Task code-analysis -depends pre-build `
    -requiredVariables @('Configuration', 'MaxWarnings') `
{
    $buildParams = @("/p:Environment=$Environment")

    $solutionPath = "$src\DeployDemo.sln"
    $logFile = "$workspace\Warnings.txt"

    Exec { msbuild.exe $solutionPath '/m' '/t:Build' "/p:Configuration=$Configuration" '/verbosity:normal' '/fileLogger' "/fileloggerparameters:WarningsOnly;LogFile=$logFile" $buildParams }

    $warnings = (Get-Content $logFile | Measure-Object -Line).Lines
    Write-Information "Warnings: $warnings"

    if ($warnings -gt $MaxWarnings)
    {
        throw "Warnings number ($warnings) is upper than limit ($MaxWarnings)."
    }
}

