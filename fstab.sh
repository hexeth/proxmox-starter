#!/bin/bash

#install nfs-common
apt update
apt install nfs-common git -y

#create dir structure
DIR=/library
if [ ! -d $DIR ]; then
    mkdir "/library"
    mkdir "/library/data1"
    mkdir "/library/data2"
    mkdir "/library/data3"
    chown root:root /library -R
fi

#create fstab
wget https://raw.githubusercontent.com/hexeth/proxmox-starter/main/fstab -O /etc/fstab
chown root:root /etc/fstab
#mount
mount -a

#install oh-my-bash
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
sed -i '/TEXT_TO_BE_REPLACED/c\This line is removed by the admin.' /tmp/foo