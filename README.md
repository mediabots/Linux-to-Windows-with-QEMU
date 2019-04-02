# Linux-to-Windows-with-QEMU

A Shell Script to Auto install Windows Server on your Linux System. [Right now, it supports 2012 R2 < evaluation/180 days trial > copy]

Script would use QEMU-KVM portable software for Virtualization purpose.
Since QEMU is a portable s/w, so it can reside in temporary RAM.

Actually script is semi-automatic.
All Linux commands part(such as downloading Windows ISO image, gathering system info, choosing disk/partition, managing RAM , attaching required windows s/w in CDROM) would be handled by script automatically.

And rest of the windows part(clicking, selecting, setting Administrator password ) need to be done manually by any Free VNC windows software.

After Windows Installation completed, you would find a Power Shell script under CD-ROM, called "EnableRDP.ps1".
By running it you would be able to enable Remote Desktop on your Windows server, so after that you would be able to connect your Windows server through Windows "Remote Desktop Application" App :)

I also attached Firefox App on CD-ROM, install that, so you don't need to face "Internet Explorer" horrible setting experience!

---

## Requirements
A SSH client such as Putty : https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

A VNC software such as RealVNC : https://www.realvnc.com/en/connect/download/viewer/

A VPS or Dedicated server with Ubuntu OS Installed.

At least 30GB Free disk space in your system.

Virtualization of your VPS or Server must be enabled.
Run below coammnd :

`echo $(egrep '^flags.*(vmx|svm)' /proc/cpuinfo | wc -l)`

if output is greater than 0, then Virtualization is enabled :D

Either should have access of root user OR run with su (super user) 

---

## Optional

If you want to use your own Windows ISO copy.

Then download official copy from https://www.microsoft.com/en-in/evalcenter/evaluate-windows-server-2012-r2 and upload it to your extra server & create a direct url and then replace LINE NO. 39 & 41 of mediabots_Ubuntu-to-Windows.sh with your DIRECT LINK

Script Line No. 39 :-

sudo wget -P /mediabots http://51.15.226.83/WS2012R2.ISO

Script Line No. 41 :-

sudo wget -P /mediabots https://ia601506.us.archive.org/4/items/WS2012R2/WS2012R2.ISO

---

## How to Run the Script

Just run below five commands one after another :

`su`

`mkdir /media/script && mount -t tmpfs -o size=1m tmpfs /media/script`

`wget -P /media/script https://raw.githubusercontent.com/mediabots/Linux-to-Windows-with-QEMU/master/mediabots_Linux-to-Windows.sh`

`chmod +x /media/script/*`

`/media/script/mediabots_Linux-to-Windows.sh`

---

## How Script works?

CASE - 1

Your Server/VPS Free RAM size > 5 GB

If your system comes with more than 5GB free RAM, script would ask, whether do you want to delete your existing Linux OS(Ubuntu in this case).

Go with that option only if "Rescue Boot" option is available in your Server Hosting Control-panel.

  Case - 1.a

  Suppose you proceed with that option, in that case, script would download Windows-ISO image & other stuffs in your system RAM.
  
  Case - 1.b
  
  Suppose you dont go with that option.
  
  Script would first check, how many Disk are attached with your VPS/Server.
    
   Case - 1.b.i  
   
   If there are multi Disk.
   
   Winodws-OS would be installed on your second Disk.
   
   Case - 1.b.ii
   
   If only one Disk attached, then it would check how many partitions(size > 25 GB) are present there.
   
   If there are multi partitons(size > 25 GB). Windows-OS would be installed on second partition.
   
   Else
   
   If only one partion exist, and that partition has more than 30 GB free space. In that case ,it would create a "disk.img" file of 25 GB size for installing Windows-OS on that file.

CASE - 2

Your Server/VPS Free RAM size < 5 GB
  
  start from <Case - 1.b>

---

## Demo Video

<a href="http://www.youtube.com/watch?feature=player_embedded&v=84gVQXXJF8A" target="_blank"><img src="http://img.youtube.com/vi/84gVQXXJF8A/0.jpg" 
alt="Turn your Linux VPS or Server into Windows Server automatically using Shell script trough QEMU-KVM" width="480" height="360" border="10" /></a>

OR

http://bit.ly/Linux-to-Windows

---

## Screenshots

https://imgur.com/a/w7WszdK (19 images included)

---

## Disclaimer

For few cases, due to RAID configuration of the hard disk, if you had chosen to delete existing Linux OS & install Windows OS on entire hard disk.
On your VNC , you might see, Windows installation failing.

If you are facing such issue; Exit from the script & Re-run it & in this time just opt for installing Windows OS without deleting Linux OS. And it would work :D

In case, portable QEMU-KVM app stopped/closed, your Widows-Server would not be accessible.
To access it again, you require to run the QEMU-KVM app again with proper parameters.

Run below command :

`cat /details.txt`

Copy the Output of the above result and Paste it & press Enter button.
It would run the QEMU-KVM again. So your Windows Server would be accessible again :D

If you required a reboot of your Windows Server, just reboot it from Windows Server reboot option. 
Don't reboot your server from Server Hosting Control-panel. Otherwise QEMU App would get stopped.

If you had opted for removing your old Linux OS, you would get Windows server with full HDD capacity.
But RAM would not be full, because QEMU resides on RAM.

---
## Updates

Right now, Script supports Ubuntu,Debian,CentOS Distros.

But very soon I would add the support for all other Linux Distros too.

So stay tuned.

---

## Reference

askubuntu.com, stackexchange.com, stackoverflow.com, ubuntuforums.com, tecmint.com, qemu.org, myrlse@wjunction, exchangepedia.com 

