_qemu() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" == "x86_64" ]]
	then
		mkdir -p "$scriptLocal"
		_createLocked "$scriptLocal"/_qemu || return 1
		
		qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -boot c -m 768
		
		rm -f "$scriptLocal"/_qemu
		return 0
	fi
	
	return 1
}

_integratedQemu() {
	mkdir -p "$instancedVirtDir" || _stop 1
	
	_readLocked "$scriptLocal"/_qemu && _stop 1
	
	_commandBootdisc "$@" || _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	
	qemuUserArgs+=(-machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -net nic -net user,smb="$sharedHostProjectDir")
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	qemu-system-x86_64 "${qemuArgs[@]}"
	
	_safeRMR "$instancedVirtDir" || _stop 1
}

#"${qemuSpecialArgs[@]}" == ["-snapshot "]
_userQemu_sequence() {
	unset qemuSpecialArgs
	
	qemuSpecialArgs+=("-snapshot")
	
	export qemuSpecialArgs
	
	_start
	
	_integratedQemu "$@" || _stop 1
	
	_stop
}

_userQemu() {
	"$scriptAbsoluteLocation" _userQemu_sequence "$@"
}

_editQemu_sequence() {
	unset qemuSpecialArgs
	
	export qemuSpecialArgs
	
	_start
	
	_integratedQemu "$@" || _stop 1
	
	_stop
}

_editQemu() {
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}
