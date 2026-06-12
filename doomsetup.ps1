Unregister-ScheduledTask -TaskName "doomsetup" -Confirm:$false
#remove task

$pathofscript = "c:\doomsetupcontinue.sh"

$shContent = @"
#!/bin/bash
apt update && apt upgrade -y
apt install -y build-essential git libx11-dev libxext-dev wget
git clone https://github.com/id-Software/DOOM.git ~/DOOM
cd ~/DOOM/linuxdoom-1.10
mkdir -p linux
make
rm -f linux/*.o
apt install -y gcc-multilib libc6-dev-i386 libx11-dev:i386 libxext-dev:i386 xserver-xephyr
sed -i '1s/^/#include <errno.h>\n/' i_sound.c
sed -i 's/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX # -DUSEASM/CFLAGS=-g -Wall -DNORMALUNIX -DLINUX -m32 -Wno-implicit-function-declaration -Wno-implicit-int # -DUSEASM/' Makefile
sed -i 's/$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $(O)/i_main.o \/$(CC) -m32 $(CFLAGS) $(LDFLAGS) $(OBJS) $(O)/i_main.o \' Makefile
"@
$bytes = [System.Text.Encoding]::UTF8.GetBytes($shContent.Replace("`r`n", "`n"))
[System.IO.File]::WriteAllBytes($pathofscript, $bytes)
