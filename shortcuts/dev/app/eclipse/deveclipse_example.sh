
_prepare_example_ConfigurationLookupDirectory_eclipse() {
	#_prepare_abstractfs_appdir_none "$@"
	#_prepare_abstractfs_appdir_independent "$@"
	_prepare_abstractfs_appdir_shared "$@"
	#_prepare_abstractfs_appdir_export "$@"
	
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	#_probe_prepare_abstractfs_appdir_post
	_probe_prepare_abstractfs_appdir
	
	export ub_eclipse_workspace="$ubAFS_CLD"/_eclipse-workspace
	export ub_eclipse_configuration="$ubAFS_CLD"/_eclipse-configuration/_eclipse_configuration
	
	mkdir -p "$ubASD_PRJ"
	mkdir -p "$ubASD_CLD"
}



_eclipse_example_binary() {
	eclipse "$@"
	#sleep 9
}


# ATTENTION: Override with 'core.sh', 'ops', or similar.
# Static parameters. Must be accepted if function overridden to point script contained installation.
_eclipse_example-static() {
	mkdir -p "$ub_eclipse_workspace"
	mkdir -p "$ub_eclipse_configuration"
	_eclipse_example_binary -vm "$ubJava" -data "$ub_eclipse_workspace" -configuration "$ub_eclipse_configuration" "$@"
}



_eclipse_example_procedure() {
	! _set_java__eclipse && _stop 1
	
	# Scope will by default... cd "$ub_specimen" ...
	#... abstractfs... consistent directory name... '_eclipse_executable'
	mkdir -p ./project
	cd ./project
	
	
	# Configuration Lookup Directory
	_prepare_example_ConfigurationLookupDirectory_eclipse _eclipse_example-static "$@"
	
	
	#... fakeHome... preparation... disable ?
	
	
	# Example only.
	[[ "$specialGCC" != '' ]] && _messagePlain_request 'request: special GCC bin='"$specialGCC"
	
	#echo "$ub_specimen"
	
	
	
	_messagePlain_request 'request: abstractfs: project:  '"$ubAFS_PRJ"
	
	
	#_abstractfs bash
	#eclipse -vm "$ubJava"  "$@"
	
	
	# DANGER: Current directory WILL be included in directory chosen by "_abstractfs" !
	_abstractfs _eclipse_example-static "$@"
}


_eclipse_example() {
	#_fakeHome "$scriptAbsoluteLocation" _eclipse_example_procedure "$@"
	"$scriptAbsoluteLocation" _eclipse_example_procedure "$@"
}

