# WARNING Stability of this function's API is important for compatibility with existing docker images.
_drop_docker() {
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	_gosuExecVirt "$@"
}
