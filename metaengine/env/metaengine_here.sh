_me_header_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

#_messagePlain_good
#_messagePlain_warn
#_messagePlain_bad

CZXWXcRMTo8EmM8i4d
	
	declare -f _color_begin_good
	declare -f _color_begin_warn
	declare -f _color_begin_bad
	declare -f _color_end
	declare -f _messagePlain_good
	declare -f _messagePlain_warn
	declare -f _messagePlain_bad
	
	echo
	echo
}

_me_var_here_script() {
	cat << CZXWXcRMTo8EmM8i4d
	
export scriptAbsoluteLocation="$scriptAbsoluteLocation"
export scriptAbsoluteFolder="$scriptAbsoluteFolder"
export sessionid="$sessionid"

CZXWXcRMTo8EmM8i4d
}

_me_var_here_prog() {
	cat << CZXWXcRMTo8EmM8i4d
CZXWXcRMTo8EmM8i4d
}

_me_var_here() {
	_me_var_here_script

	cat << CZXWXcRMTo8EmM8i4d

#Special. Signals do NOT reset metaID .
export metaEmbed="true"

#near equivalent: _set_me_host
	export metaBase="$metaBase"
	export metaObjName="$metaObjName"
	export metaTmp="$metaTmp"
	#export metaTmp="$$tmpSelf""$tmpPrefix"/.m_"$sessionid"
	export metaProc="$metaProc"
	# WARNING: Setting metaProc to a value not including sessionid disables automatic removal by default!
	#export metaProc="$metaBase""$tmpPrefix"/.m_"$sessionid"

export metaType="$metaType"

export metaID="$metaID"

export metaPath="$metaPath"

#export metaDir_tmp="$metaTmp"/"$metaPath"
#export metaDir_base="$metaProc"/"$metaPath"

#near equivalent _set_me_dir
	#export metaDir_tmp="$metaTmp"/"$metaPath"
	#export metaDir_base="$metaProc"/"$metaPath"
	#export metaDir="$metaDir_tmp"
	export metaDir_tmp="$metaDir_tmp"
	export metaDir_base="$metaDir_base"
	export metaDir="$metaDir"
	#[[ "$metaType" == "base" ]] && export metaDir="$metaDir_base" && _messagePlain_warn 'metaType= base'
	#[[ "$metaType" == "" ]] && _messagePlain_good 'metaType= '
	[[ "$metaType" == "base" ]] && _messagePlain_warn 'metaType= base'
	[[ "$metaType" == "" ]] && _messagePlain_good 'metaType= '

export metaReg="$metaReg"
export metaConfidence="$metaConfidence"

export in_me_a_path="$in_me_a_path"
export in_me_b_path="$in_me_b_path"
export out_me_a_path="$out_me_a_path"
export out_me_b_path="$out_me_b_path"



CZXWXcRMTo8EmM8i4d
	
	_me_var_here_prog "$@"
}

_me_embed_here() {
	_me_header_here
	
	_me_var_here
	
	cat << CZXWXcRMTo8EmM8i4d


. "$scriptAbsoluteLocation" --embed "\$@"
CZXWXcRMTo8EmM8i4d
}

_me_command_here() {
	_me_header_here
	
	_me_var_here
	
	#cat << CZXWXcRMTo8EmM8i4d
#
#
#. "$scriptAbsoluteLocation" --embed "$1" "\$@"
#CZXWXcRMTo8EmM8i4d

echo -n '. "$scriptAbsoluteLocation" --embed'

local currentArg
for currentArg in "$@"
do
	echo -n ' '
	_safeEcho \""$currentArg"\"
done

echo ' "$@"'

cat << CZXWXcRMTo8EmM8i4d
# Mark task complete, if part of parallel thread set.
if [[ "$processThreadID" != "" ]]
then
	_complete_me "$processThreadID"
	rm -f "$metaProc"/_active/"$processThreadID" > /dev/null 2>&1
fi
CZXWXcRMTo8EmM8i4d

}

_me_command_here_write() {
	mkdir -p "$metaDir"
	_me_command_here "$@" > "$metaDir"/me.sh
	chmod 700 "$metaDir"/me.sh
}
_me_command_here_write_noclobber() {
	[[ -e "$metaDir"/me.sh ]] && return 0
	
	_me_command_here_write "$@"
}
_me_command() {
	_messageNormal 'write: '"$metaObjName"
	_set_me
	_me_command_here_write "$@"
	
	_messageNormal 'fork: '"$metaObjName"': '"$metaDir"/me.sh
	"$metaDir"/me.sh &
}


