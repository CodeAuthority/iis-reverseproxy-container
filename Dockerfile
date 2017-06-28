FROM microsoft/iis:windowsservercore

# Download and install the required URL rewrite and Application Request Routing modules. Clean up after!
ADD http://go.microsoft.com/fwlink/?LinkID=615137 /install/rewrite_amd64.msi
ADD http://go.microsoft.com/fwlink/?LinkID=615136 /install/ARRv3_setup_amd64_en-us.msi
RUN msiexec.exe /i C:\install\rewrite_amd64.msi /qn /log C:\ms_install.log & \
    msiexec.exe /i C:\install\ARRv3_setup_amd64_en-us.msi /qn /log C:\arr_install.log & \
    rd /s /q c:\install

# Enable proxy feature for IIS. Allows us to act as a reverse proxy
RUN .\Windows\System32\inetsrv\appcmd.exe set CONFIG -section:system.webServer/proxy /enabled:"True" /commit:apphost

# The web config should contain our routing to other containers
ADD ./web.config /inetpub/wwwroot/web.config