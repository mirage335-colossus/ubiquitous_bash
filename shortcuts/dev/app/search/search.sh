_test_search() {
	_tryExec "_test_recoll"
}

# ATTENTION: Override with 'ops.sh' or similar.
_set_search_prog() {
	true
	#export current_configDir_search="$scriptLocal"/search
	#export current_configDir_search="$current_projectDir_search"/.search
}

_set_search() {
	_messagePlain_nominal 'init: _set_search'
	
	# DANGER: Consistent directory naming.
	# Force creation of 'project.afs' .
	export afs_nofs='false'
	export ubAbstractFS_enable_projectafs_dir='true'
	
	_reset_abstractfs
	"$scriptAbsoluteLocation" _messagePlain_probe_cmd _findProjectAFS .
	_reset_abstractfs
	
	_messagePlain_probe_cmd _abstractfs ls -d ./.
	_messagePlain_probe_var abstractfs
	
	_messagePlain_nominal "set: search"
	export current_abstractDir_search="$abstractfs"
	export current_projectDir_search="$abstractfs_projectafs_dir"
	_messagePlain_probe_var current_projectDir_search
	#export current_configDir_search="$scriptLocal"/search
	export current_configDir_search="$current_projectDir_search"/.search
	_set_search_prog "$@"
	_messagePlain_probe_var current_configDir_search
	
	_reset_abstractfs
}

_prepare_search() {
	_messagePlain_nominal 'init: _prepare_search'
	_set_search "$@"
	
	_messagePlain_nominal '_prepare_search: dir'
	#"$scriptAbsoluteLocation" _abstractfs _messagePlain_probe_cmd mkdir -p "$current_configDir_search"
	_messagePlain_probe_cmd mkdir -p "$current_configDir_search"
}
