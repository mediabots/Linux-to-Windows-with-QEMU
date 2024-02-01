dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist	= "CentOS" ] ; then
	qemupath=$(whereis qemu-kvm | sed "s/ /\n/g" | egrep "^/usr/libexec/")
	#b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:print:]\n" | sed 's/^/\/dev\//'))
else
	qemupath=$(whereis qemu-system-x86_64 | cut -f2 -d" ")
	#b=($(fdisk -l | grep "^/dev/" | tr -d "*" | tr -s '[:space:]' | cut -f1 -d" "))
fi

echo $qemupath >qemupath.txt
 


qemupath=$(echo cat qemupath.txt | bash)

clear
echo "VPS1"
vps=vps1




custom_ram="6000""M"
CPU=3
PORT=1001
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS2"
vps=vps2




custom_ram="6000""M"
CPU=3
PORT=1002
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS3"
vps=vps3




custom_ram="6000""M"
CPU=3
PORT=1003
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS4"
vps=vps4




custom_ram="6000""M"
CPU=3
PORT=1004
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS5"
vps=vps5




custom_ram="6000""M"
CPU=3
PORT=1005
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS6"
vps=vps6




custom_ram="6000""M"
CPU=3
PORT=1006
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS7"
vps=vps7




custom_ram="6000""M"
CPU=3
PORT=1007
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS8"
vps=vps8




custom_ram="6000""M"
CPU=3
PORT=1008
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS9"
vps=vps9




custom_ram="6000""M"
CPU=3
PORT=1009
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT

echo "VPS10"
vps=vps10




custom_ram="6000""M"
CPU=3
PORT=10010
sudo nohup $qemupath -nographic -net nic -net user,hostfwd=tcp::$PORT-:3389 -show-cursor -m $custom_ram -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=$CPU -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=vm/$vps.raw,index=0,media=disk,format=raw -boot once=d &>/dev/null & disown %1
echo $! > $DISKNAME.txt
cp $DISKNAME.txt vm/$DISKNAME.txt
rm $DISKNAME.txt
echo VM Specifications: $CPU CPU , $custom_ram RAM, $PORT
