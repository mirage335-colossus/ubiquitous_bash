_rmlink() {
	[[ -h "$1" ]] && rm -f "$1" && return 0
	! [[ -e "$1" ]] && return 0
	return 1
}

#Like "ln -sf", but will not proceed if target is not link and exists (ie. will not erase files).
_relink_sequence() {

	#Do not update correct symlink.
	local existingLinkTarget
	existingLinkTarget=$(readlink "$2")
	[[ "$existingLinkTarget" == "$1" ]] && return 0
	
	! [[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s "$1" "$2" && return 0
	[[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s -r "$1" "$2" && return 0
	
	return 1
}

_relink() {
	[[ "$relinkRelativeUb" == "true" ]] && export relinkRelativeUb=""
	_relink_sequence "$@"
}

_relink_relative() {
	export relinkRelativeUb="true"
	_relink_sequence "$@"
	export relinkRelativeUb=""
	unset relinkRelativeUb
}

#Copies files only if source/destination do match. Keeps files in a completely written state as often as possible.
_cpDiff() {
	! diff "$1" "$2" > /dev/null 2>&1 && cp "$1" "$2"
}
