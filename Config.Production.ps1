Expand-PsakeConfiguration `
@{
    Configuration = 'Release'

    AppServer = 'app.example.com'
    ApprootPath = 'C:\approot'
    AdminUsername = $env:AdminUsername
    AdminPassword = $env:AdminPassword
    ServiceUsername = $env:ServiceUsername
    ServicePassword = $env:ServicePassword

    DatabaseServer = 'mssql.example.com'
    DatabaseUsername = $env:DatabaseUser
    DatabasePassword = $env:DatabasePassword

}