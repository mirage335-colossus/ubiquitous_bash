# CAUTION: ConfigurationLookupDirectory, managed by "_appdir" functions, is NOT a global configuration registry. ONLY intended to support programs which may require *project-specific* configuration (eg. Eclipse).
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
# WARNING: All 'mkdir' operations using "$ubADD" or similar must take place *within* abstractfs, to avoid creating a folder conflicting with the required symlink.
# Input
# "$@"
_set_abstractfs_AbstractSourceDirectory() {
	# AbstractSourceDirectory
	_set_abstractfs_disable_CLD
	export ubASD=$(export afs_nofs_write="true" ; "$scriptAbsoluteLocation" _get_base_abstractfs "$@" "$ub_specimen")
	_set_abstractfs_disable_CLD
	export ubASD_name=$(basename $ubASD)
	
	# Should never be reached. Also, undesirable default.
	[[ "$ubASD_name" == "" ]] && export ubASD_name=project
	
	
	# No known production use.
	export ubADD_CLD_none_sub=""
	export ubADD_PRJ_none_sub=""
	export ubASD_CLD_none_sub="$ubADD_CLD_none_sub"
	export ubASD_CLD_none="$ubASD"
	export ubASD_PRJ_none=""
	export ubASD_PRJ_none="$ubASD""$ubASD_PRJ_none"
	
	# ApplicationSourceDirectory-ConfigurationLookupDirectory
	# Project directory is *source* directory.
	# ConfigurationLookupDirectory is *neighbor*, using absolute path *outside* abstractfs translation.
	# CAUTION: Not compatible with applications requiring all paths translated by abstractfs.
	# CAUTION: Invalid to combine "$ubADD" with "$ubADD_CLD_independent_sub" .
	export ubADD_CLD_independent_sub=/../"$ubASD_name".cld
	export ubADD_PRJ_independent_sub=""
	export ubASD_CLD_independent_sub="$ubADD_CLD_independent_sub"
	export ubASD_CLD_independent="$ubASD""$ubASD_CLD_independent_sub"
	export ubASD_PRJ_independent_sub=""
	export ubASD_PRJ_independent="$ubASD""$ubASD_PRJ_independent_sub"
	
	# ConfigurationLookupDirectory is *neighbor*, next to project directory, in *shared* abstractfs directory.
	# DANGER: Strongly discouraged. May break use of "project.afs" with alternative layouts and vice versa.
	export ubADD_CLD_shared_sub=/"$ubASD_name".cld
	export ubADD_PRJ_shared_sub=/"$ubASD_name"
	export ubASD_CLD_shared_sub=/.."$ubADD_CLD_shared_sub"
	export ubASD_CLD_shared="$ubASD""$ubASD_CLD_shared_sub"
	export ubASD_PRJ_shared_sub=""
	export ubASD_PRJ_shared="$ubASD""$ubASD_PRJ_shared_sub"
	
	# Internal '_export' folder instead of neighboring ConfigurationLookupDirectory .
	export ubADD_CLD_export_sub=/_export/afscld
	export ubADD_PRJ_export_sub=""
	export ubASD_CLD_export_sub="$ubADD_CLD_export_sub"
	export ubASD_CLD_export="$ubASD""$ubASD_CLD_export_sub"
	export ubASD_PRJ_export_sub="$ubASD_CLD_export_sub"
	export ubASD_PRJ_export="$ubASD"
}

_set_abstractfs_enable_CLD() {
	export ubAbstractFS_enable_CLD='true'
}

_set_abstractfs_disable_CLD() {
	export ubAbstractFS_enable_CLD='false'
	
	# No known production use.
	export ubAbstractFS_enable_CLDnone='false'
	export ubAbstractFS_enable_CLDindependent='false'
	export ubAbstractFS_enable_CLDshared='false'
	export ubAbstractFS_enable_CLDexport='false'
}

_prepare_abstractfs_appdir() {
	mkdir -p "$ubASD"
	mkdir -p "$ubASD_CLD"
	#_set_abstractfs_disable_CLD
	export ubADD=$(export afs_nofs="true" ; "$scriptAbsoluteLocation" _get_abstractfs "$@" "$ub_specimen")
	#_set_abstractfs_disable_CLD
}











_probe_prepare_abstractfs_appdir_AbstractSourceDirectory() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_AbstractSourceDirectory'
	_messagePlain_probe_var ubASD
	_messagePlain_probe_var ubASD_name
	
	_messagePlain_probe_var ubASD_CLD_none_sub
	_messagePlain_probe_var ubASD_CLD_none
	
	_messagePlain_probe_var ubASD_CLD_independent_sub
	_messagePlain_probe_var ubASD_CLD_independent
	
	_messagePlain_probe_var ubASD_CLD_shared_sub
	_messagePlain_probe_var ubASD_CLD_shared
	
	_messagePlain_probe_var ubASD_CLD_export_sub
	_messagePlain_probe_var ubASD_CLD_export
}

_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior'
	_messagePlain_probe_var ubASD
	_messagePlain_probe_var ubASD_PRJ
	_messagePlain_probe_var ubASD_CLD
}

_probe_prepare_abstractfs_appdir_post() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_post'
	_messagePlain_probe_var ubADD
	#_messagePlain_probe_var ubADD_PRJ
	#_messagePlain_probe_var ubADD_CLD
	_messagePlain_probe_var ubAFS_PRJ
	_messagePlain_probe_var ubAFS_CLD
}



_probe_prepare_abstractfs_appdir() {
	_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	_probe_prepare_abstractfs_appdir_post
}

