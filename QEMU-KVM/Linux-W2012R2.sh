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
 
mkdir vm

qemupath=$(echo cat qemupath.txt | bash)
clear
echo "VPS1"
vps=vps1
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1001
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS2"
vps=vps2
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1002
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS3"
vps=vps3
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1003
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS4"
vps=vps4
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1004
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS5"
vps=vps5
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1005
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS6"
vps=vps6
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1006
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS7"
vps=vps7
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1007
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS8"
vps=vps8
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1008
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS9"
vps=vps9
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=1009
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS10"
vps=vps10
cp windows2012r2.raw vm/$vps.raw
cd vm
qemu-img resize -f raw $vps.raw +25G
cd ..
custom_ram="6000""M"
CPU=3
PORT=10010
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT
