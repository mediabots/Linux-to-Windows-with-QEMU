#!/bin/bash
#
#Vars
yum install unzip -y
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip
clear
echo "Katacoda Centos Windows 8.1 by fb.com/thuong.hai.581"
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp --region eu 30889 &>/dev/null &
yum install sudo -y
echo "Downloading QEMU"
sudo yum install -y qemu-kvm
link1_status=$(curl -Is -k https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.4/providers/qemu.box | grep HTTP | cut -f2 -d" " | head -1)
link2_status=$(curl -Is -k https://transfer.sh/1XiXrYw/lite81.qcow2 | grep HTTP | cut -f2 -d" ")
sudo wget -O lite81.qcow2 https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.4/providers/qemu.box
[ -s lite81.qcow2 ] || sudo wget -O lite81.qcow2 https://transfer.sh/1XiXrYw/lite81.qcow2
availableRAMcommand="free -m | tail -2 | head -1 | awk '{print \$7}'"
availableRAM=$(echo $availableRAMcommand | bash)
custom_param_ram="-m "$(expr $availableRAM - 856 )"M"
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
nohup sudo /usr/libexec/qemu-kvm -nographic -net nic -net user,hostfwd=tcp::30889-:3389 -show-cursor $custom_param_ram -localtime -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$cpus -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=lite81.qcow2,index=0,media=disk,format=qcow2 -boot once=d &>/dev/null &
clear
echo "Katacoda Centos Windows 8.1 by fb.com/thuong.hai.581"
echo Your RDP IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo User: Administrator
echo Password: Thuonghai001
echo Script by fb.com/thuong.hai.581
echo Wait 30s-1m VM boot up before connect. 
echo Do not close Katacoda tab. VM expired in 1 hour.
