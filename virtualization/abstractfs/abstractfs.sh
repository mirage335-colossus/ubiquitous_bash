_test_abstractfs() {
	_getDep md5sum
}

_abstractfs() {
	#Nesting prohibited. Not fully tested.
	# WARNING: May cause infinite recursion symlinks.
	[[ "$abstractfs" != "" ]] && return 1
	
	_reset_abstractfs
	
	_prepare_abstract
	
	local abstractfs_command="$1"
	shift
	
	export virtUserPWD="$PWD"
	
	export abstractfs_puid=$(_uid)
	
	_base_abstractfs "$@"
	_name_abstractfs > /dev/null 2>&1
	[[ "$abstractfs_name" == "" ]] && return 1
	
	export abstractfs="$abstractfs_root"/"$abstractfs_name"
	
	_set_share_abstractfs
	_relink_abstractfs
	_virtUser "$@"
	
	cd "$localPWD"
	#cd "$abstractfs_base"
	#cd "$abstractfs"
	
	local commandExitStatus
	
	#_scope_terminal "${processedArgs[@]}"
	"$abstractfs_command" "${processedArgs[@]}"
	commandExitStatus=$?
	
	_set_share_abstractfs_reset
	_rmlink_abstractfs
	
	return "$commandExitStatus"
}
