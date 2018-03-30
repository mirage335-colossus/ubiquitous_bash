#Overload this function, or the guestArch variable, to configure QEMU to  guest with a specif
_qemu() {
	local qemuHostArch
	qemuHostArch=$(uname -m)
	[[ "$qemuHostArch" == "" ]] && qemuGuestArch="$qemuHostArch"
	 _messagePlain_probe 'qemuGuestArch= '"$qemuGuestArch"
	
	local qemuExitStatus
	
	[[ "$qemuHostArch" == "x86_64" ]] && _messagePlain_probe '>qemu= qemu-system-x86_64' && qemu-system-x86_64 "$@"
	qemuExitStatus="$?"
	
	
	return "$qemuExitStatus"
}

_integratedQemu() {
	_messagePlain_nominal 'init: _integratedQemu'
	
	! mkdir -p "$instancedVirtDir" && _messagePlain_bad 'fail: mkdir -p instancedVirtDir= '"$instancedVirtDir" && _stop 1
	
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	
	if _testQEMU_hostArch_x64_nested
	then
		_messagePlain_good 'supported: nested x64'
		qemuArgs+=(-cpu host)
	else
		_messagePlain_warn 'warn: no nested x64'
	fi
	
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l)
	[[ "$hostThreadCount" -ge "4" ]] && [[ "$hostThreadCount" -lt "8" ]] && _messagePlain_probe 'cpu: >4' && qemuArgs+=(-smp 4)
	[[ "$hostThreadCount" -ge "8" ]] && _messagePlain_probe 'cpu: >6' && qemuArgs+=(-smp 6)
	
	qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c)
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	qemuUserArgs+=(-m "$vmMemoryAllocation")
	
	qemuUserArgs+=(-net nic,model=rtl8139 -net user,smb="$sharedHostProjectDir")
	
	qemuArgs+=(-usbdevice tablet)
	
	qemuArgs+=(-vga cirrus)
	
	qemuArgs+=(-show-cursor)
	
	if _testQEMU_hostArch_x64_hardwarevt
	then
		_messagePlain_good 'found: kvm'
		_mesqemuArgs+=(-machine accel=kvm)
	else
		_messagePlain_warn 'missing: kvm'
	fi
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_messagePlain_probe _qemu "${qemuArgs[@]}"
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
	
	_messageNormal "Checking lock."
	_readLocked "$scriptLocal"/_qemuEdit && _messageError 'lock: _qemuEdit' && _stop 1
	! _createLocked "$scriptLocal"/_qemuEdit  && _messageError 'lock: _qemuEdit' && _stop 1
	
	_messageNormal "Launch: _integratedQemu."
	! _integratedQemu "$@" && _messageError 'FAIL' && _stop 1
	
	rm -f "$scriptLocal"/_qemuEdit
	
	_stop
}

_editQemu() {
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}
