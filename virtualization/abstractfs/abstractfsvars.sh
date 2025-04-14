

# No production use (ie. not used by 'abstractfs' itself, but recommended flag variables as a standard for other scripts using 'abstractfs' to follow).
#
# Flag. Need 'abstractfs' (eg. ''./ubiquitous_bash.sh _abstractfs bash' ) path consistency (eg. '/dev/shm/uk4u/zjZktz7G/ubiquitous_bash.sh' ) enough to force subsequent commands (eg. ArduinoIDE) to run under Linux/WSL unless specifically exempted (eg. upload firmware under Cygwin/MSW after compile under Linux/WSL) .
#_set_abstractfs_wsl
_set_abstractfs_alwaysUNIXneverNative() {
	export abstractfs_alwaysUNIXneverNative="true"
}
# Allow native paths (eg. 'C:\abstract/uk4u/zjZktz7G/ubiquitous_bash.sh' ) . STRONGLY DISCOURAGED, but may be default, because otherwise native MSWindows binaries would not be used by default.
_set_abstractfs_allowNative() {
	export abstractfs_alwaysUNIXneverNative="false"
}
_set_abstractfs_enable() {
	export abstractfs_enable="true"
}
# Suggested default. If 'abstractfs' can be avoided, then native MSWindows binaries, etc, will be usable.
_set_abstractfs_disable() {
	export abstractfs_disable="true"
}



_reset_abstractfs() {
	export abstractfs=
	export abstractfs_base=
	export abstractfs_name=
	export abstractfs_puid=
	export abstractfs_projectafs=
	export abstractfs_projectafs_dir=
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
	
	# ATTENTION: Using absolute folder, may preserve apparent parent directory name at the expense of reducing likelihood of 8.3 compatibility.
	#./ubiquitous_bash.sh _abstractfs ls -lad ./.
	#/dev/shm/uk4u/randomid/.
	#/dev/shm/uk4u/randomid/ubiquitous_bash
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
	#git remote show origin 2>/dev/null
	git config --get remote.origin.url
	
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
		export abstractfs_projectafs_dir=$(_getAbsoluteFolder "./project.afs")
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

# $abstractfs_root/$abstractfs_name

export abstractfs_name="$abstractfs_name"




















































if [[ "\$1" != "--noexec" ]]
then
	
#####
CZXWXcRMTo8EmM8i4d


	declare -f _getScriptAbsoluteLocation
	declare -f _getScriptAbsoluteFolder
	
	
	
	declare -f _checkBaseDirRemote_common_localOnly
	declare -f _checkBaseDirRemote_common_remoteOnly
	
	
	
	declare -f _checkBaseDirRemote
	
	
	
	declare -f _compat_realpath
	declare -f _compat_realpath_run
	
	declare -f _getAbsoluteLocation
	declare -f _realpath_L_s
	declare -f _getAbsoluteFolder
	
	
	declare -f _findDir
	
	
	
	declare -f _safeEcho_newline
	
	declare -f _searchBaseDir
	
	
	
	declare -f _checkBaseDirRemote
	#_declare -f _safeEcho_newline
	declare -f _safeEcho
	
	declare -f _localDir
	
	
	
	#_declare -f _safeEcho_newline
	
	
	
	#_declare -f _safeEcho_newline
	
	declare -f _slashBackToForward
	
	
	
	declare -f _checkBaseDirRemote_app_localOnly
	declare -f _checkBaseDirRemote_app_remoteOnly
	declare -f _pathPartOf
	declare -f _realpath_L
	
	declare -f _virtUser
	
	
	
	declare -f _x11_clipboard_sendText
	declare -f _removeFilePrefix
	

cat << CZXWXcRMTo8EmM8i4d	
	
#####
	
	
#####
	
	cd "\$(_getScriptAbsoluteFolder)"
	
	
	export standalone_abstractfs="$abstractfs_root"/"$abstractfs_name"
	export standalone_abstractfs_base=\$(_getScriptAbsoluteFolder)
	
	
	export sharedHostProjectDir="\$standalone_abstractfs_base"
	export sharedGuestProjectDir="\$standalone_abstractfs"
	
	current_x11_clipboard=\$(xclip -out -selection clipboard)
	current_x11_clipboard=\$(_removeFilePrefix "\$current_x11_clipboard")
	
	# Replace (if relevant) ./../.. ... /../home/user/ ... with /home/"\$USER"/ .
	#current_x11_clipboard=\${current_x11_clipboard/*\/home\//\/home\/}
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\//\/home\//')
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/'"\$USER"'/\/home\/'"\$USER"'/')
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/[a-zA-Z0-9_\-]*/\/home\/'"\$USER"'/')
	current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/[^/]*/\/home\/'"\$USER"'/')
	
	#if [[ -e "\${processedArgs[0]}" ]]
	if [[ -e "\$current_x11_clipboard" ]]
	then
		_virtUser "\$current_x11_clipboard"
		_safeEcho "\${processedArgs[0]}" | _x11_clipboard_sendText
	fi
fi

CZXWXcRMTo8EmM8i4d
}

_write_projectAFS() {
	local testAbstractfsBase
	testAbstractfsBase="$abstractfs_base"
	[[ "$1" != "" ]] && testAbstractfsBase=$(_getAbsoluteLocation "$1")
	
	# ATTENTION: Hardcoded paths to prevent accidental creation of 'project.afs' file in user's home or similar directories
	# Keep in mind even within a 'chroot' or similar virtualized environment, a 'project' directory would typically be used.
	[[ "$testAbstractfsBase" == /home/"$USER" ]] && return 1
	[[ "$testAbstractfsBase" == /home/"$USER"/ ]] && return 1
	[[ "$testAbstractfsBase" == /root ]] && return 1
	[[ "$testAbstractfsBase" == /root/ ]] && return 1
	[[ "$testAbstractfsBase" == /tmp ]] && return 1
	[[ "$testAbstractfsBase" == /tmp/ ]] && return 1
	[[ "$testAbstractfsBase" == /dev ]] && return 1
	[[ "$testAbstractfsBase" == /dev/ ]] && return 1
	[[ "$testAbstractfsBase" == /dev/shm ]] && return 1
	[[ "$testAbstractfsBase" == /dev/shm/ ]] && return 1
	[[ "$testAbstractfsBase" == / ]] && return 1
	
	( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] || [[ "$nofs_write" == "true" ]] || [[ "$afs_nofs_write" == "true" ]] ) && return 0
	_projectAFS_here > "$testAbstractfsBase"/project.afs
	chmod u+x "$testAbstractfsBase"/project.afs
}

# DANGER: Mandatory strict directory 8.3 compliance for this variable! Long subdirectory/filenames permitted thereafter.
_default_name_abstractfs() {
	#If "$abstractfs_name" is not saved to file, a consistent, compressed, naming scheme, is required.
	if ( [[ "$nofs" == "true" ]] || [[ "$afs_nofs" == "true" ]] )
	then
		#echo $(basename "$abstractfs_base") | md5sum | head -c 8
		_describe_abstractfs "$@" | md5sum | _filter_random | head -c 8
		return
	fi
	
	cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-z' 2> /dev/null | head -c "1" | _filter_random 2> /dev/null
	#cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-z0-9' 2> /dev/null | head -c "7"  | _filter_random 2> /dev/null
	_uid 7
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
