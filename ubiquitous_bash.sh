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
	local absoluteLocation
	if [[ (-e $PWD\/$0) && ($0 != "") ]] && [[ "$1" != "/"* ]]
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
	dirname "$(_getScriptAbsoluteLocation)"
}
alias getScriptAbsoluteFolder=_getScriptAbsoluteFolder

#Retrieves absolute path of parameter, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for finding absolute paths, when it is desirable not to interfere with symlink specified folder structure.
_getAbsoluteLocation() {
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
	local absoluteLocation=$(_getAbsoluteLocation "$1")
	dirname "$absoluteLocation"
}
alias getAbsoluteLocation=_getAbsoluteLocation

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

#Portable sanity checked "rm -r" command.
# WARNING Not foolproof. Use to guard against systematic errors, not carelessness.
#"$1" == directory to remove
_safeRMR() {
	
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
	[[ ! -e "$1" ]] && return 1
	
	mkdir -p "$2"
	[[ ! -e "$2" ]] && return 1
	
	sudo -n mount --bind "$1" "$2"
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
#"$1" == test directory
_checkForMounts() {
	_start
	
	#If test directory itself is a directory, further testing is not necessary.
	mountpoint "$1" > /dev/null 2>&1 && _stop 0
	
	local mountCheckFile="$safeTmp"/mc-$(_uid)
	
	echo -n false > "$mountCheckFile"
	
	#Sanity check, file exists.
	! [[ -e "$mountCheckFile" ]] && _stop 0
	
	# TODO: Possible stability/portability improvements.
	#https://unix.stackexchange.com/questions/248472/finding-mount-points-with-the-find-command
	
	find "$1" -type d -exec mountpoint {} 2>/dev/null \; | grep 'is a mountpoint' >/dev/null 2>&1 && echo -n true > "$mountCheckFile"
	
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
	if [[ -e "$pidFile" ]]
	then
		export daemonPID=$(cat "$pidFile")
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
	
	rm "$pidFile" >/dev/null 2>&1
}

#Executes self in background (ie. as daemon).
_execDaemon() {
	"$scriptAbsoluteLocation" >/dev/null 2>&1 &
	echo "$!" > "$pidFile"
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
	
	cp "$logTmp"/* "$permaLog"/
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

#Checks if file/directory exists on remote system. Overload this function with implementation specific to the container/virtualization solution in use (ie. docker run).
_checkBaseDirRemote() {
	false
}

#Reports the highest-level directory containing all files in given parameter set.
#"$@" == parameters to search
_searchBaseDir() {
	local baseDir
	local newDir
	
	baseDir=""
	
	local processedArgs
	local currentArg
	local currentResult
	
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
#"$2" == sharedProjectDir
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
	
	if [[ ! -e "$1" ]]
	then
		echo "$1"
		return
	fi
	
	[[ "$3" != "" ]] && echo -n "$3"/
	realpath -L -s --relative-to="$2" "$1"
	
}

#Lists all chrooted processes. First parameter is chroot directory. Script might need to run as root.
#Techniques originally released by other authors at http://forums.grsecurity.net/viewtopic.php?f=3&t=1632 .
#"$1" == ChRoot Dir
_listprocChRoot() {
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	PROCS=""
	for p in `ps -o pid -A`; do
		if [ "`readlink /proc/$p/root`" = "$absolute1" ]; then
			PROCS="$PROCS $p"
		fi
	done
	echo "$PROCS"
}

#End user and diagnostic function, shuts down all processes in a chroot.
_stopChRoot() {
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	echo "TERMinating all chrooted processes."
	sleep 5
	kill -TERM $(_listprocChRoot "$absolute1") >/dev/null 2>&1
	sleep 15
	
	echo "KILLing all chrooted processes."
	kill -KILL $(_listprocChRoot "$absolute1") >/dev/null 2>&1
	sleep 1
	
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
	_bindMountManager "/dev" "$absolute1"/proc
	_bindMountManager "/dev" "$absolute1"/sys
	
	_bindMountManager "/dev" "$absolute1"/dev/pts
	
	_bindMountManager "/dev" "$absolute1"/tmp
	
	#Provide an shm filesystem at /dev/shm.
	sudo -n mount -t tmpfs -o size=4G tmpfs "$absolute1"/dev/shm
	
}

#"$1" == ChRoot Dir
_umountChRoot() {
	_mustGetSudo
	
	[[ ! -e "$1" ]] && return 1
	
	local absolute1
	absolute1=$(_getAbsoluteLocation "$1")
	
	sudo -n umount "$absolute1"/proc
	sudo -n umount "$absolute1"/sys
	sudo -n umount "$absolute1"/dev/pts
	sudo -n umount "$absolute1"/tmp
	sudo -n umount "$absolute1"/dev/shm
	sudo -n umount "$absolute1"/dev
	
	sudo -n umount "$absolute1" >/dev/null 2>&1
	
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

_closeChRoot() {
	[[ -e "$scriptLocal"/_closing ]] && return 1
	
	_start
	
	_mustGetSudo
	
	echo > "$scriptLocal"/_closing
	
	_stopChRoot "$chrootDir"
	_umountChRoot "$chrootDir"
	mountpoint "$chrootDir" > /dev/null 2>&1 && sudo -n umount "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	rm "$scriptLocal"/_closing
	
	rm "$scriptLocal"/_open
	
	rm "$scriptLocal"/WARNING
	
	_stop
}

_imageLoop_raspbian() {
	_mustGetSudo
	
	_start
	
	mkdir -p "$chrootDir"
	
	"$scriptAbsoluteLocation" _checkForMounts "$chrootDir" && _stop 1
	
	if sudo -n losetup -f -P --show "$scriptLocal"/vm-raspbian.img > "$safeTmp"/imagedev 2> /dev/null
	then
		cp "$safeTmp"/imagedev "$scriptLocal"/imagedev
		
		local imagedev
		imagedev=$(cat "$safeTmp"/imagedev)
		
		local imagepart
		imagepart="$imagedev"p2
		
		local loopdevfs
		loopdevfs=$(eval $(sudo -n blkid "$imagepart" | awk ' { print $3 } '); echo $TYPE)
		
		if [[ "$loopdevfs" == "ext4" ]]
		then
			
			sudo -n mount "$imagepart" "$chrootDir" || _stop 1
			
			echo > "$scriptLocal"/_open
			
			mountpoint "$chrootDir" > /dev/null 2>&1 || _stop 1
			
			_mountChRoot "$chrootDir"
			
			_readyChRoot "$chrootDir" || _stop 1
			
			
		fi
		
	fi
	
	_stop 0
}

_imageLoop_Native() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	
}

_imageLoop_platforms() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	if [[ -e "$scriptLocal"/vm-raspbian.img ]]
	then
		_imageLoop_raspbian
		return "$?"
	fi
	
	if [[ -e "$scriptLocal"/vm.img ]]
	then
		_imageLoop_Native
		return "$?"
	fi
}

_imageChRoot() {
	_mustGetSudo
	mkdir -p "$chrootDir"
	
	[[ -e "$scriptLocal"/_open ]] && return 0
	
	[[ -e "$scriptLocal"/_closing ]] && return 1
	
	if [[ -e "$scriptLocal"/_opening ]] && "$scriptAbsoluteLocation" _checkForMounts "$chrootDir"
	then
		_waitChRoot_opening || return 1
		_readyChRoot || return 1
		return 0
	fi
	
	echo > "$scriptLocal"/_opening
	
	
	if ! _imageLoop_platforms
	then
		"$scriptAbsoluteLocation" _closeChRoot
		
		rm "$scriptLocal"/_opening
		
		return 1
	fi
	
	
	rm "$scriptLocal"/_opening
	
	echo > "$scriptLocal"/_open
}


_openChRoot() {
	_start
	
	_mustGetSudo
	
	echo "OPEN CHROOT" > "$scriptLocal"/WARNING
	
	mkdir -p "$chrootDir"
	
	_imageChRoot || _stop 1
	
	_stop
}



_chrootRasPi() {
	
	
	#effectively disable /etc/ld.so.preload
	
	
	true
	#chroot
	
	#enable default /etc/ld.so.preload
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
}

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
_getUUID() {
	cat /proc/sys/kernel/random/uuid
}
alias getUUID=_getUUID

#####Shortcuts

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
	
	[[ -e "$storageLocation"/debian-9.1.0-amd64-netinst.iso ]] && cp "$storageLocation"/debian-9.1.0-amd64-netinst.iso ./debian-9.1.0-amd64-netinst.iso > /dev/null 2>&1
	[[ -e ./debian-9.1.0-amd64-netinst.iso ]] || _fetch 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/debian-9.1.0-amd64-netinst.iso'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS'
	
	wget 'https://cdimage.debian.org/debian-cd/9.1.0/amd64/iso-cd/SHA512SUMS.sign'
	
	if ! cat SHA512SUMS | grep debian-9.1.0-amd64-netinst.iso | sha512sum -c - > /dev/null 2>&1
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
	mv "$safeTmp"/debian-9.1.0-amd64-netinst.iso "$storageLocation"
	
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
	
	qemu-system-x86_64 -machine accel=kvm -drive format=raw,file="$scriptLocal"/vm.img -cdrom "$scriptAbsoluteFolder"/_lib/os/debian-9.1.0-amd64-netinst.iso -boot d -m 1512
	
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

[[ ! -e "$scriptAbsoluteLocation" ]] && exit 1
[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1

#Current directory for preservation.
export outerPWD=$(_getAbsoluteLocation "$PWD")

export initPWD="$PWD"
intInitPWD="$PWD"

#Temporary directories.
export safeTmp="$scriptAbsoluteFolder"/w_"$sessionid"
export logTmp="$safeTmp"/log
export shortTmp=/tmp/w_"$sessionid"	#Solely for misbehaved applications called upon.
export scriptBin="$scriptAbsoluteFolder"/_bin

export scriptLocal="$scriptAbsoluteFolder"/_local

export chrootDir="$scriptLocal"/chroot

#export varStore="$scriptAbsoluteFolder"/var

#Process control.
[[ "$pidFile" == "" ]] && export pidFile="$safeTmp"/.bgpid
export daemonPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"	#Invalid do-not-match default.

#Monolithic shared files.

#Resource directories.
#export guidanceDir="$scriptAbsoluteFolder"/guidance

#Object Dir
export objectDir="$scriptAbsoluteFolder"

#Object Name
export objectName=$(basename "$objectDir")

#Modify PATH to include own directories.
export PATH="$PATH":"$scriptAbsoluteFolder"
[[ -d "$scriptBin" ]] && export PATH="$PATH":"$scriptBin"

#####Local Environment Management (Resources)

_extra() {
	true
}


_prepare() {
	
	mkdir -p "$safeTmp"
	
	mkdir -p "$shortTmp"
	
	mkdir -p "$logTmp"
	
	mkdir -p "$scriptLocal"
	
	_extra
}

#####Local Environment Management (Instancing)

_start() {
	
	_prepare
	
	#touch "$varStore"
	#. "$varStore"
	
	
}

_saveVar() {
	true
	#declare -p varName > "$varStore"
}

_stop() {
	
	_safeRMR "$safeTmp"
	_safeRMR "$shortTmp"
	
	_tryExec _killDaemon
	
	if [[ "$1" != "" ]]
	then
		exit "$1"
	else
		exit 0
	fi
}

_preserveLog() {
	cp "$logTmp"/* ./  >/dev/null 2>&1
}

#Wrapper. If lock file is present, waits for unlocking operation to complete successfully, then reports status.
#"$1" == checkFile
#"$@" == wait command and parameters
_waitFileCommands() {
	if [[ -e "$1" ]]
	then
		local waitFileCommandStatus
		
		"$@"
		
		waitFileCommandStatus="$?"
		
		if [[ "$waitFileCommandStatus" != "0" ]]
		then
			return "$waitFileCommandStatus"
		fi
		
		[[ -e "$1" ]] && return 1
		
	fi
	
	return 0
}

#Wrapper. Operates lock file for mounting shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == waitOpen function && shift
#"$@" == wrapped function and parameters
_open() {
	[[ -e "$scriptLocal"/_open ]] && return 0
	
	[[ -e "$scriptLocal"/_closing ]] && return 1
	
	if [[ -e "$scriptLocal"/_opening ]]
	then
		if _waitFileCommands "$scriptLocal"/_opening "$1"
		then
			[[ -e "$scriptLocal"/_open ]] || return 1
			return 0
		else
			return 1
		fi
	fi
	echo > "$scriptLocal"/_opening
	shift
	
	echo "LOCKED" > "$scriptLocal"/WARNING
	
	"$@"
	
	
	if [[ "$?" == "0" ]]
	then
		echo > "$scriptLocal"/_open
		rm "$scriptLocal"/_opening
		return 0
	fi
	
	return 1
}

#Wrapper. Operates lock file for shared resources (eg. persistent virtual machine image). Avoid if possible.
#"$1" == <"--force"> && shift
#"$1" == waitClose function && shift
#"$@" == wrapped function and parameters
_close() {
	if [[ "$1" == "--force" ]]
	then
		shift
	elif ! [[ -e "$scriptLocal"/_open ]]
	then
		return 0
	fi
	
	if [[ -e "$scriptLocal"/_closing ]]
	then
		if _waitFileCommands "$scriptLocal"/_closing "$1"
		then
			return 0
		else
			return 1
		fi
	fi
	echo > "$scriptLocal"/_closing
	shift
	
	"$@"
	
	if [[ "$?" == "0" ]]
	then
		rm "$scriptLocal"/_open
		rm "$scriptLocal"/_closing
		rm "$scriptLocal"/WARNING
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
	
	_tryExec "_testMountChecks"
	_tryExec "_testBindMountManager"
	_tryExec "_testDistro"
	
	_tryExec "_testChRoot"
	_tryExec "_testQEMU"
	_tryExec "_testQEMU_x64-x64"
	_tryExec "_testQEMU_x64-raspi"
	_tryExec "_testQEMU_raspi-raspi"
	
	_tryExec "_testExtra"
	
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

_build() {
	_start
	
	echo -e '\E[1;32;46m Binary compiling...	\E[0m'
	
	_tryExec _buildIdle
	_tryExec _buildChRoot
	_tryExec _buildQEMU
	
	_tryExec _buildExtra
	
	echo "     ...DONE"
	
	_stop
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
	trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP INT QUIT PIPE TERM		# reset
	trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP INT QUIT PIPE TERM		# ignore
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
#if [[ "$1" != "" ]] && [[ "$1" != "-"* ]] && [[ ! -e "$1" ]]
if [[ "$1" == '_'* ]]
then
	"$@"
	#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
	if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
	then
		exit "$?"
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

#####Entry

#"$scriptAbsoluteLocation" _setup


_main "$@"


