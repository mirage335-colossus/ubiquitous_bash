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
# DANGER: Recursion hazard. Do not create overrides without checking that alternate exists.

# WARNING: Only partially compatible.
if ! type md5sum > /dev/null 2>&1 && type md5 > /dev/null 2>&1
then
	md5sum() {
		md5 "$@"
	}
fi

# DANGER: No production use. Testing only.
# WARNING: Only partially compatible.
#if ! type md5 > /dev/null 2>&1 && type md5sum > /dev/null 2>&1
#then
#	md5() {
#		md5sum "$@"
#	}
#fi


# WARNING: DANGER: Compatibility may not be guaranteed!
if ! type unionfs-fuse > /dev/null 2>&1 && type unionfs > /dev/null 2>&1 && man unionfs | grep 'unionfs-fuse - A userspace unionfs implementation' > /dev/null 2>&1
then
	unionfs-fuse() {
		unionfs "$@"
	}
fi

if ! type qemu-arm-static > /dev/null 2>&1 && type qemu-arm > /dev/null 2>&1
then
	qemu-arm-static() {
		qemu-arm "$@"
	}
fi

if ! type qemu-armeb-static > /dev/null 2>&1 && type qemu-armeb > /dev/null 2>&1
then
	qemu-armeb-static() {
		qemu-armeb "$@"
	}
fi


#Override (Program).

#Override, cygwin.

# ATTENTION: User must launch "tmux" (no parameters) in a graphical Cygwin terminal.
# Launches graphical application through "tmux new-window" if available.
# https://superuser.com/questions/531787/starting-windows-gui-program-in-windows-through-cygwin-sshd-from-ssh-client
_workaround_cygwin_tmux() {
	if pgrep -u "$USER" ^tmux$ > /dev/null 2>&1
	then
		tmux new-window "$@"
		return "$?"
	fi
	
	"$@"
	return "$?"
}

if ! type nmap > /dev/null 2>&1 && type '/cygdrive/c/Program Files/Nmap/nmap.exe' > /dev/null 2>&1
then
	nmap() {
		'/cygdrive/c/Program Files/Nmap/nmap.exe' "$@"
	}
fi

if ! type nmap > /dev/null 2>&1 && type '/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' > /dev/null 2>&1
then
	nmap() {
		'/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' "$@"
	}
fi

# DANGER: Severely differing functionality. Intended only to stand in for "ip addr show" and similar.
if ! type ip > /dev/null 2>&1 && type 'ipconfig' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	ip() {
		if [[ "$1" == "addr" ]] && [[ "$2" == "show" ]]
		then
			ipconfig
			return $?
		fi
		
		return 1
	}
fi



# WARNING: Native 'vncviewer.exe' is a GUI app, and cannot be launched directly from Cygwin SSH server.

#if ! type vncviewer > /dev/null 2>&1 && type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1

if type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		_workaround_cygwin_tmux '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' "$@"
	}
fi

if type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		_workaround_cygwin_tmux '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' "$@"
	}
fi


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

