_test_fakehome() {
	_getDep mount
	_getDep mountpoint
	
	_getDep rsync
	
	_wantGetDep dbus-run-session
}

#Example. Run similar code under "core.sh" before calling "_fakeHome", "_install_fakeHome", or similar, to set a specific type/location for fakeHome environment - global, instanced, or otherwise.
_arbitrary_fakeHome_app() {
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$shortFakeHome"
	
	#export actualFakeHome="$globalFakeHome"
	#export actualFakeHome=""$arbitraryFakeHome"/arbitrary"
}

#"$1" == lib source path (eg. "$scriptLib"/app/.app)
#"$2" == home destination path (eg. ".app")
# WARNING: Locking mechanism not intended to be relied on.
# WARNING: Return status success may not reflect successful link/copy.
_link_fakeHome() {
	mkdir -p "$1" > /dev/null 2>&1
	mkdir -p "$actualFakeHome" > /dev/null 2>&1
	mkdir -p "$globalFakeHome" > /dev/null 2>&1
	
	#If globalFakeHome symlinks are obsolete, subsequent _instance_internal operation may overwrite valid links with them. See _install_fakeHome .
	rmdir "$globalFakeHome"/"$2" > /dev/null 2>&1
	_relink "$1" "$globalFakeHome"/"$2"
	
	if [[ "$actualFakeHome" == "$globalFakeHome" ]] || [[ "$fakeHomeEditLib" == "true" ]]
	then
		rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
		_relink "$1" "$actualFakeHome"/"$2"
		return 0
	fi
	
	#Actual files/directories will not be overwritten by symlinks when "$globalFakeHome" is copied to "$actualFakeHome". Remainder of this function dedicated to creating copies, before and instead of, symlinks.
	
	#rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
	_rmlink "$actualFakeHome"/"$2"
	
	#Waits if copy is in progress, delaying program launch.
	local lockWaitTimer
	for (( lockWaitTimer = 0 ; lockWaitTimer <= 90 ; lockWaitTimer++ )); do
		! [[ -e "$actualFakeHome"/"$2".lck ]] && break
		sleep 0.3
	done
	
	#Checks if copy has already been made.
	[[ -e "$actualFakeHome"/"$2" ]] && return 0
	
	mkdir -p "$actualFakeHome"/"$2"
	
	#Copy file.
	if ! [[ -d "$1" ]] && [[ -e "$1" ]]
	then
		rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
		
		echo > "$actualFakeHome"/"$2".lck
		cp "$1" "$actualFakeHome"/"$2"
		rm "$actualFakeHome"/"$2".lck
		return 0
	fi
	
	#Copy directory.
	echo > "$actualFakeHome"/"$2".lck
	_instance_internal "$1"/. "$actualFakeHome"/"$2"/
	rm "$actualFakeHome"/"$2".lck
	return 0
}

#Example. Override with "core.sh". Allows specific application configuration directories to reside outside of globalFakeHome, for organization, testing, and distribution.
_install_fakeHome_app() {
	#_link_fakeHome "$scriptLib"/app/.app ".app"
	
	true
}

#actualFakeHome
_install_fakeHome() {
	_install_fakeHome_app
	
	#Asterisk used where multiple global home folders are needed, following convention "$scriptLocal"/h_* . Used by webClient for _firefox_esr .
	[[ "$actualFakeHome" == "$globalFakeHome"* ]] && return 0
	
	#Any globalFakeHome links created by "_link_fakeHome" are not to overwrite copies made to instancedFakeHome directories. Related errors emitted by "rsync" are normal, and therefore, silenced.
	_instance_internal "$globalFakeHome"/. "$actualFakeHome"/ > /dev/null 2>&1
}

#Run before _fakeHome to use a ramdisk as home directory. Wrap within "_wantSudo" and ">/dev/null 2>&1" to use optionally. Especially helpful to limit SSD wear when dealing with moderately large (ie. ~2GB) fakeHome environments which must be instanced.
_mountRAM_fakeHome() {
	_mustGetSudo
	mkdir -p "$actualFakeHome"
	sudo -n mount -t ramfs ramfs "$actualFakeHome"
	sudo -n chown "$USER":"$USER" "$actualFakeHome"
	! mountpoint "$actualFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_umountRAM_fakeHome() {
	mkdir -p "$actualFakeHome"
	sudo -n umount "$actualFakeHome"
	mountpoint "$actualFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_begin_fakeHome() {
	# WARNING: Recursive fakeHome prohibited. Instead, start new script session, with new sessionid, and keepFakeHome=false. Do not workaround without a clear understanding why this may endanger your application.
	_resetFakeHomeEnv
	[[ "$setFakeHome" == "true" ]] && return 1
	#_resetFakeHomeEnv_nokeep
	
	[[ "$realHome" == "" ]] && export realHome="$HOME"
	
	export HOME="$actualFakeHome"
	export setFakeHome=true
	
	_prepareFakeHome > /dev/null 2>&1
	
	_install_fakeHome
	
	_makeFakeHome "$realHome" "$actualFakeHome"
	
	export fakeHomeEditLib="false"
	
	export realScriptAbsoluteLocation="$scriptAbsoluteLocation"
	export realScriptAbsoluteFolder="$scriptAbsoluteFolder"
	export realSessionID="$sessionid"
}

