_prepare_instance_vbox() {
	_prepare_vbox "$instancedVirtDir"
}

_wait_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	VBoxXPCOMIPCD_PID=$(cat "$VBoxXPCOMIPCD_PIDfile" 2> /dev/null)
	#echo -e '\E[1;32;46mWaiting for VBoxXPCOMIPCD to finish... \E[0m'
	while kill -0 "$VBoxXPCOMIPCD_PID" > /dev/null 2>&1
	do
		sleep 0.2
	done
}

_rm_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	#Usually unnecessary, possibly destructive, may delete VM images.
	#VBoxManage unregistervm "$sessionid" --delete > /dev/null 2>&1
	
	_safeRMR "$instancedVirtDir" || return 1
	
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -f "$VBOX_USER_HOME_short" > /dev/null 2>&1
	
	#_closeVBoxRaw || return 1
	
	return 0
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}

#https://www.virtualbox.org/ticket/18257
_workaround_VirtualBoxVM() {
	if type VirtualBoxVM > /dev/null 2>&1
	then
		VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1 && type /usr/lib/virtualbox/VirtualBoxVM > /dev/null 2>&1
	then
		/usr/lib/virtualbox/VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1 && type /usr/local/lib/virtualbox/VirtualBoxVM > /dev/null 2>&1
	then
		/usr/local/lib/virtualbox/VirtualBoxVM "$@"
		return
	fi
	if ! type VirtualBoxVM > /dev/null 2>&1
	then
		VirtualBox "$@"
		return
	fi
}

_vboxGUI() {
	#_workaround_VirtualBoxVM "$@"
	
	#VirtualBoxVM "$@"
	#VirtualBox "$@"
	VBoxSDL "$@"
}


