winget install --id JernejSimoncic.Wget -e --source winget --accept-package-agreements --accept-source-agreements
winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements

$taskaction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument '-executionpolicy bypass -file "$env:USERPROFILE\desktop\doomsetup.ps1"'
$afterrestart = New-ScheduledTaskTrigger -AtLogOn
$config = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

Register-ScheduledTask -TaskName "doomsetup" -Action $taskaction -Trigger $afterrestart -RunLevel Highest -Settings $config -Force

wsl --install --no-distribution
wsl --install -d Ubuntu --no-launch

#hopefully work with multipule lines?
#new-item -Path "$env:USERPROFILE\desktop\doomsetup.ps1" -value
# 
#not needed, just download it instead

