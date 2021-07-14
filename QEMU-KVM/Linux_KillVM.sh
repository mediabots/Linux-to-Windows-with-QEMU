#!/bin/bash
#
#Vars
clear
echo "Wellcome to VM kill, type DISKNAME of VM you want to kill:"
cd vm
read -p "DISK NAME: " DISKNAME
vm=$(echo cat $DISKNAME.txt | bash)
kill $vm 
cd ..
