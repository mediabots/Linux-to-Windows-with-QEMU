#!/bin/bash
#
#Vars
echo Install Gdrive ...
wget -O /usr/src/gdrive https://raw.githubusercontent.com/kmille36/Linux-to-Windows-with-QEMU/master/gdrive-linux-x64 >/dev/null 2>&1
chmod +x /usr/src/gdrive >/dev/null 2>&1
sudo install /usr/src/gdrive /usr/local/bin/gdrive >/dev/null 2>&1
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip *.zip
clear
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp --region ap 30889 &>/dev/null &
windows_os_link=https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.2/providers/qemu.box
windows_os_name="Windows 11 Super Lite"
custom_param_disk="windows11lite.qcow2"
echo $custom_param_disk >disk.txt
echo gdrive upload $custom_param_disk >update.txt
mounted=0
GREEN='\033[1;32m';GREEN_D='\033[0;32m';RED='\033[0;31m';YELLOW='\033[0;33m';BLUE='\033[0;34m';NC='\033[0m'
# Virtualization checking..
virtu=$(egrep -i '^flags.*(vmx|svm)' /proc/cpuinfo | wc -l)
if [ $virtu = 0 ] ; then echo -e "[Error] ${RED}Virtualization/KVM in your Server/VPS is OFF\nExiting...${NC}";
else
#
# Deleting Previous Windows Installation by the Script
#umount -l /mnt /media/script /media/sw
#rm -rf /mediabots /floppy /virtio /media/* /tmp/*
#rm -f /sw.iso /disk.img 
# installing required Ubuntu packages
dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist = "CentOS" ] ; then
	printf "Y\n" | yum install sudo -y
	sudo yum install wget vim curl genisoimage -y
	# Downloading Portable QEMU-KVM
	echo "Downloading QEMU"
	umount /dev/mapper/centos-home
        yes|lvreduce -L 2G /dev/mapper/centos-home
        lvextend -r -l+100%FREE /dev/mapper/centos-root
	sudo yum remove xorg* -y
	sudo yum remove gnome* -y
	yum remove xrdp -y
	##sudo yum update -y
	sudo yum install -y qemu-kvm
	sudo yum install libguestfs-tools -y
	curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
	##sudo yum install -y powershell
elif [ $dist = "Ubuntu" -o $dist = "Debian" ] ; then
	printf "Y\n" | apt-get install sudo -y
	sudo apt-get install vim curl genisoimage -y
	sudo mkdir /etc/powershell
	sudo wget -P /etc/powershell https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
	sudo dpkg -i /etc/powershell/packages-microsoft-prod.deb
	# Downloading Portable QEMU-KVM
	echo "Downloading QEMU"
	sudo apt-get update
        dpkg-reconfigure debconf -f noninteractive -p critical
        UCF_FORCE_CONFFOLD=YES apt -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" -y dist-upgrade 
	sudo apt-get install -y qemu-kvm
	##sudo apt-get install -y powershell
