#!/bin/bash

#create dir structure
DIR=/library
if [ ! -d $DIR ]; then
    mkdir "/library"
    mkdir "/library/data1"
    mkdir "/library/data2"
    mkdir "/library/data3"
fi

#create fstab
wget https://raw.githubusercontent.com/hexeth/proxmox-starter/main/fstab -O /etc/fstab

#mount
mount -a