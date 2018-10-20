_dropChRoot() {
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	"$scriptAbsoluteLocation" _gosuExecVirt cp -r /etc/skel/. "$virtGuestHomeDrop"
	
	"$scriptAbsoluteLocation" _gosuExecVirt "$scriptAbsoluteLocation" _setupUbiquitous_nonet > /dev/null 2>&1
	
	# Drop to user ubvrtusr, using gosu.
	_gosuExecVirt "$@"
}

#No production use. Kept for reference only.
###_prepareChRootUser() {
	
	#_gosuExecVirt cp -r /etc/skel/. /home/
	
	#cp -a /home/"$virtGuestUser".ref/. /home/"$virtGuestUser"/
	#chown "$virtGuestUser":"$virtGuestUser" /home/"$virtGuestUser"
	
	###true
	
###}
