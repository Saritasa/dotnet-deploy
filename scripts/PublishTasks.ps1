Properties `
{
    $Configuration = $null

    $AppServer = $null
    $AdminUsername = $null
    $AdminPassword = $null

    $ServiceUsername = $null
    $ServicePassword = $null
}

$root = $PSScriptRoot
$src = Resolve-Path "$root\..\src"
$workspace = Resolve-Path "$root\.."




Task publish-service -depends build, init-winrm -description '* Publish service to specified server.' ` `
    -requiredVariables @('Configuration', 'AppServer', 'ApprootPath',
        'ServiceUsername', 'ServicePassword') `
{
    $session = Start-RemoteSession -ServerHost $AppServer
    $serviceCredential = New-Object System.Management.Automation.PSCredential($ServiceUsername,
        (ConvertTo-SecureString $ServicePassword -AsPlainText -Force))
    # TODO: Fix project name.
    $projectName = 'Example.Service'
    $binPath = "$src\$projectName\bin\$Configuration"
    $serviceName = $projectName
    $destinationPath = "$ApprootPath\$serviceName"

    Invoke-ServiceProjectDeployment -Session $session `
        -ServiceName $serviceName -ProjectName $projectName `
        -BinPath $binPath -DestinationPath $destinationPath `
        -ServiceCredential $serviceCredential

    Remove-PSSession $session
}
