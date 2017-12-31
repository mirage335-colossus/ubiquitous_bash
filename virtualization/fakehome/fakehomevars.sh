_prepareFakeHome() {
	mkdir -p "$globalFakeHome"
}

_prepareFakeHome_instance() {
	_prepareFakeHome
	
	mkdir -p "$instancedFakeHome"
	cp -a "$globalFakeHome"/. "$instancedFakeHome"
}

_rm_instance_fakeHome() {
	rmdir "$instancedFakeHome" > /dev/null 2>&1
	
	# DANGER Allows folders containing ".git" to be removed in all further shells inheriting this environment!
	export safeToDeleteGit="true"
	
	[[ -e "$instancedFakeHome" ]] & _safeRMR "$instancedFakeHome"
}
