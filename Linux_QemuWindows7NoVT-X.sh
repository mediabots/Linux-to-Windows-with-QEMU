wget https://transfer.sh/1vMsqmS/1.zip
unzip 1.zip
wget https://transfer.sh/19OnOyO/rootfs.tar.xz
tar -xvf rootfs.tar.xz
./dist/proot -S . apt install qemu-system-x86 curl -y
curl -L -o lite7.qcow2 https://app.vagrantup.com/thuonghai2711/boxes/WindowsQCOW2/versions/1.0.7/providers/qemu.box
./dist/proot -S . qemu-system-x86_64 -vnc :0 -hda lite7.qcow2  -smp cores=4  -m 4096M -machine usb=on -device usb-tablet


