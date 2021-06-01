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


# WARNING: Only a small fraction of the tablet area may be mapped regardless of using this command or not - there is no workaround for that here.
# At least 'h1060p' tablet may be affected. Results have been inconsistent - may work on some machines (perhaps single-monitor) but not others (perhaps multimonitor).
# ATTENTION: Connecting tablet to a VM may be a useful workaround.
# ATTENTION: Correct tablet 'Area' may be approximately 50800x31750 ( not 32767x32767 ) .
# KDE Graphics Tablet configuration under 'system settings' is known to work for screen remapping purposes after 'registration' (to whatever extent the tablet area is utilized anyway).
# _tablet_map_primary() {
# 	local currentPrimaryMonitor
# 	currentPrimaryMonitor=$(xrandr --listactivemonitors | cut -f 3 -d\ | grep -v '^\w*$' | grep \* | head -n1 | tr -dc 'a-zA-Z0-9.:_-')
# 	
# 	local currentLine
# 	#xsetwacom --list devices | cut -f1 | while read currentLine
# 	while read currentLine
# 	do
# 		#xsetwacom --set "$currentLine" "MapToOutput" "$currentPrimaryMonitor"
# 		xsetwacom --set "$currentLine" "MapToOutput" 1920x1080+0+0
# 		xsetwacom --set "$currentLine" "Mode" "Absolute"
# 		xsetwacom --set "$currentLine" "Suppress" "0"
# 		xsetwacom --set "$currentLine" "Mode" Absolute
# 		xsetwacom --set "$currentLine" "Area" 0 0 32767 32767
# 	done <<<$(xsetwacom --list devices | cut -f1)
# }





_test_h1060p() {
	sudo -n mkdir -p /etc/X11/xorg.conf.d
	_h1060p_xorg_here | sudo -n tee /etc/X11/xorg.conf.d/70-wacom-h1060p > /dev/null
	
	
	_wantGetDep 'libxcb-xinput.so.0'
	
	_wantGetDep 'kde_wacom_tabletfinder'
	
	
	
	
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
