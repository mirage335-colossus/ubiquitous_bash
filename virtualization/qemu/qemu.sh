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
	
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l | tr -dc '0-9')
	[[ "$hostThreadCount" -ge "4" ]] && [[ "$hostThreadCount" -lt "8" ]] && _messagePlain_probe 'cpu: >4' && qemuArgs+=(-smp 4)
	[[ "$hostThreadCount" -ge "8" ]] && _messagePlain_probe 'cpu: >6' && qemuArgs+=(-smp 6)
	
	qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c)
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	qemuUserArgs+=(-m "$vmMemoryAllocation")
	
	[[ "$qemuUserArgs_netRestrict" == "" ]] && qemuUserArgs_netRestrict="n"
	
	qemuUserArgs+=(-net nic,model=rtl8139 -net user,restrict="$qemuUserArgs_netRestrict",smb="$sharedHostProjectDir")
	
	qemuArgs+=(-usbdevice tablet)
	
	qemuArgs+=(-vga cirrus)
	
	[[ "$qemuArgs_audio" == "" ]] && qemuArgs+=(-device ich9-intel-hda -device hda-duplex)
	
	qemuArgs+=(-show-cursor)
	
	if _testQEMU_hostArch_x64_hardwarevt
	then
		_messagePlain_good 'found: kvm'
		qemuArgs+=(-machine accel=kvm)
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
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	"$scriptAbsoluteLocation" _userQemu_sequence "$@"
}

_editQemu_sequence() {
	unset qemuSpecialArgs
	
	export qemuSpecialArgs
	
	_start
	
	#_messageNormal "Checking lock."
	#_readLocked "$scriptLocal"/_qemuEdit && _messageError 'lock: _qemuEdit' && _stop 1
	#! _createLocked "$scriptLocal"/_qemuEdit  && _messageError 'lock: _qemuEdit' && _stop 1
	
	_messageNormal "Checking lock and conflicts."
	export specialLock="$lock_open_qemu"
	! _open true true && _messageError 'FAIL' && _stop 1
	
	_messageNormal "Launch: _integratedQemu."
	! _integratedQemu "$@" && _messageError 'FAIL' && _stop 1
	
	rm -f "$scriptLocal"/_qemuEdit > /dev/null 2>&1
	export specialLock="$lock_open_qemu"
	! _close true true && _messageError 'FAIL' && _stop 1
	
	_stop
}

_editQemu() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}
