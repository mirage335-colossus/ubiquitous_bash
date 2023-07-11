#Overload this function, or the guestArch variable, to configure QEMU with specialized parameters.
_qemu_system_x86_64() {
	qemu-system-x86_64 "$@"
}

_qemu_system_arm() {
	qemu-system-arm "$@"
}

_qemu_system_aarch64() {
	qemu-system-aarch64 "$@"
}

_integratedQemu_imagefilename() {
	if [[ "$ubVirtDiskOverride" == "" ]]
	then
		local current_imagefilename
		if ! current_imagefilename=$(_loopImage_imagefilename)
		then
			_messagePlain_bad 'fail: missing: vm*.img'
			return 1
		fi
	else
		current_imagefilename="$ubVirtDiskOverride"
	fi
	
	echo "$current_imagefilename"
	
	return 0
}

# ATTENTION: Override with 'ops' or similar.
_integratedQemu_x64_display() {
	
	#qemuArgs+=(-device virtio-vga,virgl=on -display gtk,gl=on)
	
	#return 0
	
	
	true
	
	#
	
	# https://www.kraxel.org/blog/2019/09/display-devices-in-qemu/
	[[ "$qemuOStype" == "" ]] && [[ "$vboxOStype" != "" ]] && qemuOStype="$vboxOStype"
	if [[ "$ub_override_qemu_livecd" != '' ]] || [[ "$ub_override_qemu_livecd_more" != '' ]]
	then
		# DANGER: Beware not all "qemu" emulated "display" 'devices' seem to support 'hibernation' ('suspend to disk') !
		# At least 'qxl-vga' is known to successfully resume .
		# Assume 'livecd' is 'linux' .
		#qemuArgs+=(-device qxl-vga -display gtk)
		qemuArgs+=(-device qxl-vga)
	elif [[ "$qemuOStype" == 'Debian_64' ]] || [[ "$qemuOStype" == 'Gentoo_64' ]]
	then
		# Not yet enabled (virtio-vga) by default for a few reasons.
		# *) May need to specify 'gtk' or 'sdl' to enable OpenGL acceleration. If these backends are missing, qemu may fail.
		# *) Some guest configurations (eg. LXDE and Linux 4.x instead of KDE/Plasma and Linux 5.x) may not continue updating guest display resize requests, ultimately causing guest to remain at low resolution (ie. 640x480) .
		# *) Hardware graphics should only be necessary for a few specific applications (eg. FreeCAD, VR).
		# *) Any use of 'virtio-vga' seems not to support 'linux' 'hibernation' ('suspend to disk') .
		# https://github.com/mate-desktop/marco/issues/338
		if [[ "$qemuNoGL" == 'true' ]]
		then
			qemuArgs+=(-device qxl-vga)
			#qemuArgs+=(-device virtio-vga,virgl=on -display gtk,gl=off)
		else
			qemuArgs+=(-device qxl-vga)
			#qemuArgs+=(-device virtio-vga,virgl=on -display gtk,gl=on)
		fi
	elif [[ "$qemuOStype" == 'Windows10_64' ]] || [[ "$qemuOStype" == 'Windows11_64' ]]
	then
		# WARNING: MSW11 may require 256MB VRAM. How this may be set by qemu is not obvious.
		# https://blogs.oracle.com/virtualization/post/install-microsoft-windows-11-on-virtualbox
		#qemuArgs+=(-device qxl)
		qemuArgs+=(-device qxl-vga)
	elif [[ "$qemuOStype" == 'WindowsXP' ]] || [[ "$qemuOStype" == 'legacy-obsolete' ]]
	then
		qemuArgs+=(-vga cirrus)
	else
		qemuArgs+=(-vga std)
	fi
}

