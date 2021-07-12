#!/bin/bash
#
#Vars
clear
echo "Wellcome to VM start, type DISKNAME,CPU,RAM(MB),PORT(Max 5 number) you want:"
cd vm 
ls -l --block-size=GB
read -p "DISK NAME: " DISKNAME
read -p "DISK SIZE(Blank for default): " DISKSIZE
read -p "CPU(Virtual Processor): " CPU
read -p "RAM(MB): " RAM
read -p "PORT(Max 5 number): " PORT
custom_ram="$RAM""M"
custom_disk="$DISKSIZE""GB"
qemu-img resize $DISKNAME.qcow2 $custom_disk
cd ..
sudo /usr/bin/qemu-system-x86_64 -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$DISKNAME.qcow2,index=0,media=disk,format=qcow2 -boot once=d & disown %1
echo VM Specifications: $CPU CPU , $custom_ram RAM
echo "Successfully!! Your VM start with RDP Port $PORT"
echo "To check Qemu VM Process:  ps auxw |grep qemu"
echo "To start NGROK: ./ngrok tcp --region ap $PORT"
echo "To start NGROK in background: nohup ./ngrok tcp --region ap $PORT &>/dev/null &"
