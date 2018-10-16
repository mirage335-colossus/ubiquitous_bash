_testVirtBootdisc() {
	if ! type mkisofs > /dev/null 2>&1 && ! type genisoimage > /dev/null 2>&1
	then
		echo 'need mkisofs or genisoimage'
		_stop 1
	fi
}

_prepareBootdisc() {
	mkdir -p "$hostToGuestFiles" > /dev/null 2>&1 || return 1
	mkdir -p "$hostToGuestDir" > /dev/null 2>&1 || return 1
	return 0
}

_mkisofs() {
	if type mkisofs > /dev/null 2>&1
	then
		mkisofs "$@"
		return $?
	fi
	
	if type genisoimage > /dev/null 2>&1
	then
		genisoimage "$@"
		return $?
	fi
}

_writeBootdisc() {
	_mkisofs -V "$ubiquitiousBashID" -volset "$ubiquitiousBashID" -sysid "$ubiquitiousBashID" -R -uid 0 -gid 0 -dir-mode 0555 -file-mode 0555 -new-dir-mode 0555 -J -hfs -o "$hostToGuestISO" "$hostToGuestFiles"
}

_setShareMSW_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="X:"
}

#No production use. Not recommended.
_setShareMSW_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedHostProjectDir=/
	export sharedGuestProjectDir="Z:"
}

_setShareMSW() {
	[[ "$flagShareApp" ]] && _setShareMSW_app && return
	[[ "$flagShareApp" ]] && _setShareMSW_root && return
	return 1
}

#Consider using explorer.exe to use file associations within the guest. Overload with ops to force a more specific 'preCommand'.
_preCommand_MSW() {
	echo 'X:'
	echo 'cd '"$localPWD"
	echo -e -n 'start /MAX "" "explorer.exe" '
}

_createHTG_MSW() {
	_setShareMSW
	
	export checkBaseDirRemote=""
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	_here_bootdisc_startupbat >> "$hostToGuestFiles"/rootmsw.bat
	
	_preCommand_MSW >> "$hostToGuestFiles"/application.bat
	
	_safeEcho_newline "${processedArgs[@]}" >> "$hostToGuestFiles"/application.bat
	 
	echo ""  >> "$hostToGuestFiles"/application.bat
	
	echo -e -n >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareApp" == "true" ]] && _here_bootdisc_loaderXbat >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareRoot" == "true" ]] && _here_bootdisc_loaderZbat >> "$hostToGuestFiles"/loader.bat
	
	cat "$hostToGuestFiles"/loader.bat >> "$hostToGuestFiles"/uk4uPhB6.bat
	cat "$hostToGuestFiles"/application.bat >> "$hostToGuestFiles"/uk4uPhB6.bat
	
	_here_bootdisc_shellbat >> "$hostToGuestFiles"/shell.bat
	
	#https://www.cyberciti.biz/faq/howto-unix-linux-convert-dos-newlines-cr-lf-unix-text-format/
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/rootmsw.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/application.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/loader.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/shell.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/uk4uPhB6.bat
}

_setShareUNIX_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="/home/user/project"
}

_setShareUNIX_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="/home/user/project"
	export sharedHostProjectDir=/
}

_setShareUNIX() {
	[[ "$flagShareApp" ]] && _setShareUNIX_app && return
	[[ "$flagShareApp" ]] && _setShareUNIX_root && return
	return 1
}

_createHTG_UNIX() {
	_setShareUNIX
	
	export checkBaseDirRemote=""
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	_here_bootdisc_statup_xdg >> "$hostToGuestFiles"/startup.desktop
	
	_here_bootdisc_rootnix >> "$hostToGuestFiles"/rootnix.sh
	
	echo '#!/usr/bin/env bash' >> "$hostToGuestFiles"/cmd.sh
	echo "export localPWD=""$localPWD" >> "$hostToGuestFiles"/cmd.sh
	_safeEcho_newline "/media/bootdisc/ubiquitous_bash.sh _dropBootdisc ${processedArgs[@]}" >> "$hostToGuestFiles"/cmd.sh
}

_commandBootdisc() {
	_prepareBootdisc || return 1
	
	export flagShareRoot="false"
	
	#Rigiorously ensure flags will be set properly.
	[[ "$flagShareRoot" != "true" ]] && export flagShareRoot="false"
	[[ "$flagShareRoot" != "true" ]] && export flagShareApp="true"
	
	#Include ubiquitious_bash itself.
	cp "$scriptAbsoluteLocation" "$hostToGuestFiles"/
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$hostToGuestFiles"/_bin
	
	#Process for MSW.
	_createHTG_MSW "$@"
	
	#Process for UNIX.
	_createHTG_UNIX "$@"
	
	#Ensure permissions are correctly set.
	chmod 0755 "$hostToGuestFiles"/_bin/*
	chmod 0755 "$hostToGuestFiles"/*.sh
	chmod 0755 "$hostToGuestFiles"/*.desktop
	chmod 0755 "$hostToGuestFiles"/*.bat
	#chmod 0755 "$hostToGuestFiles"/*
	
	_writeBootdisc || return 1
}

_dropBootdisc() {
	#Detect MSW/Cygwin architecture.
		#Check for QEMU type shared directory, mount if present.
		#Check for VBox type shared directory, mount if present.
	
	#Detect UNIX architecture.
	if ! uname -a | grep -i cygwin > /dev/null 2>&1
	then
		#Attempt to wait for QEMU or VBox type shared directory.
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.3
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 1
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 3
		
		for iteration in `seq 1 15`;
		do
			! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 6
		done
		
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 9
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 18
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 27
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 36
	fi
	sleep 0.3
	
	cd "$localPWD"
	
	"$@"
}




