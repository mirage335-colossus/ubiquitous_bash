_testVirtBootdisc() {
	if ! type mkisofs > /dev/null 2>&1 && ! type genisoimage > /dev/null 2>&1
	then
		echo 'need mkisofs or genisoimage'
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
	_mkisofs -R -uid 0 -gid 0 -dir-mode 0555 -file-mode 0555 -new-dir-mode 0555 -J -hfs -o "$hostToGuestISO" "$hostToGuestFiles"
}

_setShareMSW_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="X:"
}

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
	echo -e -n 'start /MAX "explorer.exe" '
}

_createHTG_MSW() {
	_setShareMSW
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	
	
	_preCommand_MSW > "$hostToGuestFiles"/application.bat
	
	echo "${processedArgs[@]}" >> "$hostToGuestFiles"/application.bat
	 
	echo ""  >> "$hostToGuestFiles"/application.bat
	
	echo -e -n > "$hostToGuestFiles"/loader.bat
	[[ "$flagShareApp" == "true" ]] && _here_bootdisc_loaderXbat >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareRoot" == "true" ]] && _here_bootdisc_loaderZbat >> "$hostToGuestFiles"/loader.bat
	
	_here_bootdisc_shellbat > "$hostToGuestFiles"/shell.bat
	
	#https://www.cyberciti.biz/faq/howto-unix-linux-convert-dos-newlines-cr-lf-unix-text-format/
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/application.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/loader.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/shell.bat
}

_setShareUNIX_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
}

_setShareUNIX_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedHostProjectDir=/
}

_setShareUNIX() {
	[[ "$flagShareApp" ]] && _setShareUNIX_app && return
	[[ "$flagShareApp" ]] && _setShareUNIX_root && return
	return 1
}

_createHTG_UNIX() {
	_setShareUNIX
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	echo "${processedArgs[@]}" > "$hostToGuestFiles"/cmd.sh
	
	cp "$scriptAbsoluteLocation" "$hostToGuestFiles"/
}

_commandBootdisc() {
	_prepareBootdisc || return 1
	
	export flagShareRoot="false"
	
	#Rigiorously ensure flags will be set properly.
	[[ "$flagShareRoot" != "true" ]] && export flagShareRoot="false"
	[[ "$flagShareRoot" != "true" ]] && export flagShareApp="true"
	
	#Process for MSW.
	_createHTG_MSW "$@"
	
	#Process for UNIX.
	_createHTG_UNIX "$@"
	
	_writeBootdisc || return 1
}
