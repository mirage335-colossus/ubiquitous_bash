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

_detect_x11() {
	[[ "$destination_DISPLAY" != "" ]] && return 0
	
	if _permit_x11 env DISPLAY=$DISPLAY xset -q
	then
		export destination_DISPLAY="$DISPLAY"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:0 xset -q
	then
		export destination_DISPLAY=":0"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:1 xset -q
	then
		export destination_DISPLAY=":1"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:10 xset -q
	then
		export destination_DISPLAY=":10"
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:11 xset -q
	then
		export destination_DISPLAY=":11"
		return 0
	fi
	
	local current_DISPLAY
	for (( current_DISPLAY = 0 ; current_DISPLAY <= 12 ; current_DISPLAY++ ))
	do
		if _permit_x11 env DISPLAY=:$current_DISPLAY xset -q
		then
			export destination_DISPLAY=":""$current_DISPLAY"
			return 0
		fi
	done
	
	export destination_DISPLAY=":0"
	return 1
}
