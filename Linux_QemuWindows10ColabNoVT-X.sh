wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1
read -p "Paste authtoken here (Copy and Ctrl+V to paste): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp 5900 &>/dev/null &
echo Please wait for installing...
wget https://transfer.sh/1H19mpR/1.zip > /dev/null 2>&1
unzip 1.zip > /dev/null 2>&1
wget https://transfer.sh/1kpOhP6/rootfs.tar.xz > /dev/null 2>&1
tar -xvf rootfs.tar.xz > /dev/null 2>&1
echo Installing QEMU...
./dist/proot -S . apt install qemu-system-x86 curl -y > /dev/null 2>&1
echo Downloading Windows Disk...
curl -L -o lite10.qcow2 https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.1.3/providers/qemu.box
qemu-img resize lite10.qcow2 100G
./dist/proot -S . qemu-system-x86_64 -vnc :0 -hda lite10.qcow2  -smp cores=2  -m 8192M -machine usb=on -device usb-tablet


