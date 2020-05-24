_eclipse_binary() {
	eclipse "$@"
}

# ATTENTION: Override with 'core.sh', 'ops', or similar.
# Static parameters. Must be accepted if function overridden to point script contained installation.
_eclipse_param() {
	_eclipse_example_binary -vm "$ubJava" -data "$ub_eclipse_workspace" -configuration "$ub_eclipse_configuration" "$@"
}




