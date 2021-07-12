#!/bin/bash
#
#Vars
clear

echo "Wellcome to VM creation, type DISKNAME,CPU,RAM(MB),PORT you want:"

read -p "DISKNAME: " DISKNAME
read -p "CPU: " CPU
read -p "RAM(MB): " RAM
read -p "PORT: " PORT
custom_ram="$RAM""M"

mkdir vm
cp lite11.qcow2 vm/$DISKNAME.qcow2


sudo /usr/bin/qemu-system-x86_64 -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$DISKNAME.qcow2,index=0,media=disk,format=qcow2 -boot once=d & disown %1

echo VM Specifications: $CPU CPU , $RAM RAM
echo Successfully!! Your VM start with RDP Port $PORT
echo To check Qemu VM Process:  ps auxw |grep qemu
