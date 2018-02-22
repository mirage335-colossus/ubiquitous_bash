_compile_bash_deps_prog() {
	true
}

# #Default is to include all, or run a specified configuration. For this reason, it will be more typical to override this entire function, rather than append any additional code.
# _compile_bash_deps() {
# 	[[ "$1" == "lean" ]] && return 0
# 	
# 	if [[ "$1" == "cautossh" ]]
# 	then
# 		_deps_os_x11
# 		_deps_proxy
# 		_deps_proxy_special
# 		
# 		return 0
# 	fi
# 	
# 	if [[ "$1" == "" ]]
# 	then
# 		_deps_notLean
# 		_deps_os_x11
# 		
# 		_deps_x11
# 		_deps_image
# 		_deps_virt
# 		_deps_chroot
# 		_deps_qemu
# 		_deps_vbox
# 		_deps_docker
# 		_deps_wine
# 		_deps_dosbox
# 		_deps_msw
# 		_deps_fakehome
# 		
# 		_deps_blockchain
# 		
# 		_deps_proxy
# 		_deps_proxy_special
#		
#		_deps_build
# 		
# 		_deps_build_bash
# 		_deps_build_bash_ubiquitous
# 		
# 		return 0
# 	fi
# }

_vars_compile_bash_prog() {
	#export configDir="$scriptAbsoluteFolder"/_config
	
	#export progDir="$scriptAbsoluteFolder"/_prog
	#export progScript="$scriptAbsoluteFolder"/ubiquitous_bash.sh
	#[[ "$1" != "" ]] && export progScript="$scriptAbsoluteFolder"/"$1"
	
	true
}

_compile_bash_header_prog() {	
	export includeScriptList
	true
}

_compile_bash_header_program_prog() {	
	export includeScriptList
	true
}

_compile_bash_essential_utilities_prog() {	
	export includeScriptList
	true
}

_compile_bash_utilities_virtualization_prog() {	
	export includeScriptList
	true
}

_compile_bash_utilities_prog() {	
	export includeScriptList
	true
}

_compile_bash_shortcuts_prog() {	
	export includeScriptList
	true
}

_compile_bash_shortcuts_setup_prog() {	
	export includeScriptList
	true
}

_compile_bash_bundled_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_basic_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_global_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_spec_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_shortcuts_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_virtualization_prog() {	
	export includeScriptList
	true
}

_compile_bash_vars_bundled_prog() {	
	export includeScriptList
	true
}

_compile_bash_buildin_prog() {	
	export includeScriptList
	true
}

_compile_bash_environment_prog() {	
	export includeScriptList
	true
}

_compile_bash_installation_prog() {	
	export includeScriptList
	true
}

_compile_bash_program_prog() {	
	export includeScriptList
	true
}

_compile_bash_config_prog() {	
	export includeScriptList
	true
}

_compile_bash_selfHost_prog() {	
	export includeScriptList
	true
}

_compile_bash_overrides_prog() {	
	export includeScriptList
	true
}

_compile_bash_entry_prog() {	
	export includeScriptList
	true
}
