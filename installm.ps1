invoke-webrequest -uri "https://raw.githubusercontent.com/masterpatrickpl-coder/doominstallscripts/refs/heads/main/wslinstall.ps1" -OutFile "$env:USERPROFILE\desktop\wslinstall.ps1"

Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.6.2/PowerShell-7.6.2-win-x64.msi" -OutFile "$env:TEMP\pwsh.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\pwsh.msi`" /quiet /norestart" -Wait


Invoke-WebRequest -Uri "https://github.com/microsoft/WSL/releases/download/2.7.8/wsl.2.7.8.0.x64.msi" -OutFile "$env:TEMP\wsl.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\wsl.msi`" /quiet /norestart" -Wait

Restart-Computer -Force
