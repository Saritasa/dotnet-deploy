Properties `
{
    $Configuration = $null
    $WebServer = $null
    $SiteName = $null


    $DeployUsername = $null
    $DeployPassword = $null

}

$root = $PSScriptRoot
$src = Resolve-Path "$root\..\src"
$workspace = Resolve-Path "$root\.."


Task pre-publish -depends pre-build -description 'Set common publish settings for all deployments.' `
    -requiredVariables @('DeployUsername') `
{
    if (!$IsLinux)
    {
        $credential = New-Object System.Management.Automation.PSCredential($DeployUsername, (ConvertTo-SecureString $DeployPassword -AsPlainText -Force))
        Initialize-WebDeploy -Credential $credential
    }
}

Task publish-web -depends pre-publish -description '* Publish all web apps to specified server.' `
    -requiredVariables @('Configuration', 'WebServer', 'SiteName') `
{

    $buildParams = @("/p:Environment=$Environment")

    # TODO: Fix project name.
    $projectName = 'Example.Web'
    $packagePath = "$workspace\$projectName.zip"
    Invoke-PackageBuild -ProjectPath "$src\$projectName\$projectName.csproj" `
        -PackagePath $packagePath -Configuration $Configuration -BuildParams $buildParams
    Invoke-WebDeployment -PackagePath $packagePath -ServerHost $WebServer `
        -SiteName $SiteName -Application ''

}


