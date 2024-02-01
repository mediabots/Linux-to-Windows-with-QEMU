#!/bin/bash
#
#Vars
clear
echo "Wellcome to VM kill, type DISKNAME of VM you want to kill:"
cd vm
ls -l --block-size=GB | cut -f1 -d. | uniq -c
read -p "DISK NAME: " DISKNAME
vm=$(echo cat $DISKNAME.txt | bash)
kill $vm 
cd ..
echo "Kill VM $DISKNAME $vm successfully!! "
