_rmlink() {
	[[ -h "$1" ]] && rm -f "$1" && return 0
	! [[ -e "$1" ]] && return 0
	return 1
}

#Like "ln -sf", but will not proceed if target is not link and exists (ie. will not erase files).
_relink() {

	#Do not update correct symlink.
	local existingLinkTarget
	existingLinkTarget=$(readlink "$2")
	[[ "$existingLinkTarget" == "$1" ]] && return 0
	
	_rmlink "$2" && ln -s "$1" "$2" && return 0
	return 1
}
