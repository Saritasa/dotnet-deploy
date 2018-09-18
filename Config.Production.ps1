Expand-PsakeConfiguration `
@{
    Configuration = 'Release'
    WebServer = 'web.saritasa.local'
    SiteName = 'web.example.com'
    DeployUsername = $env:DeployUsername
    WwwrootPath = '/var/www'




    DatabaseServer = 'mssql.example.com'
    DatabaseUsername = $env:DatabaseUser
    DatabasePassword = $env:DatabasePassword

}