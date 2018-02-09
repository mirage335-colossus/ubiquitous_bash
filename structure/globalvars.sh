#####Global variables.

#Fixed unique identifier for ubiquitious bash created global resources, such as bootdisc images to be automaticaly mounted by guests. Should NOT be changed.
export ubiquitiousBashID="uk4uPhB663kVcygT0q"

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
export scriptLib="$scriptAbsoluteFolder"/_lib
#For virtualized guests (exclusively intended to support _setupUbiquitous and _drop* hooks).
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"
[[ ! -e "$scriptLib" ]] && export scriptLib="$scriptAbsoluteFolder"


export scriptLocal="$scriptAbsoluteFolder"/_local

#For system installations (exclusively intended to support _setupUbiquitous and _drop* hooks).
[[ "$scriptAbsoluteLocation" == "/usr/bin"* ]] && export scriptBin="/usr/share/ubcore/bin"
[[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]] && export scriptBin="/usr/local/share/ubcore/bin"
if [[ "$scriptAbsoluteLocation" == "/usr/bin"* ]] || [[ "$scriptAbsoluteLocation" == "/usr/local/bin"* ]]
then
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
export safeTmpSSH='~/.s_'"$sessionid"

#Process control.
export pidFile="$safeTmp"/.pid
export uPID="cwrxuk6wqzbzV6p8kPS8J4APYGX"	#Invalid do-not-match default.

export daemonPidFile="$scriptLocal"/.bgpid

#export varStore="$scriptAbsoluteFolder"/var

export vncPIDfile="$safeTmp"/.vncpid
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

#Monolithic shared log files.
export importLog="$scriptLocal"/import.log

#Resource directories.
#export guidanceDir="$scriptAbsoluteFolder"/guidance

#Object Dir
export objectDir="$scriptAbsoluteFolder"

#Object Name
export objectName=$(basename "$objectDir")

#Modify PATH to include own directories.
_permissions_directory_checkForPath "$scriptAbsoluteFolder" && export PATH="$PATH":"$scriptAbsoluteFolder"
[[ "$scriptBin" != "$scriptAbsoluteFolder" ]] && [[ -d "$scriptBin" ]] && _permissions_directory_checkForPath "$scriptBin" && export PATH="$PATH":"$scriptBin"

export permaLog="$scriptLocal"

export HOST_USER_ID=$(id -u)
export HOST_GROUP_ID=$(id -g)
export virtGuestUserDrop="ubvrtusr"
export virtGuestUser="$virtGuestUserDrop"
[[ $(id -u) == 0 ]] && export virtGuestUser="root"

export globalArcDir="$scriptLocal"/a
export globalArcFS="$globalArcDir"/fs
export globalArcTmp="$globalArcDir"/tmp

export globalBuildDir="$scriptLocal"/b
export globalBuildFS="$globalBuildDir"/fs
export globalBuildTmp="$globalBuildDir"/tmp

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$scriptAbsoluteFolder"/v_"$sessionid"
export instancedVirtFS="$instancedVirtDir"/fs
export instancedVirtTmp="$instancedVirtDir"/tmp

export virtGuestHomeDrop=/home/"$virtGuestUserDrop"
export virtGuestHome="$virtGuestHomeDrop"
[[ $(id -u) == 0 ]] && export virtGuestHome=/root
###export virtGuestHomeRef="$virtGuestHome".ref

export instancedVirtHome="$instancedVirtFS""$virtGuestHome"
###export instancedVirtHomeRef="$instancedVirtHome".ref

export sharedHostProjectDirDefault=""
export sharedGuestProjectDirDefault="$virtGuestHome"/project

export sharedHostProjectDir="$sharedHostProjectDirDefault"
export sharedGuestProjectDir="$sharedGuestProjectDirDefault"

export instancedProjectDir="$instancedVirtHome"/project
export instancedDownloadsDir="$instancedVirtHome"/Downloads

export hostToGuestDir="$instancedVirtDir"/htg
export hostToGuestFiles="$hostToGuestDir"/files
export hostToGuestISO="$instancedVirtDir"/htg/htg.iso

export chrootDir="$globalVirtFS"
export vboxRaw="$scriptLocal"/vmvdiraw.vmdk

export globalFakeHome="$scriptLocal"/h
export instancedFakeHome="$scriptAbsoluteFolder"/h_"$sessionid"

#Machine information.
export hostMemoryTotal=$(cat /proc/meminfo | grep MemTotal | tr -cd '[[:digit:]]')
export hostMemoryAvailable=$(cat /proc/meminfo | grep MemAvailable | tr -cd '[[:digit:]]')
export hostMemoryQuantity="$hostMemoryTotal"


#Machine allocation defaults.
export vmMemoryAllocationDefault=96
[[ "$hostMemoryQuantity" -gt "500000" ]] && export vmMemoryAllocationDefault=256
[[ "$hostMemoryQuantity" -gt "800000" ]] && export vmMemoryAllocationDefault=512
[[ "$hostMemoryQuantity" -gt "1500000" ]] && export vmMemoryAllocationDefault=896

[[ "$hostMemoryQuantity" -gt "3000000" ]] && export vmMemoryAllocationDefault=896
[[ "$hostMemoryQuantity" -gt "6000000" ]] && export vmMemoryAllocationDefault=1024

[[ "$hostMemoryQuantity" -gt "8000000" ]] && export vmMemoryAllocationDefault=1256
[[ "$hostMemoryQuantity" -gt "12000000" ]] && export vmMemoryAllocationDefault=1512
[[ "$hostMemoryQuantity" -gt "16000000" ]] && export vmMemoryAllocationDefault=1512

