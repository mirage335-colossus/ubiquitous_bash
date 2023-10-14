
# Suggest 'scale 1.5' as a workaround for driving large screens at 1080p@60Hz instead of 4k@60Hz due to legacy graphics ports.
_xscale() {
	xrandr --output "$1" --scale "$2"x"$2"
	
	_reset_KDE
	
	arandr
}

_test_xscale() {
	_wantGetDep xrandr
	_wantGetDep arandr
}


