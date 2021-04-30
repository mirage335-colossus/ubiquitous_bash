_vncviewer_operations() {
	_messagePlain_nominal 'init: _vncviewer_operations'
	
	local msw_vncPasswdFile
	msw_vncPasswdFile=$(_slashBackToForward "$vncPasswdFile")
	msw_vncPasswdFile='C:\cygwin64'"$vncPasswdFile"
	
	local current_vncPasswdFile
	current_vncPasswdFile="$vncPasswdFile"
	
	[[ "$override_cygwin_vncviewer" == 'true' ]] && type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 && current_vncPasswdFile="$msw_vncPasswdFile"
	[[ "$override_cygwin_vncviewer" == 'true' ]] && type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 && current_vncPasswdFile="$msw_vncPasswdFile"
	
	
	#Typically set in '~/.bashrc' for *unusual* machines which have problems using vncviewer under X11.
	#https://steamcommunity.com/app/382110/discussions/0/1741101364304281184/
	if [[ "$vncviewer_manual" == 'true' ]]
	then
		_messagePlain_good 'assume: vncviewer (TigerVNC)'
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		mkdir -p "$HOME"/usrcmd
		
		local usrcmdUID
		usrcmdUID=$(_uid)
		
		_safeEcho_newline 'vncviewer -DotWhenNoCursor -passwd '\""$current_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"
		_safeEcho_newline 'vncviewer -DotWhenNoCursor -passwd '\""$current_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID".sh
		chmod u+x "$HOME"/usrcmd/"$usrcmdUID".sh
		
		if type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
		then
			_safeEcho_newline '"C:\Program Files\TigerVNC\vncviewer.exe"'' -DotWhenNoCursor -passwd '\""$msw_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"_x64.bat
			chmod u+x "$HOME"/usrcmd/"$usrcmdUID"_x64.bat
		fi
		
		if type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
		then
			_safeEcho_newline '"C:\Program Files (x86)\TigerVNC\vncviewer.exe"'' -DotWhenNoCursor -passwd '\""$msw_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"_x86.bat
			chmod u+x "$HOME"/usrcmd/"$usrcmdUID"_x86.bat
		fi
		
		_messagePlain_request 'request: manual launch: vncviewer: time 120s: directives:' "$HOME"/usrcmd/"$usrcmdUID"
		
		_messagePlain_nominal 'wait...'
		
		# WARNING: Relies on VNC server replying "RFB" to TCP connections.
		#while _checkPort localhost "$vncPort"
		while echo -n | sleep 13 | _timeout 6 socat - TCP:localhost:"$vncPort",connect-timeout="$netTimeout" 2> /dev/null | grep RFB >/dev/null 2>&1
		do
			sleep 6
		done
		sleep 3
		
		rm -f "$HOME"/usrcmd/"$usrcmdUID" > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID".sh > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID"_x86.bat > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID"_x64.bat > /dev/null 2>&1
		
		return 0
	fi
	
	_messagePlain_nominal 'Detecting and launching vncviewer.'
	
	#Cygwin, Overriden to Native TigerVNC
	if [[ "$override_cygwin_vncviewer" == 'true' ]] && ( ( type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 ) || ( type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 ) )
	then
		_messagePlain_good 'found: vncviewer (MSW)'
		
		_messagePlain_good 'assume: vncviewer (TigerVNC)'
		
		_messagePlain_probe '_vncviewer_operations'
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		# ATTENTION: Uncomment to log debug output from MSW vncviewer.
		
		#_messagePlain_probe  -----
		#_messagePlain_probe '"${vncviewerArgs[@]}"'
		#_safeEcho "${vncviewerArgs[@]}"
		#_messagePlain_probe -----
		#_messagePlain_probe '"$@"'
		#_safeEcho "$@"
		#_messagePlain_probe -----
		
		#tmux new-window bash -c '"/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe" -DotWhenNoCursor -passwd "'$current_vncPasswdFile'" localhost:"'$vncPort'" > ~/.sshtmp/vncerr 2>&1'
		
		if ! vncviewer -DotWhenNoCursor -passwd "$current_vncPasswdFile" localhost:"$vncPort" "${vncviewerArgs[@]}" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		
		# WARNING: Relies on VNC server replying "RFB" to TCP connections.
		#while _checkPort localhost "$vncPort"
		while echo -n | sleep 13 | _timeout 6 socat - TCP:localhost:"$vncPort",connect-timeout="$netTimeout" 2> /dev/null | grep RFB >/dev/null 2>&1
		do
			sleep 6
		done
		sleep 3
		
		
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_report_detect_x11
	
	_messagePlain_nominal 'Detecting and launching vncviewer.'
	
	#TigerVNC
	if vncviewer --help 2>&1 | grep 'PasswordFile   \- Password file for VNC authentication (default\=)' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncviewer (TigerVNC)'
		
		_messagePlain_probe '_vncviewer_operations'
		_report_detect_x11
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		if ! vncviewer -DotWhenNoCursor -passwd "$current_vncPasswdFile" localhost:"$vncPort" "${vncviewerArgs[@]}" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	#TightVNC
	if vncviewer --help 2>&1 | grep '\-passwd' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncviewer (TightVNC)'
		
		_messagePlain_probe '_vncviewer_operations'
		_report_detect_x11
		
		#if ! vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
		if ! vncviewer -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	type vncviewer > /dev/null 2>&1 && _messagePlain_bad 'unsupported: vncviewer'
	! type vncviewer > /dev/null 2>&1 && _messagePlain_bad 'missing: vncviewer'
	
	return 1
}
