wget https://transfer.sh/1vMsqmS/1.zip
unzip 1.zip
wget https://transfer.sh/19OnOyO/rootfs.tar.xz
tar -xvf rootfs.tar.xz
./dist/proot -S . /bin/bash
lscpu
