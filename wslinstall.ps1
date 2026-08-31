#pwsh version 7.6.3
$dateforfile = get-date -format "ddMMyyyyHHmm"
$logpath = "$env:USERPROFILE\desktop\wslinstall${dateforfile}.log"

start-transcript -path $logpath

Write-host "this will restart you machine, make sure to save all your work before proceeding, you have 20 seconds" -ForegroundColor Red  
Start-Sleep -seconds 20

#winget install --id Git.Git --source winget --accept-package-agreements --accept-source-agreements

$wslexe = "C:\Windows\System32\wsl.exe"

if (get-command "winget" -erroraction silentlycontinue) {
write-host "installing wsl via winget"
start-sleep -seconds 2
winget install --id Microsoft.WSL --source winget --accept-package-agreements --accept-source-agreements
start-sleep -seconds 2
& $wslexe --install -d Ubuntu --no-launch
start-sleep -seconds 10
}
elseif (get-command "wsl" -erroraction silentlycontinue) {
write-host "installing wsl via its self"
start-sleep -seconds 2
wsl --install --no-distribution
start-sleep -seconds 2
& $wslexe --install -d Ubuntu --no-launch
start-sleep -seconds 10
}
else {
write-warning "fallback to manual install"
start-sleep -seconds 2
Invoke-WebRequest -Uri "https://github.com/microsoft/WSL/releases/download/2.7.8/wsl.2.7.8.0.x64.msi" -OutFile "$env:TEMP\wsl.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\wsl.msi`" /quiet /norestart" -Wait
& $wslexe --install -d Ubuntu --no-launch
start-sleep -seconds 10
}


$pwsh7path = "C:\Program Files\PowerShell\7"
$pwsh7path32 = "C:\Program Files (x86)\PowerShell\7"

if ((Test-path $pwsh7path) -or (Test-Path $pwsh7path32)) {
$getpwshversion = pwsh -command '$PSVersionTable.PSVersion.ToString()'
if ($getpwshversion -ne "7.6.5") {
if (get-command "winget" -erroraction silentlycontinue) {
write-host "powershell7 install found but not latest, upgrading" -ForegroundColor Yellow
winget upgrade --id Microsoft.Powershell --silent --verbose --accept-source-agreements --accept-package-agreements --include-unknown
}
else {
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.6.5/PowerShell-7.6.5-win-x64.msi" -OutFile "$env:TEMP\pwsh.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\pwsh.msi`" /quiet /norestart" -Wait
}
} 
else {
write-host "powershell okay" -ForegroundColor Green
}
}
else {
if (get-command "winget" -erroraction silentlycontinue) {
write-host "no powershell7 install found, installing..." -ForegroundColor Yellow
winget install --id Microsoft.Powershell --silent --verbose --accept-source-agreements --accept-package-agreements --include-unknown
}
else {
Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.6.3/PowerShell-7.6.3-win-x64.msi" -OutFile "$env:TEMP\pwsh.msi" -UseBasicParsing
Start-Process msiexec.exe -ArgumentList "/i `"$env:TEMP\pwsh.msi`" /quiet /norestart" -Wait
}
}


#wsl --install --no-distribution
#wsl --install -d Ubuntu --no-launch

#not needed, just download it instead

invoke-webrequest -uri "https://raw.githubusercontent.com/masterpatrickpl-coder/doominstallscripts/refs/heads/main/doomsetup.ps1" -OutFile "$env:USERPROFILE\desktop\doomsetup.ps1" -usebasicparsing

$part2Path = "$env:USERPROFILE\desktop\doomsetup.ps1"
$taskaction = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-executionpolicy bypass -file `"$part2Path`""
$afterrestart = New-ScheduledTaskTrigger -AtLogOn
$config = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

Register-ScheduledTask -TaskName "doomsetup" -Action $taskaction -Trigger $afterrestart -RunLevel Highest -Settings $config -Force

#wait some time

Write-warning "restarting..."  
Start-Sleep -Seconds 5

Stop-transcript

Start-sleep -seconds 7

Restart-Computer -Force