_integratedQemu_x64() {
	_messagePlain_nominal 'init: _integratedQemu_x64'
	
	[[ "$qemuOStype" == "" ]] && [[ "$vboxOStype" != "" ]] && qemuOStype="$vboxOStype"
	
	
	local current_imagefilename
	if ! current_imagefilename=$(_integratedQemu_imagefilename)
	then
		_stop 1
	fi
	
	
	! mkdir -p "$instancedVirtDir" && _messagePlain_bad 'fail: mkdir -p instancedVirtDir= '"$instancedVirtDir" && _stop 1
	
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	
	qemuArgs+=(-usb)
	
	if _testQEMU_hostArch_x64_nested
	then
		_messagePlain_good 'supported: nested x64'
		
		# WARNING: Nested virtualization support currently disabled by default. May impose frequent software updates or commonality between host/guest.
		# Fail for Debian Buster/Stretch host/guest.
		# Reasonably expected to fail with proprietary guest.
		# https://bugzilla.redhat.com/show_bug.cgi?id=1565179
		
		# ATTENTION: Overload "demandNestKVM" with "ops" or similar.
		if [[ "$demandNestKVM" == 'true' ]] #|| ( ! [[ "$virtOStype" == 'MSW'* ]] && ! [[ "$virtOStype" == 'Windows'* ]] && ! [[ "$qemuOStype" == 'Windows'* ]] )
		then
			[[ "$demandNestKVM" == 'true' ]] && _messagePlain_warn 'force: nested x64'
			_messagePlain_warn 'warn: set: nested x64'
			qemuArgs+=(-cpu host)
		else
			_messagePlain_good 'unset: nested x64'
		fi
		
	else
		_messagePlain_warn 'missing: nested x64'
	fi
	
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l | tr -dc '0-9')
	if [[ "$hostThreadCount" -ge "4" ]] || [[ "$hostThreadCount" -ge "8" ]]
	then
		[[ "$hostThreadCount" -ge "4" ]] && [[ "$hostThreadCount" -lt "8" ]] && _messagePlain_probe 'cpu: >4' && qemuArgs+=(-smp 4)
		[[ "$hostThreadCount" -ge "8" ]] && _messagePlain_probe 'cpu: >6' && qemuArgs+=(-smp 6)
	else
		# Single-threaded host with guest 'efi', 'Windows10_64', 'Windows11_64', are all not plausible. Minimum dual-CPU requirement of MSW11 as default.
		# ATTENTION: For guests benefitting from single core performance only, force such non-default by exporting 'vboxCPUs' with 'ops' or similar.
		if [[ "$ubVirtPlatform" == *'efi' ]] || [[ "$ubVirtPlatformOverride" == *'efi' ]] || [[ "$qemuOStype" == "Win"*"10"* ]] || [[ "$qemuOStype" == "Win"*"11"* ]]
		then
			qemuArgs+=(-smp 2)
		fi
	fi
	
	#https://superuser.com/questions/342719/how-to-boot-a-physical-windows-partition-with-qemu
	#qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img)
	#qemuUserArgs+=(-drive format=raw,file="$current_imagefilename")
	if [[ "$ub_override_qemu_livecd" != '' ]]
	then
		qemuUserArgs+=(-drive file="$ub_override_qemu_livecd",media=cdrom)
	elif [[ "$ub_override_qemu_livecd_more" != '' ]]
	then
		qemuUserArgs+=(-drive format=raw,file="$ub_override_qemu_livecd_more")
	else
		qemuUserArgs+=(-drive format=raw,file="$current_imagefilename")
	fi
	
	qemuUserArgs+=(-drive file="$hostToGuestISO",media=cdrom -boot c)
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	
	# Must have at least 4096MB for 'livecd' , unless even larger memory allocation has been configured .
	if [[ "$ub_override_qemu_livecd" != '' ]] || [[ "$ub_override_qemu_livecd_more" != '' ]]
	then
		if [[ "$vmMemoryAllocation" -lt 4096 ]]
		then
			vmMemoryAllocation=4096
		fi
	fi
	
	#[[ "$ubVirtPlatform" == *'efi' ]] || [[ "$ubVirtPlatformOverride" == *'efi' ]]
	if [[ "$vmMemoryAllocation" -lt 8704 ]] && ( [[ "$qemuOStype" == "Win"*"10"* ]] || [[ "$qemuOStype" == "Win"*"11"* ]] )
	then
		vmMemoryAllocation=8704
	fi
	
	qemuUserArgs+=(-m "$vmMemoryAllocation")
	
	[[ "$qemuUserArgs_netRestrict" == "" ]] && qemuUserArgs_netRestrict="n"
	
	qemuUserArgs+=(-net nic,model=rtl8139 -net user,restrict="$qemuUserArgs_netRestrict",smb="$sharedHostProjectDir")
	
	#qemuArgs+=(-usbdevice tablet)
	qemuArgs+=(-device usb-tablet)
	
	
	
	_integratedQemu_x64_display
	
	
	
	[[ "$qemuArgs_audio" == "" ]] && qemuArgs+=(-device ich9-intel-hda -device hda-duplex)
	
	# https://github.com/elisa-tech/meta-elisa/issues/23
	# https://wiki.qemu.org/ChangeLog/6.0
	# qemuArgs+=(-show-cursor)
	if [[ $(_qemu_system_x86_64 -version | grep version | sed 's/.*version\ //' | sed 's/\ .*//' | cut -f1 -d\. | tr -dc '0-9') -lt "6" ]]
	then
		qemuArgs+=(-show-cursor)
	fi
	
	if _testQEMU_hostArch_x64_hardwarevt
	then
		_messagePlain_good 'found: kvm'
		qemuArgs+=(-machine accel=kvm)
	else
		_messagePlain_warn 'missing: kvm'
	fi
	
	
	# https://blog.matejc.com/blogs/myblog/playing-on-qemu
	# https://www.kraxel.org/repos/jenkins/edk2/
	# https://www.kraxel.org/repos/
	# https://unix.stackexchange.com/questions/52996/how-to-boot-efi-kernel-using-qemu-kvm
	# https://blog.hartwork.org/posts/get-qemu-to-boot-efi/
	# https://www.kraxel.org/repos/jenkins/edk2/
	# https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-20200515.1447.g317d84abe3.noarch.rpm
	if ( [[ "$ubVirtPlatform" == "x64-efi" ]] || [[ "$qemuOStype" == "Win"*"10"* ]] || [[ "$qemuOStype" == "Win"*"11"* ]] ) && [[ "$ub_override_qemu_livecd" == '' ]] && [[ "$ub_override_qemu_livecd_more" == '' ]]
	then
		if [[ -e "$HOME"/core/installations/ovmf/OVMF_CODE-pure-efi.fd ]] && [[ -e "$HOME"/core/installations/ovmf/OVMF_VARS-pure-efi.fd ]]
		then
			qemuArgs+=(-drive if=pflash,format=raw,readonly,file="$HOME"/core/installations/ovmf/OVMF_CODE-pure-efi.fd -drive if=pflash,format=raw,file="$HOME"/core/installations/ovmf/OVMF_VARS-pure-efi.fd)
		elif [[ -e /usr/share/OVMF/OVMF_CODE.fd ]]
		then
			qemuArgs+=(-bios /usr/share/OVMF/OVMF_CODE.fd)
		else
			# Bootloader is not declared as other than legacy bios type.
			# Do nothing by default. Loading an EFI bootloader with CSM module may cause unwanted delay.
			true
		fi
	fi
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_messagePlain_probe _qemu_system_x86_64 "${qemuArgs[@]}"
	_qemu_system_x86_64 "${qemuArgs[@]}"
	
	_safeRMR "$instancedVirtDir" || _stop 1
}

