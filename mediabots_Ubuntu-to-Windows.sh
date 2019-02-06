#!/bin/bash
#
# installing sudo
printf "Y\n" | apt install sudo -y
#
#Vars
mounted=0
# updating System
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade 
sudo apt-get --yes dist-upgrade
#
# Downloading resources
sudo mkdir /mediabots /floppy /virtio
link1_status=$(curl -Is https://mediabots.ml/WS2012R2.ISO | grep HTTP | cut -f2 -d" ")
link2_status=$(curl -Is https://archive.org/download/WS2012R2/WS2012R2.ISO | grep HTTP | cut -f2 -d" ")
#link2_status=$(curl -Is https://ia601506.us.archive.org/4/items/WS2012R2/WS2012R2.ISO | grep HTTP | cut -f2 -d" ")
sudo wget -P /mediabots https://archive.org/download/WS2012R2/WS2012R2.ISO # https://mediabots.ml/WS2012R2.ISO # Windows Server 2012 R2 
sudo wget -P /floppy https://ftp.mozilla.org/pub/firefox/releases/64.0/win32/en-US/Firefox%20Setup%2064.0.exe
sudo mv /floppy/'Firefox Setup 64.0.exe' /floppy/Firefox.exe
sudo wget -P /floppy https://downloadmirror.intel.com/23073/eng/PROWinx64.exe # Intel Network Adapter for Windows Server 2012 R2 
# Powershell script to auto enable remote desktop for administrator
sudo touch /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name \"fDenyTSConnections\" -Value 0" >> /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name \"UserAuthentication\" -Value 1" >> /floppy/EnableRDP.ps1
sudo echo -e "Enable-NetFirewallRule -DisplayGroup \"Remote Desktop\"" >> /floppy/EnableRDP.ps1
# Downloading Virtio Drivers
sudo wget -P /virtio https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
# installing genisoimage to create .iso
sudo apt install -y genisoimage
sudo mkisofs -o /sw.iso /floppy
#
#Enabling KSM
sudo echo 1 > /sys/kernel/mm/ksm/run
#Free memories
sync; sudo echo 3 > /proc/sys/vm/drop_caches
# Gathering System information
virtualization=$(lscpu | grep Virtualization: | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo $virtualization
model=$(lscpu | grep "Model name:" | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo $model
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo $cpus
availableRAM=$(free -m | tail -2 | head -1 | awk '{print $7}')
echo $availableRAM
diskNumbers=$(fdisk -l | grep "Disk /dev/" | wc -l)
partNumbers=$(fdisk -l | grep "^/dev/" | wc -l)
firstDisk=$(fdisk -l | grep "Disk /dev/" | head -1 | cut -f1 -d":" | cut -f2 -d" ")
freeDisk=$(df | grep "^/dev/" | awk '{print$1 " " $4}' | sort -g -k 2 | tail -1 | cut -f2 -d" ")
newDisk=$(expr $freeDisk \* 90 / 100 / 1024)
#
custom_param_os="/mediabots/"$(ls /mediabots)
custom_param_sw="/sw.iso"
#
if [ $diskNumbers -eq 1 ] ; then # open 1st if
if [ $availableRAM -ge 4650 ] ; then 
	read -r -p "Do you want to completely delete your current Linux O.S.? (yes/no) : " deleteLinux
	deleteLinux=$(echo "$deleteLinux" | head -c 1)
	if [ ! -z $deleteLinux ] && [ $deleteLinux = 'Y' -o $deleteLinux = 'y' ] ; then
		sudo dd if=/dev/zero of=$firstDisk bs=1M count=1 # blank out the disk
		mount -t tmpfs -o size=4500m tmpfs /mnt
		mv /mediabots/* /mnt
		mkdir /media/sw
		mount -t tmpfs -o size=121m tmpfs /media/sw
		mv /sw.iso /media/sw
		custom_param_os="/mnt/"$(ls /mnt)
		custom_param_sw="/media/sw/sw.iso"
		availableRAM=$(free -m | tail -2 | head -1 | awk '{print $7}')
		custom_param_disk=$firstDisk
		custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
		mounted=1
	else
		sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
		custom_param_disk="/disk.img"
		custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
	fi
else
	sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
	custom_param_disk="/disk.img"
	custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
fi
else # 1st if else
if [ $availableRAM -ge 4650 ] ; then
	read -r -p "Do you want to completely delete your current Linux O.S.? (yes/no) : " deleteLinux
	deleteLinux=$(echo "$deleteLinux" | head -c 1)
	if [ ! -z $deleteLinux ] && [ $deleteLinux = 'Y' -o $deleteLinux = 'y' ] ; then
		sudo dd if=/dev/zero of=$firstDisk bs=1M count=1 # blank out the disk
		mount -t tmpfs -o size=4500m tmpfs /mnt
		mv /mediabots/* /mnt
		mkdir /media/sw
		mount -t tmpfs -o size=121m tmpfs /media/sw
		mv /sw.iso /media/sw
		custom_param_os="/mnt/"$(ls /mnt)
		custom_param_sw="/media/sw/sw.iso"
		availableRAM=$(free -m | tail -2 | head -1 | awk '{print $7}')
		custom_param_disk=$firstDisk
		custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
		mounted=1
	else
		custom_param_disk=$(fdisk -l | grep "Disk /dev/" | awk 'NR==2' | cut -f2 -d" " | cut -f1 -d":") # 2nd disk chosen
		custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
	fi
else
	custom_param_disk=$(fdisk -l | grep "Disk /dev/" | awk 'NR==2' | cut -f2 -d" " | cut -f1 -d":")
	custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
fi
fi # closed 1st if
#
#[X]dmidecode -t 17 | grep Size: | cut -f2 -d" "
# Downloading Portable QEMU-KVM
sudo wget -qO- /tmp https://ia601503.us.archive.org/12/items/vkvm.tar/vkvm.tar.gz | sudo tar xvz -C /tmp
# Running the KVM
sudo /tmp/qemu-system-x86_64 -net nic -net user,hostfwd=tcp::5555-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk -drive file=$custom_param_os,index=1,media=cdrom -drive file=$custom_param_sw,index=2,media=cdrom -boot once=d -vnc :0 &
pid=$(echo $! | head -1)
disown -h $pid
if [ $mounted = 1 ]; then
	read -r -p "Had your Windows Server setup completed successfully? (yes/no) : " setup_initial
	setup_initial=$(echo "$setup_initial" | head -c 1)
	if [ ! -z $setup_initial ] && [ $setup_initial = 'Y' -o $setup_initial = 'y' ] ; then
		kill $pid
		umount /mnt
		umount /media/sw
		sync; sudo echo 3 > /proc/sys/vm/drop_caches
		availableRAM=$(free -m | tail -2 | head -1 | awk '{print $7}')
		custom_param_ram="-m "$(expr $availableRAM - 150 )"M"
		sudo /tmp/qemu-system-x86_64 -net nic -net user,hostfwd=tcp::5555-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk -drive file=$custom_param_sw,index=1,media=cdrom -boot c -vnc :0 &
		pid=$(echo $! | head -1)
		disown -h $pid
		echo "Job Done :)"
	fi
else
	echo "Job Done :)"
fi

#disown  -h  %1

#[X] Creating qemu scripts for tap & bridge
#[X]sudo apt-get install bridge-utils
#[X]sudo echo -e "##/bin/bash" > \qemu-ifdown
#[X]sudo echo -e "##/bin/bash" > \qemu-ifup
#[X]sudo sed -i "s/##/#\!/" \qemu-ifdown
#[X]sudo sed -i "s/##/#\!/" \qemu-ifup
#[X]sudo echo -e "echo \"Executing qemu-ifup\"\necho \"Bringing up \$1 for bridged mode...\"\nsudo ip link set \$1 up promisc on\necho \"Adding \$1 to br0...\"\nsudo brctl addif br0 \$1\nsleep 2" >> /qemu-ifup
#[X]sudo echo -e "echo \"Executing qemu-ifdown\"\nsudo ip link set \$1 down\nsudo brctl delif br0 \$1\nsudo ip link delete dev \$1\nsleep 2" >> \qemu-ifdown
#[X]chmod 750 \qemu-ifdown \qemu-ifup


#/tmp/qemu-system-x86_64 -net nic,model=virtio -net user,hostfwd=tcp::3389-:3389 -m 1048M -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=4 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=/dev/loop0,index=0,media=disk,if=virtio -drive file=/mediabots/WS2012R2.ISO,index=1,media=cdrom -drive file=/virtio/virtio-win.iso,index=2,media=cdrom -drive file=/sw.iso,index=3,media=cdrom -boot once=d -vnc :78




#/tmp/qemu-system-x86_64 -net nic -device virtio-net,netdev=network0 -netdev tap,id=network0,ifname=tap0,script=no,downscript=no,vhost=on -net user,hostfwd=tcp::3389-:3389 -m 3G -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=4 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=/dev/vdb,index=0,media=disk,if=virtio -drive file=/root/mediabots/WS2012R2.ISO,index=1,media=cdrom -drive file=/root/virtio/virtio-win.iso,index=3,media=cdrom -drive file=/root/sw.iso,index=2,media=cdrom -boot c -vnc :78



#echo $(curl ifconfig.me)

#sudo /tmp/qemu-system-x86_64 -device e1000,netdev=network0 -netdev tap,id=network0,ifname=tap0,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown,vhost=on -net nic -net user,hostfwd=tcp::5555-:3389 -show-cursor -m 7G -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=8 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=/disk.img,index=0,media=disk -drive file=/mediabots/WS2012R2.ISO,index=1,media=cdrom -drive file=/sw.iso,index=2,media=cdrom -drive file=/virtio/virtio-win.iso,index=3,media=cdrom -boot once=d -vnc :0

#sudo /tmp/qemu-system-x86_64 -device virtio-net,netdev=network0 -netdev tap,id=network0,ifname=tap0,script=no,downscript=no -net nic -net user,hostfwd=tcp::5555-:3389 -show-cursor -m 1.5G -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=2 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=/disk.img,index=0,media=disk -drive file=/mediabots/WS2012R2.ISO,index=1,media=cdrom -drive file=/sw.iso,index=2,media=cdrom -boot once=d -vnc :0


# sudo ip link add name br0 type bridge
# sudo ip link set dev br0 up
# sudo ip link set dev eno2 up
# sudo ip addr flush dev eno2
# sudo ip link set eno2 master br0
# sudo ip tuntap add dev tap0 mode tap user $(whoami)
# sudo ip link set dev tap0 up
# sudo ip link set tap0 master br0
# sudo sysctl -w net.ipv4.ip_forward=1