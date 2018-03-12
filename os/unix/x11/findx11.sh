_test_os_x11() {
	! _wantDep xset && echo 'warn: xset missing, unable to autodetect'
}

#Default. Overridden where remote machine access is needed (ie. _ssh within _vnc) .
#export permit_x11_override=("$scriptAbsoluteLocation" _ssh -C -o ConnectionAttempts=2 "$@")
_permit_x11() {
	if [[ "$permit_x11_override" != "" ]]
	then
		"${permit_x11_override[@]}" "$@"
		return
	fi
	
	"$@"
}

_detect_x11_displays() {
	local current_XAUTH
	[[ "$1" != "" ]] && current_XAUTH="$1"
	
	local current_DISPLAY
	for (( current_DISPLAY = 0 ; current_DISPLAY <= 12 ; current_DISPLAY++ ))
	do
		if _permit_x11 env DISPLAY=:"$current_DISPLAY" XAUTHORITY="$current_XAUTH" xset -q > /dev/null 2>&1
		then
			export destination_AUTH="$current_XAUTH"
			export destination_DISPLAY=":""$current_DISPLAY"
			return 0
		fi
	done
	return 1
}

_detect_x11() {
	
	[[ "$destination_DISPLAY" != "" ]] && return 1
	[[ "$destination_AUTH" != "" ]] && return 1
	
	export destination_DISPLAY
	export destination_AUTH
	
	if _permit_x11 env DISPLAY=$DISPLAY xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY="$DISPLAY"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:0 xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":0"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:1 xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":1"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:10 xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":10"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:11 xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":11"
		return 0
	fi
	
	#export destination_AUTH=""
	#_detect_x11_displays "$destination_AUTH" && return 0
	
	export destination_AUTH="$XAUTHORITY"
	_detect_x11_displays "$destination_AUTH" && return 0
	
	export destination_AUTH="$HOME"/.Xauthority
	[[ -e "$destination_AUTH" ]] && _detect_x11_displays "$destination_AUTH" && return 0
	
	export destination_AUTH=$(ps -eo args -fp $(pgrep Xorg | head -n 1) 2>/dev/null | tail -n+2 | sort | sed 's/.*X.*\-auth\ \(.*\)/\1/' | sed 's/\ \-.*//g')
	[[ -e "$destination_AUTH" ]] && _detect_x11_displays "$destination_AUTH" && return 0
	
	#Unreliable, extra dependencies, last resort.
	local destination_AUTH_x11vnc
	_wantDep x11vnc && export destination_DISPLAY=$(x11vnc -findauth -finddpy | cut -f1 -d\, | cut -f2- -d\=) &&  destination_AUTH_x11vnc=$(x11vnc -display "$destination_DISPLAY" -findauth | cut -f2- -d\=)
	[[ -e "$destination_AUTH_x11vnc" ]] && export destination_AUTH="$destination_AUTH_x11vnc" && return 0
	
	export destination_AUTH=""
	export destination_DISPLAY=":0"
	return 1
}
