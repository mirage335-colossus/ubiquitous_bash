_compile_bash_metaengine() {
	export includeScriptList
	
	#[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine"/undefined.sh )
}

_compile_bash_vars_metaengine() {
	export includeScriptList
	
	#[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine"/undefined_vars.sh )
}
