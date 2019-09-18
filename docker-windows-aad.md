# Special notes about Docker Desktop on Windows 10

Docker Desktop on Windows requires a shared drive in order to mount host volumes in that drive to Linux containers. Please make sure to read the "Shared Drives" section of the [Get started with Docker for Windows](https://docs.docker.com/docker-for-windows/) page.

Note that for users of Windows 10 Enterprise secured with Azure Active Directory (AAD), the user will not reside in the local host and may not be accepted in the "Shared Drives" tab of the Docker Desktop Settings page, specially if the organization has configured AAD to only issue PIN codes instead of user passwords.

## Workaround for Windows 10 Enterprise secured with Azure Active Directory

If Docker Desktop does not accept your AAD user and password in the "Shared Drives" panel, the only known workaround at this time is to use a separate local account to handle the drive sharing and file permissions.

Assuming the creation of a new user does not violate your organization policies, the workaround is comprised of two steps:

1. [Create a new local user account](https://support.microsoft.com/en-us/help/4026923/windows-10-create-a-local-user-or-administrator-account
) on Windows and use that account in the "Shared drive" tab. For instance, if you created an account named "Developer", you would have the following settings.

<img src="images/docker-windows-ad-share-drive.png">

2. Grant that new user full permissions to the folders to be mounted by Appsody into a container. You could use the "Security" tab for each folder properties in the File Explorer, but the quickers and simplest mechanism is to open a "Command Prompt" and issue the following commands:

```
mkdir %USERPROFILE%\.m2\repository
mkdir %USERPROFILE%\.appsody
mkdir %USERPROFILE%\workspace\kabanero-workshop

set DOCKER_SHARED_DRIVE_USER=Developer

icacls "%USERPROFILE%\.m2" /grant %DOCKER_SHARED_DRIVE_USER%:(OI)(CI)F
icacls "%USERPROFILE%\.appsody" /grant %DOCKER_SHARED_DRIVE_USER%:(OI)(CI)F
icacls "%USERPROFILE%\workspace\kabanero-workshop" /grant %DOCKER_SHARED_DRIVE_USER%:(OI)(CI)F
```

Note that the user in `DOCKER_SHARED_DRIVE_USER` must match the user in the first step. 

Repeat the `mkdir` and `icacls` command for any other directory where you may create a new Appsody project.

Observant readers will also note that granting the permission directly to all of `%USERPROFILE%` would achieve the same end-result with less commands and concerns about not forgetting to grant the permissions to other folders, but these instructions focused on reducing the surface area of the workaround.

3. If you want to revert the permissions later, execute the following commands:

```
set DOCKER_SHARED_DRIVE_USER=Developer

icacls "%USERPROFILE%\.m2" /remove %DOCKER_SHARED_DRIVE_USER%
icacls "%USERPROFILE%\.appsody" /remove %DOCKER_SHARED_DRIVE_USER%
icacls "%USERPROFILE%\workspace\kabanero-workshop" /remove %DOCKER_SHARED_DRIVE_USER%
```