_test_readlink_f_sequence() {
	_start
	
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
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
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
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
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

_condition_lines_zero() {
	local currentLineCount
	currentLineCount=$(wc -l)
	
	[[ "$currentLineCount" == 0 ]] && return 0
	return 1
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

#Purple. User must do something manually to proceed. NOT to be used for dependency installation requests - use probe, bad, and fail statements for that.
_messagePlain_request() {
	echo -e -n '\E[0;35m '
	echo -n "$@"
	echo -e -n ' \E[0m'
	echo
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

#Blue. Diagnostic instrumentation.
#Prints "$@" with quotes around every parameter.
_messagePlain_probe_quoteAdd() {
	
	#https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
	
	local currentCommandStringPunctuated
	local currentCommandStringParameter
	for currentCommandStringParameter in "$@"; do 
		currentCommandStringParameter="${currentCommandStringParameter//\\/\\\\}"
		currentCommandStringPunctuated="$currentCommandStringPunctuated \"${currentCommandStringParameter//\"/\\\"}\""
	done
	#_messagePlain_probe "$currentCommandStringPunctuated"
	
	echo -e -n '\E[0;34m '
	
	_safeEcho "$currentCommandStringPunctuated"
	
	echo -e -n ' \E[0m'
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

#Gets filename extension, specifically any last three characters in given string.
#"$1" == filename
_getExt() {
	echo "$1" | tr -dc 'a-zA-Z0-9.' | tr '[:upper:]' '[:lower:]' | tail -c 4
}

#Reports either the directory provided, or the directory of the file provided.
_findDir() {
	local dirIn=$(_getAbsoluteLocation "$1")
	dirInLogical=$(_realpath_L_s "$dirIn")
	
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
	
	if [[ "$relinkRelativeUb" == "true" ]]
	then
		_rmlink "$2" && ln -s --relative "$1" "$2" && return 0
	fi
	
	return 1
}

_relink() {
	[[ "$2" == "/dev/null" ]] && return 1
	[[ "$relinkRelativeUb" == "true" ]] && export relinkRelativeUb=""
	_relink_procedure "$@"
}

_relink_relative() {
	export relinkRelativeUb=""
	
	[[ "$relinkRelativeUb" != "true" ]] && ln --help 2>/dev/null | grep '\-\-relative' > /dev/null 2>&1 && export relinkRelativeUb="true"
	[[ "$relinkRelativeUb" != "true" ]] && ln 2>&1 | grep '\-\-relative' > /dev/null 2>&1 && export relinkRelativeUb="true"
	[[ "$relinkRelativeUb" != "true" ]] && man ln 2>/dev/null | grep '\-\-relative' > /dev/null 2>&1 && export relinkRelativeUb="true"
	
	_relink_procedure "$@"
	export relinkRelativeUb=""
	unset relinkRelativeUb
}

#Copies files only if source/destination do match. Keeps files in a completely written state as often as possible.
_cpDiff() {
	! diff "$1" "$2" > /dev/null 2>&1 && cp "$1" "$2"
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
	
	# WARNING: Cygwin port range detection not yet implemented.
	if uname -a | grep -i cygwin > /dev/null 2>&1
	then
		! type nmap > /dev/null 2>&1 && echo "missing socket detection" && _stop 1
		return 0
	fi
	
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
	
	if uname -a | grep -i cygwin > /dev/null 2>&1
	then
		nmap --host-timeout 0.1 -Pn localhost -p "$1" 2> /dev/null | grep open > /dev/null 2>&1
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

_showPort_ipv6() {
	nmap -6 --host-timeout "$netTimeout" -Pn "$1" -p "$2" 2> /dev/null
}

_showPort_ipv4() {
	nmap --host-timeout "$netTimeout" -Pn "$1" -p "$2" 2> /dev/null
}

_checkPort_ipv6() {
	if _showPort_ipv6 "$@" | grep open > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkPort_ipv4() {
	if _showPort_ipv4 "$@" | grep open > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}

_checkPort_sequence() {
	_start
	
	local currentEchoStatus
	currentEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
	
	local currentExitStatus
	
	if ( [[ "$1" == 'localhost' ]] || [[ "$1" == '::1' ]] || [[ "$1" == '127.0.0.1' ]] )
	then
		_checkPort_ipv4 "localhost" "$2"
		return "$?"
	fi
	
	#Lack of coproc support implies old system, which implies IPv4 only.
	#if ! type coproc >/dev/null 2>&1
	#then
	#	_checkPort_ipv4 "$1" "$2"
	#	return "$?"
	#fi
	
	( ( _showPort_ipv4 "$1" "$2" ) 2> /dev/null > "$safeTmp"/_showPort_ipv4 & )
	
	( ( _showPort_ipv6 "$1" "$2" ) 2> /dev/null > "$safeTmp"/_showPort_ipv6 & )
	
	
	local currentTimer
	currentTimer=1
	while [[ "$currentTimer" -le "$netTimeout" ]]
	do
		grep -m1 'open' "$safeTmp"/_showPort_ipv4 > /dev/null 2>&1 && _stop
		grep -m1 'open' "$safeTmp"/_showPort_ipv6 > /dev/null 2>&1 && _stop
		
		! [[ $(jobs | wc -c) -gt '0' ]] && ! grep -m1 'open' "$safeTmp"/_showPort_ipv4 && grep -m1 'open' "$safeTmp"/_showPort_ipv6 > /dev/null 2>&1 && _stop 1
		
		let currentTimer="$currentTimer"+1
		sleep 1
	done
	
	
	_stop 1
}

# DANGER: Unstable, abandoned. Reference only.
# WARNING: Limited support for older systems.
#https://unix.stackexchange.com/questions/86270/how-do-you-use-the-command-coproc-in-various-shells
#http://wiki.bash-hackers.org/syntax/keywords/coproc
#http://mywiki.wooledge.org/BashFAQ/024
#[[ $COPROC_PID ]] && kill $COPROC_PID
#coproc { bash -c '(sleep 9 ; echo test) &' ; bash -c 'echo test' ;  } ; grep -m1 test <&${COPROC[0]}
#coproc { echo test ; echo x ; } ; sleep 1 ; grep -m1 test <&${COPROC[0]}
_checkPort_sequence_coproc() {
	local currentEchoStatus
	currentEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
	
	local currentExitStatus
	
	if ( [[ "$1" == 'localhost' ]] || [[ "$1" == '::1' ]] || [[ "$1" == '127.0.0.1' ]] )
	then
		_checkPort_ipv4 "localhost" "$2"
		return "$?"
	fi
	
	#Lack of coproc support implies old system, which implies IPv4 only.
	if ! type coproc >/dev/null 2>&1
	then
		_checkPort_ipv4 "$1" "$2"
		return "$?"
	fi
	
	#coproc { sleep 30 ; echo foo ; sleep 30 ; echo bar; } ; grep -m1 foo <&${COPROC[0]}
	#[[ $COPROC_PID ]] && kill $COPROC_PID ; coproc { ((sleep 1 ; echo test) &) ; echo x ; sleep 3 ; } ; sleep 0.1 ; grep -m1 test <&${COPROC[0]}
	
	[[ "$COPROC_PID" ]] && kill "$COPROC_PID" > /dev/null 2>&1
	coproc {
		( ( _showPort_ipv4 "$1" "$2" ) & )
		
		#[sleep] Lessens unlikely occurrence of interleaved text within "open" keyword.
		#IPv6 delayed instead of IPv4 due to likelihood of additional delay by IPv6 tunneling.
		#sleep 0.1
		
		# TODO: Better characterize problems with sleep.
		# Workaround - sleep may disable 'stty echo', which may be irreversable within SSH proxy command.
		#_timeout 0.1 cat < /dev/zero > /dev/null
		if ! ping -c 2 -i 0.1 localhost > /dev/null 2>&1
		then
			ping -c 2 -i 1 localhost > /dev/null 2>&1
		fi
		
		#[sleep] Lessens unlikely occurrence of interleaved text within "open" keyword.
		#IPv6 delayed instead of IPv4 due to likelihood of additional delay by IPv6 tunneling.
		( ( _showPort_ipv6 "$1" "$2" ) & )

		#sleep 2
		ping -c 2 -i 2 localhost > /dev/null 2>&1
	}
	grep -m1 open <&"${COPROC[0]}" > /dev/null 2>&1
	currentExitStatus="$?"
	
	stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
	
	return "$currentExitStatus"
}

#Checks hostname for open port.
#"$1" == hostname
#"$2" == port
_checkPort() {
	#local currentEchoStatus
	#currentEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
	
	#if bash -c \""$scriptAbsoluteLocation"\"\ _checkPort_sequence\ \""$1"\"\ \""$2"\" > /dev/null 2>&1
	if "$scriptAbsoluteLocation" _checkPort_sequence "$1" "$2" > /dev/null 2>&1
	then
		#stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
		return 0
	fi
	#stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
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

#####Shortcuts

_visualPrompt() {
	#+%H:%M:%S\ %Y-%m-%d\ Q%q
	#+%H:%M:%S\ %b\ %d,\ %y

	#Long.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]--\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]-|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '

	#Short.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]-\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	#Truncated, 40 columns.
	export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
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
	
	local currentExitStatus
	
	export queryType="server"
	"$ub_queryserver" "$@"
	currentExitStatus="$?"
	
	env > env_$(_uid)
	
	_stop "$currentExitStatus"
}
_queryServer() {
	"$scriptAbsoluteLocation" _queryServer_sequence "$@"
}
_qs() {
	_queryServer "$@"
}

_queryClient_sequence() {
	_start
	
	local currentExitStatus
	
	export queryType="client"
	"$ub_queryclient" "$@"
	currentExitStatus="$?"
	
	env > env_$(_uid)
	
	_stop "$currentExitStatus"
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

_setupUbiquitous_here() {
	cat << CZXWXcRMTo8EmM8i4d

if type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1
then
	# Greater or equal, '_priority_critical_pid_root' .
	sudo -n renice -n -15 -p \$\$ > /dev/null 2>&1
	sudo -n ionice -c 2 -n 2 -p \$\$ > /dev/null 2>&1
fi
# ^
# Ensures admin user shell startup, including Ubiquitous Bash, is relatively quick under heavy system load.
# Near-realtime priority may be acceptable, due to reliability of relevant Ubiquitous Bash functions.
# WARNING: Do NOT prioritize highly enough to interfere with embedded hard realtime processes.


export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptFolder="$ubcoreUBdir"
[[ "\$scriptAbsoluteLocation" != "" ]] && . "\$scriptAbsoluteLocation" --parent _importShortcuts
[[ "\$scriptAbsoluteLocation" == "" ]] && . "\$profileScriptLocation" --profile _importShortcuts


# Returns priority to normal.
# Greater or equal, '_priority_app_pid_root' .
#ionice -c 2 -n 3 -p \$\$
#renice -n -5 -p \$\$ > /dev/null 2>&1

# Returns priority to normal.
# Greater or equal, '_priority_app_pid' .
ionice -c 2 -n 4 -p \$\$
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
		
		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: git pull' && cd "$localFunctionEntryPWD" && return 0
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
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winehere
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winecfghere
	
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

# ATTENTION: Overload with 'core.sh' or similar.
# WARNING: May become default behavior.
_anchor_autoupgrade() {
	local currentScriptBaseName
	currentScriptBaseName=$(basename $scriptAbsoluteLocation)
	[[ "$currentScriptBaseName" != "ubiquitous_bash.sh" ]] && return 1
	
	true
	#[[ -e "$scriptLib"/ubiquitous_bash/_anchor ]] && cp -a "$scriptLib"/ubiquitous_bash/_anchor "$scriptAbsoluteFolder"/_anchor
}

_anchor() {
	_anchor_autoupgrade
	
	! [[ -e "$scriptAbsoluteFolder"/_anchor ]] && return 1
	
	#https://superuser.com/questions/450868/what-is-the-simplest-scriptable-way-to-check-whether-a-shell-variable-is-exporte
	! [ "$(bash -c 'echo ${objectName}')" ] && return 1
	
	
	rm -f "$scriptAbsoluteFolder"/_anchor.tmp > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_anchor.tmp
	perl -p -e 's/export anchorSourceDir=.*/export anchorSourceDir="$ENV{objectName}"/g' "$scriptAbsoluteFolder"/_anchor > "$scriptAbsoluteFolder"/_anchor.tmp
	mv "$scriptAbsoluteFolder"/_anchor.tmp "$scriptAbsoluteFolder"/_anchor
	
	[[ "$scriptAbsoluteFolder" == *"ubiquitous_bash" ]] && _refresh_anchors_ubiquitous
	
	if type "_refresh_anchors" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors"
		return
	fi
	
	return 0
}




_setup_renice() {
	_messageNormal '_setup_renice'
	
	if [[ "$scriptAbsoluteFolder" == *'ubiquitous_bash' ]] && [[ "$1" != '--force' ]]
	then
		_messagePlain_bad 'bad: generic ubiquitous_bash installation detected'
		_messageFAIL
		_stop 1
	fi
	
	
	_messagePlain_nominal '_setup_renice: hook: ubcore'
	local ubHome
	ubHome="$HOME"
	export ubcoreDir="$ubHome"/.ubcore
	export ubcoreFile="$ubcoreDir"/.ubcorerc
	
	if ! [[ -e "$ubcoreFile" ]]
	then
		_messagePlain_warn 'fail: hook: missing: .ubcorerc'
		return 1
	fi
	
	if grep 'token_ub_renice' "$ubcoreFile" > /dev/null 2>&1
	then
		_messagePlain_good 'good: hook: present: .ubcorerc'
		return 0
	fi
	
	#echo '# token_ub_renice' >> "$ubcoreFile"
	cat << CZXWXcRMTo8EmM8i4d >> "$ubcoreFile"

# token_ub_renice
if [[ "\$__overrideRecursionGuard_make" != 'true' ]] && [[ "\$__overrideKeepPriority_make" != 'true' ]] && type type > /dev/null 2>&1 && type -p make > /dev/null 2>&1
then
	__overrideRecursionGuard_make='true'
	__override_make=$(type -p make 2>/dev/null)
	make() {
		#Greater or equal, _priority_idle_pid
		
 		ionice -c 2 -n 5 -p \$\$ > /dev/null 2>&1
		renice -n 3 -p \$\$ > /dev/null 2>&1
		
		"\$__override_make" "\$@"
	}
fi

CZXWXcRMTo8EmM8i4d
	
	if grep 'token_ub_renice' "$ubcoreFile" > /dev/null 2>&1
	then
		_messagePlain_good 'good: hook: present: .ubcorerc'
		#return 0
	else
		_messagePlain_bad 'fail: hook: missing: token: .ubcorerc'
		_messageFAIL
		return 1
	fi
	
	
	
	_messagePlain_nominal '_setup_renice: hook: cron'
	echo '@reboot '"$scriptAbsoluteLocation"' _unix_renice_execDaemon' | crontab -
	
	#echo '*/7 * * * * '"$scriptAbsoluteLocation"' _unix_renice'
	#echo '*/1 * * * * '"$scriptAbsoluteLocation"' _unix_renice_app'
}

# WARNING: Recommend, using an independent installation (ie. not '~/core/infrastructure/ubiquitous_bash').
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
	# sleep 0.7
	_unix_renice_app
	_unix_renice
	
	sleep 3
	_unix_renice_app
	_unix_renice
	
	sleep 9
	_unix_renice_app
	_unix_renice
	
	sleep 27
	_unix_renice_app
	_unix_renice
	
	sleep 27
	_unix_renice_app
	_unix_renice
	
	local currentIteration
	while true
	do
		currentIteration=0
		while [[ "$currentIteration" -lt "4" ]]
		do
			sleep 120
			[[ "$matchingEMBEDDED" != 'false' ]] && sleep 120
			_unix_renice_app > /dev/null 2>&1
			let currentIteration="$currentIteration"+1
		done
		
		_unix_renice
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
	
	
	_priority_enumerate_pattern "^okular$" >> "$processListFile"
	
	_priority_enumerate_pattern "^xournal$" >> "$processListFile"
	
	_priority_enumerate_pattern "^soffice.bin$" >> "$processListFile"
	
	
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
	
	
	# WARNING: Probably unnecessary and counterproductive. May risk halting important compile jobs.
	#_priority_enumerate_pattern "^cc1$" >> "$processListFile"
	#_priority_enumerate_pattern "^cc1plus$" >> "$processListFile"
	
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_idle_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}



#####Basic Variable Management

#Reset prefixes.
export tmpPrefix="" 

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
	if ! chown "$USER":"$USER" "$abstractfs_root" > /dev/null 2>&1
	then
		! /sbin/chown "$USER" "$abstractfs_root" && exit 1
	fi
	
	
	! mkdir -p "$abstractfs_lock" && exit 1
	chmod 0700 "$abstractfs_lock" > /dev/null 2>&1
	! chmod 700 "$abstractfs_lock" && exit 1
	if ! chown "$USER":"$USER" "$abstractfs_lock" > /dev/null 2>&1
	then
		! /sbin/chown "$USER" "$abstractfs_root" && exit 1
	fi
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
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
	
	_prepare
	
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
}

# DANGER: Use of "_stop" must NOT require successful "_start". Do NOT include actions which would not be safe if "_start" was not used or unsuccessful.
_stop() {
	_stop_stty_echo
	
	_tryExec "_stop_prog"
	
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
	
	[[ -e "$safeTmp" ]] && sleep 0.1 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 0.3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 1 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	[[ -e "$safeTmp" ]] && sleep 3 && _safeRMR "$safeTmp"
	
	_tryExec _rm_instance_fakeHome
	
	#Optionally always try to remove any systemd shutdown hook.
	#_tryExec _unhook_systemd_shutdown
	
	
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

_testarglength() {
	local testArgLength
	
	! testArgLength=$(getconf ARG_MAX) && _messageFAIL && _stop 1
	
	
	# Typical UNIX.
	if [[ "$testArgLength" -lt 131071 ]]
	then
		# Typical Cygwin. Marginal result at best.
		[[ "$testArgLength" -ge 32000 ]] && uname -a | grep -i 'cygwin' > /dev/null 2>&1 && return 0
		
		_messageFAIL && _stop 1
	fi
	
	_messagePASS
}

#_test_prog() {
#	true
#}

_test() {
	_messageNormal "Sanity..."
	
	! "$scriptAbsoluteLocation" _true && _messageFAIL && return 1
	"$scriptAbsoluteLocation" _false && _messageFAIL && return 1
	
	local santiySessionID_length
	santiySessionID_length=$(echo -n "$sessionid" | wc -c | tr -dc '0-9')
	
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
	
	echo 'true' > "$safeTmp"/shouldNotOverwrite
	mv "$safeTmp"/doesNotExist "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1 && _messageFAIL && return 1
	[[ $(cat "$safeTmp"/shouldNotOverwrite) != "true" ]] && _messageFAIL && return 1
	rm -f "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1
	
	
	_getDep flock
	
	( flock 200; echo > "$safeTmp"/ready ; sleep 3 ) 200>"$safeTmp"/flock &
	sleep 1
	if ( flock 200; ! [[ -e "$safeTmp"/ready ]] ) 200>"$safeTmp"/flock
	then
		_messageFAIL
		_stop 1
	fi
	rm -f "$safeTmp"/flock > /dev/null 2>&1
	rm -f "$safeTmp"/ready > /dev/null 2>&1
	
	ln -s /dev/null "$safeTmp"/working
	ln -s /dev/null/broken "$safeTmp"/broken
	if ! [[ -h "$safeTmp"/broken ]] || ! [[ -h "$safeTmp"/working ]] || [[ -e "$safeTmp"/broken ]] || ! [[ -e "$safeTmp"/working ]]
	then
		_messageFAIL
		_stop 1
	fi
	rm -f "$safeTmp"/working
	rm -f "$safeTmp"/broken
	
	_messagePASS
	
	
	_messageNormal "Permissions..."
	
	! _test_permissions_ubiquitous && _messageFAIL
	
	_messagePASS
	
	#Environment generated by ubiquitous bash is typically 10000 characters.
	echo -n -e '\E[1;32;46m Argument length...	\E[0m'
	
	_testarglength
	
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
	_getDep tac
	_getDep type
	_getDep mkdir
	_getDep trap
	_getDep return
	_getDep set
	
	# WARNING: Deprecated. Migrate to 'type -p' instead when possible.
	# WARNING: No known production use.
	#https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then
	_getDep which
	
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
	
	_test_readlink_f
	
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
	
	_tryExec "_test_prog"
	
	_stop
}

#_testBuilt_prog() {
#	true
#}

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
	
	_tryExec "_testBuilt_prog"
	
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
	#_find_setupCommands -name '_command' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_tryExec "_setup_ssh_commands"
	_tryExec "_setup_command_commands"
}

#_setup_pre() {
#	true
#}

#_setup_prog() {
#	true
#}

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
	
	_tryExec "_setup_pre"
	
	_tryExec "_setup_ssh"
	
	_tryExec "_setup_prog"
	
	_stop
}

# DANGER: Especially not expected to modify system program behavior (eg. not to modify "$HOME"/.ssh ).
# WARNING: Strictly expected to not modify anyting outside the script directory.
_setup_local() {
	export ub_setup_local='true'
	
	_setup
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
	cp -a "$scriptAbsoluteFolder"/ops.sh "$safeTmp"/package/
	
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

#currentReversePort=""
#currentMatchingReversePorts=""
#currentReversePortOffset=""
#matchingOffsetPorts=""
#matchingReversePorts=""
#matchingEMBEDDED=""

#Creates "${matchingOffsetPorts}[@]" from "${matchingReversePorts}[@]".
#Intended for public server tunneling (ie. HTTPS).
# ATTENTION: Overload with 'ops' .
_offset_reversePorts() {
	local currentReversePort
	local currentMatchingReversePorts
	local currentReversePortOffset
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		let currentReversePortOffset="$currentReversePort"+100
		currentMatchingReversePorts+=( "$currentReversePortOffset" )
	done
	matchingOffsetPorts=("${currentMatchingReversePorts[@]}")
	export matchingOffsetPorts
}


#####Network Specific Variables
#Statically embedded into monolithic ubiquitous_bash.sh/cautossh script by compile .

# WARNING Must use unique netName!
export netName=default
export gatewayName=gw-"$netName"-"$netName"
export LOCALSSHPORT=22


#Optional equivalent to LOCALSSHPORT, also respected for tunneling ports from other services.
export LOCALLISTENPORT="$LOCALSSHPORT"

# ATTENTION: Mostly future proofing. Due to placement of autossh within a 'while true' loop, associated environment variables are expected to have minimal, if any, effect.
#Poll time must be double network timeouts.
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

	if [[ "$testHostname" == 'hostnameA' ]] || [[ "$testHostname" == 'hostnameB' ]] || [[ "$testHostname" == '*' ]]
	then
		matchingReversePorts+=( '20001' )
		matched='true'
	fi
	if [[ "$testHostname" == 'hostnameC' ]] || [[ "$testHostname" == 'hostnameD' ]] || [[ "$testHostname" == '*' ]]
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

_offset_reversePorts
export matchingOffsetPorts

export keepKeys_SSH='true'

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
	
	trap 'excode=$?; _stop_emergency $excode; trap - EXIT; echo $excode' INT TERM	# reset
	trap 'excode=$?; trap "" EXIT; _stop_emergency $excode; echo $excode' INT TERM	# ignore
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


