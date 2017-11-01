
_checkVBox_raw() {
	_prepare_instance_vbox
	
	#Use existing VDI image if available.
	[[ -e "$scriptLocal"/vm.vdi ]] && return 1
	[[ ! -e "$scriptLocal"/vm.img ]] && return 1
	
	_wantSudo || return 1
	
	return 0
}

# WARNING
# Per VirtualBox developers, "This is a development tool and shall only be used to analyse problems. It is completely unsupported and will change in incompatible ways without warning."
# If that happens, this function will be revised quickly, possibly to the point of generating the VMDK file itself with a here document instead of VirtualBox commands. See "_diag/data/vmdkRawExample".
_create_vbox_raw() {
	VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" > "$vboxRaw".log
}


_mountVBox_raw_sequence() {
	_start
	
	_checkVBox_raw || _stop 1
	
	rm -f "$vboxRaw" > /dev/null 2>&1
	
	sudo -n losetup -f -P --show "$scriptLocal"/vm.img > "$safeTmp"/vboxloop 2> /dev/null || _stop 1
	
	
	cp -n "$safeTmp"/vboxloop "$scriptLocal"/vboxloop > /dev/null 2>&1 || _stop 1
	
	local vboximagedev=$(cat "$safeTmp"/vboxloop)
	
	sudo chown "$USER" "$vboximagedev" || _stop 1
	_create_vbox_raw "$vboximagedev"
	
	
	_stop 0
}

_mountVBox_raw() {
	"$scriptAbsoluteLocation" _mountVBox_raw_sequence
	return "$?"
}

_waitVBox_opening() {
	true
}

_umountVBox_raw() {
	local vboximagedev
	vboximagedev=$(cat "$scriptLocal"/vboxloop)
	
	sudo -n losetup -d "$vboximagedev" > /dev/null 2>&1 || return 1
	
	rm "$scriptLocal"/vboxloop > /dev/null 2>&1
	
	return 0
}

_waitVBox_closing() {
	true
}


_openVBoxRaw() {
	_checkVBox_raw || return 1
	
	_open _waitVBox_opening _mountVBox_raw
}

_closeVBoxRaw() {
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitVBox_closing _umountVBox_raw
		return
	fi
	
	_close _waitVBox_closing _umountVBox_raw
}
