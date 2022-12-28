#!/bin/bash

#create dir structure
mkdir /library
mkdir /library/data1
mkdir /library/data2
mkdir /library/data3

#create fstab
echo "192.168.1.23:/mnt/md0/data      /library/data1  nfs     defaults        0       0" | tee /etc/fstab
echo "192.168.1.23:/mnt/md1/data2     /library/data2  nfs     defaults        0       0" | tee /etc/fstab
echo "192.168.1.23:/mnt/md2/data3     /library/data3  nfs     defaults        0       0" | tee /etc/fstab