
_prepare_example_ConfigurationLookupDirectory_eclipse() {
	_prepare_abstractfs_appdir "$@"
	_probe_prepare_abstractfs_appdir_static
	
	export ub_eclipse_workspace="$ubCLD_static"/_eclipse-workspace
	export ub_eclipse_configuration="$ubCLD_static"/_eclipse-configuration/_eclipse_configuration
	
	mkdir -p "$ub_eclipse_workspace"
	mkdir -p "$ub_eclipse_configuration"
}



_eclipse_example_binary() {
	eclipse "$@"
}


# ATTENTION: Override with 'core.sh', 'ops', or similar.
# Static parameters. Must be accepted if function overridden to point script contained installation.
_eclipse_example-static() {
	_eclipse_example_binary -vm "$ubJava" -data "$ub_eclipse_workspace" -configuration "$ub_eclipse_configuration" "$@"
}



_eclipse_example_procedure() {
	! _set_java_openjdk && _stop 1
	
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
	
	
	
	_messagePlain_request 'request: abstractfs:          '"$ubAPD_static"
	
	
	#_abstractfs bash
	#eclipse -vm "$ubJava"  "$@"
	
	
	# DANGER: Current directory WILL be included in directory chosen by "_abstractfs" !
	_abstractfs _eclipse_example-static "$@"
}


_eclipse_example() {
	#_fakeHome "$scriptAbsoluteLocation" _eclipse_example_procedure "$@"
	"$scriptAbsoluteLocation" _eclipse_example_procedure "$@"
}