_set_instance_vbox_type() {
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Debian_64
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Gentoo
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Windows2003
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	[[ "$vboxOStype" == "" ]] && _readLocked "$lock_open" && export vboxOStype=Debian_64
	[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	_messagePlain_probe 'vboxOStype= '"$vboxOStype"
	
	if VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	then
		_messagePlain_probe VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
		return 0
	fi
	_messagePlain_bad 'fail: 'VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	return 1
}

_set_instance_vbox_cores_more() {
	[[ "$1" -ge "$vboxCPUs" ]] && _messagePlain_probe 'cpu: >'"$1" && export vboxCPUs="$1"
}

# ATTENTION: Override, function, or, variables, with "ops" or similar.
# WARNING: Do not cause use of more than half the number of physical cores (not threads) unless specifically required.
_set_instance_vbox_cores() {
	# DANGER: Do not set "vboxCPUs" unless specifically required.
	# Intended only where specifically necessary to force a specific number of threads (eg. "1").
	# FAIL if "hostThreadCount" < "vboxCPUs" .
	# FAIL or DEGRADE if "hostCoreCount" < "vboxCPUs" .
	# POSSIBLE DEGRADE if nesting AND "vboxCPUs" != "" .
	[[ "$vboxCPUs" != "" ]] && _messagePlain_warn 'warn: configured: force: vboxCPUs= '"$vboxCPUs" && return 0
	
	export vboxCPUs=1
	
	local hostCoreCount
	local hostThreadCount
	local hostThreadAllowance
	
	
	# Physical Cores.
	local hostCoreCount=$(grep ^cpu\\scores /proc/cpuinfo | head -n 1 | tr -dc '0-9')
	
	# Logical Threads.
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l | tr -dc '0-9')
	
	# Typical stability margin reservation.
	let hostThreadAllowance="$hostCoreCount"-2
	
	_messagePlain_probe_var hostCoreCount
	_messagePlain_probe_var hostThreadCount
	
	# Catch core/thread detection failure.
	if [[ "$hostCoreCount" -lt "1" ]] || [[ "$hostCoreCount" == "" ]] || [[ "$hostThreadCount" -lt "1" ]] || [[ "$hostThreadCount" == "" ]]
	then
		_messagePlain_bad 'fail: hostCoreCount, hostThreadCount'
		_messagePlain_warn 'missing: smp: force: vboxCPUs= '1
		
		# Default, allow single threaded operation if core/thread count was indeterminite.
		return 0
	fi
	
	# Logical Threads > Physical Cores ('SMT', 'Hyper-Threading', etc)
	if [[ "$hostThreadCount" -gt "$hostCoreCount" ]]
	then
		# Logical Threads Present
		_messagePlain_good 'detect: logical threads'
		
		[[ "$hostCoreCount" -lt "6" ]] && _set_instance_vbox_cores_more "$hostCoreCount"
		
		# DANGER: Do not set "vboxCPUsAllowManyThreads" if processor capabilities (eg. Intel Atom) will be uncertain and/or host/guest latencies may be important.
		# Not recommended for Intel i7-2640M (as found in Lenovo X220) or older hosts.
		# Nevertheless, power efficiency (eg Intel Atom) may be a good reason to specifically enable this.
		# https://unix.stackexchange.com/questions/325932/virtualbox-is-it-a-bad-idea-to-assign-more-virtual-cpu-cores-than-number-of-phy
		# https://en.wikipedia.org/wiki/Hyper-threading
		if [[ "$vboxCPUsAllowManyThreads" == 'true' ]]
		then
			_messagePlain_warn 'warn: configured: vboxCPUsAllowManyThreads'
			
			[[ "$hostCoreCount" -lt "4" ]] && _set_instance_vbox_cores_more "$hostThreadCount"
			
			let hostThreadAllowance="$hostThreadCount"-2
			_set_instance_vbox_cores_more "$hostThreadAllowance"
		fi
		
		# WARNING: Do not set "vboxCPUsAllowManyCores" unless it is acceptable for guest to consume (at least nearly) 100% CPU cores/threads/time/resources.
		if [[ "$vboxCPUsAllowManyCores" == 'true' ]]
		then
			_messagePlain_probe 'configured: vboxCPUsAllowManyCores'
			
			let hostThreadAllowance="$hostCoreCount"-2
			_set_instance_vbox_cores_more "$hostThreadAllowance"
		fi
		
		[[ "$hostCoreCount" -ge "32" ]] && _set_instance_vbox_cores_more 20
		
		[[ "$hostCoreCount" -lt "32" ]] && [[ "$hostCoreCount" -ge "24" ]] && _set_instance_vbox_cores_more 14
		[[ "$hostCoreCount" -lt "24" ]] && [[ "$hostCoreCount" -ge "16" ]] && _set_instance_vbox_cores_more 10
		[[ "$hostCoreCount" -lt "16" ]] && [[ "$hostCoreCount" -ge "12" ]] && _set_instance_vbox_cores_more 8
		[[ "$hostCoreCount" -lt "12" ]] && [[ "$hostCoreCount" -ge "10" ]] && _set_instance_vbox_cores_more 8
		[[ "$hostCoreCount" -lt "10" ]] && [[ "$hostCoreCount" -ge "8" ]] && _set_instance_vbox_cores_more 6
		[[ "$hostCoreCount" -lt "8" ]] && [[ "$hostCoreCount" -ge "6" ]] && _set_instance_vbox_cores_more 4
		
		
	else
		# Logical Threads Absent
		_messagePlain_bad 'missing: logical threads'
		
		[[ "$hostCoreCount" -lt "4" ]] && _set_instance_vbox_cores_more "$hostCoreCount"
		
		# WARNING: Do not set "vboxCPUsAllowManyCores" unless it is acceptable for guest to consume (at least nearly) 100% CPU cores/threads/time/resources.
		if [[ "$vboxCPUsAllowManyCores" == 'true' ]]
		then
			let hostThreadAllowance="$hostCoreCount"-2
			_set_instance_vbox_cores_more "$hostThreadAllowance"
		fi
		
		[[ "$hostCoreCount" -ge "32" ]] && _set_instance_vbox_cores_more 16
		
		[[ "$hostCoreCount" -lt "32" ]] && [[ "$hostCoreCount" -ge "24" ]] && _set_instance_vbox_cores_more 12
		[[ "$hostCoreCount" -lt "24" ]] && [[ "$hostCoreCount" -ge "16" ]] && _set_instance_vbox_cores_more 8
		[[ "$hostCoreCount" -lt "16" ]] && [[ "$hostCoreCount" -ge "10" ]] && _set_instance_vbox_cores_more 6
		[[ "$hostCoreCount" -lt "10" ]] && [[ "$hostCoreCount" -ge "8" ]] && _set_instance_vbox_cores_more 4
		[[ "$hostCoreCount" -lt "8" ]] && [[ "$hostCoreCount" -ge "4" ]] && _set_instance_vbox_cores_more 4
	fi
	
	# ATTENTION: Do not set "vboxCPUsMax" unless specifically required.
	if [[ "$vboxCPUsMax" != "" ]]
	then
		_messagePlain_warn 'warn: configured: vboxCPUsMax= '"$vboxCPUsMax"
		[[ "$vboxCPUs" -ge "$vboxCPUsMax" ]] && export vboxCPUs="$vboxCPUsMax"
	fi
	
	_messagePlain_probe_var vboxCPUs
	return 0
}

