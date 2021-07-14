#!/bin/bash
#
#Vars
clear
echo "Wellcome to VM delete, type DISKNAME you want to delete:"
cd vm 
ls -l --block-size=GB | cut -f1 -d. | uniq -c
read -p "DISK NAME: " DISKNAME
rm  $DISKNAME.qcow2
rm  $DISKNAME.txt
cd ..