# DANGER: Do NOT call without snapshot on RasPi images intended for real (ie. arm64, "RPI3") hardware! Untested!
# WARNING: NOT recommended. Severely restricted performance and features.
#https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
#https://www.raspberrypi.org/forums/viewtopic.php?t=195565
#https://github.com/dhruvvyas90/qemu-rpi-kernel
#qemu-system-arm -kernel ./kernel-raspi -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda ./vm-raspbian.img -redir tcp:5022::22 -no-reboot
#qemu-system-arm -kernel ./kernel-raspi -cpu arm1176 -m 256 -M versatilepb -dtb versatile-pb.dtb -no-reboot -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -net nic -net user,hostfwd=tcp::5022-:22 -hda ./vm-raspbian.img
#https://raspberrypi.stackexchange.com/questions/45936/has-anyone-managed-to-run-raspberry-pi-3-with-kvm-enabled
#https://wiki.qemu.org/Documentation/Platforms/ARM
#https://github.com/bztsrc/raspi3-tutorial
#https://translatedcode.wordpress.com/2018/04/25/debian-on-qemus-raspberry-pi-3-model/
_integratedQemu_raspi() {
	_messagePlain_nominal 'init: _integratedQemu_raspi'
	
	
	local current_imagefilename
	if ! current_imagefilename=$(_integratedQemu_imagefilename)
	then
		_stop 1
	fi
	
	
	! mkdir -p "$instancedVirtDir" && _messagePlain_bad 'fail: mkdir -p instancedVirtDir= '"$instancedVirtDir" && _stop 1
	
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && _stop 1
	
	! [[ -e "$scriptLocal"/kernel-raspi ]] && _messagePlain_bad 'fail: missing: kernel-raspi' && _messagePlain_probe 'request: obtain kernel-raspi : https://github.com/dhruvvyas90/qemu-rpi-kernel'
	! [[ -e "$scriptLocal"/kernel-raspi ]] && _messagePlain_bad 'fail: missing: versatile-pb.dtb' && _messagePlain_probe 'request: obtain versatile-pb.dtb : https://github.com/dhruvvyas90/qemu-rpi-kernel'
	qemuUserArgs+=(-kernel "$scriptLocal"/kernel-raspi -cpu arm1176 -M versatilepb -dtb "$scriptLocal"/versatile-pb.dtb -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -no-reboot)
	#qemuUserArgs+=(-kernel "$scriptLocal"/kernel-raspi -M raspi3 -append "root=/dev/sda2 rootfstype=ext4 rw" -no-reboot)
	#qemuUserArgs+=(-kernel "$scriptLocal"/kernel-raspi -M virt -bios /usr/share/qemu-efi/QEMU_EFI.fd -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -no-reboot)
	#qemuUserArgs+=(-kernel "$scriptLocal"/kernel-raspi -cpu arm1176 -M virt -bios /usr/share/qemu-efi/QEMU_EFI.fd -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -no-reboot)
	
	#local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l | tr -dc '0-9')
	#[[ "$hostThreadCount" -ge "4" ]] && _messagePlain_probe 'cpu: >4' && qemuArgs+=(-smp 4)
	
	#https://superuser.com/questions/342719/how-to-boot-a-physical-windows-partition-with-qemu
	#qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm-raspbian.img)
	qemuUserArgs+=(-drive format=raw,file="$current_imagefilename")
	
	
	#qemuUserArgs+=(-drive if=none,id=uas-cdrom,media=cdrom,file="$hostToGuestISO" -device nec-usb-xhci,id=xhci -device usb-uas,id=uas,bus=xhci.0 -device scsi-cd,bus=uas.0,scsi-id=0,lun=5,drive=uas-cdrom)
	
	qemuUserArgs+=(-drive file="$hostToGuestISO",media=cdrom -boot c)
	
	#[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	#qemuUserArgs+=(-m "$vmMemoryAllocation")
	qemuUserArgs+=(-m 256)
	
	# ATTENTION: Overload with "ops" or similar.
	[[ "$qemuUserArgs_netRestrict" == "" ]] && qemuUserArgs_netRestrict="n"
	#[[ "$qemuUserArgs_net_guestSSH" == "" ]] && qemuUserArgs_net_guestSSH=",hostfwd=tcp::5022-:22"
	[[ "$qemuUserArgs_net_guestSSH" == "" ]] && qemuUserArgs_net_guestSSH=""
	
	#qemuUserArgs+=(-net nic,model=rtl8139 -net user,restrict="$qemuUserArgs_netRestrict",smb="$sharedHostProjectDir")
	qemuUserArgs+=(-net nic -net user,restrict="$qemuUserArgs_netRestrict""$qemuUserArgs_net_guestSSH",smb="$sharedHostProjectDir")
	
	#qemuArgs+=(-usbdevice tablet)
	
	#qemuArgs+=(-vga cirrus)
	
	#[[ "$qemuArgs_audio" == "" ]] && qemuArgs+=(-device ich9-intel-hda -device hda-duplex)
	
	#qemuArgs+=(-show-cursor)
	
	qemuUserArgs+=(-serial stdio)
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_messagePlain_probe _qemu_system_arm "${qemuArgs[@]}"
	_qemu_system_arm "${qemuArgs[@]}"
	#_messagePlain_probe _qemu_system_aarch64 "${qemuArgs[@]}"
	#_qemu_system_aarch64 "${qemuArgs[@]}"
	
	_safeRMR "$instancedVirtDir" || _stop 1
}

