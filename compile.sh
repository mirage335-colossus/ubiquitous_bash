#!/usr/bin/env bash

#Universal debugging filesystem.
_user_log-ub() {
	# DANGER Do NOT create automatically, or reference any existing directory!
	! [[ -d "$HOME"/.ubcore/userlog ]] && cat - > /dev/null 2>&1 && return 0
	
	#Terminal session may be used - the sessionid may be set through .bashrc/.ubcorerc .
	if [[ "$sessionid" != "" ]]
	then
		cat - >> "$HOME"/.ubcore/userlog/u-"$sessionid".log
		return 0
	fi
	cat - >> "$HOME"/.ubcore/userlog/u-undef.log
	
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
#"--parent", "--return", "--devenv"
#"--call", "--script" "--bypass"

ub_import=
ub_import_param=
ub_import_script=
ub_loginshell=

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && ub_import="true"
([[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]]) && ub_import_param="$1" && shift
([[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]]) && ub_loginshell="true"	#Importing ubiquitous bash into a login shell with "~/.bashrc" is the only known cause for "_getScriptAbsoluteLocation" to return a result such as "/bin/bash".
[[ "$ub_import" == "true" ]] && ! [[ "$ub_loginshell" == "true" ]] && ub_import_script="true"

_messagePlain_probe_expr '$0= '"$0"'\n ''$1= '"$1"'\n ''ub_import= '"$ub_import"'\n ''ub_import_param= '"$ub_import_param"'\n ''ub_import_script= '"$ub_import_script"'\n ''ub_loginshell= '"$ub_loginshell" | _user_log-ub

# DANGER Prohibited import from login shell. Use _setupUbiquitous, call from another script, or manually set importScriptLocation.
# WARNING Import from shell can be detected. Import from script cannot. Asserting that script has been imported is possible. Asserting that script has not been imported is not possible. Users may be protected from interactive mistakes. Script developers are NOT protected.
if [[ "$ub_import_param" == "--profile" ]]
then
	([[ "$profileScriptLocation" == "" ]] ||  [[ "$profileScriptFolder" == "" ]]) && _messagePlain_bad 'import: profile: missing: profileScriptLocation, missing: profileScriptFolder' | _user_log-ub && return 1
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])
then
	([[ "$scriptAbsoluteLocation" == "" ]] || [[ "$scriptAbsoluteFolder" == "" ]] || [[ "$sessionid" == "" ]]) && _messagePlain_bad 'import: parent: missing: scriptAbsoluteLocation, missing: scriptAbsoluteFolder, missing: sessionid' | _user_log-ub && return 1
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ([[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]])
then
	([[ "$importScriptLocation" == "" ]] ||  [[ "$importScriptFolder" == "" ]]) && _messagePlain_bad 'import: call: missing: importScriptLocation, missing: importScriptFolder' | _user_log-ub && return 1
elif [[ "$ub_import" != "true" ]]	#"--shell", ""
then
	_messagePlain_warn 'import: undetected: cannot determine if imported' | _user_log-ub
	true #no problem
else	#FAIL, implies [[ "$ub_import" == "true" ]]
	_messagePlain_bad 'import: fall: fail' | _user_log-ub && return 1
	exit 1
fi

#Override.

#Override (Program).

#####Utilities

