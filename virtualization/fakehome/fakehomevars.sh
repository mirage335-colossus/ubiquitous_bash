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
	[[ -e "$instancedFakeHome" ]] & _safeRMR "$instancedFakeHome"
}
