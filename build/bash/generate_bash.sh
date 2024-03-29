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
	#[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash core core_monolithic.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash monolithic monolithic.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash ubcore ubcore.sh
	
	[[ "$1" != "" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash "$@"
	
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure lean
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure ubcore
	#[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure core_monolithic
	#rm -f "$scriptAbsoluteFolder"/core_monolithic.sh
	##mv "$scriptAbsoluteFolder"/core_monolithic_compressed.sh "$scriptAbsoluteFolder"/core_compressed.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure monolithic
	rm -f "$scriptAbsoluteFolder"/monolithic.sh
	#mv "$scriptAbsoluteFolder"/monolithic_compressed.sh "$scriptAbsoluteFolder"/compressed.sh
	
	
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure ubiquitous_bash
	
	
	
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash rotten rotten.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure rotten
	#[[ "$objectName" == "ubiquitous_bash" ]] && mv -f "$scriptAbsoluteFolder"/rotten_compressed.sh "$scriptAbsoluteFolder"/rotten.sh
	
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash rotten_test rotten_test.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure rotten_test
	[[ "$objectName" == "ubiquitous_bash" ]] && mv -f "$scriptAbsoluteFolder"/rotten_test_compressed.sh "$scriptAbsoluteFolder"/rotten_test.sh
	
	
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





# ATTENTION: WARNING: CAUTION: Do NOT oversimplify! Keep in mind this seemingly 'spaghetti code' logic has in fact been thoroughly tested for safety, and is complex due to an extraordinary combination of preventive inheritance checks, workarounds, and compressed code. Compressed scripts are already a workaround for purely arbitrary limitations (eg. cloud init script size limits). This stuff goes as far as ensuring the compressed scripts can be included through '.bashrc' without any possibility of interfering with other 'ubiquitous bash' scripts.
# WARNING: Unfortunately, this really is necessarily as complicated as it looks. A text editor which highlights a currently selected text fragment elsewhere, may help 'browse' the code, such as double-clicking the 'source' word and comparing other occurrences. Removing code which specifically optimizes what does not appear in the especially small 'rotten' script may also help make the code a bit easier to understand.
# WARNING: Keep in mind some logical conditions here may yet have no production use, but are thoroughly expected to have a production use in the future. Other logic may have an existing use which only becomes obvious if some of the software using 'ubiquitous bash' is tested. Particularly, '_scope', 'arduinoUbiquitous', '_setupUbiquitous', etc. MSW also causes significant issues. Building automatic tests for such issues may require a network of Virtual Machines, and testing strictly interactive (ie. '_bash', 'bash -i', etc) shells, all of which may also require software development of the relevant toolchain first.
# _request_visualPrompt
_generate_compile_bash-compressed_procedure() {
	# If a "base85"/"ascii85" implementation were widely available at all possibly relevant 'environments', then compressed scripts could possibly be ~5% smaller.
	# WARNING: Do NOT attempt 'yEnc', apparently NOT 'utf8' text editor compatible.
	# https://en.wikipedia.org/wiki/Ascii85
	# https://en.wikipedia.org/wiki/Binary-to-text_encoding
	# https://sites.google.com/site/dannychouinard/Home/unix-linux-trinkets/little-utilities/base64-and-base85-encoding-awk-scripts
	#  'if you plan on running these on Solaris, use the /usr/xpg4/bin versions of awk'
	#  https://sites.google.com/site/dannychouinard/Home
	#   'Everything is open source, either public domain or GPL V2.'
	#  Experiments may have found input character corruption apparently with few but significant binary symbols.
	# https://metacpan.org/pod/Math::Base85
	# https://stackoverflow.com/questions/51821351/how-do-i-use-m-flag-to-load-a-perl-module-using-its-relative-path-from-command
	#uudeview
	#local current_textBinaryEncoder
	#current_textBinaryEncoder=""
	#current_textBinaryEncoder="$2"
	#sed -i 'N;s/\n//'
	
	echo "#!/usr/bin/env bash" > "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '[[ "$PATH" != *"/usr/local/bin"* ]] && [[ -e "/usr/local/bin" ]] && export PATH=/usr/local/bin:"$PATH"
[[ "$PATH" != *"/usr/bin"* ]] && [[ -e "/usr/bin" ]] && export PATH=/usr/bin:"$PATH"
[[ "$PATH" != *"/bin:"* ]] && [[ -e "/bin" ]] && export PATH=/bin:"$PATH"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
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
	
	_compress_declare_headerFunctions() {
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
	current_internal_compressedScript_headerFunctions=$(_compress_declare_headerFunctions | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	
	
	# Comment filter seems to greatly improve compressibility, possibly due to comments being much less compressible than code.
	# WARNING: Comment filter may incorrectly remove comments within here documents, as with '#!/bin/dash' from '_here_header_bash_or_dash()' . Interleaved code using different comment characters (eg. 'batch' files interpretable as 'bash', 'scriptedIllustrator', etc) will fail. Diagnostic/debugging/etc comments may also be removed.
	# https://unix.stackexchange.com/questions/157328/how-can-i-remove-all-comments-from-a-file
	#grep -o '^[^#]*'
	#sed '/^[[:blank:]]*#/d;s/#.*//''
	#shfmt -mn foo.sh
	# https://stackoverflow.com/questions/3349156/general-utility-to-remove-strip-all-comments-from-source-code-in-various-languag
	#cloc --strip-comments=small
	#--use-sloccount
	#grep -v '^'"[[:space:]]"'#'
	#grep -v '^#' | grep -v '^'"[[:space:]]"'#'
	#grep -v '^#[^!]' | grep -v '^'"[[:space:]]"'#[^!]'
	
	# https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed
	
	local current_internal_CompressedScript
	#current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/"$1".sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	if [[ "$1" == "rotten" ]] && [[ "$1" == "rotten"* ]]
	then
		current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/"$1".sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | grep -v '^#[^!]' | grep -v '^'"[[:space:]]"'#[^!]' | sed '/\S/!d' | grep -v -P '^\t*#' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	else
		current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/"$1".sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | grep -v '^#[^!]' | grep -v '^'"[[:space:]]"'#[^!]' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	fi
	
	#local current_internal_CompressedScript_cksum
	current_internal_CompressedScript_cksum=$(echo "$current_internal_CompressedScript" | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9')
	#local current_internal_CompressedScript_bytes
	current_internal_CompressedScript_bytes=$(echo "$current_internal_CompressedScript" | wc -c | tr -dc '0-9')
	
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'export ub_setScriptChecksum_disable="true"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo 'current_internal_CompressedScript_bytes='\'"$current_internal_CompressedScript_bytes"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_CompressedScript_cksum='\'"$current_internal_CompressedScript_cksum"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_CompressedScript='\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo "$current_internal_CompressedScript"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_compressedScript_headerFunctions='\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo "$current_internal_compressedScript_headerFunctions"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '! echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d)' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	[[ "$1" != "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
if [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export tmpMSW_compressed=$( cd "$LOCALAPPDATA" 2>/dev/null ; pwd )"/Temp"/uk4u_"$RANDOM""$RANDOM""$RANDOM".sh
	echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d > "$tmpMSW_compressed"
	source "$tmpMSW_compressed"
	rm -f "$tmpMSW_compressed"
else
	source <(echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d)
fi
CZXWXcRMTo8EmM8i4d
	[[ "$1" == "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	source <(echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d)
CZXWXcRMTo8EmM8i4d
	
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
export importScriptLocation=$(_getScriptAbsoluteLocation)
export importScriptFolder=$(_getScriptAbsoluteFolder)
! type readlink > /dev/null 2>&1 && exit 1;
! type dirname > /dev/null 2>&1 && exit 1;
! type basename > /dev/null 2>&1 && exit 1;
! readlink -f . > /dev/null 2>&1 && exit 1;
CZXWXcRMTo8EmM8i4d
	echo '[[ "$1" == "--profile" ]] && ( [[ '"$1"' == "rotten"* ]] || [[ '"$1"' == "rotten" ]] ) && export ub_import="true" && export importScriptLocation="$profileScriptLocation" && export importScriptFolder="$profileScriptFolder"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
[[ "$importScriptLocation" == "" ]] && exit 1
[[ "$importScriptFolder" == "" ]] && exit 1
! _getAbsolute_criticalDep && exit 1
CZXWXcRMTo8EmM8i4d
	
	echo '! _compressed_criticalDep && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo '! echo "$current_internal_CompressedScript" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --compressed "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --script' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --call' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --bypass "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
if [[ "$1" == "--embed" ]]
then
CZXWXcRMTo8EmM8i4d

	[[ "$1" == "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
	internalFunctionExitStatus="$?"
CZXWXcRMTo8EmM8i4d
	[[ "$1" != "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	if [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1
	then
		echo "$current_internal_CompressedScript" | base64 -d | xz -d > "$tmpMSW_compressed"
		source "$tmpMSW_compressed" "$@"
		internalFunctionExitStatus="$?"
		rm -f "$tmpMSW_compressed"
	else
		source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
		internalFunctionExitStatus="$?"
	fi
CZXWXcRMTo8EmM8i4d
	
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	return "$internalFunctionExitStatus" > /dev/null 2>&1
	exit "$internalFunctionExitStatus"
elif [[ "$1" == "--profile" ]] || [[ "$1" == "--parent" ]]
then
CZXWXcRMTo8EmM8i4d
	
	[[ "$1" == "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
CZXWXcRMTo8EmM8i4d
	[[ "$1" != "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	if [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1
	then
		echo "$current_internal_CompressedScript" | base64 -d | xz -d > "$tmpMSW_compressed"
		source "$tmpMSW_compressed" "$@"
		rm -f "$tmpMSW_compressed"
	else
		source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
	fi
CZXWXcRMTo8EmM8i4d

	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
else
CZXWXcRMTo8EmM8i4d
	
	[[ "$1" == "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --compressed "$@"
CZXWXcRMTo8EmM8i4d
	[[ "$1" != "rotten" ]] && cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	if [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1
	then
		echo "$current_internal_CompressedScript" | base64 -d | xz -d > "$tmpMSW_compressed"
		source "$tmpMSW_compressed" --compressed "$@"
		rm -f "$tmpMSW_compressed"
	else
		source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --compressed "$@"
	fi
CZXWXcRMTo8EmM8i4d
	
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	ub_import=
	ub_import_param=
	ub_import_script=
	ub_loginshell=
fi
if [[ "$ub_import" == "true" ]] && ! ( [[ "$ub_import_param" == "--bypass" ]] ) || [[ "$ub_import_param" == "--compressed" ]] || [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--profile" ]]
then
CZXWXcRMTo8EmM8i4d
	echo '	if [[ "$ubiquitousBashID" != "" ]] || [[ -e "$HOME"/.ubcore ]] || ( [[ '"$1"' != "rotten"* ]] || [[ '"$1"' != "rotten" ]] )' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	then
		return 0 > /dev/null 2>&1
		exit 0
	fi
fi
CZXWXcRMTo8EmM8i4d
	
	echo 'unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'export ub_setScriptChecksum_disable=' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'unset ub_setScriptChecksum_disable' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo 'true' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo '# https://github.com/mirage335/ubiquitous_bash' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes
	
	
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '#####Entry' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '# ###' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	# TODO: ' ./ubiquitous_bash_compressed.sh _bin bash -i ' fails if '_main' is enabled
	# TODO: Maybe "$ub_import_param" is not set in this context?
	#echo '[[ "$1" == '"'"_"'"'* ]] && type "$1" > /dev/null 2>&1 && "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	# Disable dependency for 'gosu' binaries only if definitely necessary and if function is otherwise defined.
	#_test_Gosu() {
		#true
	#}
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
_test_prog() {
	true
}
_main() {
	#_start
	_start scriptLocal_mkdir_disable
	
	_collect
	
	_enter "$@"
	
	_stop
}
if [[ "$1" == '_test' ]]
then
	current_deleteScriptLocal="false"
	[[ ! -e "$scriptLocal" ]] && current_deleteScriptLocal="true"
	_stop_prog() {
		[[ "$current_deleteScriptLocal" == "true" ]] && rmdir "$scriptLocal" > /dev/null 2>&1
	}
fi
if [[ "$1" == '_'* ]] && type "$1" > /dev/null 2>&1
then
	"$@"
	internalFunctionExitStatus="$?"
	return "$internalFunctionExitStatus" > /dev/null 2>&1
	exit "$internalFunctionExitStatus"
fi
if [[ "$1" != '_'* ]]
then
	_main "$@"
fi
CZXWXcRMTo8EmM8i4d
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	chmod u+x "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
}
