#actualFakeHome
	#default: "$instancedFakeHome"
	#"$globalFakeHome" || "$instancedFakeHome" || "$shortFakeHome" || "$arbitraryFakeHome"/arbitrary
#keepFakeHome
	#default: true
	#"true" || "false"
# ATTENTION: WARNING: Do not remove or modify functionality of GUI workarounds without extensive testing!
_fakeHome() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	# WARNING: Obviously less reliable than directly stating variable assignments.
	local fakeHomeENVvars
	
	fakeHomeENVvars+=(DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP="$XDG_SESSION_DESKTOP" XDG_CURRENT_DESKTOP="$XDG_SESSION_DESKTOP")
	fakeHomeENVvars+=(realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome")
	fakeHomeENVvars+=(TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}")
	[[ "$ub_fakeHome_dropPWD" != 'true' ]] && fakeHomeENVvars+=(PWD="$PWD")
	fakeHomeENVvars+=(_JAVA_OPTIONS="${_JAVA_OPTIONS}")
	fakeHomeENVvars+=(scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder")
	fakeHomeENVvars+=(sessionid="$sessionid" realSessionID="$realSessionID" )
	
	fakeHomeENVvars+=(LD_PRELOAD="$LD_PRELOAD")
	
	# https://github.com/prusa3d/PrusaSlicer/issues/3969
	fakeHomeENVvars+=(USER="$USER")
	
	
	[[ "$TMPDIR" != "" ]] && fakeHomeENVvars+=(TMPDIR="$TMPDIR")
	#fakeHomeENVvars+=( SSH_AUTH_SOCK="$SSH_AUTH_SOCK" SSH_AGENT_PID="$SSH_AGENT_PID" GPG_AGENT_INFO="$GPG_AGENT_INFO" )
	fakeHomeENVvars+=(SESSION_MANAGER="$SESSION_MANAGER" WINDOWID="$WINDOWID" QT_ACCESSIBILITY="$QT_ACCESSIBILITY" COLORTERM="$COLORTERM" XDG_SESSION_PATH="$XDG_SESSION_PATH" LANGUAGE="$LANGUAGE"  SHELL_SESSION_ID="$SHELL_SESSION_ID" DESKTOP_SESSION="$DESKTOP_SESSION" XCURSOR_SIZE="$XCURSOR_SIZE" GTK_MODULES="$GTK_MODULES" XDG_SEAT="$XDG_SEAT" XDG_SESSION_DESKTOP="$XDG_SESSION_DESKTOP" XDG_SESSION_TYPE="$XDG_SESSION_TYPE" XDG_CURRENT_DESKTOP="$XDG_CURRENT_DESKTOP" KONSOLE_DBUS_SERVICE="$KONSOLE_DBUS_SERVICE" PYTHONSTARTUP="$PYTHONSTARTUP" KONSOLE_DBUS_SESSION="$KONSOLE_DBUS_SESSION" PROFILEHOME="$PROFILEHOME" XDG_SEAT_PATH="$XDG_SEAT_PATH" KDE_SESSION_UID="$KDE_SESSION_UID" XDG_SESSION_CLASS="$XDG_SESSION_CLASS" COLORFGBG="$COLORFGBG" KDE_SESSION_VERSION="$KDE_SESSION_VERSION" SHLVL="$SHLVL" LC_MEASUREMENT="$LC_MEASUREMENT" XDG_VTNR="$XDG_VTNR" XDG_SESSION_ID="$XDG_SESSION_ID" GS_LIB="$GS_LIB" XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" LC_TIME="$LC_TIME" QT_AUTO_SCREEN_SCALE_FACTOR="$QT_AUTO_SCREEN_SCALE_FACTOR" XCURSOR_THEME="$XCURSOR_THEME" KDE_FULL_SESSION="$KDE_FULL_SESSION" KONSOLE_PROFILE_NAME="$KONSOLE_PROFILE_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" KONSOLE_DBUS_WINDOW="$KONSOLE_DBUS_WINDOW" LS_COLORS="$LS_COLORS")
	
	fakeHomeENVvars+=(QT_QPA_PLATFORMTHEME="$QT_QPA_PLATFORMTHEME")

	[[ "$devfast" != "" ]] && fakeHomeENVvars+=(devfast="$devfast")
	
	
	if type dbus-run-session > /dev/null 2>&1 && [[ "$fakeHome_dbusRunSession_DISABLE" != "true" ]]
	then
		fakeHomeENVvars+=(dbus-run-session)
	fi
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" sessionid="$sessionid" scriptAbsoluteFolder="$scriptAbsoluteFolder" realSessionID="$realSessionID" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	##env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
	##dbus-run-session "$@"
	##"$@"
	##. "$@"
	#env -i "${fakeHomeENVvars[@]}" "$@"
	#fakeHomeExitStatus=$?
	
	
	
	if [[ "$appImageExecutable" == "" ]]
	then
		[[ "$1" == *'.APPIMAGE' ]] && export appImageExecutable="$1"
		[[ "$1" == *'.appimage' ]] && export appImageExecutable="$1"
		[[ "$1" == *'.AppImage' ]] && export appImageExecutable="$1"
	fi
	if [[ "$appImageExecutable" != "" ]]
	then
		#mkdir -p "$appImageExecutable".home
		#mkdir -p "$appImageExecutable".config
		#"$appImageExecutable" --appimage-portable-home > /dev/null 2>&1
		#"$appImageExecutable" --appimage-portable-config > /dev/null 2>&1
		
		export appImageExecutable_basename=$(basename "$appImageExecutable")
		export appImageExecutable_actualFakeHome="$actualFakeHome"/"$appImageExecutable_basename"
		
		chmod u+rx "$appImageExecutable"
		
		#cp -r -L --preserve=all "$appImageExecutable" "$actualFakeHome"/
		rsync -rLptgoD "$appImageExecutable" "$actualFakeHome"/
		
		chmod u+rx "$appImageExecutable_actualFakeHome"
		
		if [[ ! -d "$appImageExecutable_actualFakeHome".home ]] || [[ ! -d "$appImageExecutable_actualFakeHome".config ]]
		then
			mkdir -p "$appImageExecutable_actualFakeHome".home
			mkdir -p "$appImageExecutable_actualFakeHome".config
			"$appImageExecutable_actualFakeHome" --appimage-portable-home > /dev/null 2>&1
			"$appImageExecutable_actualFakeHome" --appimage-portable-config > /dev/null 2>&1
		fi
		
		
		shift
		
		#_fakeHome "$appImageExecutable_actualFakeHome" "$@"
		
		if [[ "$1" != '--norunFakeHome' ]]
		then
			env -i "${fakeHomeENVvars[@]}" "$appImageExecutable_actualFakeHome" "$@"
			fakeHomeExitStatus=$?
		else
			fakeHomeExitStatus='0'
		fi
	elif false
	then
		true
	else
		env -i "${fakeHomeENVvars[@]}" "$@"
		fakeHomeExitStatus=$?
	fi
	
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

#Do NOT keep parent session under fakeHome environment. Do NOT regain parent session if "~/.ubcore/.ubcorerc" is imported (typically upon shell launch).
# ATTENTION: WARNING: Do not remove or modify functionality of GUI workarounds without extensive testing!
_fakeHome_specific() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	# WARNING: Obviously less reliable than directly stating variable assignments.
	local fakeHomeENVvars
	
	fakeHomeENVvars+=(DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP="$XDG_SESSION_DESKTOP" XDG_CURRENT_DESKTOP="$XDG_SESSION_DESKTOP")
	fakeHomeENVvars+=(realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome")
	fakeHomeENVvars+=(TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}")
	[[ "$ub_fakeHome_dropPWD" != 'true' ]] && fakeHomeENVvars+=(PWD="$PWD")
	fakeHomeENVvars+=(_JAVA_OPTIONS="${_JAVA_OPTIONS}")
	#fakeHomeENVvars+=(scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder"realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder")
	#fakeHomeENVvars+=(sessionid="$sessionid" realSessionID="$realSessionID" )
	
	if type dbus-run-session > /dev/null 2>&1
	then
		fakeHomeENVvars+=(dbus-run-session)
	fi
	
	##env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}dbus-run-session "$@"
	##dbus-run-session "$@"
	##"$@"
	##. "$@"
	env -i "${fakeHomeENVvars[@]}" "$@"
	fakeHomeExitStatus=$?
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

#No workarounds, run in current shell.
# WARNING: Not recommended. No production use. Do not launch GUI applications.
_fakeHome_embedded() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
	#dbus-run-session "$@"
	#"$@"
	. "$@"
	fakeHomeExitStatus=$?
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

_fakeHome_() {
	_fakeHome_embedded "$@"
}




