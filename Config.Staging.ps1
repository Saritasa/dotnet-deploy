Expand-PsakeConfiguration `
@{
    Configuration = 'Release'
    WebServer = 'staging.saritasa.local'
    SiteName = 'staging.example.com'
    DeployUsername = $env:DeployUsername
    DeployPassword = $env:DeployPassword
    WwwrootPath = 'C:\inetpub\wwwroot'




    DatabaseServer = 'mssql-staging.example.com'
    DatabaseUsername = $env:DatabaseUser
    DatabasePassword = $env:DatabasePassword

}