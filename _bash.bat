@rem(){ :;};@rem echo '
@echo off
@goto b
' > /dev/null 2>&1 ;
rem(){ :;};rem

if [[ "$1" == 'ubAnchorSelfTestOnly' ]]
then
	echo PASS-BASH
	exit
fi

if [[ "$1" == 'MSWselfReinterpret' ]]
then
	shift
	
	# ATTENTION: DANGER: Not yet implemented. Comment to allow continuation production use.
	exit 1
fi


# WARNING: MSW compatible anchor batch script. This should NOT be required for all Ubiquitous Bash functions.
# Rather, MSW compatble anchor batch scripts should ONLY be needed to integrate with legacy programs which are
# required for interoperability, unable to be recompiled from source, and unusually unable to be controlled
# from native UNIX environments.

# DANGER: Beware the MSW platform has historically been less stable, standalone, and/or reliable through the year 2020.

# DANGER: Beware this must behave correctly under BOTH MSW and native UNIX platforms.




#Universal debugging filesystem.
_user_log_anchor() {
	# DANGER Do NOT create automatically, or reference any existing directory!
	! [[ -d "$HOME"/.ubcore/userlog ]] && cat - > /dev/null 2>&1 && return 0
	
	#Terminal session may be used - the sessionid may be set through .bashrc/.ubcorerc .
	if [[ "$sessionid" != "" ]]
	then
		cat - >> "$HOME"/.ubcore/userlog/a-"$sessionid".log
		return 0
	fi
	cat - >> "$HOME"/.ubcore/userlog/a-undef.log
	
	return 0
}

