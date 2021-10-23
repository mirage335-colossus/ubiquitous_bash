_generate_bash() {
	
	_findUbiquitous
	_vars_generate_bash
	
	#####
	
	_deps_build_bash
	_deps_build_bash_ubiquitous
	
	#####
	
	rm -f "$progScript" >/dev/null 2>&1
	
	_compile_bash_header
	
	_compile_bash_essential_utilities
	_compile_bash_utilities
	
	_compile_bash_vars_global
	
	_compile_bash_extension
	_compile_bash_selfHost
	_compile_bash_selfHost_prog
	
	_compile_bash_overrides_disable
	_compile_bash_overrides
	
	_includeScripts "${includeScriptList[@]}"
	
	#Default command.
	echo >> "$progScript"
	echo '_generate_lean-python "$@"' >> "$progScript"
	
	echo >> "$progScript"
	echo '_generate_compile_bash "$@"' >> "$progScript"
	
	echo 'exit 0' >> "$progScript"
	
	chmod u+x "$progScript"
	
	
	_tryExecFull _ub_cksum_special_derivativeScripts_write "$progScript"
	
	# DANGER Do NOT remove.
	exit 0
}

_vars_generate_bash() {
	export configDir="$scriptAbsoluteFolder"/_config
	
	export progDir="$scriptAbsoluteFolder"/_prog
	export progScript="$scriptAbsoluteFolder"/compile.sh
}

#Intended as last command in a compile script. Updates the compile script itself, uses the updated script to update itself again, then compiles product with fully synchronized script.
# WARNING Must be last command and part of a function, or there will be risk of re-entering the script at an incorrect location.
_generate_compile_bash() {
	"$scriptAbsoluteLocation" _generate_bash
	"$scriptAbsoluteFolder"/compile.sh _generate_bash
	"$scriptAbsoluteFolder"/compile.sh _compile_bash
	
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash lean lean.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash ubcore ubcore.sh
	
	[[ "$1" != "" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash "$@"
	
	_generate_compile_bash_prog
	
	# DANGER Do NOT remove.
	exit 0
}

# #No production use. Unmaintained, obsolete. Never used literally. Preserved as an example command set to build the otherwise self-hosted generate/compile script manually (ie. bootstrapping).
# _bootstrap_bash_basic() {
# 	cat "generic"/minimalheader.sh "labels"/utilitiesLabel.sh "generic/filesystem"/absolutepaths.sh "generic/filesystem"/safedelete.sh "generic/process"/timeout.sh "generic"/uid.sh "generic/filesystem/permissions"/checkpermissions.sh "build/bash"/include.sh "structure"/globalvars.sh "build/bash/ubiquitous"/discoverubiquitous.sh "build/bash/ubiquitous"/depsubiquitous.sh "build/bash"/generate.sh "build/bash"/compile.sh "structure"/overrides.sh > ./compile.sh
# 	echo >> ./compile.sh
# 	echo _generate_compile_bash >> ./compile.sh
# 	chmod u+x ./compile.sh
# }
