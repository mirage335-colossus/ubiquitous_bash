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

#Blue. Diagnostic instrumentation.
_messagePlain_probe_var() {
	echo -e -n '\E[0;34m '
	
	echo -n "$1"'= '
	
	eval echo -e -n \$"$1"
	
	echo -e -n ' \E[0m'
	echo
	return 0
}
_messageVar() {
	_messagePlain_probe_var "$@"
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

_messagePlain_probe_expr '$0= '"$0"'\n ''$1= '"$1"'\n ''ub_import= '"$ub_import"'\n ''ub_import_param= '"$ub_import_param"'\n ''ub_import_script= '"$ub_import_script"'\n ''ub_loginshell= '"$ub_loginshell" | _user_log-ub

# DANGER Prohibited import from login shell. Use _setupUbiquitous, call from another script, or manually set importScriptLocation.
# WARNING Import from shell can be detected. Import from script cannot. Asserting that script has been imported is possible. Asserting that script has not been imported is not possible. Users may be protected from interactive mistakes. Script developers are NOT protected.
if [[ "$ub_import_param" == "--profile" ]]
then
	if ([[ "$profileScriptLocation" == "" ]] ||  [[ "$profileScriptFolder" == "" ]]) && _messagePlain_bad 'import: profile: missing: profileScriptLocation, missing: profileScriptFolder' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])
then
	if ([[ "$scriptAbsoluteLocation" == "" ]] || [[ "$scriptAbsoluteFolder" == "" ]] || [[ "$sessionid" == "" ]]) && _messagePlain_bad 'import: parent: missing: scriptAbsoluteLocation, missing: scriptAbsoluteFolder, missing: sessionid' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ([[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]])
then
	if ([[ "$importScriptLocation" == "" ]] ||  [[ "$importScriptFolder" == "" ]]) && _messagePlain_bad 'import: call: missing: importScriptLocation, missing: importScriptFolder' | _user_log-ub
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

#Override.

# WARNING: Only partially compatible.
if ! type md5sum > /dev/null 2>&1 && type md5 > /dev/null 2>&1
then
	md5sum() {
		md5
	}
fi

# DANGER: No production use. Testing only.
# WARNING: Only partially compatible.
#if ! type md5 > /dev/null 2>&1 && type md5sum > /dev/null 2>&1
#then
#	md5() {
#		md5sum
#	}
#fi

#Override (Program).

#####Utilities

_test_getAbsoluteLocation_sequence() {
	_start
	
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
	_start
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
	#! [[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && echo 'crit: missing: realpath' && _stop 1
	
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

_compat_realpath() {
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	#Workaround, Mac. See https://github.com/mirage335/ubiquitous_bash/issues/1 .
	export compat_realpath_bin=/opt/local/libexec/gnubin/realpath
	[[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && return 0
	
	export compat_realpath_bin=$(which realpath)
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


#Critical prerequsites.
_getAbsolute_criticalDep() {
	#! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	
	#Known to succeed under BusyBox (OpenWRT), NetBSD, and common Linux variants. No known failure modes. Extra precaution.
	! readlink -f . > /dev/null 2>&1 && return 1
	
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
	
	# WARNING: Allows removal of temporary folders created by current ubiquitous bash session only.
	[[ "$sessionid" != "" ]] && [[ "$1" == *"$sessionid"* ]] && safeToRM="true"
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
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
	
	# WARNING: Allows removal of temporary folders created by current ubiquitous bash session only.
	[[ "$sessionid" != "" ]] && [[ "$1" == *"$sessionid"* ]] && safeToRM="true"
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#! type realpath > /dev/null 2>&1 && return 1
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
	
	#! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	return 0
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

_terminate() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat "$safeTmp"/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

_terminateMetaHostAll() {
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
	
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 0.3
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 1
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 3
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 10
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	
	return 1
}

_terminateAll() {
	_terminateMetaHostAll
	
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	local currentPID
	
	
	cat ./.s_*/.pid >> "$processListFile" 2> /dev/null
	
	cat ./.e_*/.pid >> "$processListFile" 2> /dev/null
	cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
	
	cat ./w_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

#Generates random alphanumeric characters, default length 18.
_uid() {
	local curentLengthUID

	currentLengthUID="18"
	! [[ -z "$uidLengthPrefix" ]] && ! [[ "$uidLengthPrefix" -lt "18" ]] && currentLengthUID="$uidLengthPrefix"
	! [[ -z "$1" ]] && currentLengthUID="$1"

	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c "$currentLengthUID" 2> /dev/null
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
	
	local permissions_readout=$(_compat_stat_c_run "%a" "$1")
	
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
	
	permissions_uid=$(_compat_stat_c_run "%u" "$1")
	permissions_gid=$(_compat_stat_c_run "%g" "$1")
	
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

_self_critial() {
	_priority_critical_pid "$$"
}

_self_interactive() {
	_priority_interactive_pid "$$"
}

_self_background() {
	_priority_background_pid "$$"
}

_self_idle() {
	_priority_idle_pid "$$"
}

_self_app() {
	_priority_app_pid "$$"
}

_self_zero() {
	_priority_zero_pid "$$"
}


#Example.
_priority_critical() {
	_priority_dispatch "_priority_critical_pid"
}

_priority_critical_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 2 -n 2 -p "$1"
	! sudo -n renice -15 -p "$1" && return 1
	
	return 0
}

_priority_critical_pid() {
	[[ "$1" == "" ]] && return 1
	
	_priority_critical_pid_root "$1" && return 0
	
	ionice -c 2 -n 4 -p "$1"
	! renice 0 -p "$1" && return 1
	
	return 1
}

_priority_interactive_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 2 -n 2 -p "$1"
	! sudo -n renice -10 -p "$1" && return 1
	
	return 0
}

_priority_interactive_pid() {
	[[ "$1" == "" ]] && return 1
	
	_priority_interactive_pid_root "$1" && return 0
	
	ionice -c 2 -n 4 -p "$1"
	! renice 0 -p "$1" && return 1
	
	return 1
}

_priority_app_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 2 -n 3 -p "$1"
	! sudo -n renice -5 -p "$1" && return 1
	
	return 0
}

_priority_app_pid() {
	[[ "$1" == "" ]] && return 1
	
	_priority_app_pid_root "$1" && return 0
	
	ionice -c 2 -n 4 -p "$1"
	! renice 0 -p "$1" && return 1
	
	return 1
}

_priority_background_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 2 -n 5 -p "$1"
	! sudo -n renice +5 -p "$1" && return 1
	
	return 0
}

_priority_background_pid() {
	[[ "$1" == "" ]] && return 1
	
	if ! type ionice > /dev/null 2>&1 || ! groups | grep -E 'wheel|sudo' > /dev/null 2>&1
	then
		renice +5 -p "$1"
		return 0
	fi
	
	_priority_background_pid_root "$1" && return 0
	
	ionice -c 2 -n 5 -p "$1"
	
	renice +5 -p "$1"
}



_priority_idle_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 3 -p "$1"
	! sudo -n renice +15 -p "$1" && return 1
	
	return 0
}

_priority_idle_pid() {
	[[ "$1" == "" ]] && return 1
	
	if ! type ionice > /dev/null 2>&1 || ! groups | grep -E 'wheel|sudo' > /dev/null 2>&1
	then
		renice +15 -p "$1"
		return 0
	fi
	
	_priority_idle_pid_root "$1" && return 0
	
	#https://linux.die.net/man/1/ionice
	ionice -c 3 -p "$1"
	
	renice +15 -p "$1"
}

_priority_zero_pid_root() {
	! _wantSudo && return 1
	
	sudo -n ionice -c 2 -n 4 -p "$1"
	! sudo -n renice 0 -p "$1" && return 1
	
	return 0
}

_priority_zero_pid() {
	[[ "$1" == "" ]] && return 1
	
	_priority_zero_pid_root "$1" && return 0
	
	#https://linux.die.net/man/1/ionice
	ionice -c 2 -n 4 -p "$1"
	
	renice 0 -p "$1"
}

# WARNING: Untested.
_priority_dispatch() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	echo "$1" >> "$processListFile"
	pgrep -P "$1" 2>/dev/null >> "$processListFile"
	
	local currentPID
	
	while read -r currentPID
	do
		"$@" "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

# WARNING: Untested.
_priority_enumerate_pid() {
	[[ "$1" == "" ]] && return 1
	
	echo "$1"
	pgrep -P "$1" 2>/dev/null
}

_priority_enumerate_pattern() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	echo -n >> "$processListFile"
	
	pgrep "$1" >> "$processListFile"
	
	
	local parentListFile
	parentListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	echo -n >> "$parentListFile"
	
	local currentPID
	
	while read -r currentPID
	do
		pgrep -P "$currentPID" 2>/dev/null > "$parentListFile"
	done < "$processListFile"
	
	cat "$processListFile"
	cat "$parentListFile"
	
	
	rm "$processListFile"
	rm "$parentListFile"
}

_instance_internal() {
	! [[ -e "$1" ]] && return 1
	! [[ -d "$1" ]] && return 1
	! [[ -e "$2" ]] && return 1
	! [[ -d "$2" ]] && return 1
	rsync -q -ax --exclude "/.cache" --exclude "/.git" "$@"
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

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_var() {
	echo -e -n '\E[0;34m '
	
	echo -n "$1"'= '
	
	eval echo -e -n \$"$1"
	
	echo -e -n ' \E[0m'
	echo
	return 0
}
_messageVar() {
	_messagePlain_probe_var "$@"
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

#Blue. Diagnostic instrumentation.
#Prints "$@" and runs "$@".
# WARNING: Use with care.
_messagePlain_probe_cmd() {
	echo -e -n '\E[0;34m '
	
	_safeEcho "$@"
	
	echo -e -n ' \E[0m'
	echo
	
	"$@"
	
	return
}
_messageCMD() {
	_messagePlain_probe_cmd "$@"
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

_mustcarry() {
	grep "$1" "$2" > /dev/null 2>&1 && return 0
	
	echo "$1" >> "$2"
	return
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
	_tryExec "_includeScript_prog" "$1" && return 0

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

# WARNING: Untested.
#_includeScript_prog() {
#	false
	
	# WARNING: Not recommended. Create folders and submodules under "_prog" instead, as in "_prog/libName".
	#_includeFile "$scriptLib"/libName/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	#_includeFile "$scriptLib"/libName/"$includeScriptFilename" && return 0
	
	#return 1
#}

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
	[[ "$1" == "/dev/null" ]] && return 1
	
	[[ -h "$1" ]] && rm -f "$1" && return 0
	
	! [[ -e "$1" ]] && return 0
	
	return 1
}

#Like "ln -sf", but will not proceed if target is not link and exists (ie. will not erase files).
_relink_procedure() {
	#Do not update correct symlink.
	local existingLinkTarget
	existingLinkTarget=$(readlink "$2")
	[[ "$existingLinkTarget" == "$1" ]] && return 0
	
	! [[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s "$1" "$2" && return 0
	[[ "$relinkRelativeUb" == "true" ]] && _rmlink "$2" && ln -s -r "$1" "$2" && return 0
	
	return 1
}

_relink() {
	[[ "$2" == "/dev/null" ]] && return 1
	[[ "$relinkRelativeUb" == "true" ]] && export relinkRelativeUb=""
	_relink_procedure "$@"
}

_relink_relative() {
	export relinkRelativeUb="true"
	_relink_procedure "$@"
	export relinkRelativeUb=""
	unset relinkRelativeUb
}

#Copies files only if source/destination do match. Keeps files in a completely written state as often as possible.
_cpDiff() {
	! diff "$1" "$2" > /dev/null 2>&1 && cp "$1" "$2"
}

_testBindMountManager() {
	_getDep mount
	_getDep umount
	_getDep mountpoint
	
	if ! mount --help | grep '\-\-bind' >/dev/null 2>&1
	then
		echo "mount missing bind feature"
		_stop 1
	fi
	
	if ! mount --help | grep '\-\-rbind' >/dev/null 2>&1
	then
		echo "mount missing rbind feature"
		_stop 1
	fi
	
}


# WARNING: Requries prior check with _mustGetSudo .
#"$1" == Source
#"$2" == Destination
_bindMountManager() {
	mountpoint "$2" > /dev/null 2>&1 && return 1
	
	if [[ "$1" == "" ]]
	then
		return 1
	fi
	
	if [[ "$1" == "/" ]]
	then
		return 1
	fi
	
	[[ ! -e "$1" ]] && return 1
	
	sudo -n mkdir -p "$2"
	[[ ! -e "$2" ]] && return 1
	
	sudo -n mount --bind "$1" "$2"
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

_test_channel_fifo() {
	_getDep mkfifo
	
	if ! dd if=$(./ubiquitous_bash.sh _channel_host_fifo cat /dev/zero) of=/dev/null bs=1M count=10 iflag=fullblock > /dev/null 2>&1
	then
		echo 'fail: channel: fifo'
		_stop 1
	fi
}

_test_channel() {
	_tryExec "_test_channel_fifo"
}

_set_channel() {
	export channelTmp="$scriptAbsoluteFolder""$tmpPrefix"/.c_"$sessionid"
}

_prepare_channel() {
	mkdir -p "$channelTmp"
}

_stop_channel_allow() {
	export channelStop="true"
}
_stop_channel_prohibit() {
	export channelStop="false"
}

_rm_instance_channel() {
	[[ "$channelStop" != "true" ]] && return 0
	export channelStop="false"
	
	[[ "$channelTmp" != "" ]] && [[ "$channelTmp" == *"$sessionid"* ]] && [[ -e "$channelTmp" ]] && _safeRMR "$channelTmp"
}

_channel_fifo_example() {
	cat /dev/urandom | base64
}

_channel_fifo_sequence() {
	_stop_channel_allow
	
	"$@" 2>/dev/null > "$commandFIFO"
	
	_rm_instance_channel
}

_channel_host_fifo_sequence() {
	_stop_channel_prohibit
	_set_channel
	_prepare_channel
	
	export commandFIFO="$channelTmp"/cmdfifo
	mkfifo "$commandFIFO"
	
	echo "$commandFIFO"
	
	
	#nohup "$scriptAbsoluteLocation" --embed _channel_fifo_sequence "$@" >/dev/null 2>&1 &
	"$scriptAbsoluteLocation" --embed _channel_fifo_sequence "$@" >/dev/null 2>&1 &
	#disown -h $!
	disown -a -h
}

# example: dd if=$(./ubiquitous_bash.sh _channel_host_fifo _channel_fifo_example) of=/dev/null
# example: dd if=$(./ubiquitous_bash.sh _channel_host_fifo cat /dev/zero) of=/dev/null bs=1M count=10000 iflag=fullblock
_channel_host_fifo() {
	"$scriptAbsoluteLocation" _channel_host_fifo_sequence "$@"
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

_validatePort() {
	[[ "$1" -lt "1024" ]] && return 1
	[[ "$1" -gt "65535" ]] && return 1
	
	return 0
}

_testFindPort() {
	! _wantGetDep ss
	! _wantGetDep sockstat
	
	! type ss > /dev/null 2>&1 && ! type sockstat > /dev/null 2>&1 && echo "missing socket detection" && _stop 1
	
	local machineLowerPort=$(cat /proc/sys/net/ipv4/ip_local_port_range 2> /dev/null | cut -f1)
	local machineUpperPort=$(cat /proc/sys/net/ipv4/ip_local_port_range 2> /dev/null | cut -f2)
	
	[[ "$machineLowerPort" == "" ]] && echo "warn: autodetect: lower_port"
	[[ "$machineUpperPort" == "" ]] && echo "warn: autodetect: upper_port"
	[[ "$machineLowerPort" == "" ]] || [[ "$machineUpperPort" == "" ]] && return 0
	
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

#True if port open (in use).
_checkPort_local() {
	[[ "$1" == "" ]] && return 1
	
	if type ss > /dev/null 2>&1
	then
		ss -lpn | grep ':'"$1"' ' > /dev/null 2>&1
		return $?
	fi
	
	if type sockstat > /dev/null 2>&1
	then
		sockstat -46ln | grep '\.'"$1"' ' > /dev/null 2>&1
		return $?
	fi
	
	return 1
}

#Waits a reasonable time interval for port to be open (in use).
#"$1" == port
_waitPort_local() {
	local checksDone
	checksDone=0
	while ! _checkPort_local "$1" && [[ "$checksDone" -lt 72 ]]
	do
		let checksDone+=1
		sleep 0.1
	done
	
	local checksDone
	checksDone=0
	while ! _checkPort_local "$1" && [[ "$checksDone" -lt 72 ]]
	do
		let checksDone+=1
		sleep 0.3
	done
	
	local checksDone
	checksDone=0
	while ! _checkPort_local "$1" && [[ "$checksDone" -lt 72 ]]
	do
		let checksDone+=1
		sleep 1
	done
	
	return 0
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
			if ! _checkPort_local "$currentPort"
			then
				sleep 0.1
				if ! _checkPort_local "$currentPort"
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
	
	echo "$currentPort"
	
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

_testTor() {
	_getDep socat
	_getDep curl
	
	if ! _wantGetDep tor
	then
		echo 'warn: tor not available'
		return 1
	fi
	
	if ! _wantGetDep torsocks
	then
		echo 'warn: tor client support requires torsocks'
		return 1
	fi
}

_torServer_SSH_writeCfg() {
	mkdir -p "$scriptLocal"/tor/sshd/dd
	
	rm "$scriptLocal"/tor/sshd/dd/torrc > /dev/null 2>&1
	
	echo "RunAsDaemon 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo "DataDirectory "'"'"$scriptLocal"/tor/sshd/dd'"' >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	echo "SocksPort 0" >> "$scriptLocal"/tor/sshd/dd/torrc
	echo  >> "$scriptLocal"/tor/sshd/dd/torrc
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		
		mkdir -p "$scriptLocal"/tor/sshd/"$currentReversePort"
		chmod 700 "$scriptLocal"/tor/sshd/"$currentReversePort"
		
		echo "HiddenServiceDir "'"'"$scriptLocal"/tor/sshd/"$currentReversePort"/'"' >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo "HiddenServicePort ""$currentReversePort"" 127.0.0.1:""$LOCALSSHPORT" >> "$scriptLocal"/tor/sshd/dd/torrc
		
		echo  >> "$scriptLocal"/tor/sshd/dd/torrc
		
	done
	
}

_get_torServer_SSH_hostnames() {
	local currentHostname
	local currentReversePort
	
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	[[ ! -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}"/hostname ]] && sleep 3
	
	
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && sleep 3
		[[ ! -e "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname ]] && continue
		
		currentHostname=$(cat "$scriptLocal"/tor/sshd/"$currentReversePort"/hostname)
		torServer_hostnames+=( "$currentHostname":"$currentReversePort" )
	done
	
	export torServer_hostnames
}

_show_torServer_SSH_hostnames() {
	_get_torServer_SSH_hostnames
	
	echo
	local currentHostname
	for currentHostname in "${torServer_hostnames[@]}"
	do
		echo "$currentHostname"
	done
}

#Typically used to create onion addresses for an entire network of machines.
_torServer_SSH_all_launch() {
	_get_reversePorts '*'
	
	_torServer_SSH_writeCfg
	
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_show_torServer_SSH_hostnames
	
}

#Especially intended for IPv4 NAT punching.
_torServer_SSH_launch() {
	_get_reversePorts
	
	_torServer_SSH_writeCfg
	
	tor -f "$scriptLocal"/tor/sshd/dd/torrc
	
	_show_torServer_SSH_hostnames
	
}

_torServer_SSH() {
	mkdir -p "$scriptLocal"/ssh/log
	local logID
	logID=$(_uid)
	"$scriptAbsoluteLocation" _cmdDaemon _torServer_SSH_launch "$@" >> "$scriptLocal"/ssh/log/_torServer_SSH."$logID".log 2>&1
}

_checkTorPort_sequence() {
	_start
	
	#Does not work, because torsocks does not handle the DNS resolution method used by nmap.
	#torsocks nmap -n -Pn -sT "$1" -p "$2" | grep open > /dev/null 2>&1
	
	local curlPid
	! torsocks curl --connect-timeout 72 --max-time 72 -v telnet://"$1":"$2" > "$safeTmp"/curl 2>&1 && echo FAIL > "$safeTmp"/fail &
	curlPid=$!
	
	while true
	do
		if grep "Connected" "$safeTmp"/curl > /dev/null 2>&1
		then
			kill -TERM "$curlPid"
			#Unneeded curl process considered lower risk than misdirected signal to user process.
			#ps --no-headers -p "$curlPid" > /dev/null 2>&1 && sleep 0.1 && ps --no-headers -p "$curlPid" > /dev/null 2>&1 && kill -KILL "$curlPid"
			_stop 0
		fi
		
		if grep "FAIL" "$safeTmp"/fail > /dev/null 2>&1
		then
			_stop 1
		fi
		
		
		sleep 0.1
	done
	
	
	_stop
	
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkTorPort() {
	"$scriptAbsoluteLocation" _checkTorPort_sequence "$@"
}

_proxyTor_direct() {
 	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	#Use of "-q" parameter may not be useful in all cases.
	##printf "HEAD / HTTP/1.0\r\n\r\n" | torsocks nc sejnfjrq6szgca7v.onion 80
	#torsocks nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#torsocks nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	#torsocks nc "$proxyTargetHost" "$proxyTargetPort"
	#torsocks socat - TCP:"$proxyTargetHost":"$proxyTargetPort"
	socat - SOCKS4A:localhost:"$proxyTargetHost":"$proxyTargetPort",socksport=9050
}

#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxyTor() {
	if _checkTorPort "$1" "$2"
	then
		if _proxyTor_direct "$1" "$2"
		then
			_stop
		fi
	fi
}

#Checks all reverse port assignments through hostname, launches proxy if open.
#"$1" == host short name
#"$1" == hostname (typically onion)
_proxyTor_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxyTor "$2" "$currentReversePort"
	done
}




#Example only.
_here_ssh_config() {
	cat << CZXWXcRMTo8EmM8i4d

Host *-$netName*
	Compression yes
	ExitOnForwardFailure yes
	ConnectTimeout 72
	ConnectionAttempts 1
	ServerAliveInterval 5
	ServerAliveCountMax 5
	#PubkeyAuthentication yes
	#PasswordAuthentication no
	StrictHostKeyChecking no
	UserKnownHostsFile "$sshLocalSSH/known_hosts"
	IdentityFile "$sshLocalSSH/id_rsa"
	
	Cipher aes256-gcm@openssh.com
	Ciphers aes256-gcm@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc,aes192-cbc,aes256-cbc,arcfour

Host machine-$netName
	User user
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_machine-$netName


CZXWXcRMTo8EmM8i4d
}

_ssh_criticalDep() {
	! type ssh > /dev/null 2>&1 && return 1
	#! type ssh > /dev/null 2>&1 && _messagePlain_bad 'missing: ssh' && return 1
	[[ -L /usr/bin/ssh ]] && ls -l /usr/bin/ssh | grep firejail > /dev/null 2>&1 && _messagePlain_bad 'conflict: firejail' && return 1
	return 0
}

_testProxySSH() {
	_getDep ssh
	
	if [[ -L /usr/local/bin/ssh ]] && ls -l /usr/local/bin/ssh | grep firejail > /dev/null 2>&1
	then
		_messagePlain_warn 'workaround: firejail'
		_messagePlain_probe 'FireJail containment of SSH itself interferes with proxy host jumping, and also inserts a message into the character stream. Most CoreAutoSSH features will not work, if bypassing this is not possible.'
		
		[[ -L /usr/bin/ssh ]] && ls -l /usr/bin/ssh | grep firejail > /dev/null 2>&1 && _messagePlain_bad 'conflict: firejail' && return 1
	fi
	
	#For both _package and _rsync .
	! _wantDep rsync && echo 'warn: no rsync'
	
	! _wantDep sshfs && echo 'warn: sshfs not found'
	
	! _wantDep base64 && echo 'warn: no base64'
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tigervnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tigervnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tigervnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	! _wantDep x0tigervncserver && echo 'warn: x0tigervncserver not found'
	
	! _wantDep vncpasswd && echo 'warn: vncpasswd not found, x11vnc broken!'
	
	! _wantDep xset && echo 'warn: xset not found'
	
	#! _wantDep xpra && echo 'warn: xpra not found'
	#! _wantDep xephyr && echo 'warn: xephyr not found'
	#! _wantDep xnest && echo 'warn: xnest not found'
	
	if [[ -e /usr/share/doc/realvnc-vnc-server ]] || type vnclicense >/dev/null 2>&1
	then
		export ubTAINT="true"
		echo 'TAINT: unsupported vnc!'
	fi
	
	#May be required by some _rsync backup scripts.
	#! _wantDep fakeroot && echo 'warn: fakeroot not found'
}

_testRemoteSSH() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _test'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_self() {
	_start
	_start_safeTmp_ssh "$1"
	
	_ssh "$1" "$safeTmpSSH"'/cautossh '"$@"
	
	_stop_safeTmp_ssh "$1"
	_stop
}

_ssh_setupUbiquitous() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _setupUbiquitous'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_setupUbiquitous_nonet() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _setupUbiquitous_nonet'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

#Enters remote server at hostname, by SSH, sets up a tunnel, checks tunnel for another SSH server.
#"$1" == host short name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_checkRemoteSSH() {
	local localPort
	localPort=$(_findPort)
	
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	_timeout 14 _ssh -f "$1" -L "$localPort":"$remoteHostDestination":"$2" -N > /dev/null 2>&1
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 2
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	sleep 3
	nmap -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	
	return 1
}

#Launches proxy if remote port is open at hostname.
#"$1" == gateway name
#"$2" == port
#"$3" == remote host (optional, localhost default)
_proxySSH() {
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	#Checking for remote port is usually unnecessary, as the SSH command seems to fail normally if the remote destination is not up. Not explicitly checking with nmap saves significant time (performance). However, the code remains in place for immediate return to default if proven useful.
	#if _checkRemoteSSH "$1" "$2" "$remoteHostDestination"
	#then
		if _ssh -q -W "$remoteHostDestination":"$2" "$1"
		then
			_stop
		fi
	#fi
	
	return 0
}

#Checks all reverse port assignments through hostname, launches proxy if open.
#"$1" == host short name
#"$2" == gateway name
_proxySSH_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxySSH "$2" "$currentReversePort"
	done
}

_ssh_command() {
	! _ssh_criticalDep && return 1
	
	if [[ -L /usr/local/bin/ssh ]] && ls -l /usr/local/bin/ssh | grep firejail > /dev/null 2>&1
	then
		if /usr/bin/ssh -F "$sshDir"/config "$@"
		then
			return 0
		fi
		return 1
	fi
	
	if ssh -F "$sshDir"/config "$@"
	then
		return 0
	fi
	return 1
}

_ssh_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	local sshExitStatus
	_ssh_command "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

_ssh() {
	if [[ "$sshInContainment" == "true" ]]
	then
		if _ssh_command "$@"
		then
			return 0
		fi
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	return "$sshExitStatus"
}

# WARNING Structure should match _ssh_sequence .
_sshfs_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	local sshExitStatus
	sshfs -F "$sshDir"/config "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

# WARNING Structure should match _ssh .
_sshfs() {
	if [[ "$sshInContainment" == "true" ]]
	then
		if sshfs -F "$sshDir"/config "$@"
		then
			return 0
		fi
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _sshfs_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	return "$sshExitStatus"
}


#"$1" == commandName
_command_ssh_user_field() {
	echo "$1" | grep '^_ssh$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_ssh' > /dev/null 2>&1 && echo "$1" | sed 's/^_ssh-//g' && return 0
	echo "$1" | grep '^_rsync$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_rsync' > /dev/null 2>&1 && echo "$1" | sed 's/^_rsync-//g' && return 0
	
	echo "$1" | grep '^_backup$' > /dev/null 2>&1 && return 1
	echo "$1" | grep '^_backup' > /dev/null 2>&1 && echo "$1" | sed 's/^_backup-//g' && return 0
	
	return 1
}

#"$1" == commandName
_command_ssh_user() {
	local field_sshCommandUser
	field_sshCommandUser=$(_command_ssh_user_field "$1")
	
	#Output blank, default user specified by SSH config or here document.
	[[ "$field_sshCommandUser" == "home" ]] && return 0
	
	[[ "$field_sshCommandUser" != "" ]] && echo "$field_sshCommandUser" && return 0
	
	#Blank may be regarded as error condition.
	return 1
	
}

_command_ssh_machine() {
	true
}

_rsync_command_check_backup_dependencies() {
	#_messageNormal "Checking - dependencies."
	
	##Check for sudo, especially if fakeroot is unavailable or undesirable.
	#if [[ "$criticalSSHUSER" == "root" ]]
	#then
		#[[ $(id -u) != 0 ]] && _messageError 'fail: not root' && return 1
		criticalSudoAvailable=false
		criticalSudoAvailable=$(sudo -n echo true)
		! [[ "$criticalSudoAvailable" == "true" ]] && _messageError 'bad: sudo' && return 1
	#fi

	#Check for fakeroot.
	#! type fakeroot > /dev/null 2>&1  && _messageError 'missing: fakeroot' && return 1
	
	# WARNING Intended for direct copy/paste inclusion into independent launch wrapper scripts. Kept here for redundancy.
	! type _command_safeBackup > /dev/null 2>&1 && _messageError "missing: _command_safeBackup" && return 1
	
	return 0
}

#"$1" == criticalBackupSource
#"$2" == criticalBackupDestination
_prepare_rsync_backup_env() {
	_messageNormal "Preparing - env."
	
	[[ "$1" != "" ]] && export criticalBackupSource="$1"
	[[ "$2" != "" ]] && export criticalBackupDestination="$2"

	[[ "$criticalBackupSource" == "" ]] && _messageError 'blank: criticalBackupSource' && return 1
	[[ "$criticalBackupDestination" == "" ]] && _messageError 'blank: criticalBackupDestination' && return 1

	mkdir -p "$criticalBackupDestination"
	[[ ! -e "$criticalBackupDestination" ]] && _messageError 'fail: mkdir criticalBackupDestination= '"$criticalBackupDestination" && return 1

	mkdir -p "$criticalBackupDestination"/fs
	[[ ! -e "$criticalBackupDestination"/fs ]] && _messageError 'fail: mkdir criticalBackupDestination/fs= '"$criticalBackupDestination"/fs && return 1
	
	! sudo -n chown root:root "$criticalBackupDestination"/fs && _messageError 'chown: '"$criticalBackupDestination" && return 1
	! sudo -n chmod 700 "$criticalBackupDestination"/fs && _messageError 'chmod: '"$criticalBackupDestination" && return 1

	#Fakeroot, pseudo, and image, optional features are provisioned here, but not expected to be used. Containing all operations within Uqibuitous Bash virtualization is generally expected to represent best practice.

	#mkdir -p "$criticalBackupDestination"/fakeroot
	#[[ ! -e "$criticalBackupDestination"/fakeroot ]] && _messageError 'fail: mkdir criticalBackupDestination/fakeroot= '"$criticalBackupDestination"/fakeroot && return 1
	#[[ ! -e "$criticalBackupDestination"/fakeroot.db ]] && echo -n > "$criticalBackupDestination"/fakeroot.db
	#[[ ! -e "$criticalBackupDestination"/fakeroot.db ]] && _messageError 'fail: mkdir criticalBackupDestination/fakeroot.db= '"$criticalBackupDestination"/fakeroot.db && return 1

	#mkdir -p "$criticalBackupDestination"/pseudo
	#[[ ! -e "$criticalBackupDestination"/pseudo ]] && _messageError 'fail: mkdir criticalBackupDestination/pseudo= '"$criticalBackupDestination"/pseudo && return 1
	#[[ ! -e "$criticalBackupDestination"/pseudo.db ]] && echo -n > "$criticalBackupDestination"/pseudo.db
	#[[ ! -e "$criticalBackupDestination"/pseudo.db ]] && _messageError 'fail: mkdir criticalBackupDestination/pseudo.db= '"$criticalBackupDestination"/pseudo.db && return 1

	#mkdir -p "$criticalBackupDestination"/image
	#[[ ! -e "$criticalBackupDestination"/image ]] && _messageError 'fail: mkdir criticalBackupDestination/image= '"$criticalBackupDestination"/image && return 1
	#[[ ! -e "$criticalBackupDestination"/image.img ]] && echo -n > "$criticalBackupDestination"/image.img
	#[[ ! -e "$criticalBackupDestination"/image.img ]] && _messageError 'fail: mkdir criticalBackupDestination/image.img= '"$criticalBackupDestination"/image.img && return 1
	
	! _safeBackup "$criticalBackupDestination" && _messageError "check: _command_safeBackup" && return 1
	
	return 0
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#Generates "root@machine:/" format rsync address from machine name, user, and path.
#_rsync_sourceAddress "machine" "/path/" "user"
#_rsync_sourceAddress "machine" "" "user"
#"$1" == criticalSSHmachine
#"$2" == criticalSourcePath (optional)
#"$3" == criticalUser (optional)
_rsync_remoteAddress() {
	#root@machine:/
	#user@machine:
	#machine:
	
	[[ "$1" != "" ]] && export criticalSSHmachine="$1"
	[[ "$2" != "" ]] && export criticalSourcePath="$2"
	[[ "$3" != "" ]] && export criticalUser="$3"
	
	[[ "$criticalSourcePath" == "" ]] && [[ "$criticalUser" == "root" ]] && export criticalSourcePath="/"
	
	export criticalUserAddress="$criticalUser"
	[[ "$criticalUserAddress" != "" ]] && export criticalUserAddress="$criticalUser"'@'
	
	export criticalRsyncAddress="$criticalUserAddress""$criticalSSHmachine"':'"$criticalSourcePath"
	
	echo "$criticalRsyncAddress"
	
	[[ "$criticalSSHmachine" == "" ]] && return 1
	return 0
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#"$1" == criticalSSHmachine
#"$2" == criticalSourcePath (optional)
#"$3" == criticalUser (optional)
#"$4" == commandName
#_rsync_backup_remote "$machineName" "" "" "$commandName"
_rsync_backup_remote() {
	[[ "$1" != "" ]] && export criticalSSHmachine="$1"
	[[ "$2" != "" ]] && export criticalSourcePath="$2"
	[[ "$3" != "" ]] && export criticalUser="$3"
	
	[[ "$criticalUser" == "" ]] && export criticalUser=$(_command_ssh_user "$4")
	
	[[ "$criticalSSHmachine" == "" ]] && return 1
	
	_rsync_remoteAddress "$criticalSSHmachine" "$criticalSourcePath" "$criticalUser"
}

# WARNING Sets and accepts global variables. Do NOT reuse or recurse without careful consideration or guard statements.
#"$1" == criticalDestinationPrefix (optional, default "_arc")
#"$2" == $criticalDestinationPath (optional)
#"$3" == criticalUser (optional)
#"$4" == commandName
#_rsync_backup_local "" "" "" "$commandName"
_rsync_backup_local() {
	[[ "$1" != "" ]] && export criticalDestinationPrefix="$1"
	[[ "$criticalDestinationPrefix" == "" ]] && export criticalDestinationPrefix="_arc"
	
	[[ "$3" != "" ]] && export criticalUser="$3"
	[[ "$criticalUser" == "" ]] && export criticalUser=$(_command_ssh_user_field "$4")
	
	[[ "$2" != "" ]] && export criticalDestinationPath="$2"
	[[ "$criticalDestinationPath" == "" ]] && export criticalDestinationPath="$criticalUser"
	
	[[ "$criticalDestinationPath" == "" ]] && return 1
	
	export criticalDestinationPrefixAddress="$criticalDestinationPrefix"
	[[ "$criticalDestinationPrefixAddress" != "" ]] && export criticalDestinationPrefixAddress="$criticalDestinationPrefixAddress"'/'
	
	echo "$criticalDestinationPrefixAddress""$criticalDestinationPath"
}

_rsync() {
	rsync -e "$scriptAbsoluteLocation"" _ssh" "$@"
}

_start_safeTmp_ssh() {
	cat "$scriptAbsoluteLocation" | base64 | _ssh -C -o ConnectionAttempts=2 "$@" '
mkdir -p '"$safeTmpSSH"'
chmod 700 '"$safeTmpSSH"'
cat - | base64 -d > '"$safeTmpSSH"'/cautossh
chmod 700 '"$safeTmpSSH"'/cautossh
'
	
	#cat "$scriptAbsoluteLocation" | base64 | _ssh -C -o ConnectionAttempts=2 "$@" 'cat - | base64 -d > '"$safeTmpSSH"'/cautossh'
	#_ssh -C -o ConnectionAttempts=2 "$@" 'chmod 700 '"$safeTmpSSH"'/cautossh'
}

_stop_safeTmp_ssh() {
#rm '"$safeTmpSSH"'/w_*/*
	cat "$scriptAbsoluteLocation" | _ssh -C -o ConnectionAttempts=2 "$@" '
rm '"$safeTmpSSH"'/cautossh
rmdir '"$safeTmpSSH"'/_local
rmdir '"$safeTmpSSH"'
'
	
}

_vnc_ssh() {
	"$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes "$@" 
}

_findPort_vnc() {
	local vncMinPort
	let vncMinPort="${reversePorts[0]}"+20
	
	local vncMaxPort
	let vncMaxPort="${reversePorts[0]}"+50
	
	_findPort "$vncMinPort" "$vncMaxPort"
}

_prepare_vnc() {
	
	echo > "$vncPasswdFile".pln
	chmod 600 "$vncPasswdFile".pln
	_uid 8 > "$vncPasswdFile".pln
	
	export vncPort=$(_findPort_vnc)
	
	export vncPIDfile="$safeTmpSSH"/.vncpid
	export vncPIDfile_local="$safeTmp"/.vncpid
	
}

_report_vncpasswd() {
	_messagePlain_probe 'report: _report_vncpasswd'
	
	! [[ -e "$vncPasswdFile".pln ]] && _messagePlain_bad 'missing: "$vncPasswdFile".pln' && return 0
	
	! [[ -s "$vncPasswdFile".pln ]] && _messagePlain_bad 'blank: "$vncPasswdFile".pln' && return 0
	
	if [[ -s "$vncPasswdFile".pln ]]
	then
		#Blue. Diagnostic instrumentation.
		echo -e -n '\E[0;34m '
		cat "$vncPasswdFile".pln
		echo -e -n ' \E[0m'
		echo
		return 0
	fi
	
	return 0
}

_vncpasswd() {
	_messagePlain_nominal "init: _vncpasswd"
	
	#TigerVNC, specifically.
	if type tigervncpasswd >/dev/null 2>&1
	then
		_messagePlain_good 'found: tigervnc'
		_report_vncpasswd
		! echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | tigervncpasswd "$vncPasswdFile" && _messagePlain_bad 'fail: vncpasswd' && return 1
		return 0
	fi
	
	#Supported by both TightVNC and TigerVNC.
	if echo | vncpasswd -x --help 2>&1 | grep -i 'vncpasswd \[FILE\]' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncpasswd'
		_report_vncpasswd
		! echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | vncpasswd "$vncPasswdFile" && _messagePlain_bad 'fail: vncpasswd' && return 1
		return 0
	fi
	
	type vncpasswd > /dev/null 2>&1 && _messagePlain_bad 'unsupported: vncpasswd'
	! type vncpasswd > /dev/null 2>&1 && _messagePlain_bad 'missing: vncpasswd'
	
	return 1
}

_vncviewer_operations() {
	_messagePlain_nominal 'init: _vncviewer_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe '_vncviewer_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Detecting and launching vncviewer.'
	#TigerVNC
	if vncviewer --help 2>&1 | grep 'PasswordFile   \- Password file for VNC authentication (default\=)' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncviewer (TigerVNC)'
		
		if ! vncviewer -DotWhenNoCursor -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	#TightVNC
	if vncviewer --help 2>&1 | grep '\-passwd' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncviewer (TightVNC)'
		
		#if ! vncviewer -encodings "copyrect tight zrle hextile" localhost:"$vncPort"
		if ! vncviewer -passwd "$vncPasswdFile" localhost:"$vncPort" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	type vncviewer > /dev/null 2>&1 && _messagePlain_bad 'unsupported: vncviewer'
	! type vncviewer > /dev/null 2>&1 && _messagePlain_bad 'missing: vncviewer'
	
	return 1
}

_vncviewer_sequence() {
	_messageNormal '_vncviewer_sequence: Start'
	_start
	
	_messageNormal '_vncviewer_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	_report_vncpasswd
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_vncviewer_sequence: Operations .'
	! _vncviewer_operations "$@" && _messageError 'FAIL: vncviewer' && _stop 1
	
	_messageNormal '_vncviewer_sequence: Stop'
	_stop
}

#Password must be given on standard input. Environment variable "$vncPort" must be set. Environment variable "$destination_DISPLAY" may be forced.
_vncviewer() {
	"$scriptAbsoluteLocation" _vncviewer_sequence "$@"
}

#To be overrideden by ops (eg. for "-repeat").
_x11vnc_command() {
	x11vnc "$@"
}

_x11vnc_operations() {
	_messagePlain_nominal 'init: _x11vnc_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_bad 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe 'x11vnc_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Detecting and launching x11vnc.'
	#x11vnc
	if type x11vnc >/dev/null 2>&1
	then
		_messagePlain_good 'found: x11vnc'
		
		#-passwdfile cmd:"/bin/cat -"
		#-noxrecord -noxfixes -noxdamage
		if ! _x11vnc_command -localhost -rfbauth "$vncPasswdFile" -rfbport "$vncPort" -timeout 48 -xkb -display "$destination_DISPLAY" -auth "$destination_AUTH" -noxrecord -noxdamage
		then
			_messagePlain_bad 'fail: x11vnc'
			return 1
		fi
		
		return 0
	fi
	
	#TigerVNC.
	if type x0tigervncserver
	then
		_messagePlain_good 'found: x0tigervncserver'
		
		if ! x0tigervncserver -rfbauth "$vncPasswdFile" -rfbport "$vncPort"
		then
			_messagePlain_bad 'fail: x0tigervncserver'
			return 1
		fi
		return 0
	fi
	
	_messagePlain_bad 'missing: x11vnc || x0tigervncserver'
	
	return 1
}

_x11vnc_sequence() {
	_messageNormal '_x11vnc_sequence: Start'
	_start
	
	_messageNormal '_x11vnc_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	_report_vncpasswd
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Operations .'
	! _x11vnc_operations && _messageError 'FAIL: x11vnc' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Stop'
	_stop
}

#Password must be given on standard input. Environment variable "$vncPort" must be set. Environment variable "$destination_DISPLAY" may be forced.
_x11vnc() {
	"$scriptAbsoluteLocation" _x11vnc_sequence "$@"
}

_vncserver_operations() {
	_messagePlain_nominal 'init: _vncserver_operations'
	
	#[[ "$desktopEnvironmentLaunch" == "" ]] && desktopEnvironmentLaunch="true"
	[[ "$desktopEnvironmentLaunch" == "" ]] && desktopEnvironmentLaunch="startlxde"
	[[ "$desktopEnvironmentGeometry" == "" ]] && desktopEnvironmentGeometry='1920x1080'
	
	_messagePlain_nominal 'Searching for unused X11 display.'
	local vncDisplay
	local vncDisplayValid
	for (( vncDisplay = 1 ; vncDisplay <= 9 ; vncDisplay++ ))
	do
		! [[ -e /tmp/.X"$vncDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$vncDisplay" ]] && vncDisplayValid=true && _messagePlain_good 'found: unused X11 display= '"$vncDisplay" && break
	done
	[[ "$vncDisplayValid" != "true" ]] && _messagePlain_bad 'fail: vncDisplayValid != "true"' && _stop 1
	
	_messagePlain_nominal 'Detecting and launching vncserver.'
	#TigerVNC
	if echo | vncserver -x --help 2>&1 | grep '\-fg' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncserver (TigerVNC)'
		echo
		echo '*****TigerVNC Server Detected'
		echo
		#"-fg" may be unreliable
		#vncserver :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" &
		
		
		export XvncCommand="Xvnc"
		type Xtigervnc >/dev/null 2>&1 && export XvncCommand="Xtigervnc"
		
		type "$XvncCommand" > /dev/null 2>&1 && _messagePlain_good 'found: XvncCommand= '"$XvncCommand"
		! type "$XvncCommand" > /dev/null 2>&1 && _messagePlain_bad 'missing: XvncCommand= '"$XvncCommand"
		
		"$XvncCommand" :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" -rfbwait 48000 &
		echo $! > "$vncPIDfile"
		
		sleep 0.3
		[[ ! -e "$vncPIDfile" ]] && _messagePlain_bad 'missing: "$vncPIDfile"' && return 1
		local vncPIDactual=$(cat $vncPIDfile)
		! ps -p "$vncPIDactual" > /dev/null 2>&1 && _messagePlain_bad 'inactive: vncPID= '"$vncPIDactual" && return 1
		_messagePlain_good 'active: vncPID= '"$vncPIDactual"
		
		export DISPLAY=:"$vncDisplay"
		
		local currentCount
		for (( currentCount = 0 ; currentCount < 90 ; currentCount++ ))
		do
			_timeout 3 xset q >/dev/null 2>&1 && _messagePlain_good 'connect: DISPLAY= '"$DISPLAY" && break
			sleep 1
		done
		
		[[ "$currentCount" == "90" ]] && _messagePlain_bad 'fail: connect: DISPLAY= '"$DISPLAY" && return 1
		
		bash -c "$desktopEnvironmentLaunch" &
		
		sleep 48
		
		return 0
	fi
	
	#TightVNC
	if type vncserver >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncserver (TightVNC)'
		echo
		echo '*****TightVNC Server Detected'
		echo
		
		#TightVNC may refuse to use an aribtary password file if system default does not exist.
		[[ ! -e "$HOME"/.vnc/passwd ]] && echo | cat "$vncPasswdFile".pln - "$vncPasswdFile".pln | vncpasswd
		
		export XvncCommand="Xvnc"
		type Xtightvnc >/dev/null 2>&1 && export XvncCommand="Xtightvnc"
		
		type "$XvncCommand" > /dev/null 2>&1 && _messagePlain_good 'found: XvncCommand= '"$XvncCommand"
		! type "$XvncCommand" > /dev/null 2>&1 && _messagePlain_bad 'missing: XvncCommand= '"$XvncCommand"
		
		"$XvncCommand" :"$vncDisplay" -depth 16 -geometry "$desktopEnvironmentGeometry" -nevershared -dontdisconnect -localhost -rfbport "$vncPort" -rfbauth "$vncPasswdFile" -rfbwait 48000 &
		echo $! > "$vncPIDfile"
		
		sleep 0.3
		[[ ! -e "$vncPIDfile" ]] && _messagePlain_bad 'missing: "$vncPIDfile"' && return 1
		local vncPIDactual=$(cat $vncPIDfile)
		! ps -p "$vncPIDactual" > /dev/null 2>&1 && _messagePlain_bad 'inactive: vncPID= '"$vncPIDactual" && return 1
		_messagePlain_good 'active: vncPID= '"$vncPIDactual"
		
		export DISPLAY=:"$vncDisplay"
		
		local currentCount
		for (( currentCount = 0 ; currentCount < 90 ; currentCount++ ))
		do
			xset q >/dev/null 2>&1 && _messagePlain_good 'connect: DISPLAY= '"$DISPLAY" && break
			sleep 1
		done
		
		[[ "$currentCount" == "90" ]] && _messagePlain_bad 'fail: connect: DISPLAY= '"$DISPLAY" && return 1
		
		bash -c "$desktopEnvironmentLaunch" &
		
		sleep 48
		
		return 0
	fi
	
	type vncserver > /dev/null 2>&1 && type Xvnc > /dev/null 2>&1 && _messagePlain_bad 'unsupported: vncserver || Xvnc' && return 1
	
	_messagePlain_bad 'missing: vncserver || Xvnc'
	
	return 1
}

_vncserver_sequence() {
	_messageNormal '_vncserver_sequence: Start'
	_start
	
	_messageNormal '_vncserver_sequence: Setting vncpasswd .'
	cat - > "$vncPasswdFile".pln
	! _vncpasswd && _messageError 'FAIL: vncpasswd' && _stop 1
	
	_messageNormal '_x11vnc_sequence: Operations .'
	! _vncserver_operations && _messageError 'FAIL: vncserver' && _stop 1
	
	_stop
}

#Password must be given on standard input. Environment variables "$vncPort", "$vncPIDfile", must be set. Environment variables "$desktopEnvironmentGeometry", "$desktopEnvironmentLaunch", may be forced.
_vncserver() {
	"$scriptAbsoluteLocation" _vncserver_sequence "$@"
}

#Environment variable "$vncPIDfile", must be set.
_vncserver_terminate() {
	
	# WARNING: For now, this does not always work with TigerVNC.
	if [[ -e "$vncPIDfile" ]] && [[ -s "$vncPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$vncPIDfile"'
		
		pkill -P $(cat "$vncPIDfile")
		kill $(cat "$vncPIDfile")
		#sleep 1
		#kill -KILL $(cat "$vncPIDfile")
		rm "$vncPIDfile"
		
		pgrep Xvnc && _messagePlain_warn 'found: Xvnc process'
		pgrep Xtightvnc && _messagePlain_warn 'found: Xtightvnc process'
		pgrep Xtigervnc && _messagePlain_warn 'found: Xtigervnc process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$vncPIDfile'
	_messagePlain_bad 'terminate: Xvnc, Xtightvnc, Xtigervnc'
	
	pkill Xvnc
	pkill Xtightvnc
	pkill Xtigervnc
	rm "$vncPIDfile"
	
	return 1
}

_vnc_sequence() {
	_messageNormal '_vnc_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_vnc_sequence: Launch: _x11vnc'
	
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' '"$safeTmpSSH"/cautossh' _x11vnc' &
	
	_waitPort localhost "$vncPort"
	
	_messageNormal '_vnc_sequence: Ready: _waitPort localhost vncport= '"$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	
	_messageNormal '_vnc_sequence: Done: final attempt: _vncviewer'
	
	_messageNormal '_vnc_sequence: Stop'
	stty echo > /dev/null 2>&1
	_stop_safeTmp_ssh "$@"
	_stop
}

_vnc() {
	"$scriptAbsoluteLocation" _vnc_sequence "$@"
}

_push_vnc_sequence() {
	_messageNormal '_push_vnc_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_push_vnc_sequence: Launch: _x11vnc'
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' '"$scriptAbsoluteLocation"' _x11vnc' &
	#-noxrecord -noxfixes -noxdamage
	
	_waitPort localhost "$vncPort"
	
	_messageNormal '_push_vnc_sequence: Ready: _waitPort localhost vncport= '"$vncPort"
	
	#VNC service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	_messageNormal '_push_vnc_sequence: Done: final attempt: _vncviewer'
	
	_messageNormal '_push_vnc_sequence: Stop'
	stty echo > /dev/null 2>&1
	_stop_safeTmp_ssh "$@"
	_stop 1
}

_push_vnc() {
	"$scriptAbsoluteLocation" _push_vnc_sequence "$@"
}

_desktop_sequence() {
	_messageNormal '_desktop_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_vnc_sequence: Launch: _vncserver'
	# TODO WARNING Terminal echo (ie. "stty echo") lockup errors are possible as ssh is backgrounded without "-f".
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$safeTmpSSH"/cautossh' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	_messageNormal '_vnc_sequence: Ready: _waitPort. Launch: _vncviewer'
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _vncviewer'
	stty echo > /dev/null 2>&1
	
	_messageNormal '_vnc_sequence: Terminate: _vncserver_terminate'
	
	_vnc_ssh "$@" 'env vncPIDfile='"$vncPIDfile"' '"$safeTmpSSH"/cautossh' _vncserver_terminate'
	
	_messageNormal '_desktop_sequence: Stop'
	_stop_safeTmp_ssh "$@"
	_stop
}

#Launches VNC server and client, with up to nine nonpersistent desktop environments.
_desktop() {
	"$scriptAbsoluteLocation" _desktop_sequence "$@"
}

_push_desktop_sequence() {
	_messageNormal '_push_desktop_sequence: Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_vnc
	
	_messageNormal '_push_desktop_sequence: Launch: _vncserver'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' vncPIDfile='"$vncPIDfile_local"' desktopEnvironmentGeometry='"$desktopEnvironmentGeometry"' desktopEnvironmentLaunch='"$desktopEnvironmentLaunch"' '"$scriptAbsoluteLocation"' _vncserver' &
	
	
	_waitPort localhost "$vncPort"
	sleep 0.8 #VNC service may not always be ready when port is up.
	
	_messageNormal '_push_desktop_sequence: Ready: _waitPort. Launch: _vncviewer'
	
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' destination_DISPLAY='""' '"$safeTmpSSH"/cautossh' _vncviewer'
	stty echo > /dev/null 2>&1
	
	_messageNormal '_push_desktop_sequence: Terminate: _vncserver_terminate'
	
	bash -c 'env vncPIDfile='"$vncPIDfile_local"' '"$scriptAbsoluteLocation"' _vncserver_terminate'
	
	_messageNormal '_desktop_sequence: Stop'
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_desktop() {
	"$scriptAbsoluteLocation" _push_desktop_sequence "$@"
}

#Builtin version of ssh-copy-id.
_ssh_copy_id() {
	_start
	
	"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id=_ssh_copy_id

#"$1" == "key_name"
#"$2" == "local_subdirectory" (optional)
_setup_ssh_copyKey() {
	local sshKeyName
	local sshKeyLocalSubdirectory
	
	sshKeyName="$1"
	[[ "$2" != "" ]] && sshKeyLocalSubdirectory="$2"/
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
		return 0
	fi
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
		return 0
	fi
	
	return 1
}

#Overload with "ops".
_setup_ssh_extra() {
	true
}

_setup_ssh_merge_known_hosts() {
	[[ ! -e "$scriptLocal"/ssh/known_hosts ]] && echo > "$scriptLocal"/ssh/known_hosts
	[[ ! -e "$sshLocalSSH"/known_hosts ]] && echo > "$sshLocalSSH"/known_hosts
	sort "$scriptLocal"/ssh/known_hosts "$sshLocalSSH"/known_hosts | uniq > "$safeTmp"/known_hosts_uniq
	_cpDiff "$safeTmp"/known_hosts_uniq "$scriptLocal"/ssh/known_hosts
	
	_cpDiff "$scriptLocal"/ssh/known_hosts "$sshLocalSSH"/known_hosts
}

_setup_ssh_operations() {
	_prepare_ssh
	
	mkdir -p "$scriptLocal"/ssh
	
	! [[ -e "$sshBase" ]] && mkdir -p "$sshBase" && chmod 700 "$sshBase"
	! [[ -e "$sshBase"/"$ubiquitiousBashID" ]] && mkdir -p "$sshBase"/"$ubiquitiousBashID" && chmod 700 "$sshBase"/"$ubiquitiousBashID"
	! [[ -e "$sshDir" ]] && mkdir -p "$sshDir" && chmod 700 "$sshDir"
	! [[ -e "$sshLocal" ]] && mkdir -p "$sshLocal" && chmod 700 "$sshLocal"
	! [[ -e "$sshLocalSSH" ]] && mkdir -p "$sshLocalSSH" && chmod 700 "$sshLocalSSH"
	
	#! grep "$ubiquitiousBashID" "$sshBase"/config > /dev/null 2>&1 && echo 'Include "'"$sshUbiquitous"'/config"' >> "$sshBase"/config
	
	#Prepend include directive. Mitigates the risk of falling under an existing config directive (eg. Host/Match). Carries the relatively insignificant risk of a non-atomic operation.
	if ! grep "$ubiquitiousBashID" "$sshBase"/config > /dev/null 2>&1 && [[ ! -e "$sshBase"/config.tmp ]]
	then
		echo -n >> "$sshBase"/config
		echo 'Include "'"$sshUbiquitous"'/config"' >> "$sshBase"/config.tmp
		echo >> "$sshBase"/config.tmp
		cat "$sshBase"/config >> "$sshBase"/config.tmp
		mv "$sshBase"/config.tmp "$sshBase"/config
		
	fi
	
	! grep "$netName" "$sshUbiquitous"/config > /dev/null 2>&1 && echo 'Include "'"$sshDir"'/config"' >> "$sshBase"/config >> "$sshUbiquitous"/config
	
	if [[ "$keepKeys_SSH" == "false" ]]
	then
		rm -f "$scriptLocal"/ssh/id_rsa >/dev/null 2>&1
		rm -f "$scriptLocal"/ssh/id_rsa.pub >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa >/dev/null 2>&1
		rm -f "$sshDir"/id_rsa.pub >/dev/null 2>&1
		rm -f "$sshLocalSSH"/id_rsa >/dev/null 2>&1
		rm -f "$sshLocalSSH"/id_rsa.pub >/dev/null 2>&1
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e "$sshLocalSSH"/id_rsa ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/id_rsa
	fi
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	_setup_ssh_copyKey id_rsa
	
	_setup_ssh_merge_known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" "$sshDir"/cautossh
	
	# TODO Replace with a less oversimplified destination directory structure.
	#Concatenates all "ops" directives into one file to allow a single "cpDiff" operation.
	[[ -e "$objectDir"/ops ]] && cat "$objectDir"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ops ]] && cat "$scriptLocal"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/ops ]] && cat "$scriptLocal"/ssh/ops >> "$safeTmp"/opsAll
	
	[[ -e "$objectDir"/opsauto ]] && cat "$objectDir"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/opsauto ]] && cat "$scriptLocal"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/opsauto ]] && cat "$scriptLocal"/ssh/opsauto >> "$safeTmp"/opsAll
	
	
	_cpDiff "$safeTmp"/opsAll "$sshLocalSSH"/ops
	
	_setup_ssh_extra
}

_setup_ssh_sequence() {
	_start
	
	_setup_ssh_operations
	
	_stop
}

_setup_ssh() {
	"$scriptAbsoluteLocation" _setup_ssh_sequence "$@"
}

_setup_ssh_commands() {
	_find_setupCommands -name '_ssh' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	_find_setupCommands -name '_rsync' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_sshfs' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_web' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_backup' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_fs' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_vnc' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	_find_setupCommands -name '_push_vnc' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	_find_setupCommands -name '_desktop' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	_find_setupCommands -name '_push_desktop' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_wake' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_find_setupCommands -name '_meta' -exec "$scriptAbsoluteLocation" _setupCommand_meta {} \;
}

_package_cautossh() {
	#cp -a "$scriptAbsoluteFolder"/_index "$safeTmp"/package
	
	#https://stackoverflow.com/questions/4585929/how-to-use-cp-command-to-exclude-a-specific-directory
	#find "$scriptAbsoluteFolder"/_index -type f -not -path '*_arc*' -exec cp -d --preserve=all {} "$safeTmp"'/package/'{} \;
	
	rsync -av --progress --exclude "_arc" "$scriptAbsoluteFolder"/_index/ "$safeTmp"/package/_index/
	
	cp -a "$scriptAbsoluteFolder"/_local/ssh "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/_local/tor "$safeTmp"/package/
}

#May be overridden by "ops" if multiple gateways are required.
_ssh_autoreverse() {
	_torServer_SSH
	_autossh
	
	#_autossh firstGateway
	#_autossh secondGateway
}

_testAutoSSH() {
	if ! _wantGetDep autossh
	then
		echo 'warn: autossh not available'
		return 1
	fi
}

#"$1" == "$gatewayName"
#"$2" == "$reversePort"
_autossh_external() {
	#Workaround. SSH will call CoreAutoSSH recursively as the various "proxy" directives are called. These processes should be managed by SSH, and not recorded in the daemon PID list file, as daemon management scripts may be confused by these many processes quitting long before daemon failure.
	export isDaemon=
	
	local autosshPID
	/usr/bin/autossh -M 0 -F "$sshDir"/config -R "$2":localhost:22 "$1" -N &
	autosshPID="$!"
	
	#echo "$autosshPID" | _prependDaemonPID
	
	#_pauseForProcess "$autosshPID"
	wait "$autosshPID"
}

#Searches for an unused port in the reversePorts list, binds reverse proxy to it.
#Until "_proxySSH_reverse" can differentiate "known_hosts" at remote ports, there is little point in performing a check for open ports at the remote end, since these would be used automatically. Thus, "_autossh_direct" is recommended for now.
#"$1" == "$gatewayName"
_autossh_find() {
	local currentReversePort
	for currentReversePort in "${reversePorts[@]}"
	do
		if ! _checkRemoteSSH "$1" "$currentReversePort"
		then
			_autossh_external "$1" "$currentReversePort"
			return 0
		fi
	done
	return 1
}

#"$1" == "$gatewayName"
_autossh_direct() {
	_autossh_external "$1" "${reversePorts[0]}"
}

#"$1" == "$gatewayName"
_autossh_ready() {
	local sshExitStatus
	
	_ssh "$1" true
	sshExitStatus="$?"
	if [[ "$sshExitStatus" != "255" ]]
	then
		_autossh_direct "$1"
		_stop
	fi
}

#May be overridden by "ops" if multiple gateways are required.
#Not recommended. If multiple gateways are required, it is better to launch autossh daemons for each of them simultaneously. See "_ssh_autoreverse".
_autossh_list_sequence() {
	_start
	
	_autossh_ready "$1"
	
	#_autossh_ready firstGateway
	#_autossh_ready secondGateway
	
	_stop
}

_autossh_list() {
	"$scriptAbsoluteLocation" _autossh_list_sequence "$@"
}

#May be overridden by "ops" to point to direct, find, or list.
_autossh_entry() {
	[[ "$1" != "" ]] && export gatewayName="$1"
	
	_autossh_direct "$gatewayName"
	#_autossh_find "$gatewayName"
	#_autossh_list "$gatewayName"
}

_autossh_launch() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	export sshInContainment="true"
	
	while true
	do
		"$scriptAbsoluteLocation" _autossh_entry "$@"
		
		sleep 30
		
		if [[ "$EMBEDDED" == "true" ]]
		then
			sleep 270
		fi
		
	done
	
	_stop
}

# WARNING Not all autossh functions have been fully tested yet. However, previous versions of this system are known to be much more robust than autossh defaults.
_autossh() {
	mkdir -p "$scriptLocal"/ssh/log
	local logID
	logID=$(_uid)
	_cmdDaemon "$scriptAbsoluteLocation" _autossh_launch "$@" >> "$scriptLocal"/ssh/log/_autossh."$logID".log 2>&1
}

_reversessh() {
	_ssh -R "${reversePorts[0]}":localhost:22 "$gatewayName" -N "$@"
}




_testProxyRouter_sequence() {
	_start
	
	local testPort
	testPort=$(_findPort)
	
	_timeout 10 nc -l -p "$testPort" 2>/dev/null > "$safeTmp"/nctest &
	
	sleep 0.1 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 0.3 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 0.9 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 3 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	sleep 6 && ! echo PASS | nc localhost "$testPort" 2>/dev/null &&
	false
	! grep 'PASS' "$safeTmp"/nctest > /dev/null 2>&1 && _stop 1
	
	_stop 0
}

_testProxyRouter() {
	_getDep socat
	
	_getDep nc
	_getDep nmap
	
	if "$scriptAbsoluteLocation" _testProxyRouter_sequence "$@"
	then
		return 0
	fi
	
	_stop 1
}

#Routes standard in/out to a target host/port through netcat.
_proxy_direct() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	#nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	#nc "$proxyTargetHost" "$proxyTargetPort" 2> /dev/null
	socat - TCP:"$proxyTargetHost":"$proxyTargetPort" 2> /dev/null
}

#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxy() {
	if _checkPort "$1" "$2"
	then
		if _proxy_direct "$1" "$2"
		then
			_stop
		fi
	fi
	
	return 0
}

#Checks all reverse port assignments, launches proxy if open.
#"$1" == host short name
#"$2" == hostname
_proxy_reverse() {
	_get_reversePorts "$1"
	
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		_proxy "$2" "$currentReversePort"
	done
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

_test_os_x11() {
	! _wantDep xset && echo 'warn: xset missing, unable to autodetect'
}

#Default. Overridden where remote machine access is needed (ie. _ssh within _vnc) .
#export permit_x11_override=("$scriptAbsoluteLocation" _ssh -C -o ConnectionAttempts=2 "$@")
#In practice, this override hook no longer has any production use.
_permit_x11() {
	if [[ "$permit_x11_override" != "" ]]
	then
		"${permit_x11_override[@]}" "$@"
		return
	fi
	
	"$@"
}

_report_detect_x11() {
	_messagePlain_probe 'report: _report_detect_x11'
	
	[[ "$destination_DISPLAY" == "" ]] && _messagePlain_warn 'blank: $destination_DISPLAY'
	[[ "$destination_DISPLAY" != "" ]] && _messagePlain_probe 'destination_DISPLAY= '"$destination_DISPLAY"
	
	[[ "$destination_AUTH" == "" ]] && _messagePlain_warn 'blank: $destination_AUTH'
	[[ "$destination_AUTH" != "" ]] && _messagePlain_probe 'destination_AUTH= '"$destination_AUTH"
	
	return 0
}

_detect_x11_displays() {
	_messagePlain_nominal "init: _detect_x11_displays"
	
	local current_XAUTH
	[[ "$1" != "" ]] && current_XAUTH="$1"
	
	local current_DISPLAY
	for (( current_DISPLAY = 0 ; current_DISPLAY <= 12 ; current_DISPLAY++ ))
	do
		export destination_AUTH="$current_XAUTH"
		export destination_DISPLAY=":""$current_DISPLAY"
		
		_messagePlain_probe 'test: _detect_x11_displays: display'
		_report_detect_x11
		
		if _permit_x11 env DISPLAY=:"$current_DISPLAY" XAUTHORITY="$current_XAUTH" xset -q > /dev/null 2>&1
		then
			_messagePlain_good 'found: _detect_x11_displays: working display'
			_report_detect_x11
			return 0
		fi
	done
	_messagePlain_probe 'fail: _detect_x11_displays: working display not found'
	return 1
}

_detect_x11() {
	_messagePlain_nominal "init: _detect_x11"
	
	_messagePlain_nominal "Checking X11 destination variables."
	
	[[ "$destination_DISPLAY" != "" ]] && _messagePlain_warn 'set: $destination_DISPLAY'
	[[ "$destination_AUTH" != "" ]] && _messagePlain_warn 'set: $destination_AUTH'
	if [[ "$destination_DISPLAY" != "" ]] || [[ "$destination_AUTH" != "" ]]
	then
		_report_detect_x11
		return 1
	fi
	
	_messagePlain_nominal "Searching typical X11 display locations"
	export destination_DISPLAY
	export destination_AUTH
	
	if _permit_x11 env DISPLAY=$DISPLAY XAUTHORITY="$XAUTHORITY" xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY="$DISPLAY"
		export destination_AUTH="$XAUTHORITY"
		
		_messagePlain_good 'accept: $DISPLAY $XAUTHORITY'
		_report_detect_x11
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:0 XAUTHORITY="$XAUTHORITY" xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":0"
		export destination_AUTH="$XAUTHORITY"
		
		_messagePlain_good 'accept: $DISPLAY=:0 $XAUTHORITY'
		_report_detect_x11
		return 0
	fi
	
	if _permit_x11 env DISPLAY=:10 XAUTHORITY="$XAUTHORITY" xset -q > /dev/null 2>&1
	then
		export destination_DISPLAY=":10"
		export destination_AUTH="$XAUTHORITY"
		
		_messagePlain_good 'accept: $DISPLAY=:10 $XAUTHORITY'
		_report_detect_x11
		return 0
	fi
	
	export destination_AUTH=$(ps -eo args -fp $(pgrep Xorg | head -n 1) 2>/dev/null | tail -n+2 | sort | sed 's/.*X.*\-auth\ \(.*\)/\1/' | sed 's/\ \-.*//g')
	_messagePlain_nominal "Searching X11 display locations, from process list"
	_messagePlain_probe 'destination_AUTH= '"$destination_AUTH"
	[[ -e "$destination_AUTH" ]] && _detect_x11_displays "$destination_AUTH" && _messagePlain_good 'return: _detect_x11' && _report_detect_x11 && return 0
	
	export destination_AUTH="$HOME"/.Xauthority
	_messagePlain_nominal "Searching X11 display locations, XAUTHORITY at HOME."
	_messagePlain_probe 'destination_AUTH= '"$destination_AUTH"
	[[ -e "$destination_AUTH" ]] && _detect_x11_displays "$destination_AUTH" && _messagePlain_good 'return: _detect_x11' && _report_detect_x11 && return 0
	
	export destination_AUTH="$XAUTHORITY"
	_messagePlain_nominal "Searching X11 display locations, XAUTHORITY as set."
	_messagePlain_probe 'destination_AUTH= '"$destination_AUTH"
	_detect_x11_displays "$destination_AUTH" && _messagePlain_good 'return: _detect_x11' && _report_detect_x11 && return 0
	
	#Unreliable, extra dependencies, last resort.
	local destination_AUTH
	_wantDep x11vnc && export destination_DISPLAY=$(x11vnc -findauth -finddpy | cut -f1 -d\, | cut -f2- -d\=) && destination_AUTH=$(x11vnc -display "$destination_DISPLAY" -findauth | cut -f2- -d\=)
	_messagePlain_nominal "Searching X11 display locations, from x11vnc"
	_messagePlain_probe 'destination_AUTH= '"$destination_AUTH"
	[[ -e "$destination_AUTH" ]] && export destination_AUTH="$destination_AUTH" && _messagePlain_good 'return: _detect_x11' && _report_detect_x11 && return 0
	
	
	export destination_AUTH=""
	export destination_DISPLAY=""
	
	_report_detect_x11
	_messagePlain_bad 'fail: working display not found'
	return 1
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

_apt-file_sequence() {
	_start
	
	_mustGetSudo
	#_mustGetDep su
	
	! _wantDep apt-file && sudo -n apt-get install --install-recommends -y apt-file
	_checkDep apt-file
	
	sudo -n apt-file "$@" > "$safeTmp"/pkgsOut 2> "$safeTmp"/pkgsErr
	sudo -n apt-file search bash > "$safeTmp"/checkOut 2> "$safeTmp"/checkErr
	
	while ! [[ -s "$safeTmp"/checkOut ]] || cat "$safeTmp"/pkgsErr | grep 'cache is empty' > /dev/null 2>&1
	do
		sudo -n apt-file update > "$safeTmp"/updateOut 2> "$safeTmp"/updateErr
		sudo -n apt-file "$@" > "$safeTmp"/pkgsOut 2> "$safeTmp"/pkgsErr
		sudo -n apt-file search bash > "$safeTmp"/checkOut 2> "$safeTmp"/checkErr
	done
	
	cat "$safeTmp"/pkgsOut
	#cat "$safeTmp"/pkgsErr >&2
	_stop
}

_apt-file() {
	_timeout 750 "$scriptAbsoluteLocation" _apt-file_sequence "$@"
}

_fetchDep_debianStretch_special() {
	if [[ "$1" == *"wine"* ]] && ! dpkg --print-foreign-architectures | grep i386 > /dev/null 2>&1
	then
		sudo -n dpkg --add-architecture i386
		sudo -n apt-get update
		sudo -n apt-get install --install-recommends -y wine
		return 0
	fi
	
	if [[ "$1" == "realpath" ]] || [[ "$1" == "readlink" ]] || [[ "$1" == "dirname" ]] || [[ "$1" == "basename" ]] || [[ "$1" == "sha512sum" ]] || [[ "$1" == "sha256sum" ]] || [[ "$1" == "head" ]] || [[ "$1" == "tail" ]] || [[ "$1" == "sleep" ]] || [[ "$1" == "env" ]] || [[ "$1" == "cat" ]] || [[ "$1" == "mkdir" ]] || [[ "$1" == "dd" ]] || [[ "$1" == "rm" ]] || [[ "$1" == "ln" ]] || [[ "$1" == "ls" ]] || [[ "$1" == "test" ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
	then
		sudo -n apt-get install --install-recommends -y coreutils
		return 0
	fi
	
	if [[ "$1" == "mount" ]] || [[ "$1" == "umount" ]] || [[ "$1" == "losetup" ]]
	then
		sudo -n apt-get install --install-recommends -y mount
		return 0
	fi
	
	if [[ "$1" == "mountpoint" ]] || [[ "$1" == "mkfs" ]]
	then
		sudo -n apt-get install --install-recommends -y util-linux
		return 0
	fi
	
	if [[ "$1" == "mkfs.ext4" ]]
	then
		sudo -n apt-get install --install-recommends -y e2fsprogs
		return 0
	fi
	
	if [[ "$1" == "parted" ]] || [[ "$1" == "partprobe" ]]
	then
		sudo -n apt-get install --install-recommends -y parted
		return 0
	fi
	
	if [[ "$1" == "qemu-arm-static" ]] || [[ "$1" == "qemu-armeb-static" ]]
	then
		sudo -n apt-get install --install-recommends -y qemu qemu-user-static binfmt-support
		#update-binfmts --display
		return 0
	fi
	
	if [[ "$1" == "qemu-system-x86_64" ]]
	then
		sudo -n apt-get install --install-recommends -y qemu-system-x86
		return 0
	fi
	
	if [[ "$1" == "qemu-img" ]]
	then
		sudo -n apt-get install --install-recommends -y qemu-utils
		return 0
	fi
	
	if [[ "$1" == "VirtualBox" ]] || [[ "$1" == "VBoxSDL" ]] || [[ "$1" == "VBoxManage" ]] || [[ "$1" == "VBoxHeadless" ]]
	then
		sudo -n mkdir -p /etc/apt/sources.list.d
		echo 'deb http://download.virtualbox.org/virtualbox/debian stretch contrib' | sudo -n tee /etc/apt/sources.list.d/vbox.list > /dev/null 2>&1
		
		"$scriptAbsoluteLocation" _getDep wget
		! _wantDep wget && return 1
		
		# TODO Check key fingerprints match "B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF" and "7B0F AB3A 13B9 0743 5925  D9C9 5442 2A4B 98AB 5139" respectively.
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -n apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo -n apt-key add -
		
		sudo -n apt-get update
		sudo -n apt-get install --install-recommends -y dkms virtualbox-5.2
		
		return 0
	fi
	
	if [[ "$1" == "gpg" ]]
	then
		sudo -n apt-get install --install-recommends -y gnupg
		return 0
	fi
	
	#Unlikely scenario for hosts.
	if [[ "$1" == "grub-install" ]]
	then
		sudo -n apt-get install --install-recommends -y grub2
		#sudo -n apt-get install --install-recommends -y grub-legacy
		return 0
	fi
	
	if [[ "$1" == "MAKEDEV" ]]
	then
		sudo -n apt-get install --install-recommends -y makedev
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "awk" ]]
	then
		sudo -n apt-get install --install-recommends -y mawk
		return 0
	fi
	
	if [[ "$1" == "kill" ]] || [[ "$1" == "ps" ]]
	then
		sudo -n apt-get install --install-recommends -y procps
		return 0
	fi
	
	if [[ "$1" == "find" ]]
	then
		sudo -n apt-get install --install-recommends -y findutils
		return 0
	fi
	
	if [[ "$1" == "docker" ]]
	then
		sudo apt-get install --install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
		
		"$scriptAbsoluteLocation" _getDep curl
		! _wantDep curl && return 1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo -n apt-key add -
		local aptKeyFingerprint
		aptKeyFingerprint=$(sudo -n apt-key fingerprint 0EBFCD88 2> /dev/null)
		[[ "$aptKeyFingerprint" == "" ]] && return 1
		
		sudo -n add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		
		sudo -n apt-get update
		
		sudo -n apt-get remove -y docker docker-engine docker.io docker-ce docker
		sudo -n apt-get install --install-recommends -y docker-ce
		
		sudo -n usermod -a -G docker "$USER"
		
		return 0
	fi
	
	if [[ "$1" == "smbd" ]]
	then
		sudo -n apt-get install --install-recommends -y samba
		return 0
	fi
	
	if [[ "$1" == "atom" ]]
	then
		curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo -n apt-key add -
		sudo -n sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
		
		sudo -n apt-get update
		
		sudo -n apt-get install --install-recommends -y atom
		
		return 0
	fi
	
	if [[ "$1" == "GL/gl.h" ]] || [[ "$1" == "GL/glext.h" ]] || [[ "$1" == "GL/glx.h" ]] || [[ "$1" == "GL/glxext.h" ]] || [[ "$1" == "GL/dri_interface.h" ]] || [[ "$1" == "x86_64-linux-gnu/pkgconfig/dri.pc" ]]
	then
		sudo -n apt-get install --install-recommends -y mesa-common-dev
		
		return 0
	fi
	
	if [[ "$1" == "go" ]]
	then
		sudo -n apt-get install --install-recommends -y golang-go
		
		return 0
	fi
	
	if [[ "$1" == "cura-lulzbot" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See https://www.lulzbot.com/learn/tutorials/cura-lulzbot-edition-installation-debian ."
cat << 'CZXWXcRMTo8EmM8i4d'
wget -qO - https://download.alephobjects.com/ao/aodeb/aokey.pub | sudo apt-key add -
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak && sudo sed -i '$a deb http://download.alephobjects.com/ao/aodeb jessie main' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install cura-lulzbot
CZXWXcRMTo8EmM8i4d
		echo "(typical)"
		_stop 1
	fi
	
	if [[ "$1" =~ "FlashPrint" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See http://www.flashforge.com/support-center/flashprint-support/ ."
		_stop 1
	fi
	
	if [[ "$1" == "cargo" ]] || [[ "$1" == "rustc" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation."
cat << 'CZXWXcRMTo8EmM8i4d'
curl https://sh.rustup.rs -sSf | sh
echo '[[ -e "$HOME"/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
CZXWXcRMTo8EmM8i4d
		echo "(typical)"
		_stop 1
	fi
	
	if [[ "$1" == "firejail" ]]
	then
		echo "WARNING: Recommend manual system configuration after install. See https://firejail.wordpress.com/download-2/ ."
		echo "WARNING: Desktop override symlinks may cause problems, especially preventing proxy host jumping by CoreAutoSSH!"
		return 1
	fi
	
	
	return 1
}

_fetchDep_debianStretch_sequence() {
	_start
	
	_mustGetSudo
	
	_wantDep "$1" && _stop 0
	
	_fetchDep_debianStretch_special "$@" && _wantDep "$1" && _stop 0
	
	sudo -n apt-get install --install-recommends -y "$1" && _wantDep "$1" && _stop 0
	
	_apt-file search "$1" > "$safeTmp"/pkgsOut 2> "$safeTmp"/pkgsErr
	
	local sysPathAll
	sysPathAll=$(sudo -n bash -c "echo \$PATH")
	sysPathAll="$PATH":"$sysPathAll"
	local sysPathArray
	IFS=':' read -r -a sysPathArray <<< "$sysPathAll"
	
	local currentSysPath
	local matchingPackageFile
	local matchingPackagePattern
	local matchingPackage
	for currentSysPath in "${sysPathArray[@]}"
	do
		matchingPackageFile=""
		matchingPackagePath=""
		matchingPackage=""
		matchingPackagePattern="$currentSysPath"/"$1"
		matchingPackageFile=$(grep ': '$matchingPackagePattern'$' "$safeTmp"/pkgsOut | cut -f2- -d' ')
		matchingPackage=$(grep ': '$matchingPackagePattern'$' "$safeTmp"/pkgsOut | cut -f1 -d':')
		if [[ "$matchingPackage" != "" ]]
		then
			sudo -n apt-get install --install-recommends -y "$matchingPackage"
			_wantDep "$1" && _stop 0
		fi
	done
	matchingPackage=""
	matchingPackage=$(head -n 1 "$safeTmp"/pkgsOut | cut -f1 -d':')
	sudo -n apt-get install --install-recommends -y "$matchingPackage"
	_wantDep "$1" && _stop 0
	
	_stop 1
}

_fetchDep_debianStretch() {
	#Run up to 2 times. On rare occasion, cache will become unusable again by apt-find before an installation can be completed. Overall, apt-find is the single weakest link in the system.
	"$scriptAbsoluteLocation" _fetchDep_debianStretch_sequence "$@"
	"$scriptAbsoluteLocation" _fetchDep_debianStretch_sequence "$@"
}

_fetchDep_debian() {
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 1 | grep 9 > /dev/null 2>&1
	then
		_fetchDep_debianStretch "$@"
		return
	fi
	
	return 1
}

#https://unix.stackexchange.com/questions/39226/how-to-run-a-script-with-systemd-right-before-shutdown


_here_systemd_shutdown_action() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
Description=...

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
CZXWXcRMTo8EmM8i4d

echo ExecStop="$scriptAbsoluteLocation" "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

}

_here_systemd_shutdown() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
Description=...

[Service]
Type=oneshot
RemainAfterExit=true
CZXWXcRMTo8EmM8i4d

echo ExecStop="$scriptAbsoluteLocation" _remoteSigTERM "$safeTmp"/.pid "$sessionid"

cat << 'CZXWXcRMTo8EmM8i4d'

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

}

_hook_systemd_shutdown() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	_here_systemd_shutdown | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n systemctl start "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
}

_hook_systemd_shutdown_action() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	_here_systemd_shutdown_action "$@" | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n systemctl start "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	
}

#"$1" == sessionid (optional override for cleaning up stale systemd files)
_unhook_systemd_shutdown() {
	local hookSessionid
	hookSessionid="$sessionid"
	[[ "$1" != "" ]] && hookSessionid="$1"
	
	[[ ! -e /etc/systemd/system/"$hookSessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	[[ "$SYSTEMCTLDISABLE" == "true" ]] && echo SYSTEMCTLDISABLE | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1 && return 0
	export SYSTEMCTLDISABLE=true
	
	sudo -n systemctl disable "$hookSessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n rm -f /etc/systemd/system/"$hookSessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
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

_test_bashdb() {
	#_getDep ddd
	
	#if ! _discoverResource bashdb-code/bashdb.sh > /dev/null 2>&1
	#then
	#	echo
	#	echo 'bashdb required for debugging'
		#_stop 1
	#fi
	
	if ! type bashdb > /dev/null 2>&1
	then
		echo
		echo 'warn: bashdb required for debugging'
	#_stop 1
	fi
	
	return 0
}


_stopwatch() {
	local measureDateA
	local measureDateB
	
	measureDateA=$(date +%s%N | cut -b1-13)

	"$@"

	measureDateB=$(date +%s%N | cut -b1-13)

	bc <<< "$measureDateB - $measureDateA"
}

#####Idle

_gosuBinary() {
	echo "$hostArch" | grep x86_64 > /dev/null 2>&1 && export gosuBinary="gosu-amd64" && return
	echo "$hostArch" | grep x86 > /dev/null 2>&1 && export gosuBinary="gosu-i386" && return
	echo "$hostArch" | grep arm > /dev/null 2>&1 && export gosuBinary="gosu-armel" && return
	
	uname -m | grep x86_64 > /dev/null 2>&1 && export gosuBinary="gosu-amd64" && return
	uname -m | grep x86 > /dev/null 2>&1 && export gosuBinary="gosu-i386" && return
	uname -m | grep arm > /dev/null 2>&1 && export gosuBinary="gosu-armel" && return
}

_gosuExecVirt() {
	_gosuBinary
	
	if [[ "$1" == "" ]]
	then
		exec "$scriptBin"/"$gosuBinary" "$virtSharedUser" /bin/bash "$@"
		return
	fi
	
	exec "$scriptBin"/"$gosuBinary" "$virtSharedUser" "$@"
}

_test_buildGoSu() {
	_getDep gpg
	_getDep dirmngr
}

_testBuiltGosu() {
	#export PATH="$PATH":"$scriptBin"
	
	_getDep gpg
	_getDep dirmngr
	
	_gosuBinary
	
	_checkDep "$gosuBinary"
	
	#Beware, this test requires either root or sudo to actually verify functionality.
	if ! "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1 && ! sudo -n "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1
	then
		echo gosu invalid response
		_stop 1
	fi
	
}

_verifyGosu_sequence() {
	_start
	
	local gpgTestDir
	gpgTestDir="$safeTmp"
	[[ -e "$scriptBin"/gosu-armel ]] && [[ -e "$scriptBin"/gosu-armel.asc ]] && [[ -e "$scriptBin"/gosu-amd64 ]] && [[ -e "$scriptBin"/gosu-amd64.asc ]] && [[ -e "$scriptBin"/gosu-i386 ]] && [[ -e "$scriptBin"/gosu-i386.asc ]] && [[ -e "$scriptBin"/gosudev.asc ]] && gpgTestDir="$scriptBin" #&& _stop 1
	
	[[ "$1" != "" ]] && gpgTestDir="$1"
	
	if ! [[ -e "$gpgTestDir"/gosu-armel ]] || ! [[ -e "$gpgTestDir"/gosu-armel.asc ]] || ! [[ -e "$gpgTestDir"/gosu-amd64 ]] || ! [[ -e "$gpgTestDir"/gosu-amd64.asc ]] || ! [[ -e "$gpgTestDir"/gosu-i386 ]] || ! [[ -e "$gpgTestDir"/gosu-i386.asc ]] || ! [[ -e "$gpgTestDir"/gosudev.asc ]]
	then
		_stop 1
	fi
	
	# verify the signature
	export GNUPGHOME="$shortTmp"/vgosu
	mkdir -m 700 -p "$GNUPGHOME" > /dev/null 2>&1
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/vgosu
	
	# TODO Add further verification steps.
	gpg --armor --import "$gpgTestDir"/gosudev.asc || _stop 1
	
	gpg --batch --verify "$gpgTestDir"/gosu-armel.asc "$gpgTestDir"/gosu-armel || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-amd64.asc "$gpgTestDir"/gosu-amd64 || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-i386.asc "$gpgTestDir"/gosu-i386 || _stop 1
	
	_stop
}

_verifyGosu() {
	if ! "$scriptAbsoluteLocation" _verifyGosu_sequence "$@"
	then
		return 1
	fi
	return 0
}

_testGosu() {
	if ! _verifyGosu > /dev/null 2>&1
	then
		echo 'need valid gosu'
		_stop 1
	fi
	return 0
}

#From https://github.com/tianon/gosu/blob/master/INSTALL.md .
# TODO Build locally from git repo and verify.
_buildGosu_sequence() {
	_start
	
	local haveGosuBin
	haveGosuBin=false
	[[ -e "$scriptBin"/gosu-armel ]] && [[ -e "$scriptBin"/gosu-armel.asc ]] && [[ -e "$scriptBin"/gosu-amd64 ]] && [[ -e "$scriptBin"/gosu-amd64.asc ]] && [[ -e "$scriptBin"/gosu-i386 ]] && [[ -e "$scriptBin"/gosu-i386.asc ]] && [[ -e "$scriptBin"/gosudev.asc ]] && haveGosuBin=true #&& return 0
	
	local GOSU_VERSION
	GOSU_VERSION=1.10
	
	if [[ "$haveGosuBin" != "true" ]]
	then
		wget -O "$safeTmp"/gosu-armel https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel
		wget -O "$safeTmp"/gosu-armel.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel.asc
		
		wget -O "$safeTmp"/gosu-amd64 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
		wget -O "$safeTmp"/gosu-amd64.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc
		
		wget -O "$safeTmp"/gosu-i386 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386
		wget -O "$safeTmp"/gosu-i386.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386.asc
	fi
	
	export GNUPGHOME="$shortTmp"/bgosu
	mkdir -m 700 -p "$GNUPGHOME" > /dev/null 2>&1
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/bgosu
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || _stop 1
	gpg --armor --export 036A9C25BF357DD4 > "$safeTmp"/gosudev.asc || stop 1
	
	if [[ "$haveGosuBin" != "true" ]]
	then
		_verifyGosu "$safeTmp" > /dev/null 2>&1 || _stop 1
	fi
	if [[ "$haveGosuBin" == "true" ]]
	then
		_verifyGosu "$scriptBin" > /dev/null 2>&1 || _stop 1
	fi
	
	[[ "$haveGosuBin" != "true" ]] && mv "$safeTmp"/gosu* "$scriptBin"/
	[[ "$haveGosuBin" != "true" ]] && chmod ugoa+rx "$scriptBin"/gosu-*
	
	_stop
}

_buildGosu() {
	"$scriptAbsoluteLocation" _buildGosu_sequence "$@"
}


_start_virt_instance() {
	
	mkdir -p "$instancedVirtDir" || return 1
	mkdir -p "$instancedVirtFS" || return 1
	mkdir -p "$instancedVirtTmp" || return 1
	
	mkdir -p "$instancedVirtHome" || return 1
	###mkdir -p "$instancedVirtHomeRef" || return 1
	
	mkdir -p "$sharedHostProjectDir" > /dev/null 2>&1
	mkdir -p "$instancedProjectDir" || return 1
	
}

_start_virt_all() {
	
	_start_virt_instance
	
	mkdir -p "$globalVirtDir" || return 1
	mkdir -p "$globalVirtFS" || return 1
	mkdir -p "$globalVirtTmp" || return 1
	
	
	return 0
}

_stop_virt_instance() {
	
	_wait_umount "$instancedProjectDir"
	sudo -n rmdir "$instancedProjectDir"
	
	_wait_umount "$instancedVirtHome"
	sudo -n rmdir "$instancedVirtHome"
	###_wait_umount "$instancedVirtHomeRef"
	###sudo -n rmdir "$instancedVirtHomeRef"
	sudo -n rmdir "$instancedVirtFS"/home
	
	_wait_umount "$instancedVirtFS"
	sudo -n rmdir "$instancedVirtFS"
	_wait_umount "$instancedVirtTmp"
	sudo -n rmdir "$instancedVirtTmp"
	_wait_umount "$instancedVirtDir"
	sudo -n rmdir "$instancedVirtDir"
	
	
	
	return 0
	
}

_stop_virt_all() {
	
	_stop_virt_instance || return 1
	
	_wait_umount "$globalVirtFS" || return 1
	_wait_umount "$globalVirtTmp" || return 1
	_wait_umount "$globalVirtDir" || return 1
	
	
	
}


#Triggers before "user" and "edit" virtualization commands, to allow a single installation of a virtual machine to be used by multiple ubiquitous labs.
#Does NOT trigger for all non-user commands (eg. open, docker conversion), as these are intended for developers with awareness of associated files under "$scriptLocal".

# WARNING
# DISABLED by default. Must be explicitly enabled by setting "$ubVirtImageLocal" to "false" in "ops".

#toImage

#_closeChRoot

#_closeVBoxRaw

#_editQemu
#_editVBox

#_userChRoot
#_userQemu
#_userVBox

#_userDocker

#_dockerCommit
#_dockerLaunch
#_dockerAttach
#_dockerOn
#_dockerOff

_findInfrastructure_virtImage() {
	[[ "$ubVirtImageLocal" != "false" ]] && return 0
	
	[[ -e "$scriptLocal"/vm.img ]] && export ubVirtImageLocal="true" && return 0
	[[ -e "$scriptLocal"/vm.vdi ]] && export ubVirtImageLocal="true" && return 0
	[[ -e "$scriptLocal"/vmvdiraw.vmdi ]] && export ubVirtImageLocal="true" && return 0
	
	_checkSpecialLocks && export ubVirtImageLocal="true" && return 0
	
	_findInfrastructure_virtImage_script "$@"
}

# WARNING
#Overloading with "ops" is recommended.
_findInfrastructure_virtImage_script() {
	local infrastructureName=$(basename "$scriptAbsoluteFolder")
	
	local recursionExec
	local recursionExecList
	local currentRecursionExec
	
	recursionExecList+=("$scriptAbsoluteFolder"/../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	#recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$HOME"/core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	
	recursionExecList+=("$HOME"/core/extra/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh)
	
	local whichExeVM
	whichExeVM=nixexevm
	[[ "$virtOStype" == 'MSW'* ]] && whichExeVM=winexevm
	[[ "$virtOStype" == 'Windows'* ]] && whichExeVM=winexevm
	[[ "$vboxOStype" == 'Windows'* ]] && whichExeVM=winexevm
	
	
	recursionExecList+=("$scriptAbsoluteFolder"/../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../../core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$scriptAbsoluteFolder"/../../../../../../../core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	
	recursionExecList+=("$HOME"/core/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$HOME"/core/extra/infrastructure/"$whichExeVM"/ubiquitous_bash.sh)
	
	recursionExecList+=("$HOME"/core/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	recursionExecList+=("$HOME"/core/extra/infrastructure/vm/"$whichExeVM"/ubiquitous_bash.sh)
	
	for currentRecursionExec in "${recursionExecList[@]}"
	do
		if _recursion_guard "$currentRecursionExec"
		then
			"$currentRecursionExec" "$@"
			return
		fi
	done
}


#Removes 'file://' often used by browsers.
_removeFilePrefix() {
	local translatedFileParam
	translatedFileParam=${1/#file:\/\/}
	
	_safeEcho_newline "$translatedFileParam"
}

#Translates back slash parameters (UNIX paths) to forward slash parameters (MSW paths).
_slashBackToForward() {
	local translatedFileParam
	translatedFileParam=${1//\//\\}
	
	_safeEcho_newline "$translatedFileParam"
}

_nixToMSW() {
	echo -e -n 'Z:'
	
	local localAbsoluteFirstParam
	localAbsoluteFirstParam=$(_getAbsoluteLocation "$1")
	
	local intermediateStepOne
	intermediateStepOne=_removeFilePrefix "$localAbsoluteFirstParam"
	
	_slashBackToForward "$intermediateStepOne"
}

#Determines whether test parameter is in the path of base parameter.
#"$1" == testParameter
#"$2" == baseParameter
_pathPartOf() {
	local testParameter
	testParameter="IAUjqyPF2s3gqjC0t1"
	local baseParameter
	baseParameter="JQRBqIoOVoDJuzc7k9"
	
	[[ -e "$1" ]] && testParameter=$(_getAbsoluteLocation "$1")
	[[ -e "$2" ]] && baseParameter=$(_getAbsoluteLocation "$2")
	
	[[ "$testParameter" != "$baseParameter"* ]] && return 1
	return 0
}

#Checks if file/directory exists on local filesystem, and meets other criteria. Intended to be called within the virtualization platform, through _checkBaseDirRemote . Often maintained merely for the sake of example.
_checkBaseDirLocal() {
	/bin/bash -c '[[ -e "'"$1"'" ]] && ! [[ -d "'"$1"'" ]] && [[ "'"$1"'" != "." ]] && [[ "'"$1"'" != ".." ]] && [[ "'"$1"'" != "./" ]] && [[ "'"$1"'" != "../" ]]'
}

_checkBaseDirRemote_app_localOnly() {
	false
}

_checkBaseDirRemote_app_remoteOnly() {
	[[ "$1" == "/bin/bash" ]] && return 0
}

# WARNING Strongly recommend not sharing root with guest, but this can be overridden by "ops".
_checkBaseDirRemote_common_localOnly() {
	[[ "$1" == "." ]] && return 0
	[[ "$1" == "./" ]] && return 0
	[[ "$1" == ".." ]] && return 0
	[[ "$1" == "../" ]] && return 0
	
	[[ "$1" == "/" ]] && return 0
	
	return 1
}

_checkBaseDirRemote_common_remoteOnly() {
	[[ "$1" == "/bin"* ]] && return 0
	[[ "$1" == "/lib"* ]] && return 0
	[[ "$1" == "/lib64"* ]] && return 0
	[[ "$1" == "/opt"* ]] && return 0
	[[ "$1" == "/usr"* ]] && return 0
	
	[[ "$1" == "/bin/bash" ]] && return 0
	
	#type "$1" > /dev/null 2>&1 && return 0
	
	#! [[ "$1" == "/"* ]] && return 0
	
	return 1
}

#Checks if file/directory exists on remote system. Overload this function with implementation specific to the container/virtualization solution in use (ie. docker run).
_checkBaseDirRemote() {
	_checkBaseDirRemote_common_localOnly "$1" && return 0
	_checkBaseDirRemote_common_remoteOnly "$1" && return 1
	
	_checkBaseDirRemote_app_localOnly "$1" && return 0
	_checkBaseDirRemote_app_remoteOnly "$1" && return 1
	
	[[ "$checkBaseDirRemote" == "" ]] && checkBaseDirRemote="false"
	"$checkBaseDirRemote" "$1" || return 1
	return 0
}

#Reports the highest-level directory containing all files in given parameter set.
#"$@" == parameters to search
#$checkBaseDirRemote == function to check if file/directory exists on remote system
_searchBaseDir() {
	local baseDir
	local newDir
	
	baseDir=""
	
	local processedArgs
	local currentArg
	local currentResult
	
	#Do not translate if exists on remote filesystem. Dummy check by default unless overloaded, by $checkBaseDirRemote value.
	#Intended to prevent "/bin/true" and similar from being translated, so execution of remote programs can be requested.
	for currentArg in "$@"
	do
		if _checkBaseDirRemote "$currentArg"
		then
			continue
		fi
		
		currentResult="$currentArg"
		processedArgs+=("$currentResult")
	done
	
	for currentArg in "${processedArgs[@]}"
	do
		
		if [[ ! -e "$currentArg" ]]
		then
			continue
		fi
		
		if [[ "$baseDir" == "" ]]
		then
			baseDir=$(_findDir "$currentArg")
		fi
		
		for subArg in "${processedArgs[@]}"
		do
			if [[ ! -e "$subArg" ]]
			then
				continue
			fi
			
			newDir=$(_findDir "$subArg")
			
			while [[ "$newDir" != "$baseDir"* ]]
			do
				baseDir=$(_findDir "$baseDir"/..)
				
				if [[ "$baseDir" == "/" ]]
				then
					break
				fi
			done
			
		done
		
		
		
		
	done
	
	_safeEcho_newline "$baseDir"
}

#Converts to relative path, if provided a file parameter.
#"$1" == parameter to search
#"$2" == sharedHostProjectDir
#"$3" == sharedGuestProjectDir (optional)
_localDir() {
	if _checkBaseDirRemote "$1"
	then
		_safeEcho_newline "$1"
		return
	fi
	
	if [[ ! -e "$2" ]]
	then
		_safeEcho_newline "$1"
		return
	fi
	
	if [[ ! -e "$1" ]] || ! _pathPartOf "$1" "$2"
	then
		_safeEcho_newline "$1"
		return
	fi
	
	[[ "$3" != "" ]] && _safeEcho "$3" && [[ "$3" != "/" ]] && _safeEcho "/"
	realpath -L -s --relative-to="$2" "$1"
	
}


#Takes a list of parameters, idenfities file parameters, finds a common path, and translates all parameters to that path. Essentially provides shared folder and file parameter translation for application virtualization solutions.
#Keep in mind this function has a relatively complex set of inputs and outputs, serving a critically wide variety of edgy use cases across platforms.
#"$@" == input parameters

#"$sharedHostProjectDir" == if already set, overrides the directory that will be shared, rarely used to share entire root
#"$sharedGuestProjectDir" == script default is /home/ubvrtusr/project, can be overridden, "X:" typical for MSW guests
#Setting sharedGuestProjectDir to a drive letter designation will also enable UNIX/MSW parameter translation mechanisms.

# export sharedHostProjectDir == common directory to bind mount
# export processedArgs == translated arguments to be used in place of "$@"

# WARNING Consider specified syntax for portability.
# _runExec "${processedArgs[@]}"
_virtUser() {
	export sharedHostProjectDir="$sharedHostProjectDir"
	export processedArgs
	
	[[ "$virtUserPWD" == "" ]] && export virtUserPWD="$outerPWD"
	
	if [[ -e /tmp/.X11-unix ]] && [[ "$DISPLAY" != "" ]] && type xauth > /dev/null 2>&1
	then
		export XSOCK=/tmp/.X11-unix
		export XAUTH=/tmp/.virtuser.xauth."$sessionid"
		touch $XAUTH
		xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
	fi
	
	if [[ "$sharedHostProjectDir" == "" ]]
	then
		sharedHostProjectDir=$(_searchBaseDir "$@" "$virtUserPWD")
		#sharedHostProjectDir="$safeTmp"/shared
		mkdir -p "$sharedHostProjectDir"
	fi
	
	export localPWD=$(_localDir "$virtUserPWD" "$sharedHostProjectDir" "$sharedGuestProjectDir")
	export virtUserPWD=
	
	#If $sharedGuestProjectDir matches MSW drive letter format, enable translation of other non-UNIX file parameter differences.
	local enableMSWtranslation
	enableMSWtranslation=false
	_safeEcho_newline "$sharedGuestProjectDir" | grep '^[[:alpha:]]\:\|^[[:alnum:]][[:alnum:]]\:\|^[[:alnum:]][[:alnum:]][[:alnum:]]\:' > /dev/null 2>&1 && enableMSWtranslation=true
	
	#http://stackoverflow.com/questions/15420790/create-array-in-loop-from-number-of-arguments
	#local processedArgs
	local currentArg
	local currentResult
	processedArgs=()
	for currentArg in "$@"
	do
		currentResult=$(_localDir "$currentArg" "$sharedHostProjectDir" "$sharedGuestProjectDir")
		[[ "$enableMSWtranslation" == "true" ]] && currentResult=$(_slashBackToForward "$currentResult")
		processedArgs+=("$currentResult")
	done
}

_stop_virtLocal() {
	[[ "$XAUTH" == "" ]] && return
	[[ ! -e "$XAUTH" ]] && return
	
	rm -f "$XAUTH" > /dev/null 2>&1
}

_test_virtLocal_X11() {
	_getDep xauth
}

# TODO: Expansion needed.
_vector_virtUser() {
	export sharedHostProjectDir=
	export sharedGuestProjectDir=/home/user/project
	_virtUser /tmp
	#_safeEcho_newline "${processedArgs[0]}"
	[[ "${processedArgs[0]}" != '/home/user/project/tmp' ]] && echo 'fail: _vector_virtUser' && _messageFAIL
	
	export sharedHostProjectDir=/
	export sharedGuestProjectDir='Z:'
	_virtUser /tmp
	#_safeEcho_newline "${processedArgs[0]}"
	[[ "${processedArgs[0]}" != 'Z:\tmp' ]] && echo 'fail: _vector_virtUser' && _messageFAIL
	
	export sharedHostProjectDir=/tmp
	export sharedGuestProjectDir='/home/user/project/tmp'
	_virtUser /tmp
	#_safeEcho_newline "${processedArgs[0]}"
	[[ "${processedArgs[0]}" != '/home/user/project/tmp/.' ]] && echo 'fail: _vector_virtUser' && _messageFAIL
	
	export virtUserPWD='/tmp'
	export sharedHostProjectDir=/tmp
	export sharedGuestProjectDir='/home/user/project/tmp'
	_virtUser /tmp
	#_safeEcho_newline "${processedArgs[0]}"
	#_safeEcho_newline "$localPWD"
	[[ "$localPWD" != '/home/user/project/tmp/.' ]] && echo 'fail: _vector_virtUser' && _messageFAIL
	
	export virtUserPWD='/tmp'
	export sharedHostProjectDir=/tmp
	export sharedGuestProjectDir='/home/user/project/tmp'
	_virtUser -e /tmp
	#_safeEcho_newline "${processedArgs[0]}"
	[[ "${processedArgs[0]}" != '-e' ]] && echo 'fail: _vector_virtUser' && _messageFAIL
	
	
	return 0
}






_test_abstractfs_sequence() {
	export afs_nofs="true"
	if ! "$scriptAbsoluteLocation" _abstractfs ls "$scriptAbsoluteLocation" > /dev/null 2>&1
	then
		_stop 1
	fi
}

_test_abstractfs() {
	_getDep md5sum
	if ! "$scriptAbsoluteLocation" _test_abstractfs_sequence
	then
		echo 'fail: abstractfs: ls'
		_stop 1
	fi
}

_abstractfs() {
	#Nesting prohibited. Not fully tested.
	# WARNING: May cause infinite recursion symlinks.
	[[ "$abstractfs" != "" ]] && return 1
	
	_reset_abstractfs
	
	_prepare_abstract
	
	local abstractfs_command="$1"
	shift
	
	export virtUserPWD="$PWD"
	
	export abstractfs_puid=$(_uid)
	
	_base_abstractfs "$@"
	_name_abstractfs > /dev/null 2>&1
	[[ "$abstractfs_name" == "" ]] && return 1
	
	export abstractfs="$abstractfs_root"/"$abstractfs_name"
	
	_set_share_abstractfs
	_relink_abstractfs
	_virtUser "$@"
	
	cd "$localPWD"
	#cd "$abstractfs_base"
	#cd "$abstractfs"
	
	local commandExitStatus
	
	#_scope_terminal "${processedArgs[@]}"
	"$abstractfs_command" "${processedArgs[@]}"
	commandExitStatus=$?
	
	_set_share_abstractfs_reset
	_rmlink_abstractfs
	
	return "$commandExitStatus"
}

_reset_abstractfs() {
	export abstractfs=
	export abstractfs_base=
	export abstractfs_name=
	export abstractfs_puid=
	export abstractfs_projectafs=
}

_prohibit_rmlink_abstractfs() {
	#mkdir -p "$abstractfs_lock"/"$abstractfs_name"
	mkdir -p "$abstractfs_lock"/"$abstractfs_name"/"$abstractfs_puid"
}

_permit_rmlink_abstractfs() {
	#mkdir -p "$abstractfs_lock"/"$abstractfs_name"
	rmdir "$abstractfs_lock"/"$abstractfs_name"/"$abstractfs_puid" > /dev/null 2>&1
}

_wait_rmlink_abstractfs() {
	! [[ -e "$abstractfs_lock"/"$abstractfs_name"_rmlink ]] && return 0
	sleep 0.1
	
	! [[ -e "$abstractfs_lock"/"$abstractfs_name"_rmlink ]] && return 0
	sleep 0.3
	
	! [[ -e "$abstractfs_lock"/"$abstractfs_name"_rmlink ]] && return 0
	sleep 1
	
	! [[ -e "$abstractfs_lock"/"$abstractfs_name"_rmlink ]] && return 0
	sleep 3
	
	! [[ -e "$abstractfs_lock"/"$abstractfs_name"_rmlink ]] && return 0
	return 1
}

_rmlink_abstractfs() {
	mkdir -p "$abstractfs_lock"
	_permit_rmlink_abstractfs
	
	! _wait_rmlink_abstractfs && return 1
	
	echo > "$abstractfs_lock"/"$abstractfs_name"_rmlink
	
	rmdir "$abstractfs_lock"/"$abstractfs_name" >/dev/null 2>&1 && _rmlink "$abstractfs"
	rmdir "$abstractfs_root" >/dev/null 2>&1
	
	rm "$abstractfs_lock"/"$abstractfs_name"_rmlink
}

_relink_abstractfs() {
	! _wait_rmlink_abstractfs && return 1
	
	mkdir -p "$abstractfs_lock"
	_prohibit_rmlink_abstractfs
	
	! _wait_rmlink_abstractfs && return 1
	
	_relink "$sharedHostProjectDir" "$sharedGuestProjectDir"
}

#Precaution. Should not be a requirement in any production use.
_set_share_abstractfs_reset() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
}

# ATTENTION: Overload with "core.sh".
_set_share_abstractfs() {
	_set_share_abstractfs_reset
	
	export sharedHostProjectDir="$abstractfs_base"
	#export sharedHostProjectDir=$(_getAbsoluteFolder "$abstractfs_base")
	export sharedGuestProjectDir="$abstractfs"
	
	#Blank default. Resolves to lowest directory shared by "$PWD" and "$@" .
	#export sharedHostProjectDir="$sharedHostProjectDirDefault"
}

_describe_abstractfs() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	local testAbstractfsBase
	testAbstractfsBase="$abstractfs_base"
	[[ "$1" != "" ]] && testAbstractfsBase=$(_getAbsoluteLocation "$1")
	
	basename "$testAbstractfsBase"
	! cd "$testAbstractfsBase" >/dev/null 2>&1 && cd "$localFunctionEntryPWD" && return 1
	git rev-parse --abbrev-ref HEAD 2>/dev/null
	git remote show origin 2>/dev/null
	
	cd "$localFunctionEntryPWD"
}

_base_abstractfs() {
	export abstractfs_base=
	[[ "$@" != "" ]] && export abstractfs_base=$(_searchBaseDir "$@")
	[[ "$abstractfs_base" == "" ]] && export abstractfs_base=$(_searchBaseDir "$@" "$virtUserPWD")
}

_findProjectAFS_procedure() {
	[[ "$ub_findProjectAFS_maxheight" -gt "120" ]] && return 1
	let ub_findProjectAFS_maxheight="$ub_findProjectAFS_maxheight"+1
	export ub_findProjectAFS_maxheight
	
	if [[ -e "./project.afs" ]]
	then
		_getAbsoluteLocation "./project.afs"
		return 0
	fi
	
	[[ "$1" == "/" ]] && return 1
	
	! cd .. > /dev/null 2>&1 && return 1
	
	_findProjectAFS_procedure
}

#Recursively searches for directories containing "project.afs".
_findProjectAFS() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$1"
	
	_findProjectAFS_procedure
	
	cd "$localFunctionEntryPWD"
}

_projectAFS_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

export abstractfs_name="$abstractfs_name"
CZXWXcRMTo8EmM8i4d
}

_write_projectAFS() {
	local testAbstractfsBase
	testAbstractfsBase="$abstractfs_base"
	[[ "$1" != "" ]] && testAbstractfsBase=$(_getAbsoluteLocation "$1")
	
	( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] ) && return 0
	_projectAFS_here > "$testAbstractfsBase"/project.afs
	chmod u+x "$testAbstractfsBase"/project.afs
}

# DANGER: Mandatory strict directory 8.3 compliance for this variable! Long subdirectory/filenames permitted thereafter.
_default_name_abstractfs() {
	#If "$abstractfs_name" is not saved to file, a consistent, compressed, naming scheme, is required.
	if ( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] )
	then
		#echo $(basename "$abstractfs_base") | md5sum | head -c 8
		_describe_abstractfs "$@" | md5sum | head -c 8
		return
	fi
	
	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-z' 2> /dev/null | head -c "1" 2> /dev/null
	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-z0-9' 2> /dev/null | head -c "7" 2> /dev/null
}

#"$1" == "$abstractfs_base" || ""
_name_abstractfs() {
	export abstractfs_name=
	
	local testAbstractfsBase
	testAbstractfsBase="$abstractfs_base"
	[[ "$1" != "" ]] && testAbstractfsBase=$(_getAbsoluteLocation "$1")
	
	export abstractfs_projectafs=$(_findProjectAFS "$testAbstractfsBase")
	[[ "$abstractfs_projectafs" != "" ]] && [[ -e "$abstractfs_projectafs" ]] && . "$abstractfs_projectafs" --noexec
	
	if [[ "$abstractfs_name" == "" ]]
	then
		export abstractfs_name=$(_default_name_abstractfs "$testAbstractfsBase")
		if ( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] )
		then
			echo "$abstractfs_name"
			return
		fi
		_write_projectAFS "$testAbstractfsBase"
		export abstractfs_name=
	fi
	
	export abstractfs_projectafs=$(_findProjectAFS "$testAbstractfsBase")
	[[ "$abstractfs_projectafs" != "" ]] && [[ -e "$abstractfs_projectafs" ]] && . "$abstractfs_projectafs" --noexec
	
	( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] ) && [[ ! -e "$abstractfs_projectafs" ]] && return 1
	[[ "$abstractfs_name" == "" ]] && return 1
	
	echo "$abstractfs_name"
	return 0
}

_makeFakeHome_extra_layer0() {
	_relink "$1"/.bashrc "$2"/.bashrc
	_relink "$1"/.ubcore "$2"/.ubcore
	
	_relink "$1"/.Xauthority "$2"/.Xauthority
	
	_relink "$1"/.ssh "$2"/.ssh
	_relink "$1"/.gitconfig "$2"/.gitconfig
	
	mkdir -p "$2"/.config
}

_makeFakeHome_extra_layer1() {
	true
}

#"$1" == sourceHome
#"$2" == destinationHome
_makeFakeHome() {
	[[ "$1" == "" ]] && return 1
	! [[ -d "$1" ]] && return 1
	
	[[ "$2" == "" ]] && return 1
	[[ "$2" == "/home/""$USER" ]] && return 1
	! [[ -d "$2" ]] && return 1
	
	_relink "$1" "$2"/realHome
	
	_relink "$1"/Downloads "$2"/Downloads
	
	_relink "$1"/Desktop "$2"/Desktop
	_relink "$1"/Documents "$2"/Documents
	_relink "$1"/Music "$2"/Music
	_relink "$1"/Pictures "$2"/Pictures
	_relink "$1"/Public "$2"/Public
	_relink "$1"/Templates "$2"/Templates
	_relink "$1"/Videos "$2"/Videos
	
	_relink "$1"/bin "$2"/bin
	
	_relink "$1"/core "$2"/core
	_relink "$1"/project "$2"/project
	_relink "$1"/projects "$2"/projects
	
	
	
	_makeFakeHome_extra_layer0 "$@"
	_makeFakeHome_extra_layer1 "$@"
}

_unmakeFakeHome_extra_layer0() {
	_rmlink "$1"/.bashrc
	_rmlink "$1"/.ubcore
	
	_rmlink "$1"/.Xauthority
	
	_rmlink "$1"/.ssh
	_rmlink "$1"/.gitconfig
	
	rmdir "$1"/.config
}

_unmakeFakeHome_extra_layer1() {
	true
}

#"$1" == destinationHome
_unmakeFakeHome() {
	[[ "$1" == "" ]] && return 1
	[[ "$1" == "/home/""$USER" ]] && return 1
	! [[ -d "$1" ]] && return 1
	
	_rmlink "$1"/realHome
	
	_rmlink "$1"/Downloads
	
	_rmlink "$1"/Desktop
	_rmlink "$1"/Documents
	_rmlink "$1"/Music
	_rmlink "$1"/Pictures
	_rmlink "$1"/Public
	_rmlink "$1"/Templates
	_rmlink "$1"/Videos
	
	_rmlink "$1"/bin
	
	_rmlink "$1"/core
	_rmlink "$1"/project
	_rmlink "$1"/projects
	
	
	
	_unmakeFakeHome_extra_layer0 "$@"
	_unmakeFakeHome_extra_layer1 "$@"
}

_test_fakehome() {
	_getDep mount
	_getDep mountpoint
	
	_getDep rsync
}

#Example. Run similar code under "core.sh" before calling "_fakeHome", "_install_fakeHome", or similar, to set a specific type/location for fakeHome environment - global, instanced, or otherwise.
_arbitrary_fakeHome_app() {
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$shortFakeHome"
	
	#export actualFakeHome="$globalFakeHome"
	#export actualFakeHome=""$arbitraryFakeHome"/arbitrary"
}

#"$1" == lib source path (eg. "$scriptLib"/app/.app)
#"$2" == home destination path (eg. ".app")
# WARNING: Locking mechanism not intended to be relied on.
# WARNING: Return status success may not reflect successful link/copy.
_link_fakeHome() {
	mkdir -p "$1" > /dev/null 2>&1
	mkdir -p "$actualFakeHome" > /dev/null 2>&1
	mkdir -p "$globalFakeHome" > /dev/null 2>&1
	
	#If globalFakeHome symlinks are obsolete, subsequent _instance_internal operation may overwrite valid links with them. See _install_fakeHome .
	rmdir "$globalFakeHome"/"$2" > /dev/null 2>&1
	_relink "$1" "$globalFakeHome"/"$2"
	
	if [[ "$actualFakeHome" == "$globalFakeHome" ]] || [[ "$fakeHomeEditLib" == "true" ]]
	then
		rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
		_relink "$1" "$actualFakeHome"/"$2"
		return 0
	fi
	
	#Actual files/directories will not be overwritten by symlinks when "$globalFakeHome" is copied to "$actualFakeHome". Remainder of this function dedicated to creating copies, before and instead of, symlinks.
	
	#rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
	_rmlink "$actualFakeHome"/"$2"
	
	#Waits if copy is in progress, delaying program launch.
	local lockWaitTimer
	for (( lockWaitTimer = 0 ; lockWaitTimer <= 90 ; lockWaitTimer++ )); do
		! [[ -e "$actualFakeHome"/"$2".lck ]] && break
		sleep 0.3
	done
	
	#Checks if copy has already been made.
	[[ -e "$actualFakeHome"/"$2" ]] && return 0
	
	mkdir -p "$actualFakeHome"/"$2"
	
	#Copy file.
	if ! [[ -d "$1" ]] && [[ -e "$1" ]]
	then
		rmdir "$actualFakeHome"/"$2" > /dev/null 2>&1
		
		echo > "$actualFakeHome"/"$2".lck
		cp "$1" "$actualFakeHome"/"$2"
		rm "$actualFakeHome"/"$2".lck
		return 0
	fi
	
	#Copy directory.
	echo > "$actualFakeHome"/"$2".lck
	_instance_internal "$1"/. "$actualFakeHome"/"$2"/
	rm "$actualFakeHome"/"$2".lck
	return 0
}

#Example. Override with "core.sh". Allows specific application configuration directories to reside outside of globalFakeHome, for organization, testing, and distribution.
_install_fakeHome_app() {
	#_link_fakeHome "$scriptLib"/app/.app ".app"
	
	true
}

#actualFakeHome
_install_fakeHome() {
	_install_fakeHome_app
	
	#Asterisk used where multiple global home folders are needed, following convention "$scriptLocal"/h_* . Used by webClient for _firefox_esr .
	[[ "$actualFakeHome" == "$globalFakeHome"* ]] && return 0
	
	#Any globalFakeHome links created by "_link_fakeHome" are not to overwrite copies made to instancedFakeHome directories. Related errors emitted by "rsync" are normal, and therefore, silenced.
	_instance_internal "$globalFakeHome"/. "$actualFakeHome"/ > /dev/null 2>&1
}

#Run before _fakeHome to use a ramdisk as home directory. Wrap within "_wantSudo" and ">/dev/null 2>&1" to use optionally. Especially helpful to limit SSD wear when dealing with moderately large (ie. ~2GB) fakeHome environments which must be instanced.
_mountRAM_fakeHome() {
	_mustGetSudo
	mkdir -p "$actualFakeHome"
	sudo -n mount -t ramfs ramfs "$actualFakeHome"
	sudo -n chown "$USER":"$USER" "$actualFakeHome"
	! mountpoint "$actualFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_umountRAM_fakeHome() {
	mkdir -p "$actualFakeHome"
	sudo -n umount "$actualFakeHome"
	mountpoint "$actualFakeHome" > /dev/null 2>&1 && _stop 1
	return 0
}

_begin_fakeHome() {
	#Recursive fakeHome prohibited. Instead, start new script session, with new sessionid, and keepFakeHome=false. Do not workaround without a clear understanding why this may endanger your application.
	[[ "$setFakeHome" == "true" ]] && return 1
	#_resetFakeHomeEnv_nokeep
	
	[[ "$realHome" == "" ]] && export realHome="$HOME"
	
	export HOME="$actualFakeHome"
	export setFakeHome=true
	
	_prepareFakeHome > /dev/null 2>&1
	
	_install_fakeHome
	
	_makeFakeHome "$realHome" "$actualFakeHome"
	
	export fakeHomeEditLib="false"
	
	export realScriptAbsoluteLocation="$scriptAbsoluteLocation"
	export realScriptAbsoluteFolder="$scriptAbsoluteFolder"
	export realSessionID="$sessionid"
}

#actualFakeHome
	#default: "$instancedFakeHome"
	#"$globalFakeHome" || "$instancedFakeHome" || "$shortFakeHome" || "$arbitraryFakeHome"/arbitrary
#keepFakeHome
	#default: true
	#"true" || "false"
_fakeHome() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" sessionid="$sessionid" scriptAbsoluteFolder="$scriptAbsoluteFolder" realSessionID="$realSessionID" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
	#dbus-run-session "$@"
	#"$@"
	#. "$@"
	fakeHomeExitStatus=$?
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

#Do NOT keep parent session under fakeHome environment. Do NOT regain parent session if "~/.ubcore/.ubcorerc" is imported (typically upon shell launch).
_fakeHome_specific() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}dbus-run-session "$@"
	#dbus-run-session "$@"
	#"$@"
	#. "$@"
	fakeHomeExitStatus=$?
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

#No workarounds, run in current shell.
# WARNING: Not recommended. No production use. Do not launch GUI applications.
_fakeHome_embedded() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
	#dbus-run-session "$@"
	#"$@"
	. "$@"
	fakeHomeExitStatus=$?
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

_fakeHome_() {
	_fakeHome_embedded "$@"
}





_userFakeHome_procedure() {
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_userFakeHome_sequence() {
	_start
	
	_userFakeHome_procedure "$@"
	
	_stop $?
}

_userFakeHome() {
	"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"
}

_editFakeHome_procedure() {
	export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_editFakeHome_sequence() {
	_start
	
	_editFakeHome_procedure "$@"
	
	_stop $?
}

_editFakeHome() {
	"$scriptAbsoluteLocation" _editFakeHome_sequence "$@"
}

_userShortHome_procedure() {
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_userShortHome_sequence() {
	_start
	
	_userShortHome_procedure "$@"
	
	_stop $?
}

_userShortHome() {
	"$scriptAbsoluteLocation" _userShortHome_sequence "$@"
}

_editShortHome_procedure() {
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="true"
	_fakeHome "$@"
}

_editShortHome_sequence() {
	_start
	
	_editShortHome_procedure "$@"
	
	_stop $?
}

# WARNING: Only allows persistent modifications to directories which have been linked by "_link_fakeHome" or similar.
_editShortHome() {
	"$scriptAbsoluteLocation" _editShortHome_sequence "$@"
}

_shortHome() {
	_userShortHome "$@"
}

_memFakeHome_procedure() {
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	
	_mountRAM_fakeHome
	
	local fakeHomeExitStatus
	
	_fakeHome "$@"
	fakeHomeExitStatus=$?
	
	_umountRAM_fakeHome
	
	return "$fakeHomeExitStatus"
}

_memFakeHome_sequence() {
	_start
	
	_memFakeHome_procedure "$@"
	
	_stop $?
}

_memFakeHome() {
	"$scriptAbsoluteLocation" _memFakeHome_sequence "$@"
}

_resetFakeHomeEnv_extra() {
	true
}

_resetFakeHomeEnv_nokeep() {
	! [[ "$setFakeHome" == "true" ]] && return 0
	export setFakeHome="false"
	
	export HOME="$realHome"
	
	#export realHome=""
	
	_resetFakeHomeEnv_extra
}

_resetFakeHomeEnv() {
	#[[ "$keepFakeHome" == "true" ]] && return 0
	[[ "$keepFakeHome" != "false" ]] && return 0
	
	_resetFakeHomeEnv_nokeep
} 

_test_image() {
	_mustGetSudo
	
	_getDep losetup
	#_getDep partprobe
}

_loopImage_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	[[ -e "$scriptLocal"/imagedev ]] && _stop 1
	
	local imagefilename
	#[[ -e "$scriptLocal"/vm-x64.img ]] && imagefilename="$scriptLocal"/vm-x64.img
	[[ -e "$scriptLocal"/vm.img ]] && imagefilename="$scriptLocal"/vm.img
	
	sudo -n losetup -f -P --show "$imagefilename" > "$safeTmp"/imagedev 2> /dev/null || _stop 1
	sudo -n partprobe > /dev/null 2>&1
	
	cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_loopImage() {
	"$scriptAbsoluteLocation" _loopImage_sequence
}

_mountImageFS_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	"$scriptAbsoluteLocation" _checkForMounts "$globalVirtFS" && _stop 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	local imagepart
	#imagepart="$imagedev"p2
	imagepart="$imagedev"p1
	
	local loopdevfs
	loopdevfs=$(eval $(sudo -n blkid "$imagepart" | awk ' { print $3 } '); echo $TYPE)
	
	! [[ "$loopdevfs" == "ext4" ]] && _stop 1
	
	sudo -n mount "$imagepart" "$globalVirtFS" || _stop 1
	
	mountpoint "$globalVirtFS" > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_mountImageFS() {
	"$scriptAbsoluteLocation" _mountImageFS_sequence
}

_mountImage() {
	"$scriptAbsoluteLocation" _loopImage_sequence 
	"$scriptAbsoluteLocation" _mountImageFS_sequence
}

_umountLoop() {
	_mustGetSudo || return 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n losetup -d "$imagedev" > /dev/null 2>&1 || return 1
	sudo -n partprobe > /dev/null 2>&1
	
	rm -f "$scriptLocal"/imagedev || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
	return 0
}

# TODO Duplicates some code from _umountLoop. Test, and remove.
_umountImage() {
	_mustGetSudo || return 1
	
	sudo -n umount "$globalVirtFS" > /dev/null 2>&1
	
	#Uniquely, it is desirable to allow unmounting to proceed a little further if the filesystem was not mounted to begin with. Enables manual intervention.
	_readyImage "$globalVirtFS" && return 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n losetup -d "$imagedev" > /dev/null 2>&1 || return 1
	sudo -n partprobe > /dev/null 2>&1
	
	rm -f "$scriptLocal"/imagedev || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
	return 0
}

_waitLoop_opening() {
	[[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.1
	[[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.3
	for iteration in `seq 1 45`;
	do
		[[ -e "$scriptLocal"/imagedev ]] && return 0
		sleep 1
	done
	
	return 1
}

_waitImage_opening() {
	_readyImage "$globalVirtFS" && return 0
	sleep 1
	_readyImage "$globalVirtFS" && return 0
	sleep 3
	_readyImage "$globalVirtFS" && return 0
	sleep 9
	_readyImage "$globalVirtFS" && return 0
	sleep 27
	_readyImage "$globalVirtFS" && return 0
	sleep 81
	_readyImage "$globalVirtFS" && return 0
	
	return 1
}

_waitLoop_closing() {
	! [[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.1
	! [[ -e "$scriptLocal"/imagedev ]] && return 0
	sleep 0.3
	for iteration in `seq 1 45`;
	do
		! [[ -e "$scriptLocal"/imagedev ]] && return 0
		sleep 1
	done
	
	return 1
}

_waitImage_closing() {
	_readyImage "$globalVirtFS" || return 0
	sleep 1
	_readyImage "$globalVirtFS" || return 0
	sleep 3
	_readyImage "$globalVirtFS" || return 0
	sleep 9
	_readyImage "$globalVirtFS" || return 0
	sleep 27
	_readyImage "$globalVirtFS" || return 0
	sleep 81
	_readyImage "$globalVirtFS" || return 0
	
	return 1
}

_readyImage() {
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	mountpoint "$absolute1" > /dev/null 2>&1 || return 1
	
	return 0
}

_openImage() {
	local returnStatus
	
	export specialLock="$lock_open_image"
	
	_open _waitImage_opening _mountImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_closeImage() {
	local returnStatus
	
	export specialLock="$lock_open_image"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitImage_closing _umountImage
		returnStatus="$?"
		
		export specialLock=""
		
		return "$returnStatus"
	fi
	
	_close _waitImage_closing _umountImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_openLoop() {
	local returnStatus
	
	export specialLock="$lock_loop_image"
	
	_open _waitLoop_opening _loopImage
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_closeLoop() {
	local returnStatus
	
	export specialLock="$lock_loop_image"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitLoop_closing _umountLoop
		returnStatus="$?"
		
		export specialLock=""
		
		return "$returnStatus"
	fi
	
	_close _waitLoop_closing _umountLoop
	returnStatus="$?"
	
	export specialLock=""
	
	return "$returnStatus"
}

_testCreateFS() {
	_mustGetSudo
	
	_getDep mkfs
	_getDep mkfs.ext4
}

_testCreatePartition() {
	_mustGetSudo
	
	_getDep parted
	#_getDep partprobe
}

_createRawImage_sequence() {
	_start
	
	export vmImageFile="$scriptLocal"/vm.img
	
	[[ "$1" != "" ]] && export vmImageFile="$1"
	
	local createRawImageSize
	createRawImageSize=7636
	[[ "$vmSize" != "" ]] && createRawImageSize="$vmSize"
	
	[[ "$vmImageFile" == "" ]] && _stop 1
	[[ -e "$vmImageFile" ]] && _stop 1
	
	dd if=/dev/zero of="$vmImageFile" bs=1M count="$createRawImageSize" > /dev/null 2>&1
	
	_stop
}

_createRawImage() {
	
	"$scriptAbsoluteLocation" _createRawImage_sequence "$@"
	
}

_createPartition() {
	_mustGetSudo
	
	sudo -n parted --script "$scriptLocal"/vm.img mklabel msdos
	sudo -n partprobe > /dev/null 2>&1
	sudo -n parted "$scriptLocal"/vm.img --script -- mkpart primary 0% 100%
	sudo -n partprobe > /dev/null 2>&1
}


_createFS_sequence() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$globalVirtFS"
	
	"$scriptAbsoluteLocation" _checkForMounts "$globalVirtFS" && _stop 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	local imagepart
	#imagepart="$imagedev"p2
	imagepart="$imagedev"p1
	
	local loopdevfs
	loopdevfs=$(eval $(sudo -n blkid "$imagepart" | awk ' { print $3 } '); echo $TYPE)
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	sudo -n mkfs.ext4 "$imagepart" > /dev/null 2>&1 || _stop 1
	
	_stop 0
}

_createFS_shell() {
	"$scriptAbsoluteLocation" _loopImage_sequence || return 1
	"$scriptAbsoluteLocation" _createFS_sequence || return 1
	"$scriptAbsoluteLocation" _umountImage || return 1
	return 0
}

_createFS() {
	local returnCode
	_open true _createFS_shell
	returnCode="$?"
	_close true true
	
	return "$returnCode"
}





_here_bootdisc_statup_xdg() {
cat << 'CZXWXcRMTo8EmM8i4d'
[Desktop Entry]
Comment=
Exec=/media/bootdisc/cmd.sh
GenericName=
Icon=exec
MimeType=
Name=
Path=
StartupNotify=false
Terminal=false
TerminalOptions=
Type=Application
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_rootnix() {
cat << 'CZXWXcRMTo8EmM8i4d'
#!/bin/bash

if [[ "$0" != "/media/bootdisc/rootnix.sh" ]] && [[ -e "/media/bootdisc" ]]
then
	for iteration in `seq 1 25`;
	do
		! /bin/mountpoint /media/bootdisc > /dev/null 2>&1 && ! [[ -e "/media/bootdisc/rootnix.sh" ]] && sleep 6
	done
	sleep 0.1
	/media/bootdisc/rootnix.sh "$@"
	exit
fi

#Equivalent "fstab" entries for reference. Not used due to conflict for mountpoint, as well as lack of standard mounting options in vboxsf driver.
#//10.0.2.4/qemu	/home/user/.pqm cifs	guest,_netdev,uid=user,user,nofail,exec		0 0
#appFolder		/home/user/.pvb	vboxsf	uid=user,_netdev				0 0

_mountGuestShareNIX() {
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && /bin/mount -t vboxsf -o uid=user,_netdev appFolder /home/user/project 2>&1
	! /bin/mountpoint /home/user/Downloads > /dev/null 2>&1 && /bin/mount -t vboxsf -o uid=user,_netdev Downloads /home/user/Downloads 2>&1
	
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && /bin/mount -t cifs -o guest,_netdev,uid=user,user,nofail,exec '//10.0.2.4/qemu' /home/user/project > /dev/null 2>&1
	
}

#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) }

_uid() {
	local uidLength
	[[ -z "$1" ]] && uidLength=18 || uidLength="$1"
	
	cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c "$uidLength"
}

export sessionid=$(_uid)
[[ -d /tmp ]] && export bootTmp=/tmp		#Typical BSD
[[ -d /dev/shm ]] && export bootTmp=/dev/shm	#Typical Linux

echo "rootnix" > "$bootTmp"/"$sessionid".rnx

#/bin/mkdir -p /home/user/.pqm
#/bin/mkdir -p /home/user/.pvb

/bin/mkdir -p /home/user/Downloads
! /bin/mountpoint /home/user/Downloads && /bin/chown user:user /home/user/Downloads

/bin/mkdir -p /home/user/project
! /bin/mountpoint /home/user/project && /bin/chown user:user /home/user/project

! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.1 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.3 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 1 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 3 && _mountGuestShareNIX

for iteration in `seq 1 15`;
do
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 6 && _mountGuestShareNIX
done

! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 9 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 18 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 27 && _mountGuestShareNIX

CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_startupbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
REM CALL A:\uk4uPhB6.bat
REM CALL B:\uk4uPhB6.bat
CALL D:\uk4uPhB6.bat
CALL E:\uk4uPhB6.bat
CALL F:\uk4uPhB6.bat
CALL G:\uk4uPhB6.bat
CALL H:\uk4uPhB6.bat
CALL Y:\shell.bat
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_shellbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
CALL Y:\loader.bat
CALL Y:\application.bat
CZXWXcRMTo8EmM8i4d
}

#No production use.
_here_bootdisc_loaderZbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use z: /delete

:checkMount

net use /USER:guest z: \\VBOXSVR\root ""

ping -n 2 127.0.0.1 > nul
IF NOT EXIST "Z:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderXbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use x: /delete

:checkMount

net use /USER:guest x: \\VBOXSVR\appFolder ""
net use /USER:guest x: \\10.0.2.4\qemu ""

ping -n 2 127.0.0.1 > nul
IF NOT EXIST "X:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_testVirtBootdisc() {
	if ! type mkisofs > /dev/null 2>&1 && ! type genisoimage > /dev/null 2>&1
	then
		echo 'need mkisofs or genisoimage'
		_stop 1
	fi
}

_prepareBootdisc() {
	mkdir -p "$hostToGuestFiles" > /dev/null 2>&1 || return 1
	mkdir -p "$hostToGuestDir" > /dev/null 2>&1 || return 1
	return 0
}

_mkisofs() {
	if type mkisofs > /dev/null 2>&1
	then
		mkisofs "$@"
		return $?
	fi
	
	if type genisoimage > /dev/null 2>&1
	then
		genisoimage "$@"
		return $?
	fi
}

_writeBootdisc() {
	_mkisofs -V "$ubiquitiousBashID" -volset "$ubiquitiousBashID" -sysid "$ubiquitiousBashID" -R -uid 0 -gid 0 -dir-mode 0555 -file-mode 0555 -new-dir-mode 0555 -J -hfs -o "$hostToGuestISO" "$hostToGuestFiles"
}

_setShareMSW_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="X:"
}

#No production use. Not recommended.
_setShareMSW_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedHostProjectDir=/
	export sharedGuestProjectDir="Z:"
}

_setShareMSW() {
	[[ "$flagShareApp" ]] && _setShareMSW_app && return
	[[ "$flagShareApp" ]] && _setShareMSW_root && return
	return 1
}

#Consider using explorer.exe to use file associations within the guest. Overload with ops to force a more specific 'preCommand'.
_preCommand_MSW() {
	echo -e -n 'start /MAX "" "explorer.exe" '
}

_createHTG_MSW() {
	_setShareMSW
	
	export checkBaseDirRemote=""
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	_here_bootdisc_startupbat >> "$hostToGuestFiles"/rootmsw.bat
	
	_preCommand_MSW >> "$hostToGuestFiles"/application.bat
	
	_safeEcho_newline "${processedArgs[@]}" >> "$hostToGuestFiles"/application.bat
	 
	echo ""  >> "$hostToGuestFiles"/application.bat
	
	echo -e -n >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareApp" == "true" ]] && _here_bootdisc_loaderXbat >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareRoot" == "true" ]] && _here_bootdisc_loaderZbat >> "$hostToGuestFiles"/loader.bat
	
	cat "$hostToGuestFiles"/loader.bat >> "$hostToGuestFiles"/uk4uPhB6.bat
	cat "$hostToGuestFiles"/application.bat >> "$hostToGuestFiles"/uk4uPhB6.bat
	
	_here_bootdisc_shellbat >> "$hostToGuestFiles"/shell.bat
	
	#https://www.cyberciti.biz/faq/howto-unix-linux-convert-dos-newlines-cr-lf-unix-text-format/
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/rootmsw.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/application.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/loader.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/shell.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/uk4uPhB6.bat
}

_setShareUNIX_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="/home/user/project"
}

_setShareUNIX_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="/home/user/project"
	export sharedHostProjectDir=/
}

_setShareUNIX() {
	[[ "$flagShareApp" ]] && _setShareUNIX_app && return
	[[ "$flagShareApp" ]] && _setShareUNIX_root && return
	return 1
}

_createHTG_UNIX() {
	_setShareUNIX
	
	export checkBaseDirRemote=""
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	_here_bootdisc_statup_xdg >> "$hostToGuestFiles"/startup.desktop
	
	_here_bootdisc_rootnix >> "$hostToGuestFiles"/rootnix.sh
	
	echo '#!/usr/bin/env bash' >> "$hostToGuestFiles"/cmd.sh
	echo "export localPWD=""$localPWD" >> "$hostToGuestFiles"/cmd.sh
	_safeEcho_newline "/media/bootdisc/ubiquitous_bash.sh _dropBootdisc ${processedArgs[@]}" >> "$hostToGuestFiles"/cmd.sh
}

_commandBootdisc() {
	_prepareBootdisc || return 1
	
	export flagShareRoot="false"
	
	#Rigiorously ensure flags will be set properly.
	[[ "$flagShareRoot" != "true" ]] && export flagShareRoot="false"
	[[ "$flagShareRoot" != "true" ]] && export flagShareApp="true"
	
	#Include ubiquitious_bash itself.
	cp "$scriptAbsoluteLocation" "$hostToGuestFiles"/
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$hostToGuestFiles"/_bin
	
	#Process for MSW.
	_createHTG_MSW "$@"
	
	#Process for UNIX.
	_createHTG_UNIX "$@"
	
	#Ensure permissions are correctly set.
	chmod 0755 "$hostToGuestFiles"/_bin/*
	chmod 0755 "$hostToGuestFiles"/*.sh
	chmod 0755 "$hostToGuestFiles"/*.desktop
	chmod 0755 "$hostToGuestFiles"/*.bat
	#chmod 0755 "$hostToGuestFiles"/*
	
	_writeBootdisc || return 1
}

_dropBootdisc() {
	#Detect MSW/Cygwin architecture.
		#Check for QEMU type shared directory, mount if present.
		#Check for VBox type shared directory, mount if present.
	
	#Detect UNIX architecture.
	if ! uname -a | grep -i cygwin > /dev/null 2>&1
	then
		#Attempt to wait for QEMU or VBox type shared directory.
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.3
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 1
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 3
		
		for iteration in `seq 1 15`;
		do
			! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 6
		done
		
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 9
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 18
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 27
		! mountpoint /home/user/project > /dev/null 2>&1 && sleep 36
	fi
	sleep 0.3
	
	cd "$localPWD"
	
	"$@"
}





# TODO Launch "_fromImage", transfering "/home/user" to archive, then transfering this archive to "/etc/skel" .
_importHomeUser() {
	true
}

_exportHomeUser() {
	true
}

# TODO To be used by "_userChRoot", binding "/home/user", as an alternative to copying "/etc/skel" .
_bindHomeUser() {
	true
}

_unbindHomeUser() {
	true
}


_test_transferimage() {
	_mustGetSudo
	
	_getDep rsync
}

_toImage() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	#_openImage || return 1
	_openChRoot || return 1
	
	#rsync -avx -A -X "$1" "$globalVirtFS"/"$2"
	rsync -avx "$1" "$globalVirtFS"/"$2"
}

_toImageDir() {
	mkdir -p "$globalVirtFS"/"$2"
	_toImage "$1" "$2"
}

_fromImage() {
	#_openImage || return 1
	_openChRoot || return 1
	
	#rsync -avx -A -X "$globalVirtFS""$1" "$2"
	rsync -avx "$globalVirtFS""$1" "$2"
}

_fromImageDir() {
	mkdir -p "$2"
	_fromImage "$1" "$2"
}

_imageToArc() {
	[[ "$globalArcFS" == "" ]] && return 1
	[[ "$globalArcFS" == "/" ]] && return 1
	
	mkdir -p "$globalArcFS" || return 1
	
	_fromImageDir /home/user/. "$globalArcFS"/home/user
	_fromImageDir /etc/skel/. "$globalArcFS"/etc/skel
}

_imageFromArc() {
	[[ "$globalArcFS" == "" ]] && return 1
	[[ "$globalArcFS" == "/" ]] && return 1
	
	mkdir -p "$globalArcFS" || return 1
	
	_toImageDir "$globalArcFS"/home/user/. /home/user
	_toImageDir "$globalArcFS"/etc/skel/. /etc/skel
}

#Example. Translates permissions and copies ".arduino" directory.
_buildFromImage() {
	_mustGetSudo
	
	[[ "$globalBuildDir" == "" ]] && return 1
	[[ "$globalBuildDir" == "/" ]] && return 1
	
	mkdir -p "$globalBuildDir" || return 1
	
	sudo -n "$scriptAbsoluteLocation" _fromImageDir /home/user/.arduino/. "$globalBuildDir"/.arduino
	#sudo -n "$scriptAbsoluteLocation" _fromImageDir /etc/skel/.arduino/. "$globalBuildDir"/.arduino
	
	_safePath "$globalBuildDir"/.arduino && sudo -n chown -R "$USER":"$GROUP" "$globalBuildDir"/.arduino
}

#Example. Translates permissions and copies ".arduino" directory.
_buildToImage() {
	_mustGetSudo
	
	[[ "$globalBuildDir" == "" ]] && return 1
	[[ "$globalBuildDir" == "/" ]] && return 1
	
	mkdir -p "$globalBuildDir" || return 1
	
	sudo -n "$scriptAbsoluteLocation" _toImageDir "$globalBuildDir"/.arduino/. /home/user/.arduino
	sudo -n "$scriptAbsoluteLocation" _toImageDir "$globalBuildDir"/.arduino/. /etc/skel/.arduino
	
	_chroot chown -R user:user /home/user/.arduino
	_chroot chown -R root:root /etc/skel/.arduino
}


_testChRoot() {
	_mustGetSudo
	
	_testGosu || _stop 1
	
	_checkDep gosu-armel
	_checkDep gosu-amd64
	_checkDep gosu-i386
	
	_getDep id
	
	_getDep mount
	_getDep umount
	_getDep mountpoint
	
	_getDep unionfs-fuse
	
}

#Lists all chrooted processes. First parameter is chroot directory. Script might need to run as root.
#Techniques originally released by other authors at http://forums.grsecurity.net/viewtopic.php?f=3&t=1632 .
#"$1" == ChRoot Dir
_listprocChRoot() {
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	PROCS=""
	local currentProcess
	for currentProcess in `ps -o pid -A`; do
		if [ "`readlink /proc/$currentProcess/root`" = "$absolute1" ]; then
			PROCS="$PROCS"" ""$currentProcess"
		fi
	done
	echo "$PROCS"
}

_killprocChRoot() {
	local chrootKillSignal
	chrootKillSignal="$1"
	
	local chrootKillDir
	chrootKillDir="$2"
	
	chrootprocs=$(_listprocChRoot "$chrootKillDir")
	[[ "$chrootprocs" == "" ]] && return 0
	sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	sleep 0.1
	
	chrootprocs=$(_listprocChRoot "$chrootKillDir")
	[[ "$chrootprocs" == "" ]] && return 0
	sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	sleep 0.3
	
	[[ "$EMERGENCYSHUTDOWN" == "true" ]] && return 1
	
	chrootprocs=$(_listprocChRoot "$chrootKillDir")
	[[ "$chrootprocs" == "" ]] && return 0
	sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	sleep 1
	
	chrootprocs=$(_listprocChRoot "$chrootKillDir")
	[[ "$chrootprocs" == "" ]] && return 0
	sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	sleep 3
	
	chrootprocs=$(_listprocChRoot "$chrootKillDir")
	[[ "$chrootprocs" == "" ]] && return 0
	sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	sleep 9
	
	#chrootprocs=$(_listprocChRoot "$chrootKillDir")
	#[[ "$chrootprocs" == "" ]] && return 0
	#sudo -n kill -"$chrootKillSignal" "$chrootprocs" >/dev/null 2>&1
	#sleep 18
}

#End user and diagnostic function, shuts down all processes in a chroot.
_stopChRoot() {
	_mustGetSudo
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	echo "TERMinating all chrooted processes."
	
	_killprocChRoot "TERM" "$absolute1"
	
	echo "KILLing all chrooted processes."
	
	_killprocChRoot "KILL" "$absolute1"
	
	echo "Remaining chrooted processes."
	_listprocChRoot "$absolute1"
	
	echo '-----'
	
}

#"$1" == ChRoot Dir
_mountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	_bindMountManager "/dev" "$absolute1"/dev
	_bindMountManager "/proc" "$absolute1"/proc
	_bindMountManager "/sys" "$absolute1"/sys
	
	_bindMountManager "/dev/pts" "$absolute1"/dev/pts
	
	_bindMountManager "/tmp" "$absolute1"/tmp
	
	#Provide an shm filesystem at /dev/shm.
	sudo -n mount -t tmpfs -o size=4G tmpfs "$absolute1"/dev/shm
	
	#Install ubiquitous_bash itself to chroot.
	sudo -n mkdir -p "$absolute1"/usr/local/bin/
	sudo -n mkdir -p "$absolute1"/usr/local/share/ubcore/bin/
	
	sudo -n cp "$scriptAbsoluteLocation" "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chmod 0755 "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	sudo -n chown root:root "$absolute1"/usr/local/bin/ubiquitous_bash.sh
	
	if [[ -e "$scriptAbsoluteFolder"/lean.sh ]]
	then
		sudo -n cp "$scriptAbsoluteFolder"/lean.sh "$absolute1"/usr/local/bin/lean.sh
		sudo -n chmod 0755 "$absolute1"/usr/local/bin/lean.sh
		sudo -n chown root:root "$absolute1"/usr/local/bin/lean.sh
	fi
	
	sudo -n cp "$scriptBin"/gosu-armel "$absolute1"/usr/local/share/ubcore/bin/gosu-armel
	sudo -n cp "$scriptBin"/gosu-amd64 "$absolute1"/usr/local/share/ubcore/bin/gosu-amd64
	sudo -n cp "$scriptBin"/gosu-i386 "$absolute1"/usr/local/share/ubcore/bin/gosu-i386
	sudo -n chmod 0755 "$absolute1"/usr/local/share/ubcore/bin/*
	sudo -n chown root:root "$absolute1"/usr/local/share/ubcore/bin/*
	
	#Workaround NetworkManager stealing /etc/resolv.conf with broken symlink.
	if ! _chroot test -f /etc/resolv.conf
	then
		sudo -n mv "$absolute1"/etc/resolv.conf "$absolute1"/etc/resolv.conf.bak > /dev/null 2>&1
		sudo -n rm -f "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
	
	if ! grep '8\.8\.8\.8' "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	then
		echo 'nameserver 8.8.8.8' | sudo tee -a "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
	
	if ! grep '2001\:4860\:4860\:\:8888' "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	then
		echo 'nameserver 2001:4860:4860::8888' | sudo tee -a "$absolute1"/etc/resolv.conf > /dev/null 2>&1
	fi
}

#"$1" == ChRoot Dir
_umountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	_wait_umount "$absolute1"/home/"$virtGuestUser"/project >/dev/null 2>&1
	_wait_umount "$absolute1"/home/"$virtGuestUser" >/dev/null 2>&1
	_wait_umount "$absolute1"/root/project >/dev/null 2>&1
	_wait_umount "$absolute1"/root >/dev/null 2>&1
	
	_wait_umount "$absolute1"/dev/shm
	_wait_umount "$absolute1"/dev/pts
	
	_wait_umount "$absolute1"/proc
	_wait_umount "$absolute1"/sys
	
	_wait_umount "$absolute1"/tmp
	
	_wait_umount "$absolute1"/dev
	
	_wait_umount "$absolute1" >/dev/null 2>&1
	
}

_readyChRoot() {
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	#mountpoint "$absolute1" > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev > /dev/null 2>&1 || return 1
	mountpoint "$absolute1"/proc > /dev/null 2>&1 || return 1
	mountpoint "$absolute1"/sys > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev/pts > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/tmp > /dev/null 2>&1 || return 1
	
	mountpoint "$absolute1"/dev/shm > /dev/null 2>&1 || return 1
	
	return 0
	
}

_mountChRoot_image_raspbian() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	if sudo -n losetup -f -P --show "$scriptLocal"/vm-raspbian.img > "$safeTmp"/imagedev 2> /dev/null
	then
		#Preemptively declare device open to prevent potentially dangerous multiple mount attempts.
		#Should now be redundant with use of lock_opening .
		#_createLocked "$lock_open" || _stop 1
		
		sudo -n partprobe > /dev/null 2>&1
		
		cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
		
		local chrootimagedev
		chrootimagedev=$(cat "$safeTmp"/imagedev)
		
		local chrootimagepart
		chrootimagepart="$chrootimagedev"p2
		
		local chrootloopdevfs
		chrootloopdevfs=$(eval $(sudo -n blkid "$chrootimagepart" | awk ' { print $3 } '); echo $TYPE)
		
		if [[ "$chrootloopdevfs" == "ext4" ]]
		then
			
			sudo -n mount "$chrootimagepart" "$chrootDir" || _stop 1
			
			mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
			
			_mountChRoot "$chrootDir"
			
			_readyChRoot "$chrootDir" || _stop 1
			
			sudo -n cp /usr/bin/qemu-arm-static "$chrootDir"/usr/bin/
			sudo -n cp /usr/bin/qemu-armeb-static "$chrootDir"/usr/bin/
			
			sudo -n cp -n "$chrootDir"/etc/ld.so.preload "$chrootDir"/etc/ld.so.preload.orig
			echo | sudo -n tee "$chrootDir"/etc/ld.so.preload > /dev/null 2>&1
			
			_stop 0
		fi
		
	fi
	
	_stop 1
}

_umountChRoot_directory_raspbian() {
	
	_mustGetSudo
	
	mkdir -p "$chrootDir"
	
	sudo -n cp "$chrootDir"/etc/ld.so.preload.orig "$chrootDir"/etc/ld.so.preload
	
}

_mountChRoot_image_x64() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	local chrootvmimage
	[[ -e "$scriptLocal"/vm-x64.img ]] && chrootvmimage="$scriptLocal"/vm-x64.img
	[[ -e "$scriptLocal"/vm.img ]] && chrootvmimage="$scriptLocal"/vm.img
	
	sudo -n losetup -f -P --show "$chrootvmimage" > "$safeTmp"/imagedev 2> /dev/null || _stop 1
	sudo -n partprobe > /dev/null 2>&1
	
	cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
	
	local chrootimagedev
	chrootimagedev=$(cat "$safeTmp"/imagedev)
	
	local chrootimagepart
	#chrootimagepart="$chrootimagedev"p2
	chrootimagepart="$chrootimagedev"p1
	
	local chrootloopdevfs
	chrootloopdevfs=$(eval $(sudo -n blkid "$chrootimagepart" | awk ' { print $3 } '); echo $TYPE)
	
	! [[ "$chrootloopdevfs" == "ext4" ]] && _stop 1
	
	sudo -n mount "$chrootimagepart" "$chrootDir" || _stop 1
	
	mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
	
	_mountChRoot "$chrootDir"
	
	_readyChRoot "$chrootDir" || _stop 1
	
	_stop 0
}

_umountChRoot_directory_x64() {
	_mustGetSudo
	
	mkdir -p "$chrootDir"
}

_mountChRoot_image() {
	_tryExecFull _hook_systemd_shutdown_action "_closeChRoot_emergency" "$sessionid"
	
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		"$scriptAbsoluteLocation" _mountChRoot_image_raspbian
		return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm-x64.img ]]
	then
		"$scriptAbsoluteLocation" _mountChRoot_image_x64
		return "$?"
	fi
	
	#Default "vm.img" will be operated on as x64 image.
	"$scriptAbsoluteLocation" _mountChRoot_image_x64
	return "$?"
}

_umountChRoot_directory() {
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_raspbian || return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm-x64.img ]]
	then
		"$scriptAbsoluteLocation" _umountChRoot_directory_x64 || return "$?"
	fi
	
	#Default "vm.img" will be operated on as x64 image.
	"$scriptAbsoluteLocation" _umountChRoot_directory_x64 || return "$?"
	
	_stopChRoot "$1"
	_umountChRoot "$1"
	mountpoint "$1" > /dev/null 2>&1 && sudo -n umount "$1"
	
	"$scriptAbsoluteLocation" _checkForMounts "$1" && return 1
}

_umountChRoot_image() {
	_mustGetSudo || return 1
	
	_umountChRoot_directory "$chrootDir" && return 1
	
	local chrootimagedev
	chrootimagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n losetup -d "$chrootimagedev" > /dev/null 2>&1 || return 1
	sudo -n partprobe > /dev/null 2>&1
	
	rm -f "$scriptLocal"/imagedev || return 1
	
	rm -f "$lock_quicktmp" > /dev/null 2>&1
	
	rm -f "$permaLog"/gsysd.log > /dev/null 2>&1
	
	return 0
}

_waitChRoot_opening() {
	_readyChRoot "$chrootDir" && return 0
	sleep 1
	_readyChRoot "$chrootDir" && return 0
	sleep 3
	_readyChRoot "$chrootDir" && return 0
	sleep 9
	_readyChRoot "$chrootDir" && return 0
	sleep 27
	_readyChRoot "$chrootDir" && return 0
	sleep 81
	_readyChRoot "$chrootDir" && return 0
	
	return 1
}

_waitChRoot_closing() {
	_readyChRoot "$chrootDir" || return 0
	sleep 1
	_readyChRoot "$chrootDir" || return 0
	sleep 3
	_readyChRoot "$chrootDir" || return 0
	sleep 9
	_readyChRoot "$chrootDir" || return 0
	sleep 27
	_readyChRoot "$chrootDir" || return 0
	sleep 81
	_readyChRoot "$chrootDir" || return 0
	
	return 1
}

_openChRoot() {
	export specialLock="$lock_open_chroot"
	_open _waitChRoot_opening _mountChRoot_image
}

_closeChRoot() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	export specialLock="$lock_open_chroot"
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitChRoot_closing _umountChRoot_image
		return
	fi
	
	_close _waitChRoot_closing _umountChRoot_image
}

_haltAllChRoot() {
	find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d -exec "$scriptAbsoluteLocation" _umountChRoot_directory {} \;
	find "$scriptAbsoluteFolder"/v_*/tmp -maxdepth 1 -type d -exec sudo -n umount {} \;
	find "$scriptAbsoluteFolder"/v_*/ -maxdepth 12 -type d | head -n 48 | tac | xargs rmdir
	
	"$scriptAbsoluteLocation" _closeChRoot --force
	
	#Closing file may remain if chroot was not open to begin with. Since haltAllChRoot is usually called for forced/emergency shutdown purposes, clearing the resultant lock file is usually safe.
	rm -f "$lock_closing"
}

#Fast dismount of all ChRoot filesystems/instances and cleanup of lock files. Specifically intended to act on SIGTERM or during system(d) shutdown, when time and disk I/O may be limited.
# TODO Use a tmpfs mount to track reboots (with appropriate BSD/Linux/Solaris checking) in the first place.
#"$1" == sessionid (optional override for cleaning up stale systemd files)
_closeChRoot_emergency() {
	_checkSpecialLocks "$lock_open_chroot"
	
	if [[ -e "$instancedVirtFS" ]]
	then
		_stopChRoot "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_project >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_user_home >> "$logTmp"/usrchrt.log 2>&1
		_umountChRoot_user >> "$logTmp"/usrchrt.log 2>&1
		
		_rm_ubvrtusrChRoot
		
		_stop_virt_instance >> "$logTmp"/usrchrt.log 2>&1
	fi
	
	#Not called by systemd, AND instanced directories still mounted, do not globally halt all. (optional)
	#[[ "$1" == "" ]] && find "$scriptAbsoluteFolder"/v_* -maxdepth 1 -type d > /dev/null && return 0
	
	#Not called by systemd, do not globally halt all.
	[[ "$1" == "" ]] && return 0
	
	! _readLocked "$lock_open" && ! find "$scriptAbsoluteFolder"/v_*/fs -maxdepth 1 -type d && return 0
	_readLocked "$lock_closing" && return 1
	_readLocked "$lock_opening" && return 1
	
	_readLocked "$lock_emergency" && return 0
	_createLocked "$lock_emergency"
	
	_haltAllChRoot
	
	rm -f "$lock_emergency" || return 1
	
	
	local hookSessionid
	hookSessionid="$sessionid"
	[[ "$1" != "" ]] && hookSessionid="$1"
	_tryExecFull _unhook_systemd_shutdown "$hookSessionid"
	
}

#Debugging function.
_removeChRoot() {
	_haltAllChRoot
	
	rm -f "$lock_closing"
	rm -f "$lock_opening"
	rm -f "$lock_instancing"
	
	rm -f "$globalVirtDir"/_ubvrtusr
	
	
}

_chroot() {
	
	[[ ! -e "$chrootDir"/bin/bash ]] && return 1
	
	_mustGetSudo
	
	#cd "$chrootDir"
	
	local chrootExitStatus
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" XSOCK="$XSOCK" XAUTH="$XAUTH" localPWD="$localPWD" hostArch=$(uname -m) virtSharedUser="$virtGuestUser" $(sudo -n which chroot) "$chrootDir" "$@"
	
	chrootExitStatus="$?"
	
	return "$chrootExitStatus"
	
}


_mountChRoot_userAndHome() {
	
	sudo -n mount -t tmpfs -o size=4G,uid="$HOST_USER_ID",gid="$HOST_GROUP_ID" tmpfs "$instancedVirtTmp"
	
	#_bindMountManager "$globalVirtFS" "$instancedVirtFS" || return 1
	
	#_bindMountManager "$instancedVirtTmp" "$instancedVirtHome" || return 1
	
	
	#Remove directories that interfere with union mounting.
	rmdir "$instancedProjectDir"
	rmdir "$instancedVirtHome"
	###rmdir "$instancedVirtHomeRef"
	rmdir "$instancedVirtFS"/home
	rmdir "$instancedVirtFS"/root > /dev/null 2>&1
	
	# TODO Device Mapper snapshot ChRoot instancing alternative. Disadvantage of not allowing the root filesystem to be simultaneously mounted read-write.
	# TODO Develop a function to automatically select whatever unionfs equivalent may be supported by the host.
	#sudo /bin/mount -t unionfs -o dirs="$instancedVirtTmp":"$globalVirtFS"=ro unionfs "$instancedVirtFS"
	sudo -n unionfs-fuse -o cow,allow_other,use_ino,suid,dev "$instancedVirtTmp"=RW:"$globalVirtFS"=RO "$instancedVirtFS"
	#sudo unionfs -o dirs="$instancedVirtTmp":"$globalVirtFS"=ro "$instancedVirtFS"
	sudo -n chown "$USER":"$USER" "$instancedVirtFS"
	
	#unionfs-fuse -o cow,max_files=32768 -o allow_other,use_ino,suid,dev,nonempty /u/host/etc=RW:/u/group/etc=RO:/u/common/etc=RO /u/union/etc
	
	mkdir -p "$instancedProjectDir"
	mkdir -p "$instancedVirtHome"
	###mkdir -p "$instancedVirtHomeRef"
	
	return 0
}

_mountChRoot_project() {
	#if [[ ! -e "$0" ]]
	#then
	#	return 1
	#fi
	
	if [[ "$sharedHostProjectDir" == "" ]]
	then
		return 1
	fi
	
	if [[ "$sharedHostProjectDir" == "/" ]]
	then
		return 1
	fi
	
	#Blacklist.
	[[ "$sharedHostProjectDir" == "/home" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/$USER" ]] && return 1
	[[ "$sharedHostProjectDir" == "/home/$USER/" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "/$USER" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "/$USER/" ]] && return 1
	
	[[ "$sharedHostProjectDir" == "/tmp" ]] && return 1
	[[ "$sharedHostProjectDir" == "/tmp/" ]] && return 1
	
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "$HOME" ]] && return 1
	[[ $(id -u) != 0 ]] && [[ "$sharedHostProjectDir" == "$HOME/" ]] && return 1
	
	#Whitelist.
	local safeToMount=false
	
	local safeScriptAbsoluteFolder="$_getScriptAbsoluteFolder"
	
	[[ "$sharedHostProjectDir" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "$safeScriptAbsoluteFolder"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "/home/$USER"* ]] && safeToMount="true"
	[[ "$sharedHostProjectDir" == "/root"* ]] && safeToMount="true"
	
	[[ "$sharedHostProjectDir" == "/tmp/"* ]] && safeToMount="true"
	
	[[ "$safeToMount" == "false" ]] && return 1
	
	#Safeguards/
	#[[ -d "$sharedHostProjectDir" ]] && find "$sharedHostProjectDir" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	_checkDep basename
	
	sudo -n unionfs-fuse -o allow_other,use_ino,suid,dev "$sharedHostProjectDir"=RW "$instancedProjectDir"
	sudo -n chown "$USER":"$USER" "$instancedProjectDir"
	
	#_bindMountManager "$sharedHostProjectDir" "$instancedProjectDir" || return 1
	
}

_umountChRoot_project() {
	
	_wait_umount "$instancedProjectDir"
	
}

_mountChRoot_userDirs() {
	mkdir -p "$HOME"/Downloads
	sudo -n mkdir -p "$instancedDownloadsDir"
	sudo -n unionfs-fuse -o allow_other,use_ino,suid,dev "$HOME"/Downloads=RW "$instancedDownloadsDir"
	sudo -n chown "$USER":"$USER" "$instancedDownloadsDir"
	
}

_umountChRoot_userDirs() {
	_wait_umount "$instancedDownloadsDir"
	sudo -n rmdir "$instancedDownloadsDir"
	
}

#No production use. Already supported by bind mount of full "/tmp". Kept for reference only.
_mountChRoot_X11() {
	_bindMountManager "$XSOCK" "$instancedVirtFS"/"$XSOCK"
	_bindMountManager "$XSOCK" "$instancedVirtFS"/"$XAUTH"
}

#No production use. Already supported by bind mount of full "/tmp". Kept for reference only.
_umountChRoot_X11() {
	_wait_umount "$instancedVirtFS"/"$XSOCK"
	_wait_umount "$instancedVirtFS"/"$XAUTH"
}


_umountChRoot_user() {
	
	mountpoint "$instancedVirtFS" > /dev/null 2>&1 || return 1
	#_umountChRoot "$instancedVirtFS"
	_wait_umount "$instancedVirtFS"
	
}

_umountChRoot_user_home() {
	
	_wait_umount "$instancedVirtHome" || return 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && return 1
	
	return 0
	
}

_checkBaseDirRemote_chroot() {
	
	[[ -e "$chrootDir"/"$1" ]] || return 1
	return 0
	
}



_rm_ubvrtusrChRoot() {
	
	sudo -n rmdir "$sharedGuestProjectDir" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome"/"$virtGuestUser"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome"/"$virtGuestUser" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHome" > /dev/null 2>&1
	###sudo -n rmdir "$instancedVirtHomeRef"/project > /dev/null 2>&1
	###sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser"/project > /dev/null 2>&1
	###sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser" > /dev/null 2>&1
	###sudo -n rmdir "$instancedVirtHomeRef" > /dev/null 2>&1
	
}



_ubvrtusrChRoot_report_failure() {
	
	echo -n "ubvrtusr     ""$1"
	echo -e -n '\t'
	shift
	
	echo -n "$1"
	echo -e -n '\t'
	shift
	
	shift
	echo "$@"
	
	return 0
	
}

_ubvrtusrChRoot_check() {
	#Diagnostics.
	echo '#####ubvrtusr     checks'
	
	local internalFailure
	internalFailure=false
	
	###! [[ -e "$globalVirtFS"/"$virtGuestHomeRef" ]] && _ubvrtusrChRoot_report_failure "nohome" "$virtGuestHomeRef" '[[ -e "$virtGuestHomeRef" ]]' && internalFailure=true
	
	! _chroot id -u "$virtGuestUser" > /dev/null 2>&1 && _ubvrtusrChRoot_report_failure "no guest user" "$virtGuestUser" '_chroot id -u "$virtGuestUser"' && internalFailure=true
	
	! [[ $(_chroot id -u "$virtGuestUser") == "$HOST_USER_ID" ]] && _ubvrtusrChRoot_report_failure "bad uid" $(_chroot id -u "$virtGuestUser") '[[ $(_chroot id -u "$virtGuestUser") == "$HOST_USER_ID" ]]' && internalFailure=true
	
	! [[ $(_chroot id -g "$virtGuestUser") == "$HOST_GROUP_ID" ]] && _ubvrtusrChRoot_report_failure "bad gid" $(_chroot id -g "$virtGuestUser") '[[ $(_chroot id -g "$virtGuestUser") == "$HOST_GROUP_ID" ]]' && internalFailure=true
	
	echo '#####ubvrtusr     checks'
	
	 [[ "$internalFailure" == "true" ]] && return 1
	 return 0
}

_ubvrtusrChRoot() {
	
	#If root, discontinue.
	[[ $(id -u) == 0 ]] && return 0
	
	#If user correctly setup, discontinue. Check multiple times before recreating user.
	local iterationCount
	iterationCount=0
	while [[ "$iterationCount" -lt "3" ]]
	do
		_ubvrtusrChRoot_check && return 0
		
		let iterationCount="$iterationCount"+1
		sleep 0.3
	done
	
	## Lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	_waitFile "$globalVirtDir"/_ubvrtusr || return 1
	echo > "$globalVirtDir"/quicktmp
	mv -n "$globalVirtDir"/quicktmp "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	_chroot userdel -r "$virtGuestUser"
	_rm_ubvrtusrChRoot
	
	_chroot groupadd -g "$HOST_GROUP_ID" -o "$virtGuestUser"
	_chroot useradd --shell /bin/bash -u "$HOST_USER_ID" -g "$HOST_GROUP_ID" -o -c "" -m "$virtGuestUser" || return 1
	
	_chroot usermod -a -G video "$virtGuestUser" > /dev/null 2>&1 || return 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHome" > /dev/null 2>&1
	
	sudo -n mkdir -p "$globalVirtFS""$virtGuestHome"
	###sudo -n mkdir -p "$globalVirtFS""$virtGuestHomeRef"
	###sudo -n cp -a "$globalVirtFS""$virtGuestHome"/. "$globalVirtFS""$virtGuestHomeRef"/
	###echo sudo -n cp -a "$globalVirtFS""$virtGuestHome"/. "$globalVirtFS""$virtGuestHomeRef"/
	###_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHomeRef" > /dev/null 2>&1
	
	rm -f "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	return 0
}

_userChRoot() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_start
	_start_virt_all
	export chrootDir="$globalVirtFS"
	
	_mustGetSudo || _stop 1
	
	
	_checkDep mountpoint >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	mountpoint "$instancedVirtDir" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtFS" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtTmp" > /dev/null 2>&1 && _stop 1
	mountpoint "$instancedVirtHome" > /dev/null 2>&1 && _stop 1
	
	"$scriptAbsoluteLocation" _openChRoot >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_tryExecFull _hook_systemd_shutdown_action "_closeChRoot_emergency" "$sessionid"
	
	
	_ubvrtusrChRoot  >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_mountChRoot_userAndHome >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	###[[ $(id -u) != 0 ]] && cp -a "$instancedVirtHomeRef"/. "$instancedVirtHome"/ >> "$logTmp"/usrchrt.log 2>&1
	export chrootDir="$instancedVirtFS"
	
	
	export checkBaseDirRemote=_checkBaseDirRemote_chroot
	_virtUser "$@" >> "$logTmp"/usrchrt.log 2>&1
	
	#_mountChRoot_X11
	
	_mountChRoot_project >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$sharedGuestProjectDir" >> "$logTmp"/usrchrt.log 2>&1
	
	#####
	_mountChRoot_userDirs
	
	
	
	_chroot /bin/bash /usr/local/bin/ubiquitous_bash.sh _dropChRoot "${processedArgs[@]}"
	local userChRootExitStatus="$?"
	
	_stopChRoot "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1
	
	
	
	
	_umountChRoot_userDirs
	#####
	
	#_umountChRoot_X11
	
	_umountChRoot_project >> "$logTmp"/usrchrt.log 2>&1
	_umountChRoot_user_home >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_umountChRoot_user >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_rm_ubvrtusrChRoot
	
	"$scriptAbsoluteLocation" _checkForMounts "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1 && _stop 1
	
	_stop_virt_instance >> "$logTmp"/usrchrt.log 2>&1
	_stop "$userChRootExitStatus"
}

_removeUserChRoot_sequence() {
	## Lock file. Not done with _waitFileCommands because there is nither an obvious means, nor an obviously catastrophically critical requirement, to independently check for completion of related useradd/mod/del operations.
	_waitFile "$globalVirtDir"/_ubvrtusr || return 1
	echo > "$globalVirtDir"/quicktmp
	mv -n "$globalVirtDir"/quicktmp "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
	
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	###[[ -d "$chrootDir""$virtGuestHomeRef" ]] && sudo -n "$scriptAbsoluteLocation" _safeRMR "$chrootDir""$virtGuestHomeRef"
	
	_rm_ubvrtusrChRoot
	
	rm -f "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || return 1
}

_removeUserChRoot() {
	"$scriptAbsoluteLocation" _openChRoot || return 1
	
	_removeUserChRoot_sequence
	
	"$scriptAbsoluteLocation" _closeChRoot || return 1
} 

_dropChRoot() {
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	"$scriptAbsoluteLocation" _gosuExecVirt cp -r /etc/skel/. "$virtGuestHomeDrop"
	
	"$scriptAbsoluteLocation" _gosuExecVirt "$scriptAbsoluteLocation" _setupUbiquitous_nonet
	
	# Drop to user ubvrtusr, using gosu.
	_gosuExecVirt "$@"
}

#No production use. Kept for reference only.
###_prepareChRootUser() {
	
	#_gosuExecVirt cp -r /etc/skel/. /home/
	
	#cp -a /home/"$virtGuestUser".ref/. /home/"$virtGuestUser"/
	#chown "$virtGuestUser":"$virtGuestUser" /home/"$virtGuestUser"
	
	###true
	
###}


#Ensures dependencies are met for raspi-on-raspi virtualization.
_testQEMU_raspi-raspi() {
	true
}

_testQEMU_hostArch_x64-raspi() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 1
	fi
	
	return 0
}

_testQEMU_x64-raspi() {
	
	_testQEMU_x64-x64
	_getDep qemu-arm-static
	_getDep qemu-armeb-static
	
	_mustGetSudo
	
	! _testQEMU_hostArch_x64-raspi && echo "warn: not checking x64 translation" && return 0
	
	if ! sudo -n /usr/sbin/update-binfmts --display | grep qemu > /dev/null 2>&1
	then
		echo 'binfmts does not mention qemu-arm'
		_stop 1
	fi
	
	if ! sudo -n /usr/sbin/update-binfmts --display | grep qemu-armeb-static > /dev/null 2>&1
	then
		echo 'binfmts does not mention qemu-armeb'
		_stop 1
	fi
}



_testQEMU_hostArch_x64_hardwarevt() {
	#[[ -e /dev/kvm ]] && (grep -i svm /proc/cpuinfo > /dev/null 2>&1 || grep -i vmx /proc/cpuinfo > /dev/null 2>&1)
	
	! [[ -e /dev/kvm ]] && return 1
	
	grep -i svm /proc/cpuinfo > /dev/null 2>&1 && return 0
	grep -i vmx /proc/cpuinfo > /dev/null 2>&1 && return 0
	
	return 1
}

_testQEMU_hostArch_x64_nested() {
	grep '1' /sys/module/kvm_amd/parameters/nested > /dev/null 2>&1 && return 0
	grep 'Y' /sys/module/kvm_amd/parameters/nested > /dev/null 2>&1 && return 0
	grep '1' /sys/module/kvm_intel/parameters/nested > /dev/null 2>&1 && return 0
	grep 'Y' /sys/module/kvm_intel/parameters/nested > /dev/null 2>&1 && return 0
	
	return 1
}

_testQEMU_hostArch_x64-x64() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 1
	fi
	
	return 0
}

_testQEMU_x64-x64() {
	_testQEMU_hostArch_x64-x64 || echo "warn: no native x64"
	_testQEMU_hostArch_x64_hardwarevt || echo "warn: no x64 vt"
	_testQEMU_hostArch_x64_nested || echo "warn: no nested x64"
	
	_getDep qemu-system-x86_64
	_getDep qemu-img
	
	_getDep smbd
}

_qemu-system() {
	qemu-system-x86_64 "$@"
}

#Overload this function, or the guestArch variable, to configure QEMU to  guest with a specif
_qemu() {
	local qemuHostArch
	qemuHostArch=$(uname -m)
	[[ "$qemuHostArch" == "" ]] && qemuGuestArch="$qemuHostArch"
	 _messagePlain_probe 'qemuGuestArch= '"$qemuGuestArch"
	
	local qemuExitStatus
	
	[[ "$qemuHostArch" == "x86_64" ]] && _messagePlain_probe '>qemu= qemu-system-x86_64' && qemu-system-x86_64 "$@"
	qemuExitStatus="$?"
	
	
	return "$qemuExitStatus"
}

_integratedQemu() {
	_messagePlain_nominal 'init: _integratedQemu'
	
	! mkdir -p "$instancedVirtDir" && _messagePlain_bad 'fail: mkdir -p instancedVirtDir= '"$instancedVirtDir" && _stop 1
	
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	
	if _testQEMU_hostArch_x64_nested
	then
		_messagePlain_good 'supported: nested x64'
		qemuArgs+=(-cpu host)
	else
		_messagePlain_warn 'warn: no nested x64'
	fi
	
	local hostThreadCount=$(cat /proc/cpuinfo | grep MHz | wc -l)
	[[ "$hostThreadCount" -ge "4" ]] && [[ "$hostThreadCount" -lt "8" ]] && _messagePlain_probe 'cpu: >4' && qemuArgs+=(-smp 4)
	[[ "$hostThreadCount" -ge "8" ]] && _messagePlain_probe 'cpu: >6' && qemuArgs+=(-smp 6)
	
	qemuUserArgs+=(-drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c)
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	qemuUserArgs+=(-m "$vmMemoryAllocation")
	
	[[ "$qemuUserArgs_netRestrict" == "" ]] && qemuUserArgs_netRestrict="n"
	
	qemuUserArgs+=(-net nic,model=rtl8139 -net user,restrict="$qemuUserArgs_netRestrict",smb="$sharedHostProjectDir")
	
	qemuArgs+=(-usbdevice tablet)
	
	qemuArgs+=(-vga cirrus)
	
	[[ "$qemuArgs_audio" == "" ]] && qemuArgs+=(-device ich9-intel-hda -device hda-duplex)
	
	qemuArgs+=(-show-cursor)
	
	if _testQEMU_hostArch_x64_hardwarevt
	then
		_messagePlain_good 'found: kvm'
		qemuArgs+=(-machine accel=kvm)
	else
		_messagePlain_warn 'missing: kvm'
	fi
	
	qemuArgs+=("${qemuSpecialArgs[@]}" "${qemuUserArgs[@]}")
	
	_messagePlain_probe _qemu "${qemuArgs[@]}"
	_qemu "${qemuArgs[@]}"
	
	_safeRMR "$instancedVirtDir" || _stop 1
}

#"${qemuSpecialArgs[@]}" == ["-snapshot "]
_userQemu_sequence() {
	unset qemuSpecialArgs
	
	qemuSpecialArgs+=("-snapshot")
	
	export qemuSpecialArgs
	
	_start
	
	_integratedQemu "$@" || _stop 1
	
	_stop
}

_userQemu() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	"$scriptAbsoluteLocation" _userQemu_sequence "$@"
}

_editQemu_sequence() {
	unset qemuSpecialArgs
	
	export qemuSpecialArgs
	
	_start
	
	#_messageNormal "Checking lock."
	#_readLocked "$scriptLocal"/_qemuEdit && _messageError 'lock: _qemuEdit' && _stop 1
	#! _createLocked "$scriptLocal"/_qemuEdit  && _messageError 'lock: _qemuEdit' && _stop 1
	
	_messageNormal "Checking lock and conflicts."
	export specialLock="$lock_open_qemu"
	! _open true true && _messageError 'FAIL' && _stop 1
	
	_messageNormal "Launch: _integratedQemu."
	! _integratedQemu "$@" && _messageError 'FAIL' && _stop 1
	
	rm -f "$scriptLocal"/_qemuEdit > /dev/null 2>&1
	export specialLock="$lock_open_qemu"
	! _close true true && _messageError 'FAIL' && _stop 1
	
	_stop
}

_editQemu() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	"$scriptAbsoluteLocation" _editQemu_sequence "$@"
}

_testVBox() {
	_getDep VirtualBox
	_getDep VBoxSDL
	_getDep VBoxManage
	_getDep VBoxHeadless
	
	#sudo -n checkDep dkms
	
	! _noFireJail virtualbox && _stop 1
}


_checkVBox_raw() {
	#Use existing VDI image if available.
	[[ -e "$scriptLocal"/vm.vdi ]] && _messagePlain_bad 'conflict: vm.vdi' && return 1
	[[ ! -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'missing: vm.img' && return 1
	
	return 0
}

# WARNING
# Per VirtualBox developers, "This is a development tool and shall only be used to analyse problems. It is completely unsupported and will change in incompatible ways without warning."
# If that happens, this function will be revised quickly, possibly to the point of generating the VMDK file itself with a here document instead of VirtualBox commands. See "_diag/data/vmdkRawExample".
_create_vbox_raw() {
	if ! VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" > "$vboxRaw".log
	then
		_messagePlain_bad 'fail: 'VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" '>' "$vboxRaw".log
	fi
	return 0
}


_mountVBox_raw_sequence() {
	_messagePlain_nominal 'start: _mountVBox_raw_sequence'
	_start
	
	_checkVBox_raw || _stop 1
	
	! _wantSudo && _messagePlain_bad 'bad: sudo' && return 1
	
	_prepare_instance_vbox
	
	rm -f "$vboxRaw" > /dev/null 2>&1
	
	_messagePlain_nominal 'Creating loopback.'
	! sudo -n losetup -f -P --show "$scriptLocal"/vm.img > "$safeTmp"/vboxloop 2> /dev/null && _messagePlain_bad 'fail: losetup' && _stop 1
	
	! cp -n "$safeTmp"/vboxloop "$scriptLocal"/vboxloop > /dev/null 2>&1 && _messagePlain_bad 'fail: copy vboxloop' && _stop 1
	
	local vboximagedev
	vboximagedev=$(cat "$safeTmp"/vboxloop)
	
	if _tryExecFull _hook_systemd_shutdown_action "_closeVBoxRaw" "$sessionid"
	then
		_messagePlain_good 'pass: _hook_systemd_shutdown_action'
	else
		_messagePlain_bad 'fail: _hook_systemd_shutdown_action'
	fi
	
	! sudo -n chown "$USER" "$vboximagedev" && _messagePlain_bad 'chown vboximagedev= '"$vboximagedev" && _stop 1
	
	_messagePlain_nominal 'Creating VBoxRaw.'
	_create_vbox_raw "$vboximagedev"
	
	_messagePlain_nominal 'stop: _mountVBox_raw_sequence'
	_safeRMR "$instancedVirtDir" || _stop 1
	_stop 0
}

_mountVBox_raw() {
	"$scriptAbsoluteLocation" _mountVBox_raw_sequence
	return "$?"
}

_waitVBox_opening() {
	! [[ -e "$vboxRaw" ]] && return 1
	! [[ -e "$scriptLocal"/vboxloop ]] && return 1
	
	local vboximagedev=$(cat "$safeTmp"/vboxloop)
	! [[ -e "$vboximagedev" ]] && return 1
}

_umountVBox_raw() {
	local vboximagedev
	vboximagedev=$(cat "$scriptLocal"/vboxloop)
	
	sudo -n losetup -d "$vboximagedev" > /dev/null 2>&1 || return 1
	
	rm -f "$scriptLocal"/vboxloop > /dev/null 2>&1
	rm -f "$vboxRaw" > /dev/null 2>&1
	rm -f "$vboxRaw".log > /dev/null 2>&1
	
	return 0
}

_waitVBox_closing() {
	true
}

_openVBoxRaw() {
	export specialLock="$lock_open_vbox"
	
	_checkVBox_raw || _stop 1
	
	_messagePlain_nominal 'launch: _open _waitVBox_opening _mountVBox_raw'
	
	local openVBoxRaw_exitStatus
	_open _waitVBox_opening _mountVBox_raw
	openVBoxRaw_exitStatus="$?"
	
	export specialLock=""
	
	return "$openVBoxRaw_exitStatus"
}

_closeVBoxRaw() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	export specialLock="$lock_open_vbox"
	
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitVBox_closing _umountVBox_raw
		[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
		export specialLock=""
		return 0
	fi
	
	_close _waitVBox_closing _umountVBox_raw
	[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
	export specialLock=""
	return 0
}

##VBox Boxing
_wait_lab_vbox() {
	_prepare_lab_vbox || return 1
	
	VBoxXPCOMIPCD_PID=$(cat "$VBoxXPCOMIPCD_PIDfile" 2> /dev/null)
	#echo -e '\E[1;32;46mWaiting for VBoxXPCOMIPCD to finish... \E[0m'
	while kill -0 "$VBoxXPCOMIPCD_PID" > /dev/null 2>&1
	do
		sleep 0.2
	done
}

#Not routine.
_remove_lab_vbox() {
	_prepare_lab_vbox || return 1
	
	_wait_lab_vbox
	
	#echo -e '\E[1;32;46mRemoving IPC folder and vBoxHome directory symlink from filesystem.\E[0m'
	
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -f "$VBOX_USER_HOME_short" > /dev/null 2>&1
}


_launch_lab_vbox_sequence() {
	_start
	
	_prepare_lab_vbox || return 1
	
	#Directly opening raw images in the VBoxLab environment is not recommended, due to changing VMDK disk identifiers.
	#Better practice may be to instead programmatically construct the raw image virtual machines before opening VBoxLab environment.
	#_openVBoxRaw
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox "$@"
	
	_wait_lab_vbox
	
	_stop
}

_launch_lab_vbox() {	
	"$scriptAbsoluteLocation" _launch_lab_vbox_sequence "$@"
}

_labVBox() {
	_launch_lab_vbox "$@"
}

_vboxlabSSH() {
	ssh -q -F "$scriptLocal"/vblssh -i "$scriptLocal"/id_rsa "$1"
}

_prepare_instance_vbox() {
	_prepare_vbox "$instancedVirtDir"
}

_wait_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	VBoxXPCOMIPCD_PID=$(cat "$VBoxXPCOMIPCD_PIDfile" 2> /dev/null)
	#echo -e '\E[1;32;46mWaiting for VBoxXPCOMIPCD to finish... \E[0m'
	while kill -0 "$VBoxXPCOMIPCD_PID" > /dev/null 2>&1
	do
		sleep 0.2
	done
}

_rm_instance_vbox() {
	_prepare_instance_vbox || return 1
	
	#Usually unnecessary, possibly destructive, may delete VM images.
	#VBoxManage unregistervm "$sessionid" --delete > /dev/null 2>&1
	
	_safeRMR "$instancedVirtDir" || return 1
	
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/ipcd > /dev/null 2>&1
	rm -f /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc/lock > /dev/null 2>&1
	rmdir /tmp/\.vbox-"$VBOX_IPC_SOCKETID"-ipc > /dev/null 2>&1
	
	rm -f "$VBOX_USER_HOME_short" > /dev/null 2>&1
	
	#_closeVBoxRaw || return 1
	
	return 0
}

#Not routine.
_remove_instance_vbox() {
	_prepare_instance_vbox || return 1
}

_vboxGUI() {
	#VirtualBox "$@"
	VBoxSDL "$@"
}


_set_instance_vbox_type() {
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Debian_64
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Gentoo
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=Windows2003
	#[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	[[ "$vboxOStype" == "" ]] && _readLocked "$lock_open" && export vboxOStype=Debian_64
	[[ "$vboxOStype" == "" ]] && export vboxOStype=WindowsXP
	
	_messagePlain_probe 'vboxOStype= '"$vboxOStype"
	
	if VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	then
		_messagePlain_probe VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
		return 0
	fi
	_messagePlain_bad 'fail: 'VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
	return 1
}

_set_instance_vbox_features() {
	#VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 1512 --nic1 nat --nictype1 "82543GC" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 1 --ioapic off --acpi on --pae off --chipset piix3
	
	[[ "$vboxNic" == "" ]] && vboxNic="nat"
	_messagePlain_probe 'vboxNic= '"$vboxNic"
	
	local vboxChipset
	vboxChipset="ich9"
	#[[ "$vboxOStype" == *"Win"*"XP"* ]] && vboxChipset="piix3"
	_messagePlain_probe 'vboxChipset= '"$vboxChipset"
	
	local vboxNictype
	vboxNictype="82543GC"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxNictype="82540EM"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxNictype="82540EM"
	_messagePlain_probe 'vboxNictype= '"$vboxNictype"
	
	local vboxAudioController
	vboxAudioController="ac97"
	[[ "$vboxOStype" == *"Win"*"7"* ]] && vboxAudioController="hda"
	[[ "$vboxOStype" == *"Win"*"10"* ]] && vboxAudioController="hda"
	_messagePlain_probe 'vboxAudioController= '"$vboxAudioController"
	
	[[ "$vmMemoryAllocation" == "" ]] && vmMemoryAllocation="$vmMemoryAllocationDefault"
	_messagePlain_probe 'vmMemoryAllocation= '"$vmMemoryAllocation"
	
	_messagePlain_nominal "Setting VBox VM features."
	if ! VBoxManage modifyvm "$sessionid" --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 1 --vram 128 --memory "$vmMemoryAllocation" --nic1 "$vboxNic" --nictype1 "$vboxNictype" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 4 --ioapic on --acpi on --pae on --chipset "$vboxChipset" --audiocontroller="$vboxAudioController"
	then
		_messagePlain_probe VBoxManage modifyvm "$sessionid" --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 1 --vram 128 --memory "$vmMemoryAllocation" --nic1 "$vboxNic" --nictype1 "$vboxNictype" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 4 --ioapic on --acpi on --pae on --chipset "$vboxChipset" --audiocontroller="$vboxAudioController"
		_messagePlain_bad 'fail: VBoxManage'
		return 1
	fi
	return 0
	
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/"
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir"
		
		! VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir" && _messagePlain_warn 'fail: mount sharedHostProjectDir= '"$sharedHostProjectDir"
	fi
	
	if [[ -e "$HOME"/Downloads ]]
	then
		_messagePlain_probe VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads
		
		! VBoxManage sharedfolder add "$sessionid" --name "Downloads" --hostpath "$HOME"/Downloads && _messagePlain_warn 'fail: mount (shared) Downloads= '"$HOME"/Downloads
	fi
}

_set_instance_vbox_command() {
	_messagePlain_nominal 'Creating BootDisc.'
	! _commandBootdisc "$@" && _messagePlain_bad 'fail: _commandBootdisc' && return 1
	return 0
}

_create_instance_vbox() {
	
	#Use existing VDI image if available.
	if ! [[ -e "$scriptLocal"/vm.vdi ]]
	then
		_messagePlain_nominal 'Missing VDI. Attempting to create from IMG.'
		! _openVBoxRaw && _messageError 'FAIL' && return 1
	fi
	
	_messagePlain_nominal 'Checking VDI file.'
	export vboxInstanceDiskImage="$scriptLocal"/vm.vdi
	_readLocked "$lock_open" && vboxInstanceDiskImage="$vboxRaw"
	! [[ -e "$vboxInstanceDiskImage" ]] && _messagePlain_bad 'missing: vboxInstanceDiskImage= '"$vboxInstanceDiskImage" && return 1
	
	_messagePlain_nominal 'Determining OS type.'
	_set_instance_vbox_type
	
	! _set_instance_vbox_features && _messageError 'FAIL' && return 1
	
	_set_instance_vbox_command "$@"
	
	_messagePlain_nominal 'Mounting shared filesystems.'
	_set_instance_vbox_share
	
	_messagePlain_nominal 'Attaching local filesystems.'
	! VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4 && _messagePlain_bad 'fail: VBoxManage... attach ide controller'
	
	#export vboxDiskMtype="normal"
	[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="multiattach"
	_messagePlain_probe 'vboxDiskMtype= '"$vboxDiskMtype"
	
	_messagePlain_probe VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype"
	! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype" && _messagePlain_bad 'fail: VBoxManage... attach vboxInstanceDiskImage= '"$vboxInstanceDiskImage"
	
	[[ -e "$hostToGuestISO" ]] && ! VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO" && _messagePlain_bad 'fail: VBoxManage... attach hostToGuestISO= '"$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	! VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegration,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth" && _messagePlain_warn 'fail: VBoxManage... suppress messages'
	
	
	
	return 0
}

#Create and launch temporary VM around persistent disk image.
_user_instance_vbox_sequence() {
	_messageNormal '_user_instance_vbox_sequence: start'
	_start
	
	_prepare_instance_vbox || _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Checking lock vBox_vdi= '"$vBox_vdi"
	_readLocked "$vBox_vdi" && _messagePlain_bad 'lock: vBox_vdi= '"$vBox_vdi" && _stop 1
	
	_messageNormal '_user_instance_vbox_sequence: Creating instance. '"$sessionid"
	if ! _create_instance_vbox "$@"
	then
		_stop 1
	fi
	
	_messageNormal '_user_instance_vbox_sequence: Launch: _vboxGUI '"$sessionid"
	 _vboxGUI --startvm "$sessionid"
	
	_messageNormal '_user_instance_vbox_sequence: Removing instance. '"$sessionid"
	_rm_instance_vbox
	
	_messageNormal '_user_instance_vbox_sequence: stop'
	_stop
}

_user_instance_vbox() {
	"$scriptAbsoluteLocation" _user_instance_vbox_sequence "$@"
}

_userVBox() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_user_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}

_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	if ! _create_instance_vbox "$@"
	then
		return 1
	fi
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox
	
	_wait_instance_vbox
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type multiattach
	
	rm -f "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
	_stop
}

_edit_instance_vbox() {
	"$scriptAbsoluteLocation" _edit_instance_vbox_sequence "$@"
}

_editVBox() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	_messageNormal 'Begin: '"$@"
	_edit_instance_vbox "$@"
	_messageNormal 'End: '"$@"
}


_here_dosbox_base_conf() {

cat << 'CZXWXcRMTo8EmM8i4d'
# This is the configurationfile for DOSBox 0.74. (Please use the latest version of DOSBox)
# Lines starting with a # are commentlines and are ignored by DOSBox.
# They are used to (briefly) document the effect of each option.

[sdl]
#       fullscreen: Start dosbox directly in fullscreen. (Press ALT-Enter to go back)
#       fulldouble: Use double buffering in fullscreen. It can reduce screen flickering, but it can also result in a slow DOSBox.
#   fullresolution: What resolution to use for fullscreen: original or fixed size (e.g. 1024x768).
#                     Using your monitor's native resolution with aspect=true might give the best results.
#                     If you end up with small window on a large screen, try an output different from surface.
# windowresolution: Scale the window to this size IF the output device supports hardware scaling.
#                     (output=surface does not!)
#           output: What video system to use for output.
#                   Possible values: surface, overlay, opengl, openglnb.
#         autolock: Mouse will automatically lock, if you click on the screen. (Press CTRL-F10 to unlock)
#      sensitivity: Mouse sensitivity.
#      waitonerror: Wait before closing the console if dosbox has an error.
#         priority: Priority levels for dosbox. Second entry behind the comma is for when dosbox is not focused/minimized.
#                     pause is only valid for the second entry.
#                   Possible values: lowest, lower, normal, higher, highest, pause.
#       mapperfile: File used to load/save the key/event mappings from. Resetmapper only works with the defaul value.
#     usescancodes: Avoid usage of symkeys, might not work on all operating systems.

fullscreen=false
fulldouble=false
fullresolution=original
windowresolution=original
output=surface
autolock=true
sensitivity=100
waitonerror=true
priority=higher,normal
mapperfile=mapper-0.74.map
usescancodes=true

[dosbox]
# language: Select another language file.
#  machine: The type of machine tries to emulate.
#           Possible values: hercules, cga, tandy, pcjr, ega, vgaonly, svga_s3, svga_et3000, svga_et4000, svga_paradise, vesa_nolfb, vesa_oldvbe.
# captures: Directory where things like wave, midi, screenshot get captured.
#  memsize: Amount of memory DOSBox has in megabytes.
#             This value is best left at its default to avoid problems with some games,
#             though few games might require a higher value.
#             There is generally no speed advantage when raising this value.

language=
machine=svga_s3
captures=capture
memsize=16

[render]
# frameskip: How many frames DOSBox skips before drawing one.
#    aspect: Do aspect correction, if your output method doesn't support scaling this can slow things down!.
#    scaler: Scaler used to enlarge/enhance low resolution modes.
#              If 'forced' is appended, then the scaler will be used even if the result might not be desired.
#            Possible values: none, normal2x, normal3x, advmame2x, advmame3x, advinterp2x, advinterp3x, hq2x, hq3x, 2xsai, super2xsai, supereagle, tv2x, tv3x, rgb2x, rgb3x, scan2x, scan3x.

frameskip=0
aspect=false
scaler=normal2x

[cpu]
#      core: CPU Core used in emulation. auto will switch to dynamic if available and appropriate.
#            Possible values: auto, dynamic, normal, simple.
#   cputype: CPU Type used in emulation. auto is the fastest choice.
#            Possible values: auto, 386, 386_slow, 486_slow, pentium_slow, 386_prefetch.
#    cycles: Amount of instructions DOSBox tries to emulate each millisecond.
#            Setting this value too high results in sound dropouts and lags.
#            Cycles can be set in 3 ways:
#              'auto'          tries to guess what a game needs.
#                              It usually works, but can fail for certain games.
#              'fixed #number' will set a fixed amount of cycles. This is what you usually need if 'auto' fails.
#                              (Example: fixed 4000).
#              'max'           will allocate as much cycles as your computer is able to handle.
#            
#            Possible values: auto, fixed, max.
#   cycleup: Amount of cycles to decrease/increase with keycombo.(CTRL-F11/CTRL-F12)
# cycledown: Setting it lower than 100 will be a percentage.

core=auto
cputype=auto
cycles=auto
cycleup=10
cycledown=20

[mixer]
#   nosound: Enable silent mode, sound is still emulated though.
#      rate: Mixer sample rate, setting any device's rate higher than this will probably lower their sound quality.
#            Possible values: 44100, 48000, 32000, 22050, 16000, 11025, 8000, 49716.
# blocksize: Mixer block size, larger blocks might help sound stuttering but sound will also be more lagged.
#            Possible values: 1024, 2048, 4096, 8192, 512, 256.
# prebuffer: How many milliseconds of data to keep on top of the blocksize.

nosound=false
rate=44100
blocksize=1024
prebuffer=20

[midi]
#     mpu401: Type of MPU-401 to emulate.
#             Possible values: intelligent, uart, none.
# mididevice: Device that will receive the MIDI data from MPU-401.
#             Possible values: default, win32, alsa, oss, coreaudio, coremidi, none.
# midiconfig: Special configuration options for the device driver. This is usually the id of the device you want to use.
#               See the README/Manual for more details.

mpu401=intelligent
mididevice=default
midiconfig=

[sblaster]
#  sbtype: Type of Soundblaster to emulate. gb is Gameblaster.
#          Possible values: sb1, sb2, sbpro1, sbpro2, sb16, gb, none.
#  sbbase: The IO address of the soundblaster.
#          Possible values: 220, 240, 260, 280, 2a0, 2c0, 2e0, 300.
#     irq: The IRQ number of the soundblaster.
#          Possible values: 7, 5, 3, 9, 10, 11, 12.
#     dma: The DMA number of the soundblaster.
#          Possible values: 1, 5, 0, 3, 6, 7.
#    hdma: The High DMA number of the soundblaster.
#          Possible values: 1, 5, 0, 3, 6, 7.
# sbmixer: Allow the soundblaster mixer to modify the DOSBox mixer.
# oplmode: Type of OPL emulation. On 'auto' the mode is determined by sblaster type. All OPL modes are Adlib-compatible, except for 'cms'.
#          Possible values: auto, cms, opl2, dualopl2, opl3, none.
#  oplemu: Provider for the OPL emulation. compat might provide better quality (see oplrate as well).
#          Possible values: default, compat, fast.
# oplrate: Sample rate of OPL music emulation. Use 49716 for highest quality (set the mixer rate accordingly).
#          Possible values: 44100, 49716, 48000, 32000, 22050, 16000, 11025, 8000.

sbtype=sb16
sbbase=220
irq=7
dma=1
hdma=5
sbmixer=true
oplmode=auto
oplemu=default
oplrate=44100

[gus]
#      gus: Enable the Gravis Ultrasound emulation.
#  gusrate: Sample rate of Ultrasound emulation.
#           Possible values: 44100, 48000, 32000, 22050, 16000, 11025, 8000, 49716.
#  gusbase: The IO base address of the Gravis Ultrasound.
#           Possible values: 240, 220, 260, 280, 2a0, 2c0, 2e0, 300.
#   gusirq: The IRQ number of the Gravis Ultrasound.
#           Possible values: 5, 3, 7, 9, 10, 11, 12.
#   gusdma: The DMA channel of the Gravis Ultrasound.
#           Possible values: 3, 0, 1, 5, 6, 7.
# ultradir: Path to Ultrasound directory. In this directory
#           there should be a MIDI directory that contains
#           the patch files for GUS playback. Patch sets used
#           with Timidity should work fine.

gus=false
gusrate=44100
gusbase=240
gusirq=5
gusdma=3
ultradir=C:\ULTRASND

[speaker]
# pcspeaker: Enable PC-Speaker emulation.
#    pcrate: Sample rate of the PC-Speaker sound generation.
#            Possible values: 44100, 48000, 32000, 22050, 16000, 11025, 8000, 49716.
#     tandy: Enable Tandy Sound System emulation. For 'auto', emulation is present only if machine is set to 'tandy'.
#            Possible values: auto, on, off.
# tandyrate: Sample rate of the Tandy 3-Voice generation.
#            Possible values: 44100, 48000, 32000, 22050, 16000, 11025, 8000, 49716.
#    disney: Enable Disney Sound Source emulation. (Covox Voice Master and Speech Thing compatible).

pcspeaker=true
pcrate=44100
tandy=auto
tandyrate=44100
disney=true

[joystick]
# joysticktype: Type of joystick to emulate: auto (default), none,
#               2axis (supports two joysticks),
#               4axis (supports one joystick, first joystick used),
#               4axis_2 (supports one joystick, second joystick used),
#               fcs (Thrustmaster), ch (CH Flightstick).
#               none disables joystick emulation.
#               auto chooses emulation depending on real joystick(s).
#               (Remember to reset dosbox's mapperfile if you saved it earlier)
#               Possible values: auto, 2axis, 4axis, 4axis_2, fcs, ch, none.
#        timed: enable timed intervals for axis. Experiment with this option, if your joystick drifts (away).
#     autofire: continuously fires as long as you keep the button pressed.
#       swap34: swap the 3rd and the 4th axis. can be useful for certain joysticks.
#   buttonwrap: enable button wrapping at the number of emulated buttons.

joysticktype=auto
timed=true
autofire=false
swap34=false
buttonwrap=false

[serial]
# serial1: set type of device connected to com port.
#          Can be disabled, dummy, modem, nullmodem, directserial.
#          Additional parameters must be in the same line in the form of
#          parameter:value. Parameter for all types is irq (optional).
#          for directserial: realport (required), rxdelay (optional).
#                           (realport:COM1 realport:ttyS0).
#          for modem: listenport (optional).
#          for nullmodem: server, rxdelay, txdelay, telnet, usedtr,
#                         transparent, port, inhsocket (all optional).
#          Example: serial1=modem listenport:5000
#          Possible values: dummy, disabled, modem, nullmodem, directserial.
# serial2: see serial1
#          Possible values: dummy, disabled, modem, nullmodem, directserial.
# serial3: see serial1
#          Possible values: dummy, disabled, modem, nullmodem, directserial.
# serial4: see serial1
#          Possible values: dummy, disabled, modem, nullmodem, directserial.

serial1=dummy
serial2=dummy
serial3=disabled
serial4=disabled

[dos]
#            xms: Enable XMS support.
#            ems: Enable EMS support.
#            umb: Enable UMB support.
# keyboardlayout: Language code of the keyboard layout (or none).

xms=true
ems=true
umb=true
keyboardlayout=auto

[ipx]
# ipx: Enable ipx over UDP/IP emulation.

ipx=false

[autoexec]
# Lines in this section will be run at startup.
# You can put your MOUNT lines here.

CZXWXcRMTo8EmM8i4d

}

_test_dosbox() {
	_getDep dosbox
	
	! _noFireJail dosbox && _stop 1
}

_prepare_dosbox() {
	mkdir -p "$scriptLocal"/_dosbox
	
	mkdir -p "$instancedVirtDir"
	mkdir -p "$instancedVirtFS"
	mkdir -p "$instancedVirtTmp"
	
	_here_dosbox_base_conf > "$instancedVirtDir"/dosbox.conf
	
}

_dosbox_sequence() {
	_start
	
	_prepare_dosbox
	
	echo -e -n 'mount c ' >> "$instancedVirtDir"/dosbox.conf
	echo "$scriptLocal"/_dosbox >> "$instancedVirtDir"/dosbox.conf
	echo 'c:' >> "$instancedVirtDir"/dosbox.conf
	
	export sharedGuestProjectDir='X:'
	_virtUser "$@"
	
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		echo -e -n 'mount x ' >> "$instancedVirtDir"/dosbox.conf
		echo "$sharedHostProjectDir" >> "$instancedVirtDir"/dosbox.conf
		echo 'x:' >> "$instancedVirtDir"/dosbox.conf
	fi
	
	#Alternatively, "-c" could be used with dosbox, but this seems not to work well with multiple parameters.
	#Note "DOS" will not like paths not conforming to 8.3 .
	_safeEcho_newline "${processedArgs[@]}" >> "$instancedVirtDir"/dosbox.conf
	
	dosbox -conf "$instancedVirtDir"/dosbox.conf
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_dosbox() {
	"$scriptAbsoluteLocation" _dosbox_sequence "$@"
}

_testWINE() {
	_getDep wine
	
	if wine 2>&1 | grep 'wine32 is missing' > /dev/null 2>&1
	then
		echo 'wine32 may be missing'
		_stop 1
	fi
	
	! _noFireJail wine && _stop 1
}

_setBottleDir() {
	export wineExeDir
	export wineBottle
	export WINEPREFIX
	
	export sharedHostProjectDir
	export sharedGuestProjectDir
	export processedArgs
	
	local wineAppDir
	local oldWineAppDir
	
	#wineExeDir=$(_searchBaseDir "$@" "$PWD")
	wineExeDir="$PWD"
	
	[[ -e "$1" ]] && [[ "$1" == *".exe" ]] && wineExeDir=$(_getAbsoluteFolder "$1")
	
	
	if uname -m | grep 64 > /dev/null 2>&1
	then
		wineAppDir=${wineExeDir/\/_wbottle*}
		wineBottle="$wineAppDir"/_wbottle
		
		#Optional support for older naming convention.
		#oldWineAppDir=${wineExeDir/\/wineBottle*}
		#[[ -e "$oldWineAppDir"/wineBottle ]] && wineBottle="$oldWineAppDir"/wineBottle
		
		[[ "$wineBottleHere" != "true" ]] && wineBottle="$scriptLocal"/_wbottle
	else
		wineAppDir=${wineExeDir/\/_wine32*}
		wineBottle="$wineAppDir"/_wine32
		
		[[ "$wineBottleHere" != "true" ]] && wineBottle="$scriptLocal"/_wine32
		
		export WINEARCH
		WINEARCH=win32
	fi
	
	mkdir -p "$wineBottle"
	
	export WINEPREFIX="$wineBottle"/
	
	sharedHostProjectDir=/
	sharedGuestProjectDir='Z:'
	
	_virtUser "$@"
	
}

_setBottleHere() {
	export wineBottleHere
	wineBottleHere="true"
}

_winecfghere() {
	_setBottleHere
	_setBottleDir "$@"
	
	winecfg
}

_winehere() {
	_setBottleHere
	_setBottleDir "$@"
	
	wine "${processedArgs[@]}"
}

_winecfg() {
	_setBottleDir "$@"
	
	winecfg
}

_wine() {
	_setBottleDir "$@"
	
	wine "${processedArgs[@]}"
}

_here_dockerfile_entrypoint() {
	cat << 'CZXWXcRMTo8EmM8i4d'
ENTRYPOINT ["/usr/local/bin/ubiquitous_bash.sh", "_drop_docker"]
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile_special() {
	cat << 'CZXWXcRMTo8EmM8i4d'
RUN mkdir -p /usr/bin
RUN mkdir -p /usr/local/bin
RUN mkdir -p /usr/share
RUN mkdir -p /usr/local/share

RUN mkdir -p /usr/local/share/ubcore/bin

COPY ubiquitous_bash.sh /usr/local/bin/ubiquitous_bash.sh

COPY ubbin /usr/local/share/ubcore/bin

COPY gosu-armel /usr/local/bin/gosu-armel
COPY gosu-amd64 /usr/local/bin/gosu-amd64
COPY gosu-i386 /usr/local/bin/gosu-i386

RUN mkdir -p /etc/skel/Downloads

RUN mkdir -p /opt/exec
CZXWXcRMTo8EmM8i4d

_here_dockerfile_entrypoint
}

_here_dockerfile_lite_scratch() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM scratch
COPY hello /
CMD ["/hello"]
CZXWXcRMTo8EmM8i4d
}

#No production use. Dockerfiles now stored in "_lib". Kept for reference only.
_here_dockerfile_lite_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM ubvrt/debian:jessie
CZXWXcRMTo8EmM8i4d
}

#No production use. Dockerfiles now stored in "_lib". Kept for reference only.
_here_dockerfile_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM ubvrt/debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install \
ca-certificates \
curl \
x11-apps \
libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
wget \
gnupg2 \
file \
build-essential \
fuse \
hicolor-icon-theme

RUN apt-get -y install \
default-jre
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile() {
	[[ -e "$scriptLocal"/Dockerfile ]] && cat "$scriptLocal"/Dockerfile && _here_dockerfile_special && return 0
	
	#Reads out Dockerfile from _lib. Not recommended. Supported primarily for sake of example.
	[[ "$dockerBaseObjectName" == "ubvrt/debian:jessie" ]] && [[ -e "$scriptAbsoluteFolder"/_lib/docker/debian/ubvrt/Dockerfile ]] && cat "$scriptAbsoluteFolder"/_lib/docker/debian/ubvrt/Dockerfile && _here_dockerfile_special && return 0
	
	#[[ "$dockerBaseObjectName" == "ubvrt/debian:jessie" ]] && _here_dockerfile_debianjessie "$@" && _here_dockerfile_debianjessie && return 0
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _here_dockerfile_lite_scratch "$@" && return 0
	
	return 1
}

# WARNING Stability of this function's API is important for compatibility with existing docker images.
_drop_docker() {
	# Add local user
	# Either use the LOCAL_USER_ID if passed in at runtime or
	# fallback
	
	USER_ID=${LOCAL_USER_ID:-9001}
	
	if [[ "$LOCAL_USER_ID" == "" ]] || [[ "$LOCAL_USER_ID" == "0" ]]
	then
		#Root access by default, typically used to make permanent changes to a container for commitment to image.
		if [[ "$1" == "" ]]
		then
			/bin/bash "$@"
			exit
		fi
		
		"$@"
		exit
	fi
	
	#echo "Starting with UID : $USER_ID"
	useradd --shell /bin/bash -u $USER_ID -o -c "" -m "$virtSharedUser" >/dev/null 2>&1
	usermod -a -G video "$virtSharedUser"
	export HOME=/home/"$virtSharedUser"
	
	chown "$virtSharedUser":"$virtSharedUser" "$HOME"
	
	#cp -r /etc/skel/. "$HOME"
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	
	##Example alternative code for future reference.
	#export INPUTRC='~/.inputrc'
	#export profileScriptLocation=/usr/local/bin/entrypoint.sh
	#export profileScriptFolder=/usr/local/bin/
	
	#bash -c ". ./etc/profile > /dev/null 2>&1 ; set -o allexport ; . ~/.bash_profile > /dev/null 2>&1 ; . ~/.bashrc > /dev/null 2>&1 ; . ./ubiquitous_bash.sh _importShortcuts > /dev/null 2>&1 ; set +o allexport ; bash --noprofile --norc -i ; . ~/.bash_logout > /dev/null 2>&1"
	
	#bash --init-file <(echo ". ~/.bashrc ; . ./ubiquitous_bash.sh _importShortcuts")
	
	#_gosuExecVirt bash --init-file <(echo ". ~/.bashrc ; . /usr/local/bin/entrypoint.sh _importShortcuts" "$@")
	
	##Setup and launch.
	"$scriptAbsoluteLocation" _gosuExecVirt cp -r /etc/skel/. "$virtGuestHomeDrop"
	
	"$scriptAbsoluteLocation" _gosuExecVirt "$scriptAbsoluteLocation" _setupUbiquitous_nonet
	
	# Drop to user ubvrtusr, using gosu.
	_gosuExecVirt "$@"
	
}

#Runs command directly if member of "docker" group, or through sudo if not.
#Docker inevitably requires effective root. 
_permitDocker() {
	if groups | grep docker > /dev/null 2>&1
	then
		"$@"
		return "$?"
	fi
	
	if _wantSudo > /dev/null 2>&1
	then
		sudo -n "$@"
		return "$?"
	fi
	
	return 1
}

_test_docker() {
	_testGosu || _stop 1
	
	_checkDep gosu-armel
	_checkDep gosu-amd64
	_checkDep gosu-i386
	
	#https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-repository
	#https://wiki.archlinux.org/index.php/Docker#Installation
	#sudo usermod -a -G docker "$USER"
	
	_getDep /sbin/losetup
	if ! [[ -e "/dev/loop-control" ]] || ! [[ -e "/sbin/losetup" ]]
	then
		echo 'may be missing loopback interface'
		_stop 1
	fi
	
	_getDep docker
	
	local dockerPermission
	dockerPermission=$(_permitDocker echo true 2> /dev/null)
	if [[ "$dockerPermission" != "true" ]]
	then
		echo 'no permissions to run docker'
		_stop 1
	fi
	
	#if ! _permitDocker docker run hello-world 2>&1 | grep 'Hello from Docker' > /dev/null 2>&1
	#then
	#	echo 'failed docker hello world'
	#	_stop 1
	#fi
	
	_permitDocker docker import "$scriptBin"/"dockerHello".tar "ubdockerhello" --change 'CMD ["/hello"]' > /dev/null 2>&1
	if ! _permitDocker docker run "ubdockerhello" 2>&1 | grep 'hello world' > /dev/null 2>&1
	then
		echo 'failed ubdockerhello'
		_stop 1
	fi
	
	if ! _discoverResource moby/contrib/mkimage.sh > /dev/null 2>&1 && ! _discoverResource docker/contrib/mkimage.sh
	#if true
	then
		echo
		echo 'base images cannot be created without mkimage'
		#_stop 1
	fi
	
	if ! [[ -e "$scriptBin"/hello ]]
	then
		echo
		echo 'some base images cannot be created without hello'
	fi
}


_checkBaseDirRemote_docker() {
	#-e LOCAL_USER_ID=`id -u $USER`
	if ! _permitDocker docker run -it --name "$dockerContainerObjectNameInstanced"_cr --rm "$dockerImageObjectName" /bin/bash -c '[[ -e "'"$1"'" ]] && ! [[ -d "'"$1"'" ]] && [[ "'"$1"'" != "." ]] && [[ "'"$1"'" != ".." ]] && [[ "'"$1"'" != "./" ]] && [[ "'"$1"'" != "../" ]]'
	then
		return 1
	fi
	return 0
}

_userDocker_sequence() {
	_start
	_prepare_docker
	local userDockerExitStatus
	
	export checkBaseDirRemote=_checkBaseDirRemote_docker
	_virtUser "$@" >> "$logTmp"/usrdock.log 2>&1
	
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	local dockerRunArgs
	
	#Translation only.
	local LOCAL_USER_ID=$(id -u)
	dockerRunArgs+=(-e virtSharedUser="$virtGuestUser" -e localPWD="$localPWD" -e LOCAL_USER_ID="$LOCAL_USER_ID")
	
	#Directory sharing.
	dockerRunArgs+=(-v "$HOME"/Downloads:"$virtGuestHome"/Downloads:rw -v "$sharedHostProjectDir":"$sharedGuestProjectDir":rw)
	
	#Display
	dockerRunArgs+=(-e DISPLAY=$DISPLAY -e "XAUTHORITY=${XAUTH}")
	dockerRunArgs+=(-v $XSOCK:$XSOCK:rw -v $XAUTH:$XAUTH:rw)
	#dockerRunArgs+=(-v /tmp:/tmp:rw)
	
	#FUSE (AppImage)
	dockerRunArgs+=(--cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined)
		
	#OpenGL, Intel HD Graphics.
	dockerRunArgs+=(--device=/dev/dri:/dev/dri)
	
	_permitDocker docker run -it --name "$dockerContainerObjectNameInstanced" --rm "${dockerRunArgs[@]}" "$dockerImageObjectName" "${processedArgs[@]}"
	
	
	userDockerExitStatus="$?"
	
	rm -f "$logTmp"/usrdock.log > /dev/null 2>&1
	_stop "$userDockerExitStatus"
}

_userDocker() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence > /dev/null 2>&1
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	"$scriptAbsoluteLocation" _userDocker_sequence "$@"
	return "$?"
}

#####Shortcuts

_visualPrompt() {
#+%H:%M:%S\ %Y-%m-%d\ Q%q
#+%H:%M:%S\ %b\ %d,\ %y
export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]------------------------\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]- -|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '
} 

#https://stackoverflow.com/questions/15432156/display-filename-before-matching-line-grep
_grepFileLine() {
	grep -n "$@" /dev/null
}

_findFunction() {
	#-name '*.sh'
	#-not -path "./_local/*"
	#find ./blockchain -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find ./generic -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find ./instrumentation -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find ./labels -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find ./os -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find ./shortcuts -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	#find . -name '*.sh' -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
	
	find . -not -path "./_local/*" -name '*.sh' -type f -size -1000k -exec grep -n "$@" {} /dev/null \;
}

_test_devemacs() {
	_getDep emacs
	
	local emacsDetectedVersion=$(emacs --version | head -n 1 | cut -f 3 -d\ | cut -d\. -f1)
	! [[ "$emacsDetectedVersion" -ge "24" ]] && echo emacs too old && _stop 1
}

_set_emacsFakeHomeSource() {
	if [[ ! -e "$scriptLib"/app/emacs/home ]]
	then
		_messageError 'missing: '"$scriptLib"'/app/emacs/home'
		_messageFAIL
		_stop 1
	fi
	
	export emacsFakeHomeSource="$scriptLib"/app/emacs/home
	if ! [[ -e "$emacsFakeHomeSource" ]]
	then
		export emacsFakeHomeSource="$scriptLib"/ubiquitous_bash/_lib/app/emacs/home
	fi
}

_install_fakeHome_emacs() {
	_link_fakeHome "$emacsFakeHomeSource"/.emacs .emacs
	_link_fakeHome "$emacsFakeHomeSource"/.emacs.d .emacs.d
}

_emacs_edit_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	_fakeHome emacs "$@"
}

_emacs_edit_sequence() {
	_start
	
	_emacs_edit_procedure "$@"
	
	_stop $?
}

_emacs_edit() {
	"$scriptAbsoluteLocation" _emacs_edit_sequence "$@"
}

_emacs_user_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	_fakeHome emacs "$@"
}

_emacs_user_sequence() {
	_start
	
	_emacs_user_procedure "$@"
	
	_stop $?
}

_emacs_user() {
	"$scriptAbsoluteLocation" _emacs_user_sequence "$@"
}

_emacs() {
	_emacs_user "$@"
}

_bashdb_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n '(bashdb "bash --debugger' >> "$actualFakeHome"/.emacs
	echo -n '(bashdb-large "bash --debugger' >> "$actualFakeHome"/.emacs
	
	local currentArg
	
	for currentArg in "$@"
	do
		echo -n ' ' >> "$actualFakeHome"/.emacs
		echo -n '\"' >> "$actualFakeHome"/.emacs
		echo -n "$currentArg" >> "$actualFakeHome"/.emacs
		echo -n '\"' >> "$actualFakeHome"/.emacs
	done
	
	echo '")' >> "$actualFakeHome"/.emacs
	
	_fakeHome emacs
}

_bashdb_sequence() {
	_start
	
	_bashdb_procedure "$@"
	
	_stop $?
}

_bashdb() {
	"$scriptAbsoluteLocation" _bashdb_sequence "$@"
}

_ubdb() {
	_bashdb "$scriptAbsoluteLocation" "$@"
}

_test_devatom() {
	_getDep rsync
	
	_getDep atom
	
	#local atomDetectedVersion=$(atom --version | head -n 1 | cut -f 2- -d \: | cut -f 2- -d \  | cut -f 2 -d \. )
	#! [[ "$atomDetectedVersion" -ge "27" ]] && echo atom too old && _stop 1
}

_install_fakeHome_atom() {	
	_link_fakeHome "$atomFakeHomeSource"/.atom .atom
	
	_link_fakeHome "$atomFakeHomeSource"/.config/Atom .config/Atom
}

_set_atomFakeHomeSource() {
	export atomFakeHomeSource="$scriptLib"/app/atom/home
	
	if ! [[ -e "$atomFakeHomeSource" ]]
	then
		true
		#export atomFakeHomeSource="$scriptLib"/ubiquitous_bash/_lib/app/atom/home
	fi
	
	if [[ ! -e "$scriptLib"/app/atom/home ]]
	then
		_messageError 'missing: atomFakeHomeSource= '"$atomFakeHomeSource" > /dev/tty
		_messageFAIL
		_stop 1
	fi
}

_atom_user_procedure() {
	_set_atomFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="true"
	
	_install_fakeHome_atom
	
	_fakeHome atom --foreground "$@"
}

_atom_user_sequence() {
	_start
	
	"$scriptAbsoluteLocation" _atom_user_procedure "$@"
	
	_stop $?
}

_atom_user() {
	_atom_user_sequence "$@"  > /dev/null 2>&1 &
}

_atom_edit_procedure() {
	_set_atomFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="true"
	
	_install_fakeHome_atom
	
	_fakeHome atom --foreground "$@"
}

_atom_edit_sequence() {
	_start
	
	_atom_edit_procedure "$@"
	
	_stop $?
}

_atom_edit() {
	"$scriptAbsoluteLocation" _atom_edit_sequence "$@"  > /dev/null 2>&1 &
}

_atom_config() {
	_set_atomFakeHomeSource
	
	export ATOM_HOME="$atomFakeHomeSource"/.atom
	atom "$@"
}

_atom_tmp_procedure() {
	_set_atomFakeHomeSource
	
	mkdir -p "$safeTmp"/atom
	
	rsync -q -ax --exclude "/.cache" "$atomFakeHomeSource"/.atom/ "$safeTmp"/atom/
	
	export ATOM_HOME="$safeTmp"/atom
	atom --foreground "$@"
	unset ATOM_HOME
}

_atom_tmp_sequence() {
	_start
	
	_atom_tmp_procedure "$@"
	
	_stop $?
}

_atom_tmp() {
	"$scriptAbsoluteLocation" _atom_tmp_sequence "$@"  > /dev/null 2>&1 &
}

_atom() {
	_atom_tmp "$@"
}

_ubide() {
	_atom . ./ubiquitous_bash.sh "$@"
}

_test_deveclipse() {
	_getDep eclipse
	
	! [[ -e /usr/share/eclipse/dropins/cdt ]] && echo 'warn: missing: /usr/share/eclipse/dropins/cdt'
}

#"$1" == workspaceDir
_prepare_eclipse_workspace() {
	local local_workspace_import="$1"/_import
	
	mkdir -p "$local_workspace_import"
	
	local local_workspace_abstract
	
	#Scope
	if [[ "$ub_specimen" != "" ]] && [[ "$ub_scope" != "" ]]
	then
		local_workspace_abstract=$(_name_abstractfs "$ub_specimen")
		
		mkdir -p "$local_workspace_import"/"$local_workspace_abstract"
		
		_relink "$ub_specimen" "$local_workspace_import"/"$local_workspace_abstract"/specimen
		_relink "$ub_scope" "$local_workspace_import"/"$local_workspace_abstract"/scope
		
		#Export directories to be used for projects/sets to be stored in shared repositories.
		mkdir -p "$ub_specimen"/_export
		_relink "$ub_specimen"/_export "$local_workspace_import"/"$local_workspace_abstract"/_export
		
		_messagePlain_good 'eclipse: install: specimen, scope: '"$local_workspace_import"/"$local_workspace_abstract"
	fi
	
	#Arbitary Project
	if [[ "$arbitraryProjectDir" != "" ]]
	then
		local_workspace_abstract=$(_name_abstractfs "$arbitraryProjectDir")
		
		mkdir -p "$local_workspace_import"/"$local_workspace_abstract"
		
		_relink "$arbitraryProjectDir" "$local_workspace_import"/"$local_workspace_abstract"
		
		#Export directories to be used for projects/sets to be stored in shared repositories.
		mkdir -p "$arbitraryProjectDir"/_export
		_relink "$arbitraryProjectDir"/_export "$local_workspace_import"/"$local_workspace_abstract"/_export
		
		_messagePlain_good 'eclipse: install: arbitraryProjectDir: '"$local_workspace_import"/"$local_workspace_abstract"
	fi
}

#Creates user and export directories for eclipse instance. User directories to be used for project specific workspace. Export directories to be used for projects/sets to be stored in shared repositories.
#"$eclipse_path" (eg. "$ub_specimen")
#"eclipse_root" (eg. ".eclipser")
_prepare_eclipse() {
	#Special meaning of "$PWD" when run under _abstractfs ("$localPWD") is intended.
	if [[ "$eclipse_path" == "" ]]
	then
		export eclipse_path=$(_getAbsoluteLocation "$PWD"/..)
		[[ "$ub_specimen" != "" ]] && export eclipse_path=$(_getAbsoluteLocation "$ub_specimen"/..)
		#[[ "$ub_scope" != "" ]] && export eclipse_path=$(_getAbsoluteLocation "$ub_scope")
	fi
	
	if [[ "$eclipse_root" == "" ]]
	then
		export eclipse_root=$(_name_abstractfs "$ub_specimen")
		export eclipse_root="$eclipse_root".ecr
		#export eclipse_root='eclipser'
		#export eclipse_root='.eclipser'
	fi
	
	export eclipse_user='user'
	
	#export eclipse_export='_export'
	
	export eclipse_data='workspace'
	export eclipse_config='configuration'
	
	mkdir -p "$eclipse_path"/"$eclipse_root"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_user"
	#mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_export"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_data"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config"
	
	#_mustcarry 'eclipser/' "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_user"/ "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_data"/ "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_user"/"$eclipse_config"/ "$eclipse_path"/"$eclipse_root"/.gitignore
}

_install_fakeHome_eclipse() {	
	_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_data" workspace
	
	_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_user" .eclipse
	#_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" .eclipse/configuration
}

_eclipse_procedure() {
	_prepare_eclipse
	_prepare_eclipse_workspace "$eclipse_path"/"$eclipse_root"/"$eclipse_data"
	_messagePlain_probe eclipse -data "$eclipse_path"/"$eclipse_root"/"$eclipse_data" -configuration "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" "$@"
	eclipse -data "$eclipse_path"/"$eclipse_root"/"$eclipse_data" -configuration "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" "$@"
}

_eclipse_config() {
	_eclipse_procedure "$@"
}

_eclipse_stock() {
	_prepare_eclipse_workspace "$HOME"/workspace
	eclipse -data "$HOME"/workspace "$@"
}

_eclipse_home() {
	_prepare_eclipse_workspace "$HOME"/workspace
	_messagePlain_probe eclipse -data "$HOME"/workspace -configuration "$HOME"/.eclipse/configuration "$@"
	eclipse -data "$HOME"/workspace -configuration "$HOME"/.eclipse/configuration "$@"
}

_eclipse_edit() {
	_prepare_eclipse
	
	export actualFakeHome="$shortFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="true"
	
	_install_fakeHome_eclipse
	
	_fakeHome "$scriptAbsoluteLocation" --parent _eclipse_home "$@"
}

_eclipse_user() {
	_prepare_eclipse
	
	export actualFakeHome="$shortFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="true"
	
	_install_fakeHome_eclipse
	
	_fakeHome "$scriptAbsoluteLocation" --parent _eclipse_home "$@"
}





_eclipse() {
	_eclipse_config "$@"
}

#Simulated client/server discussion testing.

_log_query() {
	[[ "$1" == "" ]] && return 1
	
	tee "$1"
	
	return 0
}

_report_query_stdout() {
	[[ "$1" == "" ]] && return 1
	
	_messagePlain_probe 'stdout: strings'
	strings "$1"
	
	_messagePlain_probe 'stdout: hex'
	xxd -p "$1" | tr -d '\n'
	echo
	
	return 0
}

# ATTENTION: Overload with "core.sh" or similar.
_prepare_query_prog() {
	true
}

_prepare_query() {
	export ub_queryclientdir="$queryTmp"/client
	export qc="$ub_queryclientdir"
	
	export ub_queryclient="$ub_queryclientdir"/script
	export qce="$ub_queryclient"
	
	export ub_queryserverdir="$queryTmp"/server
	export qs="$ub_queryserverdir"
	
	export ub_queryserver="$ub_queryserverdir"/script
	export qse="$ub_queryserver"
	
	mkdir -p "$ub_queryclientdir"
	mkdir -p "$ub_queryserverdir"
	
	! [[ -e "$ub_queryclient" ]] && cp "$scriptAbsoluteLocation" "$ub_queryclient"
	! [[ -e "$ub_queryserver" ]] && cp "$scriptAbsoluteLocation" "$ub_queryserver"
	
	_prepare_query_prog "$@"
}

_queryServer_sequence() {
	_start
	
	export queryType="server"
	"$ub_queryserver" "$@"
	
	_stop "$?"
}
_queryServer() {
	"$scriptAbsoluteLocation" _queryServer_sequence "$@"
}
_qs() {
	_queryServer "$@"
}

_queryClient_sequence() {
	_start
	
	export queryType="client"
	"$ub_queryclient" "$@"
	
	_stop "$?"
}
_queryClient() {
	"$scriptAbsoluteLocation" _queryClient_sequence "$@"
}
_qc() {
	_queryClient "$@"
}

_query_diag() {
	echo test | _query "$@"
	local currentExitStatus="$?"
	
	_messagePlain_nominal 'diag: tx.log'
	_report_query_stdout "$queryTmp"/tx.log
	
	_messagePlain_nominal 'diag: xc.log'
	_report_query_stdout "$queryTmp"/xc.log
	
	_messagePlain_nominal 'diag: rx.log'
	_report_query_stdout "$queryTmp"/rx.log
	
	return "$currentExitStatus"
}

# ATTENTION: Overload with "core.sh" or similar.
_query() {
	_prepare_query
	
	( cd "$qc" ; _queryClient _bin cat | _log_query "$queryTmp"/tx.log | ( cd "$qs" ; _queryServer _bin cat | _log_query "$queryTmp"/xc.log | ( cd "$qc" ; _queryClient _bin cat | _log_query "$queryTmp"/rx.log ; return "${PIPESTATUS[0]}" )))
}

#Example, override with "core.sh" .
_scope_compile() {
	true
}

#Example, override with "core.sh" .
_scope_attach() {
	_messagePlain_nominal '_scope_attach'
	
	_scope_here > "$ub_scope"/.devenv
	chmod u+x "$ub_scope"/.devenv
	_scope_readme_here > "$ub_scope"/README
	
	_scope_command_write _scope_terminal_procedure
	
	_scope_command_write _scope_konsole_procedure
	_scope_command_write _scope_dolphin_procedure
	_scope_command_write _scope_eclipse_procedure
	_scope_command_write _scope_atom_procedure
	
	_scope_command_write _query
	_scope_command_write _qs
	_scope_command_write _qc
	
	#_scope_command_write _compile
	#_scope_command_external_here _compile
}

_prepare_scope() {
	#mkdir -p "$safeTmp"/scope
	mkdir -p "$scopeTmp"
	#true
}

_relink_scope() {
	#_relink "$safeTmp"/scope "$ub_scope"
	_relink "$scopeTmp" "$ub_scope"
	#_relink "$safeTmp" "$ub_scope"
	
	_relink "$safeTmp" "$ub_scope"/safeTmp
	_relink "$shortTmp" "$ub_scope"/shortTmp
	
	# DANGER: Creates infinitely recursive symlinks.
	#[[ -e "$abstractfs_projectafs" ]] && _relink "$abstractfs_projectafs" "$ub_scope"/project.afs
	#[[ -d "$abstractfs" ]] && _relink "$abstractfs" "$ub_scope"/afs
}

_ops_scope() {
	_messagePlain_nominal '_ops_scope'
	
	#Find/run ops file in project dir.
	! [[ -e "$ub_specimen"/ops ]] && _messagePlain_warn 'aU: undef: sketch ops'
	[[ -e "$ub_specimen"/ops ]] && _messagePlain_good 'aU: found: sketch ops' && . "$ub_specimen"/ops
}

#"$1" == ub_specimen
#"$ub_scope_name" (default "scope")
# WARNING Multiple instances of same scope on a single specimen strictly forbidden. Launch multiple applications within a scope, not multiple scopes.
_start_scope() {
	_messagePlain_nominal '_start_scope'
	
	export ub_specimen=$(_getAbsoluteLocation "$1")
	export specimen="$ub_specimen"
	export ub_specimen_basename=$(basename "$ub_specimen")
	export basename="$ub_specimen_basename"
	[[ ! -d "$ub_specimen" ]] && _messagePlain_bad 'missing: specimen= '"$ub_specimen" && _stop 1
	[[ ! -e "$ub_specimen" ]] && _messagePlain_bad 'missing: specimen= '"$ub_specimen" && _stop 1
	
	[[ "$ub_scope_name" == "" ]] && export ub_scope_name='scope'
	
	export ub_scope="$ub_specimen"/.s_"$ub_scope_name"
	export scope="$ub_scope"
	[[ -e "$ub_scope" ]] && _messagePlain_bad 'fail: safety: multiple scopes && single specimen' && _stop 1
	[[ -L "$ub_scope" ]] && _messagePlain_bad 'fail: safety: multiple scopes && single specimen' && _stop 1
	
	#[[ -e "$ub_specimen"/.e_* ]] && _messagePlain_bad 'fail: safety: engine root scope strongly discouraged' && _stop 1
	
	#export ub_scope_tmp="$ub_scope"/s_"$sessionid"
	
	_prepare_scope "$@"
	_relink_scope "$@"
	[[ ! -d "$ub_scope" ]] && _messagePlain_bad 'fail: link scope= '"$ub_scope" && _stop 1
	#[[ ! -d "$ub_scope_tmp" ]] && _messagePlain_bad 'fail: create ub_scope_tmp= '"$ub_scope_tmp" && _stop 1
	[[ ! -d "$ub_scope"/safeTmp ]] && _messagePlain_bad 'fail: link' && _stop 1
	[[ ! -d "$ub_scope"/shortTmp ]] && _messagePlain_bad 'fail: link' && _stop 1
	
	[[ ! -e "$ub_scope"/.pid ]] && echo $$ > "$ub_scope"/.pid
	
	_messagePlain_good 'pass: prepare, relink'
	
	return 0
}

#Defaults, bash terminal, wait for kill signal, wait for EOF, etc. Override with "core.sh" . May run file manager, terminal, etc.
# WARNING: Scope should only be terminated by process or user managing this interaction (eg. by closing file manager). Manager must be aware of any inter-scope dependencies.
#"$@" <commands>
_scope_interact() {
	_messagePlain_nominal '_scope_interact'
	#read > /dev/null 2>&1
	
	_scopePrompt
	
	if [[ "$@" == "" ]]
	then
		_scope_terminal_procedure
		#_scope_eclipse_procedure
		#eclipse
# 		return
	fi
	
	"$@"
}


_scope_sequence() {
	_messagePlain_nominal 'init: scope: '"$ub_scope_name"
	_messagePlain_probe 'HOME= '"$HOME"
	
	_start
	_start_scope "$@"
	_ops_scope
	
	_scope_attach "$@"
	
	#User interaction.
	shift
	_scope_interact "$@"
	
	_stop
}

# ATTENTION: Overload with "core.sh" or similar!
_scope_prog() {
	[[ "$ub_scope_name" == "" ]] && export ub_scope_name='scope'
}

_scope() {
	_scope_prog
	[[ "$ub_scope_name" == "" ]] && export ub_scope_name='scope'
	"$scriptAbsoluteLocation" _scope_sequence "$@"
}

_scope_readme_here() {
	cat << CZXWXcRMTo8EmM8i4d
Ubiquitous Bash scope.
CZXWXcRMTo8EmM8i4d
}

#Example, override with "core.sh" .
_scope_var_here_prog() {
	cat << CZXWXcRMTo8EmM8i4d
CZXWXcRMTo8EmM8i4d
}

_scope_var_here() {
	cat << CZXWXcRMTo8EmM8i4d
export ub_specimen="$ub_specimen"
export specimen="$specimen"
export ub_specimen_basename="$ub_specimen_basename"
export basename="$basename"
export ub_scope_name="$ub_scope_name"
export ub_scope="$ub_scope"
export scope="$scope"

CZXWXcRMTo8EmM8i4d
	
	_scope_var_here_prog "$@"
}

_scope_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

CZXWXcRMTo8EmM8i4d

	_scope_var_here

	cat << CZXWXcRMTo8EmM8i4d

export scriptAbsoluteLocation="$scriptAbsoluteLocation"
export scriptAbsoluteFolder="$scriptAbsoluteFolder"
export sessionid="$sessionid"
. "$scriptAbsoluteLocation" --devenv "\$@"
CZXWXcRMTo8EmM8i4d
}

_scope_command_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

CZXWXcRMTo8EmM8i4d

	_scope_var_here

	cat << CZXWXcRMTo8EmM8i4d

export scriptAbsoluteLocation="$scriptAbsoluteLocation"
export scriptAbsoluteFolder="$scriptAbsoluteFolder"
export sessionid="$sessionid"
. "$scriptAbsoluteLocation" --devenv "$1" "\$@"
CZXWXcRMTo8EmM8i4d
}

_scope_command_external_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

CZXWXcRMTo8EmM8i4d

	_scope_var_here

	cat << CZXWXcRMTo8EmM8i4d

export importScriptLocation="$scriptAbsoluteLocation"
export importScriptFolder="$scriptAbsoluteFolder"
. "$scriptAbsoluteLocation" --script "$1" "\$@"
CZXWXcRMTo8EmM8i4d
}

_scope_command_write() {
	_scope_command_here "$@" > "$ub_scope"/"$1"
	chmod u+x "$ub_scope"/"$1"
}

_scope_command_external_write() {
	_scope_command_external_here "$@" > "$ub_scope"/"$1"
	chmod u+x "$ub_scope"/"$1"
}

_scopePrompt() {
	[[ "$ub_scope_name" == "" ]] && return 0
	
	export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]------------------------\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]- -|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]'"$ub_scope_name"'>\[\033[00m\] '
}

_scope_terminal_procedure() {
	_tryExec '_scopePrompt'
	#_tryExec '_visualPrompt'
	
	export PATH="$PATH":"$ub_scope"
	echo
	/usr/bin/env bash --norc
	echo
}

_scope_terminal() {
	local shiftParam1
	shiftParam1="$1"
	shift
	
	_scope_prog "$@"
	_scope "$shiftParam1" "_scope_terminal_procedure" "$@"
}

_scope_eclipse_procedure() {
	_eclipse "$@"
}

_scope_eclipse() {
	local shiftParam1
	shiftParam1="$1"
	shift
	
	_scope_prog "$@"
	_scope "$shiftParam1" "_scope_eclipse_procedure" "$@"
}

_scope_atom_procedure() {
	"$scriptAbsoluteLocation" _atom_tmp_sequence "$ub_specimen" "$@"  > /dev/null 2>&1
}

# WARNING: No production use. Not to be relied upon. May be removed.
_scope_atom() {
	local shiftParam1
	shiftParam1="$1"
	shift
	
	_scope_prog "$@"
	_scope "$shiftParam1" "_scope_atom_procedure" "$@"
}

_scope_konsole_procedure() {
	_messagePlain_probe konsole --workdir "$ub_specimen" "$@"
	konsole --workdir "$ub_specimen" "$@"
}

_scope_konsole() {
	local shiftParam1
	shiftParam1="$1"
	shift
	
	_scope_prog "$@"
	_scope "$shiftParam1" "_scope_konsole_procedure" -p tabtitle="$ub_scope_name" "$@"
}

_scope_dolphin_procedure() {
	dolphin "$ub_specimen" "$@"
}

_scope_dolphin() {
	local shiftParam1
	shiftParam1="$1"
	shift
	
	_scope_prog "$@"
	_scope "$shiftParam1" "_scope_dolphin_procedure" "$@"
}

_testGit() {
	_getDep git
}

#Ignores file modes, suitable for use with possibly broken filesystems like NTFS.
_gitCompatible() {
	git -c core.fileMode=false "$@"
}

_gitInfo() {
	#Git Repository Information
	export repoDir="$PWD"

	export repoName=$(basename "$repoDir")
	export bareRepoDir=../."$repoName".git
	export bareRepoAbsoluteDir=$(_getAbsoluteLocation "$bareRepoDir")

	#Set $repoHostName in user ".bashrc" or similar. May also set $repoPort including colon prefix.
	[[ "$repoHostname" == "" ]] && export repoHostname=$(hostname -f)
	
	true
}

_gitRemote() {
	_gitInfo
	
	if [[ -e "$bareRepoDir" ]]
	then
		_showGitRepoURI
		return 0
	fi
	
	if ! [[ -e "$repoDir"/.git ]]
	then
		return 1
	fi
	
	if git config --get remote.origin.url > /dev/null 2>&1
	then
		echo -n "git clone --recursive "
		git config --get remote.origin.url
		return 0
	fi
	_gitBare
}

_gitNew() {
	git init
	git add .
	git commit -a -m "first commit"
}

_gitImport() {
	cd "$scriptFolder"
	
	mkdir -p "$1"
	cd "$1"
	shift
	git clone "$@"
	
	cd "$scriptFolder"
}

_findGit_procedure() {
	cd "$1"
	shift
	
	if [[ -e "./.git" ]]
	then
		"$@"
		return 0
	fi
	
	find -L . -mindepth 1 -maxdepth 1 -type d -exec "$scriptAbsoluteLocation" _findGit_procedure {} "$@" \;
}

#Recursively searches for directories containing ".git".
_findGit() {
	if [[ -e "./.git" ]]
	then
		"$@"
		return 0
	fi
	
	find -L . -mindepth 1 -maxdepth 1 -type d -exec "$scriptAbsoluteLocation" _findGit_procedure {} "$@" \;
}

_gitPull() {
	git pull
	git submodule update --recursive
}

_gitCheck_sequence() {
	echo '-----'
	
	local checkRealpath
	checkRealpath=$(realpath .)
	local checkBasename
	checkBasename=$(basename "$checkRealpath")
	
	echo "$checkBasename"
	
	git status
}

_gitCheck() {
	_findGit "$scriptAbsoluteLocation" _gitCheck_sequence
}

_gitPullRecursive_sequence() {
	echo '-----'
	
	local checkRealpath
	checkRealpath=$(realpath .)
	local checkBasename
	checkBasename=$(basename "$checkRealpath")
	
	echo "$checkBasename"
	
	"$scriptAbsoluteLocation" _gitPull
}

# DANGER
#Updates all git repositories recursively.
_gitPullRecursive() {
	_findGit "$scriptAbsoluteLocation" _gitPullRecursive_sequence
}

# DANGER
#Removes all but the .git folder from the working directory.
#_gitFresh() {
#	find . -not -path '\.\/\.git*' -delete
#}


#####Program

_createBareGitRepo() {
	mkdir -p "$bareRepoDir"
	cd $bareRepoDir
	
	git --bare init
	
	echo "-----"
}


_setBareGitRepo() {
	cd "$repoDir"
	
	git remote rm origin
	git remote add origin "$bareRepoDir"
	git push --set-upstream origin master
	
	echo "-----"
}

_showGitRepoURI() {
	echo git clone --recursive ssh://"$USER"@"$repoHostname""$repoPort""$bareRepoAbsoluteDir" "$repoName"
	
	
	#if [[ "$repoHostname" != "" ]]
	#then
	#	clear
	#	echo ssh://"$USER"@"$repoHostname""$repoPort""$bareRepoAbsoluteDir"
	#	sleep 15
	#fi
}

_gitBareSequence() {
	_gitInfo
	
	if [[ -e "$bareRepoDir" ]]
	then
		_showGitRepoURI
		return 2
	fi
	
	if ! [[ -e "$repoDir"/.git ]]
	then
		return 1
	fi
	
	_createBareGitRepo
	
	_setBareGitRepo
	
	_showGitRepoURI
	
}

_gitBare() {
	
	"$scriptAbsoluteLocation" _gitBareSequence
	
}



_test_bup() {
	! _wantDep bup && echo 'warn: no bup'
	
	! man tar | grep '\-\-one-file-system' > /dev/null 2>&1 && echo 'warn: tar does not support one-file-system' && return 1
	! man tar | grep '\-\-xattrs' > /dev/null 2>&1 && echo 'warn: tar does not support xattrs'
	! man tar | grep '\-\-acls' > /dev/null 2>&1 && echo 'warn: tar does not support acls'
}

_bupNew() {
	export BUP_DIR="./.bup"
	
	[[ -e "$BUP_DIR" ]] && return 1
	
	bup init
}

_bupLog() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	
	git --git-dir=./.bup log
}

_bupList() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	
	if [[ "$1" == "" ]]
	then
		bup ls "HEAD"
		return
	fi
	[[ "$1" != "" ]] && bup ls "$@"
}

_bupStore() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	
	! man tar | grep '\-\-one-file-system' > /dev/null 2>&1 && return 1
	! man tar | grep '\-\-xattrs' > /dev/null 2>&1 && return 1
	! man tar | grep '\-\-acls' > /dev/null 2>&1 && return 1
	
	if [[ "$1" == "" ]]
	then
		tar --one-file-system --xattrs --acls --exclude "$BUP_DIR" -cvf - . | bup split -n "HEAD" -vv
		return
	fi
	[[ "$1" != "" ]] && tar --one-file-system --xattrs --acls --exclude "$BUP_DIR" -cvf - . | bup split -n "$@" -vv
}

_bupRetrieve() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	
	! man tar | grep '\-\-one-file-system' > /dev/null 2>&1 && return 1
	! man tar | grep '\-\-xattrs' > /dev/null 2>&1 && return 1
	! man tar | grep '\-\-acls' > /dev/null 2>&1 && return 1
	
	if [[ "$1" == "" ]]
	then
		bup join "HEAD" | tar --one-file-system --xattrs --acls -xf -
		return
	fi
	[[ "$1" != "" ]] && bup join "$@" | tar --one-file-system --xattrs --acls -xf -
}

_here_mkboot_grubcfg() {
	
	cat << 'CZXWXcRMTo8EmM8i4d'
set default="0"
set timeout="1"

menuentry "Buildroot" {
    insmod gzio
    insmod part_msdos
    insmod ext2
CZXWXcRMTo8EmM8i4d

	local linuxImageName
	linuxImageName=$(ls "$chrootDir"/boot | grep vmlinuz | tail -n 1)
	local linuxInitRamFS
	linuxInitRamFS=$(ls "$chrootDir"/boot | grep initrd | tail -n 1)
	
	echo "linux (hd0,msdos1)/boot/""$linuxImageName"" root=/dev/sda1 rw console=tty0 console=ttyS0"
	echo "initrd /boot/""$linuxInitRamFS"

	cat << 'CZXWXcRMTo8EmM8i4d'
}
CZXWXcRMTo8EmM8i4d

}

#http://nairobi-embedded.org/making_a_qemu_disk_image_bootable_with_grub.html
_mkboot_sequence() {
	_start
	
	_mustGetSudo
	
	_readLocked "$lock_open_image" && _stop 1
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$scriptAbsoluteFolder"
	
	_messageNormal "#####Enabling boot."
	
	
	_messageProcess "Opening"
	if ! _openChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Testing mkdev"
	if ! sudo -n bash -c "type MAKEDEV" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	if ! _chroot bash -c "type MAKEDEV" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Testing grub-install"
	if ! sudo -n bash -c "type grub-install" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	if ! _chroot bash -c "type grub-install" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Testing grub-mkconfig"
	if ! _chroot bash -c "type grub-mkconfig" > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Installing GRUB"
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	#if ! sudo -n grub-install --root-directory="$chrootDir" --boot-directory="$chrootDir"/boot --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	if ! _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	
	_messagePASS
	
	
	_messageProcess "Configuring GRUB"
	
	_here_mkboot_grubcfg | sudo -n tee "$chrootDir"/boot/grub/grub.cfg > /dev/null 2>&1
	
	#if ! _chroot grub-mkconfig -o /boot/grub/grub.cfg >> "$logTmp"/grub.log 2>&1
	#then
	#	_messageFAIL
	#	_stop 1
	#fi
	
	_messagePASS
	
	_messageProcess "Constructing dev"
	_stopChRoot "$chrootDir" > /dev/null 2>&1
	_wait_umount "$chrootDir"/dev/shm
	_wait_umount "$chrootDir"/dev/pts
	_wait_umount "$chrootDir"/dev
	
	_chroot bash -c "cd /dev ; MAKEDEV generic"
	
	_messagePASS
	
	
	
	
	#_messageProcess "Installing GRUB"
	#
	#_stopChRoot "$chrootDir" > /dev/null 2>&1
	#_wait_umount "$chrootDir"/dev/shm
	#_wait_umount "$chrootDir"/dev/pts
	#_wait_umount "$chrootDir"/dev
	#
	#local imagedev
	#imagedev=$(cat "$scriptLocal"/imagedev)
	#
	#if ! sudo -n grub-install --root-directory="$chrootDir" --boot-directory="$chrootDir"/boot --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	#if ! _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos "$imagedev" >> "$logTmp"/grub.log 2>&1
	#then
	#	_messageFAIL
	#	_stop 1
	#fi
	#
	#_messagePASS
	
	_messageProcess "Closing"
	if ! _closeChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#rm "$logTmp"/grub.log
	cd "$localFunctionEntryPWD"
	_stop
}

_mkboot() {
	"$scriptAbsoluteLocation" _mkboot_sequence "$@"
}


_test_mkboot() {
	_mustGetSudo
	
	_getDep grub-install
	_getDep MAKEDEV
}

_testDistro() {
	_getDep sha256sum
	_getDep sha512sum
	_getDep axel
}

#"$1" == storageLocation (optional)
_test_fetchDebian() {
	if ! ls /usr/share/keyrings/debian-role-keys.gpg > /dev/null 2>&1
	then
		echo 'Debian Keyring missing.'
		echo 'apt-get install debian-keyring'
		_mustGetSudo
		sudo -n apt-get install -y debian-keyring
		! ls /usr/share/keyrings/debian-role-keys.gpg && _stop 1
	fi
}

_fetch_x64_debianLiteISO_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && export storageLocation=$(_getAbsoluteLocation "$1")
	
	_test_fetchDebian
	
	cd "$safeTmp"
	
	local debAvailableVersion
	#debAvailableVersion="current"	#Does not work, incorrect image name.
	#debAvailableVersion="9.1.0"
	#debAvailableVersion="9.2.1"
	debAvailableVersion="9.3.0"
	
	[[ -e "$storageLocation"/debian-"$debAvailableVersion"-amd64-netinst.iso ]] && cp "$storageLocation"/debian-"$debAvailableVersion"-amd64-netinst.iso ./debian-"$debAvailableVersion"-amd64-netinst.iso > /dev/null 2>&1
	[[ -e ./debian-"$debAvailableVersion"-amd64-netinst.iso ]] || _fetch 'https://cdimage.debian.org/debian-cd/'"$debAvailableVersion"'/amd64/iso-cd/debian-'"$debAvailableVersion"'-amd64-netinst.iso'
	
	wget 'https://cdimage.debian.org/debian-cd/'"$debAvailableVersion"'/amd64/iso-cd/SHA512SUMS'
	
	wget 'https://cdimage.debian.org/debian-cd/'"$debAvailableVersion"'/amd64/iso-cd/SHA512SUMS.sign'
	
	if ! cat SHA512SUMS | grep debian-"$debAvailableVersion"-amd64-netinst.iso | sha512sum -c - > /dev/null 2>&1
	then
		echo 'invalid'
		_stop 1
	fi
	
	if ! gpgv --keyring /usr/share/keyrings/debian-role-keys.gpg ./SHA512SUMS.sign ./SHA512SUMS
	then
		echo 'invalid'
		_stop 1
	fi
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/debian-"$debAvailableVersion"-amd64-netinst.iso "$storageLocation"
	
	_stop
}

_fetch_x64_DebianLiteISO() {
	
	"$scriptAbsoluteLocation" _fetch_x64_debianLiteISO_sequence "$@"
	
}

#Installs to a raw disk image using QEMU. Subsequently may be run under a variety of real and virtual platforms.
_create_x64_debianLiteVM_sequence() {
	_start
	
	_fetch_x64_DebianLiteISO || _stop 1
	
	_createRawImage
	
	_checkDep qemu-system-x86_64
	
	local debAvailableVersion
	#debAvailableVersion="current"	#Does not work, incorrect image name.
	#debAvailableVersion="9.1.0"
	#debAvailableVersion="9.2.1"
	debAvailableVersion="9.3.0"
	
	qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -cdrom "$scriptAbsoluteFolder"/_lib/os/debian-"$debAvailableVersion"-amd64-netinst.iso -boot d -m 1536
	
	_stop
}

_create_x64_debianLiteVM() {
	
	"$scriptAbsoluteLocation" _create_x64_debianLiteVM_sequence "$@"
	
}

_create_arm_debianLiteVM() {
	true
}



#####

_fetch_raspbian_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && export storageLocation=$(_getAbsoluteLocation "$1")
	
	cd "$safeTmp"
	
	[[ -e "$storageLocation"/2017-09-07-raspbian-stretch.zip ]] && cp "$storageLocation"/2017-09-07-raspbian-stretch.zip ./2017-09-07-raspbian-stretch.zip > /dev/null 2>&1
	[[ -e ./2017-09-07-raspbian-stretch.zip ]] || _fetch 'https://downloads.raspberrypi.org/raspbian/images/raspbian-2017-09-08/2017-09-07-raspbian-stretch.zip'
	
	wget https://downloads.raspberrypi.org/raspbian/images/raspbian-2017-09-08/2017-09-07-raspbian-stretch.zip.sha256
	
	if ! cat 2017-09-07-raspbian-stretch.zip.sha256 | grep 2017-09-07-raspbian-stretch.zip | sha256sum -c - > /dev/null 2>&1
	then
		echo 'invalid'
		_stop 1
	fi
	
	#Raspbian signature is difficult to authenticate. Including hash here allows some trust to be established from a Git/SSH server, as well HTTPS generally.
	if [[ "$(cat 2017-09-07-raspbian-stretch.zip.sha256 | cut -f1 -d\  )" != "a64d742bc525b548f0435581fac5876b50a4e9ba1d1cd6433358b4ab6c7a770b" ]]
	then
		echo 'invalid'
		_stop 1
	fi
	
	mkdir -p "$storageLocation"
	
	cd "$functionEntryPWD"
	mv "$safeTmp"/2017-09-07-raspbian-stretch.zip "$storageLocation"
	
	
	
	_stop
}

_fetch_raspbian() {
	
	"$scriptAbsoluteLocation" _fetch_raspbian_sequence "$@"
	
}

_create_raspbian_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	_fetch_raspbian || _stop 1
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	
	cd "$storageLocation"
	
	unzip "$scriptAbsoluteFolder"/_lib/os/2017-09-07-raspbian-stretch.zip
	
	export raspbianImageFile="$scriptLocal"/vm-raspbian.img
	
	[[ ! -e "$raspbianImageFile" ]] && mv "$scriptAbsoluteFolder"/_lib/os/2017-09-07-raspbian-stretch.img "$raspbianImageFile"
	
	cd "$functionEntryPWD"
	
	_stop
}

_create_raspbian() {
	
	"$scriptAbsoluteLocation" _create_raspbian_sequence "$@"
	
}

#Installs to a raw disk image using VirtualBox. Subsequently may be run under a variety of real and virtual platforms.
_create_msw_vbox_sequence() {
	_start
	
	[[ ! -e "$scriptLocal"/msw.iso ]] && _stop 1
	
	#[[ "$vmSize" == "" ]] && export vmSize="15256"
	[[ "$vmSize" == "" ]] && export vmSize="30256"
	
	[[ ! -e "$scriptLocal"/vm.img ]] && [[ ! -e "$scriptLocal"/vm.vdi ]] && _createRawImage
	
	_checkDep VBoxManage
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	_create_instance_vbox "$@"
	
	#####Actually mount MSW ISO.
	VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$scriptLocal"/msw.iso
	
	env HOME="$VBOX_USER_HOME_short" VirtualBox
	
	_wait_instance_vbox
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type multiattach
	
	rm -f "$vBox_vdi" > /dev/null 2>&1
	
	_rm_instance_vbox
	
	_stop
}

_create_msw_vbox() {
	"$scriptAbsoluteLocation" _create_msw_vbox_sequence "$@"
}


#Installs to a raw disk image using QEMU. Subsequently may be run under a variety of real and virtual platforms.
_create_msw_qemu_sequence() {
	_start
	
	[[ ! -e "$scriptLocal"/msw.iso ]] && _stop 1
	
	#[[ "$vmSize" == "" ]] && export vmSize="15256"
	[[ "$vmSize" == "" ]] && export vmSize="30256"
	
	[[ ! -e "$scriptLocal"/vm.img ]] && _createRawImage
	
	_checkDep qemu-system-x86_64
	
	qemu-system-x86_64 -smp 4 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -cdrom "$scriptLocal"/msw.iso -boot d -m 1536 -net nic,model=rtl8139 -net user -usbdevice tablet -vga cirrus -show-cursor
	
	_stop
}

_create_msw_qemu() {
	"$scriptAbsoluteLocation" _create_msw_qemu_sequence "$@"
}

_create_msw() {
	_create_msw_vbox "$@"
}

_testX11() {
	_getDep xclip
	
	_getDep xinput
}

_report_xi() {
	_messagePlain_probe "$xi_devID"
	_messagePlain_probe "$xi_state"
	_messagePlain_probe "$xi_propNumber"
} 

_x11_clipboard_sendText() {
	xclip -selection clipboard
	#xclip -selection primary
	#xclip -selection secondary
}

_x11_clipboard_getImage() {
	xclip -selection clipboard -t image/png -o -
}

_x11_clipboard_getImage_base64() {
	_x11_clipboard_getImage | base64 -w0
}

_x11_clipboard_getImage_HTML() {
	echo -e -n '<img src="data:image/png;base64,'
	_x11_clipboard_getImage_base64
	echo -e -n '" />'
}

_x11_clipboard_imageToHTML() {
	_x11_clipboard_getImage_HTML | _x11_clipboard_sendText
}

[[ "$DISPLAY" != "" ]] && alias _clipImageHTML=_x11_clipboard_imageToHTML

#KDE can lockup for many reasons, including xrandr, xsetwacom operations. Resetting the driving applications can be an effective workaround to improve reliability.
_reset_KDE() {
	if pgrep plasmashell
	then
		kquitapp plasmashell ; sleep 3 ; plasmashell &
	fi
}

_test_vboxconvert() {
	_getDep VBoxManage
}

_vdi_to_img() {
	VBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format RAW
}

#No production use. Not recommended except to accommodate MSW hosts.
_img_to_vdi() {
	VBoxManage convertdd "$scriptLocal"/vm.vdi "$scriptLocal"/vm.img --format VDI 
}

#No production use. Take care to ensure neither "vm.vdi" nor "/dev/nbd0" are not in use.
_vdi_gparted() {
	sudo -n modprobe nbd
	sudo -n qemu-nbd -c /dev/nbd0 "$scriptLocal"/vm.vdi
	
	sudo -n partprobe
	
	kdesudo gparted /dev/nbd0
	
	sudo -n qemu-nbd -d /dev/nbd0
}

#No production use.
_vdi_resize() {
	mv "$scriptLocal"/vm.vdi "$scriptLocal"/vm-big.vdi
	
	#Accommodates 8024MiB.
	VBoxManage createhd --filename "$scriptLocal"/vm-small.vdi --size 8512
	
	sudo -n modprobe nbd max_part=15
	sudo -n qemu-nbd -c /dev/nbd0 "$scriptLocal"/vm-big.vdi
	sudo -n qemu-nbd -c /dev/nbd1 "$scriptLocal"/vm-small.vdi
	sudo -n partprobe
	
	#sudo -n dd if=/dev/nbd0 of=/dev/nbd1 bs=446 count=1
	sudo -n dd if=/dev/nbd0 of=/dev/nbd1 bs=1M count=8512
	sudo -n partprobe
	
	
	
	
	
	
	
	kdesudo gparted /dev/nbd0 /dev/nbd1
	
	sudo -n qemu-nbd -d /dev/nbd0
	sudo -n qemu-nbd -d /dev/nbd1
	
	mv "$scriptLocal"/vm-small.vdi "$scriptLocal"/vm.vdi
	
	#qemu-img convert -f vdi -O qcow2 vm.vdi vm.qcow2
	#qemu-img resize vm.qcow2 8512M
	
	#VBoxManage clonehd "$scriptLocal"/vm.vdi "$scriptLocal"/vm-small.vdi --existing
	#VBoxManage modifyhd "$scriptLocal"/vm-small.vdi --resize 8512
}

#Show all images in repository.
_dockerImages() {
	_permitDocker docker images "$@"
}

#Show all containers in repository.
_dockerContainers() {
	_permitDocker docker ps -a "$@"
}

#Show all running containers.
_dockerRunning() {
	_permitDocker docker ps "$@"
}

_dockerLocal_sequence() {
	_start
	_prepare_docker
	_prepare_docker_directives
	
	_messageNormal '$dockerObjectName'
	echo "$dockerObjectName"
	_messageNormal '$dockerBaseObjectName'
	echo "$dockerBaseObjectName"
	_messageNormal '$dockerImageObjectName'
	echo "$dockerImageObjectName"
	_messageNormal '$dockerContainerObjectName'
	echo "$dockerContainerObjectName"
	_messageNormal '$dockerContainerObjectNameInstanced'
	echo "$dockerContainerObjectNameInstanced"
	
	_stop
}

#Show local docker container, image, and base name.
_dockerLocal() {
	"$scriptAbsoluteLocation" _dockerLocal_sequence "$@"
}

# WARNING Deletes specified docker IMAGE.
_dockerDeleteImage() {
	_permitDocker docker rmi "$@"
}

_dockerDeleteContainer() {
	_permitDocker docker rm "$@"
}

# WARNING Deletes all docker containers.
_dockerDeleteContainersAll() {
	_dockerDeleteContainer $(_dockerContainers -q)
}

# DANGER Deletes all docker images!
_dockerDeleteImagesAll() {
	_dockerDeleteImage --force $(_dockerImages -q)
}

# DANGER Deletes all docker assets not clearly in use!
_dockerPrune() {
	echo y | _permitDocker docker system prune
}

_dockerDeleteAll() {
	_dockerDeleteContainersAll
	_dockerDeleteImagesAll
	_dockerPrune
}

_docker_deleteContainerInstance_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerContainerObjectNameInstanced" != "" ]] && _dockerDeleteContainer "$dockerContainerObjectNameInstanced"
	
	_stop
}

_docker_deleteContainerInstance() {
	"$scriptAbsoluteLocation" _docker_deleteContainerInstance_sequence "$@"
}

_docker_deleteLocal_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerContainerObjectName" != "" ]] && _dockerDeleteContainer "$dockerContainerObjectName"
	[[ "$dockerImageObjectName" != "" ]] && _dockerDeleteImage --force "$dockerImageObjectName"
	
	_stop
}

_docker_deleteLocal() {
	"$scriptAbsoluteLocation" _docker_deleteLocal_sequence "$@"
}

_docker_deleteLocalBase_sequence() {
	_start
	_prepare_docker
	
	[[ "$dockerBaseObjectName" != "" ]] && _dockerDeleteImage "$dockerBaseObjectName"
	
	_stop
}

_docker_deleteLocalAll() {
	"$scriptAbsoluteLocation" _docker_deleteLocal_sequence "$@"
	"$scriptAbsoluteLocation" _docker_deleteLocalBase_sequence "$@"
}


_test_docker_mkimage() {
	_getDep "debootstrap"
}

_create_docker_mkimage_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Searching ""$dockerBaseObjectName"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	_messageProcess "Locating mkimage"
	cd "$dockerMkimageAbsoluteDirectory"
	[[ ! -e "./mkimage.sh" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Checking sudo"
	! _wantSudo && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Building ""$dockerBaseObjectName"
	cd "$dockerMkimageAbsoluteDirectory"
	
	#Script "mkimage.sh" from "moby" repository is "not part of the core docker distribution". Frequent updates to code requesting operations from such a script may be expected.
	#Commands here were tested with "mkimage.sh" script from "moby" git repository, URL "https://github.com/moby/moby.git", commit a4bdb304e29f21661e8ef398dbaeb8188aa0f46a .
	
	[[ $dockerMkimageDistro == "debian" ]] ; sudo -n ./mkimage.sh -t "$dockerBaseObjectName" debootstrap --variant=minbase --components=main --include=inetutils-ping,iproute "$dockerMkimageVersion" 2>> "$logTmp"/mkimageErr > "$logTmp"/mkimageOut
	
	cd "$scriptAbsoluteFolder"
	
	
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/mkimageErr > /dev/null 2>&1
	rm -f "$logTmp"/mkimageOut > /dev/null 2>&1
	
	_stop
}

_create_docker_scratch_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Searching ""$dockerBaseObjectName"
	[[ "$dockerBaseObjectExists" == "true" ]] && _messageHAVE && _stop
	_messageNEED
	
	mkdir -p "$safeTmp"/dockerbase
	cd "$safeTmp"/dockerbase
	
	_messageProcess "Building ""$dockerBaseObjectName"
	tar cv --files-from /dev/null | _permitDocker docker import - "$dockerBaseObjectName" 2> /dev/null > "$logTmp"/buildBase.log
	
	cd "$scriptAbsoluteFolder"
	
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/buildBase.log > /dev/null 2>&1
	
	_stop
}

_create_docker_scratch() {
	"$scriptAbsoluteLocation" _create_docker_scratch_sequence "$@"
}

_create_docker_debiansqueeze() {
	"$scriptAbsoluteLocation" _create_docker_mkimage_sequence "$@"
}

_create_docker_debianjessie() {
	"$scriptAbsoluteLocation" _create_docker_mkimage_sequence "$@"
}

_create_docker_base() {
	_messageNormal "#####Base."
	
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	
	_messageProcess "Evaluating ""$dockerBaseObjectName"
	
	[[ "$dockerBaseObjectName" == "" ]] && _messageError "BLANK" && return 0
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _messagePASS && _create_docker_scratch && return 0
	
	#[[ "$dockerBaseObjectName" == "ubvrt/debian:squeeze" ]] && _messagePASS && _create_docker_debiansqueeze && return
	[[ "$dockerBaseObjectName" == "ubvrt/debian:jessie" ]] && _messagePASS && _create_docker_debianjessie && return 0
	
	if [[ "$dockerBaseObjectName" == *"ubvrt"* ]]
	then
		[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && return 1
		_messagePASS
		return 0
	fi
	
	_messageWARN "No local build instructons operating, will rely on upstream provider."
	return 0
}

_create_docker_image_needed_sequence() {
	_start
	_prepare_docker
	
	_messageNormal "#####PreImage."
	_messageProcess "Validating ""$dockerImageObjectName"
	[[ "$dockerImageObjectName" == "" ]] && _messageError "BLANK" && _stop 1
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_messageProcess "Loading ""$dockerImageObjectName"
	"$scriptAbsoluteLocation" _dockerLoad
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_messageProcess "Importing ""$dockerImageObjectName"
	"$scriptAbsoluteLocation" _dockerImport
	_messagePASS
	
	_messageProcess "Searching ""$dockerImageObjectName"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	[[ "$dockerImageObjectExists" == "true" ]]  && _messageHAVE && _stop 2
	_messageNEED
	
	_stop
}

_create_docker_image_sequence() {
	_start
	_prepare_docker
	
	_create_docker_base || _stop 1
	
	_messageNormal "#####Image."
	mkdir -p "$safeTmp"/dockerimage
	cd "$safeTmp"/dockerimage
	
	_prepare_docker_directives
	_pull_docker_guest
	
	_messageProcess "Checking context "
	[[ ! -e "$dockerdirectivefile" ]] && _messageFAIL && _stop 1
	[[ ! -e "$dockerentrypoint" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Building ""$dockerImageObjectName"
	
	_permitDocker docker build --rm --tag "$dockerImageObjectName" . 2> "$logTmp"/buildImageErr.log > "$logTmp"/buildImageOut.log
	
	cd "$scriptAbsoluteFolder"
	
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	rm -f "$logTmp"/buildImageErr.log > /dev/null 2>&1
	rm -f "$logTmp"/buildImageOut.log > /dev/null 2>&1
	
	_stop
}

_create_docker_image() {
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && export dockerBaseObjectName="$1"
	[[ "$dockerImageObjectName" == "" ]] && [[ "$2" != "" ]] && export dockerImageObjectName="$2"
	
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "2" ]] && return 0
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	if ! "$scriptAbsoluteLocation" _create_docker_image_sequence
	then
		return 1
	fi
	
	if ! "$scriptAbsoluteLocation" _dockerExport
	then
		return 1
	fi
	
	return 0
}

_create_docker_container_sequence_partial() {
	local dockerContainerToCreate
	dockerContainerToCreate="$dockerContainerObjectName"
	[[ "$1" != "" ]] && dockerContainerToCreate="$1"
	
	_messageNormal "#####Container."
	_messageProcess "Validating ""$dockerContainerToCreate"
	[[ "$dockerContainerToCreate" == "" ]] && _messageError "BLANK" && return 1
	_messagePASS
	
	_messageProcess "Searching ""$dockerContainerToCreate"
	
	local dockerContainerToCreateExists
	dockerContainerToCreateExists="false"
	local dockerContainerToCreateID
	dockerContainerToCreateID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerToCreate"'$')
	[[ "$dockerContainerToCreateID" != "" ]] && dockerContainerToCreateExists="$true"
	
	[[ "$dockerContainerToCreateExists" == "true" ]]  && _messageHAVE && return
	_messageNEED
	
	_messageProcess "Building ""$dockerContainerToCreate"
	
	mkdir -p "$safeTmp"
	cd "$safeTmp"
	
	#_prepare_docker_directives
	
	_permitDocker docker create -t -i --name "$dockerContainerToCreate" "$dockerImageObjectName" 2> "$logTmp"/buildContainer.log > "$logTmp"/buildContainer.log
	
	cd "$scriptAbsoluteFolder"
	
	local dockerIDcheck
	dockerIDcheck=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerToCreate"'$')
	[[ "$dockerIDcheck" == "" ]]  && _messageFAIL && return 1
	
	_messagePASS
	rm -f "$logTmp"/buildContainer.log > /dev/null 2>&1
}

_create_docker_container_sequence() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$@"
	then
		_stop 1
	fi
	
	_stop
}

_create_docker_container() {
	if ! "$scriptAbsoluteLocation" _create_docker_image "$@"
	then
		return 1
	fi
	
	if "$scriptAbsoluteLocation" _create_docker_container_sequence "$@"
	then
		return 0
	fi
	return 1
}

#Will not attempt to create image/base from scratch.
_create_docker_container_quick() {
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	
	if "$scriptAbsoluteLocation" _create_docker_container_sequence "$@"
	then
		return 0
	fi
	return 1
}

# WARNING Serves as an example. Most use cases for instanced containers REQUIRE the container creation command to share session with other operations. See _dockerExport .
_create_docker_container_sequence_instanced() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$dockerContainerObjectNameInstanced"
	then
		_stop 1
	fi
	
	_stop
}

# WARNING Serves as an example. Most use cases for instanced containers REQUIRE the image creation command to run in a fresh instance. See _dockerExport .
_create_docker_container_instanced() {
	if ! _create_docker_image "$@"
	then
		return 1
	fi
	
	#Alternative, quicker, check for image, will not create image/base from scratch.
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	_create_docker_container_sequence_instanced || return 1
	
	return 0
}


_docker_img_enboot_sequence() {
	_start
	
	_mustGetSudo
	
	_readLocked "$lock_open_image" && _stop 1
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$scriptAbsoluteFolder"
	
	_messageNormal "#####Disabling docker."
	
	_messageProcess "Sanity"
	[[ "$chrootDir" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Opening"
	if ! _openChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#Debian image, created by mkimage, is bootable without further docker-specific and/or automation suitable modifications as of 11-12-2017 .
	
	_messageProcess "Enabling fstab"
	[[ -e "$chrootDir"/etc/fstab.dsv ]] && sudo -n mv "$chrootDir"/etc/fstab.dsv "$chrootDir"/etc/fstab
	_messagePASS
	
	_messageProcess "Enabling resolv"
	[[ -e "$chrootDir"/etc/resolv.conf.dsv ]] && sudo -n mv "$chrootDir"/etc/resolv.conf.dsv "$chrootDir"/etc/resolv.conf
	_messagePASS
	
	_messageProcess "Closing"
	if ! _closeChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#rm "$logTmp"/log.log
	cd "$localFunctionEntryPWD"
	_stop
}

#Only use to reverse docker specific boot impediments. Install bootloader as part of ChRoot functionality.
#http://mr.gy/blog/build-vm-image-with-docker.html
#http://www.olafdietsche.de/2016/03/24/debootstrap-bootable-image
_docker_img_enboot() {
	"$scriptAbsoluteLocation" _docker_img_enboot_sequence
}

_docker_img_endocker_sequence() {
	_start
	
	_mustGetSudo
	
	_readLocked "$lock_open_image" && _stop 1
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$scriptAbsoluteFolder"
	
	_messageNormal "#####Enabling docker."
	
	_messageProcess "Sanity"
	[[ "$chrootDir" == "" ]] && _messageFAIL && _stop 1
	_messagePASS
	
	_messageProcess "Opening"
	if ! _openChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Removing user"
	if ! _removeUserChRoot_sequence
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	_messageProcess "Disabling fstab"
	[[ -s "$chrootDir"/etc/fstab ]] && sudo -n mv "$chrootDir"/etc/fstab "$chrootDir"/etc/fstab.dsv > /dev/null 2>&1
	echo | sudo -n tee > /dev/null "$chrootDir"/etc/fstab
	_messagePASS
	
	_messageProcess "Disabling resolv"
	[[ -s "$chrootDir"/etc/resolv.conf ]] &&  sudo -n mv "$chrootDir"/etc/resolv.conf "$chrootDir"/etc/resolv.conf.dsv > /dev/null 2>&1
	echo | sudo -n tee > /dev/null "$chrootDir"/etc/resolv.conf
	_messagePASS
	
	_messageProcess "Closing"
	if ! _closeChRoot > /dev/null 2>&1
	then
		_messageFAIL
		_stop 1
	fi
	_messagePASS
	
	#rm "$logTmp"/log.log
	cd "$localFunctionEntryPWD"
	_stop
}

#Reverse operations performed by _docker_img_enboot .
_docker_img_endocker() {
	"$scriptAbsoluteLocation" _docker_img_endocker_sequence
}

_docker_img_to_tar_sequence() {
	_mustGetSudo
	
	_start
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	_openImage
	
	
	
	cd "$globalVirtFS"
	
	sudo -n tar --selinux --acls --xattrs -cpf "$scriptLocal"/"dockerImageFS".tar ./ --exclude '/lost+found'
	
	cd "$localFunctionEntryPWD"
	
	#
	
	cd "$localFunctionEntryPWD"
	_closeImage
	
	_stop
}


_docker_img_to_tar() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	! [[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Copying files"
	"$scriptAbsoluteLocation" _docker_img_to_tar_sequence
	_messagePASS
	
	_messageProcess "Validating readiness"
	_readLocked "$lock_open" && _messageFAIL && return 1
	_readLocked "$lock_opening" && _messageFAIL && return 1
	_readLocked "$lock_closing" && _messageFAIL && return 1
	_readLocked "$lock_emergency" && _messageFAIL && return 1
	_messagePASS
	
	
	return 0
}

_docker_tar_to_img_sequence() {
	_mustGetSudo
	
	_start
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	_openImage
	
	_messageProcess "Copying files"
	cd "$globalVirtFS"
	
	#if ! sudo -n tar --selinux --acls --xattrs xpf "$scriptLocal"/"dockerImageFS".tar
	if ! sudo -n tar xpf "$scriptLocal"/"dockerImageFS".tar
	then
		_messageFAIL
		_stop 1
	fi
	
	#[[ ! -e '/dev' ]] && _messageFAIL && _stop 1
	
	_messagePASS
	cd "$localFunctionEntryPWD"
	
	#
	
	cd "$localFunctionEntryPWD"
	_closeImage
	
	_stop
}

#http://mr.gy/blog/build-vm-image-with-docker.html
_docker_tar_to_img() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/vm*.img ]] && _messageFAIL && return 1
	! [[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Creating raw"
	_createRawImage
	! [[ -e "$scriptLocal"/vm.img ]] && _messageFAIL && return 1
	_messagePASS
	
	
	_messageProcess "Creating partition"
	if ! _createPartition
	then
		_messageFAIL
		return 1
	fi
	_messagePASS
	
	_messageProcess "Creating FS"
	if ! _createFS
	then
		_messageFAIL
		return 1
	fi
	_messagePASS
	
	"$scriptAbsoluteLocation" _docker_tar_to_img_sequence
	
	
	_messageProcess "Validating readiness"
	_readLocked "$lock_open" && _messageFAIL && return 1
	_readLocked "$lock_opening" && _messageFAIL && return 1
	_readLocked "$lock_closing" && _messageFAIL && return 1
	_readLocked "$lock_emergency" && _messageFAIL && return 1
	_messagePASS
	
	
	return 0
}

# WARNING In automated use, the load command may not result in an image name matching the path locked docker id.
_docker_load() {
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _permitDocker docker load < "$scriptLocal"/"dockerImageAll".tar
}

_dockerLoad() {
	_docker_load "$@"
}

_docker_save_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker save "$dockerImageObjectName" > "$scriptLocal"/"dockerImageAll".tar
	
	_stop
}

#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
_docker_save() {
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	#[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_messageProcess "Saving ""$dockerImageObjectName"
	
	"$scriptAbsoluteLocation" _docker_save_sequence "$@"
	
	 ! [[ -s "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	 _messagePASS
	 return 0
}

_dockerSave() {
	_docker_save "$@"
}

#Docker Portation.
#https://english.stackexchange.com/questions/141717/hypernym-for-import-and-export
#https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-via-repository
#http://mr.gy/blog/build-vm-image-with-docker.html
#These import/export functions had no production use in DockerApp. However, they produce bootable images, so are used for translation in ubiquitous_bash. Prefer _docker_save and _docker_load 

#Import filesystem as Docker image.
#"$1" == containerObjectName
#Import filesystem as Docker image.
#"$1" == containerObjectName
_dockerImport() {
	if [[ -e "$scriptLocal"/"dockerImageFS".tar ]]
	then
		_permitDocker docker import "$scriptLocal"/"dockerImageFS".tar "$dockerImageObjectName" --change 'ENTRYPOINT ["/usr/local/bin/ubiquitous_bash.sh", "_drop_docker"]' > /dev/null 2>&1
	fi
	
	# WARNING Untested. Not recommended.
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _permitDocker docker import "$scriptLocal"/"dockerContainerFS".tar "$dockerImageObjectName" > /dev/null 2>&1
}

_dockerExportContainer_named() {
	local dockerNamedID
	dockerNamedID=$(_permitDocker docker ps -a -q --filter name='^/'"$1"'$')
	
	 _permitDocker docker export "$dockerNamedID" > "$2"
}

_dockerExportContainer_sequence() {
	_start
	_prepare_docker
	
	_messageProcess "Exporting ""$dockerContainerObjectName"
	
	rm -f "$scriptLocal"/"dockerContainerFS".tar > /dev/null 2>&1
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	
	_dockerExportContainer_named "$dockerContainerObjectName" "$scriptLocal"/"dockerContainerFS".tar
	
	! [[ -s "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && _stop 1
	 _messagePASS
	 _stop 0
}

_dockerExportImage_sequence() {
	_start
	_prepare_docker
	
	if ! _create_docker_container_sequence_partial "$dockerContainerObjectNameInstanced"
	then
		_stop 1
	fi
	
	_messageProcess "Exporting ""$dockerContainerObjectNameInstanced"
	
	rm -f "$scriptLocal"/"dockerImageFS".tar > /dev/null 2>&1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && _stop 1
	
	_dockerExportContainer_named "$dockerContainerObjectNameInstanced" "$scriptLocal"/"dockerImageFS".tar
	
	! [[ -s "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && _stop 1
	 _messagePASS
	 _stop 0
}

# WARNING Recommend preforming commit operations first, then either _dockerExport or preferably _docker_save .
#Export Docker Container Filesystem. Will be restored as an image, NOT a container, resulting in operations equivalent to commit/import.
_dockerExportContainer() {
	_messageProcess "Searching conflicts"
	#[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	_create_docker_container || return 1
	
	"$scriptAbsoluteLocation" _dockerExportContainer_sequence "$@"
}

# WARNING Recommend _docker_save instead for images built within docker, not needed by other virtualization platforms, and not subject to path locking.
#Export Docker Image Filesystem (by exporting instanced container).
#"$1" == containerObjectName
_dockerExport() {
	[[ "$recursionGuard" == "true" ]] && return 0
	export recursionGuard="true"
	
	_messageProcess "Searching conflicts"
	[[ -e "$scriptLocal"/"dockerContainerFS".tar ]] && _messageFAIL && return 1
	#[[ -e "$scriptLocal"/"dockerImageFS".tar ]] && _messageFAIL && return 1
	[[ -e "$scriptLocal"/"dockerImageAll".tar ]] && _messageFAIL && return 1
	_messagePASS
	
	if ! _create_docker_image "$@"
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerExportImage_sequence "$@"
}



_dockerCommit_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker commit "$dockerContainerObjectName" "$dockerImageObjectName"
	
	_stop
}

_dockerCommit() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerCommit_sequence "$@"
	return "$?"
}

_dockerLaunch_sequence() {
	_start
	_prepare_docker
	
	
	
	_permitDocker docker start -ia "$dockerContainerObjectName"
	
	_stop
}

_dockerLaunch() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerLaunch_sequence "$@"
	return "$?"
}

_dockerAttach_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker attach "$dockerContainerObjectName"
	
	_stop
}

_dockerAttach() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerAttach_sequence "$@"
	return "$?"
}

_dockerOn_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker start "$dockerContainerObjectName"
	
	_stop
}


_dockerOn() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerOn_sequence
	return "$?"
}

_dockerOff_sequence() {
	_start
	_prepare_docker
	
	_permitDocker docker stop -t 10 "$dockerContainerObjectName"
	
	_stop
}

_dockerOff() {
	_findInfrastructure_virtImage ${FUNCNAME[0]} "$@"
	[[ "$ubVirtImageLocal" == "false" ]] && return
	
	if ! "$scriptAbsoluteLocation" _create_docker_container_quick > /dev/null 2>&1
	then
		return 1
	fi
	
	"$scriptAbsoluteLocation" _dockerOff_sequence
	return "$?"
}

_dockerEnter() {
	_dockerLaunch "$@"
}

#No production use. Recommend _dockerUser instead.
dockerRun_command() {
	local dockerRunArgs
	
	mkdir -p "$scriptLocal"/_ddata
	dockerRunArgs+=(-v "$scriptLocal"/_ddata:/mnt/_ddata:rw)
	
	_permitDocker docker run -it --name "$dockerContainerObjectName"_rt --rm "${dockerRunArgs[@]}" "$dockerImageObjectName" "$@"
}

_dockerRun_sequence() {
	_start
	_prepare_docker
	
	dockerRun_command "$@"
	
	_stop "$?"
}

#No production use. Recommend _dockerUser instead.
_dockerRun() {
	local dockerImageNeeded
	"$scriptAbsoluteLocation" _create_docker_image_needed_sequence > /dev/null 2>&1
	dockerImageNeeded="$?"
	[[ "$dockerImageNeeded" == "0" ]] && return 1
	[[ "$dockerImageNeeded" == "1" ]] && return 1
	
	"$scriptAbsoluteLocation" _dockerRun_sequence "$@"
	return "$?"
}

_test_gparted() {
	_getDep gparted
}

_gparted_sequence() {
	_start
	
	_mustGetSudo
	
	_openLoop || _stop 1
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	sudo -n gparted "$imagedev"
	
	_closeLoop || _stop 1
	
	_stop
}

_gparted() {
	"$scriptAbsoluteLocation" _gparted_sequence
}

_setupUbiquitous_here() {
	cat << CZXWXcRMTo8EmM8i4d
type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1 && sudo -n renice -n -10 -p \$\$ > /dev/null 2>&1

export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptFolder="$ubcoreUBdir"
[[ "\$scriptAbsoluteLocation" != "" ]] && . "\$scriptAbsoluteLocation" --parent _importShortcuts
[[ "\$scriptAbsoluteLocation" == "" ]] && . "\$profileScriptLocation" --profile _importShortcuts

renice -n 0 -p \$\$ > /dev/null 2>&1

true
CZXWXcRMTo8EmM8i4d
}

_configureLocal() {
	_configureFile "$1" "_local"
}

_configureFile() {
	cp "$scriptAbsoluteFolder"/"$1" "$scriptAbsoluteFolder"/"$2"
}

_configureOps() {
	echo "$@" >> "$scriptAbsoluteFolder"/ops
}

_resetOps() {
	rm "$scriptAbsoluteFolder"/ops
}

_importShortcuts() {
	_tryExec "_resetFakeHomeEnv"
	
	if ! [[ "$PATH" == *":""$HOME""/bin"* ]] && ! [[ "$PATH" == "$HOME""/bin"* ]] && [[ -e "$HOME"/bin ]] && [[ -d "$HOME"/bin ]]
	then
		export PATH="$PATH":"$HOME"/bin
	fi
	
	_tryExec "_visualPrompt"
	
	_tryExec "_scopePrompt"
}

_gitPull_ubiquitous() {
	git pull
}

_gitClone_ubiquitous() {
	git clone --depth 1 git@github.com:mirage335/ubiquitous_bash.git
}

_selfCloneUbiquitous() {
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$ubcoreUBdir"/ > /dev/null 2>&1
	cp -a "$scriptAbsoluteFolder"/lean.sh "$ubcoreUBdir"/lean.sh > /dev/null 2>&1
	cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/ubiquitous_bash.sh
}

_installUbiquitous() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	cd "$ubcoreDir"
	
	cd "$ubcoreUBdir"
	_messagePlain_nominal 'attempt: git pull'
	if [[ "$nonet" != "true" ]] && type git > /dev/null 2>&1
	then
		
		local ub_gitPullStatus
		git pull
		ub_gitPullStatus="$?"
		! cd "$localFunctionEntryPWD" && return 1
		
		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: git pull' cd "$localFunctionEntryPWD" && return 0
	fi
	_messagePlain_warn 'fail: git pull'
	
	cd "$ubcoreDir"
	_messagePlain_nominal 'attempt: git clone'
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ ! -e ".git" ]] && _gitClone_ubiquitous && _messagePlain_good 'pass: git clone' && return 0
	_messagePlain_warn 'fail: git clone'
	
	cd "$ubcoreDir"
	_messagePlain_nominal 'attempt: self clone'
	[[ -e ".git" ]] && _messagePlain_bad 'fail: self clone' && return 1
	_selfCloneUbiquitous && return 0
	_messagePlain_bad 'fail: self clone' && return 1
	
	return 0
	
	cd "$localFunctionEntryPWD"
}


_setupUbiquitous() {
	_messageNormal "init: setupUbiquitous"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	export ubcoreFile="$ubcoreDir"/.ubcorerc
	
	export ubcoreUBdir="$ubcoreDir"/ubiquitous_bash
	export ubcoreUBfile="$ubcoreDir"/ubiquitous_bash/ubiquitous_bash.sh
	
	_messagePlain_probe 'ubHome= '"$ubHome"
	_messagePlain_probe 'ubcoreDir= '"$ubcoreDir"
	_messagePlain_probe 'ubcoreFile= '"$ubcoreFile"
	
	_messagePlain_probe 'ubcoreUBdir= '"$ubcoreUBdir"
	_messagePlain_probe 'ubcoreUBfile= '"$ubcoreUBfile"
	
	mkdir -p "$ubcoreUBdir"
	! [[ -e "$ubcoreUBdir" ]] && _messagePlain_bad 'missing: ubcoreUBdir= '"$ubcoreUBdir" && _messageFAIL && return 1
	
	
	_messageNormal "install: setupUbiquitous"
	! _installUbiquitous && _messageFAIL && return 1
	! [[ -e "$ubcoreUBfile" ]] && _messagePlain_bad 'missing: ubcoreUBfile= '"$ubcoreUBfile" && _messageFAIL && return 1
	
	
	_messageNormal "hook: setupUbiquitous"
	! _permissions_ubiquitous_repo "$ubcoreUBdir" && _messagePlain_bad 'permissions: ubcoreUBdir = '"$ubcoreUBdir" && _messageFAIL && return 1
	
	mkdir -p "$ubHome"/bin/
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/ubiquitous_bash.sh
	
	_setupUbiquitous_here > "$ubcoreFile"
	! [[ -e "$ubcoreFile" ]] && _messagePlain_bad 'missing: ubcoreFile= '"$ubcoreFile" && _messageFAIL && return 1
	
	
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_probe "$ubcoreFile"' >> '"$ubHome"/.bashrc && echo ". ""$ubcoreFile" >> "$ubHome"/.bashrc
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_bad 'missing: bashrc hook' && _messageFAIL && return 1
	
	
	echo "Now import new functionality into current shell if not in current shell."
	echo ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
	
	
	return 0
}

_setupUbiquitous_nonet() {
	local oldNoNet
	oldNoNet="$nonet"
	export nonet="true"
	_setupUbiquitous "$@"
	[[ "$oldNoNet" != "true" ]] && export nonet="$oldNoNet"
}

_upgradeUbiquitous() {
	_setupUbiquitous
}

_resetUbiquitous_sequence() {
	_start
	
	[[ ! -e "$HOME"/.bashrc ]] && return 0
	cp "$HOME"/.bashrc "$HOME"/.bashrc.bak
	cp "$HOME"/.bashrc "$safeTmp"/.bashrc
	grep -v 'ubcore' "$safeTmp"/.bashrc > "$safeTmp"/.bashrc.tmp
	mv "$safeTmp"/.bashrc.tmp "$HOME"/.bashrc
	
	[[ ! -e "$HOME"/.ubcore ]] && return 0
	rm "$HOME"/.ubcorerc
	
	_stop
}

_resetUbiquitous() {
	"$scriptAbsoluteLocation" _resetUbiquitous_sequence
}

_refresh_anchors_ubiquitous() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_ubide
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_ubdb
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_true
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_false
}

_anchor() {
	[[ "$scriptAbsoluteFolder" == *"ubiquitous_bash" ]] && _refresh_anchors_ubiquitous
	
	if type "_refresh_anchors" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors"
		return
	fi
	
	return 0
}


_unix_renice_execDaemon() {
	_cmdDaemon "$scriptAbsoluteLocation" _unix_renice_repeat
}

_unix_renice_daemon() {
	_priority_idle_pid "$$" > /dev/null 2>&1
	
	_start
	
	_killDaemon
	
	
	_unix_renice_execDaemon
	while _daemonStatus
	do
		sleep 5
	done
	
	_stop
}

_unix_renice_repeat() {
	while true
	do
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		_unix_renice_app > /dev/null 2>&1
		sleep 10
		
		_unix_renice
		sleep 10
	done
}

_unix_renice() {
	_priority_idle_pid "$$" > /dev/null 2>&1
	
	_unix_renice_critical > /dev/null 2>&1
	_unix_renice_interactive > /dev/null 2>&1
	_unix_renice_app > /dev/null 2>&1
	_unix_renice_idle > /dev/null 2>&1
}

_unix_renice_critical() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	_priority_enumerate_pattern "^ksysguard$" >> "$processListFile"
	_priority_enumerate_pattern "^ksysguardd$" >> "$processListFile"
	_priority_enumerate_pattern "^top$" >> "$processListFile"
	_priority_enumerate_pattern "^iotop$" >> "$processListFile"
	_priority_enumerate_pattern "^latencytop$" >> "$processListFile"
	
	_priority_enumerate_pattern "^Xorg$" >> "$processListFile"
	_priority_enumerate_pattern "^modeset$" >> "$processListFile"
	
	_priority_enumerate_pattern "^smbd$" >> "$processListFile"
	_priority_enumerate_pattern "^nmbd$" >> "$processListFile"
	
	_priority_enumerate_pattern "^ssh$" >> "$processListFile"
	_priority_enumerate_pattern "^sshd$" >> "$processListFile"
	_priority_enumerate_pattern "^ssh-agent$" >> "$processListFile"
	
	_priority_enumerate_pattern "^sshfs$" >> "$processListFile"
	
	_priority_enumerate_pattern "^socat$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^cron$" >> "$processListFile"
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_critical_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

_unix_renice_interactive() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	_priority_enumerate_pattern "^kwin$" >> "$processListFile"
	_priority_enumerate_pattern "^pager$" >> "$processListFile"
	
	_priority_enumerate_pattern "^pulseaudio$" >> "$processListFile"
	
	_priority_enumerate_pattern "^synergy$" >> "$processListFile"
	_priority_enumerate_pattern "^synergys$" >> "$processListFile"
	
	_priority_enumerate_pattern "^kactivitymanagerd$" >> "$processListFile"
	
	_priority_enumerate_pattern "^dbus" >> "$processListFile"
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_interactive_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

_unix_renice_app() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	_priority_enumerate_pattern "^plasmashell$" >> "$processListFile"
	
	_priority_enumerate_pattern "^audacious$" >> "$processListFile"
	_priority_enumerate_pattern "^vlc$" >> "$processListFile"
	
	_priority_enumerate_pattern "^firefox$" >> "$processListFile"
	
	_priority_enumerate_pattern "^dolphin$" >> "$processListFile"
	
	_priority_enumerate_pattern "^kwrite$" >> "$processListFile"
	
	_priority_enumerate_pattern "^konsole$" >> "$processListFile"
	
	_priority_enumerate_pattern "^pavucontrol$" >> "$processListFile"
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_app_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}

_unix_renice_idle() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_$(_uid)
	
	_priority_enumerate_pattern "^packagekitd$" >> "$processListFile"
	
	_priority_enumerate_pattern "^apt-config$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^ModemManager$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^sddm$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^lpqd$" >> "$processListFile"
	#_priority_enumerate_pattern "^cupsd$" >> "$processListFile"
	#_priority_enumerate_pattern "^cups-browsed$" >> "$processListFile"
	
	_priority_enumerate_pattern "^akonadi" >> "$processListFile"
	_priority_enumerate_pattern "^akonadi_indexing_agent$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^kdeconnectd$" >> "$processListFile"
	#_priority_enumerate_pattern "^kacceessibleapp$" >> "$processListFile"
	#_priority_enumerate_pattern "^kglobalaccel5$" >> "$processListFile"
	
	#_priority_enumerate_pattern "^kded4$" >> "$processListFile"
	#_priority_enumerate_pattern "^ksmserver$" >> "$processListFile"
	
	_priority_enumerate_pattern "^sleep$" >> "$processListFile"
	
	_priority_enumerate_pattern "^exim4$" >> "$processListFile"
	_priority_enumerate_pattern "^apache2$" >> "$processListFile"
	_priority_enumerate_pattern "^mysqld$" >> "$processListFile"
	_priority_enumerate_pattern "^ntpd$" >> "$processListFile"
	#_priority_enumerate_pattern "^avahi-daemon$" >> "$processListFile"
	
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_idle_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}



_findPort_opsauto_blockchain() {
	if ! _findPort 63800 63850 "$@" >> "$scriptLocal"/opsauto
	then
		_stop 1
	fi
}

_opsauto_blockchain_sequence() {
	_start
	
	export opsautoGenerationMode="true"
	
	echo "" > "$scriptLocal"/opsauto
	
	echo -n 'export parity_ui_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_jasonrpc_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_ws_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_ipfs_api_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_secretstore_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_secretstore_http_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	echo -n 'export parity_stratum_port=' >> "$scriptLocal"/opsauto
	_findPort_opsauto_blockchain
	
	#echo -n 'export parity_dapps_port=' >> "$scriptLocal"/opsauto
	#_findPort_opsauto_blockchain
	
	_stop 0
}

_opsauto_blockchain() {
	"$scriptAbsoluteLocation" _opsauto_blockchain_sequence
}

_test_ethereum() {

	_getDep xterm
	
	#OpenGL/OpenCL runtime dependency for mining.
	_getDep GL/gl.h
	_getDep GL/glext.h
	_getDep GL/glx.h
	_getDep GL/glxext.h
	_getDep GL/internal/dri_interface.h
	_getDep x86_64-linux-gnu/pkgconfig/dri.pc
	
}

_test_ethereum_built() {
	_checkDep geth
	
	_checkDep ethminer
}

_test_ethereum_build() {
	_getDep go
}


_build_geth_sequence() {
	_start
	
	cd "$safeTmp"
	
	git clone https://github.com/ethereum/go-ethereum.git
	cd go-ethereum
	make geth
	
	cp build/bin/geth "$scriptBundle"/
	
	cd "$safeTmp"/..
	_stop
}

_build_geth() {
	#Do not rebuild geth unnecessarily, as build is slow.
	_typeDep geth && echo "already have geth" && return 0
	
	"$scriptAbsoluteLocation" _build_geth_sequence
}

_prepare_ethereum_data() {
	mkdir -p "$scriptLocal"/blkchain/ethereum
	mkdir -p "$scriptLocal"/blkchain/io.parity.ethereum
}

_install_fakeHome_ethereum() {
	_prepare_ethereum_data
	
	_link_fakeHome "$scriptLocal"/blkchain/ethereum .ethereum
	
	_link_fakeHome "$scriptLocal"/blkchain/io.parity.ethereum .local/share/io.parity.ethereum
}

#Similar to editShortHome .
_ethereum_home_sequence() {
	_start
	
	export actualFakeHome="$shortFakeHome"
	export fakeHomeEditLib="true"
	
	_install_fakeHome_ethereum
	
	_fakeHome "$@"
	
	_stop $?
}

_ethereum_home() {
	"$scriptAbsoluteLocation" _ethereum_home_sequence "$@"
}

_geth() {
	mkdir -p "$scriptLocal"/blkchain/ethereum > /dev/null 2>&1
	[[ ! -e "$scriptLocal"/blkchain/ethereum ]] && return 1
	geth --datadir "$scriptLocal"/blkchain/ethereum "$@"
}

_ethereum_new() {
	_geth account new
}

_ethereum_sync() {
	_geth --rpc --fast --cache=4096
}

_ethereum_status() {
	echo 'eth.syncing' | _geth attach
}

_ethereum_mine() {
	_ethereum_home xterm -e "$scriptBundle"/ethminer -G --farm-recheck 200 -S eu1.ethermine.org:4444 -FS us1.ethermine.org:4444 -O "$ethaddr"."$rigname"
}

_ethereum_mine_status() {
	xdg-open "https://ethermine.org/miners/""$ethaddr"
}

# TODO Dynamically chosen port.
_parity_ui() {
	#xdg-open 'http://127.0.0.1:'"$parity_ui_port"'/#/'
	
	#egrep -o 'https?://[^ ]+'
	parity_browser_url=$(_parity signer new-token | grep 'http' | cut -f 2- -d\  | _nocolor)
	
	xdg-open "$parity_browser_url"
}

_parity_import() {
	_parity --import-geth-keys
}

_test_ethereum_parity() {
	_getDep gcc
	_getDep g++
	
	_getDep openssl/ssl.h
	
	_getDep libudev.h
	_getDep libudev.so
}

_test_ethereum_parity_built() {
	_checkDep parity
}

_test_ethereum_parity_build() {
	_getDep rustc
	_getDep cargo
}

_build_ethereum_parity_sequence() {
	_start
	
	cd "$safeTmp"
	
	git clone https://github.com/paritytech/parity
	cd parity
	cargo build --release
	
	cp ./target/release/parity "$scriptBundle"/
	
	cd "$safeTmp"/..
	_stop
}

_build_ethereum_parity() {
	#Do not rebuild geth unnecessarily, as build is slow.
	_typeDep parity && echo "already have parity" && return 0
	
	"$scriptAbsoluteLocation" _build_ethereum_parity_sequence
}

_parity() {
	if [[ "$parity_ui_port" != "" ]] && [[ "$parity_port" != "" ]] && [[ "$parity_jasonrpc_port" != "" ]] && [[ "$parity_ws_port" != "" ]] && [[ "$parity_ipfs_api_port" != "" ]] && [[ "$parity_secretstore_port" != "" ]] && [[ "$parity_secretstore_http_port" != "" ]] && [[ "$parity_stratum_port" != "" ]]
	then
		_ethereum_home parity --ui-port="$parity_ui_port" --port="$parity_port" --jsonrpc-port="$parity_jasonrpc_port" --ws-port="$parity_ws_port" --ipfs-api-port="$parity_ipfs_api_port" --secretstore-port="$parity_secretstore_port" --secretstore-http-port="$parity_secretstore_http_port" --stratum-port="$parity_stratum_port" "$@"
	else
		_ethereum_home parity "$@"
	fi
}

_parity_attach() {
	_ethereum_home _geth attach ~/.local/share/io.parity.ethereum/jsonrpc.ipc "$@"
}

_setup_command_commands() {
	_find_setupCommands -name '_synergy' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
}

_here_synergy_config() {
	true
}

_test_synergy() {
	_getDep synergy
	_getDep synergyc
	_getDep synergys
	#_getDep quicksynergy
}

_synergy_ssh() {
	"$scriptAbsoluteLocation" _ssh -C -c aes256-gcm@openssh.com -m hmac-sha1 -o ConnectionAttempts=2 -o ServerAliveInterval=5 -o ServerAliveCountMax=5 -o ExitOnForwardFailure=yes "$@" 
}

_findPort_synergy() {
	_findPort
}

_prepare_synergy() {
	export synergyPort=$(_findPort_synergy)
	_messagePlain_probe 'synergyPort= '"$synergyPort"
	
	export synergyPIDfile="$safeTmpSSH"/.synpid
	export synergyPIDfile_local="$safeTmp"/.synpid
}

_synergy_command_client() {
	#[[ "$synergyRemoteHostname" == "" ]] && export synergyRemoteHostname="generic"
	#export HOME="$HOME"/'.ubcore'/net/"$synergyRemoteHostname"
	
	#export HOME="$HOME"/'.ubcore'/net/synergy
	
	mkdir -p "$HOME"
	cd "$HOME"
	
	synergyc --no-daemon "$@"
}

_synergy_command_server() {
	#[[ "$synergyRemoteHostname" == "" ]] && export synergyRemoteHostname="generic"
	#export HOME="$HOME"/'.ubcore'/net/"$synergyRemoteHostname"
	
	#export HOME="$HOME"/'.ubcore'/net/synergy
	
	mkdir -p "$HOME"
	cd "$HOME"
	
	pgrep ^synergy$ && sleep 48 && return 0
	
	synergy "$@" &
	[[ "$synergyPIDfile" != "" ]] && echo $! > "$synergyPIDfile"
	sleep 48
}

_synergyc_operations() {
	_messagePlain_nominal 'init: _synergyc_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe '_synergyc_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Launching synergy (client).'
	
	_synergy_command_client --no-restart localhost:"$synergyPort"
}

_synergyc() {
	"$scriptAbsoluteLocation" _synergyc_operations "$@"
}

_synergys_operations() {
	_messagePlain_nominal 'init: _synergys_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe '_synergys_operations'
	_report_detect_x11
	
	_messagePlain_nominal 'Launching synergy (server).'
	
	_synergy_command_server "$@"
}

#No production use.
_synergys_terminate() {
	if [[ -e "$synergyPIDfile" ]] && [[ -s "$synergyPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$synergyPIDfile"'
		
		pkill -P $(cat "$synergyPIDfile")
		kill $(cat "$synergyPIDfile")
		#sleep 1
		#kill -KILL $(cat "$synergyPIDfile")
		rm "$synergyPIDfile"
		
		pgrep "^synergy$" && _messagePlain_warn 'found: synergy process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$synergyPIDfile'
	_messagePlain_bad 'terminate: ^synergy$'
	
	pkill ^synergy$
	
	return 1
}

#No production use.
_synergyc_terminate() {
	if [[ -e "$synergyPIDfile" ]] && [[ -s "$synergyPIDfile" ]]
	then
		_messagePlain_good 'found: usable "$synergyPIDfile"'
		
		pkill -P $(cat "$synergyPIDfile")
		kill $(cat "$synergyPIDfile")
		#sleep 1
		#kill -KILL $(cat "$synergyPIDfile")
		rm "$synergyPIDfile"
		
		pgrep "^synergyc$" && _messagePlain_warn 'found: synergyc process'
		
		return 0
	fi
	
	_messagePlain_bad 'missing: usable "$synergyPIDfile'
	_messagePlain_bad 'terminate: ^synergyc$'
	
	pkill ^synergyc$
	
	rm "$synergyPIDfile"
	
	return 1
}

_synergys() {
	"$scriptAbsoluteLocation" _synergys_operations "$@"
}

_synergy_sequence() {
	_messageNormal '_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_synergy
	
	_messageNormal '_synergy_sequence Launch: _synergys'
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergys' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	#Service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	sleep 3
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	sleep 9
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergyc'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_synergy() {
	"$scriptAbsoluteLocation" _synergy_sequence "$@"
}

_push_synergy_sequence() {
	_messageNormal '_synergy_sequence Start'
	_start
	_start_safeTmp_ssh "$@"
	_prepare_synergy
	
	_messageNormal '_synergy_sequence Launch: _synergys'
	bash -c 'env synergyPort='"$synergyPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' '"$scriptAbsoluteLocation"' _synergys' &
	
	_waitPort localhost "$synergyPort"
	
	_messageNormal 'synergy_sequence: Ready: _waitPort localhost synergyport= '"$synergyPort"
	
	#Service may not always be ready when port is up.
	
	sleep 0.8
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	sleep 3
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	sleep 9
	if ! _checkPort localhost "$synergyPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	
	_messageNormal '_synergy_sequence: Ready: sleep, _checkPort. Launch: _synergyc'
	
	_synergy_ssh -L "$synergyPort":localhost:24800 "$@" 'env synergyPort='"$synergyPort"' '"$safeTmpSSH"/cautossh' _synergyc'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_push_synergy() {
	"$scriptAbsoluteLocation" _push_synergy_sequence "$@"
}

_test_x220() {
	_getDep xlock
	
	_getDep xsetwacom
}

_prepare_x220() {
	export ub_hardware_x220_dir="$HOME"/.ubcore/hardware
	mkdir -p "$ub_hardware_x220_dir"
}

_x220_getTrackpoint() {
	export xi_devID=$(xinput list | grep 'TPPS/2 IBM TrackPoint' | cut -d= -f 2 | cut -f 1)
	export xi_state=$(xinput -list-props "$xi_devID" | grep -i 'Device Enabled' | cut -d\) -f2 | sed 's/[^0-9]//g')
	export xi_propNumber=$(xinput -list-props "$xi_devID" | grep -i 'Device Enabled' | cut -d\( -f2 | cut -d\) -f1 | sed 's/[^0-9]//g')
}

_x220_setTrackPoint() {
	_x220_getTrackpoint
	_report_xi

	xinput -set-prop $xi_devID $xi_propNumber "$@"
}

_x220_enableTrackPoint() {
	_messagePlain_nominal "Enabling TrackPoint."
	_x220_setTrackPoint 1
}

_x220_disableTrackPoint() {
	_messagePlain_nominal "Disabling TrackPoint."
	_x220_setTrackPoint 0
}

_x220_getTouch() {
	export xi_devID=$(xinput list | grep 'Wacom ISDv4 E6 Finger touch' | cut -d= -f 2 | cut -f 1)
	export xi_state=$(xinput -list-props "$xi_devID" | grep -i 'Device Enabled' | cut -d\) -f2 | sed 's/[^0-9]//g')
	export xi_propNumber=$(xinput -list-props "$xi_devID" | grep -i 'Device Enabled' | cut -d\( -f2 | cut -d\) -f1 | sed 's/[^0-9]//g')
}

_x220_setTouch() {
	_x220_getTouch
	_report_xi
	
	xinput -set-prop $xi_devID $xi_propNumber "$@"
}

_x220_enableTouch() {
	_messagePlain_nominal "Enabling Touch."
	
	#On enable, momentarily block input events. Otherwise, all touch previous touch events will be processed.
	xlock -mode flag -message "Enabling touch..." &
	sleep 2
	
	_x220_setTouch 1
	
	sleep 2
	kill -KILL $!
}

_x220_disableTouch() {
	_messagePlain_nominal "Disabling Touch."
	_x220_setTouch 0
}

_x220_toggleTouch() {
	_messagePlain_nominal "Togling Touch."
	
	_x220_getTouch
	_report_xi
	
	if [[ "$xi_state" == "1" ]]
	then
		_x220_disableTouch
	else
		_x220_enableTouch
	fi
}

#Workaround. Display configuration changes may inappropriately remap pen/eraser/touch input off matching internal screen.
_x220_wacomLVDS() {
	xsetwacom --set 'Wacom ISDv4 E6 Pen stylus'  "MapToOutput" LVDS1
	xsetwacom --set 'Wacom ISDv4 E6 Pen eraser'  "MapToOutput" LVDS1
	xsetwacom --set 'Wacom ISDv4 E6 Finger touch'  "MapToOutput" LVDS1
}

_x220_setWacomRotation() {
	_x220_wacomLVDS
	
	xsetwacom --set 'Wacom ISDv4 E6 Pen stylus' rotate $1
	xsetwacom --set 'Wacom ISDv4 E6 Pen eraser' rotate $1
	xsetwacom --set 'Wacom ISDv4 E6 Finger touch' rotate $1
}

_x220_tablet_N000() {
	_messagePlain_nominal "Tablet - N000"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate normal
	_x220_setWacomRotation none
	echo "N000" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_enableTouch
	_x220_enableTrackPoint
	
	_reset_KDE
}

_x220_tablet_E090() {
	_messagePlain_nominal "Tablet - E090"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate right
	_x220_setWacomRotation cw
	echo "E090" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_disableTouch
	_x220_disableTrackPoint
	
	_reset_KDE
}

_x220_tablet_S180() {
	_messagePlain_nominal "Tablet - S180"
	
	_prepare_x220
	
	xrandr --output LVDS1 --rotate inverted
	_x220_setWacomRotation half
	echo "S180" > "$ub_hardware_x220_dir"/screenRotationState
	
	_x220_enableTouch
	_x220_disableTrackPoint
	
	_reset_KDE
}

#Flip through tablet rotations. Recommend binding to key or quicklaunch.
_x220_tablet_flip() {
	_messagePlain_nominal "Tablet - Flip"
	
	_prepare_x220
	
	if [[ ! -f "$ub_hardware_x220_dir"/screenRotationState ]]
	then
		echo 'S180' > "$ub_hardware_x220_dir"/screenRotationState
	fi
	
	local currentState
	currentState=$(cat "$ub_hardware_x220_dir"/screenRotationState)
	
	_messagePlain_probe "currentState= ""$currentState"
	
	case "$currentState" in
		N000)
		_x220_tablet_E090
		;;
		E090)
		_x220_tablet_S180
		;;
		S180)
		_x220_tablet_N000
		;;
	esac
}


_x220_vgaSmall() {
	xrandr --addmode VGA1 1366x768
	xrandr --output VGA1 --same-as LVDS1 --mode 1366x768
	xrandr --output LVDS1 --primary --auto
	
	xrandr --addmode VGA1 1366x768
	xrandr --output VGA1 --same-as LVDS1 --mode 1366x768
	xrandr --output LVDS1 --primary --auto
	
	_x220_tablet_N000
}

#Most commonly used mode. Recommend binding to key or quicklaunch.
_x220_vgaRightOf() {
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	_x220_tablet_N000
}

_x220_vgaTablet() {
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	xrandr --output LVDS1 --primary --mode 1366x768
	xrandr --output VGA1 --right-of LVDS1 --auto
	xrandr --output LVDS1 --primary --mode 1366x768
	
	_x220_tablet_S180
}

#####Basic Variable Management

#####Global variables.
#Fixed unique identifier for ubiquitious bash created global resources, such as bootdisc images to be automaticaly mounted by guests. Should NEVER be changed.
export ubiquitiousBashIDnano=uk4u
export ubiquitiousBashIDshort="$ubiquitiousBashIDnano"PhB6
export ubiquitiousBashID="$ubiquitiousBashIDshort"63kVcygT0q

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
elif ([[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]])  && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
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
	_messagePlain_bad 'import: fall: fail' | _user_log-ub
	return 1 >/dev/null 2>&1
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
export safeTmp="$scriptAbsoluteFolder""$tmpPrefix"/w_"$sessionid"
export scopeTmp="$scriptAbsoluteFolder""$tmpPrefix"/s_"$sessionid"
export queryTmp="$scriptAbsoluteFolder""$tmpPrefix"/q_"$sessionid"
export logTmp="$safeTmp"/log
#Solely for misbehaved applications called upon.
export shortTmp=/tmp/w_"$sessionid"

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
#Fail-Safe
export bootTmp="$scriptLocal"
#Typical BSD
[[ -d /tmp ]] && export bootTmp='/tmp'
#Typical Linux
[[ -d /dev/shm ]] && export bootTmp='/dev/shm'

#Specialized temporary directories.

#MetaEngine/Engine Tmp Defaults (example, no production use)
#export metaTmp="$scriptAbsoluteFolder""$tmpPrefix"/.m_"$sessionid"
#export engineTmp="$scriptAbsoluteFolder""$tmpPrefix"/.e_"$sessionid"

# WARNING: Only one user per (virtual) machine. Requires _prepare_abstract . Not default.
# DANGER: Mandatory strict directory 8.3 compliance for this variable! Long subdirectory/filenames permitted thereafter.
# DANGER: Permitting multi-user access to this directory may cause unexpected behavior, including inconsitent file ownership.
#Consistent absolute path abstraction.
export abstractfs_root=/tmp/"$ubiquitiousBashIDnano"
( [[ "$bootTmp" == '/dev/shm' ]] || [[ "$bootTmp" == '/tmp' ]] ) && export abstractfs_root="$bootTmp"/"$ubiquitiousBashIDnano"
export abstractfs_lock=/"$bootTmp"/"$ubiquitiousBashID"/afslock

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


#Reset prefixes.
export tmpPrefix=""

#Machine information.
export hostMemoryTotal=$(cat /proc/meminfo | grep MemTotal | tr -cd '[[:digit:]]')
export hostMemoryAvailable=$(cat /proc/meminfo | grep MemAvailable | tr -cd '[[:digit:]]')
export hostMemoryQuantity="$hostMemoryTotal"

export virtGuestUserDrop="ubvrtusr"
export virtGuestUser="$virtGuestUserDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestUser="root"

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$scriptAbsoluteFolder"/v_"$sessionid"
export instancedVirtFS="$instancedVirtDir"/fs
export instancedVirtTmp="$instancedVirtDir"/tmp

export virtGuestHomeDrop=/home/"$virtGuestUserDrop"
export virtGuestHome="$virtGuestHomeDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestHome=/root
###export virtGuestHomeRef="$virtGuestHome".ref

export instancedVirtHome="$instancedVirtFS""$virtGuestHome"
###export instancedVirtHomeRef="$instancedVirtHome".ref

export sharedHostProjectDirDefault=""
export sharedGuestProjectDirDefault="$virtGuestHome"/project

export sharedHostProjectDir="$sharedHostProjectDirDefault"
export sharedGuestProjectDir="$sharedGuestProjectDirDefault"

export instancedProjectDir="$instancedVirtHome"/project
export instancedDownloadsDir="$instancedVirtHome"/Downloads

export chrootDir="$globalVirtFS"
export vboxRaw="$scriptLocal"/vmvdiraw.vmdk

#Only globalFakeHome is persistent. All other default home directories are removed in some way by "_stop".
export globalFakeHome="$scriptLocal"/h
export instancedFakeHome="$scriptAbsoluteFolder"/h_"$sessionid"
export shortFakeHome="$shortTmp"/h

#Do not use directly as home directory. Append subdirectories.
export arbitraryFakeHome="$shortTmp"/a

#Default, override.
# WARNING: Do not disable.
export actualFakeHome="$instancedFakeHome"
export fakeHomeEditLib="false"
export keepFakeHome="true"

#Automatically assigns appropriate memory quantities to nested virtual machines.
_vars_vmMemoryAllocationDefault() {
	export vmMemoryAllocationDefault=96
	
	[[ "$hostMemoryQuantity" -lt "500000" ]] && export vmMemoryAllocationDefault=256 && return 1
	
	[[ "$hostMemoryQuantity" -lt "1256000" ]] && export vmMemoryAllocationDefault=512 && return 0
	[[ "$hostMemoryQuantity" -lt "1768000" ]] && export vmMemoryAllocationDefault=1024 && return 0
	[[ "$hostMemoryQuantity" -lt "8000000" ]] && export vmMemoryAllocationDefault=1512 && return 0
	
	[[ "$hostMemoryQuantity" -ge "14000000" ]] && export vmMemoryAllocationDefault=1512 && return 0
	
	return 1
}

#Machine allocation defaults.
_vars_vmMemoryAllocationDefault

export hostToGuestDir="$instancedVirtDir"/htg
export hostToGuestFiles="$hostToGuestDir"/files
export hostToGuestISO="$instancedVirtDir"/htg/htg.iso 

# WARNING Must use unique netName!
export netName=default
export gatewayName=gw-"$netName"
export LOCALSSHPORT=22

#Network Defaults
export AUTOSSH_FIRST_POLL=45
export AUTOSSH_POLL=45
#export AUTOSSH_GATETIME=0
export AUTOSSH_GATETIME=15

#export AUTOSSH_PORT=0

#export AUTOSSH_DEBUG=1
#export AUTOSSH_LOGLEVEL=7

#Example ONLY. Modify port asignments. Overriding with "netvars.sh" instead of "ops" recommended, especially for embedded systems relying on autossh.
_get_reversePorts() {
	export matchingReversePorts
	matchingReversePorts=()
	export matchingEMBEDDED=false
	
	local matched
	
	local testHostname
	testHostname="$1"
	[[ "$testHostname" == "" ]] && testHostname=$(hostname -s)
	
	if [[ "$testHostname" == "alpha" ]]
	then
		matchingReversePorts+=( "20000" )
		
		matched=true
	fi
	
	if [[ "$testHostname" == "beta" ]]
	then
		matchingReversePorts+=( "20001" )
		export matchingEMBEDDED=true
		
		matched=true
	fi
	
	if ! [[ "$matched" == "true" ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( "20009" )
		matchingReversePorts+=( "20008" )
	fi
	
	export matchingReversePorts
}

_get_reversePorts
export reversePorts=("${matchingReversePorts[@]}")
export EMBEDDED="$matchingEMBEDDED"

export keepKeys_SSH=true

_prepare_ssh() {
	[[ "$sshHomeBase" == "" ]] && export sshHomeBase="$HOME"/.ssh
	[[ "$sshBase" == "" ]] && export sshBase="$sshHomeBase"
	export sshUbiquitous="$sshBase"/"$ubiquitiousBashID"
	export sshDir="$sshUbiquitous"/"$netName"
	export sshLocal="$sshDir"/_local
	export sshLocalSSH="$sshLocal"/ssh
}



_prepareFakeHome() {
	mkdir -p "$actualFakeHome"
}

_rm_instance_fakeHome() {
	! [[ -e "$instancedFakeHome" ]] && return 0
	
	[[ -e "$instancedFakeHome" ]] && rmdir "$instancedFakeHome" > /dev/null 2>&1
	
	[[ -e "$instancedFakeHome" ]] && _unmakeFakeHome "$instancedFakeHome" > /dev/null 2>&1
	
	# DANGER Allows folders containing ".git" to be removed in all further shells inheriting this environment!
	export safeToDeleteGit="true"
	[[ -e "$instancedFakeHome" ]] && _safeRMR "$instancedFakeHome"
	export safeToDeleteGit="false"
}

##### VBoxVars
#Only include variables and functions here that might need to be used globally.
_unset_vbox() {
	export vBox_vdi=""
	
	export vBoxInstanceDir=""
	
	export VBOX_ID_FILE=""
	
	export VBOX_USER_HOME=""
	export VBOX_USER_HOME_local=""
	export VBOX_USER_HOME_short=""
	
	export VBOX_IPC_SOCKETID=""
	export VBoxXPCOMIPCD_PIDfile=""
	
	_messagePlain_nominal 'clear: _unset_vbox'
}

_reset_vboxLabID() {
	[[ "$VBOX_ID_FILE" == "" ]] && _messagePlain_bad 'blank: VBOX_ID_FILE' && return 1
	
	rm -f "$VBOX_ID_FILE" > /dev/null 2>&1
	
	[[ -e "$VBOX_ID_FILE" ]] && _messagePlain_bad 'fail: VBOX_ID_FILE exists' && return 1
	
	return 0
}

#"$1" == virtualbox instance directory (optional)
_prepare_vbox() {
	_messagePlain_nominal 'init: _prepare_vbox'
	
	_unset_vbox
	
	export vBox_vdi="$scriptLocal/_vboxvdi"
	
	export vBoxInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export vBoxInstanceDir="$1"
	_messagePlain_probe 'vBoxInstanceDir= '"$vBoxInstanceDir"
	
	mkdir -p "$vBoxInstanceDir" > /dev/null 2>&1 || return 1
	mkdir -p "$scriptLocal" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtDir" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtFS" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtTmp" > /dev/null 2>&1 || return 1
	
	export VBOX_ID_FILE
	VBOX_ID_FILE="$vBoxInstanceDir"/vbox.id
	
	! _pathLocked _reset_vboxLabID && _messagePlain_bad 'fail: path has changed and lock not reset' && return 1
	
	[[ ! -e "$VBOX_ID_FILE" ]] && sleep 0.1 && [[ ! -e "$VBOX_ID_FILE" ]] && echo -e -n "$sessionid" > "$VBOX_ID_FILE" 2> /dev/null
	[[ -e "$VBOX_ID_FILE" ]] && export VBOXID=$(cat "$VBOX_ID_FILE" 2> /dev/null)
	
	
	export VBOX_USER_HOME="$vBoxInstanceDir"/vBoxCfg
	export VBOX_USER_HOME_local="$vBoxInstanceDir"/vBoxHome
	#export VBOX_USER_HOME_short="$HOME"/.vbl"$VBOXID"
	#export VBOX_USER_HOME_short=/tmp/.vbl"$VBOXID"
	export VBOX_USER_HOME_short="$bootTmp"/.vbl"$VBOXID"
	
	export VBOX_IPC_SOCKETID="$VBOXID"
	export VBoxXPCOMIPCD_PIDfile="/tmp/.vbox-""$VBOX_IPC_SOCKETID""-ipc/lock"
	
	
	
	[[ "$VBOXID" == "" ]] && _messagePlain_bad 'blank: VBOXID' && return 1
	[[ ! -e "$VBOX_ID_FILE" ]] && _messagePlain_bad 'missing: VBOX_ID_FILE= '"$VBOX_ID_FILE" && return 1
	
	
	mkdir -p "$VBOX_USER_HOME" > /dev/null 2>&1 || return 1
	mkdir -p "$VBOX_USER_HOME_local" > /dev/null 2>&1 || return 1
	
	
	#Atomically ensure symlink between full and short home directory paths is up to date.
	local oldLinkPath
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && ln -sf "$VBOX_USER_HOME_local" "$VBOX_USER_HOME_short" > /dev/null 2>&1
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && _messagePlain_bad 'fail: symlink VBOX_USER_HOME_local to VBOX_USER_HOME_short' && return 1
	
	return 0
}

_prepare_lab_vbox() {
	_prepare_vbox "$scriptLocal"
}
#_prepare_lab_vbox


##### DockerVars
#Only include variables and functions here that might need to be used globally.

_unset_docker() {
	export docker_image=""
	
	export dockerInstanceDir=""
	
	export dockerubidfile=""
	
	export dockerImageFilename=""
	
	export DOCKERUBID=""
	
	export dockerObjectName=""
	export dockerBaseObjectName=""
	export dockerImageObjectName=""
	export dockerImageObjectNameSane=""
	export dockerContainerObjectName=""
	export dockerContainerObjectNameInstanced=""
	
	export dockerBaseObjectExists=""
	export dockerImageObjectExists=""
	export dockerContainerObjectExists=""
	export dockerContainerObjectNameInstancedExists=""
	
	export dockerContainerID=""
	export dockerContainerInstancedID=""
	
	export dockerMkimageDistro=""
	export dockerMkimageVersion=""
	
	export dockerMkimageAbsoluteLocaton=""
	export dockerMkimageAbsoluteDirectory=""
	
	export dockerdirectivefile=""
	export dockerentrypoint=""
	
	
}

_reset_dockerID() {
	[[ "$dockerubidfile" == "" ]] && return 1
	
	rm -f "$dockerubidfile" > /dev/null 2>&1
	 
	[[ -e "$dockerubidfile" ]] && return 1
	
	return 0
}

_prepare_docker_directives() {
	# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
	_here_dockerfile > "$dockerdirectivefile"
	
	cp "$scriptAbsoluteLocation" "$dockerentrypoint" > /dev/null 2>&1
	chmod 0755 "$dockerentrypoint" > /dev/null 2>&1
}

_pull_docker_guest() {
	cp "$dockerdirectivefile" ./ > /dev/null 2>&1
	cp "$dockerentrypoint" ./ > /dev/null 2>&1
	
	cp "$scriptBin"/gosu* ./ > /dev/null 2>&1
	cp "$scriptBin"/hello ./ > /dev/null 2>&1
	
	mkdir -p ./ubbin
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin"/. ./ubbin/
}

#Separated for diagnostic purposes.
_prepare_docker_default() {
	export dockerObjectName
	export dockerBaseObjectName
	export dockerImageObjectName
	export dockerContainerObjectName
	
	[[ "$dockerBaseObjectName" == "" ]] && [[ "$1" != "" ]] && dockerBaseObjectName="$1"
	[[ "$dockerImageObjectName" == "" ]] && [[ "$2" != "" ]] && dockerImageObjectName="$2"
	
	#Default
	if [[ "$dockerObjectName" == "" ]] && [[ "$dockerBaseObjectName" == "" ]] && [[ "$dockerImageObjectName" == "" ]] && [[ "$dockerContainerObjectName" == "" ]]
	then
		#dockerObjectName="unimportant-local/app:app-local/debian:jessie"
		#dockerObjectName="unimportant-hello-scratch"
		#dockerObjectName="ubvrt-ubvrt-scratch"
		#dockerObjectName="ubvrt-ubvrt-ubvrt/debian:jessie"
		dockerObjectName="ubvrt-ubvrt-unknown/unknown:unknown"
	fi
	
	#Allow specification of just the base name.
	[[ "$dockerObjectName" == "" ]] && [[ "$dockerBaseObjectName" != "" ]] && [[ "$dockerImageObjectName" == "" ]] && [[ "$dockerContainerObjectName" == "" ]] && dockerObjectName="ubvrt-ubvrt-""$dockerBaseObjectName"
	
	export dockerObjectName
	export dockerBaseObjectName
	export dockerImageObjectName
	export dockerContainerObjectName
}

_prepare_docker() {
	
	export dockerInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export dockerInstanceDir="$1"
	
	export docker_image="$scriptLocal/_dockimg"
	
	export dockerubidfile
	dockerubidfile="$scriptLocal"/docker.id
	
	_pathLocked _reset_dockerID || return 1
	
	[[ ! -e "$dockerubidfile" ]] && sleep 0.1 && [[ ! -e "$dockerubidfile" ]] && echo -e -n "$lowsessionid" > "$dockerubidfile" 2> /dev/null
	[[ -e "$dockerubidfile" ]] && export DOCKERUBID=$(cat "$dockerubidfile" 2> /dev/null)
	
	export dockerImageFilename="$scriptLocal"/docker.dai
	
	##Sub-object Names
	#Overload by setting either "$dockerObjectName", or any of "$dockerBaseObjectName", "$dockerImageObjectName", and "$dockerContainerObjectName" .
	
	#container-image-base
	#Unique names NOT requires.
	#Path locked ID from ubiquitous_bash will be prepended to image name.
	_prepare_docker_default
	
	[[ "$dockerBaseObjectName" == "" ]] && export dockerBaseObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f3)
	[[ "$dockerImageObjectName" == "" ]] && export dockerImageObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f2)
	[[ "$dockerContainerObjectName" == "" ]] && export dockerContainerObjectName=$(echo "$dockerObjectName" | cut -d\- -f1)
	
	if ! echo "$dockerBaseObjectName" | grep ':' >/dev/null 2>&1
	then
		export dockerBaseObjectName="$dockerBaseObjectName"":latest"
	fi
	
	export dockerImageObjectName="$DOCKERUBID"_"$dockerImageObjectName"
	
	if ! echo "$dockerImageObjectName" | grep ':' >/dev/null 2>&1
	then
		export dockerImageObjectName="$dockerImageObjectName"":latest"
	fi
	
	export dockerImageObjectNameSane=$(echo "$dockerImageObjectName" | tr ':/' '__' | tr -dc 'a-zA-Z0-9_')
	
	export dockerContainerObjectName="$dockerContainerObjectName""_""$dockerImageObjectNameSane"
	
	export dockerContainerObjectNameInstanced="$lowsessionid"_"$dockerContainerObjectName"
	
	##Specialized, redundant in some cases.
	export dockerBaseObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerBaseObjectName" 2> /dev/null)" != "" ]] && export dockerBaseObjectExists="true"
	
	export dockerImageObjectExists="false"
	[[ "$(_permitDocker docker images -q "$dockerImageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists="true"
	
	export dockerContainerObjectExists="false"
	export dockerContainerID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerObjectName"'$')
	[[ "$dockerContainerID" != "" ]] && export dockerContainerObjectExists="true"
	
	export dockerContainerObjectNameInstancedExists="false"
	export dockerContainerInstancedID=$(_permitDocker docker ps -a -q --filter name='^/'"$dockerContainerObjectNameInstanced"'$')
	[[ "$dockerContainerInstancedID" != "" ]] && export dockerContainerObjectNameInstancedExists="true"
	
	
	export dockerMkimageDistro=$(echo "$dockerBaseObjectName" | cut -d \/ -f 2 | cut -d \: -f 1)
	export dockerMkimageVersion=$(echo "$dockerBaseObjectName" | cut -d \/ -f 2 | cut -d \: -f 2)
	
	##Binaries
	[[ "$dockerMkimageAbsoluteLocaton" == "" ]] && export dockerMkimageAbsoluteLocaton=$(_discoverResource moby/contrib/mkimage.sh)
	[[ "$dockerMkimageAbsoluteLocaton" == "" ]] && export dockerMkimageAbsoluteLocaton=$(_discoverResource docker/contrib/mkimage.sh)
	[[ "$dockerMkimageAbsoluteDirectory" == "" ]] && export dockerMkimageAbsoluteDirectory=$(_getAbsoluteFolder "$dockerMkimageAbsoluteLocaton")
	
	##Directives
	export dockerdirectivefile
	dockerdirectivefile="$safeTmp"/Dockerfile
	export dockerentrypoint
	dockerentrypoint="$safeTmp"/ubiquitous_bash.sh
	#_prepare_docker_directives
	
}
#_prepare_docker


_test_metaengine_sequence() {
	! _start_metaengine_host && _stop 1
	! _stop_metaengine_allow && _stop 1
	
	! _reset_me_name && _stop 1
	! _assign_me_coordinates "" "" "" "" "" "" 0 1 0 1 1 0 && _stop 1
	! _set_me_null_in && _stop 1
	
	
	! _reset_me_name && _stop 1
	! _set_me_null_in && _stop 1
	! _set_me_rand_out && _stop 1
	! _cycle_me && _stop 1
	! _set_me_null_out && _stop 1
	
	! _reset_me_name && _stop 1
	! _set_me_null_in && _stop 1
	! _assign_me_name_out "1" && _stop 1
	! _cycle_me && _stop 1
	! _assign_me_name_out "2" && _stop 1
	! _cycle_me && _stop 1
	! _assign_me_name_out "3" && _stop 1
	! _cycle_me && _stop 1
	! _set_me_null_out && _stop 1
	
	! _stop_metaengine_allow && _stop 1
	_stop
}

_test_metaengine() {
	_getDep mkfifo
	
	if ! "$scriptAbsoluteLocation" _test_metaengine_sequence > /dev/null 2>&1
	then
		echo 'fail: metaengine: internal'
		_stop 1
	fi
}

_report_metaengine() {
	_messagePlain_nominal 'init: _report_metaengine'
	
	[[ ! -e "$metaTmp" ]] && _messagePlain_bad 'missing: metaTmp'
	
	
	[[ "$metaBase" == "" ]] && _messagePlain_warn 'blank: metaBase'
	[[ "$metaObjName" == "" ]] && _messagePlain_warn 'blank: metaObjName'
	
	#[[ "$metaType" == "" ]] && _messagePlain_warn 'blank: metaID'
	
	[[ "$metaID" == "" ]] && _messagePlain_warn 'blank: metaID'
	
	[[ "$metaPath" == "" ]] && _messagePlain_warn 'blank: metaPath'
	
	[[ "$metaDir_tmp" == "" ]] && _messagePlain_warn 'blank: metaDir_tmp'
	[[ "$metaDir_base" == "" ]] && _messagePlain_warn 'blank: metaDir_base'
	[[ "$metaDir" == "" ]] && _messagePlain_warn 'blank: metaDir'
	
	[[ "$metaReg" == "" ]] && _messagePlain_warn 'blank: metaReg'
	
	[[ "$metaConfidence" == "" ]] && _messagePlain_warn 'blank: metaConfidence'
	
	[[ ! -e "$metaBase" ]] && _messagePlain_warn 'missing: metaBase'
	
	[[ ! -e "$metaDir_tmp" ]] && _messagePlain_warn 'missing: metaDir_tmp'
	[[ ! -e "$metaDir_base" ]] && _messagePlain_warn 'missing: metaDir_base'
	[[ ! -e "$metaDir" ]] && _messagePlain_warn 'missing: metaDir'
	
	[[ ! -e "$metaReg" ]] && _messagePlain_warn 'missing: metaReg'
	
	[[ ! -e "$metaDir"/ao ]] && _messagePlain_warn 'missing: "$metaDir"/ao'
	[[ ! -e "$metaDir"/bo ]] && _messagePlain_warn 'missing: "$metaDir"/bo'
	
	[[ ! -e "$in_me_a_path" ]] && _messagePlain_warn 'missing: in_me_a_path'
	[[ ! -e "$in_me_b_path" ]] && _messagePlain_warn 'missing: in_me_b_path'
}

_report_metaengine_relink_in() {
	[[ ! -e "$metaDir"/ai ]] && _messagePlain_warn 'missing: "$metaDir"/ai'
	[[ ! -e "$metaDir"/bi ]] && _messagePlain_warn 'missing: "$metaDir"/bi'
}

_report_metaengine_relink_out() {
	[[ ! -e "$out_me_a_path" ]] && _messagePlain_warn 'missing: out_me_a_path'
	[[ ! -e "$out_me_b_path" ]] && _messagePlain_warn 'missing: out_me_b_path'
}

_message_me_vars() {
	_message_me_set
	_message_me_coordinates
	_message_me_name
}

_message_me_set() {
	_messagePlain_probe '########## SET'
	
	_messageVar metaBase
	_messageVar metaObjName
	echo
	_messageVar metaID
	echo
	_messageVar metaPath
	_messageVar metaDir_tmp
	_messageVar metaDir_base
	_messageVar metaDir
	_messageVar metaReg
	_messageVar metaConfidence
	echo
	_message_me_path
}

_message_me_path() {
	_messagePlain_probe '########## PATH'
	_messageVar in_me_a_path
	_messageVar in_me_b_path
	_messageVar out_me_a_path
	_messageVar out_me_b_path
	echo
}

_message_me_coordinates() {
	_messagePlain_probe '########## IO - COORDINATES'
	_messagePlain_probe '##### ai'
	_messageVar in_me_a_z
	_messageVar in_me_a_x
	_messageVar in_me_a_y
	echo
	_messagePlain_probe '##### bi'
	_messageVar in_me_b_z
	_messageVar in_me_b_x
	_messageVar in_me_b_y
	echo
	_messagePlain_probe '##### ao'
	_messageVar out_me_a_z
	_messageVar out_me_a_x
	_messageVar out_me_a_y
	echo
	_messagePlain_probe '##### bo'
	_messageVar out_me_b_z
	_messageVar out_me_b_x
	_messageVar out_me_b_y
	echo
}

_message_me_name() {
	_messagePlain_probe '########## IO - NAMES'
	_messageVar in_me_a_name
	_messageVar in_me_b_name
	_messageVar out_me_a_name
	_messageVar out_me_b_name
}

_me_header_here() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

#Green. Working as expected.
_messagePlain_good() {
	echo -e -n '\E[0;32m '
	echo -n "\$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Yellow. May or may not be a problem.
_messagePlain_warn() {
	echo -e -n '\E[1;33m '
	echo -n "\$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

#Red. Will result in missing functionality, reduced performance, etc, but not necessarily program failure overall.
_messagePlain_bad() {
	echo -e -n '\E[0;31m '
	echo -n "\$@"
	echo -e -n ' \E[0m'
	echo
	return 0
}

CZXWXcRMTo8EmM8i4d
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
	#export metaTmp="$scriptAbsoluteFolder""$tmpPrefix"/.m_"$sessionid"
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



# ATTENTION: Declare with "core.sh" or similar if appropriate.
# WARNING: Any "$tmpPrefix" will be reset before metaengine unless explicitly declared here.
#_set_me_host_prefix() {
#	export metaPrefix="prefix"
#}

_set_me_host() {
	_set_me_base
	
	_tryExec "_set_me_host_prefix"
	
	export metaTmp="$scriptAbsoluteFolder""$metaPrefix"/.m_"$sessionid"
	
	# WARNING: Setting metaProc to a value not including sessionid disables automatic removal by default!
	export metaProc="$metaBase""$metaPrefix"/.m_"$sessionid"
}

_reset_me_host() {
	_reset_me_base
	
	export metaTmp=
	export metaProc=
}

_set_me() {
	_messagePlain_nominal 'init: _set_me'
	
	#_set_me_base
	#_set_me_objname
	
	_set_me_uid
	
	_set_me_path
	_set_me_dir
	_set_me_reg
	
	_set_me_confidence
	
	_set_me_io_in
	_set_me_io_out
	
	_message_me_set
}

_reset_me() {
	#_reset_me_base
	#_reset_me_objname
	
	#_reset_me_host
	
	_reset_me_uid
	
	_reset_me_path
	_reset_me_dir
	_reset_me_reg
	
	_reset_me_confidence
	
	_reset_me_name
	_reset_me_coordinates
	
	_reset_me_type
	
	_reset_me_io
	
	_stop_metaengine_allow
}

_set_me_uid() {
	[[ "$metaEmbed" == "true" ]] && return 0
	export metaID=$(_uid)
}

_reset_me_uid() {
	export metaID=
}

_set_me_path() {
	export metaPath="$metaID"
}

_reset_me_path() {
	export metaPath=
}

# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_dir() {
	export metaDir_tmp="$metaTmp"/"$metaPath"
	
	export metaDir_base="$metaProc"/"$metaPath"
	
	export metaDir="$metaDir_tmp"
	[[ "$metaType" == "base" ]] && export metaDir="$metaDir_base" && _messagePlain_warn 'metaDir= base'
	[[ "$metaType" == "" ]] && _messagePlain_good 'metaDir= tmp'
}

_reset_me_dir() {
	export metaDir_tmp=
	export metaDir_base=
	
	export metaDir=
}

# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_reg() {
	export metaReg="$metaTmp"/_reg
	[[ "$metaType" == "base" ]] && export metaReg="$metaBase"/_reg && _messagePlain_warn 'metaReg= base'
	[[ "$metaType" == "" ]] && _messagePlain_good 'metaReg= tmp'
}

_reset_me_reg() {
	export metaReg=
}

#Intended to signal task completion, allowing shutdown of processing chain.
_set_me_confidence() {
	export metaConfidence="$metaReg"/confidence
}

_reset_me_confidence() {
	export metaConfidence=
}



# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_base() {
	export metaBase=
	
	export metaBase="$outerPWD"
	
	#[[ "$@" != "" ]] && export metaengine_base=$(_searchBaseDir "$@")
	#[[ "$metaengine_base" == "" ]] && export metaengine_base=$(_searchBaseDir "$@" "$virtUserPWD")
	
	#export metaengine_base="$scriptAbsoluteLocation"
}

_reset_me_base() {
	export metaBase=
}

# ATTENTION: Overload with "core.sh" if appropriate.
# WARNING: No default production use.
_set_me_objname() {
	export metaObjName=
	
	export metaObjName="$objectName"
}

_reset_me_objname() {
	export metaObjName=
}



_reset_me_coordinates_ai() {
	export in_me_a_x=
	export in_me_a_y=
	export in_me_a_z=
}

_reset_me_coordinates_bi() {
	export in_me_b_x=
	export in_me_b_y=
	export in_me_b_z=
}

_reset_me_coordinates_ao() {
	export out_me_a_x=
	export out_me_a_y=
	export out_me_a_z=
}

_reset_me_coordinates_bo() {
	export out_me_b_x=
	export out_me_b_y=
	export out_me_b_z=
}

_reset_me_coordinates() {
	_reset_me_coordinates_ai
	_reset_me_coordinates_bi
	_reset_me_coordinates_ao
	_reset_me_coordinates_bo
}


_check_me_coordinates_ai() {
	[[ "$in_me_a_x" == "" ]] && return 1
	[[ "$in_me_a_y" == "" ]] && return 1
	[[ "$in_me_a_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_bi() {
	[[ "$in_me_b_x" == "" ]] && return 1
	[[ "$in_me_b_y" == "" ]] && return 1
	[[ "$in_me_b_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_ao() {
	[[ "$out_me_a_x" == "" ]] && return 1
	[[ "$out_me_a_y" == "" ]] && return 1
	[[ "$out_me_a_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_bo() {
	[[ "$out_me_b_x" == "" ]] && return 1
	[[ "$out_me_b_y" == "" ]] && return 1
	[[ "$out_me_b_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_in() {
	! _check_me_coordinates_ai && return 1
	! _check_me_coordinates_bi && return 1
	return 0
}

_check_me_coordinates_out() {
	! _check_me_coordinates_ao && return 1
	! _check_me_coordinates_bo && return 1
	return 0
}

_check_me_coordinates() {
	! _check_me_coordinates_ai && return 1
	! _check_me_coordinates_bi && return 1
	! _check_me_coordinates_ao && return 1
	! _check_me_coordinates_bo && return 1
	return 0
}

_reset_me_name_ai() {
	export in_me_a_name=
}

_reset_me_name_bi() {
	export in_me_b_name=
}

_reset_me_name_ao() {
	export out_me_a_name=
}

_reset_me_name_bo() {
	export out_me_b_name=
}

_reset_me_rand() {
	_reset_me_name_ai
	_reset_me_name_bi
	_reset_me_name_ao
	_reset_me_name_bo
}
_reset_me_name() {
	_reset_me_name_ai
	_reset_me_name_bi
	_reset_me_name_ao
	_reset_me_name_bo
}

_check_me_name_in() {
	[[ "$in_me_a_name" == "" ]] && return 1
	[[ "$in_me_b_name" == "" ]] && return 1
	return 0
}

_check_me_name_out() {
	[[ "$out_me_a_name" == "" ]] && return 1
	[[ "$out_me_b_name" == "" ]] && return 1
	return 0
}

_check_me_name() {
	[[ "$in_me_a_name" == "" ]] && return 1
	[[ "$in_me_b_name" == "" ]] && return 1
	[[ "$out_me_a_name" == "" ]] && return 1
	[[ "$out_me_b_name" == "" ]] && return 1
	return 0
}
_check_me_rand() {
	_check_me_name
}


_set_me_io_name_in() {
	_messagePlain_nominal 'init: _set_me_io_name_in'
	
	# Optional feature. While used, must must contain at least one file/dir.
	export in_me_a_active="$metaReg"/name/"$in_me_a_name"/_active
	export in_me_a_active_tmp="$in_me_a_active"_tmp
	export in_me_b_active="$metaReg"/name/"$in_me_b_name"/_active
	export in_me_b_active_tmp="$in_me_b_active"_tmp
	export in_me_active="$in_me_a_active"
	export in_me_active_tmp="$in_me_a_active_tmp"
	
	export in_me_a_path="$metaReg"/name/"$in_me_a_name"/ao
		[[ "$in_me_a_name" == "null" ]] && export in_me_a_path=/dev/null
	export in_me_b_path="$metaReg"/name/"$in_me_b_name"/bo
		[[ "$in_me_b_name" == "null" ]] && export in_me_b_path=/dev/null
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_name_out() {
	_messagePlain_nominal 'init: _set_me_io_name_out'
	
	# Optional feature. While used, must must contain at least one file/dir.
	export out_me_a_active="$metaReg"/name/"$out_me_a_name"/_active
	export out_me_a_active_tmp="$out_me_a_active"_tmp
	export out_me_b_active="$metaReg"/name/"$out_me_b_name"/_active
	export out_me_b_active_tmp="$out_me_b_active"_tmp
	export out_me_active="$out_me_a_active"
	export out_me_active_tmp="$out_me_a_active_tmp"
	
	export out_me_a_path="$metaReg"/name/"$out_me_a_name"/ao
		[[ "$out_me_a_name" == "null" ]] && export out_me_a_path=/dev/null
	export out_me_b_path="$metaReg"/name/"$out_me_b_name"/bo
		[[ "$out_me_b_name" == "null" ]] && export out_me_b_path=/dev/null
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_coordinates_in() {
	_messagePlain_nominal 'init: _set_me_io_coordinates_in'
	
	# WARNING: Untested.
	# Optional feature. While used, must must contain at least one file/dir.
	export in_me_a_active="$metaReg"/grid/_active/"$in_me_a_z"/"$in_me_a_x"/"$in_me_a_y"
	export in_me_a_active_tmp="$in_me_a_active"_tmp
	export in_me_b_active="$metaReg"/grid/_active/"$in_me_b_z"/"$in_me_b_x"/"$in_me_b_y"
	export in_me_b_active_tmp="$in_me_b_active"_tmp
	export in_me_active="$in_me_a_active"
	export in_me_active_tmp="$in_me_a_active_tmp"
	
	export in_me_a_path="$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"/"$in_me_a_y"
	export in_me_b_path="$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"/"$in_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_coordinates_out() {
	_messagePlain_nominal 'init: _set_me_io_coordinates_out'
	
	# WARNING: Untested.
	# Optional feature. While used, must must contain at least one file/dir.
	export out_me_a_active="$metaReg"/grid/_active/"$out_me_a_z"/"$out_me_a_x"/"$out_me_a_y"
	export out_me_a_active_tmp="$out_me_a_active"_tmp
	export out_me_b_active="$metaReg"/grid/_active/"$out_me_b_z"/"$out_me_b_x"/"$out_me_b_y"
	export out_me_b_active_tmp="$out_me_b_active"_tmp
	export out_me_active="$out_me_a_active"
	export out_me_active_tmp="$out_me_a_active_tmp"
	
	export out_me_a_path="$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"/"$out_me_a_y"
	export out_me_b_path="$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"/"$out_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

#No production use.
_set_me_io_coordinates() {
	_messagePlain_nominal 'init: _set_me_io_coordinates'
	
	export in_me_a_path="$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"/"$in_me_a_y"
	export in_me_b_path="$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"/"$in_me_b_y"
	export out_me_a_path="$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"/"$out_me_a_y"
	export out_me_b_path="$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"/"$out_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_in() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates_in && ! _check_me_name_in && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _set_me_io_name_in && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _set_me_io_coordinates_in && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

_set_me_io_out() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates_out && ! _check_me_name_out && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _set_me_io_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _set_me_io_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

#No production use.
_set_me_io() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates && ! _check_me_name && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _set_me_io_name_in && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _set_me_io_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _set_me_io_coordinates_in && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _set_me_io_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

_reset_me_io() {
	export in_me_a_path=
	export in_me_b_path=
	export out_me_a_path=
	export out_me_b_path=
}



_assign_me_objname() {
	export metaObjName="$1"
	_messagePlain_nominal 'set: metaObjName= '"$metaObjName"
}

_set_me_type_tmp() {
	export metaType=""
	_messagePlain_nominal 'set: metaType= (tmp)'"$metaType"
}

_set_me_type_base() {
	export metaType="base"
	_messagePlain_nominal 'set: metaType= '"$metaType"
}

_reset_me_type() {
	export metaType=
}


_cycle_me_name() {
	export in_me_a_name="$out_me_a_name"
	export in_me_b_name="$out_me_b_name"
	_set_me_rand_out
	
	_messagePlain_nominal 'cycle: in_me_a_name= (out_me_a_name)'"$in_me_a_name"' ''cycle: in_me_b_name= (out_me_b_name)'"$in_me_b_name"
	_messagePlain_probe 'rand: out_me_a_name= '"$out_me_a_name"' ''rand: out_me_b_name= '"$out_me_b_name"
}
_cycle_me() {
	_cycle_me_name
}


_assign_me_name_ai() {
	export in_me_a_name="$1"
}

_assign_me_name_bi() {
	export in_me_b_name="$1"
}

_assign_me_name_ao() {
	export out_me_a_name="$1"
}

_assign_me_name_bo() {
	export out_me_b_name="$1"
}

_assign_me_name_in() {
	_assign_me_name_ai "$1"
	_assign_me_name_bi "$1"
}

_assign_me_name_out() {
	_assign_me_name_ao "$1"
	_assign_me_name_bo "$1"
}



# WARNING: Coordinate assignment by centroid for 3D pipeline representation ONLY. Detailed spatial data to be completely represented in binary formatted named buffers.
#_assign_me_coordinates aiX aiY aiZ biX biY biZ aoX aoY aoZ boX boY boZ
_assign_me_coordinates() {
	_assign_me_coordinates_ai "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_bi "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_ao "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_bo "$1" "$2" "$3"
}

#_assign_me... X Y Z
_assign_me_coordinates_ai() {
	export in_me_a_x="$1"
		shift
	export in_me_a_y="$1"
		shift
	export in_me_a_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_bi() {
	export in_me_b_x="$1"
		shift
	export in_me_b_y="$1"
		shift
	export in_me_b_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_ao() {
	export out_me_a_x="$1"
		shift
	export out_me_a_y="$1"
		shift
	export out_me_a_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_bo() {
	export out_me_b_x="$1"
		shift
	export out_me_b_y="$1"
		shift
	export out_me_b_z="$1"
}

# No known production use.
_set_me_rand_in() {
	_messagePlain_nominal 'init: _set_me_rand_in'
	local rand_uid
	rand_uid=$(_uid)
	export in_me_a_name="$rand_uid"
	export in_me_b_name="$rand_uid"
}

_set_me_rand_out() {
	_messagePlain_nominal 'init: _set_me_rand_out'
	local rand_uid
	rand_uid=$(_uid)
	export out_me_a_name="$rand_uid"
	export out_me_b_name="$rand_uid"
}

# No known production use.
_set_me_rand() {
	_messagePlain_nominal 'init: _set_me_rand'
	_set_me_rand_in
	_set_me_rand_out
}

_set_me_null_in() {
	_messagePlain_nominal 'init: _set_me_null_in'
	_assign_me_name_ai null
	_assign_me_name_bi null
}

_set_me_null_out() {
	_messagePlain_nominal 'init: _set_me_null_out'
	_assign_me_name_ao null
	_assign_me_name_bo null
}

_set_me_null() {
	_messagePlain_nominal 'init: _set_me_null'
	_set_me_null_in
	_set_me_null_out
}

_relink_metaengine_coordinates_in() {
	_messagePlain_nominal 'init: _relink_metaengine_coordinates_in'
	
	_messageCMD mkdir -p "$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"
	_messageCMD _relink_relative "$in_me_a_path" "$metaDir"/ai
	
	_messageCMD mkdir -p "$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"
	_messageCMD _relink_relative "$in_me_b_path" "$metaDir"/bi
	
	_report_metaengine_relink_in
	
	_messagePlain_good 'return: complete'
	return 0
}

_relink_metaengine_coordinates_out() {
	_messagePlain_nominal 'init: _relink_metaengine_coordinates_out'
	
	_messageCMD mkdir -p "$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"
	_messageCMD _relink_relative "$metaDir"/ao "$out_me_a_path"
	
	_messageCMD mkdir -p "$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"
	_messageCMD _relink_relative "$metaDir"/bo "$out_me_b_path"
	
	_report_metaengine_relink_out
	
	_messagePlain_good 'return: complete'
	return 0
}

#No production use.
_relink_metaengine_coordinates() {
	_messagePlain_nominal 'init: _relink_metaengine_coordinates'
	
	_messageCMD mkdir -p "$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"
	_messageCMD _relink_relative "$in_me_a_path" "$metaDir"/ai
	
	_messageCMD mkdir -p "$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"
	_messageCMD _relink_relative "$in_me_b_path" "$metaDir"/bi
	
	_messageCMD mkdir -p "$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"
	_messageCMD _relink_relative "$metaDir"/ao "$out_me_a_path"
	
	_messageCMD mkdir -p "$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"
	_messageCMD _relink_relative "$metaDir"/bo "$out_me_b_path"
	
	_messagePlain_good 'return: complete'
	return 0
}

#No production use. Untested.
_rmlink_metaengine_coordinates() {
	#_rmlink "$metaDir"/ai > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x" > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_a_z" > /dev/null 2>&1
	
	#_rmlink "$metaDir"/bi > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x" > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_b_z" > /dev/null 2>&1
	
	_rmlink "$out_me_a_path" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_a_z" > /dev/null 2>&1
	
	_rmlink "$out_me_b_path" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_b_z" > /dev/null 2>&1
}

_relink_metaengine_name_in() {
	_messagePlain_nominal 'init: _relink_metaengine_name'
	
	#No known production relevance.
	[[ -e "$metaReg"/name/"$metaID" ]] && _messageError 'FAIL: unexpected safety' && _stop 1
	
	_messageCMD mkdir -p "$metaReg"/name/"$in_me_a_name"
	! [[ "$in_me_a_path" == "/dev/null" ]] && _messageCMD _relink_relative "$in_me_a_path" "$metaDir"/ai
	_messageCMD mkdir -p "$metaReg"/name/"$in_me_b_name"
	! [[ "$in_me_a_path" == "/dev/null" ]] && _messageCMD _relink_relative "$in_me_b_path" "$metaDir"/bi
	
	[[ "$in_me_a_path" == "/dev/null" ]] && _relink "$in_me_a_path" "$metaDir"/ai
	[[ "$in_me_b_path" == "/dev/null" ]] && _relink "$in_me_b_path" "$metaDir"/bi
	
	# DANGER: Administrative/visualization use ONLY.
	( [[ "$in_me_a_path" == "/dev/null" ]] || [[ "$in_me_b_path" == "/dev/null" ]] ) && _relink_relative "$metaDir" "$metaReg"/name/null/"$metaID"
	
	_report_metaengine_relink_in
	
	_messagePlain_good 'return: complete'
	return 0
}

_relink_metaengine_name_out() {
	_messagePlain_nominal 'init: _relink_metaengine_name'
	
	#No known production relevance.
	[[ -e "$metaReg"/name/"$metaID" ]] && _messageError 'FAIL: unexpected safety' && _stop 1
	
	_messageCMD mkdir -p "$metaReg"/name/"$out_me_a_name"
	! [[ "$out_me_a_path" == "/dev/null" ]] && _messageCMD _relink_relative "$metaDir"/ao "$out_me_a_path"
	_messageCMD mkdir -p "$metaReg"/name/"$out_me_b_name"
	! [[ "$out_me_b_path" == "/dev/null" ]] && _messageCMD _relink_relative "$metaDir"/bo "$out_me_b_path"
	
	[[ "$out_me_a_path" == "/dev/null" ]] && rmdir "$metaDir"/ao && _relink /dev/null "$metaDir"/ao
	[[ "$out_me_b_path" == "/dev/null" ]] && rmdir "$metaDir"/bo && _relink /dev/null "$metaDir"/bo
	
	# DANGER: Administrative/visualization use ONLY.
	( [[ "$out_me_a_path" == "/dev/null" ]] || [[ "$out_me_b_path" == "/dev/null" ]] ) && _relink_relative "$metaDir" "$metaReg"/name/null/"$metaID"
	
	_report_metaengine_relink_out
	
	_messagePlain_good 'return: complete'
	return 0
}

#No production use. Unmaintained.
_relink_metaengine_name() {
	_messagePlain_nominal 'init: _relink_metaengine_name'
	
	#No known production relevance.
	[[ -e "$metaReg"/name/"$metaID" ]] && _messageError 'FAIL: unexpected safety' && _stop 1
	
	_messageCMD mkdir -p "$metaReg"/name/"$in_me_a_name"
	_messageCMD _relink_relative "$in_me_a_path" "$metaDir"/ai
	_messageCMD mkdir -p "$metaReg"/name/"$in_me_b_name"
	_messageCMD _relink_relative "$in_me_b_path" "$metaDir"/bi
	
	_messageCMD mkdir -p "$metaReg"/name/"$out_me_a_name"
	_messageCMD _relink_relative "$metaDir"/ao "$out_me_a_path"
	_messageCMD mkdir -p "$metaReg"/name/"$out_me_b_name"
	_messageCMD _relink_relative "$metaDir"/bo "$out_me_b_path"
	
	[[ "$out_me_a_path" == "/dev/null" ]] && rmdir "$metaDir"/ao && _relink /dev/null "$metaDir"/ao
	[[ "$out_me_b_path" == "/dev/null" ]] && rmdir "$metaDir"/bo && _relink /dev/null "$metaDir"/bo
	
	_messagePlain_good 'return: complete'
	return 0
}

#No production use. Untested.
_rmlink_metaengine_name() {
	
	#_rmlink "$metaDir"/ai > /dev/null 2>&1
	#rmdir "$metaReg"/name/"$in_me_a_name" > /dev/null 2>&1
	#_rmlink "$metaDir"/bi > /dev/null 2>&1
	#rmdir "$metaReg"/name/"$in_me_a_name" > /dev/null 2>&1
	
	_rmlink "$out_me_a_path" > /dev/null 2>&1
	rmdir "$metaReg"/name/"$out_me_a_name" > /dev/null 2>&1
	_rmlink "$out_me_b_path" > /dev/null 2>&1
	rmdir "$metaReg"/name/"$out_me_b_name" > /dev/null 2>&1
}


_relink_metaengine_out() {
	_messagePlain_nominal 'init: _relink_metaengine'
	
	! _check_me_coordinates_out && ! _check_me_name_out && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _prepare_metaengine_name && _relink_metaengine_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _prepare_metaengine_name && _relink_metaengine_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messagePlain_bad 'stop: undefined failure'
	_stop 1
}

_relink_metaengine_in() {
	_messagePlain_nominal 'init: _relink_metaengine'
	
	! _check_me_coordinates_in && ! _check_me_name_in && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _prepare_metaengine_name && _relink_metaengine_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _prepare_metaengine_name && _relink_metaengine_name_in && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates_in && _messagePlain_good 'return: success' && return 0
	
	_messagePlain_bad 'stop: undefined failure'
	_stop 1
}

#No production use.  Unmaintained.
_relink_metaengine() {
	_messagePlain_nominal 'init: _relink_metaengine'
	
	! _check_me_coordinates && ! _check_me_name && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _prepare_metaengine_name && _relink_metaengine_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _prepare_metaengine_name && _relink_metaengine_name_in && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _prepare_metaengine_name && _relink_metaengine_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates_in && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messagePlain_bad 'stop: undefined failure'
	_stop 1
}


_prepare_metaengine_coordinates() {
	mkdir -p "$metaReg"/grid
}

_prepare_metaengine_name() {
	mkdir -p "$metaReg"/name
}

_prepare_metaengine() {
	mkdir -p "$metaTmp"
	
	[[ "$metaDir_tmp" != "" ]] && mkdir -p "$metaDir_tmp"
	[[ "$metaDir" != "" ]] && mkdir -p "$metaDir"
	
	mkdir -p "$metaReg"
	
	mkdir -p "$metaDir"/ao
	mkdir -p "$metaDir"/bo
}

_start_metaengine_host() {
	_stop_metaengine_allow
	
	[[ -e "$scriptAbsoluteFolder""$tmpPrefix"/.e_"$sessionid" ]] && _messageError 'FAIL: safety: meta conflicts engine' && _stop 1
	
	_messageNormal 'init: _start_metaengine_host'
	
	_set_me_host
	
	_start
	
	mkdir -p "$metaTmp"
	
	#_relink_relative "$safeTmp"/.pid "$metaTmp"/.pid
}

_start_metaengine() {
	_stop_metaengine_prohibit
	
	[[ -e "$scriptAbsoluteFolder""$tmpPrefix"/.e_"$sessionid" ]] && _messageError 'FAIL: safety: meta conflicts engine' && _stop 1
	
	_messageNormal 'processor: '"$metaObjName"
	_messagePlain_probe 'init: _start_metaengine'
	
	_prepare
	#_start
	
	_set_me
	_prepare_metaengine
	
	# WARNING: Processors must include "_relink_metaengine_in" and "_relink_metaengine_out" where appropriate.
	#_relink_metaengine_in
	#_relink_metaengine_out
	
	_report_metaengine
	
	echo $$ > "$metaDir"/.pid
	_relink_relative "$metaDir"/.pid "$metaDir_tmp"/.pid
	
	_me_embed_here > "$metaDir"/.metaenv.sh
	chmod 755 "$metaDir"/.metaenv.sh
	
	echo "$sessionid" > "$metaDir"/.sessionid
	_embed_here > "$metaDir"/.embed.sh
	chmod 755 "$metaDir"/.embed.sh
}

_stop_metaengine_allow() {
	export metaStop="true"
}
_stop_metaengine_prohibit() {
	export metaStop="false"
}

#Waits for files to exist, or indefinitely pauses, allowing SIGINT or similar to trigger "_stop" at any time.
_stop_metaengine_wait() {
	_stop_metaengine_allow
	
	_wait_not_all_exist "$@"
	
	if [[ "$1" == "" ]]
	then
		while true
		do
			sleep 1
		done
	fi
}

_confidence_metaengine() {
	if [[ -e "$metaConfidence" ]]
	then
		local currentMetaConfidenceValue
		currentMetaConfidenceValue=$(cat "$metaConfidence")
		
		[[ "$currentMetaConfidenceValue" == '1' ]] && return 0
	fi
	
	return 1
}

#_rm_instance_metaengine_metaDir() {
#	# WARNING: No production use, heredoc unsupported.
#	[[ "$metaPreserve" == "true" ]] && return 0
#	
#	[[ "$metaDir" != "" ]] && [[ "$metaDir" == *"$sessionid"* ]] && [[ -e "$metaDir" ]] && _safeRMR "$metaDir"
#}

_rm_instance_metaengine() {
	# WARNING: Documentation only. Any "_stop" condition expected to cleanup work directory corresponding to sessionid.
	# Recommended practice is separate MetaEngine host for any intermittent processing chain.
	#_rm_instance_metaengine_metaDir
	
	[[ "$metaStop" != "true" ]] && return 0
	export metaStop="false"
	
	_terminateMetaProcessorAll_metaengine
	
	# ATTENTION: Optional feature. Copies host metaengine directories for analysis.
	if [[ "$metaLog" != "" ]] && [[ -e "$metaLog" ]]
	then
		cp -a "$metaTmp" "$metaLog"/metaTmp
		cp -a "$metaProc" "$metaLog"/metaProc
	fi
	
	#Only created if needed by meta.
	[[ "$metaTmp" != "" ]] && [[ -e "$metaTmp" ]] && _safeRMR "$metaTmp"
	
	[[ "$metaProc" != "" ]] && [[ "$metaProc" == *"$sessionid"* ]] && [[ -e "$metaProc" ]] && _safeRMR "$metaProc"
}

_complete_me_active() {
	[[ "$in_me_active" == "" ]] && return 1
	! [[ -e "$in_me_active" ]] && return 1
	
	local currentActiveProcCount
	currentActiveProcCount=$(ls -1 "$in_me_active" | wc -l)
	
	if [[ "$currentActiveProcCount" == '0' ]]
	then
		return 0
	fi
	
	return 1
}

_ready_me_in() {
	#! [[ -e "$in_me_a_path" ]] && _messagePlain_warn 'missing: in_me_a_path= '"$in_me_a_path"
	#! [[ -e "$in_me_b_path" ]] && _messagePlain_warn 'missing: in_me_b_path= '"$in_me_b_path"
	
	if [[ ! -e "$in_me_a_path" ]] || [[ ! -e "$in_me_b_path" ]]
	then
		return 1
	fi
	
	_messagePlain_good 'ready: in_me_a_path, in_me_b_path'
	return 0
}

_wait_metaengine_host() {
	_messagePlain_nominal 'init: _wait_metaengine_host'
	_wait_metaengine_in "$@"
}

_wait_metaengine() {
	_messagePlain_nominal 'init: _wait_metaengine'
	_wait_metaengine_in "$@"
}

# ATTENTION: Overload with "core.sh" if appropriate.
_wait_metaengine_in() {
	#_ready_me_in && return 0
	#sleep 0.1
	#_ready_me_in && return 0
	#sleep 0.3
	#_ready_me_in && return 0
	#sleep 1
	#_ready_me_in && return 0
	
	#sleep 3
	#_ready_me_in && return 0
	#sleep 10
	#_ready_me_in && return 0
	#sleep 10
	#_ready_me_in && return 0
	#sleep 10
	#_ready_me_in && return 0
	#sleep 20
	#_ready_me_in && return 0
	#sleep 20
	#_ready_me_in && return 0
	#sleep 20
	#_ready_me_in && return 0
	
	while ! _ready_me_in && ! _complete_me_active
	do
		sleep 0.1
	done
	
	if ! _ready_me_in && _complete_me_active
	then
		rm "$in_me_active"
		[[ -e "$in_me_active" ]] && rmdir "$in_me_active"
		_messagePlain_bad 'died: '"$in_me_active" && return 1
	fi
	
	return 0
	
	# Unexpected.
	! _ready_me_in && _messagePlain_bad 'unexpected: missing: in_me_a_path, in_me_b_path' && return 1
}

# "$1" == uid
_active_me() {
	_set_me_io_out
	
	mkdir -p "$out_me_active_tmp"
	echo "$$" > "$out_me_active_tmp"/"$1"
	_relink_relative "$out_me_active_tmp" "$out_me_active"
}

# "$1" == uid
_complete_me() {
	rm "$out_me_active_tmp"/"$1"
}

_terminateMetaProcessorAll_metaengine() {
	local processListFile
	processListFile="$scriptAbsoluteFolder"/.pidlist_m_$(_uid)
	
	local currentPID
	
	cat "$metaTmp"/*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID" > /dev/null 2>&1
		kill "$currentPID" > /dev/null 2>&1
	done < "$processListFile"
	
	rm "$processListFile"
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_rand() {
	_start_metaengine_host
	
	_set_me_null_in
	_set_me_rand_out
	_example_processor_name
	
	_cycle_me
	_example_processor_name
	
	_cycle_me
	_example_processor_name
	
	_cycle_me
	_set_me_null_out
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_name() {
	_start_metaengine_host
	
	_set_me_null_in
	_assign_me_name_out "1"
	_example_processor_name
	
	_cycle_me
	_assign_me_name_out "2"
	_example_processor_name
	
	_cycle_me
	_assign_me_name_out "3"
	_example_processor_name
	
	_cycle_me
	_set_me_null_out
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_coordinates() {
	_start_metaengine_host
	
	#_assign_me_coordinates aiX aiY aiZ biX biY biZ aoX aoY aoZ boX boY boZ
	#"$metaReg"/grid/"$z"/"$x"/"$y"
	
	_reset_me_name
	_assign_me_coordinates "" "" "" "" "" "" 0 1 0 1 1 0
	_set_me_null_in
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 1 0 1 1 0 0 2 0 1 2 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 2 0 1 2 0 0 3 0 1 3 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 3 0 1 3 0 0 4 0 1 4 0
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}

# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_process_base() {
	_start_metaengine_host
	
	_set_me_type_base
	
	#_assign_me_coordinates aiX aiY aiZ biX biY biZ aoX aoY aoZ boX boY boZ
	#"$metaReg"/grid/"$z"/"$x"/"$y"
	
	_reset_me_name
	_assign_me_coordinates "" "" "" "" "" "" 0 1 0 1 1 0
	_set_me_null_in
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 1 0 1 1 0 0 2 0 1 2 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 2 0 1 2 0 0 3 0 1 3 0
	_example_processor_name
	
	_reset_me_name
	_assign_me_coordinates 0 3 0 1 3 0 0 4 0 1 4 0
	_example_processor_name
	
	_reset_me
	
	_stop_metaengine_wait
}


# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
_example_processor_name() {
	_assign_me_objname "_example_processor_name"
	
	_me_command "_example_me_processor_name"
	
	#Optional. Usually correctly orders diagnostic output.
	sleep 3
}

_example_me_processor_name() {
	_messageNormal 'launch: '"$metaObjName"
	
	! _wait_metaengine && _stop 1
	_start_metaengine
	_relink_metaengine_in
	_relink_metaengine_out
	
	#Do something.
	#> cat >
	while true
	do
		sleep 10
	done
	
	#optional, closes host upon completion
	#_stop
}


# Intended to illustrate the basic logic flow. Uses global variables for some arguments - resetting these is MANDATORY .
#"$1" == _me_processor_name
#"$2" == metaObjName (optional)
_processor_launch() {
	_assign_me_objname "$1"
	#[[ "$2" != "" ]] && _assign_me_objname "$2"
	
	_me_command "$@"
	
	#Optional. Usually correctly orders diagnostic output.
	#_wait_metaengine_host
	#sleep 3
}

_me_processor_noise() {
	_messageNormal 'launch: '"$metaObjName"
	
	! _wait_metaengine && _stop 1
	_start_metaengine
	_relink_metaengine_in
	_relink_metaengine_out
	
	_buffer_me_processor_fifo
	
	cat < /dev/urandom > "$metaDir"/ao/fifo
	
	#while true
	#do
	#	sleep 1
	#done
	
	#optional, closes host upon completion
	#_stop
}

_me_divert() {
	_buffer_me_processor_divert "$@"
}

#Registers an output to a diversion directory for processors which may support more than two inputs. Expected to be used with special processors creating their own unique registrations (ie. _reg/special).
_buffer_me_processor_divert() {
	mkdir -p "$metaReg"/"$1"/divert
	mkdir -p "$metaReg"/"$2"/divert
	
	
	_relink "$metaDir"/ao "$metaReg"/"$1"/divert/"$metaID"
	_relink "$metaDir"/bo "$metaReg"/"$2"/divert/"$metaID"
}

_me_fifo() {
	_buffer_me_processor_fifo
}

_me_snippet_reset() {
	_buffer_me_processor_snippet_reset
}

_me_snippet_write() {
	_buffer_me_processor_snippet_write
}

_me_snippet_read() {
	_buffer_me_processor_snippet_read
}

_me_snippet_read_wait() {
	_buffer_me_processor_snippet_read_wait
}

_me_confidence_full() {
	_buffer_me_processor_confidence_full
}

_me_confidence_none() {
	_buffer_me_processor_confidence_none
}

_buffer_me_processor_fifo() {
	_buffer_me_processor_fifo_rm
	
	#[[ -d "$metaDir"/ai ]] && mkfifo "$metaDir"/ai/fifo
	#[[ -d "$metaDir"/bi ]] && mkfifo "$metaDir"/bi/fifo
	
	[[ -d "$metaDir"/ao ]] && mkfifo "$metaDir"/ao/fifo
	#[[ -d "$metaDir"/bo ]] && mkfifo "$metaDir"/bo/fifo
}

_buffer_me_processor_fifo_rm() {
	rm -f "$metaDir"/ao/fifo > /dev/null 2>&1
	#rm -f "$metaDir"/bo/fifo > /dev/null 2>&1
}

_buffer_me_processor_snippet_reset() {
	echo | _buffer_me_processor_snippet_assign
}

_buffer_me_processor_snippet_write() {
	! [[ -d "$metaDir"/ao ]] && return 1
	
	cat > "$metaDir"/ao/quicktmp_snippet
	mv -n "$metaDir"/ao/quicktmp_snippet "$metaDir"/ao/snippet
	rm -f "$metaDir"/ao/quicktmp_snippet > /dev/null 2>&1
}

_buffer_me_processor_snippet_check_binary() {
	! [[ -e "$metaDir"/bi/confidence ]] && return 1
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	local snippetConfidence
	snippetConfidence=$(cat "$metaDir"/bi/confidence)
	
	#cat "$metaDir"/bi/confidence
	
	[[ "$snippetConfidence" == "1" ]] && return 0
	return 1
}

_buffer_me_processor_snippet_check() {
	! [[ -e "$metaDir"/bi/confidence ]] && return 1
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	local snippetConfidence
	snippetConfidence=$(cat "$metaDir"/bi/confidence)
	
	cat "$metaDir"/bi/confidence
	
	[[ "$snippetConfidence" == "1" ]] && return 0
	return 1
}

_buffer_me_processor_snippet_read() {
	! [[ -d "$metaDir"/ai ]] && return 1
	! [[ -d "$metaDir"/bi ]] && return 1
	
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	cat "$metaDir"/ai/snippet
}

_buffer_me_processor_snippet_read_wait() {
	! [[ -d "$metaDir"/ai ]] && return 1
	! [[ -d "$metaDir"/bi ]] && return 1
	
	while ! _buffer_me_processor_snippet_check_binary
	do
		sleep 0.3
	done
	
	cat "$metaDir"/ai/snippet
}

_buffer_me_processor_confidence_reset() {
	_buffer_me_processor_confidence_none
}

_buffer_me_processor_confidence_none() {
	echo 0 | _buffer_me_processor_confidence_write
}

#Typically signals snippet processor task complete.
_buffer_me_processor_confidence_full() {
	echo 1 | _buffer_me_processor_confidence_write
}

_buffer_me_processor_confidence_write() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	cat > "$metaDir"/bo/quicktmp_confidence
	mv "$metaDir"/bo/quicktmp_confidence "$metaDir"/bo/confidence
	rm -f "$metaDir"/bo/quicktmp_confidence > /dev/null 2>&1
}

# WARNING: Untested.
_me_page_read() {
	_buffer_me_processor_page_in_read "$@"
}

# WARNING: Untested.
_me_page_write() {
	_buffer_me_processor_page_out_write "$@"
}

_me_page_tick_read() {
	_buffer_me_processor_page_tick_default _me_page_read "$@"
}

_me_page_tick_write() {
	_buffer_me_processor_page_tick_default _me_page_write "$@"
}

# WARNING: High performance is not to be expected from bash implementation. C/OpenCL may be better suited.
_me_page_tick_advance() {
	_buffer_me_processor_page_tick_advance_default "$@"
}




_buffer_me_processor_page_tick() {
	local measureTickA
	local measureTickB
	local measureTickDifference
	
	measureTickA=$(cat "$bufferTick_file")
	
	while true
	do
		measureTickB=$(cat "$bufferTick_file")
		measureTickDifference=$(bc <<< "$measureTickB - $measureTickA")
		
		if [[ "$measureTickDifference" -ge "$bufferTick_count" ]]
		then
			"$@"
		fi
		
		sleep 0.005
	done
}

_buffer_me_processor_page_tick_default() {
	export bufferTick_file="$metaReg"/tick
	export bufferTick_count=1
	
	_buffer_me_processor_page_tick "$@"
	
	export bufferTick_file=
	export bufferTick_count=
}

_buffer_me_processor_page_tick_advance_default() {
	export bufferTick_file="$metaReg"/tick
	export bufferTick_count=1
	
	_buffer_me_processor_page_tick_advance "$@"
	
	export bufferTick_file=
	export bufferTick_count=
}

_buffer_me_processor_page_tick_advance() {
	! [[ -e "$bufferTick_file" ]] && _buffer_me_processor_page_tick_reset
	
	local bufferTick_current
	bufferTick_current=$(cat "$bufferTick_file")
	
	local bufferTick_next
	bufferTick_next=$(bc <<< "$bufferTick_current + 1")
	
	echo "$bufferTick_next" | _buffer_me_processor_page_tick_write
}

_buffer_me_processor_page_tick_reset() {
	echo 0 | _buffer_me_processor_page_tick_write
}

_buffer_me_processor_page_tick_write() {
	#! [[ -d "$metaReg" ]] && return 1
	
	cat > "$bufferTick_file".tmp
	mv "$bufferTick_file".tmp "$bufferTick_file"
	rm -f "$bufferTick_file".tmp > /dev/null 2>&1
}

_buffer_me_processor_page_clock() {
	local measureDateA
	local measureDateB
	local measureDateDifference
	
	measureDateA=$(date +%s%N | cut -b1-13)
	
	while true
	do
		measureDateB=$(date +%s%N | cut -b1-13)
		measureDateDifference=$(bc <<< "$measureDateB - $measureDateA")
		
		if [[ "$measureDateDifference" -ge "$bufferClock_ms" ]]
		then
			"$@"
		fi
		
		[[ "$bufferClock_ms" -ge "3000" ]] && sleep 1
		[[ "$bufferClock_ms" -ge "300" ]] && sleep 0.1
		sleep 0.005
	done
}

_buffer_me_processor_page_clock_100fps() {
	export bufferClock_ms=10
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_90fps() {
	export bufferClock_ms=11
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_30fps() {
	export bufferClock_ms=33
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fps() {
	export bufferClock_ms=1000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fpm() {
	export bufferClock_ms=60000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fph() {
	export bufferClock_ms=360000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}




_buffer_me_processor_page_in_read() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointerRead
	
	bufferPointerRead=$(_buffer_me_processor_page_pointer_in_get_current)
	
	! [[ -e "$metaDir"/ai/"$bufferPointerRead" ]] && return 1
	
	cat "$metaDir"/ai/"$bufferPointerRead"
}


_buffer_me_processor_page_pointer_in_get_current() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	cat "$metaDir"/bi/pointer
}

_buffer_me_processor_page_pointer_out_get_previous() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bi/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 0 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 1 && return 0
}

_buffer_me_processor_page_pointer_out_get_next() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bi/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 1 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 0 && return 0
}





_buffer_me_processor_page_out_write() {
	_buffer_me_processor_page_pointer_out_advance
	
	local bufferPointerWrite
	bufferPointerNext=$(_buffer_me_processor_page_pointer_out_get_next)
	
	cat > "$metaDir"/ao/quicktmp_page"$bufferPointerWrite"
	mv "$metaDir"/ao/quicktmp_page"$bufferPointerWrite" "$metaDir"/ao/"$bufferPointerWrite"
	rm -f "$metaDir"/ao/quicktmp_page"$bufferPointerWrite" > /dev/null 2>&1
}

_buffer_me_processor_page_pointer_out_advance() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	! [[ -e "$metaDir"/bo/pointer ]] && _buffer_me_processor_page_pointer_out_reset
	
	local bufferPointerNext
	bufferPointerNext=$(_buffer_me_processor_page_pointer_out_get_next)
	
	echo "$bufferPointerNext" | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_get_current() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	cat "$metaDir"/bo/pointer
}

_buffer_me_processor_page_pointer_out_get_previous() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bo/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 0 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 1 && return 0
}

_buffer_me_processor_page_pointer_out_get_next() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bo/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 1 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 0 && return 0
}

#No production use.
_buffer_me_processor_page_reset() {
	_buffer_me_processor_page_pointer_reset
	
	rm -f "$metaDir"/ao/0 > /dev/null 2>&1
	rm -f "$metaDir"/ao/1 > /dev/null 2>&1
	rm -f "$metaDir"/ao/2 > /dev/null 2>&1
}

_buffer_me_processor_page_pointer_out_reset() {
	_buffer_me_processor_page_pointer_out_0
}

_buffer_me_processor_page_pointer_out_0() {
	echo 0 | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_1() {
	echo 1 | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_2() {
	echo 2 | _buffer_me_processor_page_pointer_out_write
}


_buffer_me_processor_page_pointer_out_write() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	cat > "$metaDir"/bo/quicktmp_pointer
	mv "$metaDir"/bo/quicktmp_pointer "$metaDir"/bo/pointer
	rm -f "$metaDir"/bo/quicktmp_pointer > /dev/null 2>&1
}



_buildHello() {
	local helloSourceCode
	helloSourceCode="$scriptAbsoluteFolder"/generic/hello/hello.c
	! [[ -e "$helloSourceCode" ]] && helloSourceCode="$scriptLib"/ubiquitous_bash/generic/hello/hello.c
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/hello -static -nostartfiles "$helloSourceCode"
}

#####Idle

_idle() {
	_start
	
	_checkDep getIdle
	
	_daemonStatus && _stop 1
	
	#Default 20 minutes.
	[[ "$idleMax" == "" ]] && export idleMax=1200000
	[[ "$idleMin" == "" ]] && export idleMin=60000
	
	while true
	do
		sleep 5
		
		idleTime=$("$scriptBin"/getIdle)
		
		if [[ "$idleTime" -lt "$idleMin" ]] && _daemonStatus
		then
			true
			_killDaemon	#Comment out if unnecessary.
		fi
		
		
		if [[ "$idleTime" -gt "$idleMax" ]] && ! _daemonStatus
		then
			_execDaemon
			while ! _daemonStatus
			do
				sleep 5
			done
		fi
		
		
		
	done
	
	_stop
}

_test_buildIdle() {
	_getDep "X11/extensions/scrnsaver.h"
}

_testBuiltIdle() {
	
	_checkDep getIdle
	
	idleTime=$("$scriptBin"/getIdle)
	
	if ! echo "$idleTime" | grep '^[0-9]*$' >/dev/null 2>&1
	then
		echo getIdle invalid response
		_stop 1
	fi
	
}

_buildIdle() {
	local idleSourceCode
	idleSourceCode="$scriptAbsoluteFolder"/generic/process/idle.c
	! [[ -e "$idleSourceCode" ]] && idleSourceCode="$scriptLib"/ubiquitous_bash/generic/process/idle.c
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/getIdle "$idleSourceCode" -lXss -lX11
	
}

_test_build_prog() {
	true
}

_test_build() {
	_getDep gcc
	_getDep g++
	_getDep make
	
	_getDep cmake
	
	_getDep autoreconf
	_getDep autoconf
	_getDep automake
	
	_getDep libtool
	
	_getDep makeinfo
	
	_getDep pkg-config
	
	_tryExec _test_buildGoSu
	
	_tryExec _test_buildIdle
	
	_tryExec _test_bashdb
	
	_tryExec _test_ethereum_build
	_tryExec _test_ethereum_parity_build
	
	_tryExec _test_build_prog
}
alias _testBuild=_test_build

_buildSequence() {
	_start
	
	echo -e '\E[1;32;46m Binary compiling...	\E[0m'
	
	_tryExec _buildHello
	
	_tryExec _buildIdle
	_tryExec _buildGosu
	
	_tryExec _build_geth
	_tryExec _build_ethereum_parity
	
	_tryExec _buildChRoot
	_tryExec _buildQEMU
	
	_tryExec _buildExtra
	
	echo "     ...DONE"
	
	_stop
}

_build_prog() {
	true
}

_build() {
	"$scriptAbsoluteLocation" _buildSequence
	
	_build_prog
}

#####Local Environment Management (Resources)

_prepare_prog() {
	true
}

_extra() {
	true
}

_prepare_abstract() {
	! mkdir -p "$abstractfs_root" && exit 1
	chmod 0700 "$abstractfs_root" > /dev/null 2>&1
	! chmod 700 "$abstractfs_root" && exit 1
	! chown "$USER":"$USER" "$abstractfs_root" && exit 1
	
	! mkdir -p "$abstractfs_lock" && exit 1
	chmod 0700 "$abstractfs_lock" > /dev/null 2>&1
	! chmod 700 "$abstractfs_lock" && exit 1
	! chown "$USER":"$USER" "$abstractfs_lock" && exit 1
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
	#_prepare_abstract
	
	_extra
	_prepare_prog
}

#####Local Environment Management (Instancing)

_start_prog() {
	true
}

_start() {
	
	_prepare
	
	#touch "$varStore"
	#. "$varStore"
	
	echo $$ > "$safeTmp"/.pid
	echo "$sessionid" > "$safeTmp"/.sessionid
	_embed_here > "$safeTmp"/.embed.sh
	chmod 755 "$safeTmp"/.embed.sh
	
	_start_prog
}

_saveVar_prog() {
	true
}

_saveVar() {
	true
	#declare -p varName > "$varStore"
	
	_saveVar_prog
}

_stop_prog() {
	true
}

_stop() {
	_stop_prog
	
	_preserveLog
	
	#Kill process responsible for initiating session. Not expected to be used normally, but an important fallback.
	local ub_stop_pid
	if [[ -e "$safeTmp"/.pid ]]
	then
		ub_stop_pid=$(cat "$safeTmp"/.pid)
		if [[ $$ != "$ub_stop_pid" ]]
		then
			pkill -P "$ub_stop_pid"
			kill "$ub_stop_pid"
		fi
	fi
	
	rm -f "$pidFile" > /dev/null 2>&1	#Redundant, as this usually resides in "$safeTmp".
	
	if [[ -e "$scopeTmp" ]] && [[ -e "$scopeTmp"/.pid ]] && [[ "$$" == $(cat "$scopeTmp"/.pid 2>/dev/null) ]]
	then
		rm -f "$ub_scope" > /dev/null 2>&1			#Symlink, or nonexistent.
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
	
	_tryExec _rm_instance_fakeHome
	
	#Optionally always try to remove any systemd shutdown hook.
	#_tryExec _unhook_systemd_shutdown
	
	if [[ "$1" != "" ]]
	then
		exit "$1"
	else
		exit 0
	fi
}

#Do not overload this unless you know why you need it instead of _stop_prog.
_stop_emergency_prog() {
	true
}

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
	
	_stop_emergency_prog
	
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
	[[ "$uDEBUG" == true ]] && caller 0 >> "$scriptLocal"/lock.log
	[[ "$uDEBUG" == true ]] && echo -e '\t'"$sessionid"'\t'"$1" >> "$scriptLocal"/lock.log
	
	mkdir -p "$bootTmp"
	
	! [[ -e "$bootTmp"/"$sessionid" ]] && echo > "$bootTmp"/"$sessionid"
	
	# WARNING Recommend setting this to a permanent value when testing critical subsystems, such as with _userChRoot related operations.
	local lockUID="$(_uid)"
	
	echo "$sessionid" > "$lock_quicktmp"_"$lockUID"
	
	mv -n "$lock_quicktmp"_"$lockUID" "$1" > /dev/null 2>&1
	
	if [[ -e "$lock_quicktmp"_"$lockUID" ]]
	then
		[[ "$uDEBUG" == true ]] && echo -e '\t'FAIL >> "$scriptLocal"/lock.log
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
_open_sequence() {
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
	
	_open_sequence "$@"
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
_close_sequence() {
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
		rm -f "$lock_open" || return 1
		
		if [[ "$specialLock" != "" ]] && [[ -e "$specialLock" ]]
		then
			rm -f "$specialLock" || return 1
		fi
		
		rm -f "$lock_closing"
		rm -f "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
}

_close() {
	local returnStatus
	
	_close_sequence "$@"
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


#####Installation


_vector() {
	_tryExec "_vector_virtUser"
}

#Verifies the timeout and sleep commands work properly, with subsecond specifications.
_timetest() {
	
	iterations=0
	while [[ "$iterations" -lt 10 ]]
	do
		dateA=$(date +%s)
		
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		sleep 0.1
		
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		_timeout 0.1 sleep 10
		
		dateB=$(date +%s)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -lt "5" ]]
		then
			_messagePASS
			return 0
		fi
		
		let iterations="$iterations + 1"
	done
	_messageFAIL
	_stop 1
}

_test_prog() {
	true
}

_test() {
	_messageNormal "Sanity..."
	
	local santiySessionID_length
	santiySessionID_length=$(echo -n "$sessionid" | wc -c)
	
	[[ "$santiySessionID_length" -lt "18" ]] && _messageFAIL && return 1
	[[ "$uidLengthPrefix" != "" ]] && [[ "$santiySessionID_length" -lt "$uidLengthPrefix" ]] && _messageFAIL && return 1
	
	[[ -e "$safeTmp" ]] && _messageFAIL && return 1
	
	_start
	
	[[ ! -e "$safeTmp" ]] && _messageFAIL && return 1
	
	local currentTestUID=$(_uid 245)
	mkdir -p "$safeTmp"/"$currentTestUID"
	echo > "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	
	[[ ! -e "$safeTmp"/"$currentTestUID"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	rm -f "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	rmdir "$safeTmp"/"$currentTestUID"
	
	[[ -e "$safeTmp"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	_messagePASS
	
	
	_messageNormal "Permissions..."
	
	! _test_permissions_ubiquitous && _messageFAIL
	
	_messagePASS
	
	echo -n -e '\E[1;32;46m Argument length...	\E[0m'
	
	local testArgLength
	
	! testArgLength=$(getconf ARG_MAX) && _messageFAIL && _stop 1
	[[ "$testArgLength" -lt 131071 ]] && _messageFAIL && _stop 1
	
	_messagePASS
	
	_messageNormal "Absolute pathfinding..."
	#_tryExec "_test_getAbsoluteLocation"
	_messagePASS
	
	echo -n -e '\E[1;32;46m Timing...		\E[0m'
	_timetest
	
	_messageNormal "Dependency checking..."
	
	## Check dependencies
	
	#"generic/filesystem"/permissions.sh
	_checkDep stat
	
	_getDep wget
	_getDep grep
	_getDep fgrep
	_getDep sed
	_getDep awk
	_getDep cut
	_getDep head
	_getDep tail
	
	_getDep wc
	
	
	! _compat_realpath && ! _wantGetDep realpath && echo 'realpath missing'
	_getDep readlink
	_getDep dirname
	_getDep basename
	
	_getDep sleep
	_getDep wait
	_getDep kill
	_getDep jobs
	_getDep ps
	_getDep exit
	
	_getDep env
	_getDep bash
	_getDep echo
	_getDep cat
	_getDep type
	_getDep mkdir
	_getDep trap
	_getDep return
	_getDep set
	
	_getDep printf
	
	_getDep dd
	
	_getDep rm
	
	_getDep find
	_getDep ln
	_getDep ls
	
	_getDep id
	
	_getDep test
	
	_getDep true
	_getDep false
	
	_getDep diff
	
	_tryExec "_test_package"
	
	
	_tryExec "_test_daemon"
	
	_tryExec "_testFindPort"
	_tryExec "_test_waitport"
	
	_tryExec "_testProxySSH"
	
	_tryExec "_testAutoSSH"
	
	_tryExec "_testTor"
	
	_tryExec "_testProxyRouter"
	
	#_tryExec "_test_build"
	
	_tryExec "_testGosu"
	
	_tryExec "_testMountChecks"
	_tryExec "_testBindMountManager"
	_tryExec "_testDistro"
	_tryExec "_test_fetchDebian"
	
	_tryExec "_test_image"
	_tryExec "_test_transferimage"
	
	_tryExec "_testCreatePartition"
	_tryExec "_testCreateFS"
	
	_tryExec "_test_mkboot"
	
	_tryExec "_test_abstractfs"
	_tryExec "_test_fakehome"
	_tryExec "_testChRoot"
	_tryExec "_testQEMU"
	_tryExec "_testQEMU_x64-x64"
	_tryExec "_testQEMU_x64-raspi"
	_tryExec "_testQEMU_raspi-raspi"
	_tryExec "_testVBox"
	
	_tryExec "_test_vboxconvert"
	
	_tryExec "_test_dosbox"
	
	_tryExec "_testWINE"
	
	_tryExec "_test_docker"
	
	_tryExec "_test_docker_mkimage"
	
	_tryExec "_testVirtBootdisc"
	
	_tryExec "_testExtra"
	
	_tryExec "_testGit"
	
	_tryExec "_test_bup"
	
	_tryExec "_testX11"
	
	_tryExec "_test_virtLocal_X11"
	
	_tryExec "_test_gparted"
	
	_tryExec "_test_synergy"
	
	_tryExec "_test_devatom"
	_tryExec "_test_devemacs"
	_tryExec "_test_deveclipse"
	
	_tryExec "_test_ethereum"
	_tryExec "_test_ethereum_parity"
	
	_tryExec "_test_metaengine"
	
	_tryExec "_test_channel"
	
	[[ -e /dev/urandom ]] || echo /dev/urandom missing _stop
	
	_messagePASS
	
	_messageNormal 'Vector...'
	_vector
	_messagePASS
	
	_test_prog
	
	_stop
}

_testBuilt_prog() {
	true
}

_testBuilt() {
	_start
	
	_messageProcess "Binary checking"
	
	_tryExec "_testBuiltIdle"
	_tryExec "_testBuiltGosu"	#Note, requires sudo, not necessary for docker .
	
	_tryExec "_test_ethereum_built"
	_tryExec "_test_ethereum_parity_built"
	
	_tryExec "_testBuiltChRoot"
	_tryExec "_testBuiltQEMU"
	
	_tryExec "_testBuiltExtra"
	
	_testBuilt_prog
	
	_messagePASS
	
	_stop
}

#Creates symlink in "$HOME"/bin, to the executable at "$1", named according to its residing directory and file name.
_setupCommand() {
	mkdir -p "$HOME"/bin
	! [[ -e "$HOME"/bin ]] && return 1
	
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolder")
	
	_relink_relative "$clientScriptLocation" "$HOME"/bin/"$commandName""-""$clientName"
	
	
}

_setupCommand_meta() {
	mkdir -p "$HOME"/bin
	! [[ -e "$HOME"/bin ]] && return 1
	
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local clientScriptFolderResidence
	clientScriptFolderResidence=$(_getAbsoluteFolder "$clientScriptFolder")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolderResidence")
	
	_relink_relative "$clientScriptLocation" "$HOME"/bin/"$commandName""-""$clientName"
	
	
}

_find_setupCommands() {
	find -L "$scriptAbsoluteFolder" -not \( -path \*_arc\* -prune \) "$@"
}

#Consider placing files like ' _vnc-machine-"$netName" ' in an "_index" folder for automatic installation.
_setupCommands() {
	#_find_setupCommands -name '_command' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	
	_tryExec "_setup_ssh_commands"
	_tryExec "_setup_command_commands"
}

_setup_pre() {
	true
}

_setup_prog() {
	true
}

_setup() {
	_start
	
	"$scriptAbsoluteLocation" _test || _stop 1
	
	#Only attempt build procedures if their functions have been defined from "build.sh" . Pure shell script projects (eg. CoreAutoSSH), and projects using only statically compiled binaries, need NOT include such procedures.
	local buildSupported
	type _build > /dev/null 2>&1 && type _test_build > /dev/null 2>&1 && buildSupported="true"
	
	[[ "$buildSupported" == "true" ]] && ! "$scriptAbsoluteLocation" _test_build && _stop 1
	
	if ! "$scriptAbsoluteLocation" _testBuilt
	then
		! [[ "$buildSupported" == "true" ]] && _stop 1
		[[ "$buildSupported" == "true" ]] && ! "$scriptAbsoluteLocation" _build "$@" && _stop 1
		! "$scriptAbsoluteLocation" _testBuilt && _stop 1
	fi
	
	_setupCommands
	
	_setup_pre
	
	_tryExec "_setup_ssh"
	
	_setup_prog
	
	_stop
}

_test_package() {
	_getDep tar
	_getDep gzip
}

_package_prog() {
	true
}

# WARNING Must define "_package_license" function in ops to include license files in package!
_package() {
	_start
	mkdir -p "$safeTmp"/package
	
	_package_prog
	
	_tryExec "_package_license"
	
	_tryExec "_package_cautossh"
	
	#scriptBasename=$(basename "$scriptAbsoluteLocation")
	#cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/"$scriptBasename"
	cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/ops "$safeTmp"/package/
	
	#cp -a "$scriptAbsoluteFolder"/_bin "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_config "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_prog "$safeTmp"
	
	#cp -a "$scriptAbsoluteFolder"/_local "$safeTmp"/package/
	
	cp -a "$scriptAbsoluteFolder"/README.md "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/USAGE.html "$safeTmp"/package/
	
	cd "$safeTmp"/package/
	tar -czvf "$scriptAbsoluteFolder"/package.tar.gz .
	
	cd "$outerPWD"
	_stop
}

#####Program

#Typically launches an application - ie. through virtualized container.
_launch() {
	false
	#"$@"
}

#Typically gathers command/variable scripts from other (ie. yaml) file types (ie. AppImage recipes).
_collect() {
	false
}

#Typical program entry point, absent any instancing support.
_enter() {
	_launch "$@"
}

#Typical program entry point.
_main() {
	_start
	
	_collect
	
	_enter "$@"
	
	_stop
}

#matchingReversePorts=""
#matchingEMBEDDED=""


#####Network Specific Variables
#Statically embedded into monolithic ubiquitous_bash.sh/cautossh script by compile .

# WARNING Must use unique netName!
export netName=default
export gatewayName=gw-"$netName"
export LOCALSSHPORT=22

export AUTOSSH_FIRST_POLL=45
export AUTOSSH_POLL=45
#export AUTOSSH_GATETIME=0
export AUTOSSH_GATETIME=15
#export AUTOSSH_PORT=0
#export AUTOSSH_DEBUG=1
#export AUTOSSH_LOGLEVEL=7

_get_reversePorts() {
	export matchingReversePorts
	matchingReversePorts=()
	export matchingEMBEDDED="false"

	local matched

	local testHostname
	testHostname="$1"
	[[ "$testHostname" == "" ]] && testHostname=$(hostname -s)

	if [[ "$testHostname" == 'hostnameA' ]] || [[ "$testHostname" == 'hostnameB' ]]
	then
		matchingReversePorts+=( '20001' )
		matched='true'
	fi
	if [[ "$testHostname" == 'hostnameC' ]] || [[ "$testHostname" == 'hostnameD' ]]
	then
		matchingReversePorts+=( '20002' )
		export matchingEMBEDDED='true'
		matched='true'
	fi
	if ! [[ "$matched" == 'true' ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( '20003' )
	fi

	export matchingReversePorts
}
_get_reversePorts
export reversePorts=("${matchingReversePorts[@]}")
export EMBEDDED="$matchingEMBEDDED"

export keepKeys_SSH='true'

_deps_metaengine() {
# 	#_deps_notLean
	
	export enUb_metaengine="true"
} 

_compile_bash_metaengine() {
	export includeScriptList
	
	#[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine"/undefined.sh )
}

_compile_bash_vars_metaengine() {
	export includeScriptList
	
	[[ "$enUb_metaengine" == "true" ]] && includeScriptList+=( "metaengine/"/metaengine.sh )
	
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
	export enUb_abstractfs=""
	export enUb_buildBash=""
	export enUb_buildBashUbiquitous=""
	
	export enUb_command=""
	export enUb_synergy=""
	
	export enUb_hardware=""
	export enUb_enUb_x220t=""
	
	export enUb_user=""
	
	export enUb_metaengine=""
}

_deps_dev_heavy() {
	_deps_notLean
	export enUB_dev_heavy="true"
}

_deps_mount() {
	_deps_notLean
	export enUB_mount="true"
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

_deps_virt_thick() {
	_deps_build
	_deps_notLean
	export enUb_virt_thick="true"
}

_deps_virt() {
	_deps_machineinfo
	_deps_image
	export enUb_virt="true"
}

_deps_chroot() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_ChRoot="true"
}

_deps_qemu() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_vbox="true"
}

_deps_docker() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_docker="true"
}

_deps_wine() {
	_deps_notLean
	_deps_virt
	export enUb_wine="true"
}

_deps_dosbox() {
	_deps_notLean
	_deps_virt
	export enUb_DosBox="true"
}

_deps_msw() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	_deps_qemu
	_deps_vbox
	_deps_wine
	export enUb_msw="true"
}

_deps_fakehome() {
	_deps_notLean
	_deps_virt
	export enUb_fakehome="true"
}

_deps_abstractfs() {
	_deps_notLean
	_deps_virt
	export enUb_abstractfs="true"
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

_deps_channel() {
	export enUb_channel="true"
}

#placeholder, define under "metaengine/build"
#_deps_metaengine() {
#	_deps_notLean
#	
#	export enUb_metaengine="true"
#}


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
		
		_deps_channel
		
		_deps_git
		_deps_bup
		
		_deps_command
		_deps_synergy
		
		return 0
	fi
	
	if [[ "$1" == "processor" ]]
	then
		
		_deps_channel
		
		_deps_metaengine
		
		_deps_abstractfs
		
		return 0
	fi
	
	if [[ "$1" == "core" ]]
	then
		_deps_dev_heavy
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_x11
		_deps_image
		
		_deps_virt
		_deps_virt_thick
		
		_deps_chroot
		_deps_qemu
		_deps_vbox
		#_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs
		
		_deps_channel
		
		_deps_metaengine
		
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
		_deps_dev_heavy
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_x11
		_deps_image
		
		_deps_virt
		_deps_virt_thick
		
		_deps_chroot
		_deps_qemu
		_deps_vbox
		_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs
		
		_deps_channel
		
		_deps_metaengine
		
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
	includeScriptList+=( "generic/filesystem"/allLogic.sh )
	includeScriptList+=( "generic/process"/timeout.sh )
	includeScriptList+=( "generic/process"/terminate.sh )
	includeScriptList+=( "generic"/uid.sh )
	includeScriptList+=( "generic/filesystem/permissions"/checkpermissions.sh )
	includeScriptList+=( "generic"/findInfrastructure.sh )
	includeScriptList+=( "generic"/gather.sh )
	
	includeScriptList+=( "generic/process"/priority.sh )
	
	includeScriptList+=( "generic/filesystem"/internal.sh )
	
	includeScriptList+=( "generic"/messaging.sh )
	
	includeScriptList+=( "generic"/config/mustcarry.sh )
	
	[[ "$enUb_buildBash" == "true" ]] && includeScriptList+=( "build/bash"/include_bash.sh )
	[[ "$enUb_buildBash" == "true" ]] && includeScriptList+=( "build/bash"/include_bash_prog.sh )
}

_compile_bash_utilities() {
	export includeScriptList
	
	#####Utilities
	includeScriptList+=( "generic/filesystem"/getext.sh )
	
	includeScriptList+=( "generic/filesystem"/finddir.sh )
	
	includeScriptList+=( "generic/filesystem"/discoverresource.sh )
	
	includeScriptList+=( "generic/filesystem"/relink.sh )
	
	[[ "$enUB_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/bindmountmanager.sh )
	
	[[ "$enUB_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/waitumount.sh )
	
	[[ "$enUB_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/mountchecks.sh )
	
	[[ "$enUb_channel" == "true" ]] && includeScriptList+=( "generic/process/"channel.sh )
	
	includeScriptList+=( "generic/process"/waitforprocess.sh )
	
	includeScriptList+=( "generic/process"/daemon.sh )
	
	includeScriptList+=( "generic/process"/remotesig.sh )
	
	includeScriptList+=( "generic/process"/embed_here.sh )
	includeScriptList+=( "generic/process"/embed.sh )
	
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
	
	includeScriptList+=( "special"/uuid.sh )
	
	[[ "$enUB_dev_heavy" == "true" ]] && includeScriptList+=( "instrumentation"/bashdb/bashdb.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "instrumentation"/profiling/stopwatch.sh )
}

_compile_bash_utilities_virtualization() {
	export includeScriptList
	
	# ATTENTION: Although the only known requirement for gosu is virtualization, it may be necessary wherever sudo is not sufficient to drop privileges.
	[[ "$enUb_virt_thick" == "true" ]] && includeScriptList+=( "special/gosu"/gosu.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtenv.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/findInfrastructure_virt.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/osTranslation.sh )
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/localPathTranslation.sh )
	
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfsvars.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomemake.sh )
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehome.sh )
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomeuser.sh )
	includeScriptList+=( "virtualization/fakehome"/fakehomereset.sh )
	
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
	
	[[ "$enUB_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev"/devsearch.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUB_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devemacs.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUB_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devatom.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUB_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/deveclipse.sh )
	
	includeScriptList+=( "shortcuts/dev/query"/devquery.sh )
	
	includeScriptList+=( "shortcuts/dev/scope"/devscope.sh )
	includeScriptList+=( "shortcuts/dev/scope"/devscope_here.sh )
	
	# WARNING: Some apps may have specific dependencies (eg. fakeHome, abstractfs, eclipse, atom).
	includeScriptList+=( "shortcuts/dev/scope"/devscope_app.sh )
	
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

_compile_bash_shortcuts_os() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts/os/unix/nice"/renice.sh )
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
	
	#Optional, rarely used, intended for overload.
	includeScriptList+=( "structure"/prefixvars.sh )
	
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
	
	# ATTENTION: Running while X11 session is idle is a common requirement for a daemon.
	[[ "$enUb_build" == "true" ]] && [[ "$enUb_x11" == "true" ]] && includeScriptList+=( "generic/process"/idle.sh )
	
	[[ "$enUb_build" == "true" ]] && includeScriptList+=( "structure"/build.sh )
}

_compile_bash_environment() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/localfs.sh )
	
	includeScriptList+=( "structure"/localenv.sh )
	includeScriptList+=( "structure"/localenv_prog.sh )
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

_compile_bash_extension() {
	export includeScriptList
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/build"/deps_meta.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/build"/compile_meta.sh )
}

#placehoder, define under "metaengine/build"
#_compile_bash_metaengine() {
#	true
#}

#placeholder, define under "metaengine/build"
#_compile_bash_vars_metaengine() {
#	true
#}

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
	
	_compile_bash_shortcuts_os
	
	_compile_bash_bundled
	_compile_bash_bundled_prog
	
	_compile_bash_command
	
	_compile_bash_user
	
	_compile_bash_hardware
	
	_tryExec _compile_bash_metaengine
	
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
	
	_tryExec _compile_bash_vars_metaengine
	
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
	
	_compile_bash_extension
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
# WARNING Exact behavior of this system is critical to some use cases.
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

_diag() {
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
			"$scriptLinkCommand" "$@"
			internalFunctionExitStatus="$?"
			
			#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
			if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]]
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
if [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" != "--bypass" ]]
then
	return 0 > /dev/null 2>&1
	exit 0
fi

#####Entry

#"$scriptAbsoluteLocation" _setup


_main "$@"


