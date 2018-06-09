_prepareFakeHome() {
	mkdir -p "$globalFakeHome"
	[[ "$appGlobalFakeHome" != "" ]] && mkdir -p "$appGlobalFakeHome"
}

_prepareFakeHome_instance() {
	_prepareFakeHome
	
	[[ "$ub_disable_prepareFakeHome_instance" == "true" ]] && return
	
	mkdir -p "$instancedFakeHome"
	
	if [[ "$appGlobalFakeHome" == "" ]]
	then
		#cp -a "$globalFakeHome"/. "$instancedFakeHome"
		rsync -q -ax --exclude "/.cache" "$globalFakeHome"/ "$instancedFakeHome"/
		return
	fi
	
	if [[ "$appGlobalFakeHome" != "" ]]
	then
		#cp -a "$appGlobalFakeHome"/. "$instancedFakeHome"
		rsync -q -ax --exclude "/.cache" "$appGlobalFakeHome"/ "$instancedFakeHome"/
		return
	fi
}

_rm_instance_fakeHome() {
	rmdir "$instancedFakeHome" > /dev/null 2>&1
	
	# DANGER Allows folders containing ".git" to be removed in all further shells inheriting this environment!
	export safeToDeleteGit="true"
	
	[[ -e "$instancedFakeHome" ]] & _safeRMR "$instancedFakeHome"
}
