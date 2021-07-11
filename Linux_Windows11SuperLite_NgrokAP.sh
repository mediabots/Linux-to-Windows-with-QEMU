#!/bin/bash
#
#Vars
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip *.zip
clear
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp --region ap 30889 &>/dev/null &
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
	#sudo yum update -y
	sudo yum install -y qemu-kvm
	curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
	sudo yum install -y powershell
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
	sudo apt-get install -y powershell
fi
sudo ln -s /usr/bin/genisoimage /usr/bin/mkisofs
# Downloading resources
sudo mkdir /mediabots /floppy /virtio
link1_status=$(curl -Is https://app.vagrantup.com/thuonghai2711/boxes/WindowsISO/versions/1.0.6/providers/qemu22000.box | grep HTTP | cut -f2 -d" " | head -1)
link2_status=$(curl -Is https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_SERVER_EVAL_x64FRE_en-us.iso | grep HTTP | cut -f2 -d" ")
#sudo wget -P /mediabots https://archive.org/download/WS2012R2/WS2012R2.ISO # Windows Server 2012 R2 
if [ $link1_status = "302" ] ; then 
	sudo wget -O /mediabots/WS11LITE.ISO https://app.vagrantup.com/thuonghai2711/boxes/WindowsISO/versions/1.0.6/providers/qemu22000.box
elif [ $link2_status = "200" -o $link2_status = "301" -o $link2_status = "302" ] ; then 
	sudo wget -O /mediabots/WS2022.ISO https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_SERVER_EVAL_x64FRE_en-us.iso
else
	echo -e "${RED}[Error]${NC} ${YELLOW}Sorry! None of Windows OS image urls are available , please report about this issue on Github page : ${NC}https://github.com/mediabots/Linux-to-Windows-with-QEMU"
	echo "Exiting.."
	sleep 30
	exit 1
fi
sudo wget -P /floppy http://dl.google.com/chrome/install/375.126/chrome_installer.exe
sudo mv /floppy/'chrome_installer.exe' /floppy/chrome_installer.exe
sudo wget -P /floppy https://downloadmirror.intel.com/23073/eng/PROWinx64.exe # Intel Network Adapter for Windows Server 2012 R2 
# Powershell script to auto enable remote desktop for administrator
sudo touch /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name \"fDenyTSConnections\" -Value 0" >> /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name \"UserAuthentication\" -Value 1" >> /floppy/EnableRDP.ps1
sudo echo -e "Enable-NetFirewallRule -DisplayGroup \"Remote Desktop\"" >> /floppy/EnableRDP.ps1
# Downloading Virtio Drivers
sudo wget -P /virtio https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
# creating .iso for Windows tools & drivers
sudo mkisofs -o /sw.iso /floppy
#
#Enabling KSM
sudo echo 1 > /sys/kernel/mm/ksm/run
#Free memories
sync; sudo echo 3 > /proc/sys/vm/drop_caches
# Gathering System information
idx=0
fs=($(df | awk '{print $1}'))
for j in $(df | awk '{print $6}');do if [ $j = "/" ] ; then os=${fs[$idx]};echo $os;fi;idx=$((idx+1));done
#
ip=$(curl ifconfig.me)
echo "Linux Distro : "$dist 
virtualization=$(lscpu | grep Virtualization: | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo "Virtualization : "$virtualization
model=$(lscpu | grep "Model name:" | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo "CPU Model : "$model
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
echo "No. of CPU cores : "$cpus
if [ $dist = "Debian" ] ;then availableRAMcommand="free -m | head -2 | tail -1 | awk '{print \$4}'" ; elif [ $dist = "Ubuntu" -o $dist = "CentOS" ] ;then availableRAMcommand="free -m | tail -2 | head -1 | awk '{print \$7}'"; fi
availableRAM=$(echo $availableRAMcommand | bash)
echo "Available RAM : "$availableRAM" MB"
diskNumbers=$(fdisk -l | grep "Disk /dev/" | wc -l)
partNumbers=$(lsblk | egrep "part" | wc -l) # $(fdisk -l | grep "^/dev/" | wc -l) 
firstDisk=$(fdisk -l | grep "Disk /dev/" | head -1 | cut -f1 -d":" | cut -f2 -d" ")
freeDisk=$(df | grep "^/dev/" | awk '{print$1 " " $4}' | sort -g -k 2 | tail -1 | cut -f2 -d" ")
# Windows required at least 25 GB free disk space
firstDiskLow=0
if [ $(expr $freeDisk / 1024 / 1024 ) -ge 25 ]; then
	newDisk=$(expr $freeDisk \* 90 / 100 / 1024)
	if [ $(expr $newDisk / 1024 ) -lt 25 ] ; then newDisk=25600 ; fi
else
	firstDiskLow=1
fi
#
# setting up default values
custom_param_os="/mediabots/"$(ls /mediabots)
custom_param_sw="/sw.iso"
custom_param_virtio="/virtio/"$(ls /virtio)
#
custom_param_ram="-m "$(expr $availableRAM - 200 )"M"
skipped=0
partition=0
other_drives=""
format=",format=raw"
if [ $dist	= "CentOS" ] ; then
	qemupath=$(whereis qemu-kvm | sed "s/ /\n/g" | egrep "^/usr/libexec/")
	#b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:print:]\n" | sed 's/^/\/dev\//'))
else
	qemupath=$(whereis qemu-system-x86_64 | cut -f2 -d" ")
	#b=($(fdisk -l | grep "^/dev/" | tr -d "*" | tr -s '[:space:]' | cut -f1 -d" "))
fi
if [ $diskNumbers -eq 1 ] ; then # opened 1st if
if [ $availableRAM -ge 4650 ] ; then # opened 2nd if
	echo -e "${BLUE}For below option pass${NC} yes ${BLUE}iff, your VPS/Server came with${NC} boot system in ${NC}${RED}'RESCUE'${NC} mode ${BLUE}feature${NC}"
	##read -r -p "Do you want to completely delete your current Linux O.S.? (yes/no) : " deleteLinux
	##deleteLinux=$(echo "$deleteLinux" | head -c 1)
	deleteLinux=$(echo "N" | head -c 1)
	if [ ! -z $deleteLinux ] && [ $deleteLinux = 'Y' -o $deleteLinux = 'y' ] ; then
		sudo wget -qO- /tmp https://archive.org/download/vkvm.tar_201903/vkvm.tar.gz | sudo tar xvz -C /tmp
		qemupath=/tmp/qemu-system-x86_64
		echo "erasing primary disk data"
		sudo dd if=/dev/zero of=$firstDisk bs=1M count=1 # blank out the disk
		echo "mounting devices"
		mount -t tmpfs -o size=4500m tmpfs /mnt
		mv /mediabots/* /mnt
		mkdir /media/sw
		mount -t tmpfs -o size=121m tmpfs /media/sw
		mv /sw.iso /media/sw
		custom_param_os="/mnt/"$(ls /mnt)
		custom_param_sw="/media/sw/sw.iso"
		availableRAM=$(echo $availableRAMcommand | bash)
		custom_param_disk=$firstDisk
		custom_param_ram="-m "$(expr $availableRAM - 500 )"M"
		format=""
		mounted=1
	else
		if [ $firstDiskLow = 0 ] ; then
			if [ $partNumbers -gt 1 ] ; then 
				idx=0;ix=0;
				#for i in $(fdisk -l | grep "^/dev/" | tr -d "*" | tr -s '[:space:]' | cut -f5 -d" "); do
				for i in $(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f4 -d" "); do
				b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:alnum:]\n" | sed 's/^/\/dev\//'))
				if [[ $i == *"G"  ]]; then a=$(echo $i | tr -d "G"); a=${a%.*} ; if [ $a -ge 25 -a $ix = 0 -a ${b[idx]} != $os ] ; then firstDisk=${b[idx]} ; custom_param_disk=$firstDisk ; partition=1 ; ix=$((ix+3)) ; elif [ $a -ge 25 -a $ix = 3 -a ${b[idx]} != $os ] ; then other_drives="-drive file=${b[idx]},index=$ix,media=disk,format=raw " ; fi ; fi ;
				idx=$((idx+1));
				done
				if [ $partition = 0 ] ;then 
					echo "creating disk image"
					sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
					custom_param_disk="/disk.img"
				fi
			else
				echo "creating disk image"
				sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
				custom_param_disk="/disk.img"
			fi
		else
			skipped=1
		fi
	fi
else
	if [ $firstDiskLow = 0 ] ; then
		if [ $partNumbers -gt 1 ] ; then 
			idx=0;ix=0;
			for i in $(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f4 -d" "); do
			b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:alnum:]\n" | sed 's/^/\/dev\//'))
			if [[ $i == *"G"  ]]; then a=$(echo $i | tr -d "G"); a=${a%.*} ; if [ $a -ge 25 -a $ix = 0 -a ${b[idx]} != $os ] ; then firstDisk=${b[idx]} ; custom_param_disk=$firstDisk ; partition=1 ; ix=$((ix+3)) ; elif [ $a -ge 25 -a $ix = 3 -a ${b[idx]} != $os ] ; then other_drives="-drive file=${b[idx]},index=$ix,media=disk,format=raw " ; fi ; fi ;
			idx=$((idx+1));
			done
			if [ $partition = 0 ] ;then 
				echo "creating disk image"
				sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
				custom_param_disk="/disk.img"
			fi
		else
			echo "creating disk image"
			sudo dd if=/dev/zero of=/disk.img bs=1024k seek=$newDisk count=0
			custom_param_disk="/disk.img"
		fi
	else
		skipped=1
	fi
fi # 2nd if closed
else # 1st if else
if [ $availableRAM -ge 4650 ] ; then
	##read -r -p "Do you want to completely delete your current Linux O.S.? (yes/no) : " deleteLinux
		##deleteLinux=$(echo "$deleteLinux" | head -c 1)
		deleteLinux=$(echo "N" | head -c 1)
	if [ ! -z $deleteLinux ] && [ $deleteLinux = 'Y' -o $deleteLinux = 'y' ] ; then
		sudo wget -qO- /tmp https://archive.org/download/vkvm.tar_201903/vkvm.tar.gz | sudo tar xvz -C /tmp
		qemupath=/tmp/qemu-system-x86_64
		echo "erasing primary disk data"
		sudo dd if=/dev/zero of=$firstDisk bs=1M count=1 # blank out the disk
		echo "mounting devices"
		mount -t tmpfs -o size=4500m tmpfs /mnt
		mv /mediabots/* /mnt
		mkdir /media/sw
		mount -t tmpfs -o size=121m tmpfs /media/sw
		mv /sw.iso /media/sw
		custom_param_os="/mnt/"$(ls /mnt)
		custom_param_sw="/media/sw/sw.iso"
		availableRAM=$(echo $availableRAMcommand | bash)
		##custom_param_disk=$firstDisk
		custom_param_disk=/dev/mapper/centos-root
		custom_param_ram="-m "$(expr $availableRAM - 500 )"M"
		format=""
		mounted=1
	else
		echo "using secondary disk for installation."
		custom_param_disk=$(fdisk -l | grep "Disk /dev/" | awk 'NR==2' | cut -f2 -d" " | cut -f1 -d":") # 2nd disk chosen
	fi
else
	echo "using secondary disk for installation.."
	custom_param_disk=$(fdisk -l | grep "Disk /dev/" | awk 'NR==2' | cut -f2 -d" " | cut -f1 -d":")
fi
fi # closed 1st if
# Adding other disks only if multi partitions are not exist
if [ $partition = 0 ] ; then
ix=2
if [ $custom_param_disk != "/disk.img" ] ; then
	for i in $(fdisk -l | grep "Disk /dev/" | cut -f2 -d" " | cut -f1 -d ":") ; do
	if [ $i != $custom_param_disk ];then 
	#echo $i;
	ix=$((ix+1))
	other_drives=$other_drives"-drive file=$i,index=$ix,media=disk,format=raw "
	if [ $ix = 3 ]; then break; fi
	fi
	done
fi
fi
#
# Running the KVM
echo "creating disk image"
dd if=/dev/zero of=disk.img bs=1024k seek=52224 count=0
custom_param_disk="disk.img"
echo "[ Running the KVM ]"
if [ $skipped = 0 ] ; then
echo "[.] running QEMU-KVM"
sudo $qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format -drive file=$custom_param_os,index=1,media=cdrom -drive file=$custom_param_sw,index=2,media=cdrom -boot once=d -vnc :9 &	
# [note- no sudo should be used after that]
#pidqemu=$(pgrep qemu) # does not work
pid=$(echo $! | head -1)
disown -h $pid
echo "disowned PID : "$pid
echo "[ For Debugging purpose ]"
echo -e "$qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format -drive file=$custom_param_os,index=1,media=cdrom -drive file=$custom_param_sw,index=2,media=cdrom $other_drives -boot once=d -vnc :9 & disown %1"
if [ $mounted = 1 ]; then
echo -e "wget -P /tmp https://archive.org/download/vkvm.tar_201903/vkvm.tar.gz && tar -C /tmp -zxvf /tmp/vkvm.tar.gz && rm /tmp/vkvm.tar.gz && $qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format $other_drives -boot c -vnc :9 & disown %1" > /details.txt # -vnc :23456 incase you dont want to access it via VNC
else
echo -e "$qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format $other_drives -boot c -vnc :9 & disown %1" > /details.txt
fi
echo -e "${YELLOW} SAVE BELOW GREEN COLORED COMMAND IN A SAFE LOCATION FOR FUTURE USAGE${NC}"
if [ $mounted = 1 ]; then
echo -e "${GREEN_D}wget -P /tmp https://archive.org/download/vkvm.tar_201903/vkvm.tar.gz && tar -C /tmp -zxvf /tmp/vkvm.tar.gz && /tmp/rm vkvm.tar.gz && $qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format $other_drives -boot c -vnc :9 & disown %1${NC}"
else
echo -e "${GREEN_D}$qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk$format $other_drives -boot c -vnc :9 & disown %1${NC}"
fi
echo -e "${BLUE}command also saved in /details.txt file${NC}"
echo -e "${YELLOW}Now download 'VNC Viewer' App from here :${NC} https://www.realvnc.com/en/connect/download/viewer/\n${YELLOW}Then install it on your computer${NC}"
echo -e "Finally open ${GREEN_D}$ip:9${NC} on your VNC viewer."
if [ $mounted = 1 ]; then
read -r -p "Had your Windows Server setup completed successfully? (yes/no) : " setup_initial
setup_initial=$(echo "$setup_initial" | head -c 1)
sleep 10
if [ ! -z $setup_initial ] && [ $setup_initial = 'Y' -o $setup_initial = 'y' ] ; then
echo $pid $cpus $custom_param_disk $custom_param_sw $other_drives
echo "helper called" 
for i in $(ps aux | grep -i "qemu" | head -2 | tr -s '[:space:]' | cut -f2 -d" ") ; do echo "killing process id : "$i ; kill -9 $i ; done
#sleep 30
echo "un-mounting"
umount -l /mnt
sleep 10
df
sync; echo 3 > /proc/sys/vm/drop_caches
free -m 
availableRAM=$(echo $availableRAMcommand | bash)
custom_param_ram="-m "$(expr $availableRAM - 2048 )"M"
custom_param_ram2="-m "$(expr $availableRAM - 500 )"M"
echo $custom_param_ram
echo "[..] running QEMU-KVM again"
$qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk -drive file=$custom_param_sw,index=1,media=cdrom $other_drives -boot c -vnc :9 &
pid2=$(echo $! | head -1)
disown -h $pid2
echo "disowned PID : "$pid2
echo "[ For Debugging purpose ]"
echo -e "$qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk -drive file=$custom_param_sw,index=1,media=cdrom $other_drives -boot c -vnc :9 & disown %1"
# incase you get qemu-system-x86_64: -net user,hostfwd=tcp::3889-:3389: Could not set up host forwarding rule 'tcp::3389-:3389' ,use this instead -net user,hostfwd=tcp::30889-:3389
echo -e "${YELLOW} SAVE BELOW GREEN COLORED COMMAND IN A SAFE LOCATION FOR FUTURE USAGE${NC}"
echo -e "${GREEN}wget -P /tmp https://archive.org/download/vkvm.tar_201903/vkvm.tar.gz && tar -C /tmp -zxvf /tmp/vkvm.tar.gz && rm /tmp/vkvm.tar.gz && $qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram2 -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk $other_drives -boot c -vnc :9 & disown %1${NC}"
echo -e "Now you can access your Windows server through \"VNC viewer\" or \"Remote Desktop Application\" (if your server 'Remote Desktop' is enabled)."
echo "Job Done :)"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip *.zip
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp --region ap 30889 &>/dev/null &
sleep 5
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
sleep 10
sudo mkdir /media/powershell
sudo wget -P /media/powershell https://gitlab.com/deadshot191414/winvps/-/raw/main/dotnumbers.ps1
sudo pwsh /media/powershell/dotnumbers.ps1
fi
else
echo "Job Done :)"
sleep 5
clear
echo Your RDP IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo User: Administrator
echo Pass: Thuonghai001
echo Connect to VNC, choose disk for windows install when setup done use RDP to connect
sleep 10
echo VNC Server Address:
echo 10.10.20.50:9 
echo Defaut RDP Port Forwading is 30889
#sudo mkdir /media/powershell
#sudo wget -P /media/powershell https://gitlab.com/deadshot191414/winvps/-/raw/main/dotnumbers.ps1
#sudo pwsh /media/powershell/dotnumbers.ps1
fi
else
echo "Windows OS required at least 25GB free desk space. Your Server/VPS does't have 25GB free space!"
echo "Exiting....."
fi
fi
