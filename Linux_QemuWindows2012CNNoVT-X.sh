wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip -o ngrok-stable-linux-amd64.zip > /dev/null 2>&1
clear
read -p "Paste authtoken here (Copy and Ctrl+V to paste then press Enter): " CRP
./ngrok authtoken $CRP 
nohup ./ngrok tcp 5900 &>/dev/null &
echo Please wait for installing...
wget https://transfer.sh/1H19mpR/1.zip > /dev/null 2>&1
unzip -o 1.zip > /dev/null 2>&1
wget https://transfer.sh/1kpOhP6/rootfs.tar.xz > /dev/null 2>&1
tar -xvf rootfs.tar.xz > /dev/null 2>&1
./dist/proot -S . userdel _apt
echo "Installing QEMU (2-3m)..."
./dist/proot -S . apt install qemu-system-x86 curl -y > /dev/null 2>&1
echo Downloading Windows Disk...
curl -L -o win.qcow2 https://transfer.sh/129GjDs/win.qcow2
echo "Windows 2012 r2 CN x64 "
echo Your VNC IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "Note: Use Right-Click To Copy"
echo Script by fb.com/thuong.hai.581
cpu=$(echo nproc | bash)
./dist/proot -S . qemu-system-x86_64 -vnc :0 -hda win.qcow2 -smp 8 -accel tcg,thread=multi -m 4096 -machine usb=on -device usb-tablet > /dev/null 2>&1
