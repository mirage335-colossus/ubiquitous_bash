_dropChRoot() {
	
	# TODO Change to localPWD or home.
	
	# TODO Drop to user ubvrtusr or remain root, using gosu.
	
	#Temporary, for testing only.
	"$@"
	
}

_prepareChRootUser() {
	#drop permissions
	#cp -r /etc/skel/. /home/
	true
}
