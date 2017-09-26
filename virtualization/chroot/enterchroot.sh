
_openChRoot() {
	_start
	
	_mustGetSudo
	
	
	
	
	echo "OPEN CHROOT" > "$scriptAbsoluteLocation"/WARNING
	
	
	
	
	
	
	_stop
}


_closeChRoot() {
	_start
	
	_mustGetSudo
	
	echo > "$scriptAbsoluteLocation"/_closing
	
	
	
	
	
	
	
	
	rm "$scriptAbsoluteLocation"/_closing
	
	# TODO Might be wise to first sanity check all directories unmounted, all processes terminated, etc.
	rm "$scriptAbsoluteLocation"/WARNING
	
	_stop
}


_chrootRasPi() {
	#mount image with losetup
	
	#mount correct partition root/boot filesystems
	
	#effectively disable /etc/ld.so.preload
	
	
	true
	#chroot
	
	#enable default /etc/ld.so.preload
} 
