#!/usr/bin/env bash

if [[ "$ub_setScriptChecksum" != "" ]]
then
	export ub_setScriptChecksum=
fi

_ub_cksum_special_derivativeScripts_header() {
	local currentFile_cksum
	if [[ "$1" == "" ]]
	then
		currentFile_cksum="$0"
	else
		currentFile_cksum="$1"
	fi
	
	head -n 30 "$currentFile_cksum" | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9'
}
_ub_cksum_special_derivativeScripts_contents() {
	local currentFile_cksum
	if [[ "$1" == "" ]]
	then
		currentFile_cksum="$0"
	else
		currentFile_cksum="$1"
	fi
	
	tail -n +45 "$currentFile_cksum" | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9'
}
##### CHECKSUM BOUNDARY - 30 lines

#export ub_setScriptChecksum_disable='true'
( [[ -e "$0".nck ]] || [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]] || [[ "$1" == '--compressed' ]] || [[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]] ) && export ub_setScriptChecksum_disable='true'
export ub_setScriptChecksum_header='1891409836'
export ub_setScriptChecksum_contents='1743676729'

# CAUTION: Symlinks may cause problems. Disable this test for such cases if necessary.
# WARNING: Performance may be crucial here.
#[[ -e "$0" ]] && ! [[ -h "$0" ]] && [[ "$ub_setScriptChecksum" != "" ]]
if [[ -e "$0" ]] && [[ "$ub_setScriptChecksum_header" != "" ]] && [[ "$ub_setScriptChecksum_contents" != "" ]] && [[ "$ub_setScriptChecksum_disable" != 'true' ]] #&& ! ( [[ -e "$0".nck ]] || [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]] || [[ "$1" == '--compressed' ]] || [[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]] )
then
	[[ $(_ub_cksum_special_derivativeScripts_header) != "$ub_setScriptChecksum_header" ]] && exit 1
	[[ $(_ub_cksum_special_derivativeScripts_contents) != "$ub_setScriptChecksum_contents" ]] && exit 1
fi
##### CHECKSUM BOUNDARY - 45 lines

_ub_cksum_special_derivativeScripts_write() {
	local current_ub_setScriptChecksum_header
	local current_ub_setScriptChecksum_contents

	current_ub_setScriptChecksum_header=$(_ub_cksum_special_derivativeScripts_header "$1")
	current_ub_setScriptChecksum_contents=$(_ub_cksum_special_derivativeScripts_contents "$1")

	sed -i 's/'#'#'###uk4uPhB663kVcygT0q-UbiquitousBash-ScriptSelfModify-SetScriptChecksumHeader-UbiquitousBash-uk4uPhB663kVcygT0q#####'/'"$current_ub_setScriptChecksum_header"'/' "$1"
	sed -i 's/'#'#'###uk4uPhB663kVcygT0q-UbiquitousBash-ScriptSelfModify-SetScriptChecksumContents-UbiquitousBash-uk4uPhB663kVcygT0q#####'/'"$current_ub_setScriptChecksum_contents"'/' "$1"
}


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
#if [[ "$ub_import" != "" ]]
#then
	#[[ "$ub_import" != "" ]] && export ub_import="" && unset ub_import
	
	#[[ "$importScriptLocation" != "" ]] && export importScriptLocation= && unset importScriptLocation
	#[[ "$importScriptFolder" != "" ]] && export importScriptFolder= && unset importScriptFolder
#fi
#[[ "$ub_import" != "" ]] && export ub_import="" && unset ub_import
#[[ "$ub_import_param" != "" ]] && export ub_import_param="" && unset ub_import_param
#[[ "$ub_import_script" != "" ]] && export ub_import_script="" && unset ub_import_script
#[[ "$ub_loginshell" != "" ]] && export ub_loginshell="" && unset ub_loginshell
ub_import=
ub_import_param=
ub_import_script=
ub_loginshell=


# ATTENTION: Apparently (Portable) Cygwin Bash interprets correctly.
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && ub_import="true"

( [[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]] || [[ "$1" == '--compressed' ]] ) && ub_import_param="$1" && shift
( [[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]] ) && ub_loginshell="true"	#Importing ubiquitous bash into a login shell with "~/.bashrc" is the only known cause for "_getScriptAbsoluteLocation" to return a result such as "/bin/bash".
[[ "$ub_import" == "true" ]] && ! [[ "$ub_loginshell" == "true" ]] && ub_import_script="true"

_messagePlain_probe_expr '$0= '"$0"'\n ''$1= '"$1"'\n ''ub_import= '"$ub_import"'\n ''ub_import_param= '"$ub_import_param"'\n ''ub_import_script= '"$ub_import_script"'\n ''ub_loginshell= '"$ub_loginshell" | _user_log-ub

# DANGER Prohibited import from login shell. Use _setupUbiquitous, call from another script, or manually set importScriptLocation.
# WARNING Import from shell can be detected. Import from script cannot. Asserting that script has been imported is possible. Asserting that script has not been imported is not possible. Users may be protected from interactive mistakes. Script developers are NOT protected.
if [[ "$ub_import_param" == "--profile" ]]
then
	if ( [[ "$profileScriptLocation" == "" ]] ||  [[ "$profileScriptFolder" == "" ]] ) && _messagePlain_bad 'import: profile: missing: profileScriptLocation, missing: profileScriptFolder' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif ( [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]] )
then
	if ( [[ "$scriptAbsoluteLocation" == "" ]] || [[ "$scriptAbsoluteFolder" == "" ]] || [[ "$sessionid" == "" ]] ) && _messagePlain_bad 'import: parent: missing: scriptAbsoluteLocation, missing: scriptAbsoluteFolder, missing: sessionid' | _user_log-ub
	then
		return 1 >/dev/null 2>&1
		exit 1
	fi
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || [[ "$ub_import_param" == "--compressed" ]] || ( [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] )
then
	if ( [[ "$importScriptLocation" == "" ]] || [[ "$importScriptFolder" == "" ]] ) && _messagePlain_bad 'import: call: missing: importScriptLocation, missing: importScriptFolder' | _user_log-ub
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
# DANGER: Recursion hazard. Do not create override alias/function without checking that alternate exists.


# Workaround for very minor OS misconfiguration. Setting this variable at all may be undesirable however. Consider enabling and generating all locales with 'sudo dpkg-reconfigure locales' or similar .
#[[ "$LC_ALL" == '' ]] && export LC_ALL="en_US.UTF-8"



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




# Only production use is Inter-Process Communication (IPC) loops which may be theoretically impossible to make fully deterministic under Operating Systems which do not have hard-real-time kernels and/or may serve an unlimited number of processes.
_here_header_bash_or_dash() {
	if [[ -e /bin/dash ]]
		then
		
cat << 'CZXWXcRMTo8EmM8i4d'
#!/bin/dash

CZXWXcRMTo8EmM8i4d
	
	else
	
cat << 'CZXWXcRMTo8EmM8i4d'
#!/usr/bin/env bash

CZXWXcRMTo8EmM8i4d

	fi
}



# Delay to attempt to avoid InterProcess-Communication (IPC) problems caused by typical UNIX/MSW Operating System kernel latency and/or large numbers of processes/threads.
# Widely deployed Linux compatible hardware and software is able to run with various 'preemption' 'configured'/'patched' kernels. Detecting such kernels may allow reduction of this arbitrary delay.
# CAUTION: Merely attempts to avoid a problem which may be inherently unavoidably unpredictable.
_sleep_spinlock() {
	# CAUTION: Spinlocks on the order of 8s are commonly observed with 'desktop' operating systems. Do NOT reduce this delay without thorough consideration! Theoretically, it may not be possible to determine whether the parent of a process is still running in less than spinlock time, only the existence of the parent process guarantees against PID rollover, and multiple spinlocks may occur between the necessary IPC events to determine any of the above.
	# ATTENTION: Consider setting this to the worst-case acceptable latency for a system still considered 'responsive' (ie. a number of seconds greater than that which would cause a user or other 'watchdog' to forcibly reboot the system).
	local currentWaitSpinlock
	let currentWaitSpinlock="$RANDOM"%4
	#let currentWaitSpinlock="$currentWaitSpinlock"+12
	let currentWaitSpinlock="$currentWaitSpinlock"+10
	sleep "$currentWaitSpinlock"
}


_____special_live_hibernate_rmmod_remainder-vbox_procedure() {
	local currentLine
	sudo -n lsmod | grep '^vbox.*$' | cut -f1 -d\  | while read currentLine
	do
		#echo "$currentLine"
		sudo -n rmmod "$currentLine"
	done
}

_____special_live_hibernate_rmmod_remainder-vbox() {
	local currentIterations
	currentIterations=0
	while [[ "$currentIterations" -lt 2 ]]
	do
		let currentIterations="$currentIterations + 1"
		_____special_live_hibernate_rmmod_remainder-vbox_procedure "$@" > /dev/null 2>&1
	done
	
	_____special_live_hibernate_rmmod_remainder-vbox_procedure "$@"
}

# CAUTION: Do not alow similarity of this function name to other commonly used function names . Unintended tab completion could significantly and substantially impede user , particularly if 'disk' hibernation is not properly available .
_____special_live_hibernate() {
	! _mustGetSudo && exit 1
	
	_messageNormal 'init: _____special_live_hibernate'
	
	local currentIterations
	
	_messagePlain_nominal 'attempt: swapon'
	sudo -n swapon /dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17
	free -m
	
	_messagePlain_nominal 'detect: vboxguest'
	sudo -n lsmod | grep vboxguest > /dev/null 2>&1 && export ub_current_special_live_consider_vbox='true'
	[[ "$ub_current_special_live_consider_vbox" == 'true' ]] && _messagePlain_good 'good: detected: vboxguest'
	
	if [[ "$ub_current_special_live_consider_vbox" == 'true' ]]
	then
		_messagePlain_nominal 'attempt: terminate: VBoxService , VBoxClient'
		sudo -n pkill VBoxService
		sudo -n pkill VBoxClient
		
		pgrep ^VBox && sleep 0.1 && pgrep ^VBox && sleep 0.3 && pgrep ^VBox && sleep 1
		sudo -n pkill -KILL VBoxService
		sudo -n pkill -KILL VBoxClient
		
		
		pgrep ^VBox && sleep 0.3
		_messagePlain_nominal 'attempt: rmmod (vbox)'
		sleep 0.05
		sudo -n rmmod vboxsf
		sudo -n rmmod vboxvideo
		sudo -n rmmod vboxguest
		_____special_live_hibernate_rmmod_remainder-vbox
		
		sleep 0.02
		sudo -n rmmod vboxsf
		sudo -n rmmod vboxvideo
		sudo -n rmmod vboxguest
		_____special_live_hibernate_rmmod_remainder-vbox
	fi
	
	_messagePlain_nominal 'attempt: HIBERNATE'
	sudo -n journalctl --rotate
	sudo -n journalctl --vacuum-time=1s
	sudo -n systemctl hibernate
	
	
	# ~1.0s
	sleep 1.1
	currentIterations=0
	while [[ "$currentIterations" -lt 3 ]]
	do
		sudo -n systemctl status hibernate.target | tail -n2 | head -n1 | grep ' Reached ' > /dev/null 2>&1 && _messagePlain_probe 'Reached'
		sudo -n systemctl status hibernate.target | tail -n1 | grep ' Stopped ' > /dev/null 2>&1 && _messagePlain_probe 'Stopped'
		sudo -n systemctl status hibernate.target | grep 'inactive (dead)' > /dev/null 2>&1 && _messagePlain_probe 'inactive'
		
		
		sudo -n systemctl status hibernate.target | tail -n2 | head -n1 | grep ' Reached ' > /dev/null 2>&1 &&
		sudo -n systemctl status hibernate.target | tail -n1 | grep ' Stopped ' > /dev/null 2>&1 &&
		sudo -n systemctl status hibernate.target | grep 'inactive (dead)' > /dev/null 2>&1 &&
		break
		
		_messagePlain_good 'delay: resume'
		
		let currentIterations="$currentIterations + 1"
		sleep 0.3
	done
	
	_messagePlain_nominal 'delay: spinlock (optimistic)'
	# Expected to result in longer delay if system is not idle.
	# ~2s
	currentIterations=0
	while [[ "$currentIterations" -lt 6 ]]
	do
		let currentIterations="$currentIterations + 1"
		sleep 0.3
	done
	# 0.5s
	currentIterations=0
	while [[ "$currentIterations" -lt 5 ]]
	do
		let currentIterations="$currentIterations + 1"
		sleep 0.1
	done
	# 0.15s
	currentIterations=0
	while [[ "$currentIterations" -lt 15 ]]
	do
		let currentIterations="$currentIterations + 1"
		sleep 0.01
	done
	
	#_messagePlain_nominal 'delay: spinlock (arbitrary)'
	#sleep 1
	
	#_messagePlain_nominal 'delay: spinlock (pessimistic)'
	#_sleep_spinlock
	
	
	if [[ "$ub_current_special_live_consider_vbox" == 'true' ]]
	then
		_messagePlain_nominal 'attempt: modprobe (vbox)'
		sudo -n modprobe vboxsf
		sudo -n modprobe vboxvideo
		sudo -n modprobe vboxguest
		
		
		sleep 0.1
		_messagePlain_nominal 'attempt: VBoxService'
		sudo -n VBoxService --pidfile /var/run/vboxadd-service.sh
		
		# 0.3s
		currentIterations=0
		while [[ "$currentIterations" -lt 3 ]]
		do
			let currentIterations="$currentIterations + 1"
			sleep 0.1
		done
		_messagePlain_nominal 'attempt: VBoxClient'
		#sudo -n VBoxClient --vmsvga
		#sudo -n VBoxClient --seamless
		#sudo -n VBoxClient --draganddrop
		#sudo -n VBoxClient --clipboard
		sudo -n VBoxClient-all
	fi
	
	disown -a -h -r
	disown -a -r
	
	_messageNormal 'done: _____special_live_hibernate'
	return 0
}

_____special_live_bulk_rw() {
	! _mustGetSudo && exit 1
	_messageNormal 'init: _____special_live_bulk_rw'
	
	sudo -n mkdir -p /mnt/bulk
	_messagePlain_nominal 'detect: mount: bulk'
	if ! mountpoint /mnt/bulk
	then
		_messagePlain_nominal 'mount: rw: bulk'
		sudo -n mount -o rw /dev/disk/by-uuid/f1edb7fb-13b1-4c97-91d2-baf50e6d65d8 /mnt/bulk
	fi
	
	! mountpoint /mnt/bulk && _messagePlain_bad 'fail: detect: mount: bulk' && exit 1
	
	_messagePlain_nominal 'remount: rw: bulk'
	sudo -n mount -o remount,rw /mnt/bulk
	
	_messageNormal 'done: _____special_live_bulk_rw'
	return 0
}

# No production use. Not expected to be desirable. Any readonly files could be added, compressed, to the 'live' 'root' .
_____special_live_bulk_ro() {
	! _mustGetSudo && exit 1
	_messageNormal 'init: _____special_live_bulk_ro'
	
	sudo -n mkdir -p /mnt/bulk
	_messagePlain_nominal 'detect: mount: bulk'
	if ! mountpoint /mnt/bulk
	then
		_messagePlain_nominal 'mount: ro: bulk'
		sudo -n mount -o ro /dev/disk/by-uuid/f1edb7fb-13b1-4c97-91d2-baf50e6d65d8 /mnt/bulk
	fi
	
	! mountpoint /mnt/bulk && _messagePlain_bad 'fail: detect: mount: bulk' && exit 1
	
	_messagePlain_nominal 'remount: ro: bulk'
	sudo -n mount -o remount,ro /mnt/bulk
	
	_messageNormal 'done: _____special_live_bulk_ro'
	return 0
}


# DANGER: Simultaneous use of any 'rw' mounted filesystem with any 'restored' hibernation file/partition is expected to result in extreme filesystem corruption! Take extra precautions to avoid this mistake!
# CAUTION: Do not alow similarity of this function name to other commonly used function names . Unintended tab completion could significantly and substantially impede user.
_____special_live_dent_backup() {
	! _mustGetSudo && exit 1
	_messageNormal 'init: _____special_live_dent_backup'
	
	_messagePlain_nominal 'attempt: mount: dent'
	sudo -n mkdir -p /mnt/dent
	! mountpoint /mnt/dent && sudo -n mount -o ro /dev/disk/by-uuid/d82e3d89-3156-4484-bde2-ccc534ca440b /mnt/dent
	! mountpoint /mnt/dent && exit 1
	
	sudo -n mount -o remount,rw /mnt/dent
	
	_messagePlain_nominal 'attempt: copy: hint'
	if type -p 'pigz' > /dev/null 2>&1
	then
		sudo -n dd if=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M | pigz --fast | sudo -n tee /mnt/dent/hint_bak.gz > /dev/null
	elif type -p 'gzip' > /dev/null 2>&1
	then
		sudo -n dd if=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M | gzip --fast | sudo -n tee /mnt/dent/hint_bak.gz > /dev/null
	else
		sudo -n dd if=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M | sudo -n tee /mnt/dent/hint_bak > /dev/null
	fi
	sync
	
	_messagePlain_nominal 'attempt: mount: ro: bulk'
	sudo -n mkdir -p /mnt/bulk
	! mountpoint /mnt/bulk && sudo -n mount -o ro /dev/disk/by-uuid/f1edb7fb-13b1-4c97-91d2-baf50e6d65d8 /mnt/bulk
	! mountpoint /mnt/bulk && exit 1
	
	
	_messagePlain_nominal 'attempt: copy: bulk'
	sudo -n mkdir -p /mnt/dent/bulk_bak
	[[ ! -e /mnt/dent/bulk_bak ]] && exit 1
	[[ ! -d /mnt/dent/bulk_bak ]] && exit 1
	
	sudo -n rsync -ax --delete /mnt/bulk/. /mnt/dent/bulk_bak/.
	
	
	
	_messagePlain_nominal 'attempt: umount: dent'
	sudo -n mount -o remount,ro /mnt/dent
	sync
	
	sudo -n umount /mnt/dent
	sync
	
	_messageNormal 'done: _____special_live_dent_backup'
	return 0
}


