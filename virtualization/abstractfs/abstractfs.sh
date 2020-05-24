_test_abstractfs_sequence() {
	export afs_nofs="true"
	if ! "$scriptAbsoluteLocation" _abstractfs ls "$scriptAbsoluteLocation" > /dev/null 2>&1
	then
		_stop 1
	fi
}

_test_abstractfs() {
	_getDep md5sum
	if ! "$scriptAbsoluteLocation" _test_abstractfs_sequence
	then
		echo 'fail: abstractfs: ls'
		_stop 1
	fi
}

# WARNING: First parameter, "$1" , must always be non-translated program to run or specialized abstractfs command.
# Specifically do not attempt _abstractfs "$scriptAbsoluteLocation" or similar.
# "$scriptAbsoluteLocation" _fakeHome "$scriptAbsoluteLocation" _abstractfs bash
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
	
	
	local current_abstractfs_base_args
	current_abstractfs_base_args=("${@}")
	
	[[ "$ubAbstractFS_enable_CLD" == 'true' ]] && [[ "$ubASD_CLD" != '' ]] && current_abstractfs_base_args+=( "$ubASD_PRJ" "$ubASD_CLD" )
	
	# WARNING: Enabling may allow a misplaced 'project.afs' file in "/" , "$HOME' , or similar, to override a legitimate directory.
	# However, such a misplaced file may already cause wrong directory collisions with abstractfs.
	# Historically not enabled by default. Consider enabling by default equivalent to at least a minor version bump - be wary of any possible broken use cases.
	[[ "$abstractfs_projectafs_dir" != "" ]] && [[ "$ubAbstractFS_enable_projectafs_dir" == 'true' ]] && current_abstractfs_base_args+=( "$abstractfs_projectafs_dir" )
	#[[ "$abstractfs_projectafs_dir" != "" ]] && [[ "$ubAbstractFS_enable_projectafs_dir" != 'false' ]] && current_abstractfs_base_args+=( "$abstractfs_projectafs_dir" )
	
	_base_abstractfs "${current_abstractfs_base_args[@]}"
	
	
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
	commandExitStatus=1
	
	#_scope_terminal "${processedArgs[@]}"
	
	if ! [[ -L "$abstractfs" ]] && [[ -d "$abstractfs" ]]
	then
		# _messagePlain_bad 'fail: abstractfs: abstractfs_base is a directory: abstractfs_base= ""$abstractfs_base"
		rmdir "$abstractfs"
		_set_share_abstractfs_reset
		_rmlink_abstractfs
		return 1
	fi
	
	_set_abstractfs_disable_CLD
	[[ "$abstractfs_command" == 'ub_abstractfs_getOnly_dst' ]] && echo "$abstractfs"
	[[ "$abstractfs_command" == 'ub_abstractfs_getOnly_src' ]] && echo "$abstractfs_base"
	if [[ "$abstractfs_command" != 'ub_abstractfs_getOnly_dst' ]] && [[ "$abstractfs_command" != 'ub_abstractfs_getOnly_src' ]]
	then
		"$abstractfs_command" "${processedArgs[@]}"
		commandExitStatus="$?"
	fi
	
	_set_share_abstractfs_reset
	_rmlink_abstractfs
	
	return "$commandExitStatus"
}





_get_abstractfs_dst_procedure() {
	shift
	_abstractfs 'ub_abstractfs_getOnly_dst' "$@"
}
_get_abstractfs_dst_sequence() {
	_start
	_get_abstractfs_dst_procedure "$@"
	_stop 0
}

# If the result independent of any particular command is desired, use "_true" as command (first parameter).
_get_abstractfs_dst() {
	"$scriptAbsoluteLocation" _get_abstractfs_dst_sequence "$@"
}
_get_abstractfs() {
	_get_abstractfs_dst "$@"
}



_get_abstractfs_src_procedure() {
	shift
	_abstractfs 'ub_abstractfs_getOnly_src' "$@"
}
_get_abstractfs_src_sequence() {
	_start
	_get_abstractfs_src_procedure "$@"
	_stop 0
}
# If the result independent of any particular command is desired, use "_true" as command (first parameter).
_get_abstractfs_src() {
	"$scriptAbsoluteLocation" _get_abstractfs_src_sequence "$@"
}

_get_base_abstractfs() {
	_get_abstractfs_src "$@"
}
_get_base_abstractfs_name() {
	local current_abstractfs_base
	current_abstractfs_base=$(_get_abstractfs_src "$@")
	basename "$current_abstractfs_base"
}




