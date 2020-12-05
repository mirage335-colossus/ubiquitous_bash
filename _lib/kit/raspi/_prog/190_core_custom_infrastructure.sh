_mountChRoot_image_raspbian_prog() {
	true
	
	local current_imagedev
	current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	mkdir -p "$globalVirtFS"/../boot
	sudo -n mount "$current_imagedev"p1 "$globalVirtFS"/../boot
	
	return 0
}

# Technically superflous, as this functionality is already safeguarded within "_umountChRoot_image" .
_umountChRoot_image_prog() {
	[[ -d "$globalVirtFS"/../boot ]] && mountpoint "$globalVirtFS"/../boot >/dev/null 2>&1 && sudo -n umount "$globalVirtFS"/../boot >/dev/null 2>&1
	
	return 0
}

# ATTENTION: Disable and replace if necessary.
_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_custom
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openChRoot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_chroot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openLoop
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeLoop
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_gparted
	
	
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeVBoxRaw
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userVBox
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_editVBox
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userVBoxLive
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_editVBoxLive
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userQemu
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_editQemu
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userQemuLive
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_editQemuLive
	
	
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_export
	
	
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_live
}