# DANGER: Simultaneous use of any 'rw' mounted filesystem with any 'restored' hibernation file/partition is expected to result in extreme filesystem corruption! Take extra precautions to avoid this mistake!
# CAUTION: Do not alow similarity of this function name to other commonly used function names . Unintended tab completion could significantly and substantially impede user.
# WARNING: By default does not restore contents of '/mnt/bulk' assuming simultaneous use of persistent storage and hibernation backup is sufficiently unlikely and risky that a request to the user is preferable.
_____special_live_dent_restore() {
	! _mustGetSudo && exit 1
	_messageNormal 'init: _____special_live_dent_restore'
	
	_messagePlain_nominal 'attempt: mount: dent'
	sudo -n mkdir -p /mnt/dent
	! mountpoint /mnt/dent && sudo -n mount -o ro /dev/disk/by-uuid/d82e3d89-3156-4484-bde2-ccc534ca440b /mnt/dent
	! mountpoint /mnt/dent && exit 1
	#sudo -n mount -o remount,ro /mnt/dent
	
	
	_messagePlain_nominal 'attempt: copy: hint'
	#sudo -n dd if=/dev/zero of=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M
	if type -p 'pigz' > /dev/null 2>&1 || type -p 'gzip' > /dev/null 2>&1
	then
		sudo -n gzip -d -c /mnt/dent/hint_bak.gz | sudo -n dd of=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M
	else
		sudo cat /mnt/dent/hint_bak | sudo -n dd of=/dev/disk/by-uuid/469457fc-293f-46ec-92da-27b5d0c36b17 bs=1M
	fi
	sync
	
	
	
	
	#_messagePlain_nominal 'attempt: mount: rw: bulk'
	#sudo -n mkdir -p /mnt/bulk
	#! mountpoint /mnt/bulk && sudo -n mount -o ro /dev/disk/by-uuid/f1edb7fb-13b1-4c97-91d2-baf50e6d65d8 /mnt/bulk
	#! mountpoint /mnt/bulk && exit 1
	#sudo -n mount -o remount,rw /mnt/bulk
	
	#_messagePlain_nominal 'attempt: copy: bulk'
	#sudo -n mkdir -p /mnt/dent/bulk_bak
	#[[ ! -e /mnt/dent/bulk_bak ]] && exit 1
	#[[ ! -d /mnt/dent/bulk_bak ]] && exit 1
	
	#sudo -n rsync -ax --delete /mnt/dent/bulk_bak/. /mnt/bulk/.
	
	
	
	_messagePlain_nominal 'attempt: umount: dent'
	sudo -n mount -o remount,ro /mnt/dent
	sync
	sudo -n umount /mnt/dent
	sync
	
	_messagePlain_request 'request: consider restoring /mnt/bulk (not overwritten by default)'
	
	_messageNormal 'done: _____special_live_dent_restore'
	return 0
}








#Override (Program).

#Override, cygwin.


# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
#/usr/local/bin:/usr/bin:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/usr/bin:/usr/lib/lapack:/cygdrive/x:/cygdrive/x/_bin:/cygdrive/x/_bundle:/opt/ansible/bin:/opt/nodejs/current:/opt/testssl:/home/root/bin
#/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/usr/bin:/usr/lib/lapack:/cygdrive/x:/cygdrive/x/_bin:/cygdrive/x/_bundle:/opt/ansible/bin:/opt/nodejs/current:/opt/testssl:/home/root/bin
if [[ "$PATH" == "/cygdrive"* ]] || ( [[ "$PATH" == *"/cygdrive"* ]] && [[ "$PATH" != *"/usr/local/bin"* ]] )
then
	if [[ "$PATH" == "/cygdrive"* ]]
	then
		export PATH=/usr/local/bin:/usr/bin:/bin:"$PATH"
	fi
	
	[[ "$PATH" != *"/usr/local/bin"* ]] && export PATH=/usr/local/bin:"$PATH"
	[[ "$PATH" != *"/usr/bin"* ]] && export PATH=/usr/bin:"$PATH"
	[[ "$PATH" != *"/bin:"* ]] && export PATH=/bin:"$PATH"
fi



# WARNING: Multiple reasons to instead consider direct detection by other commands -  ' uname -a | grep -i cygwin > /dev/null 2>&1 ' , ' [[ -e '/cygdrive' ]] ' , etc .
_if_cygwin() {
	if uname -a | grep -i cygwin > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}

# ATTENTION: Workaround - Cygwin Portable - change directory to current directory as detected by 'ubcp.cmd' .
if [[ "$CWD" != "" ]] && [[ "$cygwin_CWD_onceOnly_done" != 'true' ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	! cd "$CWD" && exit 1
	export cygwin_CWD_onceOnly_done='true'
fi


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


if _if_cygwin
then
	# WARNING: Since MSW/Cygwin is hardly suitable for mounting UNIX/tmpfs/ramfs/etc filesystems, 'mountpoint' 'safety checks' are merely disabled.
	mountpoint() {
		true
	}
	losetup() {
		false
	}
	
	tc() {
		false
	}
	wondershaper() {
		false
	}
	
	ionice() {
		false
	}
fi


# CAUTION: Fragile, at best.
# DANGER: MSW apparently does not necessarily allow 'Administrator' access to all network 'drives'. Workaround copying of obvious files is limited.
# WARNING: Most likely, after significant delay, will 'prompt' the user with a very much obstructive, and not securing very much, dialog box.
# https://stackoverflow.com/questions/4090301/root-user-sudo-equivalent-in-cygwin
# https://superuser.com/questions/812018/run-a-command-in-another-cygwin-window-and-not-exit
_sudo_cygwin_sequence() {
	_start
	
	# 'If already admin, just run the command in-line.'
	# 'This works on my Win10 machine; dunno about others.'
	if id -G | grep -q ' 544 '
	then
		"$@"
		_stop "$?"
	fi
	
	# 'cygstart/runas doesn't handle arguments with spaces correctly so create'
	# 'a script that will do so properly.'
	echo "#!/bin/bash" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export PATH=\"$PATH\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	
	
	_safeEcho_newline "$safeTmp"/_bin.bat "$@" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'echo > "'"$safeTmp"'"/sequenceDone_'"$ubiquitousBashID" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'sleep 3' >> "$safeTmp"/cygwin_sudo_temp.sh
	chmod u+x "$safeTmp"/cygwin_sudo_temp.sh
	
	
	
	cp "$scriptAbsoluteLocation" "$safeTmp"/
	chmod u+x "$safeTmp"/$(basename "$scriptAbsoluteLocation")
	
	cp "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/_bin.bat
	chmod u+x "$safeTmp"/_bin.bat
	

	# 'Do it as Administrator.'
	#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat bash
	
	if [[ "$scriptAbsoluteFolder" == "/cygdrive/c"* ]]
	then
		# WARNING: May be untested, or (especially under interactive shell) may call obsolete code.
		cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
	else
		cygstart --action=runas "$safeTmp"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
	fi
	
	
	while ! [[ -e "$safeTmp"/sequenceDone_"$ubiquitousBashID" ]]
	do
		sleep 3
	done
	
	_stop "$?"
}
_sudo_cygwin() {
	"$scriptAbsoluteLocation" _sudo_cygwin_sequence "$@"
}

# CAUTION: BROKEN !
if _if_cygwin && type cygstart > /dev/null 2>&1
then
	sudo() {
		[[ "$1" == "-n" ]] && shift
		if type cygstart > /dev/null 2>&1
		then
			_sudo_cygwin "$@"
			#cygstart --action=runas "$@"
			#"$@"
			return
		else
			"$@"
			return
		fi
		
		return 1
	}
fi




_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles() {
	local currentBinary
	currentBinary="$1"
	
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9')
	
	local currentExpectedSubdir
	currentExpectedSubdir="$2"
	
	local forceNativeBinary
	forceNativeBinary='false'
	
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local forceWorkaroundPrefix
	forceWorkaroundPrefix="$4"
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'/Program Files/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'"/"'"Program Files"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
		false
	fi
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'/Program Files (x86)/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'"/"'"Program Files (x86)"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary" > /dev/null 2>&1 && return 0
	return 1
}

_discoverResource-cygwinNative-ProgramFiles-declaration-core() {
	local currentBinary
	currentBinary="$1"
	
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9')
	
	local currentExpectedSubdir
	currentExpectedSubdir="$2"
	
	local forceNativeBinary
	forceNativeBinary='false'
	
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local forceWorkaroundPrefix
	forceWorkaroundPrefix="$4"
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentCygdriveC_equivalent"'/core/installations/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentCygdriveC_equivalent"'"/"'"core/installations"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentCygdriveC_equivalent"'/core/installations/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentCygdriveC_equivalent"'"/"'"core/installations"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary" > /dev/null 2>&1 && return 0
	return 1
}

_discoverResource-cygwinNative-ProgramFiles() {
	local currentBinary
	currentBinary="$1"
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9')
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q="$currentCygdriveC_equivalent"
	_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
	
	
	# ATTENTION: Configure: 'c..w' (aka. 'w..c') .
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {c..w}
	do
		_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
	done
	
	_discoverResource-cygwinNative-ProgramFiles-declaration-core "$@"
	
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	return 1
}


_ops_cygwinOverride_allDisks() {
	# DANGER: Calling a script from every connected Cygwin/MSW drive arguably causes obvious problems, although any device or network directly connected to any MSW machine inevitably entails such risks.
	# WARNING: Looping through {w..c} completely may impose delays sufficient to break "_test_selfTime", "_test_broadcastPipe_page", etc, if extremely slow storage is attached.
	# ATTENTION: Configure: 'w..c' (aka. 'c..w') .
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {w..c}
	do
		# WARNING: May require export of functions!
		[[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q ]] && [[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh ]] && . /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh
	done
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
}


if [[ -e /cygdrive ]] && _if_cygwin
then
	# WARNING: Reduces incidents of extremely slow storage attachment from breaking "_test_selfTime", "_test_broadcastPipe_page", etc, at risks of not recognizing newly installed 'native' programs for up to 20minutes .
	export cygwinOverride_measureDateB=$(date +%s%N | cut -b1-13)
	[[ "$cygwinOverride_measureDateA" == "" ]] && export cygwinOverride_measureDateA=$(bc <<< "$cygwinOverride_measureDateB - 900000000" | tr -dc '0-9')
	
	# WARNING: Experiment without checking checksum to ensure functions are exported correctly!
	if [[ $(bc <<< "$cygwinOverride_measureDateB - $cygwinOverride_measureDateA" | tr -dc '0-9') -gt 1200000 ]] || [[ "$ub_setScriptChecksum_contents_cygwinOverride" != "$ub_setScriptChecksum_contents" ]]
	then
		export cygwinOverride_measureDateA=$(date +%s%N | cut -b1-13)
		export ub_setScriptChecksum_contents_cygwinOverride="$ub_setScriptChecksum_contents"
		
		_discoverResource-cygwinNative-ProgramFiles 'nmap' 'Nmap' false
		
		# WARNING: Native 'vncviewer.exe' is a GUI app, and cannot be launched directly from Cygwin SSH server.
		_discoverResource-cygwinNative-ProgramFiles 'vncviewer' 'TigerVNC' false '_workaround_cygwin_tmux '
		
		_discoverResource-cygwinNative-ProgramFiles 'qalc' 'Qalculate' false
		
		
		# WARNING: CAUTION: DANGER: UNIX EOL *MANDATORY* !
		[[ -e "$scriptAbsoluteFolder"/ops-cygwin.sh ]] && . "$scriptAbsoluteFolder"/ops-cygwin.sh
		
		# export ubiquitousBashID=uk4uPhB663kVcygT0q
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
		export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
		[[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q ]] && [[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh ]] && . /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh
		
		#_ops_cygwinOverride_allDisks "$@"
		
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	fi
fi









_setup_ubiquitousBash_cygwin_procedure_root() {
	local cygwinMSWdesktopDir
	local cygwinMSWmenuDir
	
	cygwinMSWdesktopDir=$(cygpath -u -a -A -D)
	cygwinMSWmenuDir=$(cygpath -u -a -A -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	cygwinMSWdesktopDir=$(cygpath -u -a -D)
	cygwinMSWmenuDir=$(cygpath -u -a -P)
	
	chown -R "$USER":"$USER" "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash > /dev/null 2>&1
	chown -R "$USER":None "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	chown "$USER":"$USER" "$cygwinMSWdesktopDir"/_bash.bat > /dev/null 2>&1
	chown "$USER":None "$cygwinMSWdesktopDir"/_bash.bat
	chown -R "$USER":"$USER" "$cygwinMSWmenuDir"/ubiquitous_bash/ > /dev/null 2>&1
	chown -R "$USER":None "$cygwinMSWmenuDir"/ubiquitous_bash/
}

_setup_ubiquitousBash_cygwin_procedure() {
	[[ "$scriptAbsoluteFolder" != '/cygdrive'* ]] && _stop 1
	
	_messagePlain_nominal 'init: _setup_ubiquitousBash_cygwin'
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	cd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/ubiquitous_bash.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/lean.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/ubcore.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/lean.py "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	#cp "$scriptAbsoluteFolder"/_bash "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_bash.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	#cp "$scriptAbsoluteFolder"/_bin "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_bin.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_test "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_test.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_true "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_true.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_false "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_false.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_anchor "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_anchor.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_setup_ubcp.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	
	cp "$scriptAbsoluteFolder"/package.tar.xz "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp
	
	cp -a "$scriptLocal"/ubcp/_upstream "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp -a "$scriptLocal"/ubcp/overlay "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/.gitignore "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/agpl-3.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/cygwin-portable.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/cygwin-portable-updater.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/gpl-2.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/gpl-3.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/license.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/README.md "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/ubcp.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/ubcp_rename-to-enable.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/ubcp-cygwin-portable-installer.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	
	
	
	cygwinMSWdesktopDir=$(cygpath -u -a -A -D)
	cygwinMSWmenuDir=$(cygpath -u -a -A -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	
	local cygwinMSWdesktopDir
	local cygwinMSWmenuDir
	cygwinMSWdesktopDir=$(cygpath -u -a -D)
	cygwinMSWmenuDir=$(cygpath -u -a -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	
	chown -R "$USER":"$USER" "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash > /dev/null 2>&1
	chown -R "$USER":None "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	chown "$USER":"$USER" "$cygwinMSWdesktopDir"/_bash.bat > /dev/null 2>&1
	chown "$USER":None "$cygwinMSWdesktopDir"/_bash.bat
	chown -R "$USER":"$USER" "$cygwinMSWmenuDir"/ubiquitous_bash/ > /dev/null 2>&1
	chown -R "$USER":None "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	#sudo -n "$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure_root "$@"
	
	
	_messagePlain_good 'done: _setup_ubiquitousBash_cygwin: lean'
	sleep 1
}


_setup_ubiquitousBash_cygwin() {
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$@"
}





_setup_ubcp_procedure() {
	_messagePlain_nominal 'init: _setup_ubcp_procedure'
	! uname -a | grep -i cygwin > /dev/null 2>&1 && _stop 1
	
	tskill ssh-pageant > /dev/null 2>&1
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	
	export safeToDeleteGit="true"
	if [[ -e "$currentCygdriveC_equivalent"/core/infrastructure/ubcp ]]
	then
		# DANGER: Not only does this use 'rm -rf' without sanity checking, the behavior is undefined if this ubcp installation has been used to start this script!
		#[[ -e "$currentCygdriveC_equivalent"/core/infrastructure/ubcp ]] && rm -rf "$currentCygdriveC_equivalent"/core/infrastructure/ubcp
		
		_messageError 'FAIL: ubcp already installed locally and must be deleted prior to script!'
		sleep 10
		_stop 1
		exit 1
		return 1
	fi
	
	
	
	
	
	#cd "$scriptLocal"/
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/
	cd "$currentCygdriveC_equivalent"/core/infrastructure/
	
	#tar -xvf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz
	tar -xvf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz
	
	_messagePlain_good 'done: _setup_ubcp_procedure: ubcp'
	sleep 10
	
	cd "$outerPWD"
}



# CAUTION: Do NOT hook to '_setup' .
# No production use. Developer feature.
# Highly irregular accommodation for usage of 'ubiquitous_bash' through 'ubcp' (cygwin portable) compatibility layer through MSW network drive (especially '_userVBox' MSW guest network drive) .
# WARNING: May require 'administrator' privileges under MSW. However, it may be better for this directory to be 'owned' by the 'primary' 'user' account. Particularly considering the VR/gaming/CAD software that remains 'exclusive' to MSW is 'legacy' software which for both licensing and technical reasons may be inherently incompatible with 'multi-user' access.
# WARNING: MSW 'administrator' 'privileges' may break 'ubcp' .
_setup_ubcp() {
	# WARNING: May break if 'mitigation' has not been applied!
	if ! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz ]] && ! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz ]] && [[ -e "$scriptLocal"/ubcp/cygwin ]]
	then
		"$scriptAbsoluteLocation" _package_procedure-cygwinOnly "$@"
	fi
	
	"$scriptAbsoluteLocation" _setup_ubcp_procedure "$@"
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$@"
}






_mitigate-ubcp_rewrite_procedure() {
	_messagePlain_nominal 'init: _mitigate-ubcp_rewrite_procedure'
	
	local currentRoot=$(_getAbsoluteLocation "$PWD")
	
	local currentLink="$1"
	local currentLinkFile=$(basename "$1" )
	local currentLinkFolder=$(dirname "$1")
	currentLinkFolder=$(_getAbsoluteLocation "$currentLinkFolder")
	
	local currentLinkDirective=$(readlink "$1")
	
	
	_messagePlain_probe_var currentRoot
	_messagePlain_probe_var currentLink
	_messagePlain_probe_var currentLinkFile
	_messagePlain_probe_var currentLinkFolder
	_messagePlain_probe_var currentLinkDirective
	
	[[ "$currentLinkDirective" == '/proc/'* ]] && return 0
	[[ "$currentLinkDirective" == '/dev/'* ]] && return 0
	
	
	
	local currentRelativeRoot
	local currentLinkFolder_eval
	
	local currentDots='..'
	
	local currentMatch=false
	local currentIterations=0
	
	if [[ "$currentLinkFolder" == "$currentRoot" ]]
	then
		currentRelativeRoot='.'
		currentMatch='true'
	else
		while [[ "$currentMatch" == 'false' ]] && [[ "$currentIterations" -lt 14 ]]
		do
			_messagePlain_probe "$currentLinkFolder"/"$currentDots"
			currentLinkFolder_eval=$(_getAbsoluteLocation "$currentLinkFolder"/"$currentDots")
			[[ "$currentLinkFolder_eval" == "$currentRoot" ]] && currentMatch='true'
			
			if [[ "$currentMatch" == 'true' ]]
			then
				currentRelativeRoot="$currentDots"
			elif [[ "$currentMatch" == 'false' ]]
			then
				currentDots='../'"$currentDots"
				let currentIterations="$currentIterations"+1
			fi
		done
	fi
	
	
	
	
	_messagePlain_probe_var currentRelativeRoot
	
	
	local processedLinkDirective
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		processedLinkDirective="$currentRelativeRoot""$currentLinkDirective"
		
	fi
	
	_messagePlain_probe_var processedLinkDirective
	
	
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		cd "$currentLinkFolder"
		
		ls -l "$processedLinkDirective"
		
		
		# ATTENTION: Forces scenario '2'!
		# CAUTION: Three possible scenarios to consider.
		# 2) Symlinks rewritten to '/bin'. Links now pointing to '/bin' should return files when retrieved through network drive, without this link.
		# In any case, Cygwin will not be managing this directory .
		if [[ "$mitigate_ubcp_modifySymlink" == 'true' ]]
		then
			if [[ "$currentLinkDirective" == '/usr/bin/'* ]]
			then
				processedLinkDirective="${processedLinkDirective/'/usr/bin/'/'/bin/'}"
			fi
		fi
		
		
		
		ln -sf "$processedLinkDirective" "$currentLinkFolder"/"$currentLinkFile"
		
		ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
		#rm -f "$currentLink"
		##currentLink=$(_getAbsoluteLocation "$currentLink)
		##cd "$currentLinkFolder"
		#ln -sf "$currentLinkDirective" "$currentLink"
		# ... replace symlink with file if not also a symlink
		
		cd "$outerPWD"
	fi
	
	# ATTENTION: Forces scenario '3'!
	# CAUTION: Three possible scenarios to consider.
	# 3) Symlinks replaced. No links, files only.
	if [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]]
	then
		cd "$currentLinkFolder"
		
		ls -ld "$currentLinkFolder"/"$currentLinkFile"
		
		
		
		_messagePlain_nominal 'directive: replace: true'
		cp -L -R --preserve=all "$currentLinkFolder"/"$currentLinkFile" "$currentLinkFolder"/"$currentLinkFile".replace
		rm -f "$currentLinkFolder"/"$currentLinkFile"
		mv "$currentLinkFolder"/"$currentLinkFile".replace "$currentLinkFolder"/"$currentLinkFile"
		
		ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
		cd "$outerPWD"
	fi
	
	
	
	return 0
}

