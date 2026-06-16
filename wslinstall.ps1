$dateforfile = get-date -format "ddMMyyyyHHmm"
$logpath = "$env:USERPROFILE\desktop\wslinstall${dateforfile}.log"

start-transcript -path $logpath

Write-host "this will restart you machine, make sure to save all your work before proceeding, you have 60 seconds" -ForegroundColor Red  
Start-Sleep -seconds 60

#winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements

$getpwshversion = pwsh -command '$PSVersionTable.PSVersion.ToString()'

$pwsh7path = "C:\Program Files\PowerShell\7"
$pwsh7path32 = "C:\Program Files (x86)\PowerShell\7"

if (Test-path $pwsh7path -or Test-Path $pwsh7path32) {
if ($getpwshversion -ne "7.6.2") {
write-host "powershell7 install found but not latest, upgrading" -ForegroundColor Orange
winget upgrade --id Microsoft.Powershell --silent --verbose --accept-source-agreements --accept-package-agreements --include-unknown
} 
else {
write-host "powershell okay" -ForegroundColor Green
}
}
else {
write-host "no powershell7 install found, installing..." -ForegroundColor Orange
winget install --id Microsoft.Powershell --silent --verbose --accept-source-agreements --accept-package-agreements --include-unknown
}


wsl --install --no-distribution
wsl --install -d Ubuntu --no-launch

#not needed, just download it instead

invoke-webrequest -uri "https://raw.githubusercontent.com/masterpatrickpl-coder/doominstallscripts/refs/heads/main/doomsetup.ps1" -OutFile "$env:USERPROFILE\desktop\doomsetup.ps1"

$part2Path = "$env:USERPROFILE\desktop\doomsetup.ps1"
$taskaction = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-executionpolicy bypass -file `"$part2Path`""
$afterrestart = New-ScheduledTaskTrigger -AtLogOn
$config = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

Register-ScheduledTask -TaskName "doomsetup" -Action $taskaction -Trigger $afterrestart -RunLevel Highest -Settings $config -Force

#wait some time

Write-host "restarting..."  
Start-Sleep -Seconds 5

Stop-transcript

Start-sleep -seconds 7

Restart-Computer -Force