#Critical prerequsites.
_getAbsolute_criticalDep() {
	! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	
	#Known issue on Mac. See https://github.com/mirage335/ubiquitous_bash/issues/1 .
	! realpath -L . > /dev/null 2>&1 && return 1
	
	return 0
}
! _getAbsolute_criticalDep && exit 1

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
	absoluteLocation=$(realpath -L -s "$absoluteLocation")
			else
	absoluteLocation=$(realpath -L "$0")
	fi

	if [[ -h "$absoluteLocation" ]]
			then
	absoluteLocation=$(readlink -f "$absoluteLocation")
	absoluteLocation=$(realpath -L "$absoluteLocation")
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
	absoluteLocation=$(realpath -L -s "$absoluteLocation")
			else
	absoluteLocation=$(realpath -L "$1")
	fi
	echo $absoluteLocation
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
	
	#Blacklist.
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
	
	#Whitelist.
	local safeToRM=false
	
	local safeScriptAbsoluteFolder
	#safeScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	safeScriptAbsoluteFolder="$scriptAbsoluteFolder"
	
	[[ "$1" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	[[ "$1" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	#[[ "$1" == "/home/$USER"* ]] && safeToRM="true"
	[[ "$1" == "/tmp/"* ]] && safeToRM="true"
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	_checkDep basename
	
	if [[ -e "$1" ]]
	then
		#sleep 0
		#echo "$1"
		# WARNING Recommend against adding any non-portable flags.
		rm -rf "$1"
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
	
	#Blacklist.
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
	
	#Whitelist.
	local safeToRM=false
	
	local safeScriptAbsoluteFolder
	#safeScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	safeScriptAbsoluteFolder="$scriptAbsoluteFolder"
	
	[[ "$1" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	[[ "$1" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	#[[ "$1" == "/home/$USER"* ]] && safeToRM="true"
	[[ "$1" == "/tmp/"* ]] && safeToRM="true"
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	_checkDep basename
	
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
	
	[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
	[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
	
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
	
	[[ ! -e "$commandScriptAbsoluteLocation" ]] && exit 1
	[[ ! -e "$commandScriptAbsoluteFolder" ]] && exit 1
	
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



#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) } 

_terminateAll() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./w_*/.pid > "$processListFile"
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		pkill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

#Generates random alphanumeric characters, default length 18.
_uid() {
	local uidLength
	! [[ -z "$1" ]] && uidLength="$1" || uidLength=18
	
	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c "$uidLength" 2> /dev/null
}

_permissions_directory_checkForPath() {
	local parameterAbsoluteLocation
	parameterAbsoluteLocation=$(_getAbsoluteLocation "$1")
	
	local checkScriptAbsoluteFolder="$(_getScriptAbsoluteFolder)"
	
	[[ "$parameterAbsoluteLocation" == "$PWD" ]] && ! [[ "$parameterAbsoluteLocation" == "$checkScriptAbsoluteFolder" ]] && return 1
	
	local permissions_readout=$(stat -c "%a" "$1")
	
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
	
	permissions_uid=$(stat -c "%u" "$1")
	permissions_gid=$(stat -c "%g" "$1")
	
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

#Checks whether currently set "$scriptBin" and similar locations are actually safe.
# WARNING Keep in mind this is necessarily run only after PATH would already have been modified, and does not guard against threats already present on the local machine.
_test_permissions_ubiquitous() {
	[[ ! -e "$scriptAbsoluteFolder" ]] && _stop 1
	
	! _permissions_directory_checkForPath "$scriptAbsoluteFolder" && _stop 1
	
	[[ -e "$scriptBin" ]] && ! _permissions_directory_checkForPath "$scriptBin" && _stop 1
	[[ -e "$scriptBundle" ]] && ! _permissions_directory_checkForPath "$scriptBundle" && _stop 1
	
	return 0
}



#Takes "$@". Places in global array variable "globalArgs".
# WARNING Adding this globalvariable to the "structure/globalvars.sh" declaration or similar to be overridden at script launch is not recommended.
#"${globalArgs[@]}"
_gather_params() {
	export globalArgs=("${@}")
}

#Universal debugging filesystem.
#End user function.
_user_log() {
	# DANGER Do NOT create automatically, or reference any existing directory!
	! [[ -d "$HOME"/.ubcore/userlog ]] && cat - > /dev/null 2>&1 && return 0
	
	cat - >> "$HOME"/.ubcore/userlog/user.log
	
	return 0
}

_monitor_user_log() {
	! [[ -d "$HOME"/.ubcore/userlog ]] && return 1
	
	tail -f "$HOME"/.ubcore/userlog/*
}

#Universal debugging filesystem.
#"generic/ubiquitousheader.sh"
_user_log-ub() {
	# DANGER Do NOT create automatically, or reference any existing directory!
	! [[ -d "$HOME"/.ubcore/userlog ]] && cat - > /dev/null 2>&1 && return 0
	
	#Terminal session may be used - the sessionid may be set through .bashrc/.ubcorerc .
	if [[ "$sessionid" != "" ]]
	then
		cat - >> "$HOME"/.ubcore/userlog/u-"$sessionid".log
		return 0
	fi
	cat - >> "$HOME"/.ubcore/userlog/u-undef.log
	
	return 0
}

_monitor_user_log-ub() {
	! [[ -d "$HOME"/.ubcore/userlog ]] && return 1
	
	tail -f "$HOME"/.ubcore/userlog/u-*
}

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

_monitor_user_log_anchor() {
	! [[ -d "$HOME"/.ubcore/userlog ]] && return 1
	
	tail -f "$HOME"/.ubcore/userlog/a-*
}

#Universal debugging filesystem.
_user_log_template() {
	# DANGER Do NOT create automatically, or reference any existing directory!
	! [[ -d "$HOME"/.ubcore/userlog ]] && cat - > /dev/null 2>&1 && return 0
	
	#Terminal session may be used - the sessionid may be set through .bashrc/.ubcorerc .
	if [[ "$sessionid" != "" ]]
	then
		cat - >> "$HOME"/.ubcore/userlog/t-"$sessionid".log
		return 0
	fi
	cat - >> "$HOME"/.ubcore/userlog/t-undef.log
	
	return 0
}

_messageColors() {
	echo -e '\E[1;37m 'white' \E[0m'
	echo -e '\E[0;30m 'black' \E[0m'
	echo -e '\E[0;34m 'blue' \E[0m'
	echo -e '\E[1;34m 'blue_light' \E[0m'
	echo -e '\E[0;32m 'green' \E[0m'
	echo -e '\E[1;32m 'green_light' \E[0m'
	echo -e '\E[0;36m 'cyan' \E[0m'
	echo -e '\E[1;36m 'cyan_light' \E[0m'
	echo -e '\E[0;31m 'red' \E[0m'
	echo -e '\E[1;31m 'red_light' \E[0m'
	echo -e '\E[0;35m 'purple' \E[0m'
	echo -e '\E[1;35m 'purple_light' \E[0m'
	echo -e '\E[0;33m 'brown' \E[0m'
	echo -e '\E[1;33m 'yellow' \E[0m'
	echo -e '\E[0;30m 'gray' \E[0m'
	echo -e '\E[1;37m 'gray_light' \E[0m'
	return 0
}

#Cyan. Harmless status messages.
#"generic/ubiquitousheader.sh"
_messagePlain_nominal() {
	echo -e -n '\E[0;36m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe() {
	echo -e -n '\E[0;34m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_expr() {
	echo -e -n '\E[0;34m '
	echo -e -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Green. Working as expected.
#"generic/ubiquitousheader.sh"
_messagePlain_good() {
	echo -e -n '\E[0;32m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Yellow. May or may not be a problem.
#"generic/ubiquitousheader.sh"
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
}

_messageWARN() {
	echo
	echo "$@"
	return 0
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
	
	echo -e -n '\E[1;32;46m '
	
	echo -n "$processString"
	
	echo -e -n '\E[0m'
	
	while [[ "$currentIteration" -lt "$padLength" ]]
	do
		echo -e -n ' '
		let currentIteration="$currentIteration"+1
	done
	
	return 0
}

#"$1" == file path
_includeFile() {
	
	if [[ -e  "$1" ]]
	then
		cat "$1" >> "$progScript"
		echo >> "$progScript"
		return 0
	fi
	
	return 1
}

#Provide only approximate, realative paths. These will be disassembled and treated as a search query following stricti preferences
#"generic/filesystem/absolutepaths.sh"
_includeScript() {

	local includeScriptFilename=$(basename "$1")
	local includeScriptSubdirectory=$(dirname "$1")
	
	
	_includeFile "$progDir"/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	
	_includeFile "$progDir"/"$includeScriptFilename" && return 0
	
	_includeFile "$ubiquitiousLibDir"/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	
	_includeFile "$ubiquitiousLibDir"/"$includeScriptFilename" && return 0
	
	_includeFile "$configDir"/"$includeScriptFilename" && return 0
	
	#[[ "$configBaseDir" == "" ]] && configBaseDir="_config"
	[[ "$configBaseDir" == "" ]] && configBaseDir=$(basename "$configDir")
	
	_includeFile "$ubiquitiousLibDir"/"$configBaseDir"/"$includeScriptFilename" && return 0
	
	return 1
}

# "$1" == script list array
_includeScripts() {
	local currentIncludeScript
	local historyIncludeScript
	local historyIncludedScript
	local duplicateIncludeScript
	
	for currentIncludeScript in "$@"
	do	
		duplicateIncludeScript="false"
		for historyIncludedScript in "${historyIncludeScript[@]}"
		do
			if [[ "$historyIncludedScript" == "$currentIncludeScript" ]]
			then
				duplicateIncludeScript="true"
			fi
		done
		historyIncludeScript+=("$currentIncludeScript")
		
		[[ "$duplicateIncludeScript" != "true" ]] && _includeScript "$currentIncludeScript"
	done
}

#Gets filename extension, specifically any last three characters in given string.
#"$1" == filename
_getExt() {
	echo "$1" | tr -dc 'a-zA-Z0-9.' | tr '[:upper:]' '[:lower:]' | tail -c 4
}

#Reports either the directory provided, or the directory of the file provided.
_findDir() {
	local dirIn=$(_getAbsoluteLocation "$1")
	dirInLogical=$(realpath -L -s "$dirIn")
	
	if [[ -d "$dirInLogical" ]]
	then
		echo "$dirInLogical"
		return
	fi
	
	echo $(_getAbsoluteFolder "$dirInLogical")
	return
	
}

_discoverResource() {
	
	[[ "$scriptAbsoluteFolder" == "" ]] && return 1
	
	local testDir
	testDir="$scriptAbsoluteFolder" ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return 0
	testDir="$scriptAbsoluteFolder"/.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return 0
	testDir="$scriptAbsoluteFolder"/../.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return 0
	testDir="$scriptAbsoluteFolder"/../../.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return 0
	
	return 1
}

_rmlink() {
	[[ -h "$1" ]] && rm -f "$1" && return 0
	! [[ -e "$1" ]] && return 0
	return 1
}

#Like "ln -sf", but will not proceed if target is not link and exists (ie. will not erase files).
_relink_sequence() {

	#Do not update correct symlink.
	local existingLinkTarget
	existingLinkTarget=$(readlink "$2")
	[[ "$existingLinkTarget" == "$1" ]] && return 0
	
	! [[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s "$1" "$2" && return 0
	[[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s -r "$1" "$2" && return 0
	
	return 1
}

_relink() {
	[[ "$relinkRelativeUb" == "true" ]] && export relinkRelativeUb=""
	_relink_sequence "$@"
}

_relink_relative() {
	export relinkRelativeUb="true"
	_relink_sequence "$@"
	export relinkRelativeUb=""
	unset relinkRelativeUb
}

#Copies files only if source/destination do match. Keeps files in a completely written state as often as possible.
_cpDiff() {
	! diff "$1" "$2" > /dev/null 2>&1 && cp "$1" "$2"
}

_wait_umount() {
	sudo -n umount "$1"
	mountpoint "$1" > /dev/null 2>&1 || return 0
	sleep 0.1
	
	sudo -n umount "$1"
	mountpoint "$1" > /dev/null 2>&1 || return 0
	sleep 0.3
	
	[[ "$EMERGENCYSHUTDOWN" == "true" ]] && return 1
	
	sudo -n umount "$1"
	mountpoint "$1" > /dev/null 2>&1 || return 0
	sleep 1
	
	sudo -n umount "$1"
	mountpoint "$1" > /dev/null 2>&1 || return 0
	sleep 3
	
	sudo -n umount "$1"
	mountpoint "$1" > /dev/null 2>&1 || return 0
	sleep 9
	
	return 1
} 

_testMountChecks() {
	_getDep mountpoint
}

#"$1" == test directory
#"$2" == flag file
_flagMount() {
	# TODO: Possible stability/portability improvements.
	#https://unix.stackexchange.com/questions/248472/finding-mount-points-with-the-find-command
	
	mountpoint "$1" >/dev/null 2>&1 && echo -n true > "$2"
}

#Searches directory for mounted filesystems.
# DANGER Do not drop requirement for sudo. As this function represents a final fail-safe, filesystem permissions cannot be allowed to interfere.
#"$1" == test directory
_checkForMounts() {
	_mustGetSudo || return 0
	
	_start
	
	#If test directory itself is a directory, further testing is not necessary.
	sudo -n mountpoint "$1" > /dev/null 2>&1 && _stop 0
	
	local mountCheckFile="$safeTmp"/mc-$(_uid)
	
	echo -n false > "$mountCheckFile"
	
	#Sanity check, file exists.
	! [[ -e "$mountCheckFile" ]] && _stop 0
	
	# TODO: Possible stability/portability improvements.
	#https://unix.stackexchange.com/questions/248472/finding-mount-points-with-the-find-command
	
	find "$1" -type d -exec sudo -n mountpoint {} 2>/dev/null \; | grep 'is a mountpoint' >/dev/null 2>&1 && echo -n true > "$mountCheckFile"
	
	#find "$1" -type d -exec "$scriptAbsoluteLocation" {} "$mountCheckFile" \;
	
	local includesMount
	includesMount=$(cat "$mountCheckFile")
	
	#Thorough sanity checking.
	[[ "$includesMount" != "false" ]] && _stop 0
	[[ "$includesMount" == "true" ]] && _stop 0
	[[ "$includesMount" == "false" ]] && _stop 1
	
	_stop 0
}

#Waits for the process PID specified by first parameter to end. Useful in conjunction with $! to provide process control and/or PID files. Unlike wait command, does not require PID to be a child of the current shell.
_pauseForProcess() {
	while ps --no-headers -p $1 &> /dev/null
	do
		sleep 0.3
	done
}
alias _waitForProcess=_pauseForProcess
alias waitForProcess=_pauseForProcess

_test_daemon() {
	_getDep pkill
}

#To ensure the lowest descendents are terminated first, the file must be created in reverse order. Additionally, PID files created before a prior reboot must be discarded and ignored.
_prependDaemonPID() {
	
	#Reset locks from before prior reboot.
	_readLocked "$daemonPidFile"lk
	_readLocked "$daemonPidFile"op
	_readLocked "$daemonPidFile"cl
	
	while true
	do
		_createLocked "$daemonPidFile"op && break
		sleep 0.1
	done
	
	#Removes old PID file if not locked during current UNIX session (ie. since latest reboot).  Prevents termination of non-daemon PIDs.
	if ! _readLocked "$daemonPidFile"lk
	then
		rm -f "$daemonPidFile"
		rm -f "$daemonPidFile"t
	fi
	_createLocked "$daemonPidFile"lk
	
	[[ ! -e "$daemonPidFile" ]] && echo >> "$daemonPidFile"
	cat - "$daemonPidFile" >> "$daemonPidFile"t
	mv "$daemonPidFile"t "$daemonPidFile"
	
	rm -f "$daemonPidFile"op
}

#By default, process descendents will be terminated first. Doing so is essential to reaching sub-proesses of sub-scripts, without manual user input.
#https://stackoverflow.com/questions/34438189/bash-sleep-process-not-getting-killed
_daemonSendTERM() {
	#Terminate descendents if parent has not been able to quit.
	pkill -P "$1"
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.1
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.3
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 2
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 6
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 9
	
	#Kill descendents if parent has not been able to quit.
	pkill -KILL -P "$1"
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.1
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.3
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 2
	
	#Terminate parent if parent has not been able to quit.
	kill -TERM "$1"
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.1
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.3
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 2
	
	#Kill parent if parent has not been able to quit.
	kill KILL "$1"
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.1
	! ps -p "$1" >/dev/null 2>&1 && return 0
	sleep 0.3
	
	#Failure to immediately kill parent is an extremely rare, serious error.
	ps -p "$1" >/dev/null 2>&1 && return 1
	return 0
}

#No production use.
_daemonSendKILL() {
	pkill -KILL -P "$1"
	kill -KILL "$1"
}

#True if any daemon registered process is running.
_daemonAction() {
	[[ ! -e "$daemonPidFile" ]] && return 1
	
	local currentLine
	local processedLine
	local daemonStatus
	
	while IFS='' read -r currentLine || [[ -n "$currentLine" ]]; do
		processedLine=$(echo "$currentLine" | tr -dc '0-9')
		if [[ "$processedLine" != "" ]] && ps -p "$processedLine" >/dev/null 2>&1
		then
			daemonStatus="up"
			[[ "$1" == "status" ]] && return 0
			[[ "$1" == "terminate" ]] && _daemonSendTERM "$processedLine"
			[[ "$1" == "kill" ]] && _daemonSendKILL "$processedLine"
		fi
	done < "$daemonPidFile"
	
	[[ "$daemonStatus" == "up" ]] && return 0
	return 1
}

_daemonStatus() {
	_daemonAction "status"
}

#No production use.
_waitForTermination() {
	_daemonStatus && sleep 0.1
	_daemonStatus && sleep 0.3
	_daemonStatus && sleep 1
	_daemonStatus && sleep 2
}
alias _waitForDaemon=_waitForTermination

#Kills background process using PID file.
_killDaemon() {
	#Do NOT proceed if PID values may be invalid.
	! _readLocked "$daemonPidFile"lk && return 1
	
	#Do NOT proceed if daemon is starting (opening).
	_readLocked "$daemonPidFile"op && return 1
	
	! _createLocked "$daemonPidFile"cl && return 1
	
	#Do NOT proceed if daemon is starting (opening).
	_readLocked "$daemonPidFile"op && return 1
	
	_daemonAction "terminate"
	
	#Do NOT proceed to detele lock/PID files unless daemon can be confirmed down.
	_daemonStatus && return 1
	
	rm -f "$daemonPidFile" >/dev/null 2>&1
	rm -f "$daemonPidFile"lk
	rm -f "$daemonPidFile"cl
	
	return 0
}

_cmdDaemon() {
	export isDaemon=true
	
	"$@" &
	
	#Any PID which may be part of a daemon may be appended to this file.
	echo "$!" | _prependDaemonPID
}

#Executes self in background (ie. as daemon).
_execDaemon() {
	#_daemonStatus && return 1
	
	_cmdDaemon "$scriptAbsoluteLocation"
}

_launchDaemon() {
	_start
	
	_killDaemon
	
	
	_execDaemon
	while _daemonStatus
	do
		sleep 5
	done
	
	
	
	
	
	_stop
}

#Remote TERM signal wrapper. Verifies script is actually running at the specified PID before passing along signal to trigger an emergency stop.
#"$1" == pidFile
#"$2" == sessionid (optional for cleaning up stale systemd files)
_remoteSigTERM() {
	[[ ! -e "$1" ]] && [[ "$2" != "" ]] && _unhook_systemd_shutdown "$2"
	
	[[ ! -e "$1" ]] && return 0
	
	pidToTERM=$(cat "$1")
	
	kill -TERM "$pidToTERM"
	
	_pauseForProcess "$pidToTERM"
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

_validatePort() {
	[[ "$1" -lt "1024" ]] && return 1
	[[ "$1" -gt "65535" ]] && return 1
	
	return 0
}

_testFindPort() {
	_getDep ss
	
	local machineLowerPort=$(cat /proc/sys/net/ipv4/ip_local_port_range | cut -f1)
	local machineUpperPort=$(cat /proc/sys/net/ipv4/ip_local_port_range | cut -f2)
	
	[[ "$machineLowerPort" -lt "1024" ]] && echo "invalid lower_port" && _stop 1
	[[ "$machineLowerPort" -lt "32768" ]] && echo "warn: low lower_port"
	[[ "$machineLowerPort" -gt "32768" ]] && echo "warn: high lower_port"
	
	[[ "$machineUpperPort" -gt "65535" ]] && echo "invalid upper_port" && _stop 1
	[[ "$machineUpperPort" -gt "60999" ]] && echo "warn: high upper_port"
	[[ "$machineUpperPort" -lt "60999" ]] && echo "warn: low upper_port"
	
	local testFoundPort
	testFoundPort=$(_findPort)
	! _validatePort "$testFoundPort" && echo "invalid port discovery" && _stop 1
}


#http://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port
_findPort() {
	local lower_port
	local upper_port
	
	lower_port="$1"
	upper_port="$2"
	
	#Non public ports are between 49152-65535 (2^15 + 2^14 to 2^16 − 1).
	#Convention is to assign ports 55000-65499 and 50025-53999 to specialized servers.
	#read lower_port upper_port < /proc/sys/net/ipv4/ip_local_port_range
	[[ "$lower_port" == "" ]] && lower_port=54000
	[[ "$upper_port" == "" ]] && upper_port=54999
	
	local range_port
	local rand_max
	let range_port="upper_port - lower_port"
	let rand_max="range_port / 2"
	
	local portRangeOffset
	portRangeOffset=$RANDOM
	#let "portRangeOffset %= 150"
	let "portRangeOffset %= rand_max"
	
	[[ "$opsautoGenerationMode" == "true" ]] && [[ "$lowestUsedPort" == "" ]] && export lowestUsedPort="$lower_port"
	[[ "$opsautoGenerationMode" == "true" ]] && lower_port="$lowestUsedPort"
	
	! [[ "$opsautoGenerationMode" == "true" ]] && let "lower_port += portRangeOffset"
	
	while true
	do
		for (( currentPort = lower_port ; currentPort <= upper_port ; currentPort++ )); do
			if ! ss -lpn | grep ":$currentPort " > /dev/null 2>&1
			then
				sleep 0.1
				if ! ss -lpn | grep ":$currentPort " > /dev/null 2>&1
				then
					break 2
				fi
			fi
		done
	done
	
	if [[ "$opsautoGenerationMode" == "true" ]]
	then
		local nextUsablePort
		
		let "nextUsablePort = currentPort + 1"
		export lowestUsedPort="$nextUsablePort"
		
	fi
	
	echo $currentPort
	
	_validatePort "$currentPort"
}

_test_waitport() {
	_getDep nmap
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkPort() {
	if nmap -Pn "$1" -p "$2" 2> /dev/null | grep open > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}

#Waits a reasonable time interval for port to be open.
#"$1" == hostname
#"$2" == port
_waitPort() {
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.1
	_checkPort "$1" "$2" && return 0
	sleep 0.3
	_checkPort "$1" "$2" && return 0
	sleep 0.3
	_checkPort "$1" "$2" && return 0
	sleep 0.6
	
	local checksDone
	checksDone=0
	while ! _checkPort "$1" "$2" && [[ "$checksDone" -lt 72 ]]
	do
		let checksDone+=1
		sleep 1
	done
	
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

_typeDep() {
	[[ -e /lib/"$1" ]] && return 0
	[[ -e /lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /lib64/"$1" ]] && return 0
	[[ -e /lib64/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/lib/"$1" ]] && return 0
	[[ -e /usr/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/local/lib/"$1" ]] && return 0
	[[ -e /usr/local/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/include/"$1" ]] && return 0
	[[ -e /usr/local/include/"$1" ]] && return 0
	
	if ! type "$1" >/dev/null 2>&1
	then
		return 1
	fi
	
	return 0
}

_wantDep() {
	_typeDep "$1" && return 0
	
	_wantSudo && sudo -n "$scriptAbsoluteLocation" _typeDep "$1" && return 0
	
	return 1
}

_mustGetDep() {
	_typeDep "$1" && return 0
	
	_wantSudo && sudo -n "$scriptAbsoluteLocation" _typeDep "$1" && return 0
	
	echo "$1" missing
	_stop 1
}

_fetchDep_distro() {
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	then
		_tryExecFull _fetchDep_debian "$@"
		return
	fi
	return 1
}

_wantGetDep() {
	_wantDep "$@" && return 0
	
	_fetchDep_distro "$@"
	
	_wantDep "$@" && return 0
	return 1
}

_getDep() {
	_wantDep "$@" && return 0
	
	_fetchDep_distro "$@"
	
	_mustGetDep "$@"
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
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && exit 1
	
	return 0
}

#Determines if sudo is usable by scripts. Will not exit on failure.
_wantSudo() {
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true 2> /dev/null)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && return 1
	
	return 0
}

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
_getUUID() {
	cat /proc/sys/kernel/random/uuid
}
alias getUUID=_getUUID

#####Global variables.
#Fixed unique identifier for ubiquitious bash created global resources, such as bootdisc images to be automaticaly mounted by guests. Should NOT be changed.
export ubiquitiousBashID="uk4uPhB663kVcygT0q"

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
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])  && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
then
	ub_import=true
	true #Do not override.
	_messagePlain_probe_expr 'parent: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''parent: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''parent: sessionid= '"$sessionid" | _user_log-ub
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ([[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]])
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
	_messagePlain_bad 'import: fall: fail' | _user_log-ub && return 1
	exit 1
fi
[[ "$importScriptLocation" != "" ]] && export importScriptLocation=
[[ "$importScriptFolder" != "" ]] && export importScriptFolder=

[[ ! -e "$scriptAbsoluteLocation" ]] && _messagePlain_bad 'missing: scriptAbsoluteLocation= '"$scriptAbsoluteLocation" | _user_log-ub && exit 1
[[ "$sessionid" == "" ]] && _messagePlain_bad 'missing: sessionid' | _user_log-ub && exit 1

export lowsessionid=$(echo -n "$sessionid" | tr A-Z a-z )

#Current directory for preservation.
export outerPWD=$(_getAbsoluteLocation "$PWD")

export initPWD="$PWD"
intInitPWD="$PWD"

#Temporary directories.
export safeTmp="$scriptAbsoluteFolder"/w_"$sessionid"
export logTmp="$safeTmp"/log
export shortTmp=/tmp/w_"$sessionid"	#Solely for misbehaved applications called upon.
export scriptBin="$scriptAbsoluteFolder"/_bin
export scriptBundle="$scriptAbsoluteFolder"/_bundle
export scriptLib="$scriptAbsoluteFolder"/_lib
#For trivial installations and virtualized guests. Exclusively intended to support _setupUbiquitous and _drop* hooks.
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"
[[ ! -e "$scriptBundle" ]] && export scriptBundle="$scriptAbsoluteFolder"
[[ ! -e "$scriptLib" ]] && export scriptLib="$scriptAbsoluteFolder"


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

#Essentially temporary tokens which may need to be reused. 
export scriptTokens="$scriptLocal"/.tokens

#Reboot Detection Token Storage
# WARNING WIP. Not tested on all platforms. Requires a directory to be tmp/ram fs mounted. Worst case result is to preserve tokens across reboots.
export bootTmp="$scriptLocal"			#Fail-Safe
[[ -d /tmp ]] && export bootTmp=/tmp		#Typical BSD
[[ -d /dev/shm ]] && export bootTmp=/dev/shm	#Typical Linux

#Specialized temporary directories.
# Unusually, safeTmpSSH must not be interpreted by client, and therefore is single quoted.
# TODO Test safeTmpSSH variants including spaces in path.
export safeTmpSSH='~/.sshtmp/.s_'"$sessionid"

#Process control.
export pidFile="$safeTmp"/.pid
export uPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"	#Invalid do-not-match default.

export daemonPidFile="$scriptLocal"/.bgpid

#export varStore="$scriptAbsoluteFolder"/var

export vncPasswdFile="$safeTmp"/.vncpasswd

#Network Defaults
export AUTOSSH_FIRST_POLL=45
export AUTOSSH_POLL=45
#export AUTOSSH_GATETIME=0
export AUTOSSH_GATETIME=15

#export AUTOSSH_PORT=0

#export AUTOSSH_DEBUG=1
#export AUTOSSH_LOGLEVEL=7

#Monolithic shared files.
export lock_pathlock="$scriptLocal"/l_path
export lock_quicktmp="$scriptLocal"/l_qt	#Used to make locking operations atomic as possible.
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


_findUbiquitous() {
	export ubiquitiousLibDir="$scriptAbsoluteFolder"
	
	local scriptBasename=$(basename "$scriptAbsoluteFolder")
	if [[ "$scriptBasename" == "ubiquitous_bash" ]]
	then
		return 0
	fi
	
	if [[ -e "$ubiquitiousLibDir"/_lib/ubiquitous_bash ]]
	then
		export ubiquitiousLibDir="$ubiquitiousLibDir"/_lib/ubiquitous_bash
		return 0
	fi
	
	local ubiquitiousLibDirDiscovery=$(find ./_lib -maxdepth 3 -type d -name 'ubiquitous_bash' | head -n 1)
	if [[ "$ubiquitiousLibDirDiscovery" != "" ]] && [[ -e "$ubiquitiousLibDirDiscovery" ]]
	then
		export ubiquitiousLibDir="$ubiquitiousLibDirDiscovery"
		return 0
	fi
	
	return 1
}


_init_deps() {
	export enUb_set="true"
	
	export enUb_machineinfo=""
	export enUb_git=""
	export enUb_bup=""
	export enUb_notLean=""
	export enUb_build=""
	export enUb_os_x11=""
	export enUb_proxy=""
	export enUb_proxy_special=""
	export enUb_x11=""
	export enUb_blockchain=""
	export enUb_image=""
	export enUb_virt=""
	export enUb_ChRoot=""
	export enUb_QEMU=""
	export enUb_vbox=""
	export enUb_docker=""
	export enUb_wine=""
	export enUb_DosBox=""
	export enUb_msw=""
	export enUb_fakehome=""
	export enUb_buildBash=""
	export enUb_buildBashUbiquitous=""
	
	export enUb_command=""
	export enUb_synergy=""
	
	export enUb_hardware=""
	export enUb_enUb_x220t=""
	
	export enUb_user=""
}


_deps_machineinfo() {
	export enUb_machineinfo="true"
}

_deps_git() {
	export enUb_git="true"
}

_deps_bup() {
	export enUb_bup="true"
}

_deps_notLean() {
	_deps_git
	_deps_bup
	export enUb_notLean="true"
}

_deps_build() {
	export enUb_build="true"
}

#Note that '_build_bash' does not incur '_build', expected to require only scripted concatenation.
_deps_build_bash() {
	export enUb_buildBash="true"
}

_deps_build_bash_ubiquitous() {
	_deps_build_bash
	export enUb_buildBashUbiquitous="true"
}

_deps_os_x11() {
	export enUb_os_x11="true"
}

_deps_proxy() {
	export enUb_proxy="true"
}

_deps_proxy_special() {
	_deps_proxy
	export enUb_proxy_special="true"
}

_deps_x11() {
	_deps_build
	_deps_notLean
	export enUb_x11="true"
}

_deps_blockchain() {
	_deps_notLean
	_deps_x11
	export enUb_blockchain="true"
}

_deps_image() {
	_deps_notLean
	_deps_machineinfo
	export enUb_image="true"
}

_deps_virt() {
	_deps_build
	_deps_notLean
	_deps_machineinfo
	_deps_image
	export enUb_virt="true"
}

_deps_chroot() {
	_deps_virt
	export enUb_ChRoot="true"
}

_deps_qemu() {
	_deps_virt
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_virt
	export enUb_vbox="true"
}

_deps_docker() {
	_deps_virt
	export enUb_docker="true"
}

_deps_wine() {
	_deps_notLean
	export enUb_wine="true"
}

_deps_dosbox() {
	_deps_notLean
	export enUb_DosBox="true"
}

_deps_msw() {
	_deps_virt
	_deps_qemu
	_deps_vbox
	_deps_wine
	export enUb_msw="true"
}

_deps_fakehome() {
	_deps_notLean
	export enUb_fakehome="true"
}

_deps_command() {
	_deps_os_x11
	_deps_proxy
	_deps_proxy_special
	
	export enUb_command="true"
}

_deps_synergy() {
	_deps_command
	export enUb_synergy="true"
}

_deps_hardware() {
	_deps_notLean
	export enUb_hardware="true"
}

_deps_x220t() {
	_deps_notLean
	_deps_hardware
	export enUb_x220t="true"
}

_deps_user() {
	_deps_notLean
	export enUb_user="true"
}


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
	
	_compile_bash_selfHost
	
	_compile_bash_overrides
	
	_includeScripts "${includeScriptList[@]}"
	
	#Default command.
	echo >> "$progScript"
	echo '_generate_compile_bash "$@"' >> "$progScript"
	echo 'exit 0' >> "$progScript"
	
	chmod u+x "$progScript"
	
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
	
	[[ "$1" != "" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash "$@"
	
	_generate_compile_bash_prog
	
	# DANGER Do NOT remove.
	exit 0
}

# #No production use. Unmaintained, obsolete. Never used literally. Preserved as an example command set to build the otherwise self-hosted generate/compile script manually (ie. bootstrapping).
# _bootstrap_bash_basic() {
# 	cat "generic"/minimalheader.sh "labels"/utilitiesLabel.sh "generic/filesystem"/absolutepaths.sh "generic/filesystem"/safedelete.sh "generic/process"/timeout.sh "generic"/uid.sh "generic/filesystem/permissions"/checkpermissions.sh "build/bash"/include.sh "structure"/globalvars.sh "build/bash/ubiquitous"/discoverubiquitious.sh "build/bash/ubiquitous"/depsubiquitous.sh "build/bash"/generate.sh "build/bash"/compile.sh "structure"/overrides.sh > ./compile.sh
# 	echo >> ./compile.sh
# 	echo _generate_compile_bash >> ./compile.sh
# 	chmod u+x ./compile.sh
# }

_generate_compile_bash_prog() {
	"$scriptAbsoluteLocation" _true
	
	return
	
	rm "$scriptAbsoluteFolder"/ubiquitous_bash.sh
	
	#"$scriptAbsoluteLocation" _compile_bash cautossh cautossh
	#"$scriptAbsoluteLocation" _compile_bash lean lean.sh
	
	"$scriptAbsoluteLocation" _compile_bash core ubiquitous_bash.sh
	
	#"$scriptAbsoluteLocation" _compile_bash "" ""
	#"$scriptAbsoluteLocation" _compile_bash ubiquitous_bash ubiquitous_bash.sh
	
	#"$scriptAbsoluteLocation" _package
}

#Default is to include all, or run a specified configuration. For this reason, it will be more typical to override this entire function, rather than append any additional code.
_compile_bash_deps() {
	[[ "$1" == "lean" ]] && return 0
	
	if [[ "$1" == "cautossh" ]]
	then
		_deps_os_x11
		_deps_proxy
		_deps_proxy_special
		
		_deps_git
		_deps_bup
		
		_deps_command
		_deps_synergy
		
		return 0
	fi
	
	if [[ "$1" == "core" ]]
	then
		_deps_notLean
		_deps_os_x11
		
		_deps_x11
		_deps_image
		_deps_virt
		_deps_chroot
		_deps_qemu
		_deps_vbox
		#_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		
		_deps_git
		_deps_bup
		
		#_deps_blockchain
		
		#_deps_command
		#_deps_synergy
		
		#_deps_hardware
		#_deps_x220t
		
		#_deps_user
		
		#_deps_proxy
		#_deps_proxy_special
		
		_deps_build
		
		_deps_build_bash
		_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	if [[ "$1" == "" ]] || [[ "$1" == "ubiquitous_bash" ]] || [[ "$1" == "ubiquitous_bash.sh" ]] || [[ "$1" == "complete" ]]
	then
		_deps_notLean
		_deps_os_x11
		
		_deps_x11
		_deps_image
		_deps_virt
		_deps_chroot
		_deps_qemu
		_deps_vbox
		_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		
		_deps_git
		_deps_bup
		
		_deps_blockchain
		
		_deps_command
		_deps_synergy
		
		_deps_hardware
		_deps_x220t
		
		_deps_user
		
		_deps_proxy
		_deps_proxy_special
		
		_deps_build
		
		_deps_build_bash
		_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	return 1
}

_vars_compile_bash() {
	export configDir="$scriptAbsoluteFolder"/_config
	
	export progDir="$scriptAbsoluteFolder"/_prog
	export progScript="$scriptAbsoluteFolder"/ubiquitous_bash.sh
	[[ "$1" != "" ]] && export progScript="$scriptAbsoluteFolder"/"$1"
	
	_vars_compile_bash_prog "$@"
}

_compile_bash_header() {
	export includeScriptList
	
	includeScriptList+=( "generic"/minimalheader.sh )
	includeScriptList+=( "generic"/ubiquitousheader.sh )
	
	includeScriptList+=( "os/override"/override.sh )
	includeScriptList+=( "os/override"/override_prog.sh )
}

_compile_bash_header_program() {
	export includeScriptList
	
	includeScriptList+=( progheader.sh )
}

_compile_bash_essential_utilities() {
	export includeScriptList
	
	#####Essential Utilities
	includeScriptList+=( "labels"/utilitiesLabel.sh )
	includeScriptList+=( "generic/filesystem"/absolutepaths.sh )
	includeScriptList+=( "generic/filesystem"/safedelete.sh )
	includeScriptList+=( "generic/process"/timeout.sh )
	includeScriptList+=( "generic/process"/terminate.sh )
	includeScriptList+=( "generic"/uid.sh )
	includeScriptList+=( "generic/filesystem/permissions"/checkpermissions.sh )
	includeScriptList+=( "generic"/findInfrastructure.sh )
	includeScriptList+=( "generic"/gather.sh )
	
	includeScriptList+=( "generic"/messaging.sh )
	
	[[ "$enUb_buildBash" == "true" ]] && includeScriptList+=( "build/bash"/include_bash.sh )
}

_compile_bash_utilities() {
	export includeScriptList
	
	#####Utilities
	includeScriptList+=( "generic/filesystem"/getext.sh )
	
	includeScriptList+=( "generic/filesystem"/finddir.sh )
	
	includeScriptList+=( "generic/filesystem"/discoverresource.sh )
	
	includeScriptList+=( "generic/filesystem"/relink.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/bindmountmanager.sh )
	
	includeScriptList+=( "generic/filesystem/mounts"/waitumount.sh )
	
	includeScriptList+=( "generic/filesystem/mounts"/mountchecks.sh )
	
	includeScriptList+=( "generic/process"/waitforprocess.sh )
	
	includeScriptList+=( "generic/process"/daemon.sh )
	
	includeScriptList+=( "generic/process"/remotesig.sh )
	
	includeScriptList+=( "generic/net"/fetch.sh )
	
	includeScriptList+=( "generic/net"/findport.sh )
	
	includeScriptList+=( "generic/net"/waitport.sh )
	
	[[ "$enUb_proxy_special" == "true" ]] && includeScriptList+=( "generic/net/proxy/tor"/tor.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/here_ssh.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/ssh.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/autossh.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/here_proxyrouter.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/proxyrouter.sh )
	
	includeScriptList+=( "generic"/showCommand.sh )
	includeScriptList+=( "generic"/validaterequest.sh )
	
	includeScriptList+=( "generic"/preserveLog.sh )
	
	[[ "$enUb_os_x11" == "true" ]] && includeScriptList+=( "os/unix/x11"/findx11.sh )
	
	includeScriptList+=( "os"/getDep.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/distro/debian"/getDep_debian.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/unix/systemd"/here_systemd.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/unix/systemd"/hook_systemd.sh )
	
	includeScriptList+=( "special"/mustberoot.sh )
	includeScriptList+=( "special"/mustgetsudo.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "special/gosu"/gosu.sh )
	
	includeScriptList+=( "special"/uuid.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "instrumentation"/bashdb/bashdb.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "instrumentation"/profiling/stopwatch.sh )
}

_compile_bash_utilities_virtualization() {
	export includeScriptList
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtenv.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/findInfrastructure_virt.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/osTranslation.sh )
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/localPathTranslation.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehome.sh )
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/mountimage.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/createImage.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/here_bootdisc.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/bootdisc.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/userpersistenthome.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/transferimage.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/testchroot.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/procchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/mountchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/enterchroot.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/mountchrootuser.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/userchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/dropchroot.sh )
	
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-raspi-raspi.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-x64-raspi.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-x64-x64.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu.sh )
	
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxtest.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxmount.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxlab.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxuser.sh )
	
	[[ "$enUb_DosBox" == "true" ]] && includeScriptList+=( "virtualization/dosbox"/here_dosbox.sh )
	[[ "$enUb_DosBox" == "true" ]] && includeScriptList+=( "virtualization/dosbox"/dosbox.sh )
	
	[[ "$enUb_wine" == "true" ]] && includeScriptList+=( "virtualization/wine"/wine.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/here_docker.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockerdrop.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockertest.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockerchecks.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockeruser.sh )
}

_compile_bash_shortcuts() {
	export includeScriptList
	
	
	#####Shortcuts
	includeScriptList+=( "labels"/shortcutsLabel.sh )
	
	includeScriptList+=( "shortcuts/prompt"/visualPrompt.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "shortcuts/dev"/devsearch.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devemacs.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devatom.sh )
	
	[[ "$enUb_git" == "true" ]] && includeScriptList+=( "shortcuts/git"/git.sh )
	[[ "$enUb_git" == "true" ]] && includeScriptList+=( "shortcuts/git"/gitBare.sh )
	
	[[ "$enUb_bup" == "true" ]] && includeScriptList+=( "shortcuts/bup"/bup.sh )
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/here_mkboot.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/mkboot.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "shortcuts/distro"/distro.sh )
	
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "shortcuts/distro/debian"/createDebian.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/distro/raspbian"/createRaspbian.sh )
	
	[[ "$enUb_msw" == "true" ]] && includeScriptList+=( "shortcuts/distro/msw"/msw.sh )
	
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11"/testx11.sh )
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11"/xinput.sh )
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11/clipboard"/x11ClipboardImage.sh )
	
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11/desktop/kde4x"/kde4x.sh )
	
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "shortcuts/vbox"/vboxconvert.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerassets.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerdelete.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercreate.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerconvert.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerportation.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercontainer.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercontainer.sh )
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/image"/gparted.sh )
}

_compile_bash_shortcuts_setup() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts"/setupUbiquitous_here.sh )
	includeScriptList+=( "shortcuts"/setupUbiquitous.sh )
}

_compile_bash_bundled() {
	export includeScriptList
	
	
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain"/blockchain.sh )
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain/ethereum"/ethereum.sh )
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "shortcuts/blockchain/ethereum"/ethereum.sh )
	
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain/ethereum"/ethereum_parity.sh )
}

_compile_bash_command() {
	[[ "$enUb_command" == "true" ]] && includeScriptList+=( "generic/net/command"/command.sh )
	
	[[ "$enUb_command" == "true" ]] && [[ "$enUb_synergy" == "true" ]] && includeScriptList+=( "generic/net/command/synergy"/here_synergy.sh )
	[[ "$enUb_command" == "true" ]] && [[ "$enUb_synergy" == "true" ]] && includeScriptList+=( "generic/net/command/synergy"/synergy.sh )
}

_compile_bash_user() {
	true
}

_compile_bash_hardware() {
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_x220t" == "true" ]] && includeScriptList+=( "hardware/x220t"/x220_display.sh )
}

_compile_bash_vars_basic() {
	export includeScriptList
	
	
	#####Basic Variable Management
	includeScriptList+=( "labels"/basicvarLabel.sh )
}

_compile_bash_vars_global() {
	export includeScriptList
	
	
	#####Global variables.
	includeScriptList+=( "structure"/globalvars.sh )
}

_compile_bash_vars_spec() {
	export includeScriptList
	
	
	[[ "$enUb_machineinfo" == "true" ]] && includeScriptList+=( "special/machineinfo"/machinevars.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtvars.sh )
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/image/imagevars.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/sshvars.sh )
	
	
	includeScriptList+=( "structure"/specglobalvars.sh )
}

_compile_bash_vars_shortcuts() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts/git"/gitVars.sh )
}

_compile_bash_vars_virtualization() {
	export includeScriptList
	
	
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomevars.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxvars.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockervars.sh )
}

_compile_bash_vars_bundled() {
	export includeScriptList
	
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/sshvars.sh )
}

_compile_bash_buildin() {
	export includeScriptList
	
	[[ "$enUb_build" == "true" ]] && includeScriptList+=( "generic/hello"/hello.sh )
	[[ "$enUb_build" == "true" ]] && [[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "generic/process"/idle.sh )
	
	[[ "$enUb_build" == "true" ]] && includeScriptList+=( "structure"/build.sh )
}

_compile_bash_environment() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/localfs.sh )
	
	includeScriptList+=( "structure"/localenv.sh )
}

_compile_bash_installation() {
	export includeScriptList
	
	includeScriptList+=( "structure"/installation.sh )
	includeScriptList+=( "structure"/installation_prog.sh )
}

_compile_bash_program() {
	export includeScriptList
	
	
	includeScriptList+=( core.sh )
	
	includeScriptList+=( "structure"/program.sh )
}

_compile_bash_config() {
	export includeScriptList
	
	
	#####Hardcoded
	includeScriptList+=( netvars.sh )
}

_compile_bash_selfHost() {
	export includeScriptList
	
	
	#####Generate/Compile
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitious.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash/ubiquitous"/depsubiquitous.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( deps.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/generate_bash.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/generate_bash_prog.sh )
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/compile_bash.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/compile_bash_prog.sh )
}

_compile_bash_overrides() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/overrides.sh )
}

_compile_bash_entry() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/entry.sh )
}

#Ubiquitous Bash compile script. Override with "ops", "_config", or "_prog" directives through "compile_bash_prog.sh" to compile other work products through similar scripting.
# "$1" == configuration
# "$2" == output filename
# DANGER
#Especially, be careful to explicitly check all prerequsites for _safeRMR are in place.
# DANGER
# Intended only for manual use, or within a memory cached function terminated by "exit". Launching through "$scriptAbsoluteLocation" is not adequate protection if the original script itself can reach modified code!
# However, launching through "$scriptAbsoluteLocation" can be used to run a command within the new version fo the script. Use this capability only with full understanding of this notification. 
# WARNING
#Beware lean configurations may not have been properly tested, and are of course intended for developer use. Their purpose is to disable irrelevant dependency checking in "_test" procedures. Rigorous test procedures covering all intended functionality should always be included in downstream projects. Pull requests welcome.
_compile_bash() {
	_findUbiquitous
	_vars_compile_bash "$2"
	
	#####
	
	_compile_bash_deps "$1"
	_compile_bash_deps_prog "$1"
	
	#####
	
	rm "$progScript" >/dev/null 2>&1
	
	export includeScriptList
	
	_compile_bash_header
	_compile_bash_header_prog
	_compile_bash_header_program
	_compile_bash_header_program_prog
	
	_compile_bash_essential_utilities
	_compile_bash_essential_utilities_prog
	_compile_bash_utilities
	_compile_bash_utilities_prog
	_compile_bash_utilities_virtualization
	_compile_bash_utilities_virtualization_prog
	
	_compile_bash_shortcuts
	_compile_bash_shortcuts_prog
	_compile_bash_shortcuts_setup
	_compile_bash_shortcuts_setup_prog
	
	_compile_bash_bundled
	_compile_bash_bundled_prog
	
	_compile_bash_command
	
	_compile_bash_user
	
	_compile_bash_hardware
	
	_compile_bash_vars_basic
	_compile_bash_vars_basic_prog
	_compile_bash_vars_global
	_compile_bash_vars_global_prog
	_compile_bash_vars_spec
	_compile_bash_vars_spec_prog
	
	_compile_bash_vars_shortcuts
	_compile_bash_vars_shortcuts_prog
	
	_compile_bash_vars_virtualization
	_compile_bash_vars_virtualization_prog
	_compile_bash_vars_bundled
	_compile_bash_vars_bundled_prog
	
	_compile_bash_buildin
	_compile_bash_buildin_prog
	
	
	_compile_bash_environment
	_compile_bash_environment_prog
	
	_compile_bash_installation
	_compile_bash_installation_prog
	
	_compile_bash_program
	_compile_bash_program_prog
	
	
	_compile_bash_config
	_compile_bash_config_prog
	
	_compile_bash_selfHost
	_compile_bash_selfHost_prog
	
	
	_compile_bash_overrides
	_compile_bash_overrides_prog
	
	_compile_bash_entry
	_compile_bash_entry_prog
	
	
	
	_includeScripts "${includeScriptList[@]}"
	
	chmod u+x "$progScript"
	
	#if "$progScript" _test > ./compile.log 2>&1
	#then
	#	rm compile.log
	#else
	#	exit 1
	#fi
	
	#"$progScript" _package
	
	# DANGER Do NOT remove.
	exit 0
}

_compile_bash_deps_prog() {
	true
}

#Default is to include all, or run a specified configuration. For this reason, it will be more typical to override this entire function, rather than append any additional code.
# WARNING Find current version of this function at "build/bash/compile_bash.sh"
# _compile_bash_deps() {
# 	[[ "$1" == "lean" ]] && return 0
# 	
# 	false
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

#####Overrides

[[ "$isDaemon" == "true" ]] && echo "$$" | _prependDaemonPID

#May allow traps to work properly in simple scripts which do not include more comprehensive "_stop" or "_stop_emergency" implementations.
if ! type _stop > /dev/null 2>&1
then
	_stop() {
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
if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]]
then
	trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP QUIT PIPE 	# reset
	trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP QUIT PIPE 	# ignore
	
	trap 'excode=$?; _stop_emergency $excode; trap - EXIT; echo $excode' INT TERM	# reset
	trap 'excode=$?; trap "" EXIT; _stop_emergency $excode; echo $excode' INT TERM	# ignore
fi

#Override functions with external definitions from a separate file if available.
#if [[ -e "./ops" ]]
#then
#	. ./ops
#fi

#Override functions with external definitions from a separate file if available.
if [[ -e "$objectDir"/ops ]]
then
	. "$objectDir"/ops
fi
if [[ -e "$scriptLocal"/ops ]]
then
	. "$scriptLocal"/ops
fi
if [[ -e "$scriptLocal"/ssh/ops ]]
then
	. "$scriptLocal"/ssh/ops
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

#Wrapper function to launch arbitrary commands within the ubiquitous_bash environment, including its PATH with scriptBin.
_bin() {
	"$@"
}

#Launch internal functions as commands, and other commands, as root.
_sudo() {
	sudo -n "$scriptAbsoluteLocation" _bin "$@"
}

_true() {
	true
}
_false() {
	false
}
_echo() {
	echo "$@"
}

#Stop if script is imported, parameter not specified, and command not given.
[[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] && [[ "$1" != '_'* ]] && _messagePlain_warn 'import: missing: parameter, missing: command' | _user_log-ub && ub_import="" && return 1

#Set "ubOnlyMain" in "ops" overrides as necessary.
if [[ "$ubOnlyMain" != "true" ]]
then
	
	#Launch command named by link name.
	if scriptLinkCommand=$(_getScriptLinkName)
	then
		if [[ "$scriptLinkCommand" == '_'* ]]
		then
			"$scriptLinkCommand" "$@"
			internalFunctionExitStatus="$?"
			
			#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
			if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]]
			then
				#export noEmergency=true
				exit "$internalFunctionExitStatus"
			fi
			ub_import=""
			return "$internalFunctionExitStatus"
		fi
	fi
	
	# NOTICE Launch internal functions as commands.
	#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
	#if [[ "$1" == '_'* ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
	if [[ "$1" == '_'* ]]
	then
		"$@"
		internalFunctionExitStatus="$?"
		
		#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
		if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]]
		then
			#export noEmergency=true
			exit "$internalFunctionExitStatus"
		fi
		ub_import=""
		return "$internalFunctionExitStatus"
		#_stop "$?"
	fi
fi

[[ "$ubOnlyMain" == "true" ]] && export ubOnlyMain="false"

#Do not continue script execution through program code if critical global variables are not sane.
[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
_failExec || exit 1

#Return if script is under import mode, and bypass is not requested.
[[ "$ub_import" == "true" ]] && [[ "$ub_import_param" != "--bypass" ]] && return 0


_generate_compile_bash "$@"
exit 0
