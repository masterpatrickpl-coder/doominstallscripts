#pwsh version 7.6.3
$dateforfile = get-date -format "ddMMyyyyHHmm"
$logpath = "$env:USERPROFILE\desktop\doomsetup${dateforfile}.log"
#$logpath

Start-transcript -path $logpath

Unregister-ScheduledTask -TaskName "doomsetup" -Confirm:$false -erroraction silentlycontinue
#remove task

$wslcheckubuntu = wsl --list --quiet

write-warning "testing if ubuntu is installed"
if ($wslcheckubuntu -notcontains "Ubuntu") {
start-sleep -seconds 2
wsl --install -d Ubuntu
}
else {
write-host "ubuntu okay" -ForegroundColor Green
}

$pathofscript = "$env:TEMP\doomsetupcontinue.sh"

Start-Sleep -Seconds 3
Write-Host "building doom, this will take a while" -ForegroundColor Yellow
Start-Sleep -Seconds 5

$shContent = @'
#!/bin/bash
apt update && apt upgrade -y
apt install -y build-essential git libx11-dev libxext-dev wget
git clone https://github.com/id-Software/DOOM.git ~/DOOM
cd ~/DOOM/linuxdoom-1.10
mkdir -p linux
dpkg --add-architecture i386
apt update
apt install -y gcc-multilib libc6-dev-i386 libx11-dev:i386 libxext-dev:i386 xserver-xephyr
sed -i '1s/^/#include <errno.h>\n/' i_sound.c
sed -i 's/#include <errnos.h>/#include <errno.h>/' i_video.c
sed -i 's/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX # -DUSEASM/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX -m32 -std=gnu99 -Wno-implicit-function-declaration -Wno-implicit-int # -DUSEASM/' Makefile
sed -i 's|$(CC) $(CFLAGS) $(LDFLAGS)|$(CC) -m32 $(CFLAGS) $(LDFLAGS)|' Makefile
sed -i 's/-lnsl //' Makefile
make
apt install doom-wad-shareware -y
cp /usr/share/games/doom/doom1.wad ~/DOOM/linuxdoom-1.10/
Xephyr :2 -ac -screen 640x400x8 -fullscreen &
sleep 2
DISPLAY=:2 ./linux/linuxxdoom -nosound
'@

$bytes = [System.Text.Encoding]::UTF8.GetBytes($shContent.Replace("`r`n", "`n"))
[System.IO.File]::WriteAllBytes($pathofscript, $bytes)

$wslPath = "/mnt/" + ($pathofscript -replace "\\", "/" -replace ":", "").ToLower()

wsl -d Ubuntu -u root bash $wslPath

#Remove-Item $pathofscript
Start-Sleep -Seconds 3
Write-Host "done???" -ForegroundColor Green

start-sleep -seconds 2

stop-transcript