_integratedQemu() {
	# Include platform determination code for correct determination of partition and mounts.
	_loopImage_imagefilename > /dev/null 2>&1
	
	if [[ "$ubVirtPlatform" == "x64-bios" ]]
	then
		_integratedQemu_x64 "$@"
		return "$?"
	fi
	
	if [[ "$ubVirtPlatform" == "x64-efi" ]]
	then
		_integratedQemu_x64 "$@"
		return "$?"
	fi
	
	# TODO: 'efi' .
	#https://unix.stackexchange.com/questions/52996/how-to-boot-efi-kernel-using-qemu-kvm
	
	if [[ "$ubVirtPlatform" == "raspbian" ]]
	then
		_integratedQemu_raspi "$@"
		return "$?"
	fi
	
	#Default x64 .
	if [[ "$ub_keepInstance" == 'true' ]]
	then
		_integratedQemu_x64 "$@"
		return "$?"
	fi
	"$scriptAbsoluteLocation" _integratedQemu_x64 "$@"
	return "$?"
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
	
	if [[ "$ub_keepInstance" == 'true' ]]
	then
		_userQemu_sequence "$@"
		return
	fi
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

# DANGER: Do NOT call without snapshot on RasPi images intended for real (ie. arm64, "RPI3") hardware! Untested!
_editQemu() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if [[ "$ub_keepInstance" == 'true' ]]
	then
		_editQemu_sequence "$@"
		return
	fi
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}

_persistentQemu() {
	_editQemu "$@"
}
