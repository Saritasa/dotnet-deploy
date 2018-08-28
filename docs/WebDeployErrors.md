Web Deploy Errors
=================

See the article: [Web Deploy error codes](https://docs.microsoft.com/en-us/iis/publish/troubleshooting-web-deploy/web-deploy-error-codes)

### ERROR_DESTINATION_INVALID

- Server DNS name is unknown.

```
Error Code: ERROR_DESTINATION_INVALID
More Information:  Could not connect to the remote computer ("staging.saritasa.local"). Make sure that the remote computer name is correct and that you are able to connect to that computer.  Learn more at: http://go.microsoft.com/fwlink/?LinkId=221672#ERROR_DESTINATION_INVALID.
Error: The remote name could not be resolved: 'staging.saritasa.local'
```

### ERROR_DESTINATION_NOT_REACHABLE

- Server is stopped.
- Web Management service is stopped.
- Firewall blocks port 8172.

```
Error Code: ERROR_DESTINATION_NOT_REACHABLE
More Information: Could not connect to the remote computer ("staging.saritasa.local"). On the remote computer, make sure that Web Deploy is installed and that the required process ("Web Management Service") is started.  Learn more at: http://go.microsoft.com/fwlink/?LinkId=221672#ERROR_DESTINATION_NOT_REACHABLE.
Error: Unable to connect to the remote server
Error: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond 192.168.0.100:8172
```

### ERROR_USER_UNAUTHORIZED

- Deploy user name is wrong.
- Deploy password is wrong.
- Password of deploy has expired.
- Site name is wrong.
- User is not authorized for the web site in IIS Manager.

```
Error Code: ERROR_USER_UNAUTHORIZED
More Information: Connected to the remote computer ("staging.saritasa.local") using the Web Management Service, but could not authorize. Make sure that you are using the correct user name and password, that the site you are connecting to exists, and that the credentials represent a user who has permissions to access the site.  Learn more at: http://go.microsoft.com/fwlink/?LinkId=221672#ERROR_USER_UNAUTHORIZED.
Error: The remote server returned an error: (401) Unauthorized.
```

### ERROR_CERTIFICATE_VALIDATION_FAILED

- Certificate has expired.
- Certificate common name is wrong (default WMSvc-Hostname).
- Server has several DNS names, certificate subject includes only one of them.
- Certificate is self-signed, but not added to trusted certificate authorities on build server.

```
Error Code: ERROR_CERTIFICATE_VALIDATION_FAILED
More Information: Connected to the remote computer ("staging.saritasa.local") using the specified process ("Web Management Service"), but could not verify the server's certificate. If you trust the server, connect again and allow untrusted certificates.  Learn more at: http://go.microsoft.com/fwlink/?LinkId=221672#ERROR_CERTIFICATE_VALIDATION_FAILED.
Error: The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel.
Error: The remote certificate is invalid according to the validation procedure.
```

See the [instruction](https://github.com/Saritasa/PSGallery/blob/master/docs/WinRMConfiguration.md#generate-new-certificate) how to change WMSvc certificate.