_set_instance_vbox_features() {
	#VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 1512 --nic1 nat --nictype1 "82543GC" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 1 --ioapic off --acpi on --pae off --chipset piix3
	
	! _set_instance_vbox_cores && return 1
	
	# WARNING: Do not set "$vmMemoryAllocation" to a high number unless specifically required.
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	_messagePlain_probe 'vmMemoryAllocation= '"$vmMemoryAllocation"
	
	[[ "$vboxNic" == "" ]] && export vboxNic="nat"
	_messagePlain_probe 'vboxNic= '"$vboxNic"
	
	
	local vboxChipset
	vboxChipset="ich9"
	#[[ "$vboxOStype" == *"Win"*"XP"* ]] && vboxChipset="piix3"
	_messagePlain_probe 'vboxChipset= '"$vboxChipset"
	
	local vboxNictype
	vboxNictype="82543GC"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxNictype="82540EM"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxNictype="82540EM"
	_messagePlain_probe 'vboxNictype= '"$vboxNictype"
	
	local vboxAudioController
	vboxAudioController="ac97"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxAudioController="hda"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxAudioController="hda"
	_messagePlain_probe 'vboxAudioController= '"$vboxAudioController"
	
	_messagePlain_nominal "Setting VBox VM features."
	
	if ! _messagePlain_probe_cmd VBoxManage modifyvm "$sessionid" --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 1 --vram 128 --memory "$vmMemoryAllocation" --nic1 "$vboxNic" --nictype1 "$vboxNictype" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus "$vboxCPUs" --ioapic on --acpi on --pae on --chipset "$vboxChipset" --audiocontroller="$vboxAudioController"
	then
		_messagePlain_bad 'fail: VBoxManage'
		return 1
	fi
	
	# Assuming x64 hosts served by VBox will have at least 'Intel HD Graphics 3000' (as found on X220 laptop/tablet) equivalent. Lesser hardware not recommended.
	if [[ "$vboxOStype" == *"Win"*"10"* ]] && [[ "$vboxCPUs" -ge "2" ]]
	then
		_messagePlain_probe VBoxManage modifyvm "$sessionid" --graphicscontroller vboxsvga --accelerate3d on --accelerate2dvideo on
		if ! VBoxManage modifyvm "$sessionid" --graphicscontroller vboxsvga --accelerate3d on --accelerate2dvideo on
		then
			_messagePlain_warn 'warn: VBoxManage: --graphicscontroller vboxsvga --accelerate3d on --accelerate2dvideo on'
		fi
	fi
	
	return 0
	
}

_set_instance_vbox_features_app() {
	true
	
	#if [[ "$vboxOStype" == *"Win"*"XP"* ]]
	#then
	#	export vboxChipset="piix3"
	#	! VBoxManage modifyvm "$sessionid" --chipset "$vboxChipset" && return 1
	#fi
	
	#! VBoxManage modifyvm "$sessionid" --usbxhci on && return 1
}

