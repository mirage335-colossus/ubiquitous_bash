#!/usr/bin/env bash

if [[ "$ubDEBUG" == "true" ]] ; then set +x ; set +E ; set +o functrace ; set +o errtrace ; export -n SHELLOPTS 2>/dev/null || true ; trap '' RETURN ; trap - RETURN ; fi

[[ "$PATH" != *"/usr/local/bin"* ]] && [[ -e "/usr/local/bin" ]] && export PATH=/usr/local/bin:"$PATH"
[[ "$PATH" != *"/usr/bin"* ]] && [[ -e "/usr/bin" ]] && export PATH=/usr/bin:"$PATH"
[[ "$PATH" != *"/bin:"* ]] && [[ -e "/bin" ]] && export PATH=/bin:"$PATH"

# Rotten.
_test() { false; }
_setup() { false; }
_typeDep() { true; }
_getDep() { true; }
_wantGetDep() { true; }
_if_cygwin() { false; }
_user_log-ub() { false; }
_collect() { false; }
_enter() { false; }



#### from messaging.sh


_color_demo() {
	_messagePlain_request _color_demo
	_messagePlain_nominal _color_demo
	_messagePlain_probe _color_demo
	_messagePlain_probe_expr _color_demo
	_messagePlain_probe_var ubiquitousBashIDshort
	_messagePlain_good _color_demo
	_messagePlain_warn _color_demo
	_messagePlain_bad _color_demo
	_messagePlain_probe_cmd echo _color_demo
	_messagePlain_probe_quoteAddDouble echo _color_demo
	_messagePlain_probe_quoteAddSingle echo _color_demo
	_messageNormal _color_demo
	_messageError _color_demo
	_messageDELAYipc _color_demo
	_messageProcess _color_demo
}
_color_end() {
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '</span>'
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n ' \E[0m'
}

_color_begin_request() {
	echo -e -n '\E[0;35m '
}
_color_begin_nominal() {
	echo -e -n '\E[0;36m '
}
_color_begin_probe() {
	echo -e -n '\E[0;34m '
}
_color_begin_probe_noindent() {
	echo -e -n '\E[0;34m'
}
_color_begin_good() {
	echo -e -n '\E[0;32m '
}
_color_begin_warn() {
	echo -e -n '\E[1;33m '
}
_color_begin_bad() {
	echo -e -n '\E[0;31m '
}
_color_begin_Normal() {
	echo -e -n '\E[1;32;46m '
}
_color_begin_Error() {
	echo -e -n '\E[1;33;41m '
}
_color_begin_DELAYipc() {
	echo -e -n '\E[1;33;47m '
}



