#!/bin/bash
#
#Vars
echo Tao 10 con 3c6gb 100GB disk.
# installing required Ubuntu packages
dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist = "CentOS" ] ; then
	printf "Y\n" | yum install sudo -y
	sudo yum install wget vim curl genisoimage screen -y
	# Downloading Portable QEMU-KVM
	echo "Downloading QEMU"
	umount /dev/mapper/centos-home
        yes|lvreduce -L 2G /dev/mapper/centos-home
        lvextend -r -l+100%FREE /dev/mapper/centos-root
	##sudo yum remove xorg* -y
	##sudo yum remove gnome* -y
	##yum remove xrdp -y
	##sudo yum update -y
	sudo yum install -y qemu-kvm
	sudo yum install libguestfs-tools -y
	##curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
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
	sudo apt-get install -y libguestfs-tools 
	sudo apt-get install -y screen 
	##sudo apt-get install -y powershell
fi
sudo ln -s /usr/bin/genisoimage /usr/bin/mkisofs
# Downloading resources

linkgz=https://dl.dropboxusercontent.com/s/w1tjv1d2brpwjiv/Hoanganh0504.gz
[ -s windows2012r2.raw ] || wget -q --show-progress --no-check-certificate -O- $linkgz | gunzip | dd of=windows2012r2.raw bs=1M

dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist	= "CentOS" ] ; then
	qemupath=$(whereis qemu-kvm | sed "s/ /\n/g" | egrep "^/usr/libexec/")
	#b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:print:]\n" | sed 's/^/\/dev\//'))
else
	qemupath=$(whereis qemu-system-x86_64 | cut -f2 -d" ")
	#b=($(fdisk -l | grep "^/dev/" | tr -d "*" | tr -s '[:space:]' | cut -f1 -d" "))
fi
echo $qemupath >qemupath.txt


qemupath=$(echo cat qemupath.txt | bash)
clear
echo "Wellcome to VM creation, type DISKNAME,CPU,RAM(MB),PORT(Max 5 number) you want:"
read -p "DISK NAME: " DISKNAME
#read -p "DISK SIZE(Default 10GB): " DISKSIZE
read -p "CPU(Virtual Processor): " CPU
read -p "RAM(MB): " RAM
read -p "PORT(Max 5 number): " PORT
custom_ram="$RAM""M"
custom_disk="$DISKSIZE""G"
mkdir vm
cp windows2012r2.raw vm/$DISKNAME.raw
#cd vm
#qemu-img resize $DISKNAME.raw $custom_disk
#cd ..
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$DISKNAME.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM
