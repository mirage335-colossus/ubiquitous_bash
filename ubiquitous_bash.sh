#!/usr/bin/env bash

#####Utilities

#Run command and output to terminal with colorful formatting. Controlled variant of "bash -v".
_showCommand() {
	echo -e '\E[1;32;46m $ '"$1"' \E[0m'
	"$@"
}

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

#Checks whether command or function is available.
# WARNING Needed by safeRMR .
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
# WARNING Not foolproof. Use to guard against systematic errors, not carelessness.
# WARNING Do NOT rely upon outside of internal programmatic usage inside script!
#"$1" == directory to remove
_safeRMR() {
	
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
	
	local safeScriptAbsoluteFolder="$_getScriptAbsoluteFolder"
	
	[[ "$1" == "./"* ]] && [[ "$PWD" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	[[ "$1" == "$safeScriptAbsoluteFolder"* ]] && safeToRM="true"
	
	#[[ "$1" == "/home/$USER"* ]] && safeToRM="true"
	[[ "$1" == "/tmp/"* ]] && safeToRM="true"
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ -d "$1" ]] && find "$1" | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
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

_discoverResource() {
	local testDir
	local scriptAbsoluteFolder
	scriptAbsoluteFolder=$(_getScriptAbsoluteFolder)
	testDir="$scriptAbsoluteFolder" ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return
	testDir="$scriptAbsoluteFolder"/.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return
	testDir="$scriptAbsoluteFolder"/../.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return
	testDir="$scriptAbsoluteFolder"/../../.. ; [[ -e "$testDir"/"$1" ]] && echo "$testDir"/"$1" && return
}

_testBindMountManager() {
	_checkDep mount
	_checkDep mountpoint
	
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
	_checkDep mountpoint
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

#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) } 

#Waits for the process PID specified by first parameter to end. Useful in conjunction with $! to provide process control and/or PID files. Unlike wait command, does not require PID to be a child of the current shell.
_pauseForProcess() {
	while ps --no-headers -p $1 &> /dev/null
	do
		sleep 0.3
	done
}
alias _waitForProcess=_pauseForProcess
alias waitForProcess=_pauseForProcess

#True if daemon is running.
_daemonStatus() {
	if [[ -e "$daemonPidFile" ]]
	then
		export daemonPID=$(cat "$daemonPidFile")
	fi
	
	ps -p "$daemonPID" >/dev/null 2>&1 && return 0
	return 1
}

_waitForTermination() {
	_daemonStatus && sleep 0.1
	_daemonStatus && sleep 0.3
	_daemonStatus && sleep 1
	_daemonStatus && sleep 2
}
alias _waitForDaemon=_waitForTermination

#Kills background process using PID file.
_killDaemon() {
	_daemonStatus && kill -TERM "$daemonPID" >/dev/null 2>&1
	
	_waitForTermination
	
	_daemonStatus && kill -KILL "$daemonPID" >/dev/null 2>&1
	
	_waitForTermination
	
	rm -f "$daemonPidFile" >/dev/null 2>&1
}

#Executes self in background (ie. as daemon).
_execDaemon() {
	"$scriptAbsoluteLocation" >/dev/null 2>&1 &
	echo "$!" > "$daemonPidFile"
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

#http://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port
_findPort() {
	lower_port="$1"
	upper_port="$2"
	
	#read lower_port upper_port < /proc/sys/net/ipv4/ip_local_port_range
	[[ "$lower_port" == "" ]] && lower_port=54000
	[[ "$upper_port" == "" ]] && upper_port=55000
	
	local portRangeOffset
	portRangeOffset=$RANDOM
	let "portRangeOffset %= 150"
	
	let "lower_port += portRangeOffset"
	
	while true
	do
		for (( port = lower_port ; port <= upper_port ; port++ )); do
			if ! ss -lpn | grep ":$port " > /dev/null 2>&1
			then
				sleep 0.1
				if ! ss -lpn | grep ":$port " > /dev/null 2>&1
				then
					break 2
				fi
			fi
		done
	done
	echo $port
}

#Generates random alphanumeric characters, default length 18.
_uid() {
	local uidLength
	[[ -z "$1" ]] && uidLength=18 || uidLength="$1"
	
	cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c "$uidLength"
}

#Validates non-empty request.
_validateRequest() {
	echo -e -n '\E[1;32;46m Validating request '"$1"'...	\E[0m'
	[[ "$1" == "" ]] && echo -e '\E[1;33;41m BLANK \E[0m' && return 1
	echo "PASS"
	return
}

#Copy log files to "$permaLog" or current directory (default) for analysis.
_preserveLog() {
	if [[ ! -d "$permaLog" ]]
	then
		permaLog="$PWD"
	fi
	
	cp "$logTmp"/* "$permaLog"/ > /dev/null 2>&1
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
	
	_here_systemd_shutdown | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n systemctl start "$sessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
}

_hook_systemd_shutdown_action() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
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
	
	[[ "$SYSTEMCTLDISABLE" == "true" ]] && echo SYSTEMCTLDISABLE | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1 && return 0
	export SYSTEMCTLDISABLE=true
	
	sudo -n systemctl disable "$hookSessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n rm -f /etc/systemd/system/"$hookSessionid".service 2>&1 | sudo tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
}


_start_virt_instance() {
	
	mkdir -p "$instancedVirtDir" || return 1
	mkdir -p "$instancedVirtFS" || return 1
	mkdir -p "$instancedVirtTmp" || return 1
	
	mkdir -p "$instancedVirtHome" || return 1
	mkdir -p "$instancedVirtHomeRef" || return 1
	
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
	_wait_umount "$instancedVirtHomeRef"
	sudo -n rmdir "$instancedVirtHomeRef"
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



#Removes 'file://' often used by browsers.
_removeFilePrefix() {
	local translatedFileParam
	translatedFileParam=${1/#file:\/\/}
	
	echo "$translatedFileParam"
}

#Translates back slash parameters (UNIX paths) to forward slash parameters (MSW paths).
_slashBackToForward() {
	local translatedFileParam
	translatedFileParam=${1//\//\\}
	
	echo "$translatedFileParam"
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

#Checks if file/directory exists on remote system. Overload this function with implementation specific to the container/virtualization solution in use (ie. docker run).
_checkBaseDirRemote() {
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
	
	echo "$baseDir"
}

#Converts to relative path, if provided a file parameter.
#"$1" == parameter to search
#"$2" == sharedHostProjectDir
#"$3" == sharedGuestProjectDir (optional)
_localDir() {
	if _checkBaseDirRemote "$1"
	then
		echo "$1"
		return
	fi
	
	if [[ ! -e "$2" ]]
	then
		echo "$1"
		return
	fi
	
	if [[ ! -e "$1" ]] && ! _pathPartOf "$1" "$2"
	then
		echo "$1"
		return
	fi
	
	[[ "$3" != "" ]] && echo -n "$3"/
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
	
	if [[ -e /tmp/.X11-unix ]] && [[ "$DISPLAY" != "" ]] && type xauth > /dev/null 2>&1
	then
		export XSOCK=/tmp/.X11-unix
		export XAUTH=/tmp/.virtuser.xauth."$sessionid"
		touch $XAUTH
		xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
	fi
	
	if [[ "$sharedHostProjectDir" == "" ]]
	then
		sharedHostProjectDir=$(_searchBaseDir "$@" "$outerPWD")
		#sharedHostProjectDir="$safeTmp"/shared
		mkdir -p "$sharedHostProjectDir"
	fi
	
	export localPWD=$(_localDir "$outerPWD" "$sharedHostProjectDir" "$sharedGuestProjectDir")
	
	#If $sharedGuestProjectDir matches MSW drive letter format, enable translation of other non-UNIX file parameter differences.
	local enableMSWtranslation
	enableMSWtranslation=false
	echo "$sharedGuestProjectDir" | grep '^[[:alpha:]]\:\|^[[:alnum:]][[:alnum:]]\:\|^[[:alnum:]][[:alnum:]][[:alnum:]]\:' > /dev/null 2>&1 && enableMSWtranslation=true
	
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

_createRawImage_sequence() {
	_start
	
	export vmImageFile="$scriptLocal"/vm.img
	
	[[ "$1" != "" ]] && export vmImageFile="$1"
	
	[[ "$vmImageFile" == "" ]] && _stop 1
	[[ -e "$vmImageFile" ]] && _stop 1
	
	dd if=/dev/zero of="$vmImageFile" bs=1G count=6
	
	_stop
}

_createRawImage() {
	
	"$scriptAbsoluteLocation" _createRawImage_sequence "$@"
	
}

_here_bootdisc_shellbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
CALL Y:\loader.bat
CALL Y:\application.bat
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderZbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use z: \\VBOXSVR\root

:checkMount
ping -n 2 127.0.0.1 > nul
IF NOT EXIST "Z:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderXbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use x: \\VBOXSVR\appFolder

:checkMount
ping -n 2 127.0.0.1 > nul
IF NOT EXIST "X:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_testVirtBootdisc() {
	if ! type mkisofs > /dev/null 2>&1 && ! type genisoimage > /dev/null 2>&1
	then
		echo 'need mkisofs or genisoimage'
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
	_mkisofs -R -uid 0 -gid 0 -dir-mode 0555 -file-mode 0555 -new-dir-mode 0555 -J -hfs -o "$hostToGuestISO" "$hostToGuestFiles"
}

_setShareMSW_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedGuestProjectDir="X:"
}

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
	echo -e -n 'start /MAX "explorer.exe" '
}

_createHTG_MSW() {
	_setShareMSW
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	
	
	_preCommand_MSW > "$hostToGuestFiles"/application.bat
	
	echo "${processedArgs[@]}" >> "$hostToGuestFiles"/application.bat
	 
	echo ""  >> "$hostToGuestFiles"/application.bat
	
	echo -e -n > "$hostToGuestFiles"/loader.bat
	[[ "$flagShareApp" == "true" ]] && _here_bootdisc_loaderXbat >> "$hostToGuestFiles"/loader.bat
	[[ "$flagShareRoot" == "true" ]] && _here_bootdisc_loaderZbat >> "$hostToGuestFiles"/loader.bat
	
	_here_bootdisc_shellbat > "$hostToGuestFiles"/shell.bat
	
	#https://www.cyberciti.biz/faq/howto-unix-linux-convert-dos-newlines-cr-lf-unix-text-format/
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/application.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/loader.bat
	sed -i 's/$'"/`echo \\\r`/" "$hostToGuestFiles"/shell.bat
}

_setShareUNIX_app() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
}

_setShareUNIX_root() {
	export sharedHostProjectDir="$sharedHostProjectDirDefault"
	export sharedGuestProjectDir="$sharedGuestProjectDirDefault"
	
	export sharedHostProjectDir=/
}

_setShareUNIX() {
	[[ "$flagShareApp" ]] && _setShareUNIX_app && return
	[[ "$flagShareApp" ]] && _setShareUNIX_root && return
	return 1
}

_createHTG_UNIX() {
	_setShareUNIX
	_virtUser "$@"
	#"$sharedHostProjectDir"
	#"${processedArgs[@]}"
	
	echo "${processedArgs[@]}" > "$hostToGuestFiles"/cmd.sh
	
	cp "$scriptAbsoluteLocation" "$hostToGuestFiles"/
}

_commandBootdisc() {
	_prepareBootdisc || return 1
	
	export flagShareRoot="false"
	
	#Rigiorously ensure flags will be set properly.
	[[ "$flagShareRoot" != "true" ]] && export flagShareRoot="false"
	[[ "$flagShareRoot" != "true" ]] && export flagShareApp="true"
	
	#Process for MSW.
	_createHTG_MSW "$@"
	
	#Process for UNIX.
	_createHTG_UNIX "$@"
	
	_writeBootdisc || return 1
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
	sudo -n cp "$scriptAbsoluteLocation" "$chrootDir"/usr/bin/ubiquitous_bash.sh
	sudo -n cp "$scriptBin"/gosu-armel "$chrootDir"/usr/bin/gosu-armel
	sudo -n cp "$scriptBin"/gosu-amd64 "$chrootDir"/usr/bin/gosu-amd64
	sudo -n cp "$scriptBin"/gosu-i386 "$chrootDir"/usr/bin/gosu-i386
	
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
	
	cp -n "$safeTmp"/imagedev "$scriptLocal"/imagedev > /dev/null 2>&1 || _stop 1
	
	local chrootimagedev
	chrootimagedev=$(cat "$safeTmp"/imagedev)
	
	local chrootimagepart
	#chrootimagepart="$chrootimagedev"p2
	chrootimagepart="$chrootimagedev"p1
	
	local chrootloopdevfs
	chrootloopdevfs=$(eval $(sudo -n blkid "$chrootimagepart" | awk ' { print $3 } '); echo $TYPE)
	
	! [[ "$chrootloopdevfs" == "ext4" ]] && return 1
	
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
	_open _waitChRoot_opening _mountChRoot_image
}

_closeChRoot() {
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
	
	sudo -n env -i HOME="/root" TERM="${TERM}" SHELL="/bin/bash" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" DISPLAY="$DISPLAY" localPWD="$localPWD" hostArch=$(uname -m) virtSharedUser="$virtGuestUser" $(sudo -n which chroot) "$chrootDir" "$@"
	
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
	rmdir "$instancedVirtHomeRef"
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
	mkdir -p "$instancedVirtHomeRef"
	
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
	sudo -n rmdir "$instancedVirtHomeRef"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser"/project > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef"/"$virtGuestUser" > /dev/null 2>&1
	sudo -n rmdir "$instancedVirtHomeRef" > /dev/null 2>&1
	
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
	
	! [[ -e "$globalVirtFS"/"$virtGuestHomeRef" ]] && _ubvrtusrChRoot_report_failure "nohome" "$virtGuestHomeRef" '[[ -e "$virtGuestHomeRef" ]]' && internalFailure=true
	
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
	
	_chroot usermod -a -G video "$virtGuestUser"  > /dev/null 2>&1 || return 1
	
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHome" > /dev/null 2>&1
	
	sudo -n cp -a "$globalVirtFS""$virtGuestHome" "$globalVirtFS""$virtGuestHomeRef"
	echo sudo -n cp -a "$globalVirtFS""$virtGuestHome" "$globalVirtFS""$virtGuestHomeRef"
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$virtGuestHomeRef" > /dev/null 2>&1
	
	rm -f "$globalVirtDir"/_ubvrtusr > /dev/null 2>&1 || _stop 1
	
	return 0
}

_userChRoot() {
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
	[[ $(id -u) != 0 ]] && cp -a "$instancedVirtHomeRef"/. "$instancedVirtHome"/ >> "$logTmp"/usrchrt.log 2>&1
	export chrootDir="$instancedVirtFS"
	
	
	export checkBaseDirRemote=_checkBaseDirRemote_chroot
	_virtUser "$@" >> "$logTmp"/usrchrt.log 2>&1
	
	_mountChRoot_project >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_chroot chown "$virtGuestUser":"$virtGuestUser" "$sharedGuestProjectDir" >> "$logTmp"/usrchrt.log 2>&1
	
	
	
	_chroot /bin/bash /usr/bin/ubiquitous_bash.sh _dropChRoot "${processedArgs[@]}"
	local userChRootExitStatus="$?"	
	
	
	
	_stopChRoot "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1
	
	_umountChRoot_project >> "$logTmp"/usrchrt.log 2>&1
	_umountChRoot_user_home >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	_umountChRoot_user >> "$logTmp"/usrchrt.log 2>&1 || _stop 1
	
	_rm_ubvrtusrChRoot
	
	"$scriptAbsoluteLocation" _checkForMounts "$instancedVirtFS" >> "$logTmp"/usrchrt.log 2>&1 && _stop 1
	
	_stop_virt_instance >> "$logTmp"/usrchrt.log 2>&1
	_stop "$userChRootExitStatus"
}

_removeUserChRoot() {
	_openChRoot
	
	_chroot userdel -r "$virtGuestUser" > /dev/null 2>&1
	_rm_ubvrtusrChRoot
	
	_removeChRoot
} 

_dropChRoot() {
	
	# Change to localPWD or home.
	cd "$localPWD"
	
	# Drop to user ubvrtusr or remain root, using gosu.
	_gosuExecVirt "$@"
}

_prepareChRootUser() {
	
	#_gosuExecVirt cp -r /etc/skel/. /home/
	
	#cp -a /home/"$virtGuestUser".ref/. /home/"$virtGuestUser"/
	#chown "$virtGuestUser":"$virtGuestUser" /home/"$virtGuestUser"
	
	true
	
}


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
	_testQEMU_hostArch_x64-raspi || _stop 1
	
	_testQEMU_x64-x64
	_checkDep qemu-arm-static
	_checkDep qemu-armeb-static
	
	_mustGetSudo
	
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
	_testQEMU_hostArch_x64-x64 || _stop 1
	
	_checkDep qemu-system-x86_64
	_checkDep qemu-img
}

_qemu-system() {
	qemu-system-x86_64 "$@"
}

_qemu() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" == "x86_64" ]]
	then
		mkdir -p "$scriptLocal"
		_createLocked "$scriptLocal"/_qemu || return 1
		
		qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -boot c -m 768
		
		rm -f "$scriptLocal"/_qemu
		return 0
	fi
	
	return 1
}

_userQemu_sequence() {
	_start
	
	mkdir -p "$instancedVirtDir" || _stop 1
	
	_readLocked "$scriptLocal"/_qemu && _stop 1
	
	_commandBootdisc "$@" || _stop 1
	
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768
	
	#https://wiki.qemu.org/Documentation/9psetup#Mounting_the_shared_path
	#qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -fsdev local,id=appFolder,path="$sharedHostProjectDir",security_model=mapped,writeout=writeout
	
	#https://askubuntu.com/questions/614098/unable-to-get-execute-bit-on-samba-share-working-with-windows-7-client
	#https://unix.stackexchange.com/questions/165554/shared-folder-between-qemu-windows-guest-and-linux-host
	#https://linux.die.net/man/1/qemu-kvm
	qemu-system-x86_64 -snapshot -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -drive file="$hostToGuestISO",media=cdrom -boot c -m 768 -net nic -net user,smb="$sharedHostProjectDir"
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_userQemu() {
	"$scriptAbsoluteLocation" _userQemu_sequence "$@"
}

_testVBox() {
	_checkDep VirtualBox
	_checkDep VBoxSDL
	_checkDep VBoxManage
	_checkDep VBoxHeadless
	
	#sudo -n checkDep dkms
}


_checkVBox_raw() {
	#Use existing VDI image if available.
	[[ -e "$scriptLocal"/vm.vdi ]] && return 1
	[[ ! -e "$scriptLocal"/vm.img ]] && return 1
	
	return 0
}

# WARNING
# Per VirtualBox developers, "This is a development tool and shall only be used to analyse problems. It is completely unsupported and will change in incompatible ways without warning."
# If that happens, this function will be revised quickly, possibly to the point of generating the VMDK file itself with a here document instead of VirtualBox commands. See "_diag/data/vmdkRawExample".
_create_vbox_raw() {
	VBoxManage internalcommands createrawvmdk -filename "$vboxRaw" -rawdisk "$1" > "$vboxRaw".log
}


_mountVBox_raw_sequence() {
	_start
	
	_checkVBox_raw || _stop 1
	
	_wantSudo || return 1
	
	_prepare_instance_vbox
	
	rm -f "$vboxRaw" > /dev/null 2>&1
	
	sudo -n losetup -f -P --show "$scriptLocal"/vm.img > "$safeTmp"/vboxloop 2> /dev/null || _stop 1
	
	cp -n "$safeTmp"/vboxloop "$scriptLocal"/vboxloop > /dev/null 2>&1 || _stop 1
	
	local vboximagedev
	vboximagedev=$(cat "$safeTmp"/vboxloop)
	
	_tryExecFull _hook_systemd_shutdown_action "_closeVBoxRaw" "$sessionid"
	
	sudo chown "$USER" "$vboximagedev" || _stop 1
	_create_vbox_raw "$vboximagedev"
	
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
	_checkVBox_raw || _stop 1
	
	_open _waitVBox_opening _mountVBox_raw
}

_closeVBoxRaw() {
	if [[ "$1" == "--force" ]]
	then
		_close --force _waitVBox_closing _umountVBox_raw
		[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
		return
	fi
	
	_close _waitVBox_closing _umountVBox_raw
	[[ "$1" != "" ]] && _tryExecFull _unhook_systemd_shutdown "$1"
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
	
	VBoxManage createvm --name "$sessionid" --ostype "$vboxOStype" --register --basefolder "$VBOX_USER_HOME_short"
}

_set_instance_vbox_features() {
	#VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 512 --nic1 nat --nictype1 "82543GC" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 1 --ioapic off --acpi on --pae off --chipset piix3
	
	VBoxManage modifyvm "$sessionid" --boot1 disk --biosbootmenu disabled --bioslogofadein off --bioslogofadeout off --bioslogodisplaytime 5 --vram 128 --memory 512 --nic1 nat --nictype1 "82543GC" --clipboard bidirectional --accelerate3d off --accelerate2dvideo off --vrde off --audio pulse --usb on --cpus 4 --ioapic on --acpi on --pae on --chipset ich9
	
}

_set_instance_vbox_share() {
	#VBoxManage sharedfolder add "$sessionid" --name "root" --hostpath "/"
	[[ "$sharedHostProjectDir" != "" ]] && VBoxManage sharedfolder add "$sessionid" --name "appFolder" --hostpath "$sharedHostProjectDir"
}

_set_instance_vbox_command() {
	_commandBootdisc "$@" || return 1
}

_create_instance_vbox() {
	_openVBoxRaw
	
	export vboxInstanceDiskImage="$scriptLocal"/vm.vdi
	_readLocked "$lock_open" && vboxInstanceDiskImage="$vboxRaw"
	! [[ -e "$vboxInstanceDiskImage" ]] && return 1
	
	_set_instance_vbox_type
	
	_set_instance_vbox_features
	
	_set_instance_vbox_command "$@"
	
	_set_instance_vbox_share
	
	VBoxManage storagectl "$sessionid" --name "IDE Controller" --add ide --controller PIIX4
	
	#export vboxDiskMtype="normal"
	[[ "$vboxDiskMtype" == "" ]] && export vboxDiskMtype="multiattach"
	VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "$vboxInstanceDiskImage" --mtype "$vboxDiskMtype"
	
	[[ -e "$hostToGuestISO" ]] && VBoxManage storageattach "$sessionid" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$hostToGuestISO"
	
	#VBoxManage showhdinfo "$scriptLocal"/vm.vdi

	#Suppress annoying warnings.
	VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutMouseIntegrationOn,showRuntimeError.warning.HostAudioNotResponding,remindAboutGoingSeamless,remindAboutInputCapture,remindAboutGoingFullscreen,remindAboutMouseIntegrationOff,confirmGoingSeamless,confirmInputCapture,remindAboutPausedVMInput,confirmVMReset,confirmGoingFullscreen,remindAboutWrongColorDepth"
	
	return 0
}

#Create and launch temporary VM around persistent disk image.
_user_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_create_instance_vbox "$@"
	
	 _vboxGUI --startvm "$sessionid"
	
	_rm_instance_vbox
	
	_stop
}

_user_instance_vbox() {
	"$scriptAbsoluteLocation" _user_instance_vbox_sequence "$@"
}

_userVBox() {
	_user_instance_vbox "$@"
}

_edit_instance_vbox_sequence() {
	_start
	
	_prepare_instance_vbox || return 1
	
	_readLocked "$vBox_vdi" && return 1
	
	_createLocked "$vBox_vdi" || return 1
	
	#VBoxManage modifymedium "$scriptLocal"/vm.vdi --type normal
	
	export vboxDiskMtype="normal"
	_create_instance_vbox "$@"
	
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
	_edit_instance_vbox "$@"
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
	_checkDep dosbox
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
	echo "${processedArgs[@]}" >> "$instancedVirtDir"/dosbox.conf
	
	dosbox -conf "$instancedVirtDir"/dosbox.conf
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_dosbox() {
	"$scriptAbsoluteLocation" _dosbox_sequence "$@"
}

_testWINE() {
	_checkDep wine
	
	if wine 2>&1 | grep 'wine32 is missing' > /dev/null 2>&1
	then
		echo 'wine32 may be missing'
		_stop 1
	fi
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

#Runs command directly if member of "docker" group, or through sudo if not.
#Docker inevitably requires effective root. 
_permitDocker() {
	if groups | grep docker > /dev/null 2>&1
	then
		"$@"
		return 0
	fi
	
	if _wantSudo > /dev/null 2>&1
	then
		sudo -n "$@"
		return 0
	fi
	
	return 1
}

_test_docker() {
	#https://docs.docker.com/engine/installation/linux/docker-ce/debian/#install-using-the-repository
	#https://wiki.archlinux.org/index.php/Docker#Installation
	#sudo usermod -a -G docker "$USER"
	
	#_checkDep /sbin/losetup
	if ! [[ -e "/dev/loop-control" ]] || ! [[ -e "/sbin/losetup" ]]
	then
		echo 'may be missing loopback interface'
		_stop 1
	fi
	
	_checkDep docker
	
	local dockerPermission
	dockerPermission=$(_permitDocker echo true 2> /dev/null)
	if [[ "$dockerPermission" != "true" ]]
	then
		echo 'no permissions to run docker'
		_stop 1
	fi
	
	if ! _permitDocker docker run hello-world 2>&1 | grep 'Hello from Docker' > /dev/null 2>&1
	then
		echo 'failed docker hello world'
		_stop 1
	fi
	
	if ! _discoverResource docker/contrib/mkimage.sh > /dev/null 2>&1
	#if true
	then
		echo
		echo 'base images cannot be created without mkimage'
		#_stop 1
	fi
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
	
	rootAvailable=$(sudo -n echo true)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && return 1
	
	return 0
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

_testBuiltGosu() {
	#export PATH="$PATH":"$scriptBin"
	
	_checkDep gpg
	_checkDep dirmngr
	
	_gosuBinary
	
	_checkDep "$gosuBinary"
	
	#Beware, this test requires either root or sudo to actually verify functionality.
	if ! "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1 && ! sudo -n "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1
	then
		echo gosu invalid response
		_stop 1
	fi
	
}

#From https://github.com/tianon/gosu/blob/master/INSTALL.md .
# TODO Build locally from git repo and verify.
_buildGosu() {
	_start
	
	local haveGosuBin
	haveGosuBin=false
	#[[ -e "$scriptBin"/gosu-armel ]] && [[ -e "$scriptBin"/gosu-armel.asc ]] && [[ -e "$scriptBin"/gosu-amd64 ]] && [[ -e "$scriptBin"/gosu-amd64.asc ]] && [[ -e "$scriptBin"/gosu-i386 ]] && [[ -e "$scriptBin"/gosu-i386.asc ]] && haveGosuBin=true #&& return 0
	
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
	
	# verify the signature
	export GNUPGHOME="$shortTmp"/vgosu
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/vgosu
	
	# TODO Add further verification steps.
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
	
	local gpgTestDir
	gpgTestDir="$safeTmp"
	[[ "$haveGosuBin" == "true" ]] && gpgTestDir="$scriptBin"
	
	gpg --batch --verify "$gpgTestDir"/gosu-armel.asc "$gpgTestDir"/gosu-armel || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-amd64.asc "$gpgTestDir"/gosu-amd64 || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-i386.asc "$gpgTestDir"/gosu-i386 || _stop 1
	
	[[ "$haveGosuBin" != "true" ]] && mv "$safeTmp"/gosu-* "$scriptBin"/
	[[ "$haveGosuBin" != "true" ]] && chmod ugoa+rx "$scriptBin"/gosu-*
	
	_stop
}

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
_getUUID() {
	cat /proc/sys/kernel/random/uuid
}
alias getUUID=_getUUID

#####Shortcuts

testGit() {
	checkDep git
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


_gitNew() {
	git init
	git add .
	git commit -a -m "first commit"
}

_gitCheck() {
	find . -name .git -type d -exec bash -c 'echo ----- $(basename $(dirname $(realpath {}))) ; cd $(dirname $(realpath {})) ; git status' \;
}

_gitImport() {
	cd "$scriptFolder"
	
	mkdir -p "$1"
	cd "$1"
	shift
	git clone "$@"
	
	cd "$scriptFolder"
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
	
	
	if [[ "$repoHostname" != "" ]]
	then
		clear
		echo ssh://"$USER"@"$repoHostname""$repoPort""$bareRepoAbsoluteDir"
		sleep 15
	fi
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



_testDistro() {
	_checkDep sha256sum
	_checkDep sha512sum
	_checkDep axel
}

#"$1" == storageLocation (optional)
_fetch_x64_debianLiteISO_sequence() {
	_start
	
	export functionEntryPWD="$PWD"
	
	export storageLocation="$scriptAbsoluteFolder"/_lib/os/
	[[ "$1" != "" ]] && export storageLocation=$(_getAbsoluteLocation "$1")
	
	if ! ls /usr/share/keyrings/debian-role-keys.gpg > /dev/null 2>&1
	then
		echo 'Debian Keyring missing.'
		echo 'apt-get install debian-keyring'
	fi
	
	cd "$safeTmp"
	
	local debAvailableVersion
	#debAvailableVersion="current"	#Does not work, incorrect image name.
	#debAvailableVersion="9.1.0"
	debAvailableVersion="9.2.1"
	
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
	debAvailableVersion="9.2.1"
	
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

_visualPrompt() {
export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]----------\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ %b\ %d,\ %y)\[\033[01;34m\])-\[\033[01;36m\]--- - - - |\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '
} 

_testX11() {
	
	_checkDep xclip
	
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

_dockerImages() {
	_permitDocker docker images "$@"
}

_dockerContainers() {
	_permitDocker docker ps -a "$@"
}

_dockerRunning() {
	_permitDocker docker ps "$@"
}

# WARNING Deletes specified docker IMAGE.
_dockerDeleteImage() {
	_permitDocker docker rmi "$1"
}

# WARNING Deletes all docker containers.
_dockerDeleteContainersAll() {
	_permitDocker docker rm $(_dockerContainers -q)
}

# DANGER Deletes all docker images!
_dockerDeleteImagesAll() {
	_permitDocker docker rmi --force $(_dockerImages -q)
}

# DANGER Deletes all docker assets not clearly in use!
_dockerPrune() {
	_permitDocker docker system prune
}
 

 

_importShortcuts() {
	_visualPrompt
}

_setupUbiquitous() {
	
	mkdir -p "$HOME"/bin/
	
	ln -s "$scriptAbsoluteLocation" "$HOME"/bin/ubiquitous_bash.sh
	
	echo 'export profileScriptLocation='"$scriptAbsoluteLocation" >> "$HOME"/.bashrc
	echo 'export profileScriptFolder='"$scriptAbsoluteFolder" >> "$HOME"/.bashrc
	
	echo '. '"$scriptAbsoluteLocation"' _importShortcuts' >> "$HOME"/.bashrc
	
} 

#####Basic Variable Management

#####Global variables.

export sessionid=$(_uid)
export scriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
export scriptAbsoluteFolder=$(_getScriptAbsoluteFolder)

if ( [[ "$scriptAbsoluteLocation" == "/bin/bash" ]] || [[ "$scriptAbsoluteLocation" == "/usr/bin/bash" ]] )  && [[ "${BASH_SOURCE[0]}" != "${0}" ]] && [[ "$profileScriptLocation" != "" ]] && [[ "$profileScriptFolder" != "" ]]
then
	export scriptAbsoluteLocation="$profileScriptLocation"
	export scriptAbsoluteFolder="$profileScriptFolder"
fi

#Current directory for preservation.
export outerPWD=$(_getAbsoluteLocation "$PWD")

export initPWD="$PWD"
intInitPWD="$PWD"

#Temporary directories.
export safeTmp="$scriptAbsoluteFolder"/w_"$sessionid"
export logTmp="$safeTmp"/log
export shortTmp=/tmp/w_"$sessionid"	#Solely for misbehaved applications called upon.
export scriptBin="$scriptAbsoluteFolder"/_bin
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"	#For virtualized guests.

export scriptLocal="$scriptAbsoluteFolder"/_local

#Reboot Detection Token Storage
# WARNING WIP. Not tested on all platforms. Requires a directory to be tmp/ram fs mounted. Worst case result is to preserve tokens across reboots.
export bootTmp="$scriptLocal"			#Fail-Safe
[[ -d /tmp ]] && export bootTmp=/tmp		#Typical BSD
[[ -d /dev/shm ]] && export bootTmp=/dev/shm	#Typical Linux

#Process control.
[[ "$pidFile" == "" ]] && export pidFile="$safeTmp"/.pid
export uPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"	#Invalid do-not-match default.

[[ "$daemonPidFile" == "" ]] && export daemonPidFile="$scriptLocal"/.bgpid
export daemonPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"	#Invalid do-not-match default.

#export varStore="$scriptAbsoluteFolder"/var

#Monolithic shared files.
export lock_pathlock="$scriptLocal"/_pathlck
export lock_quicktmp="$scriptLocal"/quicktmp	#Used to make locking operations atomic as possible.
export lock_emergency="$scriptLocal"/_emergncy
export lock_open="$scriptLocal"/_open
export lock_opening="$scriptLocal"/_opening
export lock_closed="$scriptLocal"/_closed
export lock_closing="$scriptLocal"/_closing
export lock_instance="$scriptLocal"/_instance
export lock_instancing="$scriptLocal"/_instancing

#Monolithic shared log files.
export importLog="$scriptLocal"/import.log

#Resource directories.
#export guidanceDir="$scriptAbsoluteFolder"/guidance

#Object Dir
export objectDir="$scriptAbsoluteFolder"

#Object Name
export objectName=$(basename "$objectDir")

#Modify PATH to include own directories.
export PATH="$PATH":"$scriptAbsoluteFolder"
[[ -d "$scriptBin" ]] && export PATH="$PATH":"$scriptBin"

export permaLog="$scriptLocal"

export HOST_USER_ID=$(id -u)
export HOST_GROUP_ID=$(id -g)
export virtGuestUser="ubvrtusr"
[[ $(id -u) == 0 ]] && export virtGuestUser="root"

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$scriptAbsoluteFolder"/v_"$sessionid"
export instancedVirtFS="$instancedVirtDir"/fs
export instancedVirtTmp="$instancedVirtDir"/tmp

export virtGuestHome=/home/"$virtGuestUser"
[[ $(id -u) == 0 ]] && export virtGuestHome=/root
export virtGuestHomeRef="$virtGuestHome".ref

export instancedVirtHome="$instancedVirtFS""$virtGuestHome"
export instancedVirtHomeRef="$instancedVirtHome".ref

export sharedHostProjectDirDefault=""
export sharedGuestProjectDirDefault="$virtGuestHome"/project

export sharedHostProjectDir="$sharedHostProjectDirDefault"
export sharedGuestProjectDir="$sharedGuestProjectDirDefault"

export instancedProjectDir="$instancedVirtHome"/project

export hostToGuestDir="$instancedVirtDir"/htg
export hostToGuestFiles="$hostToGuestDir"/files
export hostToGuestISO="$instancedVirtDir"/htg/htg.iso

export chrootDir="$globalVirtFS"
export vboxRaw="$scriptLocal"/vmvdiraw.vmdk

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
}

_reset_vboxLabID() {
	[[ "$VBOX_ID_FILE" == "" ]] && return 1
	
	rm -f "$VBOX_ID_FILE" > /dev/null 2>&1
	
	[[ -e "$VBOX_ID_FILE" ]] && return 1
	
	return 0
}

#"$1" == virtualbox instance directory (optional)
_prepare_vbox() {
	_unset_vbox
	
	export vBox_vdi="$scriptLocal/_vboxvdi"
	
	export vBoxInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export vBoxInstanceDir="$1"
	
	mkdir -p "$vBoxInstanceDir" > /dev/null 2>&1 || return 1
	mkdir -p "$scriptLocal" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtDir" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtFS" > /dev/null 2>&1 || return 1
	mkdir -p "$globalVirtTmp" > /dev/null 2>&1 || return 1
	
	export VBOX_ID_FILE
	VBOX_ID_FILE="$vBoxInstanceDir"/vbox.id
	
	_pathLocked _reset_vboxLabID || return 1
	
	[[ ! -e "$VBOX_ID_FILE" ]] && sleep 0.1 && [[ ! -e "$VBOX_ID_FILE" ]] && echo -e -n "$sessionid" > "$VBOX_ID_FILE" 2> /dev/null
	[[ -e "$VBOX_ID_FILE" ]] && export VBOXID=$(cat "$VBOX_ID_FILE" 2> /dev/null)
	
	
	export VBOX_USER_HOME="$vBoxInstanceDir"/vBoxCfg
	export VBOX_USER_HOME_local="$vBoxInstanceDir"/vBoxHome
	#export VBOX_USER_HOME_short="$HOME"/.vbl"$VBOXID"
	#export VBOX_USER_HOME_short=/tmp/.vbl"$VBOXID"
	export VBOX_USER_HOME_short="$bootTmp"/.vbl"$VBOXID"
	
	export VBOX_IPC_SOCKETID="$VBOXID"
	export VBoxXPCOMIPCD_PIDfile="/tmp/.vbox-""$VBOX_IPC_SOCKETID""-ipc/lock"
	
	
	
	[[ "$VBOXID" == "" ]] && return 1
	[[ ! -e "$VBOX_ID_FILE" ]] && return 1
	
	
	mkdir -p "$VBOX_USER_HOME" > /dev/null 2>&1 || return 1
	mkdir -p "$VBOX_USER_HOME_local" > /dev/null 2>&1 || return 1
	
	
	#Atomically ensure symlink between full and short home directory paths is up to date.
	local oldLinkPath
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && ln -sf "$VBOX_USER_HOME_local" "$VBOX_USER_HOME_short" > /dev/null 2>&1
	oldLinkPath=$(readlink "$VBOX_USER_HOME_short")
	[[ "$oldLinkPath" != "$VBOX_USER_HOME_local" ]] && return 1
	
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
	
	export dockerObjectName=""
	export dockerBaseObjectName=""
	export dockerImageObjectName=""
	export dockerContainerObjectName=""
	export dockerImageObjectNameSane=""
	
	
}

_reset_dockerID() {
	[[ "$dockerubidfile" == "" ]] && return 1
	
	rm -f "$dockerubidfile" > /dev/null 2>&1
	 
	[[ -e "$dockerubidfile" ]] && return 1
	
	return 0
}

_prepare_docker_directives() {
	#Docker directives files should be generated from here documents and a copy of the script iself.
	
	true
}

_prepare_docker() {
	
	export dockerInstanceDir="$scriptLocal"
	[[ "$1" != "" ]] && export dockerInstanceDir="$1"
	
	export docker_image="$scriptLocal/_dockimg"
	
	export dockerubidfile
	dockerubidfile="$scriptLocal"/docker.id
	
	_pathLocked _reset_dockerID || return 1
	
	[[ ! -e "$dockerubidfile" ]] && sleep 0.1 && [[ ! -e "$dockerubidfile" ]] && echo -e -n "$sessionid" > "$dockerubidfile" 2> /dev/null
	[[ -e "$dockerubidfile" ]] && export DOCKERUBID=$(cat "$dockerubidfile" 2> /dev/null)
	
	export dockerImageFilename="$scriptLocal"/docker.dai
	
	##Sub-object Names
	#Overload by setting either "$dockerObjectName", or all of "$dockerBaseObjectName", "$dockerImageObjectName", and "$dockerContainerObjectName" .
	
	#container-image-base
	#[[ "$dockerObjectName" == "" ]] && export dockerObjectName="unimportant-""$DOCKERUBID"_"local/app:app-local/debian:jessie"
	[[ "$dockerObjectName" == "" ]] && export dockerObjectName="unimportant-""$DOCKERUBID"_"hello-scratch"
	
	
	if [[ "$dockerBaseObjectName" == "" ]] || [[ "$dockerImageObjectName" == "" ]] || [[ "$dockerContainerObjectName" == "" ]]
	then
		export dockerBaseObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f3)
		export dockerImageObjectName=$(echo "$dockerObjectName" | cut -s -d\- -f2)
		export dockerContainerObjectName=$(echo "$dockerObjectName" | cut -d\- -f1)
	fi
	
	if ! echo "$dockerBaseObjectName" | grep ':' >/dev/null 2>&1
	then
		dockerBaseObjectName="$dockerBaseObjectName"":latest"
	fi
	
	if ! echo "$dockerImageObjectName" | grep ':' >/dev/null 2>&1
	then
		dockerImageObjectName="$dockerImageObjectName"":latest"
	fi
	
	dockerImageObjectNameSane=$(echo "$imageObjectName" | tr ':/' '__' | tr -dc 'a-zA-Z0-9_')
	
	dockerContainerObjectName="$dockerContainerObjectName""_""$dockerImageObjectNameSane"
	
	##Specialized.
	export dockerBaseObjectExists=false
	[[ "$(docker images -q "$baseObjectName" 2> /dev/null)" != "" ]] && export baseObjectExists=true
	
	export dockerContainerObjectExists=false
	export dockerContainerID=$(docker ps -a -q --filter name='^/'"$containerObjectName"'$')
	[[ "$dockerContainerID" != "" ]] && export dockerContainerObjectExists=true
	
	export dockerImageObjectExists=false
	[[ "$(docker images -q "$imageObjectName" 2> /dev/null)" != "" ]] && export dockerImageObjectExists=true
	
	
	export mkimageDistro=$(echo "$baseObjectName" | cut -d \/ -f 2 | cut -d \: -f 1)
	export mkimageVersion=$(echo "$baseObjectName" | cut -d \/ -f 2 | cut -d \: -f 2)
	
	##Binaries
	export mkimageAbsoluteLocaton=$(_discoverResource docker/contrib/mkimage.sh)
	export mkimageAbsoluteDirectory=$(_getAbsoluteFolder "$mkimageAbsoluteLocaton")
	
	##Directives
	export dockerdirectivefile
	dockerdirectivefile="$safeTmp"/dockerfile
	export dockerentrypoint
	dockerentrypoint="$safeTmp"/entrypoint.sh
	#_prepare_docker_directives
	
}
#_prepare_docker


#####Local Environment Management (Resources)

_extra() {
	true
}


_prepare() {
	
	mkdir -p "$safeTmp"
	
	mkdir -p "$shortTmp"
	
	mkdir -p "$logTmp"
	
	mkdir -p "$scriptLocal"
	
	mkdir -p "$bootTmp"
	
	_extra
}

#####Local Environment Management (Instancing)

_start() {
	
	_prepare
	
	#touch "$varStore"
	#. "$varStore"
	
	echo $$ > "$safeTmp"/.pid
	
}

_saveVar() {
	true
	#declare -p varName > "$varStore"
}

_stop() {
	_preserveLog
	
	rm -f "$pidFile" > /dev/null 2>&1	#Redundant, as this usually resides in "$safeTmp".
	_safeRMR "$safeTmp"
	_safeRMR "$shortTmp"
	
	#Daemon uses a separate instance, and will not be affected by previous actions.
	_tryExec _killDaemon
	
	#Optionally always try to remove any systemd shutdown hook.
	#_tryExec _unhook_systemd_shutdown
	
	if [[ "$1" != "" ]]
	then
		exit "$1"
	else
		exit 0
	fi
}

#Called upon SIGTERM or similar signal.
_stop_emergency() {
	[[ "$noEmergency" == true ]] && _stop "$1"
	
	export EMERGENCYSHUTDOWN=true
	
	_closeChRoot_emergency
	
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

_createLocked() {
	[[ "$uDEBUG" == true ]] && caller 0 >> "$scriptLocal"/lock.log
	[[ "$uDEBUG" == true ]] && echo -e '\t'"$sessionid"'\t'"$1" >> "$scriptLocal"/lock.log
	
	mkdir -p "$bootTmp"
	
	! [[ -e "$bootTmp"/"$sessionid" ]] && echo > "$bootTmp"/"$sessionid"
	
	echo "$sessionid" > "$lock_quicktmp"
	
	mv -n "$lock_quicktmp" "$1" > /dev/null 2>&1
	
	if [[ -e "$lock_quicktmp" ]]
	then
		[[ "$uDEBUG" == true ]] && echo -e '\t'FAIL >> "$scriptLocal"/lock.log
		return 1
	fi
}

_resetLocks() {
	
	_readLocked "$lock_open"
	_readLocked "$lock_opening"
	_readLocked "$lock_closed"
	_readLocked "$lock_closing"
	_readLocked "$lock_instance"
	_readLocked "$lock_instancing"
	
}

#Wrapper. Operates lock file for mounting shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == waitOpen function && shift
#"$@" == wrapped function and parameters
_open() {
	_readLocked "$lock_open" && return 0
	
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
		rm -f "$lock_opening"
		return 0
	fi
	
	return 1
}

#Wrapper. Operates lock file for shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == <"--force"> && shift
#"$1" == waitClose function && shift
#"$@" == wrapped function and parameters
_close() {
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
		rm -f "$lock_closing"
		rm -f "$scriptLocal"/WARNING
		return 0
	fi
	
	return 1
	
	
}

#####Idle

_idle() {
	_start
	
	_checkDep getIdle
	
	_killDaemon
	
	while true
	do
		sleep 5
		
		idleTime=$("$scriptBin"/getIdle)
		
		if [[ "$idleTime" -lt "3300000" ]] && _daemonStatus
		then
			true
			_killDaemon	#Comment out if unnecessary.
		fi
		
		
		if [[ "$idleTime" -gt "3600000" ]] && ! _daemonStatus
		then
			_execDaemon
		fi
		
		
		
	done
	
	_stop
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
	
	idleSourceCode=$(find "$scriptAbsoluteFolder" -type f -name "getIdle.c" | head -n 1)
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/getIdle "$idleSourceCode" -lXss -lX11
	
}

#####Installation

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
			echo "FAIL"
			_stop 1
		fi
		
		if [[ "$dateDelta" -lt "5" ]]
		then
			echo "PASS"
			return 0
		fi
		
		let iterations="$iterations + 1"
	done
	echo "FAIL"
	_stop 1
}

_test() {
	_start
	
	echo -e -n '\E[1;32;46m Dependency checking...	\E[0m'
	
	# Check dependencies
	_checkDep wget
	_checkDep grep
	_checkDep fgrep
	_checkDep sed
	_checkDep awk
	_checkDep cut
	_checkDep head
	_checkDep tail
	
	
	_checkDep realpath
	_checkDep readlink
	_checkDep dirname
	
	_checkDep sleep
	_checkDep wait
	_checkDep kill
	_checkDep jobs
	_checkDep ps
	_checkDep exit
	
	_checkDep env
	_checkDep bash
	_checkDep echo
	_checkDep cat
	_checkDep type
	_checkDep mkdir
	_checkDep trap
	_checkDep return
	_checkDep set
	
	_checkDep dd
	
	_checkDep rm
	
	_checkDep find
	_checkDep ln
	_checkDep ls
	
	_checkDep id
	
	_checkDep true
	_checkDep false
	
	_tryExec "_testMountChecks"
	_tryExec "_testBindMountManager"
	_tryExec "_testDistro"
	
	_tryExec "_testChRoot"
	_tryExec "_testQEMU"
	_tryExec "_testQEMU_x64-x64"
	_tryExec "_testQEMU_x64-raspi"
	_tryExec "_testQEMU_raspi-raspi"
	_tryExec "_testVBox"
	
	_tryExec "_test_dosbox"
	
	_tryExec "_testWINE"
	
	_tryExec "_test_docker"
	
	_tryExec "_testVirtBootdisc"
	
	_tryExec "_testExtra"
	
	_tryExec "_testGit"
	_tryExec "_testX11"
	
	[[ -e /dev/urandom ]] || echo /dev/urandom missing _stop
	
	echo "PASS"
	
	echo -n -e '\E[1;32;46m Timing...		\E[0m'
	_timetest
	
	_stop
	
}

_testBuilt() {
	_start
	
	echo -e -n '\E[1;32;46m Binary checking...	\E[0m'
	
	_tryExec "_testBuiltIdle"
	#_tryExec "_testBuiltGosu"
	
	_tryExec "_testBuiltChRoot"
	_tryExec "_testBuiltQEMU"
	
	_tryExec "_testBuiltExtra"
	
	echo "PASS"
	
	_stop
}

#Creates symlink in ~/bin, to the executable at "$1", named according to its residing directory and file name.
_setupCommand() {
	local clientScriptLocation
	clientScriptLocation=$(_getAbsoluteLocation "$1")
	
	local clientScriptFolder
	clientScriptFolder=$(_getAbsoluteFolder "$1")
	
	local commandName
	commandName=$(basename "$1")
	
	local clientName
	clientName=$(basename "$clientScriptFolder")
	
	ln -s -r "$clientScriptLocation" ~/bin/"$commandName""-""$clientName"
	
	
}

_setupCommands() {
	#find . -name '_command' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
	true
}

_setup() {
	_start
	
	"$scriptAbsoluteLocation" _test || _stop 1
	
	"$scriptAbsoluteLocation" _build "$@" || _stop 1
	
	"$scriptAbsoluteLocation" _testBuilt || _stop 1
	
	_setupCommands
	
	_stop
}

#####Program

_buildSequence() {
	_start
	
	echo -e '\E[1;32;46m Binary compiling...	\E[0m'
	
	_tryExec _buildIdle
	_tryExec _buildGosu
	
	_tryExec _buildChRoot
	_tryExec _buildQEMU
	
	_tryExec _buildExtra
	
	echo "     ...DONE"
	
	_stop
}

_build() {
	"$scriptAbsoluteLocation" _buildSequence
}

#Typically launches an application - ie. through virtualized container.
_launch() {
	false
}

#Typically gathers command/variable scripts from other (ie. yaml) file types (ie. AppImage recipes).
_collect() {
	false
}

#Typical program entry point, absent any instancing support.
_enter() {
	_launch
}

#Typical program entry point.
_main() {
	_start
	
	_collect
	
	_enter
	
	_stop
}

#####Overrides

#Traps, if script is not imported into existing shell, or bypass requested.
if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
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


#Launch internal functions as commands.
_true() {
	true
}
_false() {
	false
}
_echo() {
	echo "$@"
}
#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
#if [[ "$1" == '_'* ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
if [[ "$1" == '_'* ]]
then
	"$@"
	internalFunctionExitStatus="$?"
	#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
	if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
	then
		#export noEmergency=true
		exit "$internalFunctionExitStatus"
	fi
	#_stop "$?"
fi

#Stop if script is imported into an existing shell and bypass not requested.
if [[ "${BASH_SOURCE[0]}" != "${0}" ]] && [[ "$1" != "--bypass" ]]
then
	return
fi

if ! [[ "$1" != "--bypass" ]]
then
	shift
fi

#Do not continue script execution through program code if critical global variables are not sane.
[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
_failExec || exit 1

#####Entry

#"$scriptAbsoluteLocation" _setup


_main "$@"


