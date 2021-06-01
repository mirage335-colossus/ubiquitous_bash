_h1060p_xorg_here() {
	cat << CZXWXcRMTo8EmM8i4d

# https://blog.simos.info/how-to-setup-the-huion-430p-drawing-tablet-on-ubuntu-20-04/
# Huion H430P drawing tablet
# Huion Inspiroy H1060P
# 256c:006d
Section "InputClass"
	#Identifier "Huion H430P drawing tablet"
	Identifier "Huion drawing tablet"
	MatchProduct "HUION"
        MatchUSBID "256c:*"
	MatchDevicePath "/dev/input/event*"
	Driver "wacom"
	# https://github.com/DIGImend/digimend-kernel-drivers
	# /usr/share/X11/xorg.conf.d/50-digimend.conf (digimend-dkms)
	#Option "Suppress" "0"
EndSection

CZXWXcRMTo8EmM8i4d
}









_test_h1060p() {
	sudo -n mkdir -p /etc/X11/xorg.conf.d
	_h1060p_xorg_here | sudo -n tee /etc/X11/xorg.conf.d/70-wacom-h1060p > /dev/null
	
	
	
	_wantGetDep digimend-debug
	
	_wantGetDep 'udev/rules.d/90-digimend.rules'
	
	# '/usr/share'
	#_wantGetDep 'X11/xorg.conf.d/50-digimend.conf'
	
	
	if ! _wantDep digimend-debug
	then
		_messagePlain_request 'request: user please install: digimend-dkms_10 (or newer)'
	fi
	
	return 0
}
