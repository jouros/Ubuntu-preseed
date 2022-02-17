#!/bin/bash
 
if [ "$1" == "-h" ]; then
         echo ""
	 echo "This is script to import qemu deployed VM into virsh"
         echo "Example: ./vm-script-start.sh -n ubuntu -d 'Ubuntu host' -p '/var/lib/libvirt/images/ubuntu.qcow2' 2>&1 | tee out.txt"
	 echo ""
         exit 0
fi
 
if [ "$#" -lt  6 ]; then
        echo "Not enough parameters, check usage with -h"
        exit 0
fi
 
while getopts n:d:p:s:l:e: flag
do
        case "${flag}" in
                n) NAME=${OPTARG};;
                d) DESCRIPTION=${OPTARG};;
                p) DPATH=${OPTARG};;
        esac
done
 
echo ""
echo "#################################################"
echo "Parameters:"
echo ""
echo "NAME        = $NAME";
echo "DESCRIPTION = $DESCRIPTION";
echo "DPATH       = $DPATH";
echo ""
echo "################################################"
echo "Starting..."
echo ""
# console pty,target_type=virtio ok for ubuntu 
virt-install \
        --virt-type kvm \
        --connect qemu:///system \
        --name "$NAME" \
	--import \
        --description "$DESCRIPTION" \
        --ram 1024 \
        --vcpus 1 \
	--cpu host \
        --disk path="$DPATH",format=qcow2,bus=virtio,discard=unmap,cache=none \
	--boot hd \
        --os-type generic \
        --network network=default,model=virtio \
        --graphics none \
	--video virtio \
	--channel spicevmc \
        --debug \
        --console pty,target_type=serial \
        --qemu-commandline='-smbios type=1' 


