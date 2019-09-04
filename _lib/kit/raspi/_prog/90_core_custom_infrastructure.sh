_mountChRoot_image_raspbian_prog() {
	mkdir -p "$globalVirtFS"/../boot
	
	sudo -n mount "$1"p1 "$globalVirtFS"/../boot
	
	return 0
}

# Technically superflous, as this functionality is already safeguarded within "_umountChRoot_image" .
_umountChRoot_image_prog() {
	sudo -n umount "$globalVirtFS"/../boot
	
	return 0
}

_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_custom
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openChRoot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_chroot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openLoop
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeLoop
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_gparted
} 
