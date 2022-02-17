# Ubuntu-preseed
1. Create folder for seeds: mkdir ubuntu_seeds; cd ubuntu_seeds/
2. Create meta-data: touch meta-data
3. Modify user-data
4. Check syntax: cloud-init devel schema --config-file user-data
5. Create iso: cloud-localds seed.iso user-data meta-data; sudo mv seed.iso /var/lib/libvirt/images/seed.iso
6. Mount: mount -o loop /var/lib/libvirt/images/ubuntu-20.04.3-live-server-amd64.iso /mnt
7. Create disk: qemu-img create -f qcow2 ubuntu.qcow2 100G; sudo mv ubuntu.qcow2 /var/lib/libvirt/images/
8. Run: ./qemu-no-reboot-ubuntu.sh -n ubuntu -d '/var/lib/libvirt/images/ubuntu.qcow2' -l '/var/lib/libvirt/images/ubuntu-20.04.3-live-server-amd64.iso' -e '/var/lib/libvirt/images/seed.iso' 2>&1 | tee out.txt
VM can be imported into virsh with: vm-script-start.sh
qemu deployment can be controlled from: nc 127.0.0.1 20001
Error logs can be seen here: nc -l 20000
