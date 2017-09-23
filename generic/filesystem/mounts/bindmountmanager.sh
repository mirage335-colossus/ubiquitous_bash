# WARNING: Requries prior check with _mustGetSudo .
#"$1" == Source
#"$2" == Destination
_bindMountManager() {
	[[ ! -e "$1" ]] && return 1
	
	mkdir -p "$2"
	[[ ! -e "$2" ]] && return 1
	
	sudo -n mount --bind "$1" "$2"
} 
