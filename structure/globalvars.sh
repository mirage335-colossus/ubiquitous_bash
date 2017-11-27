#####Global variables.

export sessionid=$(_uid)
export lowsessionid=$(echo -n "$sessionid" | tr A-Z a-z )
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
#For virtualized guests (exclusively intended to support _setupUbiquitous hook).
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"

export scriptLocal="$scriptAbsoluteFolder"/_local

#For system installations (exclusively intended to support _setupUbiquitous hook).
[[ "$scriptAbsoluteLocation" == "/usr/bin"* ]] && export scriptBin="/usr/share/ubcore/bin"
[[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]] && export scriptBin="/usr/local/share/ubcore/bin"
if [[ "$scriptAbsoluteLocation" == "/usr/bin"* ]] || [[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]]
then
	if [[ -d "$HOME" ]]
	then
		export scriptLocal="$HOME"/".ubcore"/_sys
	fi
fi

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
export lock_pathlock="$scriptLocal"/l_path
export lock_quicktmp="$scriptLocal"/l_qtmp	#Used to make locking operations atomic as possible.
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
