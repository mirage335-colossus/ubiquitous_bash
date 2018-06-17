_test_fakehome() {
	_getDep mount
	_getDep mountpoint
	
	_getDep rsync
}

#"$1" == source directory
#actualFakeHome
	#default: "$instancedFakeHome"
	#"$globalFakeHome" || "$instancedFakeHome" || "$shortFakeHome" || "$arbitraryFakeHome"/arbitrary
_install_fakeHome() {
	! [[ -e "$1" ]] && return 1
	! [[ -d "$1" ]] && return 1
	! [[ -e "$actualFakeHome" ]] && return 1
	! [[ -d "$actualFakeHome" ]] && return 1
	rsync -q -ax --exclude "/.cache" --exclude "/.git" "$1"/. "$actualFakeHome"/
}

#Example. Run similar code under "core.sh" before calling "_fakeHome", "_install_fakeHome", or similar, to set a specific type/location for fakeHome environment - global, instanced, or otherwise.
_arbitrary_fakeHome_app() {
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$shortFakeHome"
	
	#export actualFakeHome="$globalFakeHome"
	#export actualFakeHome=""$arbitraryFakeHome"/arbitrary"
}

#Example. Run similar code under "core.sh" before calling "_fakeHome" to add features to any fakeHome environment, global, instanced, or otherwise.
_install_fakeHome_app() {
	mkdir -p "$scriptLocal"/app/.app
	
	_install_fakeHome "$scriptLocal"/app/.
	#_relink "$scriptLocal"/app/.app "$globalFakeHome"/.app
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

#actualFakeHome
	#default: "$instancedFakeHome"
	#"$globalFakeHome" || "$instancedFakeHome" || "$shortFakeHome" || "$arbitraryFakeHome"/arbitrary
#keepFakeHome
	#default: true
	#"true" || "false"
_fakeHome() {
	#Recursive fakeHome prohibited. Instead, start new script session, with new sessionid, and keepFakeHome=false. Do not workaround without a clear understanding why this may endanger your application.
	[[ "$setFakeHome" == "true" ]] && return 1
	#_resetFakeHomeEnv_nokeep
	
	[[ "$realHome" == "" ]] && export realHome="$HOME"
	
	export HOME="$actualFakeHome"
	export setFakeHome=true
	
	_prepareFakeHome > /dev/null 2>&1
	_install_fakeHome "$globalFakeHome"
	_makeFakeHome "$realHome" "$actualFakeHome"
	
	env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" dbus-run-session "$@"
	#"$@"
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
}
