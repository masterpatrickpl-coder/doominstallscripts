Unregister-ScheduledTask -TaskName "doomsetup" -Confirm:$false
#remove task

$pathofscript = "c:\doomsetupcontinue.sh"

#do some stuff
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
sed -i 's/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX # -DUSEASM/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX -m32 -Wno-implicit-function-declaration -Wno-implicit-int # -DUSEASM/' Makefile
sed -i 's|$(CC) $(CFLAGS) $(LDFLAGS)|$(CC) -m32 $(CFLAGS) $(LDFLAGS)|' Makefile
make
apt install doom-wad-shareware -y
cp /usr/share/games/doom/doom1.wad ~/DOOM/linuxdoom-1.10/
Xephyr :2 -ac -screen 640x480x8 &
sleep 2
DISPLAY=:2 ./linux/linuxxdoom -nosound
'@
$bytes = [System.Text.Encoding]::UTF8.GetBytes($shContent.Replace("`r`n", "`n"))
[System.IO.File]::WriteAllBytes($pathofscript, $bytes)

wsl -d Ubuntu -u root bash /mnt/c/doomsetupcontinue.sh

write-host "done???" -ForegroundColor Green

