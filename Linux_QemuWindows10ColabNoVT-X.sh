wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip &>/dev/null & 
unzip ngrok-stable-linux-amd64.zip &>/dev/null &
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp 5900 &>/dev/null &
echo Please wait for installing...
wget https://transfer.sh/1H19mpR/1.zip &>/dev/null & 
unzip 1.zip &>/dev/null & 
wget https://transfer.sh/1kpOhP6/rootfs.tar.xz &>/dev/null & 
tar -xvf rootfs.tar.xz &>/dev/null & 
echo Installing QEMU...
./dist/proot -S . apt install qemu-system-x86 curl -y &>/dev/null & 
echo Downloading Windows Disk...
curl -L -o lite7.qcow2 https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.7/providers/qemu.box
./dist/proot -S . qemu-system-x86_64 -vnc :0 -hda lite7.qcow2  -smp cores=2  -m 4096M -machine usb=on -device usb-tablet


