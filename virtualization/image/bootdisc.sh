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
	export flagShareApp="true"
	
	export sharedGuestProjectDir="X:"
}

_setShareMSW_root() {
	export flagShareRoot="true"
	
	export sharedGuestProjectDir="Z:"
	
	export sharedHostProjectDir=/
}

_setShareMSW() {
	export flagShareApp="false"
	export flagShareRoot="false"
	
	#_setShareMSW_root
	_setShareMSW_app
}

_createHTG_MSW() {
	_setShareMSW
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	
	#Consider using explorer.exe to use file associations within the guest. Overload with ops to force a more specific 'preCommand'.
	echo -e -n 'start ' > "$hostToGuestFiles"/application.bat
	
	echo "${processedArgs[@]}" >> "$hostToGuestFiles"/application.bat
	 
	echo ""  >> "$hostToGuestFiles"/application.bat
	
	echo -e -n > "$hostToGuestFiles"/loader.bat
	[[ "$flagShareApp" == "true" ]] && _here_bootdisc_loaderXbat >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareRoot" == "true" ]] && _here_bootdisc_loaderZbat >> "$hostToGuestFiles"/loader.bat
	
	_here_bootdisc_shellbat > "$hostToGuestFiles"/shell.bat
}

_commandBootdisc() {
	# TODO Optional/overloadable UNIX processor.
	
	
	#Process for MSW.
	_createHTG_MSW "$@"
	
	
	_writeBootdisc || return 1
}
