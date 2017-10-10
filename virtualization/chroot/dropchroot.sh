_dropChRoot() {
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	_gosuExec "$@"
}

_prepareChRootUser() {
	_gosuExec cp -r /etc/skel/. /home/
}
