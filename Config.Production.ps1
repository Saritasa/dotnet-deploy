Expand-PsakeConfiguration `
@{
    Configuration = 'Release'
    WebServer = 'web.saritasa.local'
    SiteName = 'web.example.com'
    DeployUsername = $env:DeployUsername
    DeployPassword = $env:DeployPassword
    WwwrootPath = 'C:\inetpub\wwwroot'




    DatabaseServer = 'mssql.example.com'
    DatabaseUsername = $env:DatabaseUser
    DatabasePassword = $env:DatabasePassword

}