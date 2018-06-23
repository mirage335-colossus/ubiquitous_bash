_test_abstractfs() {
	_getDep md5sum
}

_abstractfs() {
	_prepare_abstract
	
	local abstractfs_command="$1"
	shift
	
	export virtUserPWD="$PWD"
	
	export abstractfs_puid=$(_uid)
	
	_base_abstractfs "$@"
	_name_abstractfs "$@"
	[[ "$abstractfs_name" == "" ]] && return 1
	
	export abstractfs="$abstractfs_root"/"$abstractfs_name"
	
	_relink_abstractfs
	
	_set_share_abstractfs
	_virtUser "$@"
	
	cd "$localPWD"
	#cd "$abstractfs_base"
	#cd "$abstractfs"
	
	#_scope_terminal "${processedArgs[@]}"
	"$abstractfs_command" "${processedArgs[@]}"
	
	_set_share_abstractfs_reset
	_rmlink_abstractfs
}
