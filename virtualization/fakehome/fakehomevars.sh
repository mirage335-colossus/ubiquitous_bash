_prepareFakeHome() {
	mkdir -p "$actualFakeHome"
}

_rm_instance_fakeHome() {
	! [[ -e "$instancedFakeHome" ]] && return 0
	
	[[ -e "$instancedFakeHome" ]] && rmdir "$instancedFakeHome" > /dev/null 2>&1
	
	[[ -e "$instancedFakeHome" ]] && _unmakeFakeHome "$instancedFakeHome" > /dev/null 2>&1
	
	# DANGER Allows folders containing ".git" to be removed in all further shells inheriting this environment!
	export safeToDeleteGit="true"
	[[ -e "$instancedFakeHome" ]] && _safeRMR "$instancedFakeHome"
	export safeToDeleteGit="false"
}
