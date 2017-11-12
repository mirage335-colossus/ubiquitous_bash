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
