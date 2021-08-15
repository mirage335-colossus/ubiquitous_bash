
_checkVBox_raw() {
	#Use existing VDI image if available.
	[[ -e "$scriptLocal"/vm.vdi ]] && _messagePlain_bad 'conflict: vm.vdi' && return 1
	
	# WARNING: Only 'vm.img' is supported as a raw image file name for vbox virtualization backend.
	[[ ! -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'missing: vm.img' && return 1
	
	return 0
}

# WARNING
# Per VirtualBox developers, "This is a development tool and shall only be used to analyse problems. It is completely unsupported and will change in incompatible ways without warning."
# If that happens, this function will be revised quickly, possibly to the point of generating the VMDK file itself with a here document instead of VirtualBox commands. See "_diag/data/vmdkRawExample".
_create_vbox_raw() {
	if ! VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" > "$vboxRaw".log
	then
		_messagePlain_bad 'fail: 'VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" '>' "$vboxRaw".log
	fi
	return 0
}

_mountVBox_raw_sequence() {
	_messagePlain_nominal 'start: _mountVBox_raw_sequence'
	_start
	
	_checkVBox_raw || _stop 1
	
	! _wantSudo && _messagePlain_bad 'bad: sudo' && return 1
	
	_prepare_instance_vbox
	
	rm -f "$vboxRaw" > /dev/null 2>&1
	
	
	
	if _tryExecFull _hook_systemd_shutdown_action "_closeVBoxRaw" "$sessionid"
	then
		_messagePlain_good 'pass: _hook_systemd_shutdown_action'
	else
		_messagePlain_bad 'fail: _hook_systemd_shutdown_action'
	fi
	
	
	
	
	local current_imagefilename
	current_imagefilename=$(_loopImage_imagefilename)
	
	_messagePlain_nominal 'Creating loopback.'
	
	# Echo error message.
	[[ -e "$scriptLocal"/vboxloop ]] && _messagePlain_bad 'fail: copy vboxloop' && _stop 1
	
	! _loopFull "$scriptLocal"/vboxloop && _messagePlain_bad 'fail: losetup' && _stop 1
	
	
	
	local vboximagedev
	vboximagedev=$(cat "$scriptLocal"/vboxloop)
	
	
	if _detect_deviceAsVirtImage "$current_imagefilename"
	then
		_messagePlain_warn 'warn: chown: ignoring device'
	else
		! sudo -n chown "$USER" "$vboximagedev" && _messagePlain_bad 'chown vboximagedev= '"$vboximagedev" && _stop 1
	fi
	
	
	_messagePlain_nominal 'Creating VBoxRaw.'
	_create_vbox_raw "$vboximagedev"
	
	
	
	_messagePlain_nominal 'stop: _mountVBox_raw_sequence'
	#_safeRMR "$instancedVirtDir" || _stop 1
	_rm_instance_vbox || _stop 1
	_stop 0
}

_mountVBox_raw() {
	"$scriptAbsoluteLocation" _mountVBox_raw_sequence
	return "$?"
}

_waitVBox_opening() {
	! [[ -e "$vboxRaw" ]] && return 1
	! [[ -e "$scriptLocal"/vboxloop ]] && return 1
	
	local vboximagedev=$(cat "$safeTmp"/vboxloop)
	! [[ -e "$vboximagedev" ]] && return 1
}

_umountVBox_raw() {
	! _umountFull "$scriptLocal"/vboxloop && _stop 1
	
	rm -f "$scriptLocal"/vboxloop > /dev/null 2>&1
	rm -f "$vboxRaw" > /dev/null 2>&1
	rm -f "$vboxRaw".log > /dev/null 2>&1
	
	return 0
}

_waitVBox_closing() {
	true
}

_openVBoxRaw() {
	export specialLock="$lock_open_vbox"
	
	_checkVBox_raw || _stop 1
	
	_messagePlain_nominal 'launch: _open _waitVBox_opening _mountVBox_raw'
	
	local openVBoxRaw_exitStatus
	_open _waitVBox_opening _mountVBox_raw
	openVBoxRaw_exitStatus="$?"
	
	export specialLock=""
	
	return "$openVBoxRaw_exitStatus"
}

_closeVBoxRaw() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	export specialLock="$lock_open_vbox"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitVBox_closing _umountVBox_raw
		[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
		export specialLock=""
		return 0
	fi
	
	_close _waitVBox_closing _umountVBox_raw
	[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
	export specialLock=""
	return 0
}
