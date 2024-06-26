
_w540_check() {
	if ! grep 'ThinkPad W540' /sys/devices/virtual/dmi/id/product_family > /dev/null 2>&1 && ! grep 'ThinkPad W540' /sys/devices/virtual/dmi/id/product_version > /dev/null 2>&1
	then
		return 1
	fi
	return 0
}

# ATTENTION: Override with 'ops.sh' if necessary.
# WARNING: Disable Kscreen background service recommended. Use KDE "System Settings" .
_w540_display_start() {
	! _w540_check && return 1
	
	
	
	local currentIteration
	currentIteration=0
	while ! pgrep plasmashell > /dev/null 2>&1 && [[ "$currentIteration" -lt "15" ]]
	do
		sleep 3
		let currentIteration=currentIteration+1
	done
	sleep 7
	#sleep 30
	mountpoint /run/live/overlay > /dev/null 2>&1 && sleep 45
	
	_w540_display-leftOf "$@" &
	
	#_w540_display-rightOf "$@" &
	
	disown -h $!
	disown
	disown -a -h -r
	disown -a -r
}

# ATTENTION: May rely on some assumptions about the software configuration of the laptop, and may be very specific to only W540 .
_w540_display-leftOf() {
	! _w540_check && return 1
	
	
	
	xrandr --output eDP-1 --mode 1920x1080
	
	xrandr --output HDMI-1 --scale 1.375x1.375
	
	
	# Workaround . Notice the '406' instaed of '405' . Causes KDE to recognize display (re)configuration, keeping the built-in screen usable.
	#xrandr --output eDP-1 --mode 1920x1080 --pos 2640x406 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	#xrandr --output eDP-1 --mode 1920x1080 --pos 2640x405 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	
	xrandr --output eDP-1 --mode 1920x1080 --pos 2640x1 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	xrandr --output eDP-1 --mode 1920x1080 --pos 2640x0 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	
	# WARNING: May not play nice with startup .
	#sleep 7
	#_reset_KDE
}












 