_mitigate-ubcp_rewrite() {
	export safeToDeleteGit="true"
	! _safePath "$1" && _stop 1
	cd "$1"
	
	find "$2" -type l -exec "$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_procedure '{}' \;
	
	return 0
}




_mitigate-ubcp_procedure() {
	export safeToDeleteGit="true"
	! _safePath "$1" && _stop 1
	
	# DANGER: REQUIRED for symbolic links to be valid as necessary during rewrite/replace algorithm.
	ln -s "$1"/bin "$1"/usr/bin
	
	_mitigate-ubcp_rewrite "$1" "$1"/etc/alternatives
	
	_mitigate-ubcp_rewrite "$1" "$1"/bin
	_mitigate-ubcp_rewrite "$1" "$1"/usr/share
	_mitigate-ubcp_rewrite "$1" "$1"/usr/libexec
	_mitigate-ubcp_rewrite "$1" "$1"/lib
	_mitigate-ubcp_rewrite "$1" "$1"/etc/pki
	_mitigate-ubcp_rewrite "$1" "$1"/etc/ssl
	_mitigate-ubcp_rewrite "$1" "$1"/etc/crypto-policies
	_mitigate-ubcp_rewrite "$1" "$1"/etc/mc
	
	_mitigate-ubcp_rewrite "$1" "$1"/opt
	
	
	
	
	
	# CAUTION: Three possible scenarios to consider.
	# 1) Symlinks rewritten as is to '/usr/bin'. Links pointing to '/usr/bin' directory will not work through network drive unless this link remains.
		# PREVENT - ' rm -f "$1"/usr/bin ' .
		# Tested - known working ( _userVBox , _userQemu ) .
	# 2) Symlinks rewritten to '/bin'. Links now pointing to '/bin' should return files when retrieved through network drive, without this link.
		# ALLOW - ' rm -f "$1"/usr/bin ' .
		# Tested - known working ( _userVBox , _userQemu ) .
	# 3) Symlinks replaced. No links, files only.
		# ALLOW - ' rm -f "$1"/usr/bin ' 
		# Tested - known working ( _userVBox , _userQemu ) .
	# In any case, Cygwin will not be managing this directory .
	( [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]] || [[ "$mitigate_ubcp_modifySymlink" == 'true' ]] ) && rm -f "$1"/usr/bin
}




_mitigate-ubcp_directory() {
	mkdir -p "$safeTmp"/package/_local
	
	if [[ -e "$scriptLocal"/ubcp/cygwin ]]
	then
		_mitigate-ubcp_procedure "$scriptLocal"/ubcp/cygwin
		return 0
	fi
# 	if [[ -e "$scriptLib"/ubcp/cygwin ]]
# 	then
# 		_mitigate-ubcp_procedure "$scriptLib"/ubcp/cygwin
# 		return 0
# 	fi
# 	if [[ -e "$scriptAbsoluteFolder"/ubcp/cygwin ]]
# 	then
# 		_mitigate-ubcp_procedure "$scriptAbsoluteFolder"/ubcp/cygwin
# 		return 0
# 	fi
	
	
	export mitigate_ubcp_replaceSymlink='false'
	cd "$outerPWD"
	_stop 1
}

# ATTENTION: Override with 'ops' or similar.
_mitigate-ubcp() {
	export mitigate_ubcp_modifySymlink='true'
	export mitigate_ubcp_replaceSymlink='false'
	_mitigate-ubcp_directory "$@"
	
	export mitigate_ubcp_replaceSymlink='true'
	_mitigate-ubcp_directory "$@"
}



_package_procedure-cygwinOnly() {
	_start
	mkdir -p "$safeTmp"/package
	
	# WARNING: Largely due to presence of '.gitignore' files in 'ubcp' .
	export safeToDeleteGit="true"
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	
	if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	then
		_package_ubcp_copy "$@"
	fi
	
	cd "$safeTmp"/package/
	_package_subdir
	
	# ATTENTION: Unusual. Expected to result in a package containing only 'ubcp' directory in the root.
	# WARNING: Having these subdirectories opened in MSW 'explorer' (file manager) may cause this directory to not exist.
	! cd "$safeTmp"/package/"$objectName"/_local && _stop 1
	
	#tar -czvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz .
	env XZ_OPT=-5 tar -cJvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz .
	
	mkdir -p "$scriptLocal"/ubcp/
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz "$scriptLocal"/ubcp/
	
	_messagePlain_request 'request: review contents of _local/ubcp/cygwin/home and similar directories'
	sleep 20
	
	cd "$outerPWD"
	_stop
}




_package-cygwinOnly() {
	export ubPackage_enable_ubcp='true'
	"$scriptAbsoluteLocation" _package_procedure-cygwinOnly "$@"
}
_package-cygwin() {
	_package-cygwinOnly "$@"
}



















#####Utilities