#Purple. User must do something manually to proceed. NOT to be used for dependency installation requests - use probe, bad, and fail statements for that.
_messagePlain_request() {
	_color_begin_request
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Cyan. Harmless status messages.
#"generic/ubiquitousheader.sh"
_messagePlain_nominal() {
	_color_begin_nominal
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe() {
	_color_begin_probe
	#_color_begin_probe_noindent
	echo -n "$@"
	_color_end
	echo
	return 0
}
_messagePlain_probe_noindent() {
	#_color_begin_probe
	_color_begin_probe_noindent
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_expr() {
	_color_begin_probe
	echo -e -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_var() {
	_color_begin_probe
	
	echo -n "$1"'= '
	
	eval echo -e -n \$"$1"
	
	_color_end
	echo
	return 0
}
_messageVar() {
	_messagePlain_probe_var "$@"
}

#Green. Working as expected.
#"generic/ubiquitousheader.sh"
_messagePlain_good() {
	_color_begin_good
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Yellow. May or may not be a problem.
#"generic/ubiquitousheader.sh"
_messagePlain_warn() {
	_color_begin_warn
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Red. Will result in missing functionality, reduced performance, etc, but not necessarily program failure overall.
_messagePlain_bad() {
	_color_begin_bad
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#Prints "$@" and runs "$@".
# WARNING: Use with care.
_messagePlain_probe_cmd() {
	_color_begin_probe
	
	_safeEcho "$@"
	
	_color_end
	echo
	
	"$@"
	
	return
}
_messageCMD() {
	_messagePlain_probe_cmd "$@"
}

#Blue. Diagnostic instrumentation.
#Prints "$@" with quotes around every parameter.
_messagePlain_probe_quoteAddDouble() {
	_color_begin_probe
	
	_safeEcho_quoteAddDouble "$@"
	
	_color_end
	echo
	
	return
}
_messagePlain_probe_quoteAdd() {
	_messagePlain_probe_quoteAddDouble "$@"
}

#Blue. Diagnostic instrumentation.
#Prints "$@" with single quotes around every parameter.
_messagePlain_probe_quoteAddSingle() {
	_color_begin_probe
	
	_safeEcho_quoteAddSingle "$@"
	
	_color_end
	echo
	
	return
}

#Blue. Diagnostic instrumentation.
#Prints "$@" and runs "$@".
# WARNING: Use with care.
_messagePlain_probe_cmd_quoteAdd() {
	
	_messagePlain_probe_quoteAdd "$@"
	
	"$@"
	
	return
}
_messageCMD_quoteAdd() {
	_messagePlain_probe_cmd_quoteAdd "$@"
}

#Demarcate major steps.
_messageNormal() {
	_color_begin_Normal
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Demarcate major failures.
_messageError() {
	_color_begin_Error
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Demarcate need to fetch/generate dependency automatically - not a failure condition.
_messageNEED() {
	_messageNormal "NEED"
	#echo " NEED "
}

#Demarcate have dependency already, no need to fetch/generate.
_messageHAVE() {
	_messageNormal "HAVE"
	#echo " HAVE "
}

_messageWANT() {
	_messageNormal "WANT"
	#echo " WANT "
}

#Demarcate where PASS/FAIL status cannot be absolutely proven. Rarely appropriate - usual best practice is to simply progress to the next major step.
_messageDONE() {
	_messageNormal "DONE"
	#echo " DONE "
}

_messagePASS() {
	_messageNormal "PASS"
	#echo " PASS "
}

#Major failure. Program stopped.
_messageFAIL() {
	_messageError "FAIL"
	#echo " FAIL "
	_stop 1
	return 0
}

_messageWARN() {
	echo
	echo "$@"
	return 0
}

# Demarcate *any* delay performed to allow 'InterProcess-Communication' connections (perhaps including at least some network or serial port servers).
_messageDELAYipc() {
	_color_begin_DELAYipc
	echo -e -n 'delay: InterProcess-Communication'
	_color_end
	echo
}


_messageProcess() {
	local processString
	processString="$1""..."
	
	local processStringLength
	processStringLength=${#processString}
	
	local currentIteration
	currentIteration=0
	
	local padLength
	let padLength=40-"$processStringLength"
	
	[[ "$processStringLength" -gt "38" ]] && _messageNormal "$processString" && return 0
	
	_color_begin_Normal
	
	echo -n "$processString"
	
	_color_end
	
	while [[ "$currentIteration" -lt "$padLength" ]]
	do
		echo -e -n ' '
		let currentIteration="$currentIteration"+1
	done
	
	return 0
}




#echo -n
_safeEcho() {
	printf '%s' "$1"
	shift
	
	[[ "$@" == "" ]] && return 0
	
	local currentArg
	for currentArg in "$@"
	do
		printf '%s' " "
		printf '%s' "$currentArg"
	done
	return 0
}

#echo
_safeEcho_newline() {
	_safeEcho "$@"
	printf '\n'
}

_safeEcho_quoteAddSingle() {
	# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html
	while (( "$#" )); do
		_safeEcho ' '"'""$1""'"
		shift
	done
}
_safeEcho_quoteAddSingle_newline() {
	_safeEcho_quoteAddSingle "$@"
	printf '\n'
}

_safeEcho_quoteAddDouble() {
	#https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
	
	local currentCommandStringPunctuated
	local currentCommandStringParameter
	for currentCommandStringParameter in "$@"; do
		currentCommandStringParameter="${currentCommandStringParameter//\\/\\\\}"
		currentCommandStringPunctuated="$currentCommandStringPunctuated \"${currentCommandStringParameter//\"/\\\"}\""
	done
	
	_safeEcho "$currentCommandStringPunctuated"
}
_safeEcho_quoteAddDouble_newline() {
	_safeEcho_quoteAddDouble "$@"
	printf '\n'
}






#### from messaging.sh





##Parameters
#"--shell", ""
#"--profile"
#"--parent", "--embed", "--return", "--devenv"
#"--call", "--script" "--bypass"
#if [[ "$ub_import" != "" ]]
#then
	#[[ "$ub_import" != "" ]] && export ub_import="" && unset ub_import
	
	#[[ "$importScriptLocation" != "" ]] && export importScriptLocation= && unset importScriptLocation
	#[[ "$importScriptFolder" != "" ]] && export importScriptFolder= && unset importScriptFolder
#fi
#[[ "$ub_import" != "" ]] && export ub_import="" && unset ub_import
#[[ "$ub_import_param" != "" ]] && export ub_import_param="" && unset ub_import_param
#[[ "$ub_import_script" != "" ]] && export ub_import_script="" && unset ub_import_script
#[[ "$ub_loginshell" != "" ]] && export ub_loginshell="" && unset ub_loginshell
ub_import=
ub_import_param=
ub_import_script=
ub_loginshell=


# ATTENTION: Apparently (Portable) Cygwin Bash interprets correctly.
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && ub_import="true"

( [[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]] || [[ "$1" == '--compressed' ]] ) && ub_import_param="$1" && shift
( [[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]] ) && ub_loginshell="true"	#Importing ubiquitous bash into a login shell with "~/.bashrc" is the only known cause for "_getScriptAbsoluteLocation" to return a result such as "/bin/bash".
[[ "$ub_import" == "true" ]] && ! [[ "$ub_loginshell" == "true" ]] && ub_import_script="true"

_messagePlain_probe_expr '$0= '"$0"'\n ''$1= '"$1"'\n ''ub_import= '"$ub_import"'\n ''ub_import_param= '"$ub_import_param"'\n ''ub_import_script= '"$ub_import_script"'\n ''ub_loginshell= '"$ub_loginshell" | _user_log-ub

# DANGER Prohibited import from login shell. Use _setupUbiquitous, call from another script, or manually set importScriptLocation.
# WARNING Import from shell can be detected. Import from script cannot. Asserting that script has been imported is possible. Asserting that script has not been imported is not possible. Users may be protected from interactive mistakes. Script developers are NOT protected.
if [[ "$ub_import_param" == "--profile" ]]
then
	if ( [[ "$profileScriptLocation" == "" ]] ||  [[ "$profileScriptFolder" == "" ]] ) && _messagePlain_bad 'import: profile: missing: profileScriptLocation, missing: profileScriptFolder' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif ( [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]] )
then
	if ( [[ "$scriptAbsoluteLocation" == "" ]] || [[ "$scriptAbsoluteFolder" == "" ]] || [[ "$sessionid" == "" ]] ) && _messagePlain_bad 'import: parent: missing: scriptAbsoluteLocation, missing: scriptAbsoluteFolder, missing: sessionid' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || [[ "$ub_import_param" == "--compressed" ]] || ( [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] )
then
	if ( [[ "$importScriptLocation" == "" ]] || [[ "$importScriptFolder" == "" ]] ) && _messagePlain_bad 'import: call: missing: importScriptLocation, missing: importScriptFolder' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif [[ "$ub_import" != "true" ]]	#"--shell", ""
then
	_messagePlain_warn 'import: undetected: cannot determine if imported' | _user_log-ub
	true #no problem
else	#FAIL, implies [[ "$ub_import" == "true" ]]
	_messagePlain_bad 'import: fall: fail' | _user_log-ub
	return 1 >/dev/null 2>&1
	exit 1
fi

_sep() {
	echo '________________________________________'
}


# Ingredients. Debian pacakges mirror, docker images, pre-built dist/OS images, etc.
_set_ingredients() {
    export ub_INGREDIENTS=""

    local currentDriveLetter

    if ! _if_cygwin
    then
        [[ -e /mnt/ingredients/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients/ingredients && return 0

        # STRONGLY PREFERRED.
        [[ -e /mnt/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients && return 0

        # STRONGLY DISCOURAGED.
        # Do NOT create "$HOME"/core/ingredients unless for some very unexpected reason it is necessary for a non-root user to use ingredients.
        [[ -e "$HOME"/core/ingredients ]] && export ub_INGREDIENTS="$HOME"/core/ingredients && return 0

        # WSL(2) specific.
        #_if_wsl
        #uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
        if type _if_wsl > /dev/null 2>&1 && _if_wsl
        then
            [[ -e /mnt/host/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/host/z/mnt/ingredients && return 0
            [[ -e /mnt/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/z/mnt/ingredients && return 0
            [[ -e /mnt/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/c/core/ingredients && return 0
            [[ -e /mnt/host/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/host/c/core/ingredients && return 0
            #
            for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
            do
                [[ -e /mnt/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/"$currentDriveLetter"/ingredients && return 0
            done
            if [[ -e /mnt/host ]]
            then
                for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
                do
                    [[ -e /mnt/host/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/host/"$currentDriveLetter"/ingredients && return 0
                done
            fi
        fi
    fi

    if _if_cygwin
    then
        [[ -e /cygdrive/z/mnt/ingredients ]] && export ub_INGREDIENTS=/cygdrive/z/mnt/ingredients && return 0
        [[ -e /cygdrive/c/core/ingredients ]] && export ub_INGREDIENTS=/cygdrive/c/core/ingredients && return 0
        #
        for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
        do
            [[ -e /cygdrive/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/cygdrive/"$currentDriveLetter"/ingredients && return 0
        done
    fi




    [[ "$ub_INGREDIENTS" == "" ]] && return 1
    return 0
}



#####Utilities

_test_getAbsoluteLocation_sequence() {
	_start scriptLocal_mkdir_disable
	
	local testScriptLocation_actual
	local testScriptLocation
	local testScriptFolder
	
	local testLocation_actual
	local testLocation
	local testFolder
	
	#script location/folder work directories
	mkdir -p "$safeTmp"/sAL_dir
	cp "$scriptAbsoluteLocation" "$safeTmp"/sAL_dir/script
	ln -s "$safeTmp"/sAL_dir/script "$safeTmp"/sAL_dir/lnk
	[[ ! -e "$safeTmp"/sAL_dir/script ]] && _stop 1
	[[ ! -e "$safeTmp"/sAL_dir/lnk ]] && _stop 1
	
	ln -s "$safeTmp"/sAL_dir "$safeTmp"/sAL_lnk
	[[ ! -e "$safeTmp"/sAL_lnk/script ]] && _stop 1
	[[ ! -e "$safeTmp"/sAL_lnk/lnk ]] && _stop 1
	
	#_getScriptAbsoluteLocation
	testScriptLocation_actual=$("$safeTmp"/sAL_dir/script _getScriptAbsoluteLocation)
	[[ "$safeTmp"/sAL_dir/script != "$testScriptLocation_actual" ]] && echo 'crit: "$safeTmp"/sAL_dir/script != "$testScriptLocation_actual"' && _stop 1
	
	testScriptLocation=$("$safeTmp"/sAL_dir/script _getScriptAbsoluteLocation)
	[[ "$testScriptLocation" != "$testScriptLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_dir/script' && _stop 1
	testScriptLocation=$("$safeTmp"/sAL_dir/lnk _getScriptAbsoluteLocation)
	[[ "$testScriptLocation" != "$testScriptLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_dir/lnk' && _stop 1
	
	testScriptLocation=$("$safeTmp"/sAL_lnk/script _getScriptAbsoluteLocation)
	[[ "$testScriptLocation" != "$testScriptLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_lnk/script' && _stop 1
	testScriptLocation=$("$safeTmp"/sAL_lnk/lnk _getScriptAbsoluteLocation)
	[[ "$testScriptLocation" != "$testScriptLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_lnk/lnk' && _stop 1
	
	#_getScriptAbsoluteFolder
	testScriptFolder_actual=$("$safeTmp"/sAL_dir/script _getScriptAbsoluteFolder)
	[[ "$safeTmp"/sAL_dir != "$testScriptFolder_actual" ]] && echo 'crit: "$safeTmp"/sAL_dir != "$testScriptFolder_actual"' && _stop 1
	
	testScriptFolder=$("$safeTmp"/sAL_dir/script _getScriptAbsoluteFolder)
	[[ "$testScriptFolder" != "$testScriptFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_dir/script' && _stop 1
	testScriptFolder=$("$safeTmp"/sAL_dir/lnk _getScriptAbsoluteFolder)
	[[ "$testScriptFolder" != "$testScriptFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_dir/lnk' && _stop 1
	
	testScriptFolder=$("$safeTmp"/sAL_lnk/script _getScriptAbsoluteFolder)
	[[ "$testScriptFolder" != "$testScriptFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_lnk/script' && _stop 1
	testScriptFolder=$("$safeTmp"/sAL_lnk/lnk _getScriptAbsoluteFolder)
	[[ "$testScriptFolder" != "$testScriptFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_lnk/lnk' && _stop 1
	
	
	#_getAbsoluteLocation
	testLocation_actual=$("$safeTmp"/sAL_dir/script _getAbsoluteLocation "$safeTmp"/sAL_dir/script)
	[[ "$safeTmp"/sAL_dir/script != "$testLocation_actual" ]] && echo 'crit: "$safeTmp"/sAL_dir/script != "$testLocation_actual"' && _stop 1
	
	testLocation=$("$safeTmp"/sAL_dir/script _getAbsoluteLocation "$safeTmp"/sAL_dir/script)
	[[ "$testLocation" != "$testLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_dir/script' && _stop 1
	testLocation=$("$safeTmp"/sAL_dir/lnk _getAbsoluteLocation "$safeTmp"/sAL_dir/lnk)
	[[ "$testLocation" != "$testLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_dir/lnk' && _stop 1
	
	testLocation=$("$safeTmp"/sAL_lnk/script _getAbsoluteLocation "$safeTmp"/sAL_lnk/script)
	[[ "$testLocation" != "$testLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_lnk/script' && _stop 1
	testLocation=$("$safeTmp"/sAL_lnk/lnk _getAbsoluteLocation "$safeTmp"/sAL_lnk/lnk)
	[[ "$testLocation" != "$testLocation_actual" ]] && echo 'crit: ! location "$safeTmp"/sAL_lnk/lnk' && _stop 1
	
	#_getAbsoluteFolder
	testFolder_actual=$("$safeTmp"/sAL_dir/script _getAbsoluteFolder "$safeTmp"/sAL_dir/script)
	[[ "$safeTmp"/sAL_dir != "$testFolder_actual" ]] && echo 'crit: "$safeTmp"/sAL_dir != "$testFolder_actual"' && _stop 1
	
	testFolder=$("$safeTmp"/sAL_dir/script _getAbsoluteFolder "$safeTmp"/sAL_dir/script)
	[[ "$testFolder" != "$testFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_dir/script' && _stop 1
	testFolder=$("$safeTmp"/sAL_dir/lnk _getAbsoluteFolder "$safeTmp"/sAL_dir/script)
	[[ "$testFolder" != "$testFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_dir/lnk' && _stop 1
	
	testFolder=$("$safeTmp"/sAL_lnk/script _getAbsoluteFolder "$safeTmp"/sAL_lnk/script)
	[[ "$testFolder" != "$testFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_lnk/script' && _stop 1
	testFolder=$("$safeTmp"/sAL_lnk/lnk _getAbsoluteFolder "$safeTmp"/sAL_lnk/script)
	[[ "$testFolder" != "$testFolder_actual" ]] && echo 'crit: ! folder "$safeTmp"/sAL_lnk/lnk' && _stop 1
	
	_stop
}

_test_getAbsoluteLocation() {
	"$scriptAbsoluteLocation" _test_getAbsoluteLocation_sequence "$@"
	[[ "$?" != "0" ]] && _stop 1
	return 0
}

#https://unix.stackexchange.com/questions/293892/realpath-l-vs-p
_test_realpath_L_s_sequence() {
	_start scriptLocal_mkdir_disable
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	
	local testPath_actual
	local testPath
	
	mkdir -p "$safeTmp"/src
	mkdir -p "$safeTmp"/sub
	ln -s  "$safeTmp"/src "$safeTmp"/sub/lnk
	
	echo > "$safeTmp"/sub/point
	
	ln -s "$safeTmp"/sub/point "$safeTmp"/sub/lnk/ref
	
	#correct
	#"$safeTmp"/sub/ref
	#realpath -L "$safeTmp"/sub/lnk/../ref
	
	#default, wrong
	#"$safeTmp"/ref
	#realpath -P "$safeTmp"/sub/lnk/../ref
	#echo -n '>'
	#readlink -f "$safeTmp"/sub/lnk/../ref
	
	testPath_actual="$safeTmp"/sub/ref
	
	cd "$functionEntryPWD"
	testPath=$(_realpath_L "$safeTmp"/sub/lnk/../ref)
	[[ "$testPath" != "$testPath_actual" ]] && echo 'crit: ! _realpath_L' && _stop 1
	
	cd "$safeTmp"
	testPath=$(_realpath_L ./sub/lnk/../ref)
	[[ "$testPath" != "$testPath_actual" ]] && echo 'crit: ! _realpath_L' && _stop 1
	
	#correct
	#"$safeTmp"/sub/lnk/ref
	#realpath -L -s "$safeTmp"/sub/lnk/ref
	
	#default, wrong for some use cases
	#"$safeTmp"/sub/point
	#realpath -L "$safeTmp"/sub/lnk/ref
	#echo -n '>'
	#readlink -f "$safeTmp"/sub/lnk/ref
	
	testPath_actual="$safeTmp"/sub/lnk/ref
	
	cd "$functionEntryPWD"
	testPath=$(_realpath_L_s "$safeTmp"/sub/lnk/ref)
	[[ "$testPath" != "$testPath_actual" ]] && echo 'crit: ! _realpath_L_s' && _stop 1
	
	cd "$safeTmp"
	testPath=$(_realpath_L_s ./sub/lnk/ref)
	[[ "$testPath" != "$testPath_actual" ]] && echo 'crit: ! _realpath_L_s' && _stop 1
	
	
	cd "$functionEntryPWD"
	_stop
}

_test_realpath_L_s() {
	#Optional safety check. Nonconformant realpath solution should be caught by synthetic test cases.
	#_compat_realpath
	#  ! [[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && echo 'crit: missing: realpath' && _stop 1
	
	"$scriptAbsoluteLocation" _test_realpath_L_s_sequence "$@"
	[[ "$?" != "0" ]] && _stop 1
	return 0
}

_test_realpath_L() {
	_test_realpath_L_s "$@"
}

_test_realpath() {
	_test_realpath_L_s "$@"
}

_test_readlink_f_sequence() {
	_start scriptLocal_mkdir_disable
	
	echo > "$safeTmp"/realFile
	ln -s "$safeTmp"/realFile "$safeTmp"/linkA
	ln -s "$safeTmp"/linkA "$safeTmp"/linkB
	
	local currentReadlinkResult
	currentReadlinkResult=$(readlink -f "$safeTmp"/linkB)
	
	local currentReadlinkResultBasename
	currentReadlinkResultBasename=$(basename "$currentReadlinkResult")
	
	if [[ "$currentReadlinkResultBasename" != "realFile" ]]
	then
		#echo 'fail: readlink -f'
		_stop 1
	fi
	
	_stop 0
}

_test_readlink_f() {
	if ! "$scriptAbsoluteLocation" _test_readlink_f_sequence
	then
		# May fail through MSW network drive provided by '_userVBox' .
		uname -a | grep -i cygwin > /dev/null 2>&1 && echo 'warn: broken (cygwin): readlink -f' && return 1
		echo 'fail: readlink -f'
		_stop 1
	fi
	
	return 0
}

_compat_realpath() {
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	#Workaround, Mac. See https://github.com/mirage335/ubiquitous_bash/issues/1 .
	export compat_realpath_bin=/opt/local/libexec/gnubin/realpath
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	export compat_realpath_bin=$(type -p realpath)
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	export compat_realpath_bin=/bin/realpath
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	export compat_realpath_bin=/usr/bin/realpath
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	# ATTENTION
	# Command "readlink -f" or text processing can be used as fallbacks to obtain absolute path
	# https://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-osx
	
	export compat_realpath_bin=""
	return 1
}

_compat_realpath_run() {
	! _compat_realpath && return 1
	
	"$compat_realpath_bin" "$@"
}

_realpath_L() {
	if ! _compat_realpath_run -L . > /dev/null 2>&1
	then
		readlink -f "$@"
		return
	fi
	
	realpath -L "$@"
}

_realpath_L_s() {
	if ! _compat_realpath_run -L . > /dev/null 2>&1
	then
		readlink -f "$@"
		return
	fi
	
	realpath -L -s "$@"
}


_cygwin_translation_rootFileParameter() {
	if ! uname -a | grep -i cygwin > /dev/null 2>&1
	then
		echo "$0"
		return 0
	fi
	
	
	local currentScriptLocation
	currentScriptLocation="$0"
	
	# CAUTION: Lookup table is used to avoid pulling in any additional dependencies. Additionally, Cygwin apparently may ignore letter case of path .
	
	[[ "$currentScriptLocation" == 'A:'* ]] && currentScriptLocation=${currentScriptLocation/A\://cygdrive/a} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'B:'* ]] && currentScriptLocation=${currentScriptLocation/B\://cygdrive/b} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'C:'* ]] && currentScriptLocation=${currentScriptLocation/C\://cygdrive/c} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'D:'* ]] && currentScriptLocation=${currentScriptLocation/D\://cygdrive/d} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'E:'* ]] && currentScriptLocation=${currentScriptLocation/E\://cygdrive/e} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'F:'* ]] && currentScriptLocation=${currentScriptLocation/F\://cygdrive/f} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'G:'* ]] && currentScriptLocation=${currentScriptLocation/G\://cygdrive/g} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'H:'* ]] && currentScriptLocation=${currentScriptLocation/H\://cygdrive/h} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'I:'* ]] && currentScriptLocation=${currentScriptLocation/I\://cygdrive/i} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'J:'* ]] && currentScriptLocation=${currentScriptLocation/J\://cygdrive/j} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'K:'* ]] && currentScriptLocation=${currentScriptLocation/K\://cygdrive/k} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'L:'* ]] && currentScriptLocation=${currentScriptLocation/L\://cygdrive/l} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'M:'* ]] && currentScriptLocation=${currentScriptLocation/M\://cygdrive/m} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'N:'* ]] && currentScriptLocation=${currentScriptLocation/N\://cygdrive/n} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'O:'* ]] && currentScriptLocation=${currentScriptLocation/O\://cygdrive/o} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'P:'* ]] && currentScriptLocation=${currentScriptLocation/P\://cygdrive/p} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Q:'* ]] && currentScriptLocation=${currentScriptLocation/Q\://cygdrive/q} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'R:'* ]] && currentScriptLocation=${currentScriptLocation/R\://cygdrive/r} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'S:'* ]] && currentScriptLocation=${currentScriptLocation/S\://cygdrive/s} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'T:'* ]] && currentScriptLocation=${currentScriptLocation/T\://cygdrive/t} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'U:'* ]] && currentScriptLocation=${currentScriptLocation/U\://cygdrive/u} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'V:'* ]] && currentScriptLocation=${currentScriptLocation/V\://cygdrive/v} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'W:'* ]] && currentScriptLocation=${currentScriptLocation/W\://cygdrive/w} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'X:'* ]] && currentScriptLocation=${currentScriptLocation/X\://cygdrive/x} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Y:'* ]] && currentScriptLocation=${currentScriptLocation/Y\://cygdrive/y} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Z:'* ]] && currentScriptLocation=${currentScriptLocation/Z\://cygdrive/z} && echo "$currentScriptLocation" && return 0
	
	[[ "$currentScriptLocation" == 'a:'* ]] && currentScriptLocation=${currentScriptLocation/a\://cygdrive/a} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'b:'* ]] && currentScriptLocation=${currentScriptLocation/b\://cygdrive/b} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'c:'* ]] && currentScriptLocation=${currentScriptLocation/c\://cygdrive/c} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'd:'* ]] && currentScriptLocation=${currentScriptLocation/d\://cygdrive/d} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'e:'* ]] && currentScriptLocation=${currentScriptLocation/e\://cygdrive/e} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'f:'* ]] && currentScriptLocation=${currentScriptLocation/f\://cygdrive/f} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'g:'* ]] && currentScriptLocation=${currentScriptLocation/g\://cygdrive/g} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'h:'* ]] && currentScriptLocation=${currentScriptLocation/h\://cygdrive/h} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'i:'* ]] && currentScriptLocation=${currentScriptLocation/i\://cygdrive/i} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'j:'* ]] && currentScriptLocation=${currentScriptLocation/j\://cygdrive/j} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'k:'* ]] && currentScriptLocation=${currentScriptLocation/k\://cygdrive/k} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'l:'* ]] && currentScriptLocation=${currentScriptLocation/l\://cygdrive/l} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'm:'* ]] && currentScriptLocation=${currentScriptLocation/m\://cygdrive/m} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'n:'* ]] && currentScriptLocation=${currentScriptLocation/n\://cygdrive/n} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'o:'* ]] && currentScriptLocation=${currentScriptLocation/o\://cygdrive/o} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'p:'* ]] && currentScriptLocation=${currentScriptLocation/p\://cygdrive/p} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'q:'* ]] && currentScriptLocation=${currentScriptLocation/q\://cygdrive/q} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'r:'* ]] && currentScriptLocation=${currentScriptLocation/r\://cygdrive/r} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 's:'* ]] && currentScriptLocation=${currentScriptLocation/s\://cygdrive/s} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 't:'* ]] && currentScriptLocation=${currentScriptLocation/t\://cygdrive/t} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'u:'* ]] && currentScriptLocation=${currentScriptLocation/u\://cygdrive/u} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'v:'* ]] && currentScriptLocation=${currentScriptLocation/v\://cygdrive/v} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'w:'* ]] && currentScriptLocation=${currentScriptLocation/w\://cygdrive/w} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'x:'* ]] && currentScriptLocation=${currentScriptLocation/x\://cygdrive/x} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'y:'* ]] && currentScriptLocation=${currentScriptLocation/y\://cygdrive/y} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'z:'* ]] && currentScriptLocation=${currentScriptLocation/z\://cygdrive/z} && echo "$currentScriptLocation" && return 0
	
	
	echo "$currentScriptLocation" && return 0
}


#Critical prerequsites.
_getAbsolute_criticalDep() {
	#  ! type realpath > /dev/null 2>&1 && exit 1
	! type readlink > /dev/null 2>&1 && exit 1
	! type dirname > /dev/null 2>&1 && exit 1
	! type basename > /dev/null 2>&1 && exit 1
	
	#Known to succeed under BusyBox (OpenWRT), NetBSD, and common Linux variants. No known failure modes. Extra precaution.
	! readlink -f . > /dev/null 2>&1 && exit 1
	
	! echo 'qwerty123.git' | grep '\.git$' > /dev/null 2>&1 && exit 1
	echo 'qwerty1234git' | grep '\.git$' > /dev/null 2>&1 && exit 1
	
	return 0
}
#! _getAbsolute_criticalDep && exit 1
_getAbsolute_criticalDep

#Retrieves absolute path of current script, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#However, will dereference symlinks IF the script location itself is a symlink. This is to allow symlinking to scripts to function normally.
#Suitable for allowing scripts to find other scripts they depend on. May look like an ugly hack, but it has proven reliable over the years.
_getScriptAbsoluteLocation() {
	if [[ "$0" == "-"* ]]
	then
		return 1
	fi
	
	local currentScriptLocation
	currentScriptLocation="$0"
	uname -a | grep -i cygwin > /dev/null 2>&1 && type _cygwin_translation_rootFileParameter > /dev/null 2>&1 && currentScriptLocation=$(_cygwin_translation_rootFileParameter)
	
	
	local absoluteLocation
	if [[ (-e $PWD\/$currentScriptLocation) && ($currentScriptLocation != "") ]] && [[ "$currentScriptLocation" != "/"* ]]
	then
		absoluteLocation="$PWD"\/"$currentScriptLocation"
		absoluteLocation=$(_realpath_L_s "$absoluteLocation")
	else
		absoluteLocation=$(_realpath_L "$currentScriptLocation")
	fi
	
	if [[ -h "$absoluteLocation" ]]
	then
		absoluteLocation=$(readlink -f "$absoluteLocation")
		absoluteLocation=$(_realpath_L "$absoluteLocation")
	fi
	echo $absoluteLocation
}
alias getScriptAbsoluteLocation=_getScriptAbsoluteLocation

#Retrieves absolute path of current script, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for allowing scripts to find other scripts they depend on.
_getScriptAbsoluteFolder() {
	if [[ "$0" == "-"* ]]
	then
		return 1
	fi
	
	dirname "$(_getScriptAbsoluteLocation)"
}
alias getScriptAbsoluteFolder=_getScriptAbsoluteFolder

#Retrieves absolute path of parameter, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for finding absolute paths, when it is desirable not to interfere with symlink specified folder structure.
_getAbsoluteLocation() {
	if [[ "$1" == "-"* ]]
	then
		return 1
	fi
	
	if [[ "$1" == "" ]]
	then
		echo
		return
	fi
	
	local absoluteLocation
	if [[ (-e $PWD\/$1) && ($1 != "") ]] && [[ "$1" != "/"* ]]
	then
		absoluteLocation="$PWD"\/"$1"
		absoluteLocation=$(_realpath_L_s "$absoluteLocation")
	else
		absoluteLocation=$(_realpath_L "$1")
	fi
	echo "$absoluteLocation"
}
alias getAbsoluteLocation=_getAbsoluteLocation

#Retrieves absolute path of parameter, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for finding absolute paths, when it is desirable not to interfere with symlink specified folder structure.
_getAbsoluteFolder() {
	if [[ "$1" == "-"* ]]
	then
		return 1
	fi
	
	local absoluteLocation=$(_getAbsoluteLocation "$1")
	dirname "$absoluteLocation"
}
alias getAbsoluteLocation=_getAbsoluteLocation

_getScriptLinkName() {
	! [[ -e "$0" ]] && return 1
	! [[ -L "$0" ]] && return 1
	
	! type basename > /dev/null 2>&1 && return 1
	
	local scriptLinkName
	scriptLinkName=$(basename "$0")
	
	[[ "$scriptLinkName" == "" ]] && return 1
	echo "$scriptLinkName"
}

#https://unix.stackexchange.com/questions/27021/how-to-name-a-file-in-the-deepest-level-of-a-directory-tree?answertab=active#tab-top
_filter_lowestPath() {
	awk -F'/' 'NF > depth {
depth = NF;
deepest = $0;
}
END {
print deepest;
}'
}

#https://stackoverflow.com/questions/1086907/can-find-or-any-other-tool-search-for-files-breadth-first
_filter_highestPath() {
	awk -F'/' '{print "", NF, $F}' | sort -n | awk '{print $2}' | head -n 1
}

_recursion_guard() {
	! [[ -e "$1" ]] && return 1
	
	! type "$1" >/dev/null 2>&1 && return 1
	
	local launchGuardScriptAbsoluteLocation
	launchGuardScriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
	local launchGuardTestAbsoluteLocation
	launchGuardTestAbsoluteLocation=$(_getAbsoluteLocation "$1")
	[[ "$launchGuardScriptAbsoluteLocation" == "$launchGuardTestAbsoluteLocation" ]] && return 1
	
	return 0
}

#Checks whether command or function is available.
# DANGER Needed by safeRMR .
_checkDep() {
	if ! type "$1" >/dev/null 2>&1
	then
		echo "$1" missing
		_stop 1
	fi
}

_tryExec() {
	type "$1" >/dev/null 2>&1 && "$1"
}

_tryExecFull() {
	type "$1" >/dev/null 2>&1 && "$@"
}

#Fails if critical global variables point to nonexistant locations. Code may be duplicated elsewhere for extra safety.
_failExec() {
	[[ ! -e "$scriptAbsoluteLocation" ]] && return 1
	[[ ! -e "$scriptAbsoluteFolder" ]] && return 1
	return 0
}

#Portable sanity checked "rm -r" command.
# DANGER Last line of defense against catastrophic errors where "rm -r" or similar would be used!
# WARNING Not foolproof. Use to guard against systematic errors, not carelessness.
# WARNING Do NOT rely upon outside of internal programmatic usage inside script!
# WARNING Consider using this function even if program control flow can be proven safe. Redundant checks just might catch catastrophic memory errors.
#"$1" == directory to remove
_safeRMR() {
	! type _getAbsolute_criticalDep > /dev/null 2>&1 && return 1
	! _getAbsolute_criticalDep && return 1
	
	#Fail sooner, avoiding irrelevant error messages. Especially important to cases where an upstream process has already removed the "$safeTmp" directory of a downstream process which reaches "_stop" later.
	! [[ -e "$1" ]] && return 1
	
	[[ ! -e "$scriptAbsoluteLocation" ]] && return 1
	[[ ! -e "$scriptAbsoluteFolder" ]] && return 1
	_failExec || return 1
	
	#if [[ ! -e "$0" ]]
	#then
	#	return 1
	#fi
	
	if [[ "$1" == "" ]]
	then
		return 1
	fi
	
	if [[ "$1" == "/" ]]
	then
		return 1
	fi
	
	if [[ "$1" == "-"* ]]
	then
		return 1
	fi
	
	#Denylist.
	[[ "$1" == "/home" ]] && return 1
	[[ "$1" == "/home/" ]] && return 1
	[[ "$1" == "/home/$USER" ]] && return 1
	[[ "$1" == "/home/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/tmp" ]] && return 1
	[[ "$1" == "/tmp/" ]] && return 1
	
	[[ "$1" == "$HOME" ]] && return 1
	[[ "$1" == "$HOME/" ]] && return 1
	
	#Allowlist.
	local safeToRM=false
	
	local safeScriptAbsoluteFolder
	#safeScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	safeScriptAbsoluteFolder="$scriptAbsoluteFolder"
	
	[[ "$1" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	[[ "$1" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	#[[ "$1" == "/home/$USER"* ]] && safeToRM="true"
	[[ "$1" == "/tmp/"* ]] && safeToRM="true"
	
	# WARNING: Allows removal of temporary folders created by current ubiquitous bash session only.
	[[ "$sessionid" != "" ]] && [[ "$1" == *"$sessionid"* ]] && safeToRM="true"
	[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$sessionid" != "" ]] && [[ "$1" == *$(echo "$sessionid" | head -c 16)* ]] && safeToRM="true"
	#[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$1" == "$tmpSelf"* ]] && safeToRM="true"
	
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# ATTENTION: Search for verbatim warning to find related workarounds!
	if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
	then
		if [[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "" ]] && [[ "$tmpSelf" == "/cygdrive/"* ]] && [[ "$tmpSelf" == "$tmpMSW"* ]]
		then
			safeToRM="true"
		fi
	fi

	if [[ -e "$HOME"/.ubtmp ]] && uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		[[ "$1" == "$HOME"/.ubtmp/* ]] && safeToRM="true"
		[[ "$1" == "./"* ]] && [[ "$PWD" == "$HOME"/.ubtmp* ]] && safeToRM="true"
	fi
	
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#  ! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	if [[ -e "$1" ]]
	then
		#sleep 0
		#echo "$1"
		# WARNING Recommend against adding any non-portable flags.
		rm -rf "$1" > /dev/null 2>&1
	fi
}

#Portable sanity checking for less, but, dangerous, commands.
# WARNING Not foolproof. Use to guard against systematic errors, not carelessness.
# WARNING Do NOT rely upon outside of internal programmatic usage inside script!
#"$1" == file/directory path to sanity check
_safePath() {
	! type _getAbsolute_criticalDep > /dev/null 2>&1 && return 1
	! _getAbsolute_criticalDep && return 1
	
	[[ ! -e "$scriptAbsoluteLocation" ]] && return 1
	[[ ! -e "$scriptAbsoluteFolder" ]] && return 1
	_failExec || return 1
	
	#if [[ ! -e "$0" ]]
	#then
	#	return 1
	#fi
	
	if [[ "$1" == "" ]]
	then
		return 1
	fi
	
	if [[ "$1" == "/" ]]
	then
		return 1
	fi
	
	if [[ "$1" == "-"* ]]
	then
		return 1
	fi
	
	#Denylist.
	[[ "$1" == "/home" ]] && return 1
	[[ "$1" == "/home/" ]] && return 1
	[[ "$1" == "/home/$USER" ]] && return 1
	[[ "$1" == "/home/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/tmp" ]] && return 1
	[[ "$1" == "/tmp/" ]] && return 1
	
	[[ "$1" == "$HOME" ]] && return 1
	[[ "$1" == "$HOME/" ]] && return 1
	
	#Allowlist.
	local safeToRM=false
	
	local safeScriptAbsoluteFolder
	#safeScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	safeScriptAbsoluteFolder="$scriptAbsoluteFolder"
	
	[[ "$1" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	[[ "$1" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	#[[ "$1" == "/home/$USER"* ]] && safeToRM="true"
	[[ "$1" == "/tmp/"* ]] && safeToRM="true"
	
	# WARNING: Allows removal of temporary folders created by current ubiquitous bash session only.
	[[ "$sessionid" != "" ]] && [[ "$1" == *"$sessionid"* ]] && safeToRM="true"
	[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$sessionid" != "" ]] && [[ "$1" == *$(echo "$sessionid" | head -c 16)* ]] && safeToRM="true"
	#[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$1" == "$tmpSelf"* ]] && safeToRM="true"
	
	
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# ATTENTION: Search for verbatim warning to find related workarounds!
	if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
	then
		if [[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "" ]] && [[ "$tmpSelf" == "/cygdrive/"* ]] && [[ "$tmpSelf" == "$tmpMSW"* ]]
		then
			safeToRM="true"
		fi
	fi

	if [[ -e "$HOME"/.ubtmp ]] && uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		[[ "$1" == "$HOME"/.ubtmp/* ]] && safeToRM="true"
		[[ "$1" == "./"* ]] && [[ "$PWD" == "$HOME"/.ubtmp* ]] && safeToRM="true"
	fi
	
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#  ! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	if [[ -e "$1" ]]
	then
		#sleep 0
		#echo "$1"
		# WARNING Recommend against adding any non-portable flags.
		return 0
	fi
}

# DANGER Last line of defense against catastrophic errors when using "delete" flag with rsync or similar!
_safeBackup() {
	! type _getAbsolute_criticalDep > /dev/null 2>&1 && return 1
	! _getAbsolute_criticalDep && return 1
	
	[[ ! -e "$scriptAbsoluteLocation" ]] && return 1
	[[ ! -e "$scriptAbsoluteFolder" ]] && return 1
	
	#Fail sooner, avoiding irrelevant error messages. Especially important to cases where an upstream process has already removed the "$safeTmp" directory of a downstream process which reaches "_stop" later.
	! [[ -e "$1" ]] && return 1
	
	[[ "$1" == "" ]] && return 1
	[[ "$1" == "/" ]] && return 1
	[[ "$1" == "-"* ]] && return 1
	
	[[ "$1" == "/home" ]] && return 1
	[[ "$1" == "/home/" ]] && return 1
	[[ "$1" == "/home/$USER" ]] && return 1
	[[ "$1" == "/home/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/root" ]] && return 1
	[[ "$1" == "/root/" ]] && return 1
	[[ "$1" == "/root/$USER" ]] && return 1
	[[ "$1" == "/root/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/tmp" ]] && return 1
	[[ "$1" == "/tmp/" ]] && return 1
	
	[[ "$1" == "$HOME" ]] && return 1
	[[ "$1" == "$HOME/" ]] && return 1
	
	! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	return 0
}

# DANGER Last line of defense against catastrophic errors when using "delete" flag with rsync or similar!
# WARNING Intended for direct copy/paste inclusion into independent launch wrapper scripts. Kept here for redundancy as well as example and maintenance.
_command_safeBackup() {
	! type _command_getAbsolute_criticalDep > /dev/null 2>&1 && return 1
	! _command_getAbsolute_criticalDep && return 1
	
	[[ ! -e "$commandScriptAbsoluteLocation" ]] && return 1
	[[ ! -e "$commandScriptAbsoluteFolder" ]] && return 1
	
	#Fail sooner, avoiding irrelevant error messages. Especially important to cases where an upstream process has already removed the "$safeTmp" directory of a downstream process which reaches "_stop" later.
	! [[ -e "$1" ]] && return 1
	
	[[ "$1" == "" ]] && return 1
	[[ "$1" == "/" ]] && return 1
	[[ "$1" == "-"* ]] && return 1
	
	[[ "$1" == "/home" ]] && return 1
	[[ "$1" == "/home/" ]] && return 1
	[[ "$1" == "/home/$USER" ]] && return 1
	[[ "$1" == "/home/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/root" ]] && return 1
	[[ "$1" == "/root/" ]] && return 1
	[[ "$1" == "/root/$USER" ]] && return 1
	[[ "$1" == "/root/$USER/" ]] && return 1
	[[ "$1" == "/$USER" ]] && return 1
	[[ "$1" == "/$USER/" ]] && return 1
	
	[[ "$1" == "/tmp" ]] && return 1
	[[ "$1" == "/tmp/" ]] && return 1
	
	[[ "$1" == "$HOME" ]] && return 1
	[[ "$1" == "$HOME/" ]] && return 1
	
	#  ! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	return 0
}




# Suggested for files used as Inter-Process Communication (IPC) or similar indicators (eg. temporary download files recently in progress).
# Works around files that may not be deleted by 'rm -f' when expected (ie. due to Cygwin/MSW file locking).
# ATTRIBUTION-AI: OpRt_.deepseek/deepseek-r1-distill-llama-70b  2025-03-27  (partial)
_destroy_lock() {
    [[ "$1" == "" ]] && return 0

    # Fraction of   2GB part file  divided by  1MB/s optical-disc write speed   .
    local currentLockWait="1250"

    local current_anyFilesExists
    local currentFile
    
    
    local currentIteration=0
    for ((currentIteration=0; currentIteration<"$currentLockWait"; currentIteration++))
    do
        rm -f "$@" > /dev/null 2>&1

        current_anyFilesExists="false"
        for currentFile in "$@"
        do
            [[ -e "$currentFile" ]] && current_anyFilesExists="true"
        done

        if [[ "$current_anyFilesExists" == "false" ]]
        then
            return 0
            break
        fi

        # DANGER: Does NOT use _safeEcho . Do NOT use with external input!
        ( echo "STACK_FAIL STACK_FAIL STACK_FAIL: software: wait: rm: exists: file: ""$@" >&2 ) > /dev/null
        sleep 1
    done

    [[ "$currentIteration" != "0" ]] && sleep 7
    return 1
}




# Equivalent to 'mv -n' with an error exit status if file cannot be overwritten.
# https://unix.stackexchange.com/questions/248544/mv-move-file-only-if-destination-does-not-exist
_moveconfirm() {
	local currentExitStatusText
	currentExitStatusText=$(mv -vn "$1" "$2" 2>/dev/null)
	[[ "$currentExitStatusText" == "" ]] && return 1
	return 0
}


_test_moveconfirm_procedure() {
	echo > "$safeTmp"/mv_src
	echo > "$safeTmp"/mv_dst
	
	_moveconfirm "$safeTmp"/mv_src "$safeTmp"/mv_dst && return 1
	
	rm -f "$safeTmp"/mv_dst
	! _moveconfirm "$safeTmp"/mv_src "$safeTmp"/mv_dst && return 1
	
	rm -f "$safeTmp"/mv_dst
	
	return 0
}

_test_moveconfirm_sequence() {
	_start
	
	if ! _test_moveconfirm_procedure "$@"
	then
		_stop 1
	fi
	
	_stop
}

_test_moveconfirm() {
	"$scriptAbsoluteLocation" _test_moveconfirm_sequence "$@"
}


_all_exist() {
	local currentArg
	for currentArg in "$@"
	do
		! [[ -e "$currentArg" ]] && return 1
	done
	
	return 0
}

_wait_not_all_exist() {
	while ! _all_exist "$@"
	do
		sleep 0.1
	done
}

#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) } 

_condition_lines_zero() {
	local currentLineCount
	currentLineCount=$(wc -l)
	
	[[ "$currentLineCount" == 0 ]] && return 0
	return 1
}


_safe_declare_uid() {
	unset _uid
	_uid() {
		local currentLengthUID
		currentLengthUID="$1"
		[[ "$currentLengthUID" == "" ]] && currentLengthUID=18
		cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "$currentLengthUID" 2> /dev/null
		return
	}
	export -f _uid
}

#Generates semi-random alphanumeric characters, default length 18.
_uid() {
	local curentLengthUID
	local currentIteration
	currentIteration=0
	
	currentLengthUID="18"
	! [[ -z "$uidLengthPrefix" ]] && ! [[ "$uidLengthPrefix" -lt "18" ]] && currentLengthUID="$uidLengthPrefix"
	! [[ -z "$1" ]] && currentLengthUID="$1"
	
	if [[ -z "$uidLengthPrefix" ]] && [[ -z "$1" ]]
	then
		# https://stackoverflow.com/questions/32484504/using-random-to-generate-a-random-string-in-bash
		# https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
		#chars=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
		chars=bgjktwxyz23679BGJKTVWXYZ
		#for currentIteration in {1..$currentLengthUID} ; do
		for (( currentIteration=1; currentIteration<="$currentLengthUID"; currentIteration++ )) ; do
		echo -n "${chars:RANDOM%${#chars}:1}"
		done
		echo
	else
		cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "$currentLengthUID" 2> /dev/null
	fi
	return 0
}

# WARNING: Reduces uniqueness, irreversible. Multiple input characters result in same output character.
_filter_random() {
	tr 'a-z' 'bgjktwxyz''bgjktwxyz''bgjktwxyz' | tr 'A-Z' 'BGJKTVWXYZ''BGJKTVWXYZ''BGJKTVWXYZ' | tr '0-9' '23679''23679''23679' | tr -dc 'bgjktwxyz23679BGJKTVWXYZ'
}

# WARNING: Reduces uniqueness, irreversible. Multiple input characters result in same output character.
# WARNING: Not recommended for short strings (ie. not recommended for '8.3' compatibility ).
_filter_hex() {
	tr 'a-z' 'bcdf''bcdf''bcdf''bcdf''bcdf''bcdf''bcdf''bcdf' | tr 'A-Z' 'BCDF''BCDF''BCDF''BCDF''BCDF''BCDF''BCDF''BCDF' | tr '0-9' '23679''23679''23679' | tr -dc 'bcdf23679BCDF'
}

_compat_stat_c_run() {
	local functionOutput
	
	functionOutput=$(stat -c "$@" 2> /dev/null)
	[[ "$?" == "0" ]] && echo "$functionOutput" && return 0
	
	#BSD
	if stat --help 2>&1 | grep '\-f ' > /dev/null 2>&1
	then
		functionOutput=$(stat -f "$@" 2> /dev/null)
		[[ "$?" == "0" ]] && echo "$functionOutput" && return 0
	fi
	
	return 1
}

_permissions_directory_checkForPath() {
	local parameterAbsoluteLocation
	parameterAbsoluteLocation=$(_getAbsoluteLocation "$1")
	
	local checkScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	
	[[ "$parameterAbsoluteLocation" == "$PWD" ]] && ! [[ "$parameterAbsoluteLocation" == "$checkScriptAbsoluteFolder" ]] && return 1
	
	
	
	local currentParameter
	currentParameter="$1"
	
	[[ "$scriptAbsoluteFolder" == /media/"$USER"* ]] && [[ -e /media/"$USER" ]] && currentParameter=/media/"$USER"
	[[ "$scriptAbsoluteFolder" == /mnt/"$USER"* ]] && [[ -e /mnt/"$USER" ]] && currentParameter=/mnt/"$USER"
	[[ "$scriptAbsoluteFolder" == /var/run/media/"$USER"* ]] && [[ -e /var/run/media/"$USER" ]] && currentParameter=/var/run/media/"$USER"
	[[ "$scriptAbsoluteFolder" == /run/"$USER"* ]] && [[ -e /run/"$USER" ]] && currentParameter=/run/"$USER"
	
	local permissions_readout=$(_compat_stat_c_run "%a" "$currentParameter")
	
	local permissions_user
	local permissions_group
	local permissions_other
	
	permissions_user=$(echo "$permissions_readout" | cut -c 1)
	permissions_group=$(echo "$permissions_readout" | cut -c 2)
	permissions_other=$(echo "$permissions_readout" | cut -c 3)
	
	[[ "$permissions_user" -gt "7" ]] && return 1
	[[ "$permissions_group" -gt "7" ]] && return 1
	[[ "$permissions_other" -gt "5" ]] && return 1
	
	#Above checks considered sufficient in typical cases, remainder for sake of example. Return true (safe).
	return 0
	
	local permissions_uid
	local permissions_gid
	
	permissions_uid=$(_compat_stat_c_run "%u" "$currentParameter")
	permissions_gid=$(_compat_stat_c_run "%g" "$currentParameter")
	
	#Normally these variables are available through ubiqutious bash, but this permissions check may be needed earlier in that global variables setting process.
	local permissions_host_uid
	local permissions_host_gid
	
	permissions_host_uid=$(id -u)
	permissions_host_gid=$(id -g)
	
	[[ "$permissions_uid" != "$permissions_host_uid" ]] && return 1
	[[ "$permissions_uid" != "$permissions_host_gid" ]] && return 1
	
	return 0
}

#Checks whether the repository has unsafe permissions for adding binary files to path. Used as an extra safety check by "_setupUbiquitous" before adding a hook to the user's default shell environment.
_permissions_ubiquitous_repo() {
	local parameterAbsoluteLocation
	parameterAbsoluteLocation=$(_getAbsoluteLocation "$1")
	
	[[ ! -e "$parameterAbsoluteLocation" ]] && return 0
	
	! _permissions_directory_checkForPath "$parameterAbsoluteLocation" && return 1
	
	[[ -e "$parameterAbsoluteLocation"/_bin ]] && ! _permissions_directory_checkForPath "$parameterAbsoluteLocation"/_bin && return 1
	[[ -e "$parameterAbsoluteLocation"/_bundle ]] && ! _permissions_directory_checkForPath "$parameterAbsoluteLocation"/_bundle && return 1
	
	return 0
}

_test_permissions_ubiquitous-exception() {
	_if_cygwin && echo 'warn: accepted: cygwin: permissions' && return 0

	# Possible shared filesystem mount without correct permissions from the host .
	[[ -e /.dockerenv ]] && echo 'warn: accepted: docker: permissions' && return 0


	! _if_cygwin && _stop 1
	#  ! _if_cygwin && _stop "$1"
}

#Checks whether currently set "$scriptBin" and similar locations are actually safe.
# WARNING Keep in mind this is necessarily run only after PATH would already have been modified, and does not guard against threats already present on the local machine.
_test_permissions_ubiquitous() {
	[[ ! -e "$scriptAbsoluteFolder" ]] && _stop 1
	
	! _permissions_directory_checkForPath "$scriptAbsoluteFolder" && _test_permissions_ubiquitous-exception 1
	
	[[ -e "$scriptBin" ]] && ! _permissions_directory_checkForPath "$scriptBin" && _test_permissions_ubiquitous-exception 1
	[[ -e "$scriptBundle" ]] && ! _permissions_directory_checkForPath "$scriptBundle" && _test_permissions_ubiquitous-exception 1
	
	return 0
}

#Takes "$@". Places in global array variable "globalArgs".
# WARNING Adding this globalvariable to the "structure/globalvars.sh" declaration or similar to be overridden at script launch is not recommended.
#"${globalArgs[@]}"
_gather_params() {
	export globalArgs=("${@}")
}

_mustcarry() {
	grep "$1" "$2" > /dev/null 2>&1 && return 0
	
	echo "$1" >> "$2"
	return
}

#Determines if user is root. If yes, then continue. If not, exits after printing error message.
_mustBeRoot() {
if [[ $(id -u) != 0 ]]; then 
	echo "This must be run as root!"
	exit
fi
}
alias mustBeRoot=_mustBeRoot

#Determines if sudo is usable by scripts.
_mustGetSudo() {
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && return 0
	
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && exit 1
	
	return 0
}

#Determines if sudo is usable by scripts. Will not exit on failure.
_wantSudo() {
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && return 0
	
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true 2> /dev/null)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && return 1
	
	return 0
}

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
_getUUID() {
	if [[ -e /proc/sys/kernel/random/uuid ]]
	then
		cat /proc/sys/kernel/random/uuid
		return 0
	fi
	
	
	if type -p uuidgen > /dev/null 2>&1
	then
		uuidgen
		return 0
	fi
	
	# Failure. Intentionally adds extra characters to cause any tests of uuid output to fail.
	_uid 40
	return 1
}
alias getUUID=_getUUID

_embed_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

export scriptAbsoluteLocation="$scriptAbsoluteLocation"
export scriptAbsoluteFolder="$scriptAbsoluteFolder"
export sessionid="$sessionid"
. "$scriptAbsoluteLocation" --embed "\$@"
CZXWXcRMTo8EmM8i4d
}

_embed() {
	export sessionid="$1"
	"$scriptAbsoluteLocation" --embed "$@"
}

#"$@" == URL
_fetch() {
	if type axel > /dev/null 2>&1
	then
		axel "$@"
		return 0
	fi
	
	wget "$@"
	
	return 0
}

#Run command and output to terminal with colorful formatting. Controlled variant of "bash -v".
_showCommand() {
	echo -e '\E[1;32;46m $ '"$1"' \E[0m'
	"$@"
}

#Validates non-empty request.
_validateRequest() {
	echo -e -n '\E[1;32;46m Validating request '"$1"'...	\E[0m'
	[[ "$1" == "" ]] && echo -e '\E[1;33;41m BLANK \E[0m' && return 1
	echo "PASS"
	return
}

#http://www.commandlinefu.com/commands/view/3584/remove-color-codes-special-characters-with-sed
_nocolor() {
	sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}

_noFireJail() {
	if ( [[ -L /usr/local/bin/"$1" ]] && ls -l /usr/local/bin/"$1" | grep firejail > /dev/null 2>&1 ) || ( [[ -L /usr/bin/"$1" ]] && ls -l /usr/bin/"$1" | grep firejail > /dev/null 2>&1 )
	then
		 _messagePlain_bad 'conflict: firejail: '"$1"
		 return 1
	fi
	
	return 0
}

#Copy log files to "$permaLog" or current directory (default) for analysis.
_preserveLog() {
	if [[ ! -d "$permaLog" ]]
	then
		permaLog="$PWD"
	fi
	
	cp "$logTmp"/* "$permaLog"/ > /dev/null 2>&1
}

_stopwatch() {
	local currentExitStatus_bin
	local currentExitStatus_self
	
	local measureDateA
	local measureDateB
	
	measureDateA=$(date +%s%N | cut -b1-13)

	"$@"
	currentExitStatus_bin="$?"

	measureDateB=$(date +%s%N | cut -b1-13)

	bc <<< "$measureDateB - $measureDateA"
	currentExitStatus_self="$?"

	[[ "$currentExitStatus_bin" != "0" ]] && return "$currentExitStatus_bin"
	[[ "$currentExitStatus_self" != "0" ]] && return "$currentExitStatus_self"
	return 0
}

#####Shortcuts

_importShortcuts() {
	_tryExec "_resetFakeHomeEnv"
	
	if ! [[ "$PATH" == *":""$HOME""/bin"* ]] && ! [[ "$PATH" == "$HOME""/bin"* ]] && [[ -e "$HOME"/bin ]] && [[ -d "$HOME"/bin ]]
	then
		#export PATH="$PATH":"$HOME"/bin
		
		# CAUTION: Dubious workaround to prevent '/usr/local/bin/ubiquitous_bash.sh' , or '/usr/local/bin' , from overriding later program versions in '~/bin' .
		if [[ $( ( export PATH="$PATH":"$HOME"/bin ; type -p ubiquitous_bash.sh ) ) == "/usr/local/bin/ubiquitous_bash.sh" ]]
		then
			export PATH="$HOME"/bin:"$PATH"
		else
			export PATH="$PATH":"$HOME"/bin
		fi
	fi
	
	_tryExec "_visualPrompt"
	
	_tryExec "_scopePrompt"
	
	return 0
}

# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
_visualPrompt_promptCommand() {
	[[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber='0'
	#echo "$PS1_lineNumber"
	let PS1_lineNumber="$PS1_lineNumber"+1
	#export PS1_lineNumber

	PS1_lineNumberText="$PS1_lineNumber"
	if [[ "$PS1_lineNumber" == '1' ]]
	then
		# https://unix.stackexchange.com/questions/266921/is-it-possible-to-use-ansi-color-escape-codes-in-bash-here-documents
		PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\[\033[01;36m\]'1)
		#PS1_lineNumberText=$(echo -e -n '\033[01;36m'1)
	fi
}

_visualPrompt() {
	local currentHostname
	currentHostname="$HOSTNAME"
	
	[[ -e /etc/hostname ]] && export currentHostname=$(cat /etc/hostname)

	local currentHostname_concatenate

	[[ "$RUNPOD_POD_ID" != "" ]] && currentHostname_concatenate='runpod--'

	if [[ -e /info_factoryName.txt ]]
	then
		currentHostname_concatenate=$(cat /info_factoryName.txt)
		currentHostname_concatenate="$currentHostname_concatenate"'--'
	fi

	[[ "$RUNPOD_POD_ID" != "" ]] && currentHostname_concatenate="$currentHostname_concatenate""$RUNPOD_POD_ID"'--'

	[[ "$RUNPOD_PUBLIC_IP" != "" ]] && currentHostname_concatenate="$currentHostname_concatenate""$RUNPOD_PUBLIC_IP"'--'
	#if [[ "$RUNPOD_PUBLIC_IP" != "" ]]
	#then
		#export currentHostname_concatenate="$currentHostname_concatenate"$(wget -qO- https://icanhazip.com/ | tr -dc '0-9a-fA-F:.')'--'
	#fi
	
	export currentHostname="$currentHostname_concatenate""$currentHostname"
	
	
	
	export currentChroot=
	[[ "$chrootName" != "" ]] && export currentChroot="$chrootName"
	#[[ "$VIRTUAL_ENV_PROMPT" != "" ]] && export currentChroot=python_"$VIRTUAL_ENV_PROMPT"
	
	
	#+%H:%M:%S\ %Y-%m-%d\ Q%q
	#+%H:%M:%S\ %b\ %d,\ %y

	#Long.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]--\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]-|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '

	#Short.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]-\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	#Truncated, 40 columns.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	
	# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
	
	#export PROMPT_COMMAND=$(declare -f _visualPrompt_promptCommand)' ; _visualPrompt_promptCommand'
	#export PROMPT_COMMAND='_visualPrompt_promptCommand () { [[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber="0"; let PS1_lineNumber="$PS1_lineNumber"+1; PS1_lineNumberText="$PS1_lineNumber"; if [[ "$PS1_lineNumber" == "1" ]]; then PS1_lineNumberText=$(echo -e -n "'"\E[1;36m"'"1"'"\E[0m"'"); fi } ; _visualPrompt_promptCommand'
	
	export -f _visualPrompt_promptCommand
	export PROMPT_COMMAND=_visualPrompt_promptCommand
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]>\[\033[00m\] '
	
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	export prompt_specialInfo=""

	# ATTRIBUTION-AI: ChatGPT o3 (high)  2025-05-06
	#We want to see 'RTX 2000 Ada 16GB' and 'RTX 4090 16GB' , not just 'RTX 2000 16GB' . Please revise.
	#
	# RTX 2000 Ada 16GB
	# RTX 2000 16GB
	#
	_filter_nvidia_smi_gpuInfo() {
		# write the capacities any way you like:
		#             ↓ commas, spaces or a mixture ↓
		local sizes='2,3,4,6,8,10,11,12,16,20,24,32,40,48,56,64,80,94,96,128,141,180,192,256,320,384,512,640,768,896,1024,1280,1536,1792,2048'

		awk -F', *' -v sizes="$sizes" '
			BEGIN {
				# accept both commas and blanks as separators
				n = split(sizes, S, /[ ,]+/)
			}
			{
				# ----- tidy up the model name -----
				name = $1
				gsub(/NVIDIA |GeForce |Laptop GPU|[[:space:]]+Generation/, "", name)
				gsub(/  +/, " ", name)
				sub(/^ +| +$/, "", name)

				# ----- MiB -> decimal GB -----
				mib   = $2 + 0
				bytes = mib * 1048576
				decGB = bytes / 1e9     # decimal gigabytes

				# pick the nearest marketing size
				best = S[1]
				diff = (decGB > S[1] ? decGB - S[1] : S[1] - decGB)

				for (i = 2; i <= n; i++) {
					d = (decGB > S[i] ? decGB - S[i] : S[i] - decGB)
					if (d < diff) { diff = d; best = S[i] }
				}

				printf "%s %dGB\n", name, best
			}'
	}


	if type nvidia-smi > /dev/null 2>&1
	then
		export prompt_specialInfo=$(
			nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | _filter_nvidia_smi_gpuInfo
		)
	fi

	if _if_wsl && [[ -e "/mnt/c/Windows/System32/cmd.exe" ]] && /mnt/c/Windows/System32/cmd.exe /C where nvidia-smi > /dev/null 2>&1
	then
		export prompt_specialInfo=$(
			( cd /mnt/c ; /mnt/c/Windows/System32/cmd.exe /C nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits 2>/dev/null | _filter_nvidia_smi_gpuInfo )
		)
	fi

	if [[ "$SHELL" == *"/nix/store/"*"/bin/bash"* ]]
	then
		export prompt_specialInfo="nixShell"
	fi
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	
	#if _if_cygwin
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#else
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	#fi
	
	# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
	# Slightly darker yellow will be more printable on white background (ie. Pandoc rendering from HTML from asciinema cat ).
	#01;33m
	#38;5;214m
	#
	#\[\033[01;33m\]
	#'\[\e[01;33m\e[38;5;214m\]'
	#'\[\033[01;33m\033[38;5;214m\]'
	if _if_cygwin
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	else
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	fi
	
	#export PS1="$prompt_specialInfo""$PS1"
}


_request_visualPrompt() {
	_messagePlain_request 'export profileScriptLocation="'"$scriptAbsoluteLocation"'"'
	_messagePlain_request 'export profileScriptFolder="'"$scriptAbsoluteFolder"'"'
	_messagePlain_request ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
}


# CAUTION: This file is very necessarily part of 'rotten' . Do NOT move functions or rename to other files without updating the build shellcode for 'rotten' !

# Refactored from code which was very robust with fast ISP, however often failed with slower ISP, as explained by ChatGPT due to AWS S3 temporary link expiration.
# See "_ref/wget_githubRelease_internal-OBSOLETE.sh" for original code, which due to the more iterative development process at the time, may be more reliable in untested cases.

# WARNING: May be untested.

# CAUTION: WARNING: Unusually, inheritance of local variables in procedure functions is relied upon. Theoretically, this has been long tested by 'ubiquitous_bash.sh _test' .
#"$api_address_type"
#"$currentStream"
#"$currentAxelTmpFileRelative" "$currentAxelTmpFile"
#
#"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile"
#"$currentOutFile"

# WARNING: CAUTION: Many functions rely on emitting to standard output . Experiment/diagnose by copying code to override with 'ops.sh' . CAUTION: Be very careful enabling or using diagnostic output to stderr, as stderr may also be redirected by calling functions, terminal may not be present, etc.
#( echo x >&2 ) > /dev/null
#_messagePlain_probe_var page >&2 | cat /dev/null
#_messagePlain_probe_safe "current_API_page_URL= ""$current_API_page_URL" >&2 | cat /dev/null
# WARNING: Limit stderr pollution for log (including CI logs) and terminal readability , using 'tail' .
#( cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | tail -n 10
#( set -o pipefail ; false | cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | cat > /dev/null
#( set -o pipefail ; false 2> >(tail -n 10 >&2) | cat > /dev/null )

# DANGER: Use _messagePlain_probe_safe , _safeEcho , _safeEcho_newline , etc .

# CAUTION: ATTENTION: Uncommented lines add to ALL 'compiled' bash shell scripts - INCLUDING rotten_compressed.sh !
# Thus, it may be preferable to keep example code as a separate line commented at the beginning of that line, rather than a comment character after code on the same line .





# ATTENTION: 'MANDATORY_HASH == true' claim requirement can be imposed without any important effect on reliability or performance.
# In practice, such multi-part-per-file download programs as 'aria2c' may or may not have any worse integrity safety concerns than other download programs.
# NOTICE: Track record from historically imposing MANDATORY_HASH has been long enough to establish excellent confidence for imposing the requirement for this safety claim again without serious issue if necessary.
# https://www.cvedetails.com/vulnerability-list/vendor_id-12682/Haxx.html
#  'Haxx'
# https://www.cvedetails.com/vulnerability-list/vendor_id-3385/Wget.html
# https://www.cvedetails.com/vulnerability-list/vendor_id-19755/product_id-53327/Aria2-Project-Aria2.html
# https://www.cvedetails.com/vulnerability-list/vendor_id-2842/Axel.html
# ATTENTION: DANGER: Client downloading function explicitly sets 'MANDATORY_HASH == true' to claim resulting file EITHER will be checked by external hash before production use OR file is downloaded within an internal safer network (ie. GitHub Actions) using integrity guarded computers (ie. GitHub Runners). Potentially less integrity-safe downloading as multi-part-per-file parallel 'axel' 'download accelerator' style downloading can be limited to require a safety check for the MANDATORY_HASH claim.
# NOTICE: Imposing safety check for MANDATORY_HASH claim has long track record and no known use cases combine BOTH the jittery contentious internet connections over which multi-part-per-file downloading may or may not be more reliable, AND cannot test build steps without download large files to cycle the entire build completely. That is to say, ONLY CI environments would be usefully faster from not requiring a MANDATORY_HASH claim, yet CI environments can already make an integrity claim relevant for MANDATORY_HASH, and CI environments usually have high-quality internet connections not needing complex trickery to improve download reliability/speed.
#[[ "$FORCE_AXEL" != "" ]] && ( [[ "$MANDATORY_HASH" == "true" ]] )



#export FORCE_DIRECT="true"
#export FORCE_WGET="true"
#export FORCE_AXEL="4"

# Actually buffers files in progress behind completed files, in addition to downloading over multiple connections. Streaming without buffer underrun (ie. directly to packetDisc, ie. directly to optical disc) regardless of internet connection quality may require such buffer.
#export FORCE_PARALLEL="3"

# Already default. FORCE_BUFFER="true" implies FORCE_PARALLEL=3 or similar and sets FORCE_DIRECT="false". FORCE_BUFFER="false" implies and sets FORCE_DIRECT="true" .
#FORCE_BUFFER="true"

#export GH_TOKEN="..."





#_get_vmImg_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_beforeBoot_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist_beforeBoot.txt"


#_get_vmImg_ubDistBuild-live_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso"
#currentHash_bytes=$(_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt" | head -n 14 | tail -n 1 | sed 's/^.*count=$(bc <<< '"'"'//' | cut -f1 -d\  )
# write packetDisc (eg. '/dev/sr0', '/dev/dvd'*, '/dev/cdrom'*)
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n growisofs -speed=3 -dvd-compat -Z "$3"=/dev/stdin -use-the-force-luke=notray -use-the-force-luke=spare:min -use-the-force-luke=bufsize:128m
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_ubDistBuild-rootfs_sequence
#export MANDATORY_HASH="true"
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_rootfs.tar.flx" | lz4 -d -c > ./package_rootfs.tar
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"



#! "$scriptAbsoluteLocation" _wget_githubRelease_join "owner/repo" "internal" "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext"


#_wget_githubRelease_join "soaringDistributions/Llama-augment_bundle" "" "llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf"



#_wget_githubRelease-stdout
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join-stdout
#export MANDATORY_HASH="true"







#type -p gh > /dev/null 2>&1


#_wget_githubRelease_internal

#curl --no-progress-meter
#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10

## Use variables to construct the gh release download command
#local currentIteration
#currentIteration=0
#while ! [[ -e "$current_fileOut" ]] && [[ "$currentIteration" -lt 3 ]]
#do
	##gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@"
	#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10
	#! [[ -e "$current_fileOut" ]] && sleep 7
	#let currentIteration=currentIteration+1
#done
#[[ -e "$current_fileOut" ]]
#return "$?"



# ATTENTION: Override with 'ops.sh' or similar. Do NOT attempt to override with exported variables: do indeed override the function.

_set_wget_githubRelease() {
	export githubRelease_retriesMax=25
	export githubRelease_retriesWait=18
}
_set_wget_githubRelease

_set_wget_githubRelease-detect() {
	export githubRelease_retriesMax=2
	export githubRelease_retriesWait=4
}

_set_wget_githubRelease-detect-parallel() {
	export githubRelease_retriesMax=25
	export githubRelease_retriesWait=18
}

_set_curl_github_retry() {
	export curl_retries_args=( --retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600 )
}
#_set_wget_githubRelease
#unset curl_retries_args


_if_gh() {
	if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]]
	then
		( _messagePlain_probe '_if_gh: gh' >&2 ) > /dev/null
		return 0
	fi
	( _messagePlain_probe '_if_gh: NOT gh' >&2 ) > /dev/null
	return 1
}


#_wget_githubRelease-URL "owner/repo" "" "file.ext"
#_wget_githubRelease-URL "owner/repo" "latest" "file.ext"
#_wget_githubRelease-URL "owner/repo" "internal" "file.ext"
_wget_githubRelease-URL() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-URL' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-curl "$@"
		return
	fi
}
#_wget_githubRelease-URL "owner/repo" "file.ext"
_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}
#_wget_githubRelease-address "owner/repo" "" "file.ext"
#_wget_githubRelease-address "owner/repo" "latest" "file.ext"
#_wget_githubRelease-address "owner/repo" "internal" "file.ext"
_wget_githubRelease-address() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-address' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-address-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-address-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-address-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-address-curl "$@"
		return
	fi
}

#"$api_address_type" == "tagName" || "$api_address_type" == "url"
# ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
_jq_github_browser_download_address() {
	( _messagePlain_probe 'init: _jq_github_browser_download_address' >&2 ) > /dev/null
	local currentReleaseLabel="$2"
	local currentFile="$3"
	
	# 'latest'
	#  or alternatively (untested, apparently incompatible), for all tags from the 'currentData' regardless of 'currentReleaseLabel'
	if [[ "$currentReleaseLabel" == "latest" ]] || [[ "$currentReleaseLabel" == "" ]]
	then
		if [[ "$api_address_type" == "" ]] || [[ "$api_address_type" == "url" ]]
        then
            #jq -r ".assets[] | select(.name == "'"$currentFile"'") | .browser_download_url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.assets[] | select(.name == $filename) | .browser_download_url'
            return
        fi
		if [[ "$api_address_type" == "tagName" ]]
        then
            #jq -r ".tag_name"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.tag_name'
            return
        fi
		if [[ "$api_address_type" == "api_url" ]]
		then
			#jq -r ".assets[] | select(.name == "'"$currentFile"'") | .url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.assets[] | select(.name == $filename) | .url'
			return
		fi
	# eg. 'internal', 'build', etc
	else
		if [[ "$api_address_type" == "" ]] || [[ "$api_address_type" == "url" ]]
        then
            #jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .assets[] | select(.name == "'"$currentFile"'") | .browser_download_url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .assets[] | select(.name == $filename) | .browser_download_url'
            return
        fi
		if [[ "$api_address_type" == "tagName" ]]
        then
            #jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .tag_name"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .tag_name'
            return
        fi
		if [[ "$api_address_type" == "api_url" ]]
		then
			#jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .assets[] | select(.name == "'"$currentFile"'") | .url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .assets[] | select(.name == $filename) | .url'
			return
		fi
	fi
}
_curl_githubAPI_releases_page() {
	( _messagePlain_nominal "$currentStream"'\/\/\/ init: _curl_githubAPI_releases_page' >&2 ) > /dev/null
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

	local currentPageNum="$4"
	[[ "$currentPageNum" == "" ]] && currentPageNum="1"
	_messagePlain_probe_var currentPageNum >&2 | cat /dev/null
	
	local current_API_page_URL
	current_API_page_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases?per_page=100&page=""$currentPageNum"
	[[ "$currentReleaseLabel" == "latest" ]] && current_API_page_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases""/latest"
	_messagePlain_probe_safe "current_API_page_URL= ""$current_API_page_URL" >&2 | cat /dev/null

	local current_curl_args
	current_curl_args=()
	[[ "$GH_TOKEN" != "" ]] && current_curl_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	#current_curl_args+=( -H "Accept: application/octet-stream" )
	current_curl_args+=( -S )
	current_curl_args+=( -s )

    local currentFailParam="$5"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"
	current_curl_args+=( "$currentFailParam" )
	shift ; shift ; shift ; shift ; shift
	# CAUTION: Discouraged unless proven necessary. Causes delays and latency beyond "$githubRelease_retriesWait"*"$githubRelease_retriesMax" , possibly exceeding prebuffering on a single error.
	#--retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600
	#_set_curl_github_retry
	#"${curl_retries_args[@]}"
	current_curl_args+=( "$@" )

	local currentPage
	currentPage=""

	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	( _messagePlain_probe '_curl_githubAPI_releases_page: IPv6 (false)' >&2 ) > /dev/null
	# ATTENTION: IPv6 is NOT offered by GitHub API, and so usually only wastes time at best.
	#currentPage=$(curl -6 "${current_curl_args[@]}" "$current_API_page_URL")
	false
	currentExitStatus_ipv6="$?"
	if [[ "$currentExitStatus_ipv6" != "0" ]]
	then
		( _messagePlain_probe '_curl_githubAPI_releases_page: IPv4' >&2 ) > /dev/null
		[[ "$currentPage" == "" ]] && currentPage=$(curl -4 "${current_curl_args[@]}" "$current_API_page_URL")
		currentExitStatus_ipv4="$?"
	fi
	
	_safeEcho_newline "$currentPage"

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_page' >&2 ) > /dev/null
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

	[[ "$currentPage" == "" ]] && return 1
	return 0
}
# WARNING: No production use. May be untested.
#  Rapidly skips part files which are not upstream, using only a single page from the GitHub API, saving time and API calls.
# Not guaranteed reliable. Structure of this non-essential function is provider-specific, code is written ad-hoc.
# Duplicates much code from other functions:
#  '_wget_githubRelease_procedure-address-curl'
#  '_wget_githubRelease_procedure-address_fromTag-curl'
#  '_wget_githubRelease-address-backend-curl'
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join-skip soaringDistributions/ubDistBuild spring package_image.tar.flx
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join-skip soaringDistributions/ubDistBuild latest package_image.tar.flx
_curl_githubAPI_releases_join-skip() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _curl_githubAPI_releases_join-skip' >&2 ) > /dev/null
	( _messagePlain_probe_safe _curl_githubAPI_releases_join-skip "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    [[ "$GH_TOKEN" != "" ]] && local api_address_type="api_url"
	[[ "$GH_TOKEN" == "" ]] && local api_address_type="url"

	local currentPartDownload
	currentPartDownload=""

	local currentExitStatus=1

	local currentIteration=0

	#[[ "$currentPartDownload" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentPartDownload=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _curl_githubAPI_releases_join-skip: _curl_githubAPI_releases_join_procedure-skip: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _curl_githubAPI_releases_join_procedure-skip >&2 ) > /dev/null
		currentPartDownload=$(_curl_githubAPI_releases_join_procedure-skip "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentPartDownload"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join_procedure-skip soaringDistributions/ubDistBuild spring package_image.tar.flx
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join_procedure-skip soaringDistributions/ubDistBuild latest package_image.tar.flx
_curl_githubAPI_releases_join_procedure-skip() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0


	local currentPart
	local currentAddress


	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		local currentData
		local currentData_page
		
		#(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile")
		#return

		currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		currentExitStatus="$?"

		currentData="$currentData_page"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		#( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		#currentExitStatus_tmp="$?"

		# ###
		for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
		do
			currentAddress=$(set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile".part"$currentPart" | head -n 1)
			currentExitStatus_tmp="$?"

			[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"

			[[ "$currentAddress" != "" ]] && echo "$currentPart" && return 0
		done

		
		# ### ATTENTION: No part files found is not 'skip' but FAIL .
		[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null && return 1
		
		return 0
	else
		local currentData
		currentData=""
		
		local currentData_page
		currentData_page="doNotMatch"
		
		local currentIteration
		currentIteration=1
		
		# ATTRIBUTION-AI: Many-Chat 2025-03-23
		# Alternative detection of empty array, as suggested by AI LLM .
		#[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
		while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
		do
			currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
			currentExitStatus_tmp="$?"
			[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
			currentData="$currentData"'
'"$currentData_page"

            ( _messagePlain_probe "_wget_githubRelease_procedure-address-curl: ""$currentIteration" >&2 ) > /dev/null
            #( _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 >&2 ) > /dev/null
            [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

			let currentIteration=currentIteration+1
		done

		#( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		#currentExitStatus_tmp="$?"

		# ###
		for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
		do
			currentAddress=$( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile".part"$currentPart" | head -n 1 )
			currentExitStatus_tmp="$?"

			[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
			[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
			[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

			[[ "$currentAddress" != "" ]] && echo "$currentPart" && return 0
		done

		
		# ### ATTENTION: No part files found is not 'skip' but FAIL .
		[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null && return 1
		
        return 0
	fi
}
_wget_githubRelease_procedure-address-curl() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0

	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		local currentData
		local currentData_page
		
		#(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile")
		#return

		currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		currentExitStatus="$?"

		currentData="$currentData_page"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		currentExitStatus_tmp="$?"

		[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"

		# ATTENTION: Part file does NOT exist upstream. Page did NOT match 'Not Found', page NOT empty, and data NOT empty, implying repo, releaseLabel , indeed EXISTS upstream.
		# Retries/wait must NOT continue in that case - calling function must detect and either fail or skip file on empty address if appropriate.
		#[[ "$(_safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 | wc -c )" -le 0 ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null  && return 1
		
		return 0
	else
		local currentData
		currentData=""
		
		local currentData_page
		currentData_page="doNotMatch"
		
		local currentIteration
		currentIteration=1
		
		# ATTRIBUTION-AI: Many-Chat 2025-03-23
		# Alternative detection of empty array, as suggested by AI LLM .
		#[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
		while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
		do
			currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
			currentExitStatus_tmp="$?"
			[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
			currentData="$currentData"'
'"$currentData_page"

            ( _messagePlain_probe "_wget_githubRelease_procedure-address-curl: ""$currentIteration" >&2 ) > /dev/null
            #( _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 >&2 ) > /dev/null
            [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

			let currentIteration=currentIteration+1
		done

		( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		currentExitStatus_tmp="$?"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		# ATTENTION: Part file does NOT exist upstream. Page did NOT match 'Not Found', page NOT empty, and data NOT empty, implying repo, releaseLabel , indeed EXISTS upstream.
		# Retries/wait must NOT continue in that case - calling function must detect and either fail or skip file on empty address if appropriate.
		#[[ "$(_safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 | wc -c )" -le 0 ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null  && return 1
		
        return 0
	fi
}
_wget_githubRelease-address-backend-curl() {
	local currentAddress
	currentAddress=""

	local currentExitStatus=1

	local currentIteration=0

	#[[ "$currentAddress" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentAddress=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL-curl: _wget_githubRelease_procedure-address-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-address-curl >&2 ) > /dev/null
		currentAddress=$(_wget_githubRelease_procedure-address-curl "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-address-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-address-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="tagName"

    _wget_githubRelease-address-backend-curl "$@"
    return
}
_wget_githubRelease-URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}

# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-URL-curl() {
	_wget_githubRelease-skip-URL-curl "$@"
}

# WARNING: May be untested.
_wget_githubRelease-API_URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-API_URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-API_URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-API_URL-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}

# WARNING: May be untested.
# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-API_URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-API_URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-API_URL-curl() {
	_wget_githubRelease-skip-API_URL-curl "$@"
}

_wget_githubRelease_procedure-address-gh-awk() {
	#( _messagePlain_probe 'init: _wget_githubRelease_procedure-address-gh-awk' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_procedure-address-gh-awk "$@" >&2 ) > /dev/null
    local currentReleaseLabel="$2"
    #( _messagePlain_probe_var currentReleaseLabel >&2 ) > /dev/null
    
    # WARNING: Use of complex 'awk' scripts historically has seemed less resilient, less portable, less reliable.
    # ATTRIBUTION-AI: ChatGPT o1 2025-01-22 , 2025-01-27 .
	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		#gh release list -L 1
		# In theory, simply accepting single line output from gh release list (ie. -L 1) should provide the same result (in case this awk script ever breaks).
		awk '
			# Skip a header line if it appears first:
			NR == 1 && $1 == "TITLE" && $2 == "TYPE" {
				# Just move on to the next line and do nothing else
				next
			}
			
			# The real match: find the line whose second column is "Latest"
			$2 == "Latest" {
				# Print the third column (TAG NAME) and exit
				print $3
				exit
			}
		'
	else
		awk -v label="$currentReleaseLabel" '
		# For each line where the first column equals the label we are looking for...
		$1 == label {
			# If the second column is one of the known “types,” shift fields left so
			# the *real* tag moves into $2. Repeat until no more known types remain.
			while ($2 == "Latest" || $2 == "draft" || $2 == "pre-release" || $2 == "prerelease") {
			for (i=2; i<NF; i++) {
				$i = $(i+1)
			}
			NF--
			}
			# At this point, $2 is guaranteed to be the actual tag.
			print $2
		}
		'
	fi
}
# Requires "$GH_TOKEN" .
_wget_githubRelease_procedure-address-gh() {
	( _messagePlain_nominal "$currentStream"'\/\/\/ init: _wget_githubRelease_procedure-address-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_procedure-address-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

    local currentTag

	local currentExitStatus=0
	local currentExitStatus_tmp=0

    local currentIteration
    currentIteration=1

    while [[ "$currentTag" == "" ]] && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
    do
        #currentTag=$(gh release list -L 100 -R "$currentAbsoluteRepo" | sed 's/Latest//' | grep '^'"$currentReleaseLabel" | awk '{ print $2 }' | head -n 1)
        
        currentTag=$(set -o pipefail ; gh release list -L $(( $currentIteration * 100 )) -R "$currentAbsoluteRepo" | _wget_githubRelease_procedure-address-gh-awk "" "$currentReleaseLabel" "" | head -n 1)    # or pick whichever match you want
        currentExitStatus_tmp="$?"
		[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
		
        let currentIteration++
    done

    _safeEcho_newline "$currentTag"
    #_safeEcho_newline "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTag""/""$currentFile"

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-gh: pipefail: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentTag" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-gh: empty: currentTag' >&2 ) > /dev/null && return 1

    return 0
}
_wget_githubRelease-address-gh() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-address-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-address-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-address-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1

	#local currentURL
	#currentURL=""
	local currentTag
	currentTag=""

	local currentExitStatus=1

	local currentIteration=0

	#while ( [[ "$currentURL" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	while ( [[ "$currentTag" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		#currentURL=""
		currentTag=""

		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-address-gh: _wget_githubRelease_procedure-address-gh: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-address-gh >&2 ) > /dev/null
		#currentURL=$(_wget_githubRelease_procedure-address-gh "$@")
		currentTag=$(_wget_githubRelease_procedure-address-gh "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	#_safeEcho_newline "$currentURL"
	_safeEcho_newline "$currentTag"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-address-gh: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-URL-gh() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-URL-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

    local currentTag

	local currentExitStatus=1

	currentTag=$(_wget_githubRelease-address-gh "$@")
	currentExitStatus="$?"
	

	#echo "$currentTag"
    _safeEcho_newline "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTag""/""$currentFile"

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	[[ "$currentTag" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: empty: currentTag' >&2 ) > /dev/null && return 1
	
	return 0
}





# _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_download() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-curl .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _gh_download' >&2 ) > /dev/null
	
	! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentTagName="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFileParameter="$5"

	local currentOutFile="$currentFile"

	shift
	shift
	shift
	[[ "$currentOutParameter" == "--output" ]] && currentOutParameter="-O"
	[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFileParameter" && shift && shift

	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	# CAUTION: Assumed 'false' by 'rotten' !
	# (ie. 'rotten' does NOT support Cygwin/MSW)
	local currentOutFile_translated_cygwinMSW=""
	( _if_cygwin && type -p cygpath > /dev/null 2>&1 ) && ( [[ "$currentOutFile" != "" ]] && [[ "$currentOutFile" != "-" ]] ) && currentOutFile_translated_cygwinMSW=$(cygpath -w $(_getAbsoluteLocation "$currentOutFile"))

	local currentExitStatus=1

	local currentIteration
	currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _gh_download: gh release download: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		# CAUTION: Assumed 'false' by 'rotten' !
		# (ie. 'rotten' does NOT support Cygwin/MSW)
		if [[ "$currentOutFile_translated_cygwinMSW" != "" ]]
		then
			# WARNING: Apparently, 'gh release download' will throw an error with filename '/cygdrive'...'.m_axelTmp__'"$(_uid14)" .
			( _messagePlain_probe_safe gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile_translated_cygwinMSW" "$@" >&2 ) > /dev/null
			( set -o pipefail ; gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile_translated_cygwinMSW" "$@" 2> >(tail -n 30 >&2) )
			currentExitStatus="$?"
		else
			( _messagePlain_probe_safe gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile" "$@" >&2 ) > /dev/null
			( set -o pipefail ; gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile" "$@" 2> >(tail -n 30 >&2) )
			currentExitStatus="$?"
		fi

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_download: gh release download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}
#_gh_downloadURL "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTagName""/""$currentFile" "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_downloadURL() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _gh_downloadURL' >&2 ) > /dev/null
	
	! _if_gh && return 1

	# ATTRIBUTION-AI: ChatGPT GPT-4 2023-11-04 ... refactored 2025-01-22 ... .

	local currentURL="$1"
	local currentOutParameter="$2"
	local currentOutFileParameter="$3"

	[[ "$currentURL" == "" ]] && return 1

	# Use `sed` to extract the parts of the URL
	local currentAbsoluteRepo=$(echo "$currentURL" | sed -n 's|https://github.com/\([^/]*\)/\([^/]*\)/.*|\1/\2|p')
	[[ "$?" != "0" ]] && return 1
	local currentTagName=$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/\([^/]*\)/.*|\1|p')
	[[ "$?" != "0" ]] && return 1
	local currentFile=$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/[^/]*/\(.*\)|\1|p')
	[[ "$?" != "0" ]] && return 1

	local currentOutFile="$currentFile"

	shift
	[[ "$currentOutParameter" == "--output" ]] && currentOutParameter="-O"
	[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFileParameter" && shift && shift

	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile"
	##[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1
	#currentExitStatus=1

	#local currentIteration
	#currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	#while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	#do
		#if [[ "$currentIteration" != "0" ]]
		#then 
			#( _messagePlain_warn 'warn: BAD: RETRY: _gh_downloadURL: _gh_download: currentIteration != 0' >&2 ) > /dev/null
			#sleep "$githubRelease_retriesWait"
		#fi

		# CAUTION: Do NOT translate file parameter (ie. for Cygwin/MSW) for an underlying backend function (ie. '_gh_download') - that will be done by underlying backend function if at all. Similarly, also do NOT state '--clobber' or similar parameters to backend function.
		#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile"
		##[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"
		( _messagePlain_probe_safe _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@" >&2 ) > /dev/null
		_gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@"
		currentExitStatus="$?"

		#let currentIteration=currentIteration+1
	#done

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_downloadURL: _gh_download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}






#_wget_githubRelease-stdout

#_wget_githubRelease



_wget_githubRelease-stdout() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease-stdout' >&2 ) > /dev/null
	local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
	
	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	[[ "$FORCE_DIRECT" == "true" ]] && _wget_githubRelease_procedure-stdout "$@"

	# ATTENTION: /dev/null assures that stdout is not corrupted by any unexpected output that should have been sent to stderr
	[[ "$FORCE_DIRECT" != "true" ]] && _wget_githubRelease_procedure-stdout "$@" > /dev/null

	if ! [[ -e "$currentAxelTmpFile".PASS ]]
	then
		currentExitStatus=$(cat "$currentAxelTmpFile".FAIL)
		( [[ "$currentExitStatus" == "" ]] || [[ "$currentExitStatus" = "0" ]] || [[ "$currentExitStatus" = "0"* ]] ) && currentExitStatus=1
		#rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile".PASS
		#rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile".FAIL
		#rm -f "$currentAxelTmpFile" > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile"
		return "$currentExitStatus"
		#return 1
	fi
	[[ "$FORCE_DIRECT" != "true" ]] && cat "$currentAxelTmpFile"
	#rm -f "$currentAxelTmpFile" > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile"
	#rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile".PASS
	#rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile".FAIL
	return 0
}
_wget_githubRelease_procedure-stdout() {
	( _messagePlain_probe_safe _wget_githubRelease_procedure-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	if [[ "$FORCE_DIRECT" == "true" ]]
	then
		_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O - "$@"
		currentExitStatus="$?"
		if [[ "$currentExitStatus" != "0" ]]
		then
			echo > "$currentAxelTmpFile".FAIL
			return "$currentExitStatus"
		fi
		echo > "$currentAxelTmpFile".PASS
		return 0
	fi

	_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
	currentExitStatus="$?"
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
		return "$currentExitStatus"
	fi
	echo > "$currentAxelTmpFile".PASS
	return 0
}





#! "$scriptAbsoluteLocation" _wget_githubRelease_join "owner/repo" "internal" "file.ext" -O "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext" -O "file.ext"
# ATTENTION: WARNING: Warn messages correspond to inability to assuredly, effectively, use GH_TOKEN .
_wget_githubRelease() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease "$@" >&2 ) > /dev/null

	_wget_githubRelease_procedure "$@"
}
_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}
_wget_githubRelease_procedure() {
	# ATTENTION: Distinction nominally between '_wget_githubRelease' and '_wget_githubRelease_procedure' should only be necessary if a while loop retries the procedure .
	# ATTENTION: Potentially more specialized logic within download procedures should remain delegated with the responsibility to attempt retries , for now.
	# NOTICE: Several functions should already have retry logic: '_gh_download' , '_gh_downloadURL' , '_wget_githubRelease-address' , '_wget_githubRelease_procedure-curl' , '_wget_githubRelease-URL-curl' , etc .
	#( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_procedure' >&2 ) > /dev/null
	#( _messagePlain_probe_safe _wget_githubRelease_procedure "$@" >&2 ) > /dev/null

    local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

    local currentExitStatus=1

    # Discouraged .
    if [[ "$FORCE_WGET" == "true" ]]
    then
		local currentURL_typeSelected=""
        _warn_githubRelease_FORCE_WGET
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-curl
		_wget_githubRelease_loop-curl
        return "$?"
    fi

	# Discouraged . Benefits of multi-part-per-file downloading are less essential given that files are split into <2GB chunks.
	if [[ "$FORCE_AXEL" != "" ]] # && [[ "$MANDATORY_HASH" == "true" ]]
    then
		local currentURL_typeSelected=""
        ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

		[[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL==true is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && return 1

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-axel
		_wget_githubRelease_loop-axel
        return "$?"
    fi

    if _if_gh
    then
        #_wget_githubRelease-address-gh
        local currentTag=$(_wget_githubRelease-address "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        ( _messagePlain_probe _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@" >&2 ) > /dev/null
        _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@"
        currentExitStatus="$?"

        [[ "$currentExitStatus" != "0" ]] && _bad_fail_githubRelease_currentExitStatus && return "$currentExitStatus"
        [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1
        return 0
    fi

    if ! _if_gh
    then
		local currentURL_typeSelected=""
        ( _messagePlain_warn 'warn: WARNING: FALLBACK: wget/curl' >&2 ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-curl
		_wget_githubRelease_loop-curl
        return "$?"
    fi
    
    return 1
}
_wget_githubRelease_procedure-curl() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_procedure-curl' >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentURL= ""$currentURL" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutFile= ""$currentOutFile" >&2 ) > /dev/null

	# ATTENTION: Better if the loop does this only once. Resume may be possible.
	##[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	#[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

    local current_curl_args
	current_curl_args=()
	[[ "$GH_TOKEN" != "" ]] && current_curl_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	current_curl_args+=( -H "Accept: application/octet-stream" )
	current_curl_args+=( -S )
	current_curl_args+=( -s )
	#current_curl_args+=( --clobber )
	current_curl_args+=( --continue-at - )

    local currentFailParam="$1"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"
	current_curl_args+=( "$currentFailParam" )
	shift
	# ATTENTION: Usually '_wget_githubRelease_procedure-curl' is used ONLY through '_wget_githubRelease_loop-curl' - the total timeout is similar but the latency is much safer.
	# CAUTION: Discouraged unless proven necessary. Causes delays and latency beyond "$githubRelease_retriesWait"*"$githubRelease_retriesMax" , possibly exceeding prebuffering on a single error.
	#--retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600
	#_set_curl_github_retry
	#"${curl_retries_args[@]}"
	current_curl_args+=( "$@" )
	
	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	( _messagePlain_probe '_wget_githubRelease_procedure-curl: IPv6 (false)' >&2 ) > /dev/null
	# ATTENTION: IPv6 is NOT offered by GitHub API, and so usually only wastes time at best.
	#curl -6 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL"
	false
	# WARNING: May be untested.
	#( set -o pipefail ; curl -6 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL" 2> >(tail -n 30 >&2) )
	currentExitStatus_ipv6="$?"
	if [[ "$currentExitStatus_ipv6" != "0" ]]
	then
		( _messagePlain_probe '_wget_githubRelease_procedure-curl: IPv4' >&2 ) > /dev/null
		curl -4 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL"
		# WARNING: May be untested.
		#( set -o pipefail ; curl -4 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL" 2> >(tail -n 30 >&2) )
		currentExitStatus_ipv4="$?"
	fi

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		#( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-curl' >&2 ) > /dev/null
        _bad_fail_githubRelease_currentExitStatus
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

    [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1

    return 0
}
_wget_githubRelease_loop-curl() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-curl .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_loop-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_loop-curl "$@" >&2 ) > /dev/null

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease_procedure-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe_safe _wget_githubRelease_procedure-curl >&2 ) > /dev/null
		_wget_githubRelease_procedure-curl
		# WARNING: May be untested.
		#( set -o pipefail ; _wget_githubRelease_procedure-curl 2> >(tail -n 100 >&2) )
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_loop-curl: _wget_githubRelease_procedure-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease_procedure-axel() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_procedure-axel' >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentURL= ""$currentURL" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutFile= ""$currentOutFile" >&2 ) > /dev/null

    # ATTENTION: Quirk of aria2c , default dir is "$PWD" , is prepended to absolute paths , and the resulting '//' does not direct the absolute path to root.
    local currentOutFile_relative=$(basename "$currentOutFile")
    local currentOutDir=$(_getAbsoluteFolder "$currentOutFile")
    ( _messagePlain_probe_safe "currentOutFile_relative= ""$currentOutFile_relative" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutDir= ""$currentOutFile" >&2 ) > /dev/null

    ( _messagePlain_probe_safe "FORCE_AXEL= ""$FORCE_AXEL" >&2 ) > /dev/null

	# ATTENTION: Better if the loop does this only once. Resume may be possible.
	##[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	#[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	#aria2c --timeout=180 --max-tries=25 --retry-wait=15 "$@"
    ##_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" >&2
    ##_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
    ##messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" >&2
    ##_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
    local current_axel_args
	current_axel_args=()
	##[[ "$GH_TOKEN" != "" ]] && current_axel_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	[[ "$GH_TOKEN" != "" ]] && current_axel_args+=( --header="Authorization: token $GH_TOKEN" )
	current_axel_args+=( --header="Accept: application/octet-stream" )
	#current_axel_args+=( --quiet=true )
	#current_axel_args+=( --timeout=180 --max-tries=25 --retry-wait=15 )
    current_axel_args+=( --stderr=true --summary-interval=0 --console-log-level=error --async-dns=false )
    [[ "$FORCE_AXEL" != "" ]] && current_axel_args+=( -x "$FORCE_AXEL" )
	
	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	#( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv6' >&2 ) > /dev/null
	( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv6 (false)' >&2 ) > /dev/null
    #( _messagePlain_probe_safe aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" >&2 ) > /dev/null
	##aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL"
	## WARNING: May be untested.
	##( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
	#( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" > "$currentOutFile".log 2>&1 )
	#currentExitStatus_ipv6="$?"
	#( tail -n 40 "$currentOutFile".log >&2 )
	#rm -f "$currentOutFile".log > /dev/null 2>&1
	false
    if [[ "$currentExitStatus_ipv6" != "0" ]]
    then
        ( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv4' >&2 ) > /dev/null
        ( _messagePlain_probe_safe aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" >&2 ) > /dev/null
        #aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL"
        #( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
		( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" > "$currentOutFile".log 2>&1 )
        currentExitStatus_ipv4="$?"
		( tail -n 40 "$currentOutFile".log >&2 )
		rm -f "$currentOutFile".log > /dev/null 2>&1
    fi

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		#( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-axel' >&2 ) > /dev/null
        _bad_fail_githubRelease_currentExitStatus
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

    [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1

	# WARNING: Partial download is FAIL, but aria2c may set exit status '0' (ie. true). Return FALSE in this case.
	#if ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).aria2* > /dev/null 2>&1
	#if ls -1 "$currentAxelTmpFile".aria2* > /dev/null 2>&1
	#if ls -1 "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".aria2* > /dev/null 2>&1
	if ls -1 "$currentOutFile".aria2* > /dev/null 2>&1
	then
		return 1
	fi

	# Disabled (commented out). Contradictory state of PASS with part files remaining should terminate script with FAIL , _stop , exit , etc .
	# ie.
	##  _messagePlain_bad 'bad: FAIL: currentAxelTmpFile*: EXISTS !'
	##  _messageError 'FAIL'
	##_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).part*
	#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".part*
	##_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).aria2*
	#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".aria2*

    return 0
}
_wget_githubRelease_loop-axel() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-axel .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_loop-axel' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_loop-axel "$@" >&2 ) > /dev/null

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease_procedure-axel: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe_safe _wget_githubRelease_procedure-axel >&2 ) > /dev/null
		_wget_githubRelease_procedure-axel
		# WARNING: May be untested.
		#( set -o pipefail ; _wget_githubRelease_procedure-axel 2> >(tail -n 100 >&2) )
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_loop-axel: _wget_githubRelease_procedure-axel: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}















_wget_githubRelease_join() {
    local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	if [[ "$currentOutParameter" == "-O" ]]
	then
		shift
		shift
	fi

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"


	# ATTENTION
	currentFile=$(basename "$currentFile")




	( _messagePlain_probe_safe _wget_githubRelease_join "$@" >&2 ) > /dev/null

	_messagePlain_probe_safe _wget_githubRelease_join-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$@" '>' "$currentOutFile" >&2
	_wget_githubRelease_join-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$@" > "$currentOutFile"

	[[ ! -e "$currentOutFile" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1

	return 0
}




_wget_githubRelease_join-stdout() {
	"$scriptAbsoluteLocation" _wget_githubRelease_join_sequence-stdout "$@"
}
_wget_githubRelease_join_sequence-stdout() {
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease_join-stdout' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_join-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			#echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


    _set_wget_githubRelease "$@"


    local currentPart
    local currentSkip
    local currentStream
	local currentStream_wait
	local currentBusyStatus

	# CAUTION: Any greater than 50 is not expected to serve any purpose, may exhaust expected API rate limits, may greatly delay download, and may disrupt subsequent API requests. Any less than 50 may fall below the ~100GB capacity that is both expected necessary for some complete toolchains and at the limit of ~100GB archival quality optical disc (ie. M-Disc) .
	#local maxCurrentPart=50

	# ATTENTION: Graceful degradation to a maximum part count of 49 can be achieved by reducing API calls using the _curl_githubAPI_releases_join-skip function. That single API call can get 100 results, leaving 49 unused API calls remaining to get API_URL addresses to download 49 parts. Files larger than ~200GB are likely rare, specialized.
	#local maxCurrentPart=98

	# ATTENTION: In practice, 128GB storage media - reputable brand BD-XL near-archival quality optical disc, SSDs, etc - is the maximum file size that is convenient.
	# '1997537280' bytes truncate/tail
	# https://en.wikipedia.org/wiki/Blu-ray
	#  '128,001,769,472' ... 'Bytes'
	# https://fy.chalmers.se/~appro/linux/DVD+RW/Blu-ray/
	#  'only inner spare area of 256MB'
	local maxCurrentPart=63


    local currentExitStatus=1



    (( [[ "$FORCE_BUFFER" == "true" ]] && [[ "$FORCE_DIRECT" == "true" ]] ) || ( [[ "$FORCE_BUFFER" == "false" ]] && [[ "$FORCE_DIRECT" == "false" ]] )) && ( _messagePlain_bad 'bad: fail: FORCE_BUFFER , FORCE_DIRECT: conflict' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1

	[[ "$FORCE_PARALLEL" == "1" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
	[[ "$FORCE_PARALLEL" == "0" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
    
    [[ "$FORCE_AXEL" != "" ]] && [[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1

    [[ "$FORCE_AXEL" != "" ]] && ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null



    _if_buffer() {
        if ( [[ "$FORCE_BUFFER" == "true" ]] || [[ "$FORCE_DIRECT" == "false" ]] ) || [[ "$FORCE_BUFFER" == "" ]]
        then
            true
            return
        else
            false
            return
        fi
        true
        return
    }


    
    # WARNING: FORCE_DIRECT="true" , "FORCE_BUFFER="false" very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
    if ! _if_buffer
    then
        #export FORCE_DIRECT="true"

        _set_wget_githubRelease-detect "$@"
        currentSkip="skip"

        currentStream="noBuf"
        #local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	    #local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

		maxCurrentPart=$(_curl_githubAPI_releases_join-skip "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        currentPart=""
        for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
        do
            if [[ "$currentSkip" == "skip" ]]
            then
				# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
				#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				if [[ "$GH_TOKEN" != "" ]]
				then
					currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
					#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
					#[[ "$?" != "0" ]] && currentSkip="skip"
					[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
				else
					currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
					#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
					#[[ "$?" != "0" ]] && currentSkip="skip"
					[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
				fi
            fi
            
            [[ "$currentSkip" == "skip" ]] && continue

            
            if [[ "$currentExitStatus" == "0" ]] || [[ "$currentSkip" != "skip" ]]
            then
                _set_wget_githubRelease "$@"
                currentSkip="download"
            fi


            _wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart" -O - "$@"
            currentExitStatus="$?"
            #[[ "$currentExitStatus" != "0" ]] && break
        done

        return "$currentExitStatus"
    fi





	# ### ATTENTION: _if_buffer (IMPLICIT)

	# NOTICE: Parallel downloads may, if necessary, be adapted to first cache a list of addresses (ie. URLs) to download. API rate limits could then have as much time as possible to recover before subsequent commands (eg. analysis of builds). Such a cache must be filled with addresses BEFORE the download loop.
	#  However, at best, this can only be used with non-ephemeral 'browser_download_url' addresses .


	export currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"

	currentStream="$currentStream_min"


	currentPart="$maxCurrentPart"


	_set_wget_githubRelease-detect "$@"
	currentSkip="skip"

	maxCurrentPart=$(_curl_githubAPI_releases_join-skip "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

	currentPart=""
	for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
	do
		if [[ "$currentSkip" == "skip" ]]
		then
			# ATTENTION: EXPERIMENT
			# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
			#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
			##currentSkip=$([[ "$currentPart" -gt "17" ]] && echo 'skip' ; true)
			if [[ "$GH_TOKEN" != "" ]]
			then
				currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
				#[[ "$?" != "0" ]] && currentSkip="skip"
				[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
			else
				currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
				#[[ "$?" != "0" ]] && currentSkip="skip"
				[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
			fi
		fi
		
		[[ "$currentSkip" == "skip" ]] && continue


		#[[ "$currentExitStatus" == "0" ]] || 
		if [[ "$currentSkip" != "skip" ]]
		then
			_set_wget_githubRelease "$@"
			currentSkip="download"
			break
		fi
	done

	export currentSkipPart="$currentPart"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))

	"$scriptAbsoluteLocation" _wget_githubRelease_join_sequence-parallel "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" &


	# Prebuffer .
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  preBUFFER: WAIT  ...  currentPart='"$currentPart" >&2 ) > /dev/null
	if [[ "$currentPart" -ge "01" ]] && [[ "$currentStream_max" -ge "2" ]]
	then
		#currentStream="2"
		for currentStream in $(seq "$currentStream_min" "$currentStream_max" | sort -r)
		do
			( _messagePlain_probe 'prebuffer: currentStream= '"$currentStream" >&2 ) > /dev/null
			while ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
			do
				sleep 3
			done
		done
	fi
	currentStream="$currentStream_min"


	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  outputLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Stream must have written PASS/FAIL file .
		local currentDiagnosticIteration_outputLOOP_wait=0
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: WAIT:  P_A_S_S/F_A_I_L  ... currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
		do
			sleep 1

			let currentDiagnosticIteration_outputLOOP_wait=currentDiagnosticIteration_outputLOOP_wait+1
			if [[ "$currentDiagnosticIteration_outputLOOP_wait" -gt 15 ]]
			then
				currentDiagnosticIteration_outputLOOP_wait=0
				( _messagePlain_probe "diagnostic_outputLOOP_wait: pid: ""$!" >&2 ) > /dev/null
				# ATTRIBUTION-AI: ChatGPT 4.5-preview 2025-03-29
				#( echo "diagnostic_outputLOOP_wait: checking filenames exactly as seen by script: |$scriptAbsoluteFolder/$(_axelTmp).busy| and |$scriptAbsoluteFolder/$(_axelTmp).PASS|" >&2 ) > /dev/null
				#( ls -l "$scriptAbsoluteFolder"/$(_axelTmp).* >&2 )
				#stat "$scriptAbsoluteFolder"/$(_axelTmp).busy >&2 || ( echo 'diagnostic_outputLOOP_wait: '"stat busy - file truly doesn't exist at this name!" >&2 )
				#stat "$scriptAbsoluteFolder"/$(_axelTmp).PASS >&2 || ( echo 'diagnostic_outputLOOP_wait: '"stat PASS - file truly doesn't exist at this name!" >&2 )
			fi
		done
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: OUTPUT  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# ATTENTION: EXPERIMENT
		#status=none
		dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
		#cat "$scriptAbsoluteFolder"/$(_axelTmp)
		#dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M | pv --rate-limit 100M 2>/dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp)
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).busy

		#_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).*
		#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".*

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	true
}
_wget_githubRelease_join_sequence-parallel() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			#echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


	#export currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	#local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	# Due to parallelism , only API rate limits, NOT download speeds, are a concern with larger number of retries. 
	_set_wget_githubRelease "$@"
	#_set_wget_githubRelease-detect "$@"
	#_set_wget_githubRelease-detect-parallel "$@"
	local currentSkip="skip"
	
	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))
	
	currentStream="$currentStream_min"
	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  downloadLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Slot in use. Downloaded  "$scriptAbsoluteFolder"/$(_axelTmp)  file will be DELETED after use by calling process.
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: detect skip  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && _set_wget_githubRelease "$@" && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELAY: stagger, Inter-Process Communication, _stop  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# Staggered Delay.
		[[ "$currentPart" == "$currentSkipPart" ]] && sleep 2
		[[ "$currentPart" != "$currentSkipPart" ]] && sleep 6
		# Inter-Process Communication Delay.
		# Prevents new download from starting before previous download process has done  rm -f "$currentAxelTmpFile"*  .
		#  Beware that  rm  is inevitable or at least desirable - called by _stop() through trap, etc.
		sleep 7
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DOWNLOAD  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		export currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
		if ls -1 "$currentAxelTmpFile"* > /dev/null 2>&1
		then
			( _messagePlain_bad 'bad: FAIL: currentAxelTmpFile*: EXISTS !' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			_messageError 'FAIL' >&2
			exit 1
			return 1
		fi
		"$scriptAbsoluteLocation" _wget_githubRelease_procedure-join "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part$(printf "%02g" "$currentPart") &
		echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid

		# Stream must have written either in-progress download or PASS/FAIL file .
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 0.6
		done

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: DELETE' >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: DELETE ...  currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: WAIT PID  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).pid ]] && _pauseForProcess $(cat "$scriptAbsoluteFolder"/$(_axelTmp).pid) > /dev/null
	done
	wait >&2

	true
}
_wget_githubRelease_procedure-join() {
	( _messagePlain_probe_safe _wget_githubRelease_procedure-join "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	echo -n > "$currentAxelTmpFile".busy

	# ATTENTION: EXPERIMENT
	_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
    #dd if=/dev/zero bs=1M count=1500 > "$currentAxelTmpFile"
	#echo "$currentFile" >> "$currentAxelTmpFile"
    #dd if=/dev/urandom bs=1M count=1500 | pv --rate-limit 300M 2>/dev/null > "$currentAxelTmpFile"
	currentExitStatus="$?"

	# Inter-Process Communication Delay
	# Essentially a 'minimum download time' .
	sleep 7

	[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo -n > "$currentAxelTmpFile"
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
	fi

    while [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
    do
        sleep 1
    done

	# WARNING: Already inevitable (due to _stop , etc).
    #[[ "$currentAxelTmpFile" != "" ]] && rm -f "$currentAxelTmpFile".*
	[[ "$currentAxelTmpFile" != "" ]] && _destroy_lock "$currentAxelTmpFile".*

    #unset currentAxelTmpFile

    [[ "$currentExitStatus" == "0" ]] && return 0
    return "$currentExitStatus"
}










_warn_githubRelease_FORCE_WGET() {
    ( _messagePlain_warn 'warn: WARNING: FORCE_WGET=true' >&2 ; echo 'FORCE_WGET is a workaround. Only expected FORCE_WGET uses: low RAM , cloud testing/diagnostics .' >&2  ) > /dev/null
    return 0
}
_bad_fail_githubRelease_currentExitStatus() {
    ( _messagePlain_bad 'fail: wget_githubRelease: currentExitStatus: '"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile" >&2 ) > /dev/null
    return 0
}
_bad_fail_githubRelease_missing() {
    ( _messagePlain_bad 'fail: wget_githubRelease: missing: '"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile" >&2 ) > /dev/null
    return 0
}






_vector_wget_githubRelease-URL-gh() {
    local currentReleaseLabel="build"
    
    [[ $(
cat <<'CZXWXcRMTo8EmM8i4d' | _wget_githubRelease_procedure-address-gh-awk "" "$currentReleaseLabel" "" 2> /dev/null
TITLE  TYPE    TAG NAME             PUBLISHED        
build  Latest  build-1002-1  about 1 days ago
build          build-1001-1  about 2 days ago
CZXWXcRMTo8EmM8i4d
) == "build-1002-1
build-1001-1" ]] || ( _messagePlain_bad 'fail: bad: _wget_githubRelease_procedure-address-gh-awk' && _messageFAIL )

	return 0
}














#####Basic Variable Management

#Reset prefixes.
export tmpPrefix=""
export tmpSelf=""

# ATTENTION: CAUTION: Should only be used by a single unusual Cygwin override. Must be reset if used for any other purpose.
#export descriptiveSelf=""

#####Global variables.
#Fixed unique identifier for ubiquitous bash created global resources, such as bootdisc images to be automaticaly mounted by guests. Should NEVER be changed.
export ubiquitiousBashIDnano=uk4u
export ubiquitiousBashIDshort="$ubiquitiousBashIDnano"PhB6
export ubiquitiousBashID="$ubiquitiousBashIDshort"63kVcygT0q
export ubiquitousBashIDnano=uk4u
export ubiquitousBashIDshort="$ubiquitousBashIDnano"PhB6
export ubiquitousBashID="$ubiquitousBashIDshort"63kVcygT0q

##Parameters
#"--shell", ""
#"--profile"
#"--parent", "--return", "--devenv"
#"--call", "--script" "--bypass"
if [[ "$ub_import_param" == "--profile" ]]
then
	ub_import=true
	export scriptAbsoluteLocation="$profileScriptLocation"
	export scriptAbsoluteFolder="$profileScriptFolder"
	export sessionid=$(_uid)
	_messagePlain_probe_expr 'profile: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''profile: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''profile: sessionid= '"$sessionid" | _user_log-ub
elif ( [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]] ) && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
then
	ub_import=true
	true #Do not override.
	_messagePlain_probe_expr 'parent: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''parent: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''parent: sessionid= '"$sessionid" | _user_log-ub
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || [[ "$ub_import_param" == "--compressed" ]] || ( [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] )
then
	ub_import=true
	export scriptAbsoluteLocation="$importScriptLocation"
	export scriptAbsoluteFolder="$importScriptFolder"
	export sessionid=$(_uid)
	_messagePlain_probe_expr 'call: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''call: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''call: sessionid= '"$sessionid" | _user_log-ub
elif [[ "$ub_import" != "true" ]]	#"--shell", ""
then
	export scriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
	export scriptAbsoluteFolder=$(_getScriptAbsoluteFolder)
	export sessionid=$(_uid)
	_messagePlain_probe_expr 'default: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''default: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''default: sessionid= '"$sessionid" | _user_log-ub
else	#FAIL, implies [[ "$ub_import" == "true" ]]
	_messagePlain_bad 'import: fall: fail' | _user_log-ub
	return 1 >/dev/null 2>&1
	exit 1
fi
[[ "$importScriptLocation" != "" ]] && export importScriptLocation=
[[ "$importScriptFolder" != "" ]] && export importScriptFolder=

[[ ! -e "$scriptAbsoluteLocation" ]] && _messagePlain_bad 'missing: scriptAbsoluteLocation= '"$scriptAbsoluteLocation" | _user_log-ub && exit 1
[[ "$sessionid" == "" ]] && _messagePlain_bad 'missing: sessionid' | _user_log-ub && exit 1

#Current directory for preservation.
export outerPWD=$(_getAbsoluteLocation "$PWD")

export initPWD="$PWD"
intInitPWD="$PWD"


# DANGER: CAUTION: Undefined removal of (at least temporary) directories may be possible. Do NOT use without thorough consideration!
# Only known use is setting the temporary directory of a subsequent background process through "$scriptAbsoluteLocation" .
# EXAMPLE: _interactive_pipe() { ... }
if [[ "$ub_force_sessionid" != "" ]]
then
	sessionid="$ub_force_sessionid"
	[[ "$ub_force_sessionid_repeat" != 'true' ]] && export ub_force_sessionid=""
fi


_get_ub_globalVars_sessionDerived() {

export lowsessionid=$(echo -n "$sessionid" | tr A-Z a-z )

if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
then
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	if [[ "$tmpSelf" == "" ]]
	then
		
		export tmpMSW=$( cd "$LOCALAPPDATA" 2>/dev/null ; pwd )"/Temp"
		[[ ! -e "$tmpMSW" ]] && export tmpMSW=$( cd "$LOCALAPPDATA" 2>/dev/null ; pwd )"/faketemp"
		
		if [[ "$tmpMSW" != "" ]]
		then
			export descriptiveSelf="$sessionid"
			type md5sum > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != '/bin/'* ]] && [[ "$scriptAbsoluteLocation" != '/usr/'* ]] && export descriptiveSelf=$(_getScriptAbsoluteLocation | md5sum | head -c 2)$(echo "$sessionid" | head -c 16)
			export tmpSelf="$tmpMSW"/"$descriptiveSelf"
			
			[[ "$descriptiveSelf" == "" ]] && export tmpSelf="$tmpMSW"/"$sessionid"
			true
		fi
		
		( [[ "$tmpSelf" == "" ]] || [[ "$tmpMSW" == "" ]] ) && export tmpSelf=/tmp/"$sessionid"
		true
		
	fi

	#_override_msw_git
	type _override_msw_git_CEILING > /dev/null 2>&1 && _override_msw_git_CEILING
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]] && type _write_configure_git_safe_directory_if_admin_owned > /dev/null 2>&1
	#then
		_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
	#fi
elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1 ) || [[ -e /.dockerenv ]]
then
	if [[ "$tmpSelf" == "" ]]
	then
		export tmpWSL="$HOME"/.ubtmp
		[[ "$realHome" != "" ]] && export tmpWSL="$realHome"/.ubtmp
		[[ ! -e "$tmpWSL" ]] && mkdir -p "$tmpWSL"
		
		if [[ "$tmpWSL" != "" ]]
		then
			export descriptiveSelf="$sessionid"
			type md5sum > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != '/bin/'* ]] && [[ "$scriptAbsoluteLocation" != '/usr/'* ]] && export descriptiveSelf=$(_getScriptAbsoluteLocation | md5sum | head -c 2)$(echo "$sessionid" | head -c 16)
			export tmpSelf="$tmpWSL"/"$descriptiveSelf"

			[[ "$descriptiveSelf" == "" ]] && export tmpSelf="$tmpWSL"/"$sessionid"
			true
		fi

		( [[ "$tmpSelf" == "" ]] || [[ "$tmpWSL" == "" ]] ) && export tmpSelf=/tmp/"$sessionid"
		true
	fi
fi


# CAUTION: 'Proper' UNIX platforms are expected to use "$scriptAbsoluteFolder" as "$tmpSelf" . Only by necessity may these variables be different.
# CAUTION: If not blank, '$tmpSelf' must include first 16 digits of "$sessionid". Failure to do so may cause 'rmdir' collisions and prevent '_safeRMR' from allowing appropriate removal.
# Virtualization and OS image modification functions in particular are not guaranteed to have been otherwise tested.
[[ "$tmpSelf" == "" ]] && export tmpSelf="$scriptAbsoluteFolder"

#Temporary directories.
export safeTmp="$tmpSelf""$tmpPrefix"/w_"$sessionid"
export scopeTmp="$tmpSelf""$tmpPrefix"/s_"$sessionid"
export queryTmp="$tmpSelf""$tmpPrefix"/q_"$sessionid"
export logTmp="$safeTmp"/log
#Solely for misbehaved applications called upon.
export shortTmp=/tmp/w_"$sessionid"
[[ "$tmpMSW" != "" ]] && export shortTmp="$tmpMSW"/w_"$sessionid"

}
_get_ub_globalVars_sessionDerived "$@"






export scriptBin="$scriptAbsoluteFolder"/_bin
export scriptBundle="$scriptAbsoluteFolder"/_bundle
export scriptLib="$scriptAbsoluteFolder"/_lib
#For trivial installations and virtualized guests. Exclusively intended to support _setupUbiquitous and _drop* hooks.
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"
[[ ! -e "$scriptBundle" ]] && export scriptBundle="$scriptAbsoluteFolder"
[[ ! -e "$scriptLib" ]] && export scriptLib="$scriptAbsoluteFolder"


# WARNING: Standard relied upon by other standalone scripts (eg. MSW compatible _anchor.bat )
export scriptLocal="$scriptAbsoluteFolder"/_local

#For system installations (exclusively intended to support _setupUbiquitous and _drop* hooks).
if [[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]] || [[ "$scriptAbsoluteLocation" == "/usr/bin"* ]]
then
	[[ "$scriptAbsoluteLocation" == "/usr/bin"* ]] && export scriptBin="/usr/share/ubcore/bin"
	[[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]] && export scriptBin="/usr/local/share/ubcore/bin"
	
	if [[ -d "$HOME" ]]
	then
		export scriptLocal="$HOME"/".ubcore"/_sys
	fi
fi

export scriptCall_bash="$scriptAbsoluteFolder"'/_bash.bat'
export scriptCall_bin="$scriptAbsoluteFolder"/_bin.bat
if type cygpath > /dev/null 2>&1
then
    export scriptAbsoluteLocation_msw=$(cygpath -w "$scriptAbsoluteLocation")
    export scriptAbsoluteFolder_msw=$(cygpath -w "$scriptAbsoluteFolder")

	export scriptLocal_msw=$(cygpath -w "$scriptLocal")
    export scriptLib_msw=$(cygpath -w "$scriptLib")
    
    export scriptCall_bash_msw="$scriptAbsoluteFolder_msw"'\_bash.bat'
    export scriptCall_bin_msw="$scriptAbsoluteFolder_msw"'\_bin.bat'
fi

#Essentially temporary tokens which may need to be reused.
# No, NOT AI tokens, predates widespread usage of that term.
export scriptTokens="$scriptLocal"/.tokens

#Reboot Detection Token Storage
# WARNING WIP. Not tested on all platforms. Requires a directory to be tmp/ram fs mounted. Worst case result is to preserve tokens across reboots.
# WARNING: Does NOT work on Cygwin, files written to either '/tmp' or '/dev/shm' are persistent.
#Fail-Safe
export bootTmp="$scriptLocal"
#Typical BSD
[[ -d /tmp ]] && export bootTmp='/tmp'
#Typical Linux
[[ -d /dev/shm ]] && export bootTmp='/dev/shm'
#Typical MSW - WARNING: Persistent!
[[ "$tmpMSW" != "" ]] && export bootTmp="$tmpMSW"

#Specialized temporary directories.

#MetaEngine/Engine Tmp Defaults (example, no production use)
#export metaTmp="$tmpSelf""$tmpPrefix"/.m_"$sessionid"
#export engineTmp="$tmpSelf""$tmpPrefix"/.e_"$sessionid"

# WARNING: Only one user per (virtual) machine. Requires _prepare_abstract . Not default.
# DANGER: Mandatory strict directory 8.3 compliance for this variable! Long subdirectory/filenames permitted thereafter.
# DANGER: Permitting multi-user access to this directory may cause unexpected behavior, including inconsitent file ownership.
#Consistent absolute path abstraction.
export abstractfs_root=/tmp/"$ubiquitousBashIDnano"
( [[ "$bootTmp" == '/dev/shm' ]] || [[ "$bootTmp" == '/tmp' ]] || [[ "$tmpMSW" != "" ]] ) && export abstractfs_root="$bootTmp"/"$ubiquitousBashIDnano"
export abstractfs_lock="$bootTmp"/"$ubiquitousBashID"/afslock

# Unusually, safeTmpSSH must not be interpreted by client, and therefore is single quoted.
# TODO Test safeTmpSSH variants including spaces in path.
export safeTmpSSH='~/.sshtmp/.s_'"$sessionid"

#Process control.
export pidFile="$safeTmp"/.pid
#Invalid do-not-match default.
export uPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"

export daemonPidFile="$scriptLocal"/.bgpid

#export varStore="$scriptAbsoluteFolder"/var

export vncPasswdFile="$safeTmp"/.vncpasswd

#Network Defaults
[[ "$netTimeout" == "" ]] && export netTimeout=18

export AUTOSSH_FIRST_POLL=45
export AUTOSSH_POLL=45
#export AUTOSSH_GATETIME=0
export AUTOSSH_GATETIME=15

#export AUTOSSH_PORT=0

#export AUTOSSH_DEBUG=1
#export AUTOSSH_LOGLEVEL=7

#Monolithic shared files.
export lock_pathlock="$scriptLocal"/l_path
#Used to make locking operations atomic as possible.
export lock_quicktmp="$scriptLocal"/l_qt
export lock_emergency="$scriptLocal"/l_em
export lock_open="$scriptLocal"/l_o
export lock_opening="$scriptLocal"/l_opening
export lock_closed="$scriptLocal"/l_closed
export lock_closing="$scriptLocal"/l_closing
export lock_instance="$scriptLocal"/l_instance
export lock_instancing="$scriptLocal"/l_instancing

#Specialized lock files. Recommend five character or less suffix. Not all of these may yet be implemented.
export specialLocks
specialLocks=""

export lock_open_image="$lock_open"-img
specialLocks+=("$lock_open_image")

export lock_loop_image="$lock_open"-loop
specialLocks+=("$lock_loop_image")

export lock_open_chroot="$lock_open"-chrt
specialLocks+=("$lock_open_chroot")
export lock_open_docker="$lock_open"-dock
specialLocks+=("$lock_open_docker")
export lock_open_vbox="$lock_open"-vbox
specialLocks+=("$lock_open_vbox")
export lock_open_qemu="$lock_open"-qemu
specialLocks+=("$lock_open_qemu")

export specialLock=""
export specialLocks

export ubVirtImageLocal="true"

#Monolithic shared log files.
export importLog="$scriptLocal"/import.log

#Resource directories.
#export guidanceDir="$scriptAbsoluteFolder"/guidance

#Object Dir
export objectDir="$scriptAbsoluteFolder"

#Object Name
export objectName=$(basename "$objectDir")

#Modify PATH to include own directories.
if ! [[ "$PATH" == *":""$scriptAbsoluteFolder"* ]] && ! [[ "$PATH" == "$scriptAbsoluteFolder"* ]]
then
	export PATH="$PATH":"$scriptAbsoluteFolder":"$scriptBin":"$scriptBundle"
fi

export permaLog="$scriptLocal"

export HOST_USER_ID=$(id -u)
export HOST_GROUP_ID=$(id -g)

export globalArcDir="$scriptLocal"/a
export globalArcFS="$globalArcDir"/fs
export globalArcTmp="$globalArcDir"/tmp

export globalBuildDir="$scriptLocal"/b
export globalBuildFS="$globalBuildDir"/fs
export globalBuildTmp="$globalBuildDir"/tmp


export ub_anchor_specificSoftwareName=""
export ub_anchor_specificSoftwareName

export ub_anchor_user=""
export ub_anchor_user

export ub_anchor_autoupgrade=""
export ub_anchor_autoupgrade




#_set_GH_TOKEN() {
	#[[ "$GH_TOKEN" != "" ]] && export GH_TOKEN=$(_safeEcho "$GH_TOKEN" | tr -dc 'a-zA-Z0-9_')
	#[[ "$INPUT_GITHUB_TOKEN" != "" ]] && export INPUT_GITHUB_TOKEN=$(_safeEcho "$INPUT_GITHUB_TOKEN" | tr -dc 'a-zA-Z0-9_')
#}
#_set_GH_TOKEN


#####Local Environment Management (Resources)

#_prepare_prog() {
#	true
#}

_extra() {
	true
}

_prepare_abstract() {
	! mkdir -p "$abstractfs_root" && exit 1
	chmod 0700 "$abstractfs_root" > /dev/null 2>&1
	! chmod 700 "$abstractfs_root" && exit 1
	
	if [[ "$CI" != "" ]] && ! type chown > /dev/null 2>&1
	then
		chown() {
			true
		}
	fi
	
	if _if_cygwin
	then
		if ! chown "$USER":None "$abstractfs_root" > /dev/null 2>&1
		then
			! chown "$USER" "$abstractfs_root" && exit 1
		fi
	else
		if ! chown "$USER":"$USER" "$abstractfs_root" > /dev/null 2>&1
		then
			if [[ -e /sbin/chown ]]
			then
				! /sbin/chown "$USER" "$abstractfs_root" && exit 1
			else
				! /usr/bin/chown "$USER" "$abstractfs_root" && exit 1
			fi
		fi
	fi
	
	
	
	
	! mkdir -p "$abstractfs_lock" && exit 1
	chmod 0700 "$abstractfs_lock" > /dev/null 2>&1
	! chmod 700 "$abstractfs_lock" && exit 1
	
	if _if_cygwin
	then
		if ! chown "$USER":None "$abstractfs_lock" > /dev/null 2>&1
		then
			! chown "$USER" "$abstractfs_lock" && exit 1
		fi
	else
		if ! chown "$USER":"$USER" "$abstractfs_lock" > /dev/null 2>&1
		then
			if [[ -e /sbin/chown ]]
			then
				! /sbin/chown "$USER" "$abstractfs_lock" && exit 1
			else
				! /usr/bin/chown "$USER" "$abstractfs_lock" && exit 1
			fi
		fi
	fi
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	[[ "$*" != *scriptLocal_mkdir_disable* ]] && ! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
	# WARNING: No production use. Not guaranteed to be machine readable.
	[[ "$tmpSelf" != "$scriptAbsoluteFolder" ]] && echo "$tmpSelf" 2> /dev/null > "$scriptAbsoluteFolder"/__d_$(echo "$sessionid" | head -c 16)
	
	#_prepare_abstract
	
	_extra
	_tryExec "_prepare_prog"
}

#####Local Environment Management (Instancing)

#_start_prog() {
#	true
#}

# ATTENTION: Consider carefully, override with "ops".
# WARNING: Unfortunate, but apparently necessary, workaround for script termintaing while "sleep" or similar run under background.
_start_stty_echo() {
	#true
	
	#stty echo --file=/dev/tty > /dev/null 2>&1
	
	export ubFoundEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
}

_start() {
	_start_stty_echo
	
	_prepare "$@"
	
	#touch "$varStore"
	#. "$varStore"
	
	echo $$ > "$safeTmp"/.pid
	echo "$sessionid" > "$safeTmp"/.sessionid
	_embed_here > "$safeTmp"/.embed.sh
	chmod 755 "$safeTmp"/.embed.sh
	
	_tryExec "_start_prog"
}

#_saveVar_prog() {
#	true
#}

_saveVar() {
	true
	#declare -p varName > "$varStore"
	
	_tryExec "_saveVar_prog"
}

#_stop_prog() {
#	true
#}

# ATTENTION: Consider carefully, override with "ops".
# WARNING: Unfortunate, but apparently necessary, workaround for script termintaing while "sleep" or similar run under background.
_stop_stty_echo() {
	#true
	
	#stty echo --file=/dev/tty > /dev/null 2>&1
	
	[[ "$ubFoundEchoStatus" != "" ]] && stty --file=/dev/tty "$ubFoundEchoStatus" 2> /dev/null

	return 0
}

# DANGER: Use of "_stop" must NOT require successful "_start". Do NOT include actions which would not be safe if "_start" was not used or unsuccessful.
_stop() {
	if [[ "$ubDEBUG" == "true" ]] ; then set +x ; set +E ; set +o functrace ; set +o errtrace ; export -n SHELLOPTS 2>/dev/null || true ; trap '' RETURN ; trap - RETURN ; fi
	
	_stop_stty_echo
	
	_tryExec "_stop_prog"
	
	_tryExec "_stop_queue_page"
	_tryExec "_stop_queue_aggregatorStatic"
	
	_preserveLog
	
	#Kill process responsible for initiating session. Not expected to be used normally, but an important fallback.
	local ub_stop_pid
	if [[ -e "$safeTmp"/.pid ]]
	then
		ub_stop_pid=$(cat "$safeTmp"/.pid 2> /dev/null)
		if [[ $$ != "$ub_stop_pid" ]]
		then
			pkill -P "$ub_stop_pid" > /dev/null 2>&1
			kill "$ub_stop_pid" > /dev/null 2>&1
		fi
	fi
	#Redundant, as this usually resides in "$safeTmp".
	rm -f "$pidFile" > /dev/null 2>&1
	
	
	# https://stackoverflow.com/questions/25906020/are-pid-files-still-flawed-when-doing-it-right/25933330
	# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits
	local currentStopJobs
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	# WARNING: Although usually bad practice, it is useful for the spaces between PIDs to be interpreted in this case.
	# DANGER: Apparently, it is possible for some not running background jobs to be included in the PID list.
	[[ "$currentStopJobs" != "" ]] && kill $currentStopJobs > /dev/null 2>&1
	
	
	if [[ -e "$scopeTmp" ]] && [[ -e "$scopeTmp"/.pid ]] && [[ "$$" == $(cat "$scopeTmp"/.pid 2>/dev/null) ]]
	then
		#Symlink, or nonexistent.
		rm -f "$ub_scope" > /dev/null 2>&1
		#Only created if needed by scope.
		[[ -e "$scopeTmp" ]] && _safeRMR "$scopeTmp"
	fi
	
	#Only created if needed by query.
	[[ -e "$queryTmp" ]] && _safeRMR "$queryTmp"
	
	#Only created if needed by engine.
	[[ -e "$engineTmp" ]] && _safeRMR "$engineTmp"
	
	_tryExec _rm_instance_metaengine
	_tryExec _rm_instance_channel
	
	_safeRMR "$shortTmp"
	_safeRMR "$safeTmp"
	[[ "$fastTmp" != "" ]] && _safeRMR "$fastTmp"
	
	[[ -e "$safeTmp" ]] && sleep 0.1 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 0.3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 1 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	
	_tryExec _rm_instance_fakeHome
	
	#Optionally always try to remove any systemd shutdown hook.
	#_tryExec _unhook_systemd_shutdown
	
	[[ "$tmpSelf" != "$scriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "/" ]] && [[ -e "$tmpSelf" ]] && rmdir "$tmpSelf" > /dev/null 2>&1
	rm -f "$scriptAbsoluteFolder"/__d_$(echo "$sessionid" | head -c 16) > /dev/null 2>&1

	#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
	if [[ "$currentAxelTmpFile" != "" ]]
	then
		rm -f "$currentAxelTmpFile" > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4.aria2 > /dev/null 2>&1
			
		rm -f "$currentAxelTmpFile"* > /dev/null 2>&1
	fi

	[[ -e "$scriptLocal"/python_nix.lock ]] && [[ $(head -c $(echo -n "$sessionid" | wc -c | tr -dc '0-9') "$scriptLocal"/python_nix.lock 2> /dev/null ) == "$sessionid" ]] && rm -f "$scriptLocal"/python_nix.lock > /dev/null 2>&1
	[[ -e "$scriptLocal"/python_msw.lock ]] && [[ $(head -c $(echo -n "$sessionid" | wc -c | tr -dc '0-9') "$scriptLocal"/python_msw.lock 2> /dev/null ) == "$sessionid" ]] && rm -f "$scriptLocal"/python_msw.lock > /dev/null 2>&1
	[[ -e "$scriptLocal"/python_cygwin.lock ]] && [[ $(head -c $(echo -n "$sessionid" | wc -c | tr -dc '0-9') "$scriptLocal"/python_cygwin.lock 2> /dev/null ) == "$sessionid" ]] && rm -f "$scriptLocal"/python_cygwin.lock > /dev/null 2>&1
	
	_stop_stty_echo
	if [[ "$1" != "" ]]
	then
		exit "$1"
	else
		exit 0
	fi
}

#Do not overload this unless you know why you need it instead of _stop_prog.
#_stop_emergency_prog() {
#	true
#}

#Called upon SIGTERM or similar signal.
_stop_emergency() {
	[[ "$noEmergency" == true ]] && _stop "$1"
	
	export EMERGENCYSHUTDOWN=true
	
	#Not yet using _tryExec since this function would typically result from user intervention, or system shutdown, both emergency situations in which an error message would be ignored if not useful. Higher priority is guaranteeing execution if needed and available.
	_tryExec "_closeChRoot_emergency"
	
	#Daemon uses a separate instance, and will not be affected by previous actions, possibly even if running in the foreground.
	#jobs -p >> "$daemonPidFile" #Could derrange the correct order of descendent job termination.
	_tryExec _killDaemon
	
	_tryExec _stop_virtLocal
	
	_tryExec "_stop_emergency_prog"
	
	_stop "$1"
	
}

_waitFile() {
	
	[[ -e "$1" ]] && sleep 1
	[[ -e "$1" ]] && sleep 9
	[[ -e "$1" ]] && sleep 27
	[[ -e "$1" ]] && sleep 81
	[[ -e "$1" ]] && _return 1
	
	return 0
}

#Wrapper. If lock file is present, waits for unlocking operation to complete successfully, then reports status.
#"$1" == checkFile
#"$@" == wait command and parameters
_waitFileCommands() {
	local waitCheckFile
	waitCheckFile="$1"
	shift
	
	if [[ -e "$waitCheckFile" ]]
	then
		local waitFileCommandStatus
		
		"$@"
		
		waitFileCommandStatus="$?"
		
		if [[ "$waitFileCommandStatus" != "0" ]]
		then
			return "$waitFileCommandStatus"
		fi
		
		[[ -e "$waitCheckFile" ]] && return 1
		
	fi
	
	return 0
}

#$1 == command to execute if scriptLocal path has changed, typically remove another lock file
_pathLocked() {
	[[ ! -e "$lock_pathlock" ]] && echo "k3riC28hQRLnjgkwjI" > "$lock_pathlock"
	[[ ! -e "$lock_pathlock" ]] && return 1
	
	local lockedPath
	lockedPath=$(cat "$lock_pathlock")
	
	if [[ "$lockedPath" != "$scriptLocal" ]]
	then
		rm -f "$lock_pathlock" > /dev/null 2>&1
		[[ -e "$lock_pathlock" ]] && return 1
		
		echo "$scriptLocal" > "$lock_pathlock"
		[[ ! -e "$lock_pathlock" ]] && return 1
		
		if [[ "$1" != "" ]]
		then
			"$@"
			[[ "$?" != "0" ]] && return 1
		fi
		
	fi
	
	return 0
}

_readLocked() {
	mkdir -p "$bootTmp"
	
	local rebootToken
	rebootToken=$(cat "$1" 2> /dev/null)
	
	#Remove miscellaneous files if appropriate.
	if [[ -d "$bootTmp" ]] && ! [[ -e "$bootTmp"/"$rebootToken" ]]
	then
		rm -f "$scriptLocal"/*.log && rm -f "$scriptLocal"/imagedev && rm -f "$scriptLocal"/WARNING
		
		[[ -e "$lock_quicktmp" ]] && sleep 0.1 && [[ -e "$lock_quicktmp" ]] && rm -f "$lock_quicktmp"
	fi
	
	! [[ -e "$1" ]] && return 1
	##Lock file exists.
	
	if [[ -d "$bootTmp" ]]
	then
		if ! [[ -e "$bootTmp"/"$rebootToken" ]]
		then
			##Lock file obsolete.
			
			#Remove old lock.
			rm -f "$1" > /dev/null 2>&1
			return 1
		fi
		
		##Lock file and token exists.
		return 0
	fi
	
	##Lock file exists, token cannot be found.
	return 0
	
	
	
}

#Using _readLocked before any _createLocked operation is strongly recommended to remove any lock from prior UNIX session (ie. before latest reboot).
_createLocked() {
	[[ "$ubDEBUG" == true ]] && caller 0 >> "$scriptLocal"/lock.log
	[[ "$ubDEBUG" == true ]] && echo -e '\t'"$sessionid"'\t'"$1" >> "$scriptLocal"/lock.log
	
	mkdir -p "$bootTmp"
	
	! [[ -e "$bootTmp"/"$sessionid" ]] && echo > "$bootTmp"/"$sessionid"
	
	# WARNING Recommend setting this to a permanent value when testing critical subsystems, such as with _userChRoot related operations.
	local lockUID="$(_uid)"
	
	echo "$sessionid" > "$lock_quicktmp"_"$lockUID"
	
	mv -n "$lock_quicktmp"_"$lockUID" "$1" > /dev/null 2>&1
	
	if [[ -e "$lock_quicktmp"_"$lockUID" ]]
	then
		[[ "$ubDEBUG" == true ]] && echo -e '\t'FAIL >> "$scriptLocal"/lock.log
		rm -f "$lock_quicktmp"_"$lockUID" > /dev/null 2>&1
		return 1
	fi
	
	rm -f "$lock_quicktmp"_"$lockUID" > /dev/null 2>&1
	return 0
}

_resetLocks() {
	
	_readLocked "$lock_open"
	_readLocked "$lock_opening"
	_readLocked "$lock_closed"
	_readLocked "$lock_closing"
	_readLocked "$lock_instance"
	_readLocked "$lock_instancing"
	
}

_checkSpecialLocks() {
	local localSpecialLock
	
	localSpecialLock="$specialLock"
	[[ "$1" != "" ]] && localSpecialLock="$1"
	
	local currentLock
	
	for currentLock in "${specialLocks[@]}"
	do
		[[ "$currentLock" == "$localSpecialLock" ]] && continue
		_readLocked "$currentLock" && return 0
	done
	
	return 1
}

#Wrapper. Operates lock file for mounting shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == waitOpen function && shift
#"$@" == wrapped function and parameters
#"$specialLock" == additional lockfile to write
_open_procedure() {
	mkdir -p "$scriptLocal"
	
	if _readLocked "$lock_open"
	then
		_checkSpecialLocks && return 1
		return 0
	fi
	
	_readLocked "$lock_closing" && return 1
	
	if _readLocked "$lock_opening"
	then
		if _waitFileCommands "$lock_opening" "$1"
		then
			_readLocked "$lock_open" || return 1
			return 0
		else
			return 1
		fi
	fi
	
	_createLocked "$lock_opening" || return 1
	
	shift
	
	echo "LOCKED" > "$scriptLocal"/WARNING
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		_createLocked "$lock_open" || return 1
		
		if [[ "$specialLock" != "" ]]
		then
			_createLocked "$specialLock" || return 1
		fi
		
		rm -f "$lock_opening"
		return 0
	fi
	
	return 1
}

_open() {
	local returnStatus
	
	_open_procedure "$@"
	returnStatus="$?"
	
	export specialLock
	specialLock=""
	export specialLock
	
	return "$returnStatus"
}

#Wrapper. Operates lock file for shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == <"--force"> && shift
#"$1" == waitClose function && shift
#"$@" == wrapped function and parameters
#"$specialLock" == additional lockfile to remove
_close_procedure() {
	local closeForceEnable
	closeForceEnable=false
	
	if [[ "$1" == "--force" ]]
	then
		closeForceEnable=true
		shift
	fi
	
	if ! _readLocked "$lock_open" && [[ "$closeForceEnable" != "true" ]]
	then
		return 0
	fi
	
	if [[ "$specialLock" != "" ]] && [[ -e "$specialLock" ]] && ! _readLocked "$specialLock" && [[ "$closeForceEnable" != "true" ]]
	then
		return 1
	fi
	
	_checkSpecialLocks && return 1
	
	if _readLocked "$lock_closing" && [[ "$closeForceEnable" != "true" ]]
	then
		if _waitFileCommands "$lock_closing" "$1"
		then
			return 0
		else
			return 1
		fi
	fi
	
	if [[ "$closeForceEnable" != "true" ]]
	then
		_createLocked "$lock_closing" || return 1
	fi
	! _readLocked "$lock_closing" && _createLocked "$lock_closing"
	
	shift
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		#rm -f "$lock_open" || return 1
		rm -f "$lock_open"
		[[ -e "$lock_open" ]] && return 1
		
		if [[ "$specialLock" != "" ]] && [[ -e "$specialLock" ]]
		then
			#rm -f "$specialLock" || return 1
			rm -f "$specialLock"
			[[ -e "$specialLock" ]] && return 1
		fi
		
		rm -f "$lock_closing"
		rm -f "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
}

_close() {
	local returnStatus
	
	_close_procedure "$@"
	returnStatus="$?"
	
	export specialLock
	specialLock=""
	export specialLock
	
	return "$returnStatus"
}

#"$1" == variable name to preserve
#shift
#"$1" == variable data to preserve
#shift
#"$@" == function to prepare other variables
_preserveVar() {
	local varNameToPreserve
	varNameToPreserve="$1"
	shift
	
	local varDataToPreserve
	varDataToPreserve="$1"
	shift
	
	"$@"
	
	[[ "$varNameToPreserve" == "" ]] && return
	[[ "$varDataToPreserve" == "" ]] && return
	
	export "$varNameToPreserve"="$varDataToPreserve"
	
	return
}


#####Overrides

[[ "$isDaemon" == "true" ]] && echo "$$" | _prependDaemonPID

#May allow traps to work properly in simple scripts which do not include more comprehensive "_stop" or "_stop_emergency" implementations.
if ! type _stop > /dev/null 2>&1
then
	# ATTENTION: Consider carefully, override with "ops".
	# WARNING: Unfortunate, but apparently necessary, workaround for script termintaing while "sleep" or similar run under background.
	_stop_stty_echo() {
		#true
		
		stty echo --file=/dev/tty > /dev/null 2>&1
		
		#[[ "$ubFoundEchoStatus" != "" ]] && stty --file=/dev/tty "$ubFoundEchoStatus" 2> /dev/null

		return 0
	}
	_stop() {
		_stop_stty_echo
		
		if [[ "$1" != "" ]]
		then
			exit "$1"
		else
			exit 0
		fi
	}
fi
if ! type _stop_emergency > /dev/null 2>&1
then
	_stop_emergency() {
		_stop "$1"
	}
fi

#Traps, if script is not imported into existing shell, or bypass requested.
# WARNING Exact behavior of this system is critical to some use cases.
if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]]
then
	trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP QUIT PIPE 	# reset
	trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP QUIT PIPE 	# ignore
	
	# DANGER: Mechanism of workaround 'ub_trapSet_stop_emergency' is not fully understood, and was added undesirably late in development, with unknown effects. Nevertheless, a need for such functionality is expected to be encountered only rarely.
	# At least '_closeChRoot' , '_userChRoot' , '_userVBox' do not seem to have lost functionality.
	# DANGER: Any shell command matching ' _timeout.*&$ ' (backgrounding of _timeout) will probably be unable to reach '_stop' correctly, and may not remove temporary directories, etc.
	if [[ "$ub_trapSet_stop_emergency" != 'true' ]]
	then
		trap 'excode=$?; _stop_emergency $excode; trap - EXIT; echo $excode' INT TERM	# reset
		trap 'excode=$?; trap "" EXIT; _stop_emergency $excode; echo $excode' INT TERM	# ignore
		export ub_trapSet_stop_emergency='true'
	fi
fi

# DANGER: NEVER intended to be set in an end user shell for ANY reason.
# DANGER: Implemented to prevent 'compile.sh' from attempting to run functions from 'ops.sh'. No other valid use currently known or anticipated!
if [[ "$ub_ops_disable" != 'true' ]]
then
	# WARNING: CAUTION: Use sparingly and carefully . Allows a user to globally override functions for all 'ubiquitous_bash' scripts, projects, etc.
	if [[ -e "$HOME"/_bashrc ]]
	then
		. "$HOME"/_bashrc
	fi
	
	#Override functions with external definitions from a separate file if available.
	#if [[ -e "./ops" ]]
	#then
	#	. ./ops
	#fi

	#Override functions with external definitions from a separate file if available.
	# CAUTION: Recommend only "ops" or "ops.sh" . Using both can cause confusion.
	# ATTENTION: Recommend "ops.sh" only when unusually long. Specifically intended for "CoreAutoSSH" .
	if [[ -e "$objectDir"/ops ]]
	then
		. "$objectDir"/ops
	fi
	if [[ -e "$objectDir"/ops.sh ]]
	then
		. "$objectDir"/ops.sh
	fi
	if [[ -e "$scriptLocal"/ops ]]
	then
		. "$scriptLocal"/ops
	fi
	if [[ -e "$scriptLocal"/ops.sh ]]
	then
		. "$scriptLocal"/ops.sh
	fi
	if [[ -e "$scriptLocal"/ssh/ops ]]
	then
		. "$scriptLocal"/ssh/ops
	fi
	if [[ -e "$scriptLocal"/ssh/ops.sh ]]
	then
		. "$scriptLocal"/ssh/ops.sh
	fi

	#WILL BE OVERWRITTEN FREQUENTLY.
	#Intended for automatically generated shell code identifying usable resources, such as unused network ports. Do NOT use for serialization of internal variables (use $varStore for that).
	if [[ -e "$objectDir"/opsauto ]]
	then
		. "$objectDir"/opsauto
	fi
	if [[ -e "$scriptLocal"/opsauto ]]
	then
		. "$scriptLocal"/opsauto
	fi
	if [[ -e "$scriptLocal"/ssh/opsauto ]]
	then
		. "$scriptLocal"/ssh/opsauto
	fi
fi


# ATTENTION: May be redundantly redefined (ie. overloaded) if appropriate (eg. for use outside a 'ubiquitous_bash' environment).
_backend_override() {
	! type -f _backend > /dev/null 2>&1 && _backend() { "$@" ; unset -f _backend ; }
	_backend "$@"
}
## ...
## EXAMPLE
#! _openChRoot && _messageFAIL
## ...
#_backend() { _ubdistChRoot "$@" ; }
#_backend_override echo test
#unset -f _backend
## ...
#! _closeChRoot && _messageFAIL
## ...
## EXAMPLE
#_ubdistChRoot_backend_begin
#_backend_override echo test
#_ubdistChRoot_backend_end
## ...
## EXAMPLE
#_experiment() { _backend_override echo test ; }
#_ubdistChRoot_backend _experiment



#wsl '~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh' '_wrap' kwrite './gpl-3.0.txt'
#wsl '~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh' '_wrap' ldesk
_wrap() {
	[[ "$LANG" != "C" ]] && export LANG=C
	. "$HOME"/.ubcore/.ubcorerc
	
	_safe_declare_uid
	
	if uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		local currentArg
		local currentResult
		processedArgs=()
		for currentArg in "$@"
		do
			currentResult=$(wslpath -u "$currentArg")
			if [[ -e "$currentResult" ]]
			then
				true
			else
				currentResult="$currentArg"
			fi
			
			processedArgs+=("$currentResult")
		done
		
		
		"${processedArgs[@]}"
		return
	fi
	
	"$@"
}

#Wrapper function to launch arbitrary commands within the ubiquitous_bash environment, including its PATH with scriptBin.
_bin() {
	# Less esoteric than calling '_bash _bash', but calling '_bin _bin' is still not useful, and filtered out for Python scripts which may call either 'ubiquitous_bash.sh' or '_bash.bat' interchangeably.
	#  CAUTION: Shifting redundant '_bash' parameters is necessary for some Python scripts.
	if [[ "$1" == ${FUNCNAME[0]} ]] && [[ "$2" == ${FUNCNAME[0]} ]]
	then
		shift
		shift
	else
		[[ "$1" == ${FUNCNAME[0]} ]] && shift
	fi

	_safe_declare_uid
	
	"$@"
}
#Mostly intended to launch bash prompt for MSW/Cygwin users.
_bash() {
	# CAUTION: NEVER call _bash _bash , etc . This is different from calling '_bash "$scriptAbsoluteLocation" _bash', or '_bash -c bash -i' (not that those are known workable or useful either), cannot possibly provide any useful functionality (since 'bash' called by '_bash' is in the same environment), will only cause issues for no benefit, so don't.
	# ATTENTION: In practice, this can happen incidentally, due to calling '_bash.bat' instead of 'ubiquitous_bash.sh' to call '_bash' function, since MSW would not be able to run 'ubiquitous_bash.sh' without an anchor batch script properly calling Cygwin bash.exe . Python scripts which may call either 'ubiquitous_bash.sh' or '_bash.bat' interchangeably benefit from this, because the '_bash' parameter does not need to change depending on Native/MSW or UNIX/Linux. Since there is no useful purpose to calling '_bash _bash', etc, simply always dismissing the redundant '_bash' parameter is reasonable.
	#  CAUTION: Shifting redundant '_bash' parameters is necessary for some Python scripts.
	if [[ "$1" == "_bash" ]] && [[ "$2" == "_bash" ]]
	then
		shift
		shift
	else
		[[ "$1" == "_bash" ]] && shift
	fi

	_safe_declare_uid
	
	local currentIsCygwin
	currentIsCygwin='false'
	[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && _if_cygwin && currentIsCygwin='true'
	
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	[[ "$currentIsCygwin" == 'true' ]] && echo -n '.'
	
	
	_visualPrompt
	[[ "$ub_scope_name" != "" ]] && _scopePrompt
	
	_safe_declare_uid


	## CAUTION: Usually STUPID AND DANGEROUS . No production use. Exclusively for 'ubiquitous_bash' itself development.
	## Proper use of embedded scripts, '--embed', etc, is provided by the '_scope' functions, etc, intended for such purposes in almost all cases.
	##
	## WARNING: May be untested. May break 'python', 'bash', 'octave', etc. May break any '.bashrc', '.ubcorerc', python hooks, other hooks, etc. May break '_setupUbiquitous'.
	## Bad idea. Very specialized. Broken inheritance.
	##
	## No known use.
	## Functions, etc, are NOT inherited by bash terminal from script.
	##
	#if [[ "$1" == "--norc" ]] && [[ "$2" == "-i" ]] && [[ "$scriptAbsoluteLocation" == *"ubcore.sh" ]]
	#then
		#bash "$@"
		#return
	#fi
	
	
	[[ "$1" == '-i' ]] && shift
	
	
	_safe_declare_uid
	
	if [[ "$currentIsCygwin" == 'true' ]] && grep ubcore "$HOME"/.bashrc > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" == *"lean.sh" ]]
	then
		export sessionid=""
		export scriptAbsoluteFolder=""
		export scriptAbsoluteLocation=""
		bash -i "$@"
		return
	elif  [[ "$currentIsCygwin" == 'true' ]] && grep ubcore "$HOME"/.bashrc > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != *"lean.sh" ]]
	then
		bash -i "$@"
		return
	elif [[ "$currentIsCygwin" == 'true' ]] && ! grep ubcore "$HOME"/.bashrc > /dev/null 2>&1
	then
		bash --norc -i "$@"
		return
	else
		bash -i "$@"
		return
	fi
	
	bash -i "$@"
	return
	
	return 1
}

#Mostly if not entirely intended for end user convenience.
_python() {
	_safe_declare_uid
	
	if [[ -e "$safeTmp"/lean.py ]]
	then
		"$safeTmp"/lean.py '_python()'
		return
	fi
	if [[ -e "$scriptAbsoluteFolder"/lean.py ]]
	then
		"$scriptAbsoluteFolder"/lean.py '_python()'
		return
	fi
	if type -p 'lean.py' > /dev/null 2>&1
	then
		lean.py '_python()'
		return
	fi
	return 1
}

#Launch internal functions as commands, and other commands, as root.
_sudo() {
	_safe_declare_uid
	
	if ! _if_cygwin
	then
		sudo -n "$scriptAbsoluteLocation" _bin "$@"
		return
	fi
	if _if_cygwin
	then
		_sudo_cygwin "$@"
		return
	fi
	
	return 1
}

_true() {
	_safe_declare_uid
	
	#"$scriptAbsoluteLocation" _false && return 1
	#  ! "$scriptAbsoluteLocation" _bin true && return 1
	#"$scriptAbsoluteLocation" _bin false && return 1
	true
}
_false() {
	_safe_declare_uid
	
	false
}
_echo() {
	_safe_declare_uid
	
	echo "$@"
}

_diag() {
	_safe_declare_uid
	
	echo "$sessionid"
}

#Stop if script is imported, parameter not specified, and command not given.
if [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] && [[ "$1" != '_'* ]]
then
	_messagePlain_warn 'import: missing: parameter, missing: command' | _user_log-ub
	ub_import=""
	return 1 > /dev/null 2>&1
	exit 1
fi

#Set "ubOnlyMain" in "ops" overrides as necessary.
if [[ "$ubOnlyMain" != "true" ]]
then
	
	#Launch command named by link name.
	if scriptLinkCommand=$(_getScriptLinkName)
	then
		if [[ "$scriptLinkCommand" == '_'* ]]
		then
			if [[ "$ubDEBUG" == "true" ]]
			then
				# ATTRIBUTION-AI: ChatGPT o3  2025-06-06
				exec 3>&2
				#export BASH_XTRACEFD=3
				set   -o functrace
				set   -o errtrace
				# May break _test_pipefail_sequence .
				#export SHELLOPTS
				trap '
  set -E +x
  call_line=${BASH_LINENO[0]}
  call_file=${BASH_SOURCE[1]}
  [[ $call_file == "$PWD/"* ]] && call_file=${call_file#"$PWD/"}
  func_name=${FUNCNAME[0]:-MAIN}

  if [[ "$call_line" != "0" ]] && [[ func_name != "MAIN()" ]]
  then
	# extract the source line and strip leading blanks
	call_text=$(sed -n "${call_line}{s/^[[:space:]]*//;p}" "$call_file")

	printf "<<<STEPOUT<<< RETURN %s() <- %s:%d : %s  status=%d\n" \
			"$func_name"        "$call_file" \
			"$call_line"        "$call_text" \
			"$?" >&3
  fi
  set -E -x
' RETURN
				set -E -x
				#set -x
			fi
			
			"$scriptLinkCommand" "$@"
			internalFunctionExitStatus="$?"

			if [[ "$ubDEBUG" == "true" ]] ; then set +x ; set +E ; set +o functrace ; set +o errtrace ; export -n SHELLOPTS 2>/dev/null || true ; trap '' RETURN ; trap - RETURN ; fi
			
			#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
			if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--compressed" ]]
			then
				#export noEmergency=true
				exit "$internalFunctionExitStatus"
			fi
			ub_import=""
			return "$internalFunctionExitStatus" > /dev/null 2>&1
			exit "$internalFunctionExitStatus"
		fi
	fi
	
	# NOTICE Launch internal functions as commands.
	#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
	#if [[ "$1" == '_'* ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
	# && [[ "$1" != "_test" ]] && [[ "$1" != "_setup" ]] && [[ "$1" != "_build" ]] && [[ "$1" != "_vector" ]] && [[ "$1" != "_setupCommand" ]] && [[ "$1" != "_setupCommand_meta" ]] && [[ "$1" != "_setupCommands" ]] && [[ "$1" != "_find_setupCommands" ]] && [[ "$1" != "_setup_anchor" ]] && [[ "$1" != "_anchor" ]] && [[ "$1" != "_package" ]] && [[ "$1" != *"_prog" ]] && [[ "$1" != "_main" ]] && [[ "$1" != "_collect" ]] && [[ "$1" != "_enter" ]] && [[ "$1" != "_launch" ]] && [[ "$1" != "_default" ]] && [[ "$1" != "_experiment" ]]
	if [[ "$1" == '_'* ]] && type "$1" > /dev/null 2>&1 && [[ "$1" != "_test" ]] && [[ "$1" != "_setup" ]] && [[ "$1" != "_build" ]] && [[ "$1" != "_vector" ]] && [[ "$1" != "_setupCommand" ]] && [[ "$1" != "_setupCommand_meta" ]] && [[ "$1" != "_setupCommands" ]] && [[ "$1" != "_find_setupCommands" ]] && [[ "$1" != "_setup_anchor" ]] && [[ "$1" != "_anchor" ]] && [[ "$1" != "_package" ]] && [[ "$1" != *"_prog" ]] && [[ "$1" != "_main" ]] && [[ "$1" != "_collect" ]] && [[ "$1" != "_enter" ]] && [[ "$1" != "_launch" ]] && [[ "$1" != "_default" ]] && [[ "$1" != "_experiment" ]]
	then
		if [[ "$ubDEBUG" == "true" ]]
		then
			# ATTRIBUTION-AI: ChatGPT o3  2025-06-06
			exec 3>&2
			#export BASH_XTRACEFD=3
			set   -o functrace
			set   -o errtrace
			# May break _test_pipefail_sequence .
			#export SHELLOPTS
			trap '
  set -E +x
  call_line=${BASH_LINENO[0]}
  call_file=${BASH_SOURCE[1]}
  [[ $call_file == "$PWD/"* ]] && call_file=${call_file#"$PWD/"}
  func_name=${FUNCNAME[0]:-MAIN}

  if [[ "$call_line" != "0" ]] && [[ func_name != "MAIN()" ]]
  then
    # extract the source line and strip leading blanks
    call_text=$(sed -n "${call_line}{s/^[[:space:]]*//;p}" "$call_file")

    printf "<<<STEPOUT<<< RETURN %s() <- %s:%d : %s  status=%d\n" \
            "$func_name"        "$call_file" \
            "$call_line"        "$call_text" \
            "$?" >&3
  fi
' RETURN
			set -E -x
			#set -x
		fi
		
		"$@"
		internalFunctionExitStatus="$?"
		
		if [[ "$ubDEBUG" == "true" ]] ; then set +x ; set +E ; set +o functrace ; set +o errtrace ; export -n SHELLOPTS 2>/dev/null || true ; trap '' RETURN ; trap - RETURN ; fi
		
		#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
		if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--compressed" ]]
		then
			#export noEmergency=true
			exit "$internalFunctionExitStatus"
		fi
		ub_import=""
		return "$internalFunctionExitStatus" > /dev/null 2>&1
		exit "$internalFunctionExitStatus"
		#_stop "$?"
	fi
fi

[[ "$ubOnlyMain" == "true" ]] && export ubOnlyMain="false"

#Do not continue script execution through program code if critical global variables are not sane.
[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
_failExec || exit 1

#Return if script is under import mode, and bypass is not requested.
# || [[ "$current_internal_CompressedScript" != "" ]] || [[ "$current_internal_CompressedScript_cksum" != "" ]] || [[ "$current_internal_CompressedScript_bytes" != "" ]]
if [[ "$ub_import" == "true" ]] && ! ( [[ "$ub_import_param" == "--bypass" ]] ) || [[ "$ub_import_param" == "--compressed" ]] || [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--profile" ]]
then
	return 0 > /dev/null 2>&1
	exit 0
fi


#####Overrides DISABLE

# DANGER: NEVER intended to be set in an end user shell for ANY reason.
# DANGER: Implemented to prevent 'compile.sh' from attempting to run functions from 'ops.sh'. No other valid use currently known or anticipated!
export ub_ops_disable='true'


#####Entry

# WARNING: Do not add code directly here without disabling checksum!
# WARNING: Checksum may only be disabled either by override of 'generic/minimalheader.sh' or by adding appropriate '.nck' file !

#"$scriptAbsoluteLocation" _setup




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

