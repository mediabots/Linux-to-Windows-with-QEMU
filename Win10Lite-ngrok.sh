
clear
echo Getting ready...
sudo apt-get update -y > /dev/null 2>&1
echo "apt remove -y docker docker.io" > vm
echo "sudo apt-get install -y qemu-kvm unzip" >> vm 
nohup bash vm &>/dev/null &
[ -s windows10.raw ] || wget -q --show-progress --no-check-certificate -O- https://bit.ly/3fIeaUg | gunzip | dd of=windows10.raw bs=1M
availableRAMcommand="free -m | tail -2 | head -1 | awk '{print \$7}'"
availableRAM=$(echo $availableRAMcommand | bash)
custom_param_ram="-m "$(expr $availableRAM - 512)"M"
cpus=$(lscpu | grep CPU\(s\) | head -1 | cut -f2 -d":" | awk '{$1=$1;print}')
qemu-img resize windows10.raw 80G
nohup sudo qemu-system-x86_64 -nographic -net nic -net user,hostfwd=tcp::3389-:3389 -show-cursor -m 10G -soundhw hda -enable-kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,+nx -M pc -smp cores=2,threads=2,sockets=1 -vga std -machine type=pc,accel=kvm -usb -device usb-tablet -k en-us -drive file=windows10.raw,index=0,media=disk,format=raw,if=virtio -boot once=d -vnc :1 &>/dev/null &
clear

echo "======================="
echo "Downloading ngrok..."
echo "======================="
curl -sLkO https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
tar xf ngrok-stable-linux-amd64.tgz


function goto
{
    label=$1
    cd 
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | 
          grep -v ':$')
    eval "$cmd"
    exit
}

: ngrok
clear
echo "Go to: https://dashboard.ngrok.com/get-started/your-authtoken"
read -p "Paste Ngrok Authtoken: " CRP
./ngrok authtoken $CRP 
echo "======================="
echo "choose ngrok region (for better connection)."
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " CRP
./ngrok tcp --region $CRP 3389 &>/dev/null &
sleep 1
if curl --silent --show-error http://127.0.0.1:4040/api/tunnels  > /dev/null 2>&1; then echo OK; else echo "Ngrok Error! Please try again!" && sleep 1 && bash Win10Lite-ngrok.sh; fi
clear
echo "NoMachine: https://www.nomachine.com/download"
echo Done! RDP Information:
echo IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p' 
echo User: Administrator
echo Passwd: Thuonghai001
echo Note: Wait few minutes windows boot up before connect
