#!/bin/bash
#
#Vars
echo Install Windows 2022 KVM
yum install sudo -y
sudo yum install wget vim curl genisoimage -y
# Downloading Portable QEMU-KVM
echo "Downloading QEMU"
umount /dev/mapper/centos-home
yes|lvreduce -L 2G /dev/mapper/centos-home
lvextend -r -l+100%FREE /dev/mapper/centos-root
sudo yum remove xorg* -y
sudo yum remove gnome* -y
yum remove xrdp -y
sudo yum install -y qemu-kvm
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo yum install -y powershell
sudo ln -s /usr/bin/genisoimage /usr/bin/mkisofs
sudo wget -O /mediabots/WS2022.ISO https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_SERVER_EVAL_x64FRE_en-us.iso
sudo wget -P /floppy http://dl.google.com/chrome/install/375.126/chrome_installer.exe
sudo mv /floppy/'chrome_installer.exe' /floppy/chrome_installer.exe
# Powershell script to auto enable remote desktop for administrator
sudo touch /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name \"fDenyTSConnections\" -Value 0" >> /floppy/EnableRDP.ps1
sudo echo -e "Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name \"UserAuthentication\" -Value 1" >> /floppy/EnableRDP.ps1
sudo echo -e "Enable-NetFirewallRule -DisplayGroup \"Remote Desktop\"" >> /floppy/EnableRDP.ps1
# Downloading Virtio Drivers
sudo wget -P /virtio https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
# creating .iso for Windows tools & drivers
sudo mkisofs -o /sw.iso /floppy
#Enabling KSM
sudo echo 1 > /sys/kernel/mm/ksm/run
#Free memories
sync; sudo echo 3 > /proc/sys/vm/drop_caches
# setting up default values
custom_param_os="/mediabots/"$(ls /mediabots)
custom_param_sw="/sw.iso"
custom_param_virtio="/virtio/"$(ls /virtio)
custom_param_ram="-m 6144M"
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
skipped=0
partition=0
other_drives=""
format=",format=raw"
qemupath=$(whereis qemu-kvm | sed "s/ /\n/g" | egrep "^/usr/libexec/")
echo "creating disk image"
dd if=/dev/zero of=disk.img bs=1024k seek=52224 count=0
custom_param_disk="disk.img"
sudo $qemupath -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=$custom_param_disk,index=0,media=disk -drive file=$custom_param_os,index=1,media=cdrom -drive file=$custom_param_sw,index=2,media=cdrom -boot once=d -vnc :9 &


