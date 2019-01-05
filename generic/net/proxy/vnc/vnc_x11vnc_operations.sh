# Environment variables "x11vnc_clip" and "x11vnc_scale" may be forced.
_x11vnc_operations() {
	_messagePlain_nominal 'init: _x11vnc_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_bad 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe 'x11vnc_operations'
	_report_detect_x11
	
	#local x11vncArgs
	
	[[ "$x11vnc_clip" != "" ]] && x11vncArgs+=(-clip "$x11vnc_clip")
	[[ "$x11vnc_scale" != "" ]] && x11vncArgs+=(-scale "$x11vnc_scale")
	[[ "$x11vnc_scale_cursor" != "" ]] && x11vncArgs+=(-cursor arrow -scale_cursor "$x11vnc_scale_cursor")
	
	_messagePlain_nominal 'Detecting and launching x11vnc.'
	#x11vnc
	if type x11vnc >/dev/null 2>&1
	then
		_messagePlain_good 'found: x11vnc'
		
		#-passwdfile cmd:"/bin/cat -"
		#-noxrecord -noxfixes -noxdamage
		if ! _x11vnc_command  -no6 -noipv6 -localhost -rfbportv6 -1 -rfbauth "$vncPasswdFile" -rfbport "$vncPort" -timeout 120 -xkb -display "$destination_DISPLAY" -auth "$destination_AUTH" -noxrecord -noxdamage -xrefresh 1 -fixscreen "V=3,C=3,X=3,8=3" -ungrabboth "${x11vncArgs[@]}"
		then
			_messagePlain_bad 'fail: x11vnc'
			return 1
		fi
		
		return 0
	fi
	
	#TigerVNC.
	if type x0tigervncserver
	then
		_messagePlain_good 'found: x0tigervncserver'
		
		if ! x0tigervncserver -rfbauth "$vncPasswdFile" -rfbport "$vncPort"
		then
			_messagePlain_bad 'fail: x0tigervncserver'
			return 1
		fi
		return 0
	fi
	
	_messagePlain_bad 'missing: x11vnc || x0tigervncserver'
	
	return 1
}