_set_instance_vbox_features_app_post() {
	true
	
	#if ! _messagePlain_probe_cmd VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 2 --device 0 --type hdd --medium "$scriptLocal"/vm_bulk.vdi --mtype "immutable"
	#then
	#	_messagePlain_warn 'fail: vm_bulk.vdi'
	#fi
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/"
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir"
		
		! VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir" && _messagePlain_warn 'fail: mount sharedHostProjectDir= '"$sharedHostProjectDir"
	fi
	
	if [[ -e "$HOME"/Downloads ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads
		
		! VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads && _messagePlain_warn 'fail: mount (shared) Downloads= '"$HOME"/Downloads
	fi
}

_set_instance_vbox_command() {
	_messagePlain_nominal 'Creating BootDisc.'
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && return 1
	return 0
}

_create_instance_vbox() {
	
	#Use existing VDI image if available.
	if ! [[ -e "$scriptLocal"/vm.vdi ]]
	then
		_messagePlain_nominal 'Missing VDI. Attempting to create from IMG.'
		! _openVBoxRaw && _messageError 'FAIL' && return 1
	fi
	
	_messagePlain_nominal 'Checking VDI file.'
	export vboxInstanceDiskImage="$scriptLocal"/vm.vdi
	_readLocked "$lock_open" && vboxInstanceDiskImage="$vboxRaw"
	! [[ -e "$vboxInstanceDiskImage" ]] && _messagePlain_bad 'missing: vboxInstanceDiskImage= '"$vboxInstanceDiskImage" && return 1
	
	_messagePlain_nominal 'Determining OS type.'
	_set_instance_vbox_type
	
	! _set_instance_vbox_features && _messageError 'FAIL' && return 1
	
	! _set_instance_vbox_features_app && _messageError 'FAIL: unknown app failure' && return 1
	
	_set_instance_vbox_command "$@"
	
	_messagePlain_nominal 'Mounting shared filesystems.'
	_set_instance_vbox_share
	
	_messagePlain_nominal 'Attaching local filesystems.'
	! VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4 && _messagePlain_bad 'fail: VBoxManage... attach ide controller'
	
	#export vboxDiskMtype="normal"
	#[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="multiattach"
	[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="immutable"
	_messagePlain_probe 'vboxDiskMtype= '"$vboxDiskMtype"
	
	_messagePlain_probe VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype"
	! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype" && _messagePlain_bad 'fail: VBoxManage... attach vboxInstanceDiskImage= '"$vboxInstanceDiskImage"
	
	[[ -e "$hostToGuestISO" ]] && ! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO" && _messagePlain_bad 'fail: VBoxManage... attach hostToGuestISO= '"$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	! VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegration,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth" && _messagePlain_warn 'fail: VBoxManage... suppress messages'
	
	_set_instance_vbox_features_app_post
	
	return 0
}

#Create and launch temporary VM around persistent disk image.
_user_instance_vbox_sequence() {
	_messageNormal '_user_instance_vbox_sequence: start'
	_start
	
	_prepare_instance_vbox || _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Checking lock vBox_vdi= '"$vBox_vdi"
	_readLocked "$vBox_vdi" && _messagePlain_bad 'lock: vBox_vdi= '"$vBox_vdi" && _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Creating instance. '"$sessionid"
	if ! _create_instance_vbox "$@"
	then
		_stop 1
	fi
	
	_messageNormal '_user_instance_vbox_sequence: Launch: _vboxGUI '"$sessionid"
	 _vboxGUI --startvm "$sessionid"
	
	_messageNormal '_user_instance_vbox_sequence: Removing instance. '"$sessionid"
	_rm_instance_vbox
	
	_messageNormal '_user_instance_vbox_sequence: stop'
	_stop
}

_user_instance_vbox() {
	"$scriptAbsoluteLocation" _user_instance_vbox_sequence "$@"
}

_userVBox() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_user_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}

_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	if ! _create_instance_vbox "$@"
	then
		return 1
	fi
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox
	
	_wait_instance_vbox
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type multiattach
	
	rm -f "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
	_stop
}

_edit_instance_vbox() {
	"$scriptAbsoluteLocation" _edit_instance_vbox_sequence "$@"
}

_editVBox() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_edit_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}

