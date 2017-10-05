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

export virtGuestUser="ubvrtusr"

export sharedGuestProjectDir="/home/"$virtGuestUser"/project"
[[ $(id -u) == 0 ]] && export sharedGuestProjectDir="/root/project"

export instancedVirtDir="$scriptAbsoluteFolder"/v_"$sessionid"

export instancedVirtHome="$instancedVirtDir"/home/"$virtGuestUser"
[[ $(id -u) == 0 ]] && export instancedVirtHome="$instancedVirtDir"/root

export chrootDir="$scriptLocal"/chroot
export globalChRootDir="$chrootDir"

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
