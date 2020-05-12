
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_set_abstractfs_AbstractSourceDirectory() {
	# AbstractSourceDirectory
	export ubASD=$(_get_base_abstractfs "$@" "$ub_specimen")
	export ubASD_name=$(basename $ubASD)
	
	# Should never be reached. Also, undesirable default.
	[[ "$ubASD_name" == "" ]] && export ubASD_name=project
	
	# ApplicationSourceDirectory-ConfigurationLookupDirectory
	# Project directory is *source* directory.
	# ConfigurationLookupDirectory is *neighbor*, using absolute path *outside* abstractfs translation.
	# CAUTION: Not compatible with applications requiring all paths translated by abstractfs.
	export ubASD_CLD="$ubASD"/../"$ubASD_name".cld
	
	# Internal '_export' folder instead of neighboring ConfigurationLookupDirectory .
	export ubASD_CLD_export="$ubASD"/_export/afscld
}






# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_prepare_abstractfs_appdir_export() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	
	mkdir -p "$ubASD_CLD_export"
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	export ubAPD_prior_export="$ubASD"
	export ubCLD_prior_export="$ubASD_CLD_export"
	#####
	
	##### # ATTENTION: Export. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	export ubAPD_export="$ubADD"
	export ubCLD_export="$ubASD_CLD_export"
	#####
}




# ATTENTION Overload ONLY if further specialization is actually required!
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_prepare_abstractfs_appdir() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	
	mkdir -p "$ubASD"
	mkdir -p "$ubASD_CLD"
	
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	export ubAPD_prior="$ubASD"
	export ubCLD_prior="$ubASD_CLD"
	#####
	
	
	# AbstractDestinationDirectory
	export ubADD=$(_get_abstractfs "$@" "$ub_specimen")
	
	
	##### # ATTENTION: Static. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	export ubAPD_static="$ubADD"
	export ubCLD_static="$ubASD_CLD"
	#####
	
	
	export ubASDdyn=$(_get_base_abstractfs "$@" "$ub_specimen" "$ubASD_CLD")
	export ubADDdyn=$(_get_abstractfs "$@" "$ub_specimen" "$ubASD_CLD")
	
	export ubADDdyn_CLD="$ubADDdyn"/"$ubASD_name".cld
	
	
	##### # ATTENTION: Dynamic. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	export ubAPD_dynamic="$ubADDdyn"/"$ubASD_name"
	export ubCLD_dynamic="$ubADDdyn_CLD"
	#####
}
# MISUSE. Permissible, given rare requirement to ensure directories exist to perform common directory determination.
_set_abstractfs_appdir() {
	_prepare_abstractfs_appdir "$@"
}


_probe_prepare_abstractfs_appdir_prior() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_prior'
	_messagePlain_probe_var ubAPD_prior
	_messagePlain_probe_var ubCLD_prior
}
_probe_prepare_abstractfs_appdir_static() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_static'
	_messagePlain_probe_var ubAPD_static
	_messagePlain_probe_var ubCLD_static
}
_probe_prepare_abstractfs_appdir_dynamic() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_dynamic'
	_messagePlain_probe_var ubAPD_dynamic
	_messagePlain_probe_var ubCLD_dynamic
}
_probe_prepare_abstractfs_appdir() {
	_probe_prepare_abstractfs_appdir_prior
	_probe_prepare_abstractfs_appdir_static
	_probe_prepare_abstractfs_appdir_dynamic
}

