_qemu() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" == "x86_64" ]]
	then
		qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -boot c -m 1536
		return 0
	fi
	
	return 1
}

_userQemu() {
	true
}
