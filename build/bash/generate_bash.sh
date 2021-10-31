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
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-lean_compressed
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







_generate_compile_bash-lean_compressed() {
	echo "#!/usr/bin/env bash" > "$scriptAbsoluteFolder"/lean_compressed.sh
	
	_compressed_criticalDep() {
		! _getAbsolute_criticalDep && exit 1
		
		! type -p sed > /dev/null 2>&1 && exit 1
		! type -p head > /dev/null 2>&1 && exit 1
		! type -p awk > /dev/null 2>&1 && exit 1
		! type -p grep > /dev/null 2>&1 && exit 1
		! type -p ls > /dev/null 2>&1 && exit 1
		! type -p base64 > /dev/null 2>&1 && exit 1
		
		! type -p xz > /dev/null 2>&1 && exit 1
		
		! type -p fold > /dev/null 2>&1 && exit 1
		
		#! type -p cksum > /dev/null 2>&1 && exit 1
		#! type -p env > /dev/null 2>&1 && exit 1
		
		return 0
	}
	
	_compress_lean_declare_headerFunctions() {
	declare -f _realpath_L
	declare -f _realpath_L_s
	declare -f _cygwin_translation_rootFileParameter
	declare -f _getAbsolute_criticalDep
	declare -f _getScriptAbsoluteLocation
	declare -f _getScriptAbsoluteFolder
	declare -f _getAbsoluteLocation
	
	declare -f _compressed_criticalDep
	}
	
	
	#local current_internal_compressedScript_headerFunctions
	current_internal_compressedScript_headerFunctions=$(_compress_lean_declare_headerFunctions | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	
	
	
	
	#local current_internal_CompressedScript
	current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/lean.sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	#local current_internal_CompressedScript_cksum
	current_internal_CompressedScript_cksum=$(echo "$current_internal_CompressedScript" | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9')
	#local current_internal_CompressedScript_bytes
	current_internal_CompressedScript_bytes=$(echo "$current_internal_CompressedScript" | wc -c | tr -dc '0-9')
	
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'export ub_setScriptChecksum_disable="true"' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo 'current_internal_CompressedScript_bytes='\'"$current_internal_CompressedScript_bytes"\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'current_internal_CompressedScript_cksum='\'"$current_internal_CompressedScript_cksum"\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'current_internal_CompressedScript='\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo "$current_internal_CompressedScript"\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'current_internal_compressedScript_headerFunctions='\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo "$current_internal_compressedScript_headerFunctions"\' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo '! echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'source <(echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d)' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/lean_compressed.sh
export importScriptLocation=$(_getScriptAbsoluteLocation)
export importScriptFolder=$(_getScriptAbsoluteFolder)
! type readlink > /dev/null 2>&1 && exit 1;
! type dirname > /dev/null 2>&1 && exit 1;
! type basename > /dev/null 2>&1 && exit 1;
! readlink -f . > /dev/null 2>&1 && exit 1;
[[ "$importScriptLocation" == "" ]] && exit 1
[[ "$importScriptFolder" == "" ]] && exit 1
! _getAbsolute_criticalDep && exit 1
CZXWXcRMTo8EmM8i4d
	
	echo '! _compressed_criticalDep && exit 1' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo '! echo "$current_internal_CompressedScript" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --call' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --bypass "$@"' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo 'unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'export ub_setScriptChecksum_disable=' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo 'unset ub_setScriptChecksum_disable' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo 'true' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo '# https://github.com/mirage335/ubiquitous_bash' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes
	
	
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo '#####Entry' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo '# ###' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	echo '[[ "$1" == '_'* ]] && "$@"' >> "$scriptAbsoluteFolder"/lean_compressed.sh
	echo >> "$scriptAbsoluteFolder"/lean_compressed.sh
	
	chmod u+x "$scriptAbsoluteFolder"/lean_compressed.sh
	
}
