_test_getAbsoluteLocation_sequence() {
	_start scriptLocal_mkdir_disable
	
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
	_start scriptLocal_mkdir_disable
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
	_start scriptLocal_mkdir_disable
	
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
		# May fail through MSW network drive provided by '_userVBox' .
		uname -a | grep -i cygwin > /dev/null 2>&1 && echo 'warn: broken (cygwin): readlink -f' && return 1
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


_cygwin_translation_rootFileParameter() {
	if ! uname -a | grep -i cygwin > /dev/null 2>&1
	then
		echo "$0"
		return 0
	fi
	
	
	local currentScriptLocation
	currentScriptLocation="$0"
	
	# CAUTION: Lookup table is used to avoid pulling in any additional dependencies. Additionally, Cygwin apparently may ignore letter case of path .
	
	[[ "$currentScriptLocation" == 'A:'* ]] && currentScriptLocation=${currentScriptLocation/A\://cygdrive/a} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'B:'* ]] && currentScriptLocation=${currentScriptLocation/B\://cygdrive/b} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'C:'* ]] && currentScriptLocation=${currentScriptLocation/C\://cygdrive/c} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'D:'* ]] && currentScriptLocation=${currentScriptLocation/D\://cygdrive/d} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'E:'* ]] && currentScriptLocation=${currentScriptLocation/E\://cygdrive/e} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'F:'* ]] && currentScriptLocation=${currentScriptLocation/F\://cygdrive/f} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'G:'* ]] && currentScriptLocation=${currentScriptLocation/G\://cygdrive/g} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'H:'* ]] && currentScriptLocation=${currentScriptLocation/H\://cygdrive/h} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'I:'* ]] && currentScriptLocation=${currentScriptLocation/I\://cygdrive/i} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'J:'* ]] && currentScriptLocation=${currentScriptLocation/J\://cygdrive/j} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'K:'* ]] && currentScriptLocation=${currentScriptLocation/K\://cygdrive/k} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'L:'* ]] && currentScriptLocation=${currentScriptLocation/L\://cygdrive/l} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'M:'* ]] && currentScriptLocation=${currentScriptLocation/M\://cygdrive/m} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'N:'* ]] && currentScriptLocation=${currentScriptLocation/N\://cygdrive/n} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'O:'* ]] && currentScriptLocation=${currentScriptLocation/O\://cygdrive/o} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'P:'* ]] && currentScriptLocation=${currentScriptLocation/P\://cygdrive/p} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Q:'* ]] && currentScriptLocation=${currentScriptLocation/Q\://cygdrive/q} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'R:'* ]] && currentScriptLocation=${currentScriptLocation/R\://cygdrive/r} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'S:'* ]] && currentScriptLocation=${currentScriptLocation/S\://cygdrive/s} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'T:'* ]] && currentScriptLocation=${currentScriptLocation/T\://cygdrive/t} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'U:'* ]] && currentScriptLocation=${currentScriptLocation/U\://cygdrive/u} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'V:'* ]] && currentScriptLocation=${currentScriptLocation/V\://cygdrive/v} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'W:'* ]] && currentScriptLocation=${currentScriptLocation/W\://cygdrive/w} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'X:'* ]] && currentScriptLocation=${currentScriptLocation/X\://cygdrive/x} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Y:'* ]] && currentScriptLocation=${currentScriptLocation/Y\://cygdrive/y} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'Z:'* ]] && currentScriptLocation=${currentScriptLocation/Z\://cygdrive/z} && echo "$currentScriptLocation" && return 0
	
	[[ "$currentScriptLocation" == 'a:'* ]] && currentScriptLocation=${currentScriptLocation/a\://cygdrive/a} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'b:'* ]] && currentScriptLocation=${currentScriptLocation/b\://cygdrive/b} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'c:'* ]] && currentScriptLocation=${currentScriptLocation/c\://cygdrive/c} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'd:'* ]] && currentScriptLocation=${currentScriptLocation/d\://cygdrive/d} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'e:'* ]] && currentScriptLocation=${currentScriptLocation/e\://cygdrive/e} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'f:'* ]] && currentScriptLocation=${currentScriptLocation/f\://cygdrive/f} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'g:'* ]] && currentScriptLocation=${currentScriptLocation/g\://cygdrive/g} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'h:'* ]] && currentScriptLocation=${currentScriptLocation/h\://cygdrive/h} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'i:'* ]] && currentScriptLocation=${currentScriptLocation/i\://cygdrive/i} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'j:'* ]] && currentScriptLocation=${currentScriptLocation/j\://cygdrive/j} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'k:'* ]] && currentScriptLocation=${currentScriptLocation/k\://cygdrive/k} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'l:'* ]] && currentScriptLocation=${currentScriptLocation/l\://cygdrive/l} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'm:'* ]] && currentScriptLocation=${currentScriptLocation/m\://cygdrive/m} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'n:'* ]] && currentScriptLocation=${currentScriptLocation/n\://cygdrive/n} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'o:'* ]] && currentScriptLocation=${currentScriptLocation/o\://cygdrive/o} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'p:'* ]] && currentScriptLocation=${currentScriptLocation/p\://cygdrive/p} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'q:'* ]] && currentScriptLocation=${currentScriptLocation/q\://cygdrive/q} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'r:'* ]] && currentScriptLocation=${currentScriptLocation/r\://cygdrive/r} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 's:'* ]] && currentScriptLocation=${currentScriptLocation/s\://cygdrive/s} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 't:'* ]] && currentScriptLocation=${currentScriptLocation/t\://cygdrive/t} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'u:'* ]] && currentScriptLocation=${currentScriptLocation/u\://cygdrive/u} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'v:'* ]] && currentScriptLocation=${currentScriptLocation/v\://cygdrive/v} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'w:'* ]] && currentScriptLocation=${currentScriptLocation/w\://cygdrive/w} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'x:'* ]] && currentScriptLocation=${currentScriptLocation/x\://cygdrive/x} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'y:'* ]] && currentScriptLocation=${currentScriptLocation/y\://cygdrive/y} && echo "$currentScriptLocation" && return 0
	[[ "$currentScriptLocation" == 'z:'* ]] && currentScriptLocation=${currentScriptLocation/z\://cygdrive/z} && echo "$currentScriptLocation" && return 0
	
	
	echo "$currentScriptLocation" && return 0
}


#Critical prerequsites.
_getAbsolute_criticalDep() {
	#! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	#Known to succeed under BusyBox (OpenWRT), NetBSD, and common Linux variants. No known failure modes. Extra precaution.
	! readlink -f . > /dev/null 2>&1 && return 1
	
	! echo 'qwerty123.git' | grep '\.git$' > /dev/null 2>&1 && return 1
	echo 'qwerty1234git' | grep '\.git$' > /dev/null 2>&1 && return 1
	
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
	
	local currentScriptLocation
	currentScriptLocation="$0"
	uname -a | grep -i cygwin > /dev/null 2>&1 && type _cygwin_translation_rootFileParameter > /dev/null 2>&1 && currentScriptLocation=$(_cygwin_translation_rootFileParameter)
	
	
	local absoluteLocation
	if [[ (-e $PWD\/$currentScriptLocation) && ($currentScriptLocation != "") ]] && [[ "$currentScriptLocation" != "/"* ]]
	then
		absoluteLocation="$PWD"\/"$currentScriptLocation"
		absoluteLocation=$(_realpath_L_s "$absoluteLocation")
	else
		absoluteLocation=$(_realpath_L "$currentScriptLocation")
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
	
	#Denylist.
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
	
	#Allowlist.
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
	[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$sessionid" != "" ]] && [[ "$1" == *$(echo "$sessionid" | head -c 16)* ]] && safeToRM="true"
	#[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$1" == "$tmpSelf"* ]] && safeToRM="true"
	
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# ATTENTION: Search for verbatim warning to find related workarounds!
	if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
	then
		if [[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "" ]] && [[ "$tmpSelf" == "/cygdrive/"* ]] && [[ "$tmpSelf" == "$tmpMSW"* ]]
		then
			safeToRM="true"
		fi
	fi
	
	
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
	
	#Denylist.
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
	
	#Allowlist.
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
	[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$sessionid" != "" ]] && [[ "$1" == *$(echo "$sessionid" | head -c 16)* ]] && safeToRM="true"
	#[[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$1" == "$tmpSelf"* ]] && safeToRM="true"
	
	
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# ATTENTION: Search for verbatim warning to find related workarounds!
	if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
	then
		if [[ "$tmpSelf" != "$safeScriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "" ]] && [[ "$tmpSelf" == "/cygdrive/"* ]] && [[ "$tmpSelf" == "$tmpMSW"* ]]
		then
			safeToRM="true"
		fi
	fi
	
	
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




# Equivalent to 'mv -n' with an error exit status if file cannot be overwritten.
# https://unix.stackexchange.com/questions/248544/mv-move-file-only-if-destination-does-not-exist
_moveconfirm() {
	local currentExitStatusText
	currentExitStatusText=$(mv -vn "$1" "$2" 2>/dev/null)
	[[ "$currentExitStatusText" == "" ]] && return 1
	return 0
}


_test_moveconfirm_procedure() {
	echo > "$safeTmp"/mv_src
	echo > "$safeTmp"/mv_dst
	
	_moveconfirm "$safeTmp"/mv_src "$safeTmp"/mv_dst && return 1
	
	rm -f "$safeTmp"/mv_dst
	! _moveconfirm "$safeTmp"/mv_src "$safeTmp"/mv_dst && return 1
	
	rm -f "$safeTmp"/mv_dst
	
	return 0
}

_test_moveconfirm_sequence() {
	_start
	
	if ! _test_moveconfirm_procedure "$@"
	then
		_stop 1
	fi
	
	_stop
}

_test_moveconfirm() {
	"$scriptAbsoluteLocation" _test_moveconfirm_sequence "$@"
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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

#Generates semi-random alphanumeric characters, default length 18.
_uid() {
	local curentLengthUID
	local currentIteration
	currentIteration=0
	
	currentLengthUID="18"
	! [[ -z "$uidLengthPrefix" ]] && ! [[ "$uidLengthPrefix" -lt "18" ]] && currentLengthUID="$uidLengthPrefix"
	! [[ -z "$1" ]] && currentLengthUID="$1"
	
	if [[ -z "$uidLengthPrefix" ]] && [[ -z "$1" ]]
	then
		# https://stackoverflow.com/questions/32484504/using-random-to-generate-a-random-string-in-bash
		# https://www.cyberciti.biz/faq/unix-linux-iterate-over-a-variable-range-of-numbers-in-bash/
		#chars=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
		chars=bgjktwxyz23679BGJKTVWXYZ
		#for currentIteration in {1..$currentLengthUID} ; do
		for (( currentIteration=1; currentIteration<="$currentLengthUID"; currentIteration++ )) ; do
		echo -n "${chars:RANDOM%${#chars}:1}"
		done
		echo
	else
		cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "$currentLengthUID" 2> /dev/null
	fi
	return 0
}

# WARNING: Reduces uniqueness, irreversible. Multiple input characters result in same output character.
_filter_random() {
	tr 'a-z' 'bgjktwxyz''bgjktwxyz''bgjktwxyz' | tr 'A-Z' 'BGJKTVWXYZ''BGJKTVWXYZ''BGJKTVWXYZ' | tr '0-9' '23679''23679''23679' | tr -dc 'bgjktwxyz23679BGJKTVWXYZ'
}

# WARNING: Reduces uniqueness, irreversible. Multiple input characters result in same output character.
# WARNING: Not recommended for short strings (ie. not recommended for '8.3' compatibility ).
_filter_hex() {
	tr 'a-z' 'bcdf''bcdf''bcdf''bcdf''bcdf''bcdf''bcdf''bcdf' | tr 'A-Z' 'BCDF''BCDF''BCDF''BCDF''BCDF''BCDF''BCDF''BCDF' | tr '0-9' '23679''23679''23679' | tr -dc 'bcdf23679BCDF'
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
	
	
	
	local currentParameter
	currentParameter="$1"
	
	[[ "$scriptAbsoluteFolder" == /media/"$USER"* ]] && [[ -e /media/"$USER" ]] && currentParameter=/media/"$USER"
	[[ "$scriptAbsoluteFolder" == /mnt/"$USER"* ]] && [[ -e /mnt/"$USER" ]] && currentParameter=/mnt/"$USER"
	[[ "$scriptAbsoluteFolder" == /var/run/media/"$USER"* ]] && [[ -e /var/run/media/"$USER" ]] && currentParameter=/var/run/media/"$USER"
	[[ "$scriptAbsoluteFolder" == /run/"$USER"* ]] && [[ -e /run/"$USER" ]] && currentParameter=/run/"$USER"
	
	local permissions_readout=$(_compat_stat_c_run "%a" "$currentParameter")
	
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
	
	permissions_uid=$(_compat_stat_c_run "%u" "$currentParameter")
	permissions_gid=$(_compat_stat_c_run "%g" "$currentParameter")
	
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

_test_permissions_ubiquitous-cygwin() {
	! _if_cygwin && _stop 1
	#! _if_cygwin && _stop "$1"
	
	_if_cygwin && echo 'warn: accepted: cygwin: permissions' && return 0
}

#Checks whether currently set "$scriptBin" and similar locations are actually safe.
# WARNING Keep in mind this is necessarily run only after PATH would already have been modified, and does not guard against threats already present on the local machine.
_test_permissions_ubiquitous() {
	[[ ! -e "$scriptAbsoluteFolder" ]] && _stop 1
	
	! _permissions_directory_checkForPath "$scriptAbsoluteFolder" && _test_permissions_ubiquitous-cygwin 1
	
	[[ -e "$scriptBin" ]] && ! _permissions_directory_checkForPath "$scriptBin" && _test_permissions_ubiquitous-cygwin 1
	[[ -e "$scriptBundle" ]] && ! _permissions_directory_checkForPath "$scriptBundle" && _test_permissions_ubiquitous-cygwin 1
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
	echo -n >> "$processListFile"
	
	pgrep "$1" >> "$processListFile"
	
	
	local parentListFile
	parentListFile="$tmpSelf"/.pidlist_$(_uid)
	
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

# DANGER: Best practice is to call as with trailing slashes and source trailing dot .
# _instance_internal /root/source/. /root/destination/
# _instance_internal "$1"/. "$actualFakeHome"/"$2"/
# DANGER: Do not silence output unless specifically required (eg. links, possibly to directories, intended not to overwrite copies).
# _instance_internal "$globalFakeHome"/. "$actualFakeHome"/ > /dev/null 2>&1
_instance_internal() {
	! [[ -e "$1" ]] && return 1
	! [[ -d "$1" ]] && return 1
	! [[ -e "$2" ]] && return 1
	! [[ -d "$2" ]] && return 1
	rsync -q -ax --exclude "/.cache" --exclude "/.git" --exclude ".git" "$@"
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

_safeEcho_quoteAddSingle() {
	# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_07.html
	while (( "$#" )); do
		_safeEcho ' '"'""$1""'"
		shift
	done
}
_safeEcho_quoteAddSingle_newline() {
	_safeEcho_quoteAddSingle "$@"
	printf '\n'
}

_safeEcho_quoteAddDouble() {
	#https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments
	
	local currentCommandStringPunctuated
	local currentCommandStringParameter
	for currentCommandStringParameter in "$@"; do
		currentCommandStringParameter="${currentCommandStringParameter//\\/\\\\}"
		currentCommandStringPunctuated="$currentCommandStringPunctuated \"${currentCommandStringParameter//\"/\\\"}\""
	done
	
	_safeEcho "$currentCommandStringPunctuated"
}
_safeEcho_quoteAddDouble_newline() {
	_safeEcho_quoteAddDouble "$@"
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

# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
_messageColors-common() {
	echo -e '\E[1;37m ' \''\\E[1;37m'\' white \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;30m ' \''\\E[0;30m'\' black \''\\E[0m'\' ' \E[0m'
	
	echo -e '\E[0;34m ' \''\\E[0;34m'\' blue \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;34m ' \''\\E[1;34m'\' blue_light \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;32m ' \''\\E[0;32m'\' green \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;32m ' \''\\E[1;32m'\' green_light \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;36m ' \''\\E[0;36m'\' cyan \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;36m ' \''\\E[1;36m'\' cyan_light \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;31m ' \''\\E[0;31m'\' red \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;31m ' \''\\E[1;31m'\' red_light \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;35m ' \''\\E[0;35m'\' purple \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;35m ' \''\\E[1;35m'\' purple_light \''\\E[0m'\' ' \E[0m'
	echo -e '\E[0;33m ' \''\\E[0;33m'\' brown \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;33m ' \''\\E[1;33m'\' yellow \''\\E[0m'\' ' \E[0m'
	
	echo -e '\E[0;30m ' \''\\E[0;30m'\' gray \''\\E[0m'\' ' \E[0m'
	echo -e '\E[1;37m ' \''\\E[1;37m'\' gray_light \''\\E[0m'\' ' \E[0m'
	return 0
}

# https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
# Color		Foreground Code		Background Code
# Black			30	40
# Red			31	41
# Green			32	42
# Yellow		33	43
# Blue			34	44
# Magenta		35	45
# Cyan			36	46
# Light Gray		37	47
# Gray			90	100
# Light Red		91	101
# Light Green		92	102
# Light Yellow		93	103
# Light Blue		94	104
# Light Magenta		95	105
# Light Cyan		96	106
# White			97	107
_messageColors-extra() {
	local currentIterationA
	local currentIterationB
	
	for (( currentIterationA=30; currentIterationA<="37"; currentIterationA++ )) ; do
		echo -e '\033[0;'"$currentIterationA"'m ''\\033[0;'"$currentIterationA"'m 'message' \\033[0m'' \033[0m'
		echo -e '\033[1;'"$currentIterationA"'m ''\\033[1;'"$currentIterationA"'m 'message' \\033[0m'' \033[0m'
	done
	
	for (( currentIterationA=90; currentIterationA<="97"; currentIterationA++ )) ; do
		echo -e '\033[0;'"$currentIterationA"'m ''\\033[0;'"$currentIterationA"'m 'message' \\033[0m'' \033[0m'
		echo -e '\033[1;'"$currentIterationA"'m ''\\033[1;'"$currentIterationA"'m 'message' \\033[0m'' \033[0m'
	done
	
	
	
	currentIterationB=37
	for (( currentIterationA=40; currentIterationA<="46"; currentIterationA++ )) ; do
		echo -e '\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
	done
	currentIterationA=47
	currentIterationB=30
	echo -e '\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
	
	currentIterationB=37
	for (( currentIterationA=100; currentIterationA<="107"; currentIterationA++ )) ; do
		echo -e '\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
	done
}

_messageColors-all() {
	local currentIterationA
	local currentIterationB
	
	for (( currentIterationB=30; currentIterationB<="37"; currentIterationB++ )) ; do
		for (( currentIterationA=40; currentIterationA<="47"; currentIterationA++ )) ; do
			echo -e '\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
			echo -e '\033[1;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
		done
	done
	
	for (( currentIterationB=90; currentIterationB<="97"; currentIterationB++ )) ; do
		for (( currentIterationA=100; currentIterationA<="107"; currentIterationA++ )) ; do
			echo -e '\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
			echo -e '\033[1;'"$currentIterationB"';'"$currentIterationA"'m ' '\\033[0;'"$currentIterationB"';'"$currentIterationA"'m ' message ' \\033[0m' ' \033[0m'
		done
	done
}

_messageColors() {
	clear
	_messageColors-common "$@"
	echo
	echo '##########'
	echo
	_messageColors-extra "$@"
	echo
	echo '##########'
	echo
	_messageColors-all "$@"
}


_color_demo() {
	_messagePlain_request _color_demo
	_messagePlain_nominal _color_demo
	_messagePlain_probe _color_demo
	_messagePlain_probe_expr _color_demo
	_messagePlain_probe_var ubiquitousBashIDshort
	_messagePlain_good _color_demo
	_messagePlain_warn _color_demo
	_messagePlain_bad _color_demo
	_messagePlain_probe_cmd echo _color_demo
	_messagePlain_probe_quoteAddDouble echo _color_demo
	_messagePlain_probe_quoteAddSingle echo _color_demo
	_messageNormal _color_demo
	_messageError _color_demo
	_messageDELAYipc _color_demo
	_messageProcess _color_demo
}
_color_end() {
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '</span>'
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n ' \E[0m'
}

_color_begin_request() {
	#b218b2
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#b218b2;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;35m '
}
_color_begin_nominal() {
	#18b2b2
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#18b2b2;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;36m '
}
_color_begin_probe() {
	#1818b2
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#1818b2;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;34m '
}
_color_begin_probe_noindent() {
	#1818b2
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#1818b2;background-color:#848484;">'
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;34m'
}
_color_begin_good() {
	#17ae17
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#17ae17;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;32m '
}
_color_begin_warn() {
	#ffff54
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#ffff54;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[1;33m '
}
_color_begin_bad() {
	#b21818
	#848484
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#b21818;background-color:#848484;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[0;31m '
}
_color_begin_Normal() {
	#54ff54
	#18b2b2
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#54ff54;background-color:#18b2b2;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[1;32;46m '
}
_color_begin_Error() {
	#ffff54
	#b21818
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#ffff54;background-color:#b21818;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[1;33;41m '
}
_color_begin_DELAYipc() {
	#ffff54
	#b2b2b2
	( [[ "$current_scriptedIllustrator_markup" == "html" ]] || [[ "$current_scriptedIllustrator_markup" == "mediawiki" ]] ) && echo -e -n '<span style="color:#ffff54;background-color:#b2b2b2;"> '
	[[ "$current_scriptedIllustrator_markup" == "" ]] && echo -e -n '\E[1;33;47m '
}



#Purple. User must do something manually to proceed. NOT to be used for dependency installation requests - use probe, bad, and fail statements for that.
_messagePlain_request() {
	_color_begin_request
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Cyan. Harmless status messages.
#"generic/ubiquitousheader.sh"
_messagePlain_nominal() {
	_color_begin_nominal
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe() {
	_color_begin_probe
	#_color_begin_probe_noindent
	echo -n "$@"
	_color_end
	echo
	return 0
}
_messagePlain_probe_noindent() {
	#_color_begin_probe
	_color_begin_probe_noindent
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_expr() {
	_color_begin_probe
	echo -e -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#"generic/ubiquitousheader.sh"
_messagePlain_probe_var() {
	_color_begin_probe
	
	echo -n "$1"'= '
	
	eval echo -e -n \$"$1"
	
	_color_end
	echo
	return 0
}
_messageVar() {
	_messagePlain_probe_var "$@"
}

#Green. Working as expected.
#"generic/ubiquitousheader.sh"
_messagePlain_good() {
	_color_begin_good
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Yellow. May or may not be a problem.
#"generic/ubiquitousheader.sh"
_messagePlain_warn() {
	_color_begin_warn
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Red. Will result in missing functionality, reduced performance, etc, but not necessarily program failure overall.
_messagePlain_bad() {
	_color_begin_bad
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Blue. Diagnostic instrumentation.
#Prints "$@" and runs "$@".
# WARNING: Use with care.
_messagePlain_probe_cmd() {
	_color_begin_probe
	
	_safeEcho "$@"
	
	_color_end
	echo
	
	"$@"
	
	return
}
_messageCMD() {
	_messagePlain_probe_cmd "$@"
}

#Blue. Diagnostic instrumentation.
#Prints "$@" with quotes around every parameter.
_messagePlain_probe_quoteAddDouble() {
	_color_begin_probe
	
	_safeEcho_quoteAddDouble "$@"
	
	_color_end
	echo
	
	return
}
_messagePlain_probe_quoteAdd() {
	_messagePlain_probe_quoteAddDouble "$@"
}

#Blue. Diagnostic instrumentation.
#Prints "$@" with single quotes around every parameter.
_messagePlain_probe_quoteAddSingle() {
	_color_begin_probe
	
	_safeEcho_quoteAddSingle "$@"
	
	_color_end
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
	_color_begin_Normal
	echo -n "$@"
	_color_end
	echo
	return 0
}

#Demarcate major failures.
_messageError() {
	_color_begin_Error
	echo -n "$@"
	_color_end
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
	return 0
}

_messageWARN() {
	echo
	echo "$@"
	return 0
}

# Demarcate *any* delay performed to allow 'InterProcess-Communication' connections (perhaps including at least some network or serial port servers).
_messageDELAYipc() {
	_color_begin_DELAYipc
	echo -e -n 'delay: InterProcess-Communication'
	_color_end
	echo
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
	
	_color_begin_Normal
	
	echo -n "$processString"
	
	_color_end
	
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

#Provide only approximate, realative paths. These will be disassembled and treated as a search query following strict preferences.
#"generic/filesystem/absolutepaths.sh"
_includeScript() {
	_tryExec "_includeScript_prog" "$1" && return 0

	local includeScriptFilename=$(basename "$1")
	local includeScriptSubdirectory=$(dirname "$1")
	
	_includeFile "$configDir"/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	
	_includeFile "$configDir"/"$includeScriptFilename" && return 0
	
	_includeFile "$progDir"/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	
	_includeFile "$progDir"/"$includeScriptFilename" && return 0
	
	_includeFile "$ubiquitousLibDir"/"$includeScriptSubdirectory"/"$includeScriptFilename" && return 0
	
	_includeFile "$ubiquitousLibDir"/"$includeScriptFilename" && return 0
	
	#[[ "$configBaseDir" == "" ]] && configBaseDir="_config"
	[[ "$configBaseDir" == "" ]] && configBaseDir=$(basename "$configDir")
	
	_includeFile "$ubiquitousLibDir"/"$configBaseDir"/"$includeScriptFilename" && return 0
	
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
	
	#[[ -h "$1" ]] && rm -f "$1" && return 0
	[[ -h "$1" ]] && rm -f "$1" > /dev/null 2>&1
	
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

_cmdDaemon_sequence() {
	export isDaemon=true
	
	"$@" &
	
	local currentPID="$!"
	
	#Any PID which may be part of a daemon may be appended to this file.
	echo "$currentPID" | _prependDaemonPID
	
	wait "$currentPID"
}

_cmdDaemon() {
	"$scriptAbsoluteLocation" _cmdDaemon_sequence "$@" &
	disown -a -h -r
	disown -a -r
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
	
	# WARNING: Not yet relying exclusively on 'netstat' - recommend continuing to install 'nmap' for Cygwin port range detection (and also for _waitPort) .
	if uname -a | grep -i cygwin > /dev/null 2>&1
	then
		! type nmap > /dev/null 2>&1 && echo "missing socket detection: nmap" && _stop 1
		! type netstat | grep cygdrive > /dev/null 2>&1 && echo "missing socket detection: netstat" && _stop 1
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
	
	if uname -a | grep -i cygwin > /dev/null 2>&1 && type netstat > /dev/null 2>&1 && type netstat | grep cygdrive > /dev/null 2>&1
	then
		#nmap --host-timeout 0.1 -Pn localhost -p "$1" 2> /dev/null | grep open > /dev/null 2>&1
		
		# https://www.maketecheasier.com/check-ports-in-use-windows10/
		#netstat -a | grep 'TCP\|UDP' | cut -f 1-7 -d\
		netstat -a -n -q | grep 'TCP\|UDP' | cut -f 1-8 -d\  | grep ':'"$1" > /dev/null 2>&1
		return $?
	fi
	
	if type nmap
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
	
	#Non public ports are between 49152-65535 (2^15 + 2^14 to 2^16 - 1).
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

_typeShare() {
	_typeDep "$1" && return 0
	
	[[ -e /usr/share/"$1" ]] && ! [[ -d /usr/share/"$1" ]] && return 0
	[[ -e /usr/local/share/"$1" ]] && ! [[ -d /usr/local/share/"$1" ]] && return 0
	
	[[ -d /usr/share/"$1" ]] && return 2
	[[ -d /usr/local/share/"$1" ]] && return 2
	
	[[ "$1" == '/'* ]] && [[ -e "$1"* ]] && return 3
	ls /usr/share/"$1"* > /dev/null 2>&1 && return 3
	ls /usr/local/share/"$1"* > /dev/null 2>&1 && return 3
	
	return 1
}

_typeShare_dir_wildcard() {
	local currentFunctionReturn
	_typeShare "$@"
	currentFunctionReturn="$?"
	
	[[ "$currentFunctionReturn" == '0' ]] && return 0
	[[ "$currentFunctionReturn" == '2' ]] && return 0
	[[ "$currentFunctionReturn" == '3' ]] && return 0
	return 1
}

_typeShare_dir() {
	local currentFunctionReturn
	_typeShare "$@"
	currentFunctionReturn="$?"
	
	[[ "$currentFunctionReturn" == '0' ]] && return 0
	[[ "$currentFunctionReturn" == '2' ]] && return 0
	return 1
}

_typeDep() {
	
	# WARNING: Allows specification of entire path from root. *Strongly* prefer use of subpath matching, for increased portability.
	[[ "$1" == '/'* ]] && [[ -e "$1" ]] && return 0
	
	[[ -e /lib/"$1" ]] && ! [[ -d /lib/"$1" ]] && return 0
	[[ -e /lib/x86_64-linux-gnu/"$1" ]] && ! [[ -d /lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /lib64/"$1" ]] && ! [[ -d /lib64/"$1" ]] && return 0
	[[ -e /lib64/x86_64-linux-gnu/"$1" ]] && ! [[ -d /lib64/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/lib/"$1" ]] && ! [[ -d /usr/lib/"$1" ]] && return 0
	[[ -e /usr/lib/x86_64-linux-gnu/"$1" ]] && ! [[ -d /usr/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/local/lib/"$1" ]] && ! [[ -d  /usr/local/lib/"$1" ]] && return 0
	[[ -e /usr/local/lib/x86_64-linux-gnu/"$1" ]] && ! [[ -d /usr/local/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/include/"$1" ]] && ! [[ -d /usr/include/"$1" ]] && return 0
	[[ -e /usr/include/x86_64-linux-gnu/"$1" ]] && ! [[ -d /usr/include/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/local/include/"$1" ]] && ! [[ -d /usr/local/include/"$1" ]] && return 0
	[[ -e /usr/local/include/x86_64-linux-gnu/"$1" ]] && ! [[ -d /usr/local/include/x86_64-linux-gnu/"$1" ]] && return 0
	
	if ! type "$1" >/dev/null 2>&1
	then
		return 1
	fi
	
	return 0
}

_wantDep() {
	_typeDep "$1" && return 0
	
	# Expect already root if 'MSW/Cygwin' and obstructive popup dialog if 'sudo' is called through 'MSW/Cygwin' .
	_if_cygwin && return 1
	
	_wantSudo && sudo -n "$scriptAbsoluteLocation" _typeDep "$1" && return 0
	
	return 1
}

_mustGetDep() {
	_typeDep "$1" && return 0
	
	# Expect already root if 'MSW/Cygwin' and obstructive popup dialog if 'sudo' is called through 'MSW/Cygwin' .
	_if_cygwin && return 1
	
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
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && return 0
	
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && exit 1
	
	return 0
}

#Determines if sudo is usable by scripts. Will not exit on failure.
_wantSudo() {
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && return 0
	
	local rootAvailable
	rootAvailable=false
	
	rootAvailable=$(sudo -n echo true 2> /dev/null)
	
	#[[ $(id -u) == 0 ]] && rootAvailable=true
	
	! [[ "$rootAvailable" == "true" ]] && return 1
	
	return 0
}

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
_getUUID() {
	if [[ -e /proc/sys/kernel/random/uuid ]]
	then
		cat /proc/sys/kernel/random/uuid
		return 0
	fi
	
	
	if type -p uuidgen > /dev/null 2>&1
	then
		uuidgen
		return 0
	fi
	
	# Failure. Intentionally adds extra characters to cause any tests of uuid output to fail.
	_uid 40
	return 1
}
alias getUUID=_getUUID

#Reset prefixes.
export tmpPrefix=""
export tmpSelf=""

# ATTENTION: CAUTION: Should only be used by a single unusual Cygwin override. Must be reset if used for any other purpose.
#export descriptiveSelf=""

#####Global variables.
#Fixed unique identifier for ubiquitous bash created global resources, such as bootdisc images to be automaticaly mounted by guests. Should NEVER be changed.
export ubiquitiousBashIDnano=uk4u
export ubiquitiousBashIDshort="$ubiquitiousBashIDnano"PhB6
export ubiquitiousBashID="$ubiquitiousBashIDshort"63kVcygT0q
export ubiquitousBashIDnano=uk4u
export ubiquitousBashIDshort="$ubiquitousBashIDnano"PhB6
export ubiquitousBashID="$ubiquitousBashIDshort"63kVcygT0q

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
elif ( [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]] ) && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
then
	ub_import=true
	true #Do not override.
	_messagePlain_probe_expr 'parent: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''parent: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''parent: sessionid= '"$sessionid" | _user_log-ub
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || [[ "$ub_import_param" == "--compressed" ]] || ( [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] )
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

#Current directory for preservation.
export outerPWD=$(_getAbsoluteLocation "$PWD")

export initPWD="$PWD"
intInitPWD="$PWD"


# DANGER: CAUTION: Undefined removal of (at least temporary) directories may be possible. Do NOT use without thorough consideration!
# Only known use is setting the temporary directory of a subsequent background process through "$scriptAbsoluteLocation" .
# EXAMPLE: _interactive_pipe() { ... }
if [[ "$ub_force_sessionid" != "" ]]
then
	sessionid="$ub_force_sessionid"
	[[ "$ub_force_sessionid_repeat" != 'true' ]] && export ub_force_sessionid=""
fi


_get_ub_globalVars_sessionDerived() {

export lowsessionid=$(echo -n "$sessionid" | tr A-Z a-z )

# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
then
	if [[ "$tmpSelf" == "" ]]
	then
		
		export tmpMSW=$( cd "$LOCALAPPDATA" 2>/dev/null ; pwd )"/Temp"
		[[ ! -e "$tmpMSW" ]] && export tmpMSW=$( cd "$LOCALAPPDATA" 2>/dev/null ; pwd )"/faketemp"
		
		if [[ "$tmpMSW" != "" ]]
		then
			export descriptiveSelf="$sessionid"
			type md5sum > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != '/bin/'* ]] && [[ "$scriptAbsoluteLocation" != '/usr/'* ]] && export descriptiveSelf=$(_getScriptAbsoluteLocation | md5sum | head -c 2)$(echo "$sessionid" | head -c 16)
			export tmpSelf="$tmpMSW"/"$descriptiveSelf"
			
			[[ "$descriptiveSelf" == "" ]] && export tmpSelf="$tmpMSW"/"$sessionid"
			true
		fi
		
		( [[ "$tmpSelf" == "" ]] || [[ "$tmpMSW" == "" ]] ) && export tmpSelf=/tmp/"$sessionid"
		true
		
	fi
fi


# CAUTION: 'Proper' UNIX platforms are expected to use "$scriptAbsoluteFolder" as "$tmpSelf" . Only by necessity may these variables be different.
# CAUTION: If not blank, '$tmpSelf' must include first 16 digits of "$sessionid". Failure to do so may cause 'rmdir' collisions and prevent '_safeRMR' from allowing appropriate removal.
# Virtualization and OS image modification functions in particular are not guaranteed to have been otherwise tested.
[[ "$tmpSelf" == "" ]] && export tmpSelf="$scriptAbsoluteFolder"

#Temporary directories.
export safeTmp="$tmpSelf""$tmpPrefix"/w_"$sessionid"
export scopeTmp="$tmpSelf""$tmpPrefix"/s_"$sessionid"
export queryTmp="$tmpSelf""$tmpPrefix"/q_"$sessionid"
export logTmp="$safeTmp"/log
#Solely for misbehaved applications called upon.
export shortTmp=/tmp/w_"$sessionid"
[[ "$tmpMSW" != "" ]] && export shortTmp="$tmpMSW"/w_"$sessionid"

}
_get_ub_globalVars_sessionDerived "$@"






export scriptBin="$scriptAbsoluteFolder"/_bin
export scriptBundle="$scriptAbsoluteFolder"/_bundle
export scriptLib="$scriptAbsoluteFolder"/_lib
#For trivial installations and virtualized guests. Exclusively intended to support _setupUbiquitous and _drop* hooks.
[[ ! -e "$scriptBin" ]] && export scriptBin="$scriptAbsoluteFolder"
[[ ! -e "$scriptBundle" ]] && export scriptBundle="$scriptAbsoluteFolder"
[[ ! -e "$scriptLib" ]] && export scriptLib="$scriptAbsoluteFolder"


# WARNING: Standard relied upon by other standalone scripts (eg. MSW compatible _anchor.bat )
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
# WARNING: Does NOT work on Cygwin, files written to either '/tmp' or '/dev/shm' are persistent.
#Fail-Safe
export bootTmp="$scriptLocal"
#Typical BSD
[[ -d /tmp ]] && export bootTmp='/tmp'
#Typical Linux
[[ -d /dev/shm ]] && export bootTmp='/dev/shm'
#Typical MSW - WARNING: Persistent!
[[ "$tmpMSW" != "" ]] && export bootTmp="$tmpMSW"

#Specialized temporary directories.

#MetaEngine/Engine Tmp Defaults (example, no production use)
#export metaTmp="$tmpSelf""$tmpPrefix"/.m_"$sessionid"
#export engineTmp="$tmpSelf""$tmpPrefix"/.e_"$sessionid"

# WARNING: Only one user per (virtual) machine. Requires _prepare_abstract . Not default.
# DANGER: Mandatory strict directory 8.3 compliance for this variable! Long subdirectory/filenames permitted thereafter.
# DANGER: Permitting multi-user access to this directory may cause unexpected behavior, including inconsitent file ownership.
#Consistent absolute path abstraction.
export abstractfs_root=/tmp/"$ubiquitousBashIDnano"
( [[ "$bootTmp" == '/dev/shm' ]] || [[ "$bootTmp" == '/tmp' ]] || [[ "$tmpMSW" != "" ]] ) && export abstractfs_root="$bootTmp"/"$ubiquitousBashIDnano"
export abstractfs_lock="$bootTmp"/"$ubiquitousBashID"/afslock

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


export ub_anchor_specificSoftwareName=""
export ub_anchor_specificSoftwareName

export ub_anchor_user=""
export ub_anchor_user

export ub_anchor_autoupgrade=""
export ub_anchor_autoupgrade



# WARNING: In practice, at least some of 'queue' may be considered 'lean' functionality, to be included regardless of whether '_deps_queue' has been called through 'compile.sh' .
_deps_queue() {
	#_deps_notLean
	#_deps_dev
	
	# Message queue - 'broadcastPipe' , etc , underlying functions , '_read_page' , etc .
	export enUb_queue="true"
	
	# Packet - any noise-tolerant 'format' .
	# RESERVED variable name - synonymous with 'enUb_queue' .
	#export enUb_packet="true"
	
	# Portal - a 'filter program' to make arrangements between embedded devices of various unique identities and/or devices (eg. 'xAxis400stepsMM' . )
	# RESERVED variable name - synonymous with 'enUb_queue' .
	#export enUb_portal="true"
}

_compile_bash_queue() {
	export includeScriptList
	
	#includeScriptList+=( "queue"/undefined.sh )
}

_compile_bash_vars_queue() {
	export includeScriptList
	
	#[[ "$enUb_queue" == "true" ]] && 
	#[[ "$enUb_packet" == "true" ]] && 
	#[[ "$enUb_portal" == "true" ]] && 
	
	
	# ATTENTION: Only the test procedures are disabled if the 'queue' dependency is not declared. Due to the lengthy timing required to reliabily test the inherently unpredictability of any InterProcess-Communication with non-dedicated non-realtime software.
	
	
	
	
	includeScriptList+=( "queue"/queue_vars.sh )
	includeScriptList+=( "queue"/queue_vars_default.sh )
	
	includeScriptList+=( "queue"/queue.sh )
	
	
	
	includeScriptList+=( "queue/tripleBuffer"/page_read.sh )
	includeScriptList+=( "queue/tripleBuffer"/page_read_single.sh )
	
	includeScriptList+=( "queue/tripleBuffer"/page_write.sh )
	includeScriptList+=( "queue/tripleBuffer"/page_write_single.sh )
	
	
	includeScriptList+=( "queue/tripleBuffer"/broadcastPipe_page_here.sh )
	includeScriptList+=( "queue/tripleBuffer"/broadcastPipe_page.sh )
	
	includeScriptList+=( "queue/tripleBuffer"/demand_broadcastPipe_page.sh )
	
	
	#[[ "$enUb_queue" == "true" ]] && includeScriptList+=( "queue/tripleBuffer"/benchmark_page.sh )
	includeScriptList+=( "queue/tripleBuffer"/benchmark_page.sh )
	
	
	[[ "$enUb_queue" ]] && includeScriptList+=( "queue/tripleBuffer"/test_broadcastPipe_page.sh )
	[[ "$enUb_queue" ]] && includeScriptList+=( "queue/tripleBuffer"/benchmark_broadcastPipe_page.sh )
	
	
	
	includeScriptList+=( "queue/aggregator"/fifo_aggregator.sh )
	
	includeScriptList+=( "queue/aggregator"/aggregator_read.sh )
	includeScriptList+=( "queue/aggregator"/aggregator_write.sh )
	
	includeScriptList+=( "queue/aggregator/static"/broadcastPipe_aggregatorStatic.sh )
	includeScriptList+=( "queue/aggregator/static"/demand_broadcastPipe_aggregatorStatic.sh )
	
	[[ "$enUb_queue" ]] && includeScriptList+=( "queue/aggregator/static"/test_broadcastPipe_aggregatorStatic.sh )
	[[ "$enUb_queue" ]] && includeScriptList+=( "queue/aggregator/static"/benchmark_broadcastPipe_aggregatorStatic.sh )
	
	( [[ "$enUb_queue" ]] || [[ "$enUb_dev" == "true" ]] ) && includeScriptList+=( "queue/aggregator/static"/test_scope_aggregatorStatic.sh )
	
	
	includeScriptList+=( "queue/zSocket"/page_socket_tcp.sh )
	includeScriptList+=( "queue/zSocket"/page_socket_unix.sh )
	includeScriptList+=( "queue/zSocket"/aggregatorStatic_socket_tcp.sh )
	includeScriptList+=( "queue/zSocket"/aggregatorStatic_socket_unix.sh )
	
	
	
	
	
	includeScriptList+=( "queue/zDatabase"/database.sh )
	
	
	includeScriptList+=( "queue/zInteractive"/interactive.sh )
	
	
	
	[[ "$enUb_queue" ]] && includeScriptList+=( "queue"/test_queue.sh )
	
}

_deps_metaengine() {
# 	#_deps_notLean
	_deps_dev
	
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


_generate_lean-lib-python_here() {
	cat << 'CZXWXcRMTo8EmM8i4d'

# https://stackoverflow.com/questions/44834/can-someone-explain-all-in-python

# https://bruxy.regnet.cz/programming/bash-python/workshop_bash-python-en.html
# https://www.geeksforgeeks.org/how-to-run-bash-script-in-python/
# https://softwareengineering.stackexchange.com/questions/207613/encoding-a-bash-script-for-use-in-python

# https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za

# https://kimsereylam.com/python/2020/02/07/improve-your-python-shell-with-pythonrc.html




#os.system("python --version")
#print (sys.version_info)



#os.system("ubiquitous_bash.sh _getAbsoluteFolder .")



# https://www.geeksforgeeks.org/how-to-pass-multiple-arguments-to-function/

#def _bin(currentArgumentsString):
#	os.system("ubiquitous_bash.sh _bin " + currentArgumentsString)

#_bin("_getAbsoluteFolder .")

#_bin("_scope .")

#_bin("_bash -i")



#def _bash():
#	os.system("ubiquitous_bash.sh _bin _bash -i ")

#def _bash():
#	os.system("$HOME/.ubcore/ubiquitous_bash/ubcore.sh _bash -i ")

#_bash()





########################################


# WARNING: Python API documentation suggests significant possibility of incompatibility (perhaps return object type) 'if sys.hexversion < 0x03060000' or 'if sys.hexversion < 0x03000000'.
# CAUTION: Python API version compatibility may or may not be strictly enforced, due to lack of known failures, and/or usual expectations of problems from the multiple ways of doing things.
# Apparently reasonable expectations confirmed by exhaustive research may be met if python version is at least >0x20710f0 and <0x30703f0 .
#import sys
#if sys.hexversion < 0x03060000:
# https://stackoverflow.com/questions/446052/how-can-i-check-for-python-version-in-a-program-that-uses-new-language-features
#	exit(1)


#_messagePlain_request( 'request: user please install...' )
def _messagePlain_request(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;35m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_nominal( 'init: _function' )
def _messagePlain_nominal(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;36m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_probe( '_messagePlain_probe ( \'_messagePlain_probe\' ) ' )
def _messagePlain_probe(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;34m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_good( 'good: success' )
def _messagePlain_good(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;32m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_warn( 'warn: workaround' )
def _messagePlain_warn(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;33m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_bad( 'bad: fail: missing' )
def _messagePlain_bad(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;31m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messageNormal( '_function_sequence: Stop' )
def _messageNormal(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;32;46m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messageError( 'FAIL: unknown app failure' )
def _messageERROR(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;33;41m\x02 ' + currentMessage + ' \x01\033[0m\x02' )


#_messageNormal( '_function_sequence: Start' )

#_messagePlain_nominal( 'init: _function' )
#_messagePlain_request( 'request: user please install...' )
#_messagePlain_probe( '_messagePlain_probe ( \'_messagePlain_probe\' ) ' )

#_messagePlain_good( 'good: success' )
#_messagePlain_warn( 'warn: workaround' )
#_messagePlain_bad( 'bad: fail: missing' )

#_messageERROR( 'FAIL: unknown app failure' )

#_messageNormal( '_function_sequence: Stop' )







import sys
# https://stackoverflow.com/questions/446052/how-can-i-check-for-python-version-in-a-program-that-uses-new-language-features
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
# WARNING: Procedures exclusively relying on python code are NOT intended or expected to be robust. Instead use '_getScriptAbsoluteLocation' within 'ubiquitous_bash.sh' as able.
# WARNING: Whether '__file__' has similar characteristics to "$0" as used within 'ubiquitous_bash' in all relevant cases is NOT determined and is NOT to be relied upon.
# WARNING: Historically 'python' has NOT had the API stability, reliability, or portability of 'bash'.
# https://stackoverflow.com/questions/4934806/how-can-i-find-scripts-directory
# https://stackoverflow.com/questions/3503879/assign-output-of-os-system-to-a-variable-and-prevent-it-from-being-displayed-on
#currentPathCheck = subprocess.Popen(['/bin/bash', '--noprofile', '--norc', '-c', 'type -p ubiquitous_bash.sh'], stdout=subprocess.PIPE, universal_newlines=True)
#print(os.path.dirname(os.path.realpath(__file__)))
#print(sys.path[0])
#os.path.abspath(os.path.dirname(os.path.realpath(__file__))).rstrip('\n')
#if True:
#currentProc = subprocess.Popen(['/bin/bash', '-c', 'ubiquitous_bash.sh _getAbsoluteFolder ' + __file__], stdout=subprocess.PIPE, universal_newlines=True)
#currentProc = subprocess.Popen(['/bin/bash', '--noprofile', '--norc', '-c', 'ubiquitous_bash.sh _getAbsoluteFolder ' + __file__], stdout=subprocess.PIPE, universal_newlines=True)
#currentProc = subprocess.Popen(['ubiquitous_bash.sh', '_getAbsoluteFolder', __file__], stdout=subprocess.PIPE, universal_newlines=True)
def _getScriptAbsoluteFolder():
	currentPathCheck = subprocess.Popen(['/bin/bash', '-c', 'type -p ubiquitous_bash.sh'], stdout=subprocess.PIPE, universal_newlines=True)
	currentPathCheck.communicate()
	currentPathCheck.wait()
	if currentPathCheck.returncode == 0:
		currentProc = subprocess.Popen(['ubiquitous_bash.sh', '_getAbsoluteFolder', __file__], stdout=subprocess.PIPE, universal_newlines=True)
		(currentOut, currentErr) = currentProc.communicate()
		currentProc.wait()
		currentOut = currentOut.rstrip('\n')
		return(currentOut.rstrip('\n'))
	else:
		return(os.path.abspath(os.path.dirname(os.path.realpath(__file__))).rstrip('\n'))

#print(_getScriptAbsoluteFolder())










import sys
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
#
#_bash()
# WARNING: CAUTION: DANGER: Beware '_getScriptAbsoluteLocation' will NOT be set correctly!
#_bash(['-c', '_getScriptAbsoluteLocation'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#_bash("-c '_getScriptAbsoluteLocation'", True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#
#_bash(['-c', 'echo test', 'xyz'])
#print(_bash(['-c', 'echo test', 'xyz'], False))
#print(_bash(['-c', '_false'], False))
#print(_bash(['-c', '_false'], False)[1])
#
#_bash('-i')
#_bash("-c '/bin/echo true'")
#_bash("-c 'echo true'")
# https://stackoverflow.com/questions/38821586/one-line-to-check-if-string-or-list-then-convert-to-list-in-python
# https://stackoverflow.com/questions/23883394/detect-if-python-script-is-run-from-an-ipython-shell-or-run-from-the-command-li
#sys.argv[1]
#os.system("$HOME/.ubcore/ubiquitous_bash/ubcore.sh _bash -i ")
#currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
#print(['ubiquitous_bash.sh', '_bash'] + currentArguments)
def _bash(currentArguments = ['-i'], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh"):
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
			current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
			current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists("/cygdrive/c/core/infrastructure/lean/lean.sh"):
			current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/lean/lean.sh"
	currentArguments = ['-i'] if currentArguments == '-i' else currentArguments
	if isinstance(currentArguments, str):
		# WARNING: Discouraged.
		if not currentArguments == '-i':
			currentProc = subprocess.Popen(current_ubiquitous_bash + " _bash " + currentArguments, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
			currentOut = currentOut.rstrip('\n')
			if currentPrint == True:
				print(currentOut)
				return (currentOut), currentProc.returncode
		else:
			currentProc = subprocess.Popen(current_ubiquitous_bash + " _bash " + currentArguments, universal_newlines=True, shell=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
		return (currentOut), currentProc.returncode
	else:
		if not currentArguments == ['-i']:
			currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
			currentProc = subprocess.Popen([current_ubiquitous_bash, '_bash'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
			currentOut = currentOut.rstrip('\n')
			if currentPrint == True:
				print(currentOut)
				return (currentOut), currentProc.returncode
		else:
			currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
			currentProc = subprocess.Popen([current_ubiquitous_bash, '_bash'] + currentArguments, universal_newlines=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
		return (currentOut), currentProc.returncode





import sys
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
#
#_bin(['/bin/bash', '-i'])
#_bin(['_getScriptAbsoluteLocation'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#_bin(['_getScriptAbsoluteLocation'], True)
#_bin(['echo', 'test'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#print(_bin(['_false'], False, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))[1])
#
#_bin('_true')
#_bin('_echo test')
#_bin('_bash')
#print( _bin('_false', False)[1] )
#_bin("_getScriptAbsoluteLocation", True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
def _bin(currentArguments = [''], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh"):
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
			current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
			current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
	if current_ubiquitous_bash == "ubiquitous_bash.sh":
		if os.path.exists("/cygdrive/c/core/infrastructure/lean/lean.sh"):
			current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/lean/lean.sh"
	currentArguments = [''] if currentArguments == '' else currentArguments
	if isinstance(currentArguments, str):
		# WARNING: Discouraged.
		if not ( ( currentArguments == '/bin/bash -i' ) or ( currentArguments == '/bin/bash' ) ):
			currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
			currentOut = currentOut.rstrip('\n')
			if currentPrint == True:
				print(currentOut)
				return (currentOut), currentProc.returncode
		else:
			currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, universal_newlines=True, shell=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
		return (currentOut), currentProc.returncode
	else:
		if not (  ( currentArguments == ['/bin/bash', '-i'] ) or ( currentArguments == ['/bin/bash'] ) or ( currentArguments == ['_qalculate', ''] ) or ( currentArguments == ['_qalculate'] ) or ( currentArguments == ['_octave', ''] ) or ( currentArguments == ['_octave'] )  ):
			currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
			currentProc = subprocess.Popen([current_ubiquitous_bash, '_bin'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
			currentOut = currentOut.rstrip('\n')
			if currentPrint == True:
				print(currentOut)
				return (currentOut), currentProc.returncode
		else:
			currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
			currentProc = subprocess.Popen([current_ubiquitous_bash, '_bin'] + currentArguments, universal_newlines=True)
			(currentOut, currentErr) = currentProc.communicate()
			currentProc.wait()
		return (currentOut), currentProc.returncode

# ATTENTION: Only intended for indirect calls.
# https://stackoverflow.com/questions/5067604/determine-function-name-from-within-that-function-without-using-traceback
#	'there aren't enough important use cases given'
# https://www.tutorialspoint.com/How-can-I-remove-the-ANSI-escape-sequences-from-a-string-in-python
# https://docs.python.org/3/library/re.html
#return _bin(currentCommand + currentArguments + currentString, currentPrint)[0]
#return re.sub(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]', '', _bin(currentCommand + currentArguments + currentString, currentPrint)[0])
def _bin_stringAfterArgs(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_false']):
	currentString = [currentString] if isinstance(currentString, str) else currentString
	currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
	if currentPrint:
		return _bin(currentCommand + currentArguments + currentString, currentPrint)
	else:
		return re.sub(r'\n', '', re.sub(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]', '', _bin(currentCommand + currentArguments + currentString, currentPrint)[0]))

#def _bash(currentArguments = [''], currentPrint = True, current_ubiquitous_bash = "ubiquitous_bash.sh"):
#	_bin(['/bin/bash', '-i'])



#if sys.hexversion < 0x03000000:
#	exit(1)
#_bin_alias = _bin


#_clc('1 + 2')
#_qalculate('1 + 2')
#_octave('1 + 2')
#print(_octave_solve('(y == x * 2, x)' ))

def _clc(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_clc']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def clc(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['clc']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def c(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['c']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _qalculate_solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _qalculate_nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate_nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave_solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave_nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave_nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)


def _qalculate(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)








import readline # optional, will allow Up/Down/History in the console
import code
#_python()
# https://stackoverflow.com/questions/5597836/embed-create-an-interactive-python-shell-inside-a-python-program
def _python():
	variables = globals().copy()
	variables.update(locals())
	shell = code.InteractiveConsole(variables)
	shell.interact()



import sys
import os
import socket
import string
import re
#if sys.hexversion < 0x03060000:
#	exit(1)
# https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za
# https://stackoverflow.com/questions/4271740/how-can-i-use-python-to-get-the-system-hostname
# https://bugs.python.org/issue20359
#os.environ['PWD']
#os.path.expanduser(os.getcwd())
#\033[0;35;47mpython-%d\033[0m
#return "\033[92mIn [%d]:\033[0m " % (self.line)
#return ">>> "
#return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|\033[1;96m%d\033[1;94m) \033[1;96m>\033[0m " % (os.environ['USER'], socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
#return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|%d\033[1;94m) \033[1;96m>\033[0m " % (os.environ['USER'], socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
class ubPythonPS1(object):
	def __init__(self):
		self.line = 0

	def __str__(self):
		self.line += 1
		if self.line == 1:
			return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.environ['USER'], socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
		else:
			return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.environ['USER'], socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)

sys.ps1 = ubPythonPS1()
sys.ps2 = "\x01\033[0;96m\x02|...\x01\033[0m\x02 "

#_python()

CZXWXcRMTo8EmM8i4d
}


_generate_lean-overrides-python_here() {
	cat << 'CZXWXcRMTo8EmM8i4d'

# WARNING: Strongly discouraged example.
# (strongly prefer to inherit a single os.environ['scriptAbsoluteFolder'] environment variable from being called by an 'ubiquitous_bash' script)
#exec(open(_getScriptAbsoluteFolder()+'/lean.py').read())











# ATTENTION: NOTICE: Environment variables from 'ubiquitous_bash' can be used to import other python scripts.
#exec(open(os.environ['scriptAbsoluteFolder']+'/lean.py').read())

#################################################
# ATTENTION: NOTICE: Add '_prog' script code here!

def _main():
	pass



# ATTENTION: NOTICE: Add '_prog' script code here!
#################################################


import sys
if sys.hexversion > 0x03000000:
	exec('_print = print')

import sys
import string
#./lean.py "_python(c('1 + 2'))" #FAIL
#python3 ./lean.py "_print(c('1 + 2'))"
#python2 ./lean.py "print(c('1 + 2'))"
#./lean.py "_print(c('1 + 2'))"
# https://www.tutorialspoint.com/python/python_command_line_arguments.htm
# https://www.programiz.com/python-programming/methods/built-in/exec
# https://www.geeksforgeeks.org/python-program-to-convert-a-list-to-string/
# https://www.geeksforgeeks.org/python-removing-first-element-of-list/
#print ( 'Argument List:', str(sys.argv) )
#eval( sys.argv[1] + ' ' + ' '.join( sys.argv[2:] ) )
#exec( sys.argv[1] )
#if (1 in sys.argv):
if len(sys.argv) > 1:
	if ( sys.argv[1].startswith('_') ) or ( sys.argv[1].startswith('print') ) :
		exec( sys.argv[1] )


_main()

CZXWXcRMTo8EmM8i4d
}




_generate_lean-python_prog() {
	[[ "$objectName" == "ubiquitous_bash" ]] && return 0
	
	return 1
}

_generate_lean-python() {
	! _generate_lean-python_prog && return 0
	
	echo '#!/usr/bin/env python3' > "$scriptAbsoluteFolder"/lean.py
	
	_generate_lean-lib-python_here "$@" >> "$scriptAbsoluteFolder"/lean.py
	
	_generate_lean-overrides-python_here "$@" >> "$scriptAbsoluteFolder"/lean.py
	
	chmod u+x "$scriptAbsoluteFolder"/lean.py
}






# 
# _python_hook_here() {
# 	cat << CZXWXcRMTo8EmM8i4d
# 	
# 	_setupUbiquitous_accessories_here-python_hook
# 	
# CZXWXcRMTo8EmM8i4d
# }
# 
# 
# _python_hook() {
# 	_messageNormal "init: _python_hook"
# 	local ubHome
# 	ubHome="$HOME"
# 	[[ "$1" != "" ]] && ubHome="$1"
# 	
# 	export ubcoreDir="$ubHome"/.ubcore
# 	
# 	_python_hook_here > "$ubcoreDir"/python_bash_rc
# }
# 
































_findUbiquitous() {
	export ubiquitousLibDir="$scriptAbsoluteFolder"
	export ubiquitiousLibDir="$ubiquitousLibDir"
	
	local scriptBasename=$(basename "$scriptAbsoluteFolder")
	if [[ "$scriptBasename" == "ubiquitous_bash" ]]
	then
		return 0
	fi
	
	if [[ -e "$ubiquitousLibDir"/_lib/ubiquitous_bash ]]
	then
		export ubiquitousLibDir="$ubiquitousLibDir"/_lib/ubiquitous_bash
		export ubiquitiousLibDir="$ubiquitousLibDir"
		return 0
	fi
	
	local ubiquitousLibDirDiscovery=$(find ./_lib -maxdepth 3 -type d -name 'ubiquitous_bash' | head -n 1)
	if [[ "$ubiquitousLibDirDiscovery" != "" ]] && [[ -e "$ubiquitousLibDirDiscovery" ]]
	then
		export ubiquitousLibDir="$ubiquitousLibDirDiscovery"
		export ubiquitiousLibDir="$ubiquitousLibDir"
		return 0
	fi
	
	return 1
}


_init_deps() {
	export enUb_set="true"
	
	export enUb_dev=""
	export enUb_dev_heavy=""
	
	export enUb_cloud_heavy=""
	
	export enUb_mount=""
	
	export enUb_machineinfo=""
	export enUb_git=""
	export enUb_bup=""
	export enUb_repo=""
	export enUb_search=""
	export enUb_cloud=""
	export enUb_cloud_self=""
	export enUb_cloud_build=""
	export enUb_notLean=""
	export enUb_distro=""
	export enUb_build=""
	export enUb_buildBash=""
	export enUb_os_x11=""
	export enUb_proxy=""
	export enUb_proxy_special=""
	export enUb_clog=""
	export enUb_x11=""
	export enUb_blockchain=""
	export enUb_java=""
	export enUb_image=""
	export enUb_disc=""
	export enUb_virt=""
	export enUb_virt_thick=""
	export enUb_virt_translation=""
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
	export enUb_enUb_peripherial=""
	
	export enUb_user=""
	
	export enUb_channel=""
	
	export enUb_metaengine=""
	
	export enUb_stopwatch=""
	
	export enUb_linux=""
	
	export enUb_python=""
	export enUb_haskell=""
	
	export enUb_calculators=""
}

_deps_dev() {
	export enUb_dev="true"
}

_deps_dev_heavy() {
	_deps_notLean
	export enUb_dev_heavy="true"
}

_deps_cloud_heavy() {
	_deps_notLean
	export enUb_cloud_heavy="true"
}

_deps_mount() {
	_deps_notLean
	export enUb_mount="true"
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

_deps_repo() {
	export enUb_repo="true"
}

_deps_search() {
	_deps_abstractfs
	
	_deps_git
	_deps_bup
	
	_deps_x11
	
	export enUb_search="true"
}

_deps_cloud() {
	_deps_repo
	_deps_proxy
	_deps_stopwatch
	
	_deps_fakehome
	
	export enUb_cloud="true"
}

_deps_cloud_self() {
	_deps_cloud
	export enUb_cloud_self="true"
}

_deps_cloud_build() {
	_deps_cloud
	export enUb_cloud_build="true"
}

_deps_notLean() {
	_deps_git
	_deps_bup
	_deps_repo
	export enUb_notLean="true"
}

_deps_distro() {
	export enUb_distro="true"
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

_deps_clog() {
	export enUb_clog="true"
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

_deps_java() {
	export enUb_java="true"
}

_deps_image() {
	_deps_notLean
	_deps_machineinfo
	
	# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
	# _deps_image
	# _deps_chroot
	# _deps_vbox
	# _deps_qemu
	export enUb_image="true"
}

_deps_disc() {
	export enUb_disc="true"
}

_deps_virt_thick() {
	_deps_distro
	_deps_build
	_deps_notLean
	_deps_image
	export enUb_virt_thick="true"
}

_deps_virt() {
	_deps_machineinfo
	
	# WARNING: Includes 'findInfrastructure_virt' which may be a dependency of multiple virtualization backends.
	# _deps_image
	# _deps_chroot
	# _deps_vbox
	# _deps_qemu
	# _deps_docker
	export enUb_virt="true"
}

# Specifically intended to support shortcuts using file parameter translation.
_deps_virt_translation() {
	export enUb_virt_translation="true"
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
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_notLean
	_deps_virt
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
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
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
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
	_deps_git
	_deps_bup
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

_deps_peripherial() {
	_deps_notLean
	_deps_hardware
	export enUb_peripherial="true"
}

_deps_user() {
	_deps_notLean
	export enUb_user="true"
}

_deps_channel() {
	export enUb_channel="true"
}

_deps_stopwatch() {
	export enUb_stopwatch="true"
}

# WARNING: Specifically refers to 'Linux', the kernel, and things specific to it, NOT any other UNIX like features.
# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
# ie. _test_linux must not require Linux-only binaries
_deps_linux() {
	export enUb_linux="true"
}

_deps_python() {
	export enUb_python="true"
}
_deps_haskell() {
	export enUb_haskell="true"
}

_deps_calculators() {
	export enUb_calculators="true"
}

#placeholder, define under "queue/build"
# _deps_queue() {
# 	# Message queue - 'broadcastPipe' , etc , underlying functions , '_read_page' , etc .
# 	export enUb_queue="true"
# 	
# 	# Packet - any noise-tolerant 'format' .
# 	# RESERVED variable name - synonymous with 'enUb_queue' .
# 	#export enUb_packet="true"
# 	
# 	# Portal - a 'filter program' to make arrangements between embedded devices of various unique identities and/or devices (eg. 'xAxis400stepsMM' . )
# 	# RESERVED variable name - synonymous with 'enUb_queue' .
# 	#export enUb_portal="true"
# }

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
	
	_compile_bash_overrides_disable
	_compile_bash_overrides
	
	_includeScripts "${includeScriptList[@]}"
	
	#Default command.
	echo >> "$progScript"
	echo '_generate_lean-python "$@"' >> "$progScript"
	
	echo >> "$progScript"
	echo '_generate_compile_bash "$@"' >> "$progScript"
	
	echo 'exit 0' >> "$progScript"
	
	chmod u+x "$progScript"
	
	
	_tryExecFull _ub_cksum_special_derivativeScripts_write "$progScript"
	
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
	#[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash core core_monolithic.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash monolithic monolithic.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash ubcore ubcore.sh
	
	[[ "$1" != "" ]] && "$scriptAbsoluteFolder"/compile.sh _compile_bash "$@"
	
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure lean
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure ubcore
	#[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure core_monolithic
	#rm -f "$scriptAbsoluteFolder"/core_monolithic.sh
	##mv "$scriptAbsoluteFolder"/core_monolithic_compressed.sh "$scriptAbsoluteFolder"/core_compressed.sh
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure monolithic
	rm -f "$scriptAbsoluteFolder"/monolithic.sh
	#mv "$scriptAbsoluteFolder"/monolithic_compressed.sh "$scriptAbsoluteFolder"/compressed.sh
	
	
	[[ "$objectName" == "ubiquitous_bash" ]] && _generate_compile_bash-compressed_procedure ubiquitous_bash
	
	
	_generate_compile_bash_prog
	
	# DANGER Do NOT remove.
	exit 0
}

# #No production use. Unmaintained, obsolete. Never used literally. Preserved as an example command set to build the otherwise self-hosted generate/compile script manually (ie. bootstrapping).
# _bootstrap_bash_basic() {
# 	cat "generic"/minimalheader.sh "labels"/utilitiesLabel.sh "generic/filesystem"/absolutepaths.sh "generic/filesystem"/safedelete.sh "generic/process"/timeout.sh "generic"/uid.sh "generic/filesystem/permissions"/checkpermissions.sh "build/bash"/include.sh "structure"/globalvars.sh "build/bash/ubiquitous"/discoverubiquitous.sh "build/bash/ubiquitous"/depsubiquitous.sh "build/bash"/generate.sh "build/bash"/compile.sh "structure"/overrides.sh > ./compile.sh
# 	echo >> ./compile.sh
# 	echo _generate_compile_bash >> ./compile.sh
# 	chmod u+x ./compile.sh
# }






_generate_compile_bash-compressed_procedure() {
	# If a "base85"/"ascii85" implementation were widely available at all possibly relevant 'environments', then compressed scripts could possibly be ~5% smaller.
	# WARNING: Do NOT attempt 'yEnc', apparently NOT 'utf8' text editor compatible.
	# https://en.wikipedia.org/wiki/Ascii85
	# https://en.wikipedia.org/wiki/Binary-to-text_encoding
	# https://sites.google.com/site/dannychouinard/Home/unix-linux-trinkets/little-utilities/base64-and-base85-encoding-awk-scripts
	#  'if you plan on running these on Solaris, use the /usr/xpg4/bin versions of awk'
	#  https://sites.google.com/site/dannychouinard/Home
	#   'Everything is open source, either public domain or GPL V2.'
	#  Experiments may have found input character corruption apparently with few but significant binary symbols.
	# https://metacpan.org/pod/Math::Base85
	# https://stackoverflow.com/questions/51821351/how-do-i-use-m-flag-to-load-a-perl-module-using-its-relative-path-from-command
	#uudeview
	#local current_textBinaryEncoder
	#current_textBinaryEncoder=""
	#current_textBinaryEncoder="$2"
	#sed -i 'N;s/\n//'
	
	echo "#!/usr/bin/env bash" > "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	_compressed_criticalDep() {
		! _getAbsolute_criticalDep && exit 1
		
		! type -p sed > /dev/null 2>&1 && exit 1
		! type -p head > /dev/null 2>&1 && exit 1
		! type -p awk > /dev/null 2>&1 && exit 1
		! type -p grep > /dev/null 2>&1 && exit 1
		! type -p ls > /dev/null 2>&1 && exit 1
		! type -p base64 > /dev/null 2>&1 && exit 1
		
		! type -p xz > /dev/null 2>&1 && exit 1
		
		! type -p fold > /dev/null 2>&1 && exit 1
		
		#! type -p cksum > /dev/null 2>&1 && exit 1
		#! type -p env > /dev/null 2>&1 && exit 1
		
		return 0
	}
	
	_compress_declare_headerFunctions() {
	declare -f _realpath_L
	declare -f _realpath_L_s
	declare -f _cygwin_translation_rootFileParameter
	declare -f _getAbsolute_criticalDep
	declare -f _getScriptAbsoluteLocation
	declare -f _getScriptAbsoluteFolder
	declare -f _getAbsoluteLocation
	
	declare -f _compressed_criticalDep
	}
	
	
	#local current_internal_compressedScript_headerFunctions
	current_internal_compressedScript_headerFunctions=$(_compress_declare_headerFunctions | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	
	
	# Comment filter seems to greatly improve compressibility, possibly due to comments being much less compressible than code.
	# WARNING: Comment filter may incorrectly remove comments within here documents, as with '#!/bin/dash' from '_here_header_bash_or_dash()' . Interleaved code using different comment characters (eg. 'batch' files interpretable as 'bash', 'scriptedIllustrator', etc) will fail. Diagnostic/debugging/etc comments may also be removed.
	# https://unix.stackexchange.com/questions/157328/how-can-i-remove-all-comments-from-a-file
	#grep -o '^[^#]*'
	#sed '/^[[:blank:]]*#/d;s/#.*//''
	#shfmt -mn foo.sh
	# https://stackoverflow.com/questions/3349156/general-utility-to-remove-strip-all-comments-from-source-code-in-various-languag
	#cloc --strip-comments=small
	#--use-sloccount
	#grep -v '^'"[[:space:]]"'#'
	#grep -v '^#' | grep -v '^'"[[:space:]]"'#'
	#grep -v '^#[^!]' | grep -v '^'"[[:space:]]"'#[^!]'
	
	local current_internal_CompressedScript
	#current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/"$1".sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	current_internal_CompressedScript=$(cat "$scriptAbsoluteFolder"/"$1".sh | grep -v '^_main "$@"$' | sed 's/^_main "$@"$//' | grep -v '^#[^!]' | grep -v '^'"[[:space:]]"'#[^!]' | xz -z -e9 -C crc64 --threads=1 | base64 -w 156 | fold -w 156 -s)
	
	#local current_internal_CompressedScript_cksum
	current_internal_CompressedScript_cksum=$(echo "$current_internal_CompressedScript" | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9')
	#local current_internal_CompressedScript_bytes
	current_internal_CompressedScript_bytes=$(echo "$current_internal_CompressedScript" | wc -c | tr -dc '0-9')
	
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'export ub_setScriptChecksum_disable="true"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo 'current_internal_CompressedScript_bytes='\'"$current_internal_CompressedScript_bytes"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_CompressedScript_cksum='\'"$current_internal_CompressedScript_cksum"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_CompressedScript='\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo "$current_internal_CompressedScript"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'current_internal_compressedScript_headerFunctions='\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo "$current_internal_compressedScript_headerFunctions"\' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '! echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'source <(echo "$current_internal_compressedScript_headerFunctions" | base64 -d | xz -d)' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
export importScriptLocation=$(_getScriptAbsoluteLocation)
export importScriptFolder=$(_getScriptAbsoluteFolder)
! type readlink > /dev/null 2>&1 && exit 1;
! type dirname > /dev/null 2>&1 && exit 1;
! type basename > /dev/null 2>&1 && exit 1;
! readlink -f . > /dev/null 2>&1 && exit 1;
[[ "$importScriptLocation" == "" ]] && exit 1
[[ "$importScriptFolder" == "" ]] && exit 1
! _getAbsolute_criticalDep && exit 1
CZXWXcRMTo8EmM8i4d
	
	echo '! _compressed_criticalDep && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo '! echo "$current_internal_CompressedScript" | base64 -d | xz -d > /dev/null && exit 1' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --compressed "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --script' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --call' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	#echo 'source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --bypass "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
if [[ "$1" == "--embed" ]]
then
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
	internalFunctionExitStatus="$?"
	return "$internalFunctionExitStatus" > /dev/null 2>&1
	exit "$internalFunctionExitStatus"
elif [[ "$1" == "--profile" ]] || [[ "$1" == "--parent" ]]
then
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) "$@"
else
	source <(echo "$current_internal_CompressedScript" | base64 -d | xz -d) --compressed "$@"
	ub_import=
	ub_import_param=
	ub_import_script=
	ub_loginshell=
fi
if [[ "$ub_import" == "true" ]] && ! ( [[ "$ub_import_param" == "--bypass" ]] ) || [[ "$ub_import_param" == "--compressed" ]] || [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--profile" ]]
then
	return 0 > /dev/null 2>&1
	exit 0
fi
CZXWXcRMTo8EmM8i4d
	
	echo 'unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'export ub_setScriptChecksum_disable=' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo 'unset ub_setScriptChecksum_disable' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo 'true' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	echo '# https://github.com/mirage335/ubiquitous_bash' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '#_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript_uk4uPhB663kVcygT0q_compressedScript' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	unset current_internal_CompressedScript ; unset current_internal_CompressedScript_cksum ; unset current_internal_CompressedScript_bytes
	
	
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '#####Entry' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo '# ###' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	# TODO: ' ./ubiquitous_bash_compressed.sh _bin bash -i ' fails if '_main' is enabled
	# TODO: Maybe "$ub_import_param" is not set in this context?
	#echo '[[ "$1" == '"'"_"'"'* ]] && type "$1" > /dev/null 2>&1 && "$@"' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	# Disable dependency for 'gosu' binaries only if definitely necessary and if function is otherwise defined.
	#_test_Gosu() {
		#true
	#}
	cat << 'CZXWXcRMTo8EmM8i4d' >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
_test_prog() {
	true
}
_main() {
	#_start
	_start scriptLocal_mkdir_disable
	
	_collect
	
	_enter "$@"
	
	_stop
}
if [[ "$1" == '_test' ]]
then
	current_deleteScriptLocal="false"
	[[ ! -e "$scriptLocal" ]] && current_deleteScriptLocal="true"
	_stop_prog() {
		[[ "$current_deleteScriptLocal" == "true" ]] && rmdir "$scriptLocal" > /dev/null 2>&1
	}
fi
if [[ "$1" == '_'* ]] && type "$1" > /dev/null 2>&1
then
	"$@"
	internalFunctionExitStatus="$?"
	return "$internalFunctionExitStatus" > /dev/null 2>&1
	exit "$internalFunctionExitStatus"
fi
if [[ "$1" != '_'* ]]
then
	_main "$@"
fi
CZXWXcRMTo8EmM8i4d
	echo >> "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
	chmod u+x "$scriptAbsoluteFolder"/"$1"_compressed.sh
	
}

















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
	if [[ "$1" == "lean" ]]
	then
		#_deps_git
		
		#_deps_virt_translation
		
		#_deps_stopwatch
		
		_deps_queue
		
		return 0
	fi
	
	# Specifically intended to be imported into user profile.
	if [[ "$1" == "ubcore" ]]
	then
		_deps_notLean
		
		_deps_git
		_deps_bup
		
		_deps_repo
		
		_deps_search
		
		# WARNING: Only known production use in this context is '_cloud_reset' , '_cloud_unhook' , and similar.
		_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_abstractfs
		
		_deps_virt_translation
		
		_deps_stopwatch
		
		
		_deps_distro
		_deps_linux
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		#_deps_queue
		
		_deps_disc
		
		# _compile_bash_deps 'core'
		return 0
	fi
	
	if [[ "$1" == "cautossh" ]]
	then
		_deps_os_x11
		_deps_proxy
		_deps_proxy_special
		
		_deps_clog
		
		_deps_channel
		
		_deps_git
		_deps_bup
		
		_deps_repo
		
		# WARNING: Although 'cloud' may be relevant to 'cautossh', not included for now, to avoid remotely pulling client software.
		# ATTENTION: Override with 'ops.sh', 'core.sh', or similar.
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_command
		_deps_synergy
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		return 0
	fi
	
	if [[ "$1" == "processor" ]]
	then
		_deps_dev
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		_deps_queue
		_deps_metaengine
		
		return 0
	fi
	
	if [[ "$1" == "abstract" ]] || [[ "$1" == "abstractfs" ]]
	then
		_deps_dev
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_abstractfs
		
		return 0
	fi
	
	# Beware most uses of fakehome will benefit from full virtualization fallback.
	if [[ "$1" == "fakehome" ]]
	then
		_deps_dev
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_fakehome
		_deps_abstractfs
		
		return 0
	fi
	
	if [[ "$1" == "monolithic" ]]
	then
		_deps_dev_heavy
		_deps_dev
		
		#_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
		_deps_x11
		_deps_image
		
		_deps_virt
		#_deps_virt_thick
		
		#_deps_chroot
		_deps_qemu
		_deps_vbox
		#_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_distro
		
		#_deps_blockchain
		
		#_deps_command
		#_deps_synergy
		
		#_deps_hardware
		#_deps_x220t
		#_deps_peripherial
		
		#_deps_user
		
		#_deps_proxy
		#_deps_proxy_special
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		_deps_disc
		
		_deps_build
		
		#_deps_build_bash
		#_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	if [[ "$1" == "core" ]]
	then
		_deps_dev_heavy
		_deps_dev
		
		#_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
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
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_distro
		
		#_deps_blockchain
		
		#_deps_command
		#_deps_synergy
		
		#_deps_hardware
		#_deps_x220t
		#_deps_peripherial
		
		#_deps_user
		
		#_deps_proxy
		#_deps_proxy_special
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		_deps_disc
		
		_deps_build
		
		_deps_build_bash
		_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	if [[ "$1" == "" ]] || [[ "$1" == "ubiquitous_bash" ]] || [[ "$1" == "ubiquitous_bash.sh" ]] || [[ "$1" == "complete" ]]
	then
		_deps_dev_heavy
		_deps_dev
		
		_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
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
		
		_deps_python
		_deps_haskell
		
		_deps_calculators
		
		_deps_channel
		
		_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		_deps_cloud
		_deps_cloud_self
		_deps_cloud_build
		
		_deps_distro
		
		_deps_blockchain
		
		_deps_command
		_deps_synergy
		
		_deps_hardware
		_deps_x220t
		_deps_peripherial
		
		_deps_user
		
		_deps_proxy
		_deps_proxy_special
		
		_deps_clog
		
		_deps_stopwatch
		
		_deps_linux
		
		_deps_disc
		
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
	
	includeScriptList+=( "os/override"/override_cygwin.sh )
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
	includeScriptList+=( "generic/filesystem"/moveconfirm.sh )
	includeScriptList+=( "generic/filesystem"/allLogic.sh )
	includeScriptList+=( "generic/process"/timeout.sh )
	includeScriptList+=( "generic/process"/terminate.sh )
	includeScriptList+=( "generic"/condition.sh )
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
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/bindmountmanager.sh )
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/waitumount.sh )
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/mountchecks.sh )
	
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
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_vncserver_operations.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_vncviewer_operations.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_x11vnc_operations.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/here_proxyrouter.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/proxyrouter.sh )
	
	[[ "$enUb_clog" == "true" ]] && includeScriptList+=( "generic/net/clog"/clog.sh )
	
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
	
	[[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "instrumentation"/bashdb/bashdb.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_stopwatch" == "true" ]] ) && includeScriptList+=( "instrumentation"/profiling/stopwatch.sh )
}

# Specifically intended to support Eclipse as necessary for building existing software .
# Java is regarded as something similar to, but not, an unusual virtualization backend, due to its perhaps rare combination of portability, ongoing incompatible versions, lack of root or kernelspace requirements, typical operating system wide installation, and overall complexity.
# Multiple 'jre' and 'jdk' packages or script contained versions may be able to, or required, to satisfy related dependencies.
# WARNING: This is intended to provide for java *applications*, NOT necessarily browser java 'applets'.
# WARNING: Do NOT deprecate java versions for 'security' reasons - this is intended ONLY to support applications which already normally require user or root permissions.
_compile_bash_utilities_java() {
	[[ "$enUb_java" == "true" ]] && includeScriptList+=( "special/java"/java.sh )
#	[[ "$enUb_java" == "true" ]] && includeScriptList+=( "special/java"/javac.sh )
}

_compile_bash_utilities_python() {
	[[ "$enUb_python" == "true" ]] && includeScriptList+=( "build/python"/python.sh )
}
_compile_bash_utilities_haskell() {
	[[ "$enUb_haskell" == "true" ]] && includeScriptList+=( "build/haskell"/haskell.sh )
}

_compile_bash_utilities_virtualization() {
	export includeScriptList
	
	# ATTENTION: Although the only known requirement for gosu is virtualization, it may be necessary wherever sudo is not sufficient to drop privileges.
	[[ "$enUb_virt_thick" == "true" ]] && includeScriptList+=( "special/gosu"/gosu.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtenv.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/findInfrastructure_virt.sh )
	
	# Any script managing MSW from UNIX may need basic file parameter translation without needing complete remapping. Example: "_vncviewer_operations" .
	( [[ "$enUb_virt" == "true" ]] || [[ "$enUb_proxy" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] ) && includeScriptList+=( "virtualization"/osTranslation.sh )
	( [[ "$enUb_virt" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] ) && includeScriptList+=( "virtualization"/localPathTranslation.sh )
	
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs_appdir_specific.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs_appdir.sh )
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

# WARNING: Shortcuts must NOT cause _stop/exit failures in _test/_setup procedures!
_compile_bash_shortcuts() {
	export includeScriptList
	
	
	#####Shortcuts
	includeScriptList+=( "labels"/shortcutsLabel.sh )
	
	includeScriptList+=( "shortcuts/prompt"/visualPrompt.sh )
	
	#[[ "$enUb_dev_heavy" == "true" ]] && 
	includeScriptList+=( "shortcuts/dev"/devsearch.sh )
	
	
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/gnuoctave.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/gnuoctave_extra.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/qalculate.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/scriptedIllustrator_terminal.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devemacs.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devatom.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_java.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_env.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_bin_.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_app.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_example_export.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_example.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse.sh )
	
	includeScriptList+=( "shortcuts/dev/query"/devquery.sh )
	
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope.sh )
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope_here.sh )
	
	# WARNING: Some apps may have specific dependencies (eg. fakeHome, abstractfs, eclipse, atom).
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope_app.sh )
	
	( [[ "$enUb_repo" == "true" ]] && [[ "$enUb_git" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/git.sh )
	( [[ "$enUb_repo" == "true" ]] && [[ "$enUb_git" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/gitBare.sh )
	
	[[ "$enUb_bup" == "true" ]] && includeScriptList+=( "shortcuts/bup"/bup.sh )
	
	
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/repo/mktorrent"/mktorrent.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_image" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/repo/disk"/dd.sh )
	
	
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_search" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/search"/search.sh )
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_search" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/search/recoll"/recoll.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/screenScraper"/screenScraper-nix.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/screenScraper"/screenScraper-msw.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/ubVirt"/ubVirt_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/phpvirtualbox_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/virtualbox_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/libvirt_self.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/aws/aws.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/gcloud/gcloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/ibm/ibm.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/oracle/oracle.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/azure/azure.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service/vps"/digitalocean/digitalocean.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service/vps"/linode/linode.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/storage"/aws/aws_s3_compatible.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/storage"/blackblaze/blackblaze.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/apacheLibcloud/apacheLibcloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/nubo/nubo.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/rclone/rclone.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/paramiko/paramiko.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/terraform/terraform.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud"/cloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud"/cloud_abstraction.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/docker/docker_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/cloudNativeBuildpack/cloudNativeBuildpack_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/vagrant/vagrant_build.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/_custom/debian/debian_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/_custom/gentoo/gentoo_build.sh )
	
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/here_mkboot.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/mkboot.sh )
	
	[[ "$enUb_notLean" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro"/distro.sh )
	
	[[ "$enUb_QEMU" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/debian"/createDebian.sh )
	[[ "$enUb_image" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/raspbian"/createRaspbian.sh )
	
	[[ "$enUb_msw" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/msw"/msw.sh )
	
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
	( [[ "$enUb_image" == "true" ]] || [[ "$enUb_disc" == "true" ]] ) && includeScriptList+=( "shortcuts/image"/packetDrive.sh )
	
	( [[ "$enUb_image" == "true" ]] || [[ "$enUb_disc" == "true" ]] ) && includeScriptList+=( "shortcuts/image/disc"/pattern_recovery.sh )
	
	
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig_here.sh )
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig.sh )
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig_platform.sh )
	
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/bfq.sh )
}

_compile_bash_shortcuts_setup() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts"/setupUbiquitous_accessories_here.sh )
	includeScriptList+=( "shortcuts"/setupUbiquitous_accessories.sh )
	
	includeScriptList+=( "shortcuts"/setupUbiquitous_here.sh )
	includeScriptList+=( "shortcuts"/setupUbiquitous.sh )
}

_compile_bash_shortcuts_os() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts/os/unix/nice"/renice.sh )
	includeScriptList+=( "shortcuts/os/unix/systemd"/systemd_cleanup.sh )
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
	
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_peripherial" == "true" ]] && includeScriptList+=( "hardware/peripherial/h1060p"/h1060p.sh )
}

_compile_bash_vars_basic() {
	export includeScriptList
	
	
	#####Basic Variable Management
	includeScriptList+=( "labels"/basicvarLabel.sh )
}

_compile_bash_vars_global() {
	export includeScriptList
	
	includeScriptList+=( "structure"/resetvars.sh )
	
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
	includeScriptList+=( "_config"/netvars.sh )
}

_compile_bash_selfHost() {
	export includeScriptList
	
	
	#####Generate/Compile
	if ( [[ "$enUb_buildBashUbiquitous" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] || [[ "$enUb_calculators" == "true" ]] )
	then
		includeScriptList+=( "build/python"/python_lean_here.sh )
		includeScriptList+=( "build/python"/python_lean_here_prog.sh )
	fi
	
	
	includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitous.sh )
	#[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitous.sh )
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

_compile_bash_overrides_disable() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/overrides_disable.sh )
}

_compile_bash_entry() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/entry.sh )
}

_compile_bash_extension() {
	export includeScriptList
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "queue/__build"/deps_queue.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "queue/__build"/compile_queue.sh )
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/__build"/deps_meta.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/__build"/compile_meta.sh )
}

#placehoder, define under "queue/build"
#_compile_bash_queue() {
#	true
#}

#placeholder, define under "queue/build"
#_compile_bash_vars_queue() {
#	true
#}

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
	_compile_bash_utilities_java
	_compile_bash_utilities_python
	_compile_bash_utilities_haskell
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
	
	
	_tryExec _compile_bash_queue
	
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
	
	
	_tryExec _compile_bash_vars_queue
	
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
	
	
	_tryExecFull _ub_cksum_special_derivativeScripts_write "$progScript"
	
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

#####Overrides DISABLE

# DANGER: NEVER intended to be set in an end user shell for ANY reason.
# DANGER: Implemented to prevent 'compile.sh' from attempting to run functions from 'ops.sh'. No other valid use currently known or anticipated!
export ub_ops_disable='true'


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
	
	# DANGER: Mechanism of workaround 'ub_trapSet_stop_emergency' is not fully understood, and was added undesirably late in development, with unknown effects. Nevertheless, a need for such functionality is expected to be encountered only rarely.
	# At least '_closeChRoot' , '_userChRoot' , '_userVBox' do not seem to have lost functionality.
	# DANGER: Any shell command matching ' _timeout.*&$ ' (backgrounding of _timeout) will probably be unable to reach '_stop' correctly, and may not remove temporary directories, etc.
	if [[ "$ub_trapSet_stop_emergency" != 'true' ]]
	then
		trap 'excode=$?; _stop_emergency $excode; trap - EXIT; echo $excode' INT TERM	# reset
		trap 'excode=$?; trap "" EXIT; _stop_emergency $excode; echo $excode' INT TERM	# ignore
		export ub_trapSet_stop_emergency='true'
	fi
fi

# DANGER: NEVER intended to be set in an end user shell for ANY reason.
# DANGER: Implemented to prevent 'compile.sh' from attempting to run functions from 'ops.sh'. No other valid use currently known or anticipated!
if [[ "$ub_ops_disable" != 'true' ]]
then
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
fi

#Wrapper function to launch arbitrary commands within the ubiquitous_bash environment, including its PATH with scriptBin.
_bin() {
	"$@"
}
#Mostly intended to launch bash prompt for MSW/Cygwin users.
_bash() {
	local currentIsCygwin
	currentIsCygwin='false'
	[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && _if_cygwin && currentIsCygwin='true'
	
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	[[ "$currentIsCygwin" == 'true' ]] && echo -n '.'
	
	
	_visualPrompt
	[[ "$ub_scope_name" != "" ]] && _scopePrompt
	
	
	[[ "$1" == '-i' ]] && shift
	
	
	
	if [[ "$currentIsCygwin" == 'true' ]] && grep ubcore "$HOME"/.bashrc > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" == *"lean.sh" ]]
	then
		export sessionid=""
		export scriptAbsoluteFolder=""
		export scriptAbsoluteLocation=""
		bash -i "$@"
		return
	elif  [[ "$currentIsCygwin" == 'true' ]] && grep ubcore "$HOME"/.bashrc > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != *"lean.sh" ]]
	then
		bash -i "$@"
		return
	elif [[ "$currentIsCygwin" == 'true' ]] && ! grep ubcore "$HOME"/.bashrc > /dev/null 2>&1
	then
		bash --norc -i "$@"
		return
	else
		bash -i "$@"
		return
	fi
	
	bash -i "$@"
	return
	
	return 1
}

#Mostly if not entirely intended for end user convenience.
_python() {
	if [[ -e "$safeTmp"/lean.py ]]
	then
		"$safeTmp"/lean.py '_python()'
		return
	fi
	if [[ -e "$scriptAbsoluteFolder"/lean.py ]]
	then
		"$scriptAbsoluteFolder"/lean.py '_python()'
		return
	fi
	if type -p 'lean.py' > /dev/null 2>&1
	then
		lean.py '_python()'
		return
	fi
	return 1
}

#Launch internal functions as commands, and other commands, as root.
_sudo() {
	sudo -n "$scriptAbsoluteLocation" _bin "$@"
}

_true() {
	#"$scriptAbsoluteLocation" _false && return 1
	#! "$scriptAbsoluteLocation" _bin true && return 1
	#"$scriptAbsoluteLocation" _bin false && return 1
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
			if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--compressed" ]]
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
	# && [[ "$1" != "_test" ]] && [[ "$1" != "_setup" ]] && [[ "$1" != "_build" ]] && [[ "$1" != "_vector" ]] && [[ "$1" != "_setupCommand" ]] && [[ "$1" != "_setupCommand_meta" ]] && [[ "$1" != "_setupCommands" ]] && [[ "$1" != "_find_setupCommands" ]] && [[ "$1" != "_setup_anchor" ]] && [[ "$1" != "_anchor" ]] && [[ "$1" != "_package" ]] && [[ "$1" != *"_prog" ]] && [[ "$1" != "_main" ]] && [[ "$1" != "_collect" ]] && [[ "$1" != "_enter" ]] && [[ "$1" != "_launch" ]] && [[ "$1" != "_default" ]] && [[ "$1" != "_experiment" ]]
	if [[ "$1" == '_'* ]] && type "$1" > /dev/null 2>&1 && [[ "$1" != "_test" ]] && [[ "$1" != "_setup" ]] && [[ "$1" != "_build" ]] && [[ "$1" != "_vector" ]] && [[ "$1" != "_setupCommand" ]] && [[ "$1" != "_setupCommand_meta" ]] && [[ "$1" != "_setupCommands" ]] && [[ "$1" != "_find_setupCommands" ]] && [[ "$1" != "_setup_anchor" ]] && [[ "$1" != "_anchor" ]] && [[ "$1" != "_package" ]] && [[ "$1" != *"_prog" ]] && [[ "$1" != "_main" ]] && [[ "$1" != "_collect" ]] && [[ "$1" != "_enter" ]] && [[ "$1" != "_launch" ]] && [[ "$1" != "_default" ]] && [[ "$1" != "_experiment" ]]
	then
		"$@"
		internalFunctionExitStatus="$?"
		
		#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
		if [[ "$ub_import" != "true" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--compressed" ]]
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
# || [[ "$current_internal_CompressedScript" != "" ]] || [[ "$current_internal_CompressedScript_cksum" != "" ]] || [[ "$current_internal_CompressedScript_bytes" != "" ]]
if [[ "$ub_import" == "true" ]] && ! ( [[ "$ub_import_param" == "--bypass" ]] ) || [[ "$ub_import_param" == "--compressed" ]] || [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--profile" ]]
then
	return 0 > /dev/null 2>&1
	exit 0
fi



_generate_lean-python "$@"

_generate_compile_bash "$@"
exit 0
