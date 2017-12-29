_test_vboxconvert() {
	_getDep VBoxManage
}

_vdi_to_img() {
	VBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format RAW
}

#No production use. Not recommended except to accommodate MSW hosts.
_img_to_vdi() {
	VBoxManage convertdd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format VDI 
}

#No production use. Take care to ensure neither "vm.vdi" nor "/dev/nbd0" are not in use.
_vdi_gparted() {
	sudo -n modprobe nbd
	sudo -n qemu-nbd -c /dev/nbd0 "$scriptLocal"/vm.vdi
	
	sudo -n partprobe
	
	kdesudo gparted /dev/nbd0
	
	sudo -n qemu-nbd -d /dev/nbd0
}

#No production use.
_vdi_resize() {
	mv "$scriptLocal"/vm.vdi "$scriptLocal"/vm-big.vdi
	
	#Accommodates 8024MiB.
	VBoxManage createhd --filename "$scriptLocal"/vm-small.vdi --size 8512
	
	sudo -n modprobe nbd max_part=15
	sudo -n qemu-nbd -c /dev/nbd0 "$scriptLocal"/vm-big.vdi
	sudo -n qemu-nbd -c /dev/nbd1 "$scriptLocal"/vm-small.vdi
	sudo -n partprobe
	
	#sudo -n dd if=/dev/nbd0 of=/dev/nbd1 bs=446 count=1
	sudo -n dd if=/dev/nbd0 of=/dev/nbd1 bs=1M count=8512
	sudo -n partprobe
	
	
	
	
	
	
	
	kdesudo gparted /dev/nbd0 /dev/nbd1
	
	sudo -n qemu-nbd -d /dev/nbd0
	sudo -n qemu-nbd -d /dev/nbd1
	
	mv "$scriptLocal"/vm-small.vdi "$scriptLocal"/vm.vdi
	
	#qemu-img convert -f vdi -O qcow2 vm.vdi vm.qcow2
	#qemu-img resize vm.qcow2 8512M
	
	#VBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm-small.vdi --existing
	#VBoxManage modifyhd "$scriptLocal"/vm-small.vdi --resize 8512
}
