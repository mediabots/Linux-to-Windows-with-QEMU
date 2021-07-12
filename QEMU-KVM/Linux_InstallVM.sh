#!/bin/bash
#
#Vars
echo Wellcome to VM creation, type CPU,RAM you want:

read -p "DISKNAME: " DISKNAME
read -p "CPU: " CPU
read -p "RAM: " RAM
read -p "PORT: " PORT

mkdir vm



sudo /usr/bin/qemu-system-x86_64 -nographic -net nic -net user,hostfwd=tcp::30891-:3389 -show-cursor -m 8164M -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=2 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=/vm/w11.qcow2,index=0,media=disk,format=qcow2 -boot once=d & disown %1
