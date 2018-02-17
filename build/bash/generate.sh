_generate_bash() {
	
	_findUbiquitous
	_vars_generate_bash
	
	rm -f "$progScript" >/dev/null 2>&1
	
	includeScriptList+=( "generic"/minimalheader.sh )
	
	#####Essential Utilities
	includeScriptList+=( "labels"/utilitiesLabel.sh )
	includeScriptList+=( "generic/filesystem"/absolutepaths.sh )
	includeScriptList+=( "generic/filesystem"/safedelete.sh )
	includeScriptList+=( "generic/process"/timeout.sh )
	includeScriptList+=( "generic"/uid.sh )
	includeScriptList+=( "generic/filesystem/permissions"/checkpermissions.sh )
	
	includeScriptList+=( "build/bash"/include.sh )
	
	includeScriptList+=( "structure"/globalvars.sh )
	
	includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitious.sh )
	
	includeScriptList+=( "build/bash/ubiquitous"/depsubiquitous.sh )
	
	includeScriptList+=( deps.sh )
	
	includeScriptList+=( "build/bash"/generate.sh )
	
	includeScriptList+=( "build/bash"/compile.sh )
	
	includeScriptList+=( "structure"/overrides.sh )
	
	_includeScripts "${includeScriptList[@]}"
	
	#Default command.
	echo >> "$progScript"
	echo _generate_compile_bash >> "$progScript"
	
	chmod u+x "$progScript"
	
	# DANGER Do NOT remove.
	exit
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
	exit
}

#Typically not used literally. Preserved as an example command set to build the otherwise self-hosted generate/compile script manually.
_bootstrap_bash_basic() {
	cat "generic"/minimalheader.sh "labels"/utilitiesLabel.sh "generic/filesystem"/absolutepaths.sh "generic/filesystem"/safedelete.sh "generic/process"/timeout.sh "generic"/uid.sh "generic/filesystem/permissions"/checkpermissions.sh "build/bash"/include.sh "structure"/globalvars.sh "build/bash/ubiquitous"/discoverubiquitious.sh "build/bash/ubiquitous"/depsubiquitous.sh "build/bash"/generate.sh "build/bash"/compile.sh "structure"/overrides.sh > ./compile.sh
	echo >> ./compile.sh
	echo _generate_compile_bash >> ./compile.sh
	chmod u+x ./compile.sh
}
