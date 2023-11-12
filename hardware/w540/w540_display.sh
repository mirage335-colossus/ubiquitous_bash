
# ATTENTION: Override with 'ops.sh' if necessary.
_w540_display_start() {
	_w540_display_start
}



# ATTENTION: Override with 'ops.sh' if necessary.
_w540_display_start() {
	local currentIteration
	currentIteration=0
	while ! pgrep plasmashell > /dev/null 2>&1 && [[ "$currentIteration" -lt "15" ]]
	do
		sleep 3
		let currentIteration=currentIteration+1
	done
	sleep 45
	
	_w540_display-leftOf "$@" &
	
	#_w540_display-rightOf "$@" &
	
	disown -h $!
	disown
	disown -a -h -r
	disown -a -r
}

_w540_display-leftOf() {
	xrandr --output HDMI-1 --scale 1.375x1.375
	
	# Workaround . Notice the '406' instaed of '405' . Causes KDE to recognize display (re)configuration, keeping the built-in screen usable.
	xrandr --output eDP-1 --mode 1920x1080 --pos 2640x406 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	xrandr --output eDP-1 --mode 1920x1080 --pos 2640x405 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off
	
	sleep 7
	_reset_KDE
}












 
