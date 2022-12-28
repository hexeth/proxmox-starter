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
fstabArray = ( 
    "192.168.1.23:/mnt/md0/data      /library/data1  nfs     defaults        0       0"
    "192.168.1.23:/mnt/md1/data2     /library/data2  nfs     defaults        0       0"
    "192.168.1.23:/mnt/md2/data3     /library/data3  nfs     defaults        0       0"
) 

for i in ${fstabArray[@]}; do
  if  grep -q "$i" "/etc/fstab" ; then
         echo "$i exists" ; 
  else
         echo "$i does not exist" ; 
  fi
done