#Cyan. Harmless status messages.
_messagePlain_nominal() {
	echo -e -n '\E[0;36m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
_messagePlain_probe() {
	echo -e -n '\E[0;34m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
_messagePlain_probe_expr() {
	echo -e -n '\E[0;34m '
	echo -e -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Green. Working as expected.
_messagePlain_good() {
	echo -e -n '\E[0;32m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Yellow. May or may not be a problem.
_messagePlain_warn() {
	echo -e -n '\E[1;33m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Red. Will result in missing functionality, reduced performance, etc, but not necessarily program failure overall.
_messagePlain_bad() {
	echo -e -n '\E[0;31m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

##Parameters
#"--shell", ""
#"--profile"
#"--parent", "--embed", "--return", "--devenv"
#"--call", "--script" "--bypass"

ub_import=
ub_import_param=
ub_import_script=
ub_loginshell=

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && ub_import="true"
([[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]]) && ub_import_param="$1" && shift
([[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]]) && ub_loginshell="true"	#Importing ubiquitous bash into a login shell with "~/.bashrc" is the only known cause for "_getScriptAbsoluteLocation" to return a result such as "/bin/bash".
[[ "$ub_import" == "true" ]] && ! [[ "$ub_loginshell" == "true" ]] && ub_import_script="true"

_messagePlain_probe_expr '$0= '"$0"'\n ''$1= '"$1"'\n ''ub_import= '"$ub_import"'\n ''ub_import_param= '"$ub_import_param"'\n ''ub_import_script= '"$ub_import_script"'\n ''ub_loginshell= '"$ub_loginshell" | _user_log_anchor

# DANGER Prohibited import from login shell. Use _setupUbiquitous, call from another script, or manually set importScriptLocation.
# WARNING Import from shell can be detected. Import from script cannot. Asserting that script has been imported is possible. Asserting that script has not been imported is not possible. Users may be protected from interactive mistakes. Script developers are NOT protected.
if [[ "$ub_import_param" == "--profile" ]]
then
	([[ "$profileScriptLocation" == "" ]] ||  [[ "$profileScriptFolder" == "" ]]) && _messagePlain_bad 'import: profile: missing: profileScriptLocation, missing: profileScriptFolder' | _user_log_anchor && return 1
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])
then
	([[ "$scriptAbsoluteLocation" == "" ]] || [[ "$scriptAbsoluteFolder" == "" ]] || [[ "$sessionid" == "" ]]) && _messagePlain_bad 'import: parent: missing: scriptAbsoluteLocation, missing: scriptAbsoluteFolder, missing: sessionid' | _user_log_anchor && return 1
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ([[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]])
then
	([[ "$importScriptLocation" == "" ]] ||  [[ "$importScriptFolder" == "" ]]) && _messagePlain_bad 'import: call: missing: importScriptLocation, missing: importScriptFolder' | _user_log_anchor && return 1
elif [[ "$ub_import" != "true" ]]	#"--shell", ""
then
	_messagePlain_warn 'import: undetected: cannot determine if imported' | _user_log_anchor
	true #no problem
else	#FAIL, implies [[ "$ub_import" == "true" ]]
	_messagePlain_bad 'import: fall: fail' | _user_log_anchor && return 1
	exit 1
fi

if [[ "$ub_import_param" == "--profile" ]]
then
	ub_import=true
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])  && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
then
	ub_import=true
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ([[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]])
then
	ub_import=true
fi

[[ "$ub_import" != "true" ]] && ub_import_param=

#Critical prerequsites.

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

_getAbsolute_criticalDep() {
	! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	
	#Known issue on Mac. See https://github.com/mirage335/ubiquitous_bash/issues/1 .
	! realpath -L . > /dev/null 2>&1 && return 1
	
	return 0
}
! _getAbsolute_criticalDep && exit 1

#####Utilities.
#Retrieves absolute path of current script, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#However, will dereference symlinks IF the script location itself is a symlink. This is to allow symlinking to scripts to function normally.
#Suitable for allowing scripts to find other scripts they depend on. May look like an ugly hack, but it has proven reliable over the years.
_getScriptAbsoluteLocation() {
	if [[ "$0" == "-"* ]]
	then
		return 1
	fi
	
	local absoluteLocation
	if [[ (-e $PWD\/$0) && ($0 != "") ]] && [[ "$0" != "/"* ]]
	then
		absoluteLocation="$PWD"\/"$0"
		absoluteLocation=$(_realpath_L_s "$absoluteLocation")
	else
		absoluteLocation=$(_realpath_L "$0")
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
	
	! [[ -s "$1" ]] && return 1
	! head --bytes=1 "$1" > /dev/null 2>&1 && return 1
	#! type "$1" >/dev/null 2>&1 && return 1
	
	local launchGuardScriptAbsoluteLocation
	launchGuardScriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
	local launchGuardTestAbsoluteLocation
	launchGuardTestAbsoluteLocation=$(_getAbsoluteLocation "$1")
	[[ "$launchGuardScriptAbsoluteLocation" == "$launchGuardTestAbsoluteLocation" ]] && return 1
	
	return 0
}

#Generates random alphanumeric characters, default length 18.
_uid() {
	local uidLength
	! [[ -z "$1" ]] && uidLength="$1" || uidLength=18
	
	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c "$uidLength" 2> /dev/null
}

#Demarcate major steps.
_messageNormal() {
	echo -e -n '\E[1;32;46m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Demarcate major failures.
_messageError() {
	echo -e -n '\E[1;33;41m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#https://stackoverflow.com/questions/4210042/how-to-exclude-a-directory-in-find-command/16595367#16595367
_findAnchor() {
	local anchorCurrentSearchDir
	anchorCurrentSearchDir="$1"
	shift
	
	find -P "$anchorCurrentSearchDir" -not \( -path \*.git\* -prune \) -not \( -path \*_arc\* -prune \) -not \( -path \*_buried\* -prune \) -not \( -path \*_lib\* -prune \) -not \( -path \*_local\* -prune \) -not \( -path \*_local/_index\* -prune \) -not \( -path \*_local/h\* -prune \) -not \( -path \*h_\*/\* -prune \) -not \( -path \*w_\*/\* -prune \) -not \( -path \*../disk\* -prune \) -not \( -path \*../ssh\* -prune \) "$@"
}

#Recursively searches for directories.
_findAnchorSource() {
	local anchorCurrentSearchDir
	anchorCurrentSearchDir="$1"
	shift
	
	local anchorCurrentSearchDirAbsolute
	anchorCurrentSearchDirAbsolute=$(_getAbsoluteLocation "$anchorCurrentSearchDir")
	
	_findAnchor "$anchorCurrentSearchDir" -path \*"$anchorSourcePath"
	
	return
}

#Recursively searches for directories.
_findAnchorName() {
	local anchorCurrentSearchDir
	anchorCurrentSearchDir="$1"
	shift
	
	local anchorCurrentSearchDirAbsolute
	anchorCurrentSearchDirAbsolute=$(_getAbsoluteLocation "$anchorCurrentSearchDir")
	
	_findAnchor "$anchorCurrentSearchDir" -path \*_index/"$anchorName"
	
	return
}

_check_anchor() {
	local anchorCheckLine
	while IFS='' read -r anchorCheckLine || [[ -n "$anchorCheckLine" ]]
	do
		#Conventionally a git submodule for compile purposes only.
		[[ "$anchorCheckLine" == *'_lib/ubiquitous_bash/ubiquitous_bash.sh' ]] && continue
		
		[[ "$anchorCheckLine" != *"$anchorSource" ]] && [[ "$anchorCheckLine" != *'ubiquitous_bash.sh' ]] && [[ "$anchorCheckLine" != *"$anchorName" ]] && continue
		
		! _recursion_guard "$anchorCheckLine" && continue
		
		_getAbsoluteLocation "$anchorCheckLine"
	done
}

#_safeEcho_anchor "$anchorScriptAbsoluteFolder" | tr -dc 'a-zA-Z0-9.:_-'
_safeEcho_anchor() {
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

_launch_anchor() {
	_messagePlain_nominal 'anchorName='"$anchorName" | _user_log_anchor

	_messagePlain_probe 'anchorScriptAbsoluteLocation='"$anchorScriptAbsoluteLocation" | _user_log_anchor
	_messagePlain_probe 'anchorScriptAbsoluteFolder='"$anchorScriptAbsoluteFolder" | _user_log_anchor

	_messagePlain_probe 'anchorSourcePath='"$anchorSourcePath" | _user_log_anchor
	_messagePlain_probe 'anchorLabName='"$anchorLabName" | _user_log_anchor
	_messagePlain_probe 'anchorLabNameAlt='"$anchorLabNameAlt" | _user_log_anchor
	_messagePlain_probe 'anchorEntity='"$anchorEntity" | _user_log_anchor
	
	local recursionExec
	local anchorParent
	
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	
	if [[ "$anchorScriptAbsoluteFolder" == '/cygdrive/'* ]]
	then
		local currentDriveLetter
		for currentDriveLetter in {a..z}
		do
			if [[ "$anchorScriptAbsoluteFolder" == '/cygdrive/'"$currentDriveLetter" ]]
			then
				recursionExec="$anchorScriptAbsoluteFolder"/"$anchorSource"
				if _recursion_guard "$recursionExec"
				then
					[[ "$ub_import" != "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
						if [[ "$ub_import" != "true" ]]
						then
							bash "$recursionExec" "$anchorName" "$@"
							exit $?
						fi
					
					[[ "$ub_import" == "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
						[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
					
					exit $?
				fi
			fi
		done
	fi
	
	if [[ "$anchorScriptAbsoluteFolder" == '/home/user/project' ]] || [[ "$anchorScriptAbsoluteFolder" == /tmp/"$ubiquitiousBashIDnano" ]]
	then
		recursionExec="$anchorScriptAbsoluteFolder"/"$anchorSource"
		if _recursion_guard "$recursionExec"
		then
			[[ "$ub_import" != "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
				if [[ "$ub_import" != "true" ]]
				then
					bash "$recursionExec" "$anchorName" "$@"
					exit $?
				fi
			
			[[ "$ub_import" == "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
				[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
			
			exit $?
		fi
	fi
	
	
	recursionExec="$anchorScriptAbsoluteFolder"/../"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		
		exit $?
	fi
	
	#Resolves placement under "$anchorSourcePath"/_index .
	recursionExec="$anchorScriptAbsoluteFolder"/../../"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'self: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		
		exit $?
	fi
	
	anchorDestination=$(_findAnchorSource "$anchorScriptAbsoluteFolder"/.. | _check_anchor | _filter_lowestPath)
	if [[ "$anchorDestination" != "" ]]
	then
		if [[ "$anchorDestination" == *"ubiquitous_bash.sh" ]]
		then
			_messagePlain_good 'launch: 'bash "$anchorDestination" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$anchorDestination" "$anchorName" "$@"
				exit $?
			fi
			
			[[ "$ub_import" == "true" ]] && bash "$anchorDestination" "$ub_import_param" "$anchorName" "$@"
			exit $?
		fi
		_messagePlain_good 'launch: 'bash "$anchorDestination" "$ub_import_param" "$@" | _user_log_anchor
		[[ "$ub_import" != "true" ]] && bash "$anchorDestination" "$@"
		[[ "$ub_import" != "true" ]] && exit $?
		
		[[ "$ub_import" == "true" ]] && bash "$anchorDestination" "$ub_import_param" "$@"
		exit $?
	fi
	
	anchorParent=$(_getAbsoluteLocation "$anchorScriptAbsoluteFolder"/../..)
	_messagePlain_probe 'anchorParent='"$anchorParent" | _user_log_anchor
	if [[ "$anchorScriptAbsoluteFolder" == *"_local/_index" ]]
	then
		_messagePlain_probe 'detected: parent: _local/_index' | _user_log_anchor
		anchorDestination=$(_findAnchorName "$anchorParent" | _check_anchor | _filter_highestPath)
		if [[ "$anchorDestination" != "" ]]
		then
			_messagePlain_probe 'anchorDestination='"$anchorDestination" | _user_log_anchor
			_messagePlain_good 'launch: 'bash "$anchorDestination" "$ub_import_param" "$@" | _user_log_anchor
			[[ "$ub_import" != "true" ]] && bash "$anchorDestination" "$@"
			[[ "$ub_import" != "true" ]] && exit $?
			
			[[ "$ub_import" == "true" ]] && bash "$anchorDestination" "$ub_import_param" "$anchorName" "$@"
			exit $?
		fi
	fi
	
	recursionExec="$HOME"/core/infrastructure/vm/"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/extra/infrastructure/vm/"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		exit $?
	fi
	
	recursionExec="$HOME"/core/installations/"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/extra/installations/"$anchorSourcePath"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$anchorName" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$anchorName" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'launch: 'bash "$recursionExec" "$ub_import_param" "$anchorName" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$anchorName" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/lab/"$anchorEntity""$anchorLabName"/_index/"$anchorName"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$ub_import_param" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/extra/lab/"$anchorEntity""$anchorLabName"/_index/"$anchorName"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$ub_import_param" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/lab/"$anchorEntity""$anchorLabNameAlt"/_index/"$anchorName"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$ub_import_param" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$@"
		exit $?
	fi

	recursionExec="$HOME"/core/extra/lab/"$anchorEntity""$anchorLabNameAlt"/_index/"$anchorName"
	if _recursion_guard "$recursionExec"
	then
		[[ "$ub_import" != "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$@" | _user_log_anchor
			if [[ "$ub_import" != "true" ]]
			then
				bash "$recursionExec" "$@"
				exit $?
			fi
		
		[[ "$ub_import" == "true" ]] && _messagePlain_good 'reference: 'bash "$recursionExec" "$ub_import_param" "$@" | _user_log_anchor
			[[ "$ub_import" == "true" ]] && bash "$recursionExec" "$ub_import_param" "$@"
		exit $?
	fi
	_messagePlain_bad 'missing: '"$anchorSource" | _user_log_anchor
	return 1
}

export anchorScriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
export anchorScriptAbsoluteFolder=$(_getScriptAbsoluteFolder)
export anchorName=$(basename "$anchorScriptAbsoluteLocation" | sed 's/\.bat$//g')


export anchorSourceDir="ubiquitous_bash"
export anchorSource="ubiquitous_bash.sh"
export anchorSourcePath="$anchorSourceDir"/"$anchorSource"

export anchorLabName=anchorLabName
export anchorLabNameAlt="$anchorLabName"Mini

export anchorEntity=""
#export anchorEntity="entity/"

if [[ "$anchorName" == "_anchor" ]]
then
	! [[ -e "$anchorScriptAbsoluteFolder"/"$anchorSource" ]] && exit 1
	
	"$anchorScriptAbsoluteFolder"/"$anchorSource" _anchor
	exit "$?"
fi


if [[ "$1" == 'MSWselfReinterpret' ]]
then
	# ATTENTION: DANGER: Not yet implemented. Add the alternate functionality in production use.
	shift
	exit 1
fi


# ATTENTION: DANGER: Comment out in production use.
#_test() {
#	echo PASS-BASH
#}
#_test



# ATTENTION: DANGER: Uncomment in production use.
_launch_anchor "$@"
exit "$?"

#_findAnchorName .
#exit "$?"


















exit 1
:b
REM Batch script is executable as both MSW batch file and UNIX BASH script.
REM This allows the anchor to self-execute as a more functional BASH script
REM if an appropriate Cygwin environment is installed at the expected location
REM C:\core\infrastructure\ubAnchorMSWselfReinterpret .
REM BASH functionality may not be implemented or adequately tested.
REM Structure is provided only to be used if continued MS de-facto monopoly degrades
REM hardware support for suitable UNIX platforms to the point of infeasibility.
REM https://stackoverflow.com/questions/29966924/cross-platform-command-line-script-e-g-bat-and-sh

REM rem(){ :;};rem '
REM @goto b
REM ';echo sh;exit
REM :b
REM @echo batch

REM @echo batch

REM ATTENTION: WARNING: Do NOT uncomment without correcting and testing all file paths used by the MSW/cygwin/UNIX environment!
REM DANGER: Beware this must behave correctly under BOTH MSW and native UNIX platforms.
REM IF EXIST "C:\core\infrastructure\ubAnchorMSWselfReinterpret\ubcp.cmd" (
REM "C:\core\infrastructure\ubAnchorMSWselfReinterpret\ubcp.cmd" "%~dp0%0" MSWselfReinterpret %*
REM exit
REM )



@echo off

REM Ubiquitous Bash Cygwin Portable - Anchor (Batch Version)

if "%~1"=="ubAnchorSelfTestOnly" (
	echo PASS-BATCH
	exit
)


REM CAUTION: BROKEN! Attemtps to reset Cygwin 'environment variables' to prevent incorrect rewriting of '$PATH' variable. Apparently inadequate.

if NOT "%OLD_ANCHOR_PATH%" == "" (
	set "PATH=%OLD_ANCHOR_PATH%"
	set "OLD_ANCHOR_PATH="
)

if "%OLD_ANCHOR_PATH%" == "" (
	set "OLD_ANCHOR_PATH=%PATH%"
)

set "CYGWIN_PATH="
set "ORIGINAL_PATH="
set "CYGWIN_DRIVE="
set "cygwin_CWD_onceOnly_done="
set "CYGWIN="
set "ProgramData="
set "CYGWIN_ROOT="
set "HOMEPATH="


set "CYGWIN_USEWINPATH="

set "HOME="
set "HOMEDRIVE="
set "HOMEPATH="
set "INFOPATH="
set "LANG="
set "PWD="
set "SHELL="
set "_="

REM set "CYGWIN_USEWINPATH=1"
REM set "CYGWIN_NOWINPATH=1"
REM set "CYGWIN_NOWINPATH=addwinpath"








REM Filename of 'cygwin-portable.cmd' or equivalent.
REM NOT 'cygwin-portable.cmd' due to possible bug.
SET ubcp_cmd_file=ubcp.cmd

SET "ubcp_cmd_dir=%~dp0_local\ubcp"

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:X:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"X:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:X:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"X:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)


REM ### Y:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:Y:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"Y:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:Y:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"Y:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)


REM ### D:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:D:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"D:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:D:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"D:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM ### E:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:E:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"E:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:E:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"E:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM ### F:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:E:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"E:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:E:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"E:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM ### G:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:G:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"G:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:G:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"G:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM ### H:\
REM CAUTION: Ubiquitous Bash is not intended to start directly from read-only directory !
REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:H:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"H:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:H:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'ROM drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"H:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)



REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
REM echo "%~dp0" | findstr /I /B /C:Z:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
echo "%~dp0" | findstr /I /B /R "\"Z:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
REM SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
REM echo "%~dp0" | findstr /I /B /C:Z:\\  > nul
REM IF %ERRORLEVEL% EQU 0 (
REM 	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
REM )

REM A 'locally installed' 'cygwin' should be preferred over 'network drive'.
REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
echo "%~dp0" | findstr /I /B /R "\"Z:\\.*\"" > nul
IF %ERRORLEVEL% EQU 0 (
	IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
)






REM Local install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=%~dp0_local\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=%~dp0_lib\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=%~dp0ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1

REM Local install of cygwin-portable.cmd' or equivalent, brought in by ubiquitous_bash submodule.
REM WARNING: No known production use..
SET "ubcp_cmd_dir=%~dp0_lib\ubiquitous_bash\_local\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=%~dp0_lib\ubiquitous_bash\_lib\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=%~dp0_lib\ubiquitous_bash\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1

REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=C:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1

REM Global install of cygwin-portable.cmd' or equivalent.
SET "ubcp_cmd_dir=C:\core\infrastructure\cp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=C:\cp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1


SET "ubcp_cmd_dir=D:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=E:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=F:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=G:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=H:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=I:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=J:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=K:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=L:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=M:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=N:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=O:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=P:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=Q:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=R:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=S:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=T:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=U:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=V:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1
SET "ubcp_cmd_dir=W:\core\infrastructure\ubcp"
IF EXIST "%ubcp_cmd_dir%"\cygwin goto b1



REM FAILURE
IF NOT EXIST "%ubcp_cmd_dir%"\cygwin exit


:b1
SET "ubcp_cmd_path=%ubcp_cmd_dir%\%ubcp_cmd_file%"

REM FAILURE
IF NOT EXIST "%ubcp_cmd_path%" exit

REM echo "%ubcp_cmd_path%"

REM WARNING: No known production use.
REM SET "MSWanchorScriptAbsoluteLocation=%~dp0%0"
REM SET "MSWanchorScriptAbsoluteFolder=%~dp0"


REM Does NOT include the '.bat' extension.
REM SET "iMSWaN=%0"
REM SET "MSWanchorName=%iMSWaN:~0,-4%"
SET "MSWanchorName=%~n0"

REM Typically set automatically by '_anchor' function.
SET "MSWanchorSourceDir=ubiquitous_bash"

SET "MSWanchorSource=lean.sh"

if not "%MSWanchorSourceDir%"=="ubiquitous_bash" (
	if "%MSWanchorSource%"=="lean.sh" (
		SET "MSWanchorSource=ubiquitous_bash.sh"
	)
)

if "%MSWanchorSource%"=="lean.sh" (
	if "%MSWanchorName%"=="_bash" (
		SET "MSWanchorSource=ubcore.sh"
	)
	if "%MSWanchorName%"=="_setupUbiquitous" (
		SET "MSWanchorSource=ubiquitous_bash.sh"
	)
	if "%MSWanchorName%"=="_setupUbiquitous_nonet" (
		SET "MSWanchorSource=ubiquitous_bash.sh"
	)
	REM if "%MSWanchorName%"=="_setup_ubcp" (
	REM 	SET "MSWanchorSource=ubiquitous_bash.sh"
	REM )
)

REM SET "MSWanchorSource=ubiquitous_bash.sh"

SET "MSWanchorSourcePath=%MSWanchorSourceDir%\%MSWanchorSource%"




REM WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
if "%MSWanchorName%"=="_bash" (
	REM echo .
	
	REM https://stackoverflow.com/questions/7105433/windows-batch-echo-without-new-line
	echo|set /p="."
)



REM Due to the MSW tendency to use shortcuts instead of symlinks, and lack of "find" command,
REM MSW Anchor (Batch Version) is strictly limited to finding the source script only if
REM neighboring in the same directory, in direct subdirectory, or in a few static default locations.
REM WARNING: The direct subdirectory capability is intended for testing, and is not preferred for production use.

REM Test all variables.
REM echo "%~dp0%MSWanchorSource%"
REM echo "%~dp0%MSWanchorSourcePath%"
REM echo "C:\Program Files\%MSWanchorSourcePath%"
REM echo "C:\Program Files (x86)\%MSWanchorSourcePath%"
REM echo "%LOCALAPPDATA%\%MSWanchorSourcePath%"
REM echo "C:\core\infrastructure\%MSWanchorSourcePath%"
REM echo "C:\core\installations\%MSWanchorSourcePath%"

REM Neighboring in the same directory.
IF EXIST "%~dp0%MSWanchorSource%" (
"%ubcp_cmd_path%" "%~dp0%MSWanchorSource%" "%MSWanchorName%" %*
exit
)

REM Direct subdirectory.
IF EXIST "%~dp0%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "%~dp0%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)


REM Program Files .
IF EXIST "C:\Program Files\%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "C:\Program Files\%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)

REM Program Files (x86) .
IF EXIST "C:\Program Files (x86)\%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "C:\Program Files (x86)\%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)


REM TODO: Test - variable name.
REM AppData (Local) .
REM https://www.thewindowsclub.com/local-localnow-roaming-folders-windows-10/
IF EXIST "%LOCALAPPDATA%\%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "%LOCALAPPDATA%\%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)


REM core infrastructure .
IF EXIST "C:\core\infrastructure\%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "C:\core\infrastructure\%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)


REM core installations .
IF EXIST "C:\core\installations\%MSWanchorSourcePath%" (
"%ubcp_cmd_path%" "C:\core\installations\%MSWanchorSourcePath%" "%MSWanchorName%" %*
exit
)




REM ATTENTION: DANGER: Comment out in production use.
REM echo PASS-BATCH
REM IF EXIST "C:\core\infrastructure\ubAnchorMSWselfReinterpret\ubcp.cmd" (
REM "C:\core\infrastructure\ubAnchorMSWselfReinterpret\ubcp.cmd" "%~dp0%0" ubAnchorSelfTestOnly
REM exit
REM )


exit
