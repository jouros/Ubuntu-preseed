#!/bin/bash


# no-reboot = stop after install

if [ "$1" == "-h" ]; then
         echo ""
         echo "Example: ./qemu-no-reboot-ubuntu.sh -n ubuntu -d '/var/lib/libvirt/images/ubuntu.qcow2' -l '/var/lib/libvirt/images/ubuntu-20.04.3-live-server-amd64.iso' -e '/var/lib/libvirt/images/seed.iso' 2>&1 | tee out.txt"
         exit 0
fi

if [ "$#" -lt  8 ]; then
	echo ""
        echo "Not enough parameters, check usage with -h"
        exit 9999 
fi


if [ ! -d "/mnt/casper" ]; then 
        echo ""
        echo "/mnt/casper DOES  NOT exist, did you mount it?" 
        exit 9998 
fi

while getopts n:d:l:e: flag
do
        case "${flag}" in
                n) NAME=${OPTARG};;
                d) DPATH=${OPTARG};;
                l) LOCATION=${OPTARG};;
		e) SEED=${OPTARG};;
        esac
done

if [ ! -f "$DPATH" ]; then 
	echo ""
        echo "Image DOES NOT exists: $DPATH, did you run 'qemu-img create -f qcow2 ubuntu.qcow2 100G; sudo mv ubuntu.qcow2 /var/lib/libvirt/images/'?" 
        exit 9997 
fi

if [ ! -f "$LOCATION" ]; then
        echo ""
        echo "ubuntu-20.04.3-live-server-amd64.iso DOES NOT exists: $LOCATION, check you parameter." 
        exit 9996
fi

/usr/bin/qemu-system-x86_64 \
         --monitor tcp:127.0.0.1:20001,server,nowait \
         -smp 2 \
         -name "$NAME" \
         -device virtio-net,netdev=user.0 \
         -netdev bridge,id=user.0,br=virbr0 \
         -m 1024 \
         -boot once=d \
         -drive file="$DPATH",if=virtio,cache=none,discard=ignore,format=qcow2 \
         -drive file="$LOCATION",media=cdrom \
	 -drive file="$SEED",format=raw,cache=none,if=virtio \
         -machine type=pc,accel=kvm \
         -nographic \
	 -no-reboot \
         -kernel /mnt/casper/vmlinuz \
	 -initrd /mnt/casper/initrd \
         -append 'console=tty0 console=ttyS0,115200n8 autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 serial=ds=nocloud'
