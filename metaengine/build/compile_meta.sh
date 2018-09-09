_compile_bash_metaengine() {
	export includeScriptList
	
	#[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine"/undefined.sh )
}

_compile_bash_vars_metaengine() {
	export includeScriptList
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/env"/metaengine_diag.sh )
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/env"/metaengine_here.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/env"/metaengine_vars.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/env"/metaengine_parm.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/env"/metaengine_local.sh )
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/example"/example_metaengine_chain.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/example"/example_metaengine_object.sh )
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_chain.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_object.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_vars.sh )
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_divert.sh )
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_buffer.sh )
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/typical"/typical_metaengine_page.sh )
}
