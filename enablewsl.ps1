dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

#Invoke-WebRequest -Uri "https://github.com/microsoft/WSL/releases/download/2.7.8/wsl.2.7.8.0.x64.msi" -OutFile "$env:TEMP\wsl.msi" -UseBasicParsing
#Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\wsl.msi`" /quiet /norestart" -Wait

Restart-Computer -Force
