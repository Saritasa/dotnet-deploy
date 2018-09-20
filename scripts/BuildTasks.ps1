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
    if (!$IsLinux)
    {
        Initialize-MSBuild
    }

}

Task build -depends pre-build -description '* Build all projects.' `
    -requiredVariables @('Configuration') `
{
    # TODO: Fix solution name.

    Exec { dotnet build -c $Configuration "$src\Example.sln" }

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

    # TODO: Fix project name.

    $projectName = 'Example.Web'
    $templateFile = "$src\$projectName\appsettings.$Environment.json.template"
    $configFile = "$src\$projectName\appsettings.$Environment.json"


    if (!(Test-Path $configFile))
    {
        Copy-Item $templateFile $configFile
    }

    Update-VariablesInFile -Path $configFile `
        -Variables `
            @{
                DatabaseServer = ($DatabaseServer -replace '\\', '\\')
                DatabaseUsername = ($DatabaseUsername -replace '\\', '\\')
                DatabasePassword = ($DatabasePassword -replace '\\', '\\')
            }


}

Task update-version -description 'Replace package version in web project.' `
    -depends get-version `
    -requiredVariables @('MajorMinorPatch', 'InformationalVersion') `
{
    if ($Environment -eq 'Development') # It's a developer machine.
    {
        return
    }

    $branchName = Exec { git rev-parse --abbrev-ref HEAD }

    if ($branchName -like 'origin/*')
    {
        throw "Expected local branch. Got: $branchName"
    }

    if ($branchName -eq 'master')
    {
        $tag = Exec { git describe --exact-match --tags }
        if (!$tag)
        {
            throw "Production releases without tag are not allowed."
        }
    }


    # TODO: Fix project name.
    $fileName = "$src\Example\Example.csproj"
    $lines = Get-Content $fileName
    $lines | ForEach-Object { $_ -replace '<Version>[\d\.\w+-]*</Version>', "<Version>$InformationalVersion</Version>" `
        -replace '<AssemblyVersion>[\d\.]*</AssemblyVersion>', "<AssemblyVersion>$MajorMinorPatch.0</AssemblyVersion>" } |
        Set-Content $fileName -Encoding UTF8

}

Task code-analysis -depends pre-build `
    -requiredVariables @('Configuration', 'MaxWarnings') `
{
    $buildParams = @("/p:Environment=$Environment")
    # TODO: Fix solution name.
    $solutionPath = "$src\Example.sln"
    $logFile = "$workspace\Warnings.txt"

    Exec { msbuild.exe $solutionPath '/m' '/t:Build' "/p:Configuration=$Configuration" '/verbosity:normal' '/fileLogger' "/fileloggerparameters:WarningsOnly;LogFile=$logFile" $buildParams }

    $warnings = (Get-Content $logFile | Measure-Object -Line).Lines
    Write-Information "Warnings: $warnings"

    if ($warnings -gt $MaxWarnings)
    {
        throw "Warnings number ($warnings) is upper than limit ($MaxWarnings)."
    }
}

