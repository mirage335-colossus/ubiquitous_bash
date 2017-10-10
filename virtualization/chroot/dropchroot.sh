_dropChRoot() {
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	_gosuExecVirt "$@"
}

_prepareChRootUser() {
	
	#_gosuExecVirt cp -r /etc/skel/. /home/
	
	cp -a /home/"$virtGuestUser".ref/. /home/"$virtGuestUser"/
	
	
}
