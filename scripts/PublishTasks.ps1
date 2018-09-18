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


    $projectName = 'DeployDemo.Web'
    $publishProfile = $null

    if (!$IsLinux)
    {
        $packagePath = "$src\$projectName\$projectName.zip"
        Copy-Item "$src\$projectName\web.config.template" "$src\$projectName\web.config"
        Update-VariablesInFile -Path "$src\$projectName\web.config" -Variables @{ Environment = $Environment }

        $publishProfile = 'Package'
    }

    Exec { dotnet publish -c $Configuration "$src\$projectName\$projectName.csproj" /p:PublishProfile=$publishProfile }

    if ($IsLinux)
    {
        $publishDir = "$src/$projectName/bin/$Configuration/netcoreapp2.1/publish"
        Remove-Item "$publishDir/web.config"

        $params = @('-av', '--delete-excluded', "$publishDir/",
            "$DeployUsername@$($WebServer):$WwwrootPath/$SiteName")
        Write-Information "Running command: rsync $params"
        Exec { rsync $params }


        $serviceName = 'deploy-demo'
        Exec { ssh $DeployUsername@$WebServer sudo /bin/systemctl restart $serviceName }
    }
    else
    {
        Invoke-WebDeployment -PackagePath $packagePath -ServerHost $WebServer `
            -SiteName $SiteName -Application '' -MSDeployParams @('-enablerule:AppOffline')
    }

}


