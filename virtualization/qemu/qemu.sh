#Overload this function, or the guestArch variable, to configure QEMU to  guest with a specif
_qemu() {
	local qemuHostArch
	qemuHostArch=$(uname -m)
	[[ "$qemuHostArch" == "" ]] && qemuGuestArch="$qemuHostArch"
	
	local qemuExitStatus
	
	[[ "$qemuHostArch" == "x86_64" ]] && qemu-system-x86_64 "$@"
	qemuExitStatus="$?"
	
	
	return "$qemuExitStatus"
}

_integratedQemu() {
	mkdir -p "$instancedVirtDir" || _stop 1
	
	_commandBootdisc "$@" || _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l)
	[[ "$hostThreadCount" -ge "4" ]] && qemuArgs+=(-smp 4)
	
	qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 1256 -net nic,model=rtl8139 -net user,smb="$sharedHostProjectDir")
	
	qemuArgs+=(-usbdevice tablet)
	
	qemuArgs+=(-vga cirrus)
	
	qemuArgs+=(-show-cursor)
	
	[[ -e /dev/kvm ]] && (grep -i svm /proc/cpuinfo > /dev/null 2>&1 || grep -i kvm /proc/cpuinfo > /dev/null 2>&1) && qemuArgs+=(-machine accel=kvm)
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_qemu "${qemuArgs[@]}"
	
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
	
	_createLocked "$scriptLocal"/_qemuEdit || _stop 1
	
	_integratedQemu "$@" || _stop 1
	
	rm -f "$scriptLocal"/_qemuEdit
	
	_stop
}

_editQemu() {
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}
