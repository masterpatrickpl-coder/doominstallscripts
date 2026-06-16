Write-host "this will restart you machine, make sure to save all your work before proceeding, you have 60 seconds" -ForegroundColor Red  
Start-Sleep -seconds 60

winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements


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

Restart-Computer -Force
