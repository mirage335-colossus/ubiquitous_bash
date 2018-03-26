_test_x220() {
	_getDep xlock
	
	_getDep xsetwacom
}

_prepare_x220() {
	export ub_hardware_x220_dir="$HOME"/.ubcore/hardware
	mkdir -p "$ub_hardware_x220_dir"
}

_x220_getTrackpoint() {
	export xi_devID=$(xinput list | grep 'TPPS/2 IBM TrackPoint' | cut -d= -f 2 | cut -f 1)
	export xi_state=$(xinput -list-props $xi_devID | grep -i 'Device Enabled' | cut -d\) -f2 | sed 's/[^0-9]//g')
	export xi_propNumber=$(xinput -list-props $xi_devID | grep -i 'Device Enabled' | cut -d\( -f2 | cut -d\) -f1 | sed 's/[^0-9]//g')
}

_x220_setTrackPoint() {
	_x220_getTrackpoint
	_report_xi

	xinput -set-prop $xi_devID $xi_propNumber "$@"
}

_x220_enableTrackPoint() {
	_messagePlain_nominal "Enabling TrackPoint."
	_setTrackPoint 1
}

_x220_disableTrackPoint() {
	_messagePlain_nominal "Disabling TrackPoint."
	_setTrackPoint 0
}

_x220_getTouch() {
	export xi_devID=$(xinput list | grep 'Wacom ISDv4 E6 Finger touch' | cut -d= -f 2 | cut -f 1)
	export xi_state=$(xinput -list-props $devID | grep -i 'Device Enabled' | cut -d\) -f2 | sed 's/[^0-9]//g')
	export xi_propNumber=$(xinput -list-props $devID | grep -i 'Device Enabled' | cut -d\( -f2 | cut -d\) -f1 | sed 's/[^0-9]//g')
}

_x220_setTouch() {
	_x220_getTouch
	_report_xi
	
	xinput -set-prop $xi_devID $xi_propNumber "$@"
}

_x220_enableTouch() {
	_messagePlain_nominal "Enabling Touch."
	
	#On enable, momentarily block input events. Otherwise, all touch previous touch events will be processed.
	xlock -mode flag -message "Enabling touch..." &
	sleep 2
	
	_x220_setTouch 1
	
	sleep 2
	kill -KILL $!
}

_x220_disableTouch() {
	_messagePlain_nominal "Disabling Touch."
	_x220_setTouch 0
}

_x220_toggleTouch() {
	_messagePlain_nominal "Togling Touch."
	
	_x220_getTouch
	_report_xi
	
	if [[ "$xi_state" == "1" ]]
	then
		_x220_disableTouch
	else
		_x220_enableTouch
	fi
}

#Workaround. Display configuration changes may inappropriately remap pen/eraser/touch input off matching internal screen.
_x220_wacomLVDS() {
	xsetwacom --set 'Wacom ISDv4 E6 Pen stylus'  "MapToOutput" LVDS1
	xsetwacom --set 'Wacom ISDv4 E6 Pen eraser'  "MapToOutput" LVDS1
	xsetwacom --set 'Wacom ISDv4 E6 Finger touch'  "MapToOutput" LVDS1
}

_x220_setWacomRotation() {
	wacomLVDS
	
	xsetwacom --set 'Wacom ISDv4 E6 Pen stylus' rotate $1
	xsetwacom --set 'Wacom ISDv4 E6 Pen eraser' rotate $1
	xsetwacom --set 'Wacom ISDv4 E6 Finger touch' rotate $1
}

_x220_tablet_N000() {
	_messagePlain_nominal "Tablet - N000"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate normal
	_x220_setWacomRotation none
	echo "N000" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_enableTouch
	_x220_enableTrackPoint
}

_x220_tablet_E090() {
	_messagePlain_nominal "Tablet - E090"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate right
	_x220_setWacomRotation cw
	echo "E090" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_disableTouch
	_x220_disableTrackPoint
}

_x220_tablet_S180() {
	_messagePlain_nominal "Tablet - S180"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate inverted
	_x220_setWacomRotation half
	echo "S180" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_enableTouch
	_x220_disableTrackPoint
}

#Flip through tablet rotations. Recommend binding to key or quicklaunch.
_x220_tablet_flip() {
	if [[ ! -f "$ub_hardware_x220_dir"/screenRotationState ]]
	then
		echo 'S180' > "$ub_hardware_x220_dir"/screenRotationState
	fi
	
	local currentState
	currentState=$(cat "$ub_hardware_x220_dir"/screenRotationState)
	
	case "$currentState" in
		S180|N00)
		_x220_tablet_E090
		;;
		E090)
		_x220_tablet_S180
		;;
	esac
	
	_reset_KDE
}


_x220_vgaSmall() {
	xrandr --addmode VGA1 1366x768
	xrandr --output VGA1 --same-as LVDS1 --mode 1366x768
	xrandr --output LVDS1 --primary --auto
	
	xrandr --addmode VGA1 1366x768
	xrandr --output VGA1 --same-as LVDS1 --mode 1366x768
	xrandr --output LVDS1 --primary --auto
	
	_x220_tablet_N000
}

#Most commonly used mode. Recommend binding to key or quicklaunch.
_x220_vgaRightOf() {
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	_x220_tablet_N000
}

_x220_vgaTablet() {
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	_x220_tablet_S180
}
