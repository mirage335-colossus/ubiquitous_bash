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
( [[ -e "$0".nck ]] || [[ "${BASH_SOURCE[0]}" != "${0}" ]] || [[ "$1" == '--profile' ]] || [[ "$1" == '--script' ]] || [[ "$1" == '--call' ]] || [[ "$1" == '--return' ]] || [[ "$1" == '--devenv' ]] || [[ "$1" == '--shell' ]] || [[ "$1" == '--bypass' ]] || [[ "$1" == '--parent' ]] || [[ "$1" == '--embed' ]] || [[ "$0" == "/bin/bash" ]] || [[ "$0" == "-bash" ]] || [[ "$0" == "/usr/bin/bash" ]] || [[ "$0" == "bash" ]] ) && export ub_setScriptChecksum_disable='true'
export ub_setScriptChecksum_header='1891409836'
export ub_setScriptChecksum_contents='4146997442'

# CAUTION: Symlinks may cause problems. Disable this test for such cases if necessary.
# WARNING: Performance may be crucial here.
#[[ -e "$0" ]] && ! [[ -h "$0" ]] && [[ "$ub_setScriptChecksum" != "" ]]
if [[ -e "$0" ]] && [[ "$ub_setScriptChecksum_header" != "" ]] && [[ "$ub_setScriptChecksum_contents" != "" ]] && [[ "$ub_setScriptChecksum_disable" != 'true' ]]
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

ub_import=
ub_import_param=
ub_import_script=
ub_loginshell=

# ATTENTION: Apparently (Portable) Cygwin Bash interprets correctly.
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
	sudo journalctl --rotate
	sudo journalctl --vacuum-time=1s
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


# https://stackoverflow.com/questions/4090301/root-user-sudo-equivalent-in-cygwin
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
	
	
	_safeEcho_newline "$@" >> "$safeTmp"/cygwin_sudo_temp.sh
	

	# 'Do it as Administrator.'
	#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat bash
	cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
	
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
		
		# export ubiquitiousBashID=uk4uPhB663kVcygT0q
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
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin "$@"
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
	
	find "$2" -type l -exec "$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_procedure {} \;
	
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
	uname -a | grep -i cygwin > /dev/null 2>&1 && currentScriptLocation=$(_cygwin_translation_rootFileParameter)
	
	
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

#Generates random alphanumeric characters, default length 18.
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
		chars=abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
		#for currentIteration in {1..$currentLengthUID} ; do
		for (( currentIteration=1; currentIteration<="$currentLengthUID"; currentIteration++ )) ; do
		echo -n "${chars:RANDOM%${#chars}:1}"
		done
		echo
	else
		cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c "$currentLengthUID" 2> /dev/null
	fi
	return 0
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
	return 0
}

_messageWARN() {
	echo
	echo "$@"
	return 0
}

# Demarcate *any* delay performed to allow 'InterProcess-Communication' connections (perhaps including at least some network or serial port servers).
_messageDELAYipc() {
	echo -e '\E[1;33;47m ''delay: InterProcess-Communication'' \E[0m'
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
	
	#Cipher aes256-gcm@openssh.com
	#Ciphers aes256-gcm@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc,aes192-cbc,aes256-cbc,arcfour

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
	
	! _wantDep scp && echo 'warn: no scp'
	
	! _wantDep sshfs && echo 'warn: sshfs not found'
	
	! _wantDep base64 && echo 'warn: no base64'
	
	! _wantDep vncviewer && echo 'warn: no vncviewer, recommend tigervnc'
	! _wantDep vncserver && echo 'warn: no vncserver, recommend tigervnc'
	! _wantDep Xvnc && echo 'warn: no Xvnc, recommend tigervnc'
	
	! _wantDep x11vnc && echo 'warn: x11vnc not found'
	! _wantDep x0tigervncserver && echo 'warn: x0tigervncserver not found'
	
	! _wantDep vncpasswd && echo 'warn: vncpasswd not found, x11vnc broken!'
	! _wantDep xset && echo 'warn: xset not found, vnc broken!'
	
	#! _wantDep pv && echo 'warn: pv not found, ssh benchmark broken'
	#! _wantDep time && echo 'warn: time not found, ssh benchmark broken'
	
	! _wantDep curl && echo 'warn: missing: curl - public ip detection broken'
	! _wantDep iperf3 && echo 'warn: missing: iperf3 - throughput benchmark broken'
	
	#! _wantDep dash && echo 'warn: dash not found, latency benchmark inflated'
	
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
	local remoteHostDestination
	remoteHostDestination="$3"
	[[ "$remoteHostDestination" == "" ]] && remoteHostDestination="localhost"
	
	#local localPort
	#localPort=$(_findPort)
	
	#_timeout "$netTimeout" _ssh -f "$1" -L "$localPort":"$remoteHostDestination":"$2" -N > /dev/null 2>&1
	#sleep 2
	#nmap --host-timeout "$netTimeout" -Pn localhost -p "$localPort" -sV 2> /dev/null | grep 'ssh' > /dev/null 2>&1 && return 0
	
	mkdir -p "$safeTmp"
	echo | _timeout "$netTimeout" _ssh -q -W "$remoteHostDestination":"$2" "$1" | head -c 3 2> /dev/null > "$safeTmp"/_checkRemoteSSH_header &
	
	local currentIteration
	
	for currentIteration in `seq 1 "$netTimeout"`;
	do
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
		sleep 0.3
		grep 'SSH' "$safeTmp"/_checkRemoteSSH_header > /dev/null 2>&1 && return 0
	done
	
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
	
	#Checking for remote port is necessary, as the SSH command hangs indefinitely if a zombie tunnel is present (usually avoidable but highly detremential failure mode).
	if _checkRemoteSSH "$1" "$2" "$remoteHostDestination"
	then
		if _ssh -q -W "$remoteHostDestination":"$2" "$1"
		then
			_stop
		fi
	fi
	
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
	
	
	local currentBin_ssh
	currentBin_ssh="$ub_function_override_ssh"
	[[ "$currentBin_ssh" == "" ]] && currentBin_ssh=$(type -p ssh 2> /dev/null)
	
	
	if "$currentBin_ssh" -F "$sshDir"/config "$@"
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
	local currentEchoStatus
	currentEchoStatus=$(stty --file=/dev/tty -g 2>/dev/null)
	
	if [[ "$sshInContainment" == "true" ]]
	then
		if _ssh_command "$@"
		then
			stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
			return 0
		fi
		stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
		return 1
	fi
	
	export sshInContainment="true"
	
	local sshExitStatus
	"$scriptAbsoluteLocation" _ssh_sequence "$@"
	sshExitStatus="$?"
	
	export sshInContainment=""
	
	stty --file=/dev/tty "$currentEchoStatus" 2> /dev/null
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
	#rsync -e "$scriptAbsoluteLocation"" _ssh" "$@"
	#-e "$scriptAbsoluteLocation"" _ssh -T -c aes256-gcm@openssh.com -o Compression=no -x"
	rsync --block-size=64000 --checksum-choice="md5" --skip-compress='7z/ace/avi/bz2/deb/gpg/gz/iso/jpeg/jpg/lz/lsma/lzo/mov/mp[34]/ogg/png/rar/rpm/rzip/tbz/tgz/tlz/txz/xz/z/zip'/img/vdi/ima/bloom/midx/idx/pack -e "$scriptAbsoluteLocation"" _ssh -T -o Compression=no -x" "$@"
}

_grsync_procedure() {
	export ub_function_override_ssh=$(type -p ssh 2> /dev/null)
	ssh() {
		_ssh "$@"
	}
	export ssh
	
	grsync "$@"
	
	export ub_function_override_ssh=''
	unset ssh
}

_grsync() {
	_editFakeHome "$scriptAbsoluteLocation" _grsync_procedure "$@"
}

_scp_command() {
	! _ssh_criticalDep && return 1
	scp -F "$sshDir"/config "$@"
}

_scp_sequence() {
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	local sshExitStatus
	_scp_command "$@"
	sshExitStatus="$?"
	
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
	
	_setup_ssh_merge_known_hosts
	
	_stop "$sshExitStatus"
}

_scp() {
	"$scriptAbsoluteLocation" _scp_sequence "$@"
}

_ssh_internal_command() {
	_ssh -C -o ConnectionAttempts=3 "$@"
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
	_ssh_internal_command "$@" '
rm '"$safeTmpSSH"'/cautossh
rmdir '"$safeTmpSSH"'/_local > /dev/null 2>&1
rmdir '"$safeTmpSSH"'
'
	#Preventative workaround, not normally necessary.
	stty echo > /dev/null 2>&1
}

# WARNING: Intermittent unreliability due to unlikely port collision rate.
_get_ssh_external() {
	export remotePublicIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_public_ipv4 | tr -dc 'a-zA-Z0-9.:')
	export remotePublicIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_public_ipv6 | tr -dc 'a-zA-Z0-9.:')
	
	export remoteRouteIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_route_ipv4 | tr -dc 'a-zA-Z0-9.:')
	export remoteRouteIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _find_route_ipv6 | tr -dc 'a-zA-Z0-9.:')
	
	# Common practice to use separate ports for dynamic IPv4 and IPv6 services, due to some applications not supporting both simultaneously.
	export remotePortPublicIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	export remotePortPublicIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	
	export remotePortRouteIPv4=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
	export remotePortRouteIPv6=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort 35500 49075 | tr -dc 'a-zA-Z0-9.:')
}

# WARNING: Intermittent unreliability due to significant port collision rate.
_get_ssh_relay() {
	export relayPortIn=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort | tr -dc 'a-zA-Z0-9.:')
	export relayPortOut=$(_ssh_internal_command "$@" "$safeTmpSSH"'/cautossh' _findPort | tr -dc 'a-zA-Z0-9.:')
}

_prepare_ssh_fifo() {
	mkfifo "$safeTmp"/up
	mkfifo "$safeTmp"/down
	mkfifo "$safeTmp"/control
	mkfifo "$safeTmp"/back
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
	cat "$vncPasswdFile".pln | _vnc_ssh -L "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' x11vnc_clip='"$x11vnc_clip"' x11vnc_scale='"$x11vnc_scale"' x11vnc_scale_cursor='"$x11vnc_scale_cursor"' '"$safeTmpSSH"/cautossh' _x11vnc' &
	
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
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
	
	
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
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' x11vnc_clip='"$x11vnc_clip"' x11vnc_scale='"$x11vnc_scale"' x11vnc_scale_cursor='"$x11vnc_scale_cursor"' '"$scriptAbsoluteLocation"' _x11vnc' &
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
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 3
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
	sleep 9
	if ! _checkPort localhost "$vncPort"
	then
		stty echo > /dev/null 2>&1
		_stop_safeTmp_ssh "$@"
		_stop
	fi
	_messageNormal '_push_vnc_sequence: Ready: sleep, _checkPort. Launch: _vncviewer'
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
	
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
	
	cat "$vncPasswdFile".pln | bash -c 'env vncPort='"$vncPort"' destination_DISPLAY='"$DISPLAY"' destination_AUTH='"$XAUTHORITY"' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$scriptAbsoluteLocation"' _vncviewer'
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
	
	cat "$vncPasswdFile".pln | _vnc_ssh -R "$vncPort":localhost:"$vncPort" "$@" 'env vncPort='"$vncPort"' destination_DISPLAY='""' vncviewer_startFull='"$vncviewer_startFull"' vncviewer_manual='"$vncviewer_manual"' '"$safeTmpSSH"/cautossh' _vncviewer'
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
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/id_rsa.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id=_ssh_copy_id

#Builtin version of ssh-copy-id.
_ssh_copy_id_gateway() {
	_start
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/rev_gate.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id-gateway=_ssh_copy_id_gateway

#Builtin version of ssh-copy-id.
_ssh_copy_id_command() {
	_start
	
	#"$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh'
	cat "$scriptLocal"/ssh/rev_command.pub | "$scriptAbsoluteLocation" _ssh "$@" 'mkdir -p "$HOME"/.ssh < /dev/null ; cat - >> "$HOME"/.ssh/authorized_keys'
	
	_stop
}
alias _ssh-copy-id-command=_ssh_copy_id_command

#"$1" == "key_name"
#"$2" == "local_subdirectory" (optional)
_setup_ssh_copyKey() {
	local sshKeyName
	local sshKeyLocalSubdirectory
	
	sshKeyName="$1"
	[[ "$2" != "" ]] && sshKeyLocalSubdirectory="$2"/
	
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
		return 0
	fi
	
	if [[ -e "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" ]]
	then
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName"
		chmod 600 "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub > /dev/null 2>&1
		
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName" "$sshLocalSSH"/"$sshKeyName"
		cp -n "$scriptLocal"/ssh/"$sshKeyLocalSubdirectory""$sshKeyName".pub "$sshLocalSSH"/"$sshKeyName".pub > /dev/null 2>&1
		
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

_setup_ssh_rmKey() {
	rm -f "$scriptLocal"/ssh/"$1" >/dev/null 2>&1
	rm -f "$scriptLocal"/ssh/"$1".pub >/dev/null 2>&1
	rm -f "$sshDir"/"$1" >/dev/null 2>&1
	rm -f "$sshDir"/"$1".pub >/dev/null 2>&1
	rm -f "$sshLocalSSH"/"$1" >/dev/null 2>&1
	rm -f "$sshLocalSSH"/"$1".pub >/dev/null 2>&1
}

_setup_ssh_operations() {
	# "_setup_local" .
	[[ "$ub_setup_local" == 'true' ]] && export sshBase="$safeTmp"/.ssh
	
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
		_setup_ssh_rmKey id_rsa
		_setup_ssh_rmKey rev_gate
		_setup_ssh_rmKey rev_cmd
	fi
	
	if ! [[ -e "$scriptLocal"/ssh/id_rsa ]] && ! [[ -e "$sshLocalSSH"/id_rsa ]] && ! [[ -e "$scriptLocal"/ssh/id_rsa.pub ]] && ! [[ -e "$sshLocalSSH"/id_rsa.pub ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/id_rsa -C cautossh@"$netName"
	fi
	
	#Less privileged key used by asset machines to establish persistent reverse tunnels ending at a gateway server.
	if ! [[ -e "$scriptLocal"/ssh/rev_gate ]] && ! [[ -e "$sshLocalSSH"/rev_gate ]] && ! [[ -e "$scriptLocal"/ssh/rev_gate.pub ]] && ! [[ -e "$sshLocalSSH"/rev_gate.pub ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/rev_gate -C cautossh@"$netName"
	fi
	
	#Less privileged key used by random machines to establish temporary reverse tunnels ending at a command machine.
	if ! [[ -e "$scriptLocal"/ssh/rev_cmd ]] && ! [[ -e "$sshLocalSSH"/rev_cmd ]] && ! [[ -e "$scriptLocal"/ssh/rev_cmd.pub ]] && ! [[ -e "$sshLocalSSH"/rev_cmd.pub ]]
	then
		ssh-keygen -b 4096 -t rsa -N "" -f "$scriptLocal"/ssh/rev_cmd -C cautossh@"$netName"
	fi
	
	_here_ssh_config >> "$safeTmp"/config
	_cpDiff "$safeTmp"/config "$sshDir"/config
	
	_setup_ssh_copyKey id_rsa
	_setup_ssh_copyKey rev_gate
	_setup_ssh_copyKey rev_cmd
	
	_setup_ssh_merge_known_hosts
	
	_cpDiff "$scriptAbsoluteLocation" "$sshDir"/cautossh
	
	# TODO Replace with a less oversimplified destination directory structure.
	#Concatenates all "ops" directives into one file to allow a single "cpDiff" operation.
	[[ -e "$objectDir"/ops ]] && cat "$objectDir"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ops ]] && cat "$scriptLocal"/ops >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/ops ]] && cat "$scriptLocal"/ssh/ops >> "$safeTmp"/opsAll
	[[ -e "$objectDir"/ops.sh ]] && cat "$objectDir"/ops.sh >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ops.sh ]] && cat "$scriptLocal"/ops.sh >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/ops.sh ]] && cat "$scriptLocal"/ssh/ops.sh >> "$safeTmp"/opsAll
	
	[[ -e "$objectDir"/opsauto ]] && cat "$objectDir"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/opsauto ]] && cat "$scriptLocal"/opsauto >> "$safeTmp"/opsAll
	[[ -e "$scriptLocal"/ssh/opsauto ]] && cat "$scriptLocal"/ssh/opsauto >> "$safeTmp"/opsAll
	
	
	_cpDiff "$safeTmp"/opsAll "$sshLocalSSH"/ops > /dev/null 2>&1
	
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
	_find_setupCommands -name '_ssh' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_rsync' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_sshfs' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_web' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_backup' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_fs' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_vnc' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_push_vnc' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_desktop' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	_find_setupCommands -name '_push_desktop' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_wake' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_meta' -exec "$scriptAbsoluteLocation" _setupCommand_meta '{}' \;
}

_package_cautossh() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	cd "$scriptAbsoluteFolder"
	
	
	#cp -a "$scriptAbsoluteFolder"/_index "$safeTmp"/package
	
	#https://stackoverflow.com/questions/4585929/how-to-use-cp-command-to-exclude-a-specific-directory
	#find ./_index -type f -not -path '*_arc*' -exec cp -d --preserve=all '{}' "$safeTmp"'/package/''{}' \;
	
	mkdir -p ./_local
	rsync -av --progress --exclude "_arc" ./_index/ "$safeTmp"/package/_index/
	
	mkdir -p ./_local
	cp -a ./_local/ssh "$safeTmp"/package/_local/
	cp -a ./_local/tor "$safeTmp"/package/_local/
	
	
	cd "$localFunctionEntryPWD"
}

#May be overridden by "ops" if multiple gateways are required.
# ATTENTION: An "ops.sh" file will almost always include simpler directives, specifically uncommented unconditional "_torServer_SSH" and "_autossh" commands.
_ssh_autoreverse() {
	true
	local currentExitStatus
	currentExitStatus='1'
	
	#_torServer_SSH
	
	#_autossh
	
	# ATTENTION: Supports multiple jump hosts if desired.
	#_autossh firstGateway
	#_autossh secondGateway
	
	
	# Conditional fallback. Only appropriate if directive from "ops.sh" is unavialable.
	
	[[ -e "$scriptLocal"/tor/sshd/"${matchingReversePorts[0]}" ]] && currentExitStatus='0' && _torServer_SSH
	#[[ $? == '0' ]] && currentExitStatus='0'
	
	if [[ -e "$objectDir"/ops ]] || [[ -e "$objectDir"/ops.sh ]] || [[ -e "$scriptLocal"/ops ]] || [[ -e "$scriptLocal"/ops.sh ]] || [[ -e "$scriptLocal"/ssh/ops ]] || [[ -e "$scriptLocal"/ssh/ops.sh ]]
	then
		currentExitStatus='0'
		_autossh
	fi
	#[[ $? == '0' ]] && currentExitStatus='0'
	
	return "$currentExitStatus"
}

_ssh_external_procedure() {
	echo
	_messagePlain_probe_var remotePublicIPv4
	_messagePlain_probe_var remotePublicIPv6
	echo
	_messagePlain_probe_var remoteRouteIPv4
	_messagePlain_probe_var remoteRouteIPv6
	echo
}

_ssh_external_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_messagePlain_nominal 'report: IP Address'
	_ssh_external_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_external() {
	_ssh_external_sequence "$@"
}

_ssh_public_ipv4() {
	_start
	_start_safeTmp_ssh "$@"
	_get_ssh_external "$@"
	
	echo "$remotePublicIPv4"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_public_ipv6() {
	_start
	_start_safeTmp_ssh "$@"
	_get_ssh_external "$@"
	
	echo "$remotePublicIPv6"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_route_ipv4() {
	_start
	_start_safeTmp_ssh "$@"
	_get_ssh_external "$@"
	
	echo "$remoteRouteIPv4"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_route_ipv6() {
	_start
	_start_safeTmp_ssh "$@"
	_get_ssh_external "$@"
	
	echo "$remoteRouteIPv6"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

# WARNING: Allows self to login as self to local SSH server with own SSH key.
# WARNING: Requires local SSH server listening on port 22.
#https://blog.famzah.net/2015/06/26/openssh-ciphers-performance-benchmark-update-2015/
_ssh_cipher_benchmark_local_sequence() {
	_start
	
	local localSSHpubKeySample
	localSSHpubKeySample=$(tail -c +9 "$HOME"/.ssh/id_rsa.pub | head -c 36 | tr -dc 'a-zA-Z0-9')
	
	mkdir -p "$HOME"/.ssh
	[[ ! -e "$HOME"/.ssh/id_rsa ]] && [[ ! -e "$HOME"/.ssh/id_rsa.pub ]] && ssh-keygen -b 4096 -t rsa -N "" -f "$HOME"/.ssh/id_rsa
	
	[[ ! -e "$HOME"/.ssh/authorized_keys ]] && echo >> "$HOME"/.ssh/authorized_keys
	
	! grep "$localSSHpubKeySample" "$HOME"/.ssh/authorized_keys > /dev/null 2>&1 && cat "$HOME"/.ssh/id_rsa.pub >> "$HOME"/.ssh/authorized_keys
	
	[[ ! -e "$HOME"/.ssh/id_rsa ]] && _messagePlain_bad 'fail: missing: ssh key private' && _stop 1
	[[ ! -e "$HOME"/.ssh/id_rsa.pub ]] && _messagePlain_bad 'fail: missing: ssh key public' && _stop 1
	[[ ! -e "$HOME"/.ssh/authorized_keys ]] && _messagePlain_bad 'fail: missing: ssh authorized_keys' && _stop 1
	
	_messagePlain_nominal '_ssh_cipher_benchmark: fill'
	dd if=/dev/urandom bs=1M count=512 | base64 > "$safeTmp"/fill
	[[ ! -e "$safeTmp"/fill ]] && _messagePlain_bad 'fail: missing: fill' && _stop 1
	
	_messagePlain_nominal '_ssh_cipher_benchmark: benchmark'
	# uses "$safeTmp"/dd.txt as a temporary file
	#for cipher in aes128-cbc aes128-ctr aes128-gcm@openssh.com aes192-cbc aes192-ctr aes256-cbc aes256-ctr aes256-gcm@openssh.com arcfour arcfour128 arcfour256 blowfish-cbc cast128-cbc chacha20-poly1305@openssh.com 3des-cbc
	for cipher in aes128-ctr aes128-gcm@openssh.com aes192-ctr aes256-ctr aes256-gcm@openssh.com chacha20-poly1305@openssh.com
	do
		for i in 1 2 3
		do
			_messagePlain_probe "Cipher: $cipher (try $i)"
			
			#dd if="$safeTmp"/fill bs=4M count=512 2>"$safeTmp"/dd.txt | pv --size 2G | time -p ssh -c "$cipher" "$USER"@localhost 'cat > /dev/null'
			dd if="$safeTmp"/fill bs=4M 2>/dev/null | ssh -c "$cipher" "$USER"@localhost 'dd of=/dev/null' 2>&1 | grep -v records
			#grep -v records "$safeTmp"/dd.txt
		done
	done
	
	
	_stop
}

_ssh_cipher_benchmark_remote_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_ssh "$@" "$safeTmpSSH"'/cautossh _ssh_cipher_benchmark_local_sequence'
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_cipher_benchmark_local() {
	"$scriptAbsoluteLocation" _ssh_cipher_benchmark_local_sequence "$@"
}

_ssh_cipher_benchmark_remote() {
	"$scriptAbsoluteLocation" _ssh_cipher_benchmark_remote_sequence "$@"
}

_ssh_cipher_benchmark() {
	_ssh_cipher_benchmark_remote "$@"
}

_ssh_iperf_procedure() {
	_messagePlain_nominal 'iperf: A'
	local currentPort_iperf_up=$(_findPort)
	_messageCMD _ssh -o 'Compression=no' -L "$currentPort_iperf_up":localhost:"$currentPort_iperf_up" "$@" "$safeTmpSSH"/cautossh' '_ssh_benchmark_iperf_server' '"$currentPort_iperf_up" &
	sleep 5
	#_waitPort localhost "$currentPort_iperf_up"
	iperf3 -c "localhost" -p "$currentPort_iperf_up"
	
	_messagePlain_nominal 'iperf: B'
	local currentPort_iperf_down=$(_findPort)
	_ssh_benchmark_iperf_server "$currentPort_iperf_down" &
	sleep 5
	#_waitPort localhost "$currentPort_iperf_down"
	_messageCMD _ssh -o 'Compression=no' -R "$currentPort_iperf_down":localhost:"$currentPort_iperf_down" "$@" 'iperf3 -c localhost -p '"$currentPort_iperf_down"
}

_ssh_emit_procedure() {
	_messagePlain_nominal 'emit: upload'
	
	_messagePlain_probe '1k'
	dd if=/dev/urandom bs=1k count=1 2>/dev/null | base64 > "$safeTmp"/fill_001k
	dd if="$safeTmp"/fill_001k bs=512 2>/dev/null | _timeout 5 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	_messagePlain_probe '10k'
	dd if=/dev/urandom bs=1k count=10 2>/dev/null | base64 > "$safeTmp"/fill_010k
	dd if="$safeTmp"/fill_010k bs=1k 2>/dev/null | _timeout 5 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	_messagePlain_probe '1M'
	dd if=/dev/urandom bs=1M count=1 2>/dev/null | base64 > "$safeTmp"/fill_001M
	dd if="$safeTmp"/fill_001M bs=4096 2>/dev/null | _timeout 10 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	_messagePlain_probe '10M'
	dd if=/dev/urandom bs=1M count=10 2>/dev/null | base64 > "$safeTmp"/fill_010M
	dd if="$safeTmp"/fill_010M bs=4096 2>/dev/null | _timeout 30 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	_messagePlain_probe '100M'
	dd if=/dev/urandom bs=1M count=100 2>/dev/null | base64 > "$safeTmp"/fill_100M
	dd if="$safeTmp"/fill_100M bs=4096 2>/dev/null | _timeout 45 _ssh "$@" 'dd of=/dev/null' 2>&1 | grep -v records
	
	# WARNING: Less reliable test, non-link bottlenecks.
	_messagePlain_nominal 'emit: download'
	
	# https://superuser.com/questions/792427/creating-a-large-file-of-random-bytes-quickly
	#dd if=<(openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero) bs=1M count=100 iflag=fullblock
	
	_timeout 45 _ssh "$@" 'dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count=15 iflag=fullblock 2>/dev/null' | dd bs=1M of=/dev/null | grep -v records
}

_ssh_benchmark_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	#_messagePlain_nominal 'get: external'
	#_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	#_ssh_external_procedure "$@"
	#_messagePlain_nominal 'report: IP Address'
	
	_ssh_cycle "$@"
	
	_ssh_latency_procedure "$@"
	
	_ssh_iperf_procedure "$@"
	_ssh_emit_procedure "$@"
	
	_ssh_common_internal_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_benchmark() {
	"$scriptAbsoluteLocation" _ssh_benchmark_sequence "$@"
}

_ssh_pulse_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	_ssh_external_procedure "$@"
	_messagePlain_nominal 'report: IP Address'
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	_ssh_iperf_raw_route_procedure "$@"
	
	_ssh_common_external_public_procedure "$@"
	_ssh_common_external_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_pulse() {
	"$scriptAbsoluteLocation" _ssh_pulse_sequence "$@"
}

_ssh_check_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	_ssh_external_procedure "$@"
	_messagePlain_nominal 'report: IP Address'
	
	_ssh_cycle "$@"
	
	_ssh_latency_procedure "$@"
	
	_ssh_iperf_procedure "$@"
	_ssh_emit_procedure "$@"
	
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	_ssh_iperf_raw_route_procedure "$@"
	
	_ssh_common_external_public_procedure "$@"
	_ssh_common_external_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_check() {
	"$scriptAbsoluteLocation" _ssh_check_sequence "$@"
}


# Tests showed slightly better performance with netcat vs socat, and 2-3x improvement over SSH.
# Stream of pseudorandom bytes to whoever connects. Intended only for benchmarking.
# "$1" == listen port
# "$2" == MB (MegaBytes)
_ssh_benchmark_download_public_source_sequence_ipv4() {
	dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count="$2" iflag=fullblock 2>/dev/null | socat -4 - TCP-LISTEN:"$1"
	
	#openssl enc -aes-256-ctr -pass pass:$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64) -nosalt < /dev/zero) | socat - TCP-LISTEN:"10000" > /dev/null 2>&1 &
	#openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2>/dev/null | head -c 15000000 | socat - TCP-LISTEN:"10000"
	
	#socat -u /dev/zero TCP4-LISTEN:10000
	#_proxy_direct 45.62.232.168 10000 | dd bs=1M count=15 of=/dev/null iflag=fullblock
	
	#socat -u /dev/zero TCP4-LISTEN:10000
	#socat -u TCP4:45.62.232.168:10000 STDOUT | dd of=/dev/null iflag=fullblock bs=1M count=100
}

_ssh_benchmark_download_public_source_ipv4() {
	nohup "$scriptAbsoluteLocation" _ssh_benchmark_download_public_source_sequence_ipv4 "$@" > /dev/null 2>&1 &
}

# Tests showed slightly better performance with netcat vs socat, and 2-3x improvement over SSH.
# Stream of pseudorandom bytes to whoever connects. Intended only for benchmarking.
# "$1" == listen port
# "$2" == MB (MegaBytes)
_ssh_benchmark_download_public_source_sequence_ipv6() {
	dd if=<(openssl enc -aes-256-ctr -pass pass:"$(head -c 128 /dev/urandom | base64)" -nosalt < /dev/zero 2> /dev/null ) bs=1M count="$2" iflag=fullblock 2>/dev/null | socat -6 - TCP-LISTEN:"$1"
}

_ssh_benchmark_download_public_source_ipv6() {
	nohup "$scriptAbsoluteLocation" _ssh_benchmark_download_public_source_sequence_ipv6 "$@" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_server() {
	"$scriptAbsoluteLocation" _timeout $(expr "$netTimeout" '*' 2 + 17 '*' 2 ) iperf3 -s -p "$1" > /dev/null 2>&1
}

_ssh_benchmark_iperf_server_ipv4() {
	nohup "$scriptAbsoluteLocation" _timeout $(expr "$netTimeout" '*' 2 + 17 '*' 2 ) iperf3 -s -p "$1" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_server_ipv6() {
	nohup "$scriptAbsoluteLocation" _timeout $(expr "$netTimeout" '*' 3 + 17 '*' 3 + 4 '*' 3 ) iperf3 -V -s -p "$1" > /dev/null 2>&1 &
}

_ssh_benchmark_iperf_client_ipv4() {
	_timeout $(expr "$netTimeout" + 17 ) iperf3 -c "$1" -p "$2"
}

_ssh_benchmark_iperf_client_ipv4_rev() {
	_timeout $(expr "$netTimeout" + 17 ) iperf3 -c "$1" -p "$2" -R
}

_ssh_benchmark_iperf_client_ipv6() {
	_timeout $(expr "$netTimeout" + 17 ) iperf3 -V -c "$1" -p "$2"
}

_ssh_benchmark_iperf_client_ipv6_rev() {
	_timeout $(expr "$netTimeout" + 17 ) iperf3 -V -c "$1" -p "$2" -R
}

_ssh_benchmark_download_raw_procedure_ipv4() {
	#_messagePlain_probe _ssh_benchmark_download_public_source_ipv4 "$remotePortPublicIPv4"
	_ssh "$@" "$safeTmpSSH_alt"'/cautossh'' '_ssh_benchmark_download_public_source_ipv4' '"$remotePortPublicIPv4"' '25 > /dev/null 2>&1 &
	
	sleep 3
	
	#_messagePlain_nominal '_download: public IPv4'
	#_messagePlain_probe _proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv4"
	_proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv4"
}

_ssh_benchmark_download_raw_procedure_ipv6() {
	_messagePlain_probe _ssh_benchmark_download_public_source_ipv6 "$remotePortPublicIPv6"
	_ssh "$@" "$safeTmpSSH_alt"'/cautossh'' '_ssh_benchmark_download_public_source_ipv6' '"$remotePortPublicIPv6"' '25 > /dev/null 2>&1 &
	
	sleep 3
	
	#_messagePlain_nominal '_download: public IPv6'
	#_messagePlain_probe _proxy_direct "$remotePublicIPv4" "$remotePortPublicIPv6"
	_proxy_direct "$remotePublicIPv6" "$remotePortPublicIPv6"
}

# Establishes raw tunel and transmits random binary data through it as bandwidth test.
# DANGER: Even with many parallel streams, this technique tends to be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: ATTENTION: Considered to use relatively poor programming practices.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_benchmark_download_raw() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	mkfifo "$safeTmp"/aggregate_fifo
	
	export safeTmpSSH_alt="$safeTmpSSH"
	
	_messagePlain_nominal '_download: public IPv4: establishing links'
	
	local currentIteration
	for ((currentIteration=0; currentIteration < "12"; currentIteration++))
	do
		"$scriptAbsoluteLocation" _ssh_benchmark_download_raw_procedure_ipv4 "$@" > "$safeTmp"/aggregate_fifo &
		#head -c 100000000 /dev/urandom > "$safeTmp"/aggregate_fifo &
	done
	
	sleep 12
	
	_messagePlain_nominal '_download: public IPv4: downloading'
	dd if="$safeTmp"/aggregate_fifo of=/dev/null iflag=fullblock
	#cat "$safeTmp"/aggregate_fifo
	
	sleep 2
	
	
	
	_messagePlain_nominal '_download: public IPv6: establishing links'
	
	local currentIteration
	for ((currentIteration=0; currentIteration < "12"; currentIteration++))
	do
		"$scriptAbsoluteLocation" _ssh_benchmark_download_raw_procedure_ipv6 "$@" > "$safeTmp"/aggregate_fifo &
		#head -c 100000000 /dev/urandom > "$safeTmp"/aggregate_fifo &
	done
	
	sleep 12
	
	_messagePlain_nominal '_download: public IPv6: downloading'
	dd if="$safeTmp"/aggregate_fifo of=/dev/null iflag=fullblock
	#cat "$safeTmp"/aggregate_fifo
	
	sleep 2
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_iperf_raw_public_procedure() {
	echo
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv4 "$remotePortPublicIPv4"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv4 "$remotePortPublicIPv4" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remotePublicIPv4" "$remotePortPublicIPv4"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: public IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4 "$remotePublicIPv4" "$remotePortPublicIPv4"
	_ssh_benchmark_iperf_client_ipv4 "$remotePublicIPv4" "$remotePortPublicIPv4"
	
	_messagePlain_nominal 'iperf: B: public IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4_rev "$remotePublicIPv4" "$remotePortPublicIPv4"
	_ssh_benchmark_iperf_client_ipv4_rev "$remotePublicIPv4" "$remotePortPublicIPv4"
	
	echo
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv6 "$remotePortPublicIPv6"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv6 "$remotePortPublicIPv6" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remotePublicIPv6" "$remotePortPublicIPv6"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: public IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6 "$remotePublicIPv6" "$remotePortPublicIPv6"
	_ssh_benchmark_iperf_client_ipv6 "$remotePublicIPv6" "$remotePortPublicIPv6"
	
	_messagePlain_nominal 'iperf: B: public IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6_rev "$remotePublicIPv6" "$remotePortPublicIPv6"
	_ssh_benchmark_iperf_client_ipv6_rev "$remotePublicIPv6" "$remotePortPublicIPv6"
	
	sleep 2
}

_ssh_iperf_raw_route_procedure() {
	echo
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv4 "$remotePortRouteIPv4"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv4 "$remotePortRouteIPv4" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remoteRouteIPv4" "$remotePortRouteIPv4"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: route IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4 "$remoteRouteIPv4" "$remotePortRouteIPv4"
	_ssh_benchmark_iperf_client_ipv4 "$remoteRouteIPv4" "$remotePortRouteIPv4"
	
	_messagePlain_nominal 'iperf: B: route IPv4'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv4_rev "$remoteRouteIPv4" "$remotePortRouteIPv4"
	_ssh_benchmark_iperf_client_ipv4_rev "$remoteRouteIPv4" "$remotePortRouteIPv4"
	
	echo
	_messagePlain_probe _ssh_benchmark_iperf_server_ipv6 "$remotePortRouteIPv6"
	_ssh "$@" "$safeTmpSSH"'/cautossh' _ssh_benchmark_iperf_server_ipv6 "$remotePortRouteIPv6" | tr -dc 'a-zA-Z0-9.:'
	
	#_waitPort "$remoteRouteIPv6" "$remotePortRouteIPv6"
	sleep 3
	
	_messagePlain_nominal 'iperf: A: route IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6 "$remoteRouteIPv6" "$remotePortRouteIPv6"
	_ssh_benchmark_iperf_client_ipv6 "$remoteRouteIPv6" "$remotePortRouteIPv6"
	
	_messagePlain_nominal 'iperf: B: route IPv6'
	_messagePlain_probe _ssh_benchmark_iperf_client_ipv6_rev "$remoteRouteIPv6" "$remotePortRouteIPv6"
	_ssh_benchmark_iperf_client_ipv6_rev "$remoteRouteIPv6" "$remotePortRouteIPv6"
	
	sleep 2
}

# Establishes raw connection and runs iperf across it.
# DANGER: Not completely tested. May be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_iperf_public_raw_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_iperf_raw_public_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

# Establishes raw connection and runs iperf across it.
# DANGER: Not completely tested. May be inaccurate.
# CAUTION: Generally, SSH connections are to be preferred for simplicity and flexiblity.
# WARNING: Requires public IP address, LAN IP address, and/or forwarded ports 35500-49075 .
# WARNING: Intended to produce end-user data. Use multiple specific IPv4 or IPv6 tests at a static address if greater reliability is needed.
_ssh_iperf_route_raw_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_iperf_raw_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_public_procedure() {
	_messagePlain_nominal 'ping: public: IPv4'
	_messageCMD ping -4 -U -i 1 -c 3 "$remotePublicIPv4"
	
	_messagePlain_nominal 'ping: public: IPv6'
	_messageCMD ping -6 -U -i 1 -c 3 "$remotePublicIPv6"
}

_ssh_ping_public_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_public_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_public() {
	"$scriptAbsoluteLocation" _ssh_ping_public_sequence "$@"
}

_ssh_ping_route_procedure() {
	_messagePlain_nominal 'ping: route: IPv4'
	_messageCMD ping -4 -U -i 1 -c 3 "$remoteRouteIPv4"
	
	_messagePlain_nominal 'ping: route: IPv6'
	_messageCMD ping -6 -U -i 1 -c 3 "$remoteRouteIPv6"
}

_ssh_ping_route_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping_route() {
	"$scriptAbsoluteLocation" _ssh_ping_route_sequence "$@"
}

_ssh_ping_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	
	_messagePlain_nominal 'get: external'
	_get_ssh_external "$@"
	
	_ssh_ping_public_procedure "$@"
	_ssh_ping_route_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_ping() {
	"$scriptAbsoluteLocation" _ssh_ping_sequence "$@"
}

_ssh_cycle() {
	_messagePlain_nominal 'cycle: ms'
	_stopwatch _ssh "$@" true
}

# WARNING: May be significantly inflated. Consider as a 'worst case' measurement.
# ATTENTION: Values comparable to "$netTimeout" indicate failure.
# PREREQUSITE: _get_ssh_relay "$@"
_ssh_latency_net_procedure() {
	(
		_messagePlain_nominal 'latency: ms'
		
		local currentPortIn=$(_findPort)
		local currentPortOut=$(_findPort)
		
		#_messagePlain_probe 'socat -4 - TCP-LISTEN:'"$currentPortOut"' > /dev/null 2>&1 &'
		_timeout "$netTimeout" socat -4 - TCP-LISTEN:"$currentPortOut" | head -c 1 > /dev/null 2>&1 &
		
		#_messagePlain_probe '_ssh '"$@"' -L '"$currentPortIn"':localhost:'"$relayPortOut"' -R '"$relayPortIn"':localhost:'"$currentPortOut"' socat tcp-listen:'"$relayPortOut"' tcp:localhost:'"$relayPortIn"' &'
		_timeout "$netTimeout" _ssh "$@" -L "$currentPortIn":localhost:"$relayPortOut" -R "$relayPortIn":localhost:"$currentPortOut" socat tcp-listen:"$relayPortOut" tcp:localhost:"$relayPortIn" &
		
		sleep 3
		
		#_messagePlain_probe 'echo -n 1 | _proxy_direct localhost '"$currentPortIn"
		echo -n 1 | _proxy_direct localhost "$currentPortIn" > /dev/null 2>&1
		
		( sleep 6 ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		( sleep 9 ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		( sleep $(expr "$netTimeout" - 2) ; echo -n 1 | _proxy_direct localhost "$currentPortIn" ) &
		
		#_messagePlain_probe wait %1
		_stopwatch wait %1
	)
}


# WARNING: May not be an exact measurement, especially at ranges near 3second . Expected error is less than approximately plus cycle time.
#https://serverfault.com/questions/807910/measure-total-latency-of-ssh-session
#https://www.cyberciti.biz/faq/linux-unix-read-one-character-atatime-while-loop/
_ssh_latency_character_procedure() {
	_messagePlain_nominal 'latency: ms'
	
	sleep 90 < "$safeTmp"/down &
	#sleep 90 > "$safeTmp"/up &
	
	(
	
	sleep 3
	
	cat "$safeTmp"/down > /dev/null 2>&1 &
	
	echo -n 1 > "$safeTmp"/up
	_stopwatch wait
	
	) &
	
	cat "$safeTmp"/up | _ssh "$@" head -c 1 > "$safeTmp"/down
	
	return 0
}

# WARNING: Depends on python resources.
_ssh_latency_python_procedure() {
	_messagePlain_nominal 'latency: ms'
	
	python -m timeit -n 25 -s 'import subprocess; p = subprocess.Popen(["'"$scriptAbsoluteLocation"'", "_ssh", "'"$@"'", "cat"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, bufsize=0); p.stdin.write(b"z"); assert p.stdout.read(1) == b"z"' 'p.stdin.write(b"z"); assert p.stdout.read(1) == b"z"'
}

_ssh_latency_procedure() {
	_ssh_latency_python_procedure "$@"
}

_ssh_latency_sequence() {
	_start
	_start_safeTmp_ssh "$@"
	_prepare_ssh_fifo
	
	#_messagePlain_nominal 'get: external'
	#_get_ssh_external "$@"
	#_messagePlain_nominal 'get: relay'
	#_get_ssh_relay "$@"
	
	#_ssh_latency_net_procedure "$@"
	
	#_ssh_latency_character_procedure "$@"
	
	_ssh_latency_python_procedure "$@"
	
	_stop_safeTmp_ssh "$@"
	_stop
}

_ssh_latency() {
	"$scriptAbsoluteLocation" _ssh_latency_sequence "$@"
}


# Checks common ports.
_ssh_common_internal_procedure() {
	_messagePlain_nominal 'nmap: IPv4'
	ssh "$@" nmap localhost -p 22,80,443
	
	_messagePlain_nominal 'nmap: IPv6'
	ssh "$@" nmap -6 localhost -p 22,80,443
}


_ssh_common_external_public_procedure() {
	_messagePlain_nominal 'nmap: public IPv4'
	nmap "$remotePublicIPv4" -p 22,80,443
	
	_messagePlain_nominal 'nmap: public IPv6'
	nmap -6 "$remotePublicIPv6" localhost -p 22,80,443
}

_ssh_common_external_route_procedure() {
	_messagePlain_nominal 'nmap: route IPv4'
	nmap "$remoteRouteIPv4" -p 22,80,443
	
	_messagePlain_nominal 'nmap: route IPv6'
	nmap -6 "$remoteRouteIPv6" -p 22,80,443
}



_testAutoSSH() {
	if ! _wantGetDep /usr/bin/autossh
	then
		echo 'warn: autossh not available'
		return 1
	fi
}

# ATTENTION: Respects "$LOCALLISTENPORT". May be repurposed for services other than SSH (ie. HTTPS).
#"$1" == "$gatewayName"
#"$2" == "$reversePort"
_autossh_external() {
	_overrideReversePorts
	
	#Workaround. SSH will call CoreAutoSSH recursively as the various "proxy" directives are called. These processes should be managed by SSH, and not recorded in the daemon PID list file, as daemon management scripts may be confused by these many processes quitting long before daemon failure.
	export isDaemon=
	
	local currentLocalSSHport
	currentLocalSSHport="$LOCALLISTENPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport="$LOCALSSHPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport=22
	
	local autosshPID
	
	if [[ "$autosshPublic" == "true" ]]
	then
		/usr/bin/autossh -M 0 -F "$sshDir"/config -R \*:"$2":localhost:"$currentLocalSSHport" "$1" -N &
		autosshPID="$!"
	fi
	if [[ "$autosshPublic" != "true" ]]
	then
		/usr/bin/autossh -M 0 -F "$sshDir"/config -R "$2":localhost:"$currentLocalSSHport" "$1" -N &
		autosshPID="$!"
	fi
	
	#echo "$autosshPID" | _prependDaemonPID
	
	#_pauseForProcess "$autosshPID"
	wait "$autosshPID"
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
#Searches for an unused port in the reversePorts list, binds reverse proxy to it.
#Until "_proxySSH_reverse" can differentiate "known_hosts" at remote ports, there is little point in performing a check for open ports at the remote end, since these would be used automatically. Thus, "_autossh_direct" is recommended for now.
#"$1" == "$gatewayName"
_autossh_find() {
	local currentReversePort
	for currentReversePort in "${matchingReversePorts[@]}"
	do
		if ! _checkRemoteSSH "$1" "$currentReversePort"
		then
			_autossh_external "$1" "$currentReversePort"
			return 0
		fi
	done
	return 1
}

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
#"$1" == "$gatewayName"
_autossh_direct() {
	_overrideReversePorts
	_autossh_external "$1" "${matchingReversePorts[0]}"
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
	_overrideReversePorts
	[[ "$1" != "" ]] && export gatewayName="$1"
	
	_autossh_direct "$gatewayName"
	#_autossh_find "$gatewayName"
	#_autossh_list "$gatewayName"
}

_autossh_launch() {
	_overrideReversePorts
	
	_start
	
	export sshBase="$safeTmp"/.ssh
	_prepare_ssh
	
	#_setup_ssh
	_setup_ssh_operations
	
	export sshInContainment="true"
	
	while true
	do
		"$scriptAbsoluteLocation" _autossh_entry "$@"
		
		sleep 3
		
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

# WARNING: Accepts "matchingReversePorts". Must be set with current values by "_get_reversePorts" or similar!
_reversessh() {
	local currentLocalSSHport
	currentLocalSSHport="$LOCALLISTENPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport="$LOCALSSHPORT"
	[[ "$currentLocalSSHport" == "" ]] && currentLocalSSHport=22
	
	_ssh -R "${matchingReversePorts[0]}":localhost:"$currentLocalSSHport" "$gatewayName" -N "$@"
}

_overrideReversePorts() {
	[[ "$overrideLOCALLISTENPORT" != "" ]] && export LOCALLISTENPORT="$overrideLOCALLISTENPORT"
	[[ "$overrideMatchingReversePort" != "" ]] && export matchingReversePorts=( "$overrideMatchingReversePort" )
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

_vncviewer_operations() {
	_messagePlain_nominal 'init: _vncviewer_operations'
	
	local msw_vncPasswdFile
	msw_vncPasswdFile=$(_slashBackToForward "$vncPasswdFile")
	msw_vncPasswdFile='C:\cygwin64'"$vncPasswdFile"
	
	local current_vncPasswdFile
	current_vncPasswdFile="$vncPasswdFile"
	
	[[ "$override_cygwin_vncviewer" == 'true' ]] && type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 && current_vncPasswdFile="$msw_vncPasswdFile"
	[[ "$override_cygwin_vncviewer" == 'true' ]] && type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 && current_vncPasswdFile="$msw_vncPasswdFile"
	
	
	#Typically set in '~/.bashrc' for *unusual* machines which have problems using vncviewer under X11.
	#https://steamcommunity.com/app/382110/discussions/0/1741101364304281184/
	if [[ "$vncviewer_manual" == 'true' ]]
	then
		_messagePlain_good 'assume: vncviewer (TigerVNC)'
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		mkdir -p "$HOME"/usrcmd
		
		local usrcmdUID
		usrcmdUID=$(_uid)
		
		_safeEcho_newline 'vncviewer -DotWhenNoCursor -passwd '\""$current_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"
		_safeEcho_newline 'vncviewer -DotWhenNoCursor -passwd '\""$current_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID".sh
		chmod u+x "$HOME"/usrcmd/"$usrcmdUID".sh
		
		if type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
		then
			_safeEcho_newline '"C:\Program Files\TigerVNC\vncviewer.exe"'' -DotWhenNoCursor -passwd '\""$msw_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"_x64.bat
			chmod u+x "$HOME"/usrcmd/"$usrcmdUID"_x64.bat
		fi
		
		if type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
		then
			_safeEcho_newline '"C:\Program Files (x86)\TigerVNC\vncviewer.exe"'' -DotWhenNoCursor -passwd '\""$msw_vncPasswdFile"\"' localhost:'"$vncPort"' '"${vncviewerArgs[@]}"' '"$@" > "$HOME"/usrcmd/"$usrcmdUID"_x86.bat
			chmod u+x "$HOME"/usrcmd/"$usrcmdUID"_x86.bat
		fi
		
		_messagePlain_request 'request: manual launch: vncviewer: time 120s: directives:' "$HOME"/usrcmd/"$usrcmdUID"
		
		_messagePlain_nominal 'wait...'
		
		# WARNING: Relies on VNC server replying "RFB" to TCP connections.
		#while _checkPort localhost "$vncPort"
		while echo -n | sleep 13 | _timeout 6 socat - TCP:localhost:"$vncPort",connect-timeout="$netTimeout" 2> /dev/null | grep RFB >/dev/null 2>&1
		do
			sleep 6
		done
		sleep 3
		
		rm -f "$HOME"/usrcmd/"$usrcmdUID" > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID".sh > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID"_x86.bat > /dev/null 2>&1
		rm -f "$HOME"/usrcmd/"$usrcmdUID"_x64.bat > /dev/null 2>&1
		
		return 0
	fi
	
	_messagePlain_nominal 'Detecting and launching vncviewer.'
	
	#Cygwin, Overriden to Native TigerVNC
	if [[ "$override_cygwin_vncviewer" == 'true' ]] && ( ( type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 ) || ( type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1 ) )
	then
		_messagePlain_good 'found: vncviewer (MSW)'
		
		_messagePlain_good 'assume: vncviewer (TigerVNC)'
		
		_messagePlain_probe '_vncviewer_operations'
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		# ATTENTION: Uncomment to log debug output from MSW vncviewer.
		
		#_messagePlain_probe  -----
		#_messagePlain_probe '"${vncviewerArgs[@]}"'
		#_safeEcho "${vncviewerArgs[@]}"
		#_messagePlain_probe -----
		#_messagePlain_probe '"$@"'
		#_safeEcho "$@"
		#_messagePlain_probe -----
		
		#tmux new-window bash -c '"/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe" -DotWhenNoCursor -passwd "'$current_vncPasswdFile'" localhost:"'$vncPort'" > ~/.sshtmp/vncerr 2>&1'
		
		if ! vncviewer -DotWhenNoCursor -passwd "$current_vncPasswdFile" localhost:"$vncPort" "${vncviewerArgs[@]}" "$@"
		then
			_messagePlain_bad 'fail: vncviewer'
			stty echo > /dev/null 2>&1
			return 1
		fi
		
		# WARNING: Relies on VNC server replying "RFB" to TCP connections.
		#while _checkPort localhost "$vncPort"
		while echo -n | sleep 13 | _timeout 6 socat - TCP:localhost:"$vncPort",connect-timeout="$netTimeout" 2> /dev/null | grep RFB >/dev/null 2>&1
		do
			sleep 6
		done
		sleep 3
		
		
		stty echo > /dev/null 2>&1
		return 0
	fi
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_warn 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_report_detect_x11
	
	_messagePlain_nominal 'Detecting and launching vncviewer.'
	
	#TigerVNC
	if vncviewer --help 2>&1 | grep 'PasswordFile   \- Password file for VNC authentication (default\=)' >/dev/null 2>&1
	then
		_messagePlain_good 'found: vncviewer (TigerVNC)'
		
		_messagePlain_probe '_vncviewer_operations'
		_report_detect_x11
		
		[[ "$vncviewer_startFull" == "true" ]] && vncviewerArgs+=(-FullScreen)
		
		if ! vncviewer -DotWhenNoCursor -passwd "$current_vncPasswdFile" localhost:"$vncPort" "${vncviewerArgs[@]}" "$@"
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
		
		_messagePlain_probe '_vncviewer_operations'
		_report_detect_x11
		
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

# Environment variables "x11vnc_clip" and "x11vnc_scale" may be forced.
_x11vnc_operations() {
	_messagePlain_nominal 'init: _x11vnc_operations'
	
	_messagePlain_nominal 'Searching for X11 display.'
	! _detect_x11 && _messagePlain_bad 'fail: _detect_x11'
	
	export DISPLAY="$destination_DISPLAY"
	export XAUTHORITY="$destination_AUTH"
	_messagePlain_probe 'x11vnc_operations'
	_report_detect_x11
	
	#local x11vncArgs
	
	[[ "$x11vnc_clip" != "" ]] && x11vncArgs+=(-clip "$x11vnc_clip")
	[[ "$x11vnc_scale" != "" ]] && x11vncArgs+=(-scale "$x11vnc_scale")
	[[ "$x11vnc_scale_cursor" != "" ]] && x11vncArgs+=(-cursor arrow -scale_cursor "$x11vnc_scale_cursor")
	
	_messagePlain_nominal 'Detecting and launching x11vnc.'
	#x11vnc
	if type x11vnc >/dev/null 2>&1
	then
		_messagePlain_good 'found: x11vnc'
		
		#-passwdfile cmd:"/bin/cat -"
		#-noxrecord -noxfixes -noxdamage
		#-shared
		if ! _x11vnc_command  -once -notightfilexfer -no6 -noipv6 -localhost -rfbportv6 -1 -rfbauth "$vncPasswdFile" -rfbport "$vncPort" -timeout 120 -xkb -display "$destination_DISPLAY" -auth "$destination_AUTH" -noxrecord -noxdamage -xrefresh 1 -fixscreen "V=3,C=3,X=3,8=3" -ungrabboth -shared "${x11vncArgs[@]}"
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
	
	_getDep nmap
	
	_getDep curl
	
	# WARNING: Cygwin does not pass netcat tests.
	uname -a | grep -i cygwin > /dev/null 2>&1 && return 0
	
	# WARNING: Do not rely on 'netcat' functionality. Relatively non-portable. Prefer "socat" .
	_getDep nc
	
	if "$scriptAbsoluteLocation" _testProxyRouter_sequence "$@"
	then
		return 0
	fi
	
	_stop 1
}

_proxy_direct_ipv4() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	socat -4 - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

_proxy_direct_ipv6() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	[[ "$proxyTargetHost" == *':'* ]] && proxyTargetHost='['"$proxyTargetHost"']'
	
	socat -6 - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

#Routes standard in/out to a target host/port through netcat.
_proxy_direct() {
	local proxyTargetHost
	local proxyTargetPort
	
	proxyTargetHost="$1"
	proxyTargetPort="$2"
	
	[[ "$proxyTargetHost" == *':'* ]] && proxyTargetHost='['"$proxyTargetHost"']'
	
	#nc -q 96 "$proxyTargetHost" "$proxyTargetPort"
	#nc -q -1 "$proxyTargetHost" "$proxyTargetPort"
	#nc "$proxyTargetHost" "$proxyTargetPort" 2> /dev/null
	
	socat - TCP:"$proxyTargetHost":"$proxyTargetPort",connect-timeout="$netTimeout" 2> /dev/null
}

_proxy_ipv4() {
	if _checkPort_ipv4 "$1" "$2"
	then
		#_proxy_direct_ipv4 "$1" "$2"
		if _proxy_direct_ipv4 "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
	fi
	
	return 0
}

_proxy_ipv6() {
	if _checkPort_ipv6 "$1" "$2"
	then
		#_proxy_direct_ipv6 "$1" "$2"
		if _proxy_direct_ipv6 "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
			_stop
		fi
	fi
	
	return 0
}

#Launches proxy if port at hostname is open.
#"$1" == hostname
#"$2" == port
_proxy() {
	if _checkPort "$1" "$2"
	then
		#_proxy_direct "$1" "$2"
		if _proxy_direct "$1" "$2"
		then
			# WARNING: Not to be relied upon. May not reach if terminated by signal.
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

_relay() {
	socat tcp-listen:"$1",reuseaddr,fork tcp:localhost:"$2"
}

# WARNING: Choose reputable services that have been documented alive for at least a few years.
#https://gist.github.com/yurrriq/7fc7634dd00494072f45
_find_public_ipv4() {
	local currentPublicIPaddr
	
	currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipv4.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipv4.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://v4.ident.me/ | tr -dc 'a-zA-Z0-9.:')
	
	# CAUTION: Not explicitly IPv4 (though probably nearly so) - https://ipecho.net/developers.html .
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -4 -s https://ipecho.net/plain | tr -dc 'a-zA-Z0-9.:')
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

# WARNING: Choose reputable services that have been documented alive for at least a few years.
#https://gist.github.com/yurrriq/7fc7634dd00494072f45
_find_public_ipv6() {
	local currentPublicIPaddr
	
	currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://ipv6.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://ipv6.icanhazip.com/ | tr -dc 'a-zA-Z0-9.:')
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(curl --connect-timeout "$netTimeout" -6 -s https://v6.ident.me/ | tr -dc 'a-zA-Z0-9.:')
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

_find_public_ip() {
	local currentPublicIPaddr
	
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(_find_public_ipv6)
	[[ "$currentPublicIPaddr" == "" ]] && currentPublicIPaddr=$(_find_public_ipv4)
	
	
	[[ "$currentPublicIPaddr" == "" ]] && return 1
	echo -n "$currentPublicIPaddr"
	return 0
}

#https://stackoverflow.com/questions/21336126/linux-bash-script-to-extract-ip-address
_find_route_ipv4() {
	#ip route get 8.8.8.8 | awk 'NR==1 {print $NF}'
	ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'
}

#https://stackoverflow.com/questions/21336126/linux-bash-script-to-extract-ip-address
_find_route_ipv6() {
	ip route get 2001:4860:4860::8888 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'
}

_find_route_ip() {
	local currentRouteIPaddr
	
	[[ "$currentRouteIPaddr" == "" ]] && currentRouteIPaddr=$(_find_route_ipv6)
	[[ "$currentRouteIPaddr" == "" ]] && currentRouteIPaddr=$(_find_route_ipv4)
	
	[[ "$currentRouteIPaddr" == "" ]] && return 1
	echo -n "$currentRouteIPaddr"
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
	sudo -n apt-get -y update
	
# 	if [[ "$1" == *"java"* ]]
# 	then
# 		sudo -n apt-get install --install-recommends -y default-jdk default-jre
# 		return 0
# 	fi
	
	if [[ "$1" == *"wine"* ]] && ! dpkg --print-foreign-architectures | grep i386 > /dev/null 2>&1
	then
		sudo -n dpkg --add-architecture i386
		sudo -n apt-get -y update
		sudo -n apt-get install --install-recommends -y wine wine32 wine64 libwine libwine:i386 fonts-wine
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
		
		sudo -n apt-get -y update
		sudo -n apt-get install --install-recommends -y dkms virtualbox-6.1
		
		echo "WARNING: Recommend manual system configuration after install. See https://www.virtualbox.org/wiki/Downloads ."
		
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
		sudo -n apt-get install --install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
		
		"$scriptAbsoluteLocation" _getDep curl
		! _wantDep curl && return 1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo -n apt-key add -
		local aptKeyFingerprint
		aptKeyFingerprint=$(sudo -n apt-key fingerprint 0EBFCD88 2> /dev/null)
		[[ "$aptKeyFingerprint" == "" ]] && return 1
		
		sudo -n add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		
		sudo -n apt-get -y update
		
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
		
		sudo -n apt-get -y update
		
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
	
	if [[ "$1" == "php" ]]
	then
		sudo -n apt-get install --no-install-recommends -y php
		
		return 0
	fi
	
	if [[ "$1" == "cura-lulzbot" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See https://www.lulzbot.com/learn/tutorials/cura-lulzbot-edition-installation-debian ."
cat << 'CZXWXcRMTo8EmM8i4d'
wget -qO - https://download.alephobjects.com/ao/aodeb/aokey.pub | sudo -n apt-key add -
sudo -n cp /etc/apt/sources.list /etc/apt/sources.list.bak && sudo -n sed -i '$a deb http://download.alephobjects.com/ao/aodeb jessie main' /etc/apt/sources.list && sudo -n apt-get -y update && sudo -n apt-get install cura-lulzbot
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



















_fetchDep_debianBuster_special() {
	sudo -n apt-get -y update
	
# 	if [[ "$1" == *"java"* ]]
# 	then
# 		sudo -n apt-get install --install-recommends -y default-jdk default-jre
# 		return 0
# 	fi
	
	if [[ "$1" == *"wine"* ]] && ! dpkg --print-foreign-architectures | grep i386 > /dev/null 2>&1
	then
		sudo -n dpkg --add-architecture i386
		sudo -n apt-get -y update
		sudo -n apt-get install --install-recommends -y wine wine32 wine64 libwine libwine:i386 fonts-wine
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
		echo 'deb http://download.virtualbox.org/virtualbox/debian buster contrib' | sudo -n tee /etc/apt/sources.list.d/vbox.list > /dev/null 2>&1
		
		"$scriptAbsoluteLocation" _getDep wget
		! _wantDep wget && return 1
		
		# TODO Check key fingerprints match "B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF" and "7B0F AB3A 13B9 0743 5925  D9C9 5442 2A4B 98AB 5139" respectively.
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -n apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo -n apt-key add -
		
		sudo -n apt-get -y update
		sudo -n apt-get install --install-recommends -y dkms virtualbox-6.1
		
		echo "WARNING: Recommend manual system configuration after install. See https://www.virtualbox.org/wiki/Downloads ."
		
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
		sudo -n update-alternatives --set iptables /usr/sbin/iptables-legacy
		sudo -n update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
		#sudo -n systemctl restart docker
		
		sudo -n apt-get install --install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
		
		"$scriptAbsoluteLocation" _getDep curl
		! _wantDep curl && return 1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo -n apt-key add -
		local aptKeyFingerprint
		aptKeyFingerprint=$(sudo -n apt-key fingerprint 0EBFCD88 2> /dev/null)
		[[ "$aptKeyFingerprint" == "" ]] && return 1
		
		sudo -n add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		
		sudo -n apt-get -y update
		
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
		
		sudo -n apt-get -y update
		
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
	
	if [[ "$1" == "php" ]]
	then
		sudo -n apt-get install --no-install-recommends -y php
		
		return 0
	fi
	
	if [[ "$1" == "cura-lulzbot" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See https://www.lulzbot.com/learn/tutorials/cura-lulzbot-edition-installation-debian ."
cat << 'CZXWXcRMTo8EmM8i4d'
wget -qO - https://download.alephobjects.com/ao/aodeb/aokey.pub | sudo -n apt-key add -
sudo -n cp /etc/apt/sources.list /etc/apt/sources.list.bak && sudo -n sed -i '$a deb http://download.alephobjects.com/ao/aodeb jessie main' /etc/apt/sources.list && sudo -n apt-get -y update && sudo -n apt-get install cura-lulzbot
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
	
	
	if [[ "$1" == "rclone" ]]
	then
		_tryExec '_test_rclone_upstream'
		#_tryExec '_test_rclone_upstream_beta'
	fi
	
	if [[ "$1" == "terraform" ]]
	then
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		sudo -n apt-get -y update
		sudo -n apt-get install --install-recommends -y terraform
	fi
	
	if [[ "$1" == "vagrant" ]]
	then
		#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		#sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		#sudo -n apt-get -y update
		
		sudo -n apt-get install --install-recommends -y vagrant-libvirt
		
		sudo -n apt-get install --install-recommends -y vagrant
	fi
	
	
	return 1
}

_fetchDep_debianBuster_sequence() {
	_start
	
	_mustGetSudo
	
	_wantDep "$1" && _stop 0
	
	_fetchDep_debianBuster_special "$@" && _wantDep "$1" && _stop 0
	
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

_fetchDep_debianBuster() {
	#Run up to 2 times. On rare occasion, cache will become unusable again by apt-find before an installation can be completed. Overall, apt-find is the single weakest link in the system.
	"$scriptAbsoluteLocation" _fetchDep_debianBuster_sequence "$@"
	"$scriptAbsoluteLocation" _fetchDep_debianBuster_sequence "$@"
}

















_fetchDep_debian() {
	
	# WARNING: Obsolete. Declining support. Eventual removal expected approximately one year after two Debian stable releases.
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 1 | grep 9 > /dev/null 2>&1
	then
		_fetchDep_debianStretch "$@"
		return
	fi
	
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 10 > /dev/null 2>&1
	then
		_fetchDep_debianBuster "$@"
		return
	fi
	
	return 1
}

#https://unix.stackexchange.com/questions/39226/how-to-run-a-script-with-systemd-right-before-shutdown
# In theory, 'sleep 1892160000' should create a process that will run for at least 60 years, with 'sleep' binaries that support 'floating point' numbers of seconds, which should be tested for by timetest. This should not be depended upon unless necessary however.

_here_systemd_shutdown_action() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
CZXWXcRMTo8EmM8i4d


echo Description=$sessionid

cat << 'CZXWXcRMTo8EmM8i4d'

[Service]
ExecStart=/bin/true
CZXWXcRMTo8EmM8i4d

echo ExecStop=\""$scriptAbsoluteLocation"\" "$@"

cat << 'CZXWXcRMTo8EmM8i4d'
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target

CZXWXcRMTo8EmM8i4d

}

_here_systemd_shutdown() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
CZXWXcRMTo8EmM8i4d


echo Description=$sessionid

cat << 'CZXWXcRMTo8EmM8i4d'

[Service]
ExecStart=/bin/true
CZXWXcRMTo8EmM8i4d

echo ExecStop=\""$scriptAbsoluteLocation"\" "$@"

cat << 'CZXWXcRMTo8EmM8i4d'
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target

CZXWXcRMTo8EmM8i4d

}

_hook_systemd_shutdown() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	_here_systemd_shutdown | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n systemctl start "$sessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
}

_hook_systemd_shutdown_action() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	_here_systemd_shutdown_action "$@" | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n systemctl start "$sessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	
}

#"$1" == sessionid (optional override for cleaning up stale systemd files)
_unhook_systemd_shutdown() {
	local hookSessionid
	hookSessionid="$sessionid"
	[[ "$1" != "" ]] && hookSessionid="$1"
	
	[[ ! -e /etc/systemd/system/"$hookSessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	! [[ -e /etc/systemd/system ]] && return 0
	
	[[ "$SYSTEMCTLDISABLE" == "true" ]] && echo SYSTEMCTLDISABLE | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1 && return 0
	export SYSTEMCTLDISABLE=true
	
	sudo -n systemctl disable "$hookSessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
	sudo -n rm -f /etc/systemd/system/"$hookSessionid".service 2>&1 | sudo -n tee -a "$permaLog"/gsysd.log > /dev/null 2>&1
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

_stopwatch() {
	local measureDateA
	local measureDateB
	
	measureDateA=$(date +%s%N | cut -b1-13)

	"$@"

	measureDateB=$(date +%s%N | cut -b1-13)

	bc <<< "$measureDateB - $measureDateA"
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
	
	# WARNING: Override implies local image.
	[[ "$ubVirtImageIsRootPartition" != "" ]] && export ubVirtImageLocal="true" && return 0
	[[ "$ubVirtImageIsDevice" != "" ]] && export ubVirtImageLocal="true" && return 0
	[[ "$ubVirtImageOverride" != "" ]] && export ubVirtImageLocal="true" && return 0
	[[ "$ubVirtDeviceOverride" != "" ]] && export ubVirtImageLocal="true" && return 0
	#[[ "$ubVirtPlatformOverride" != "" ]] && export ubVirtImageLocal="true" && return 0
	
	# WARNING: Symlink implies local image (even if non-existent destination).
	[[ -h "$scriptLocal"/vm.img ]] && export ubVirtImageLocal="true" && return 0
	[[ -h "$scriptLocal"/vm.vdi ]] && export ubVirtImageLocal="true" && return 0
	[[ -h "$scriptLocal"/vmvdiraw.vmdi ]] && export ubVirtImageLocal="true" && return 0
	
	_checkSpecialLocks && export ubVirtImageLocal="true" && return 0
	
	# DANGER: Recursion hazard.
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

_test_localpath() {
	_getDep realpath
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
			
			# Trailing slash added to comparison to prevent partial matching of directory names.
			# https://stackoverflow.com/questions/12340846/bash-shell-script-to-find-the-closest-parent-directory-of-several-files
			# https://stackoverflow.com/questions/9018723/what-is-the-simplest-way-to-remove-a-trailing-slash-from-each-parameter
			while [[ "${newDir%/}/" != "${baseDir%/}/"* ]]
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
	! _wantGetDep xauth && echo warn: missing: xauth && return 1
	return 0
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

# WARNING: First parameter, "$1" , must always be non-translated program to run or specialized abstractfs command.
# Specifically do not attempt _abstractfs "$scriptAbsoluteLocation" or similar.
# "$scriptAbsoluteLocation" _fakeHome "$scriptAbsoluteLocation" _abstractfs bash
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
	
	
	local current_abstractfs_base_args
	current_abstractfs_base_args=("${@}")
	
	[[ "$ubAbstractFS_enable_CLD" == 'true' ]] && [[ "$ubASD_CLD" != '' ]] && current_abstractfs_base_args+=( "$ubASD_PRJ" "$ubASD_CLD" )
	
	_base_abstractfs "${current_abstractfs_base_args[@]}"
	
	
	_name_abstractfs > /dev/null 2>&1
	[[ "$abstractfs_name" == "" ]] && return 1
	
	
	# WARNING: Enabling may allow a misplaced 'project.afs' file in "/" , "$HOME' , or similar, to override a legitimate directory.
	# WARNING: Conflicting 'project.afs' files may break 'scope' use cases relying on "$ubASD_CLD" or similar.
	# However, such a misplaced file may already cause wrong directory collisions with abstractfs.
	# Historically not enabled by default. Consider enabling by default equivalent to at least a minor version bump - be wary of any possible broken use cases.
	if [[ "$abstractfs_projectafs" != "" ]]
	then
		export abstractfs_projectafs_dir=$(_getAbsoluteFolder "$abstractfs_projectafs")
		[[ "$ubAbstractFS_enable_projectafs_dir" == 'true' ]] && current_abstractfs_base_args+=( "$abstractfs_projectafs_dir" ) && _base_abstractfs "${current_abstractfs_base_args[@]}" > /dev/null 2>&1
		#[[ "$ubAbstractFS_enable_projectafs_dir" != 'false' ]] && current_abstractfs_base_args+=( "$abstractfs_projectafs_dir" ) && _base_abstractfs "${current_abstractfs_base_args[@]}" > /dev/null 2>&1
	fi
	
	export abstractfs="$abstractfs_root"/"$abstractfs_name"
	
	_set_share_abstractfs
	_relink_abstractfs
	
	_virtUser "$@"
	
	cd "$localPWD"
	#cd "$abstractfs_base"
	#cd "$abstractfs"
	
	local commandExitStatus
	commandExitStatus=1
	
	#_scope_terminal "${processedArgs[@]}"
	
	if ! [[ -L "$abstractfs" ]] && [[ -d "$abstractfs" ]]
	then
		# _messagePlain_bad 'fail: abstractfs: abstractfs_base is a directory: abstractfs_base= ""$abstractfs_base"
		rmdir "$abstractfs"
		_set_share_abstractfs_reset
		_rmlink_abstractfs
		return 1
	fi
	
	_set_abstractfs_disable_CLD
	[[ "$abstractfs_command" == 'ub_abstractfs_getOnly_dst' ]] && echo "$abstractfs"
	[[ "$abstractfs_command" == 'ub_abstractfs_getOnly_src' ]] && echo "$abstractfs_base"
	if [[ "$abstractfs_command" != 'ub_abstractfs_getOnly_dst' ]] && [[ "$abstractfs_command" != 'ub_abstractfs_getOnly_src' ]]
	then
		"$abstractfs_command" "${processedArgs[@]}"
		commandExitStatus="$?"
	fi
	
	_set_share_abstractfs_reset
	_rmlink_abstractfs
	
	return "$commandExitStatus"
}





_get_abstractfs_dst_procedure() {
	shift
	_abstractfs 'ub_abstractfs_getOnly_dst' "$@"
}
_get_abstractfs_dst_sequence() {
	_start
	_get_abstractfs_dst_procedure "$@"
	_stop 0
}

# If the result independent of any particular command is desired, use "_true" as command (first parameter).
_get_abstractfs_dst() {
	"$scriptAbsoluteLocation" _get_abstractfs_dst_sequence "$@"
}
_get_abstractfs() {
	_get_abstractfs_dst "$@"
}



_get_abstractfs_src_procedure() {
	shift
	_abstractfs 'ub_abstractfs_getOnly_src' "$@"
}
_get_abstractfs_src_sequence() {
	_start
	_get_abstractfs_src_procedure "$@"
	_stop 0
}
# If the result independent of any particular command is desired, use "_true" as command (first parameter).
_get_abstractfs_src() {
	"$scriptAbsoluteLocation" _get_abstractfs_src_sequence "$@"
}

_get_base_abstractfs() {
	_get_abstractfs_src "$@"
}
_get_base_abstractfs_name() {
	local current_abstractfs_base
	current_abstractfs_base=$(_get_abstractfs_src "$@")
	basename "$current_abstractfs_base"
}





# No known production use.
# ATTENTION Overload ONLY if further specialization is actually required!
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_prepare_abstractfs_appdir_none() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	
	#export ubASD="$ubASD"
	
	export ubASD_PRJ="$ubASD_PRJ_none"
	#export ubASD_PRJ="$ubASD_PRJ_independent"
	#export ubASD_PRJ="$ubASD_PRJ_shared"
	#export ubASD_PRJ="$ubASD_PRJ_export"
	
	export ubASD_CLD="$ubASD_CLD_none"
	#export ubASD_CLD="$ubASD_CLD_independent"
	#export ubASD_CLD="$ubASD_CLD_shared"
	#export ubASD_CLD="$ubASD_CLD_export"
	
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	
	
	
	
	# CLD_none , CLD_independent , CLD_export
	_set_abstractfs_disable_CLD
	
	# CLD_shared
	#_set_abstractfs_enable_CLD
	
	_prepare_abstractfs_appdir "$@"
	
	
	# CAUTION: May be invalid. Do not use or enable. For reference only.
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_none_sub"
	##export ubADD_CLD="$ubADD""$ubADD_CLD_independent_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	export ubAFS_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	
	export ubAFS_CLD="$ubADD""$ubADD_CLD_none_sub"
	#export ubAFS_CLD="$ubASD_CLD_independent"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#_probe_prepare_abstractfs_appdir_post
}
# MISUSE. Permissible, given rare requirement to ensure directories exist to perform common directory determination.
_set_abstractfs_appdir_none() {
	_prepare_abstractfs_appdir_none "$@"
}





# No known production use.
# ATTENTION Overload ONLY if further specialization is actually required!
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_prepare_abstractfs_appdir_independent() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	
	#export ubASD="$ubASD"
	
	#export ubASD_PRJ="$ubASD_PRJ_none"
	export ubASD_PRJ="$ubASD_PRJ_independent"
	#export ubASD_PRJ="$ubASD_PRJ_shared"
	#export ubASD_PRJ="$ubASD_PRJ_export"
	
	#export ubASD_CLD="$ubASD_CLD_none"
	export ubASD_CLD="$ubASD_CLD_independent"
	#export ubASD_CLD="$ubASD_CLD_shared"
	#export ubASD_CLD="$ubASD_CLD_export"
	
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	
	
	
	
	# CLD_none , CLD_independent , CLD_export
	_set_abstractfs_disable_CLD
	
	# CLD_shared
	#_set_abstractfs_enable_CLD
	
	_prepare_abstractfs_appdir "$@"
	
	
	# CAUTION: May be invalid. Do not use or enable. For reference only.
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_none_sub"
	##export ubADD_CLD="$ubADD""$ubADD_CLD_independent_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	export ubAFS_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_none_sub"
	export ubAFS_CLD="$ubASD_CLD_independent"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#_probe_prepare_abstractfs_appdir_post
}
# MISUSE. Permissible, given rare requirement to ensure directories exist to perform common directory determination.
_set_abstractfs_appdir_independent() {
	_prepare_abstractfs_appdir_independent "$@"
}





# No known production use.
# ATTENTION Overload ONLY if further specialization is actually required!
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
# DANGER: Strongly discouraged. May break use of "project.afs" with alternative layouts and vice versa.
_prepare_abstractfs_appdir_shared() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	
	#export ubASD="$ubASD"
	
	#export ubASD_PRJ="$ubASD_PRJ_none"
	#export ubASD_PRJ="$ubASD_PRJ_independent"
	export ubASD_PRJ="$ubASD_PRJ_shared"
	#export ubASD_PRJ="$ubASD_PRJ_export"
	
	#export ubASD_CLD="$ubASD_CLD_none"
	#export ubASD_CLD="$ubASD_CLD_independent"
	export ubASD_CLD="$ubASD_CLD_shared"
	#export ubASD_CLD="$ubASD_CLD_export"
	
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	
	
	
	
	# CLD_none , CLD_independent , CLD_export
	#_set_abstractfs_disable_CLD
	
	# CLD_shared
	_set_abstractfs_enable_CLD
	
	_prepare_abstractfs_appdir "$@"
	
	
	# CAUTION: May be invalid. Do not use or enable. For reference only.
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_none_sub"
	##export ubADD_CLD="$ubADD""$ubADD_CLD_independent_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	export ubAFS_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_none_sub"
	#export ubAFS_CLD="$ubASD_CLD_independent"
	export ubAFS_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#_probe_prepare_abstractfs_appdir_post
}
# MISUSE. Permissible, given rare requirement to ensure directories exist to perform common directory determination.
_set_abstractfs_appdir_shared() {
	_prepare_abstractfs_appdir_shared "$@"
}





# No known production use.
# ATTENTION Overload ONLY if further specialization is actually required!
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
_prepare_abstractfs_appdir_export() {
	_set_abstractfs_AbstractSourceDirectory "$@"
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	
	##### # ATTENTION: Prior to abstractfs. 'ApplicationProjectDirectory', ConfigurationLookupDirectory.
	
	#export ubASD="$ubASD"
	
	#export ubASD_PRJ="$ubASD_PRJ_none"
	#export ubASD_PRJ="$ubASD_PRJ_independent"
	#export ubASD_PRJ="$ubASD_PRJ_shared"
	export ubASD_PRJ="$ubASD_PRJ_export"
	
	#export ubASD_CLD="$ubASD_CLD_none"
	#export ubASD_CLD="$ubASD_CLD_independent"
	#export ubASD_CLD="$ubASD_CLD_shared"
	export ubASD_CLD="$ubASD_CLD_export"
	
	#_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	
	
	
	
	# CLD_none , CLD_independent , CLD_export
	_set_abstractfs_disable_CLD
	
	# CLD_shared
	#_set_abstractfs_enable_CLD
	
	_prepare_abstractfs_appdir "$@"
	
	
	# CAUTION: May be invalid. Do not use or enable. For reference only.
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	#export ubADD_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_none_sub"
	##export ubADD_CLD="$ubADD""$ubADD_CLD_independent_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_shared_sub"
	#export ubADD_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_none_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_independent_sub"
	#export ubAFS_PRJ="$ubADD""$ubADD_PRJ_shared_sub"
	export ubAFS_PRJ="$ubADD""$ubADD_PRJ_export_sub"
	
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_none_sub"
	#export ubAFS_CLD="$ubASD_CLD_independent"
	#export ubAFS_CLD="$ubADD""$ubADD_CLD_shared_sub"
	export ubAFS_CLD="$ubADD""$ubADD_CLD_export_sub"
	
	
	#_probe_prepare_abstractfs_appdir_post
}
# MISUSE. Permissible, given rare requirement to ensure directories exist to perform common directory determination.
_set_abstractfs_appdir_export() {
	_prepare_abstractfs_appdir_export "$@"
}






# CAUTION: ConfigurationLookupDirectory, managed by "_appdir" functions, is NOT a global configuration registry. ONLY intended to support programs which may require *project-specific* configuration (eg. Eclipse).
# WARNING: Input parameters must NOT include neighboring ConfigurationLookupDirectory, regardless of whether static ConfigurationLookupDirectory is used.
# WARNING: All 'mkdir' operations using "$ubADD" or similar must take place *within* abstractfs, to avoid creating a folder conflicting with the required symlink.
# Input
# "$@"
_set_abstractfs_AbstractSourceDirectory() {
	# AbstractSourceDirectory
	_set_abstractfs_disable_CLD
	export ubASD=$(export afs_nofs_write="true" ; "$scriptAbsoluteLocation" _get_base_abstractfs "$@" "$ub_specimen")
	_set_abstractfs_disable_CLD
	export ubASD_name=$(basename $ubASD)
	
	# Should never be reached. Also, undesirable default.
	[[ "$ubASD_name" == "" ]] && export ubASD_name=project
	
	
	# No known production use.
	export ubADD_CLD_none_sub=""
	export ubADD_PRJ_none_sub=""
	export ubASD_CLD_none_sub="$ubADD_CLD_none_sub"
	export ubASD_CLD_none="$ubASD"
	export ubASD_PRJ_none=""
	export ubASD_PRJ_none="$ubASD""$ubASD_PRJ_none"
	
	# ApplicationSourceDirectory-ConfigurationLookupDirectory
	# Project directory is *source* directory.
	# ConfigurationLookupDirectory is *neighbor*, using absolute path *outside* abstractfs translation.
	# CAUTION: Not compatible with applications requiring all paths translated by abstractfs.
	# CAUTION: Invalid to combine "$ubADD" with "$ubADD_CLD_independent_sub" .
	export ubADD_CLD_independent_sub=/../"$ubASD_name".cld
	export ubADD_PRJ_independent_sub=""
	export ubASD_CLD_independent_sub="$ubADD_CLD_independent_sub"
	export ubASD_CLD_independent="$ubASD""$ubASD_CLD_independent_sub"
	export ubASD_PRJ_independent_sub=""
	export ubASD_PRJ_independent="$ubASD""$ubASD_PRJ_independent_sub"
	
	# ConfigurationLookupDirectory is *neighbor*, next to project directory, in *shared* abstractfs directory.
	# DANGER: Strongly discouraged. May break use of "project.afs" with alternative layouts and vice versa.
	export ubADD_CLD_shared_sub=/"$ubASD_name".cld
	export ubADD_PRJ_shared_sub=/"$ubASD_name"
	export ubASD_CLD_shared_sub=/.."$ubADD_CLD_shared_sub"
	export ubASD_CLD_shared="$ubASD""$ubASD_CLD_shared_sub"
	export ubASD_PRJ_shared_sub=""
	export ubASD_PRJ_shared="$ubASD""$ubASD_PRJ_shared_sub"
	
	# Internal '_export' folder instead of neighboring ConfigurationLookupDirectory .
	export ubADD_CLD_export_sub=/_export/afscld
	export ubADD_PRJ_export_sub=""
	export ubASD_CLD_export_sub="$ubADD_CLD_export_sub"
	export ubASD_CLD_export="$ubASD""$ubASD_CLD_export_sub"
	export ubASD_PRJ_export_sub="$ubASD_CLD_export_sub"
	export ubASD_PRJ_export="$ubASD"
}

_set_abstractfs_enable_CLD() {
	export ubAbstractFS_enable_CLD='true'
}

_set_abstractfs_disable_CLD() {
	export ubAbstractFS_enable_CLD='false'
	
	# No known production use.
	export ubAbstractFS_enable_CLDnone='false'
	export ubAbstractFS_enable_CLDindependent='false'
	export ubAbstractFS_enable_CLDshared='false'
	export ubAbstractFS_enable_CLDexport='false'
}

_prepare_abstractfs_appdir() {
	mkdir -p "$ubASD"
	mkdir -p "$ubASD_CLD"
	#_set_abstractfs_disable_CLD
	export ubADD=$(export afs_nofs="true" ; "$scriptAbsoluteLocation" _get_abstractfs "$@" "$ub_specimen")
	#_set_abstractfs_disable_CLD
}











_probe_prepare_abstractfs_appdir_AbstractSourceDirectory() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_AbstractSourceDirectory'
	_messagePlain_probe_var ubASD
	_messagePlain_probe_var ubASD_name
	
	_messagePlain_probe_var ubASD_CLD_none_sub
	_messagePlain_probe_var ubASD_CLD_none
	
	_messagePlain_probe_var ubASD_CLD_independent_sub
	_messagePlain_probe_var ubASD_CLD_independent
	
	_messagePlain_probe_var ubASD_CLD_shared_sub
	_messagePlain_probe_var ubASD_CLD_shared
	
	_messagePlain_probe_var ubASD_CLD_export_sub
	_messagePlain_probe_var ubASD_CLD_export
}

_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior'
	_messagePlain_probe_var ubASD
	_messagePlain_probe_var ubASD_PRJ
	_messagePlain_probe_var ubASD_CLD
}

_probe_prepare_abstractfs_appdir_post() {
	_messagePlain_nominal '_probe_prepare_abstractfs_appdir_post'
	_messagePlain_probe_var ubADD
	#_messagePlain_probe_var ubADD_PRJ
	#_messagePlain_probe_var ubADD_CLD
	_messagePlain_probe_var ubAFS_PRJ
	_messagePlain_probe_var ubAFS_CLD
}



_probe_prepare_abstractfs_appdir() {
	_probe_prepare_abstractfs_appdir_AbstractSourceDirectory
	_probe_prepare_abstractfs_appdir_AbstractSourceDirectory_prior
	_probe_prepare_abstractfs_appdir_post
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
	
	# Replace ./../.. ... /../home/user/ ... with /home/"\$USER"/ .
	#current_x11_clipboard=\${current_x11_clipboard/*\/home\//\/home\/}
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\//\/home\//')
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/'"$USER"'/\/home\/'"$USER"'/')
	#current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/[a-zA-Z0-9_\-]*/\/home\/'"$USER"'/')
	current_x11_clipboard=\$(_safeEcho "\$current_x11_clipboard" | sed 's/^\([\.\/]\)*home\/[^/]*/\/home\/'"$USER"'/')
	
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
	
	_wantGetDep dbus-run-session
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
	# WARNING: Recursive fakeHome prohibited. Instead, start new script session, with new sessionid, and keepFakeHome=false. Do not workaround without a clear understanding why this may endanger your application.
	_resetFakeHomeEnv
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
# ATTENTION: WARNING: Do not remove or modify functionality of GUI workarounds without extensive testing!
_fakeHome() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	# WARNING: Obviously less reliable than directly stating variable assignments.
	local fakeHomeENVvars
	
	fakeHomeENVvars+=(DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP="$XDG_SESSION_DESKTOP" XDG_CURRENT_DESKTOP="$XDG_SESSION_DESKTOP")
	fakeHomeENVvars+=(realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome")
	fakeHomeENVvars+=(TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}")
	[[ "$ub_fakeHome_dropPWD" != 'true' ]] && fakeHomeENVvars+=(PWD="$PWD")
	fakeHomeENVvars+=(_JAVA_OPTIONS="${_JAVA_OPTIONS}")
	fakeHomeENVvars+=(scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder")
	fakeHomeENVvars+=(sessionid="$sessionid" realSessionID="$realSessionID" )
	
	fakeHomeENVvars+=(LD_PRELOAD="$LD_PRELOAD")
	
	# https://github.com/prusa3d/PrusaSlicer/issues/3969
	fakeHomeENVvars+=(USER="$USER")
	
	if type dbus-run-session > /dev/null 2>&1
	then
		fakeHomeENVvars+=(dbus-run-session)
	fi
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" sessionid="$sessionid" scriptAbsoluteFolder="$scriptAbsoluteFolder" realSessionID="$realSessionID" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	##env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
	##dbus-run-session "$@"
	##"$@"
	##. "$@"
	#env -i "${fakeHomeENVvars[@]}" "$@"
	#fakeHomeExitStatus=$?
	
	
	
	if [[ "$appImageExecutable" == "" ]]
	then
		[[ "$1" == *'.APPIMAGE' ]] && export appImageExecutable="$1"
		[[ "$1" == *'.appimage' ]] && export appImageExecutable="$1"
		[[ "$1" == *'.AppImage' ]] && export appImageExecutable="$1"
	fi
	if [[ "$appImageExecutable" != "" ]]
	then
		#mkdir -p "$appImageExecutable".home
		#mkdir -p "$appImageExecutable".config
		#"$appImageExecutable" --appimage-portable-home > /dev/null 2>&1
		#"$appImageExecutable" --appimage-portable-config > /dev/null 2>&1
		
		export appImageExecutable_basename=$(basename "$appImageExecutable")
		export appImageExecutable_actualFakeHome="$actualFakeHome"/"$appImageExecutable_basename"
		
		chmod u+rx "$appImageExecutable"
		
		#cp -r -L --preserve=all "$appImageExecutable" "$actualFakeHome"/
		rsync -rLptgoD "$appImageExecutable" "$actualFakeHome"/
		
		chmod u+rx "$appImageExecutable_actualFakeHome"
		
		if [[ ! -d "$appImageExecutable_actualFakeHome".home ]] || [[ ! -d "$appImageExecutable_actualFakeHome".config ]]
		then
			mkdir -p "$appImageExecutable_actualFakeHome".home
			mkdir -p "$appImageExecutable_actualFakeHome".config
			"$appImageExecutable_actualFakeHome" --appimage-portable-home > /dev/null 2>&1
			"$appImageExecutable_actualFakeHome" --appimage-portable-config > /dev/null 2>&1
		fi
		
		
		shift
		
		#_fakeHome "$appImageExecutable_actualFakeHome" "$@"
		
		if [[ "$1" != '--norunFakeHome' ]]
		then
			env -i "${fakeHomeENVvars[@]}" "$appImageExecutable_actualFakeHome" "$@"
			fakeHomeExitStatus=$?
		else
			fakeHomeExitStatus='0'
		fi
	elif false
	then
		true
	else
		env -i "${fakeHomeENVvars[@]}" "$@"
		fakeHomeExitStatus=$?
	fi
	
	
	#_unmakeFakeHome > /dev/null 2>&1
	
	_resetFakeHomeEnv_nokeep
	
	return "$fakeHomeExitStatus"
}

#Do NOT keep parent session under fakeHome environment. Do NOT regain parent session if "~/.ubcore/.ubcorerc" is imported (typically upon shell launch).
# ATTENTION: WARNING: Do not remove or modify functionality of GUI workarounds without extensive testing!
_fakeHome_specific() {
	_begin_fakeHome "$@"
	local fakeHomeExitStatus
	
	if ! _safeEcho_newline "$_JAVA_OPTIONS" | grep "$HOME" > /dev/null 2>&1
	then
		export _JAVA_OPTIONS=-Duser.home="$HOME"' '"$_JAVA_OPTIONS"
	fi
	
	# WARNING: Obviously less reliable than directly stating variable assignments.
	local fakeHomeENVvars
	
	fakeHomeENVvars+=(DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP="$XDG_SESSION_DESKTOP" XDG_CURRENT_DESKTOP="$XDG_SESSION_DESKTOP")
	fakeHomeENVvars+=(realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome")
	fakeHomeENVvars+=(TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}")
	[[ "$ub_fakeHome_dropPWD" != 'true' ]] && fakeHomeENVvars+=(PWD="$PWD")
	fakeHomeENVvars+=(_JAVA_OPTIONS="${_JAVA_OPTIONS}")
	#fakeHomeENVvars+=(scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder"realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder")
	#fakeHomeENVvars+=(sessionid="$sessionid" realSessionID="$realSessionID" )
	
	if type dbus-run-session > /dev/null 2>&1
	then
		fakeHomeENVvars+=(dbus-run-session)
	fi
	
	##env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}dbus-run-session "$@"
	##dbus-run-session "$@"
	##"$@"
	##. "$@"
	env -i "${fakeHomeENVvars[@]}" "$@"
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
	
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" realScriptAbsoluteLocation="$realScriptAbsoluteLocation" realScriptAbsoluteFolder="$realScriptAbsoluteFolder" dbus-run-session "$@"
	#env -i DISPLAY="$DISPLAY" XAUTH="$XAUTH" XAUTHORITY="$XAUTHORITY" XSOCK="$XSOCK" XDG_SESSION_DESKTOP='KDE' XDG_CURRENT_DESKTOP='KDE' realHome="$realHome" keepFakeHome="$keepFakeHome" HOME="$HOME" setFakeHome="$setFakeHome" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" _JAVA_OPTIONS=${_JAVA_OPTIONS}scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" dbus-run-session "$@"
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

#####Shortcuts

# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
_visualPrompt_promptCommand() {
	[[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber='0'
	#echo "$PS1_lineNumber"
	let PS1_lineNumber="$PS1_lineNumber"+1
	#export PS1_lineNumber

	PS1_lineNumberText="$PS1_lineNumber"
	if [[ "$PS1_lineNumber" == '1' ]]
	then
		# https://unix.stackexchange.com/questions/266921/is-it-possible-to-use-ansi-color-escape-codes-in-bash-here-documents
		PS1_lineNumberText=$(echo -e -n '\E[1;36m'1'\E[0m')
	fi
}

_visualPrompt() {
	#+%H:%M:%S\ %Y-%m-%d\ Q%q
	#+%H:%M:%S\ %b\ %d,\ %y

	#Long.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]--\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]-|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '

	#Short.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]-\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	#Truncated, 40 columns.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	
	# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
	
	#export PROMPT_COMMAND=$(declare -f _visualPrompt_promptCommand)' ; _visualPrompt_promptCommand'
	#export PROMPT_COMMAND='_visualPrompt_promptCommand () { [[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber="0"; let PS1_lineNumber="$PS1_lineNumber"+1; PS1_lineNumberText="$PS1_lineNumber"; if [[ "$PS1_lineNumber" == "1" ]]; then PS1_lineNumberText=$(echo -e -n "'"\E[1;36m"'"1"'"\E[0m"'"); fi } ; _visualPrompt_promptCommand'
	
	export -f _visualPrompt_promptCommand
	export PROMPT_COMMAND=_visualPrompt_promptCommand
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]>\[\033[00m\] '
	
	
	export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
}

#https://stackoverflow.com/questions/15432156/display-filename-before-matching-line-grep
_grepFileLine() {
	grep -n "$@" /dev/null
}

_findFunction() {
	#-name '*.sh'
	#-not -path "./_local/*"
	#find ./blockchain -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find ./generic -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find ./instrumentation -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find ./labels -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find ./os -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find ./shortcuts -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	#find . -name '*.sh' -type f -size -10000k -exec grep -n "$@" '{}' /dev/null \;
	
	find . -not -path "./_local/*" -name '*.sh' -type f -size -1000k -exec grep -n "$@" '{}' /dev/null \;
}



_octave_terse() {
	if [[ "$1" != "" ]]
	then
		_safeEcho_newline "$@" | octave --quiet --silent --no-window-system --no-gui 2>/dev/null | _octave_filter-messages
		return
	fi
	
	octave --quiet --silent --no-window-system --no-gui 2>/dev/null | _octave_filter-messages
	return
}

_octave() {
	if [[ "$1" != "" ]]
	then
		_octave_terse "$@"
		return
	fi
	
	octave --quiet --silent --no-window-system --no-gui "$@"
	return
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _octave_pipe
_octave_pipe() {
	_octave_terse "$@"
	#octave --quiet --silent --no-window-system --no-gui "$@" 2>/dev/null | _octave_filter-messages
}

# ATTENTION: EXAMPLE: _octave_script 'octave_script.m'
# echo 'solve(x == y * 2, y)' > octave_script.m
_octave_script() {
	local currentFile="$1"
	shift
	
	cat "$currentFile" | _octave_terse "$@"
	
	#octave --quiet --silent --no-window-system --no-gui "$@" 2>/dev/null | _octave_filter-messages
}











_octave_filter-messages() {
	grep -v 'Symbolic pkg .*1: Python communication link active, SymPy v' | grep -v '_____' | grep -v '^$' | sed 's/^ans = //' | sed 's/^(sym) //'
	#cat
}






# solve '( y  == x * 2, x)'

_octave_solve() {
	_safeEcho_newline solve"$@" | _octave_pipe
}
_octave_nsolve() {
	_safeEcho_newline nsolve"$@" | _octave_pipe
}

if type -p octave > /dev/null 2>&1
then
	_solve() {
		_octave_solve "$@"
	}
	solve() {
		_octave_solve "$@"
	}
	nsolve() {
		_octave_nsolve "$@"
	}

	_clc() {
		_octave "$@"
	}
	clc() {
		_octave "$@"
	}
	c() {
		_octave "$@"
	}
fi






_test_devgnuoctave() {
	_wantGetDep octave
	_wantGetDep octave-cli
	
	
	_wantGetDep octave-config
	_wantGetDep mkoctfile
	
	_wantGetDep 'x86_64-linux-gnu/liboctave.so'
	_wantGetDep 'x86_64-linux-gnu/liboctinterp.so'
	
	
	_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/OutputSBML.mex'
	_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/TranslateSBML.mex'
	
	_wantGetDep 'x86_64-linux-gnu/qt5/plugins/cantor/backends/cantor_octavebackend.so'
	
	
	#if ! _wantGetDep dh_octave_check
	#then
		#! _typeShare 'dh-octave/install-pkg.m' && _wantGetDep dh-octave/install-pkg.m
	#fi
	
	
	
	_tryExec '_test_devgnuoctave-debian-x64'
	
	
	
	return 0
}


# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_devgnuoctave_wantGetDep-octavePackage-debian-x64() {
	# If not Debian, then simply accept these pacakges may not be available.
	[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	# If not x64, then simply accept these pacakges may not be available.
	local hostArch
	hostArch=$(uname -m)
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 0
	fi
	
	! _typeShare_dir_wildcard 'octave/packages/'"$1" && ! _typeShare_dir_wildcard 'octave/packages/'octave-"$1" && _wantGetDep octave-"$1"
	#_wantGetDep octave-"$1"
	
	return 0
}

_test_devgnuoctave-debian-x64() {
	# If not Debian, then simply accept these pacakges may not be available.
	[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	
	# If not x64, then simply accept these pacakges may not be available.
	local hostArch
	hostArch=$(uname -m)
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 0
	fi
	
	
	
	
	if ! _typeShare_dir_wildcard 'octave/packages/arduino' && ! _typeShare 'doc-base/octave-arduino-manual' && ! _typeShare 'info/arduino.info.gz' && ! _typeShare 'doc/octave-arduino/arduino.pdf.gz'
	then
		_wantGetDep octave-arduino
	fi
	
	
	_wantGetDep /usr/share/octave/site/m/bart/bart.m
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 bim
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/biosig/mexSLOAD.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 bsltl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 cgi
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 data-smoothing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 dataframe
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 dicom
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 divand
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 doctest
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 econometrics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 financial
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fits
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fpl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fuzzy-logic-toolkit
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ga-
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/gdf/gdf_reader.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 general
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 geometry
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 gsl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 image
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 image-acquisition
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 instrument-control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 interval
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 io-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 level-set
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 linear-algebra
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 lssa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ltfat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mapping
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 miscellaneous
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 missing-functions
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mpi-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 msh-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mvn-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 nan-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ncarray
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 netcdf
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt/nlopt_optimize.oct
	! _typeShare 'octave/site/m/nlopt/nlopt_optimize.m' && _wantGetDep octave-nlopt
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 nurbs
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 netcdf
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 octclip
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 octproj
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 openems
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optim
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optiminterp
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 parallel
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/pfstools/pfsread.oct
	! _typeShare 'octave/site/m/pfstools/pfs_read_xyz.m' && _wantGetDep octave-pfstools
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/api-v52/x86_64-pc-linux-gnu/plplot_octave.oct
	! _typeShare 'plplot_octave/mesh.m' && _wantGetDep octave-plplot
	
	_wantGetDep psychtoolbox-3/PsychBasic/PsychPortAudio.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 quaternion
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 queueing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs1d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs2d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs3d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 signal
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 sockets
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 sparsersb
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 specfun
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 splines
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 statistics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 stk
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 strings
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 struct
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 symbolic
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 tsa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 vibes
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/vlfeat/toolbox/vl_binsearch.mex
	! _typeShare 'octave/site/m/vlfeat/toolbox/misc/vl_binsearch.m' && _wantGetDep octave-vlfeat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 vrml
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 zenity
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 zeromq
	
	
	return 0
}





_qalculate_terse() {
	# https://stackoverflow.com/questions/17998978/removing-colors-from-output
	#sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	
	# https://stackoverflow.com/questions/4233159/grep-regex-whitespace-behavior
	#grep -v '^\s*$'
	
	if [[ "$1" != "" ]]
	then
		_safeEcho_newline "$@" | qalc -t | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
		return
	fi
	
	qalc -t "$@" | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	return
}

# Interactive.
_qalculate() {
	if [[ "$1" != "" ]]
	then
		_qalculate_terse "$@"
		return
	fi
	
	qalc "$@"
	return
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _qalculate_pipe
_qalculate_pipe() {
	_qalculate_terse "$@"
}

# ATTENTION: _qalculate_script 'qalculate_script.m'
# echo 'solve(x == y * 2, y)' > qalculate_script.m
_qalculate_script() {
	local currentFile="$1"
	shift
	
	cat "$currentFile" | _qalculate_pipe "$@"
}










_qalculate_solve() {
	_safeEcho_newline solve"$@" | _qalculate_pipe
}
_qalculate_nsolve() {
	_safeEcho_newline solve"$@" | _qalculate_pipe
}

if type -p qalc > /dev/null 2>&1
then
	_solve() {
		_qalculate_solve "$@"
	}
	solve() {
		_qalculate_solve "$@"
	}
	nsolve() {
		_qalculate_solve "$@"
	}

	_clc() {
		_qalculate "$@"
	}
	clc() {
		_qalculate "$@"
	}
	c() {
		_qalculate "$@"
	}
fi




_test_devqalculate() {
	_wantGetDep qalculate-gtk
	_wantGetDep qalculate
	
	_wantGetDep qalc
	
	! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && _wantGetDep gnuplot-data
	! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && echo 'warn: missing: gnuplot-data'
	
	#_wantGetDep gnuplot-data
	#_wantGetDep gnuplot-x11
	_wantGetDep gnuplot-qt
	
	_wantGetDep gnuplot
	
	! _typeDep qalculate-gtk && echo 'warn: missing: qalculate-gtk'
	
	return 0
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

_testGit() {
	_wantGetDep git
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
	git branch -M main
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
	
	find -L . -mindepth 1 -maxdepth 1 -not \( -path \*_arc\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) -type d -exec "$scriptAbsoluteLocation" _findGit_procedure '{}' "$@" \;
}

#Recursively searches for directories containing ".git".
_findGit() {
	if [[ -e "./.git" ]]
	then
		"$@"
		return 0
	fi
	
	find -L . -mindepth 1 -maxdepth 1 -not \( -path \*_arc\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) -type d -exec "$scriptAbsoluteLocation" _findGit_procedure '{}' "$@" \;
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
# Pushes all changes as a commit described as "Upstream."
_gitUpstream() {
	git add -A . ; git commit -a -m "Upstream." ; git push
}
_gitUp() {
	_gitUpstream
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
	git branch -M main
	
	echo "-----"
}


_setBareGitRepo() {
	cd "$repoDir"
	
	git remote rm origin
	git remote add origin "$bareRepoDir"
	git push --set-upstream origin master
	
	# WARNING: TODO: Experimental, requires further testing. Use branch 'main' if extant.
	git push --set-upstream origin main
	
	echo "-----"
}

_showGitRepoURI() {
	echo git clone --recursive "$bareRepoAbsoluteDir" "$repoName"
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


#"$1" == src (file/dir)
#"$2" == dst (torrentName).torrent
#"$3" == CSV Tracker URL List (full announce URL list comma delimited) (' <url>[,<url>]* ')
#"$4" == CSV Web Seed URL List
# ./ubiquitous_bash.sh _mktorrent ./ubiquitous_bash.sh torrentName 'https://example.com/tracker,https://example1.com/tracker' 'https://example.com/ubiquitous_bash.sh,https://example1.com/ubiquitous_bash.sh'
_mktorrent_webseed() {
	if [[ "$1" == "" ]]
	then
		_messagePlain_request '"$1" == src (file/dir)'
		_messagePlain_request '"$2" == dst (torrentName).torrent'
		_messagePlain_request '"$3" == CSV Tracker URL List (full announce URL list comma delimited) ('\'' <url>[,<url>]* '\'')'
		_messagePlain_request '"$4" == CSV Web Seed URL List'
		return 1
	fi
	
	local currentSrc
	currentSrc="$1"
	local currentDst
	currentDst="$2"
	local currentTrackerCSV
	currentTrackerCSV="$3"
	local currentWebSeedCSV
	currentWebSeedCSV="$4"
	shift ; shift ; shift ; shift
	
	mktorrent -w "$currentWebSeedCSV" -a "$currentTrackerCSV" -d "$currentSrc" -n "$currentDst" "$@"
}
_mktorrent() {
	_mktorrent_webseed "$@"
}







_test_mktorrent() {
	# If not Debian, then simply accept these pacakges may not be available.
	[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	_wantGetDep mktorrent
	
	#_getDep mktorrent
}






#screenscraper-nix

# ATTENTION: Expect new software development will be required. Some relevant capability apparently already exists from OBS, ffmpeg , gstreamer , etc . Due to apparent lack of 'NVIDIA Game Stream' , most likely a GPU-agnostic real-time h264 or similar video codec would also be helpful.



#screenscraper-msw

# ATTENTION: Expect new software development will be required. MSW particularly has complicated issues with 'UAC' . Developer 'Guy Godin' of 'Virtual Desktop' most likely has source code for all necessary workarounds.




#aws

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .


# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
# https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_aws_cloud_cred() {
	_aws_set "$@"
}
_aws_cloud_cred_reset() {
	_aws_reset "$@"
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_aws_cloud_server_name
_aws_cloud_server_create() {
	_messageNormal 'init: _aws_cloud_server_create'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	export ub_aws_cloud_server_name="$1"
	[[ "$ub_aws_cloud_server_name" == "" ]] && export ub_aws_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _aws_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_aws_cloud_server_uid=
	while [[ "$ub_aws_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_aws_cloud_server_create_API--us-east_g5-standard-2_debian9 "$ub_aws_cloud_server_name" > "$cloudTmp"/reply
		export ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | grep -v 'PrivateDnsName' |  jq '.'Instances[].InstanceId | tr -dc 'a-zA-Z0-9.:_-')
		_aws_cloud_server_name_API "$ub_aws_cloud_server_uid" "$ub_aws_cloud_server_name"
		
		[[ "$ub_aws_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _aws_cloud_server_create: miss'
	done
	[[ "$ub_aws_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _aws_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _aws_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	_aws_cloud_server_status "$ub_aws_cloud_server_uid"
	
	_aws_cloud_cred_reset
	
	return 0
}
_aws_cloud_server_create_API--image_ami-xxxxxxxx() {
	# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
	#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name "$ubiquitiousBashIDshort" --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e
	aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name "$ubiquitiousBashIDshort" --security-group-ids sg-"$ubiquitiousBashIDshort" --subnet-id subnet-"$ubiquitiousBashIDshort"
}
_aws_cloud_server_name_API() {
	aws ec2 create-tags --resources "$ub_aws_cloud_server_uid" --tags Key=Name,Value="$ub_aws_cloud_server_name"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _aws_cloud_self_server_list _aws_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _aws_cloud_self_server_list _aws_cloud_self_server_status-filter 'workstation'
_aws_cloud_self_server_list() {
	_messageNormal 'init: _aws_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	_messagePlain_nominal 'attempt: _aws_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_aws_cloud_server_uid
	current_ub_aws_cloud_server_uid=
	while [[ "$current_ub_aws_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		# WARNING: WIP, Untested.
		# https://serverfault.com/questions/578921/how-would-you-go-about-listing-instances-using-aws-cli-in-certain-vpc-with-the-t
		#aws ec2 describe-instances --no-paginate --filters "Name=instance-type,Values=t2.micro" --query 'Reservations[*].Instances[*].{Instance:InstanceId,Tags[0]}' --output json > "$cloudTmp"/reply
		#aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value[]]' --output json > "$cloudTmp"/reply
		aws ec2 describe-instances --no-paginate --query 'Reservations[].Instances[].{InstanceId,Tags[?Key==`Name`].Value[0]}' --output json > "$cloudTmp"/reply
		current_ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.[0].Instance' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_aws_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _aws_cloud_self_server_list: miss'
	done
	[[ "$current_ub_aws_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _aws_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _aws_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.[].Instance,.[].Tags'
	_stop_cloud_tmp
	_aws_cloud_cred_reset
	
	return 0
}



_aws_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _aws_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _aws_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_aws_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_aws_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_aws_cloud_server_uid" != "null" ]] && [[ "$ub_aws_cloud_server_name" != "null" ]] && [[ "$ub_aws_cloud_server_uid" != "" ]] && [[ "$ub_aws_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_aws_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			#"$ub_aws_cloud_server_uid"
			while ! aws ec2 terminate-instances --instance-ids "$ub_aws_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_aws_cloud_server_uid=
		export ub_aws_cloud_server_name=
		
		# WARNING: May work as intended without properly filtering for 'Name' 'tag' .
		ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.['"$currentIterations"'].Instance' | tr -dc 'a-zA-Z0-9.:_-')
		ub_aws_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.['"$currentIterations"'].Tags' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_aws_cloud_server_uid
		_messagePlain_probe_var ub_aws_cloud_server_name
		
	done
	_messagePlain_good  'done: _aws_cloud_self_server_dispose-filter'
	
	return 0
}


_aws_cloud_self_server_status-filter() {
	_messageNormal 'init: _aws_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _aws_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_aws_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_aws_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_aws_cloud_server_uid" != "null" ]] && [[ "$ub_aws_cloud_server_name" != "null" ]] && [[ "$ub_aws_cloud_server_uid" != "" ]] && [[ "$ub_aws_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_aws_cloud_server_name" | grep "$@"
		then
			_aws_cloud_self_server_status "$ub_aws_cloud_server_uid"
		fi
		
		export ub_aws_cloud_server_uid=
		export ub_aws_cloud_server_name=
		
		ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_aws_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_aws_cloud_server_uid
		_messagePlain_probe_var ub_aws_cloud_server_name
		
	done
	_messagePlain_good  'done: _aws_cloud_self_server_status-filter'
	
	return 0
}


_aws_cloud_self_server_status() {
	_messageNormal 'init: _aws_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	# ATTENTION: NOTICE: Possibly an excellent means to obtain sample data for 'describe-instances' .
	
	aws ec2 describe-instances --instance-ids "$ub_aws_cloud_server_uid"
	
	
	
	# WARNING: WIP, Untested.
	
	
	
	#export ub_aws_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.' | tr -dc 'a-zA-Z0-9.:_-')
	#export ub_aws_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.' | tr -dc 'a-zA-Z0-9.:_-')
	
	export ub_aws_cloud_server_addr_ipv4=
	export ub_aws_cloud_server_addr_ipv6=
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_aws_cloud_server_ssh_cred=
	export ub_aws_cloud_server_ssh_port=
	
	export ub_aws_cloud_server_vnc_cred=
	export ub_aws_cloud_server_vnc_port=
	
	export ub_aws_cloud_server_serial=
	
	export ub_aws_cloud_server_novnc_cred=
	export ub_aws_cloud_server_novnc_port=
	export ub_aws_cloud_server_novnc_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_novnc_port"/novnc/
	export ub_aws_cloud_server_novnc_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_novnc_port"/novnc/
	
	export ub_aws_cloud_server_shellinabox_port=
	export ub_aws_cloud_server_shellinabox_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_shellinabox_port"/shellinabox/
	export ub_aws_cloud_server_shellinabox_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_aws_cloud_server_remotedesktopwebclient_port=
	export ub_aws_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_aws_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_aws_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}



























# ATTENTION: Intended to be used by '_index' shortcuts as with 'cautossh' '_setup' .
_aws() {
	local currentBin_aws
	currentBin_aws="$ub_function_override_aws"
	[[ "$currentBin_aws" == "" ]] && currentBin_aws=$(type -p aws 2> /dev/null)
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.ssh
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	env AWS_PROFILE="$netName" AWS_CONFIG_FILE="$scriptLocal"/cloud/aws/.aws/config HOME="$scriptLocal"/cloud/aws "$currentBin_aws" "$@"
}

_aws_reset() {
	export ub_function_override_aws=''
	unset ub_function_override_aws
	unset aws
}

# ATTENTION: Intended to be called from '_cloud_set' or similar, in turn called by '_cloud_hook', in turn used by '_index' shortcuts as with 'cautossh' '_setup' .
_aws_set() {
	export ub_function_override_aws=$(type -p aws 2> /dev/null)
	aws() {
		_aws "$@"
	}
}



_aws_eb() {
	local currentBin_aws_eb
	currentBin_aws_eb="$ub_function_override_aws_eb"
	[[ "$currentBin_aws_eb" == "" ]] && currentBin_aws_eb=$(type -p eb 2> /dev/null)
	
	#if [[ "$PATH" != *'.pyenv/versions'* ]]
	#then
		local current_python_path_version
		current_python_path_version=$("$currentBin_aws_eb" --version | sed 's/.*Python\ //g' | tr -dc 'a-zA-Z0-9.')
		#export PATH="$HOME/.pyenv/versions/$current_python_path_version/bin:$PATH"
	#fi
	
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.aws
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
	env PATH="$HOME/.pyenv/versions/$current_python_path_version/bin:$PATH" AWS_PROFILE="$netName" AWS_CONFIG_FILE="$scriptLocal"/cloud/aws/.aws/config HOME="$scriptLocal"/cloud/aws "$currentBin_aws_eb" "$@"
}
_eb() {
	_aws_eb "$@"
}

_aws_eb_reset() {
	export ub_function_override_aws_eb=''
	unset ub_function_override_aws_eb
	unset eb
}

_aws_eb_set() {
	if [[ "$PATH" != *'.ebcli-virtual-env/executables'* ]]
	then
		# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
		export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
	fi
	
	export ub_function_override_aws_eb=$(type -p eb 2> /dev/null)
	eb() {
		_eb "$@"
	}
}





# ATTENTION: Theoretically, it may be useful to merge an 'aws' 'home' directory to a user's actual 'home' directory. However, at best it is not known if this can be done with sufficiently portable programs. Moreover, it is not yet obvious whether this is in any way more desirable than function/path overrides alone, or may cause expensive 'human error' mistakes.
_aws_hook() {
	true
}
_aws_unhook() {
	true
}






# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_aws' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'


# ###

# https://aws.amazon.com/blogs/machine-learning/running-distributed-tensorflow-training-with-amazon-sagemaker/
# https://horovod.ai/getting-started/

#horovodrun -np 16 -H server1:4,server2:4,server3:4,server4:4 python train.py


# https://nodered.org/docs/getting-started/aws
#eb create


# https://nodered.org/docs/getting-started/aws
#sudo npm install -g --unsafe-perm pm2
#pm2 start `which node-red` -- -v
#pm2 save
#pm2 startup


# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-buckets-creating
#aws s3 mb s3://bucket-name

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html
#aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pe

# https://stackoverflow.com/questions/30809822/how-to-get-aws-command-line-interface-to-work-in-cygwin
# 'I had the same problem. I got around it by installing a new copy of AWSCLI within Cygwin. You first need to install the "curl" and "python" Cygwin packages, then you can install AWSCLI as follows:'
#curl -O https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
#pip install awscli
#hash -d aws

# ###


# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# WARNING: Infinite loop risk, do not call '_wantGetDep aws' or similar within this function.
_test_aws_upstream_sequence() {
	_start
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$safeTmp"
	
	
	_mustGetSudo
	! _wantSudo && return 1
	
	echo
	
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip -q awscliv2.zip
	sudo -n ./aws/install
	sudo -n ./aws/install --update
	
	echo
	
	sudo -n pip install --upgrade pip
	sudo -n pip install aws-shell
	
	echo
	
	git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
	./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
	#sudo -n ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
	export safeToDeleteGit="true"
	_safeRMR "$safeTmp"/aws-elastic-beanstalk-cli-setup
	export safeToDeleteGit=
	unset safeToDeleteGit
	
	echo
	
	# ATTENTION: Theoretically this should install 'nodered' and 'pm2' . Not enabled yet by default.
	# https://nodered.org/docs/getting-started/aws
	# https://github.com/nodesource/distributions#debinstall
	#curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -n -E bash -
	#sudo -n apt-get install -y nodejs
	#sudo -n npm install -g --unsafe-perm node-red
	#sudo -n npm install -g --unsafe-perm pm2
	
	#echo
	
	cd "$functionEntryPWD"
	_stop
}

# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_aws() {
	if ! _if_cygwin
	then
		# zlib1g-dev
		_getDep 'zconf.h'
		_getDep 'zlib.h'
		_getDep 'pkgconfig/zlib.pc'
		
		# libssl-dev
		_getDep 'openssl/ssl3.h'
		_getDep 'openssl/aes.h'
		_getDep 'pkgconfig/openssl.pc'
		_getDep 'pkgconfig/libssl.pc'
		_getDep 'pkgconfig/libcrypto.pc'
		
		# libncurses-dev
		_getDep 'ncurses6-config'
		_getDep 'ncursesw6-config'
		_getDep 'ncurses5-config'
		_getDep 'ncursesw5-config'
		_getDep 'curses.h'
		_getDep 'pkgconfig/ncurses.pc'
		_getDep 'pkgconfig/ncursesw.pc'
		
		# libffi-dev
		_getDep 'ffitarget.h'
		_getDep 'pkgconfig/libffi.pc'
		
		# libsqlite3-dev
		_getDep 'sqlite3.h'
		_getDep 'sqlite3ext.h'
		_getDep 'pkgconfig/sqlite3.pc'
		
		# libreadline-dev
		_getDep 'readline/readline.h'
		_getDep 'libreadline.so'
		
		# libbz2-dev
		_getDep 'bzlib.h'
		_getDep 'libbz2.so'
		
		
		# python3-pypillowfight
		_getDep 'python3/dist-packages/pillowfight/__init__.py'
		
		# python3-wxgtk4.0
		_getDep 'python3/dist-packages/wx/__init__.py'
		
		# wxglade
		_getDep 'wxglade'
		
		
		_getDep 'unzip'
		
		
		_getDep 'python3'
		_getDep 'pip'
		
		
		
		
		if [[ "$nonet" != "true" ]] && cat /etc/issue 2>/dev/null | grep 'Debian' > /dev/null 2>&1
		then
			_messagePlain_request 'ignore: upstream progress ->'
			"$scriptAbsoluteLocation" _test_aws_upstream_sequence "$@"
			_messagePlain_request 'ignore: <- upstream progress'
		fi
	fi
	
	_wantSudo && _wantGetDep aws
	
	! _typeDep aws && echo 'warn: missing: aws'
	! _typeDep aws-shell && echo 'warn: missing: aws-shell'
	
	
	if [[ "$PATH" != *'.ebcli-virtual-env/executables'* ]]
	then
		# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
		export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
	fi
	
	
	! _typeDep eb && echo 'warn: missing: eb'
	
	
	
	return 0
}




#google

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .



# https://cloud.google.com/compute/docs/instances/create-start-instance#gcloud


# https://dev.to/0xbanana/automating-deploys-with-bash-scripting-and-google-cloud-sdk-4976









# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_gcloud_cloud_cred() {
	_gcloud_set "$@"
}
_gcloud_cloud_cred_reset() {
	_gcloud_reset "$@"
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_gcloud_cloud_server_name
_gcloud_cloud_server_create() {
	_messageNormal 'init: _gcloud_cloud_server_create'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	export ub_gcloud_cloud_server_name="$1"
	[[ "$ub_gcloud_cloud_server_name" == "" ]] && export ub_gcloud_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _gcloud_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_gcloud_cloud_server_uid=
	while [[ "$ub_gcloud_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_gcloud_cloud_server_create_API--default "$ub_gcloud_cloud_server_name" > "$cloudTmp"/reply
		
		# WARNING: WIP, Untested.
		if gcloud compute instances describe "$ub_gcloud_cloud_server_name" | grep "$ub_gcloud_cloud_server_name" > /dev/null 2>&1
		then
			export ub_gcloud_cloud_server_uid="$ub_gcloud_cloud_server_name"
		fi
		
		[[ "$ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _gcloud_cloud_server_create: miss'
	done
	[[ "$ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _gcloud_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _gcloud_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_gcloud_cloud_server_status "$ub_gcloud_cloud_server_uid"
	
	_gcloud_cloud_cred_reset
	
	return 0
}
_gcloud_cloud_server_create_API--default() {
	# https://cloud.google.com/compute/docs/instances/create-start-instance#gcloud
	gcloud compute instances create "$ub_gcloud_cloud_server_name" --image-family=debian-10 --image-project=debian-cloud --machine-type="N1 shared-core"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _gcloud_cloud_self_server_list _gcloud_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _gcloud_cloud_self_server_list _gcloud_cloud_self_server_status-filter 'workstation'
_gcloud_cloud_self_server_list() {
	_messageNormal 'init: _gcloud_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	_messagePlain_nominal 'attempt: _gcloud_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_gcloud_cloud_server_uid
	current_ub_gcloud_cloud_server_uid=
	while [[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		# WARNING: WIP, Untested.
		# WARNING: TODO
		
		#curl -X GET "https://api.gcloud.com/v4/gcloud/instances" -H "Authorization: Bearer $ub_gcloud_TOKEN" > "$cloudTmp"/reply
		#current_ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data[0].id' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _gcloud_cloud_self_server_list: miss'
	done
	[[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _gcloud_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _gcloud_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.data[].id,.data[].label'
	_stop_cloud_tmp
	_gcloud_cloud_cred_reset
	
	return 0
}



_gcloud_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _gcloud_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _gcloud_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_gcloud_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_gcloud_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_gcloud_cloud_server_uid" != "null" ]] && [[ "$ub_gcloud_cloud_server_name" != "null" ]] && [[ "$ub_gcloud_cloud_server_uid" != "" ]] && [[ "$ub_gcloud_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_gcloud_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			# WARNING: WIP, Untested.
			
			while ! gcloud compute instances delete "$ub_gcloud_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_gcloud_cloud_server_uid=
		export ub_gcloud_cloud_server_name=
		
		ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_gcloud_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_gcloud_cloud_server_uid
		_messagePlain_probe_var ub_gcloud_cloud_server_name
		
	done
	_messagePlain_good  'done: _gcloud_cloud_self_server_dispose-filter'
	
	return 0
}


_gcloud_cloud_self_server_status-filter() {
	_messageNormal 'init: _gcloud_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _gcloud_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_gcloud_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_gcloud_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_gcloud_cloud_server_uid" != "null" ]] && [[ "$ub_gcloud_cloud_server_name" != "null" ]] && [[ "$ub_gcloud_cloud_server_uid" != "" ]] && [[ "$ub_gcloud_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_gcloud_cloud_server_name" | grep "$@"
		then
			_gcloud_cloud_self_server_status "$ub_gcloud_cloud_server_uid"
		fi
		
		export ub_gcloud_cloud_server_uid=
		export ub_gcloud_cloud_server_name=
		
		ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_gcloud_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_gcloud_cloud_server_uid
		_messagePlain_probe_var ub_gcloud_cloud_server_name
		
	done
	_messagePlain_good  'done: _gcloud_cloud_self_server_status-filter'
	
	return 0
}


_gcloud_cloud_self_server_status() {
	_messageNormal 'init: _gcloud_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	
	# WARNING: WIP, Untested.
	# WARNING: TODO
	
	#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_gcloud_TOKEN" "https://api.gcloud.com/v4/gcloud/instances/$ub_gcloud_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_gcloud_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.ipv4[0]' | tr -dc 'a-zA-Z0-9.:_-')
	export ub_gcloud_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.ipv6' | tr -dc 'a-zA-Z0-9.:_-')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_gcloud_cloud_server_ssh_cred=
	export ub_gcloud_cloud_server_ssh_port=
	
	export ub_gcloud_cloud_server_vnc_cred=
	export ub_gcloud_cloud_server_vnc_port=
	
	export ub_gcloud_cloud_server_serial=
	
	export ub_gcloud_cloud_server_novnc_cred=
	export ub_gcloud_cloud_server_novnc_port=
	export ub_gcloud_cloud_server_novnc_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_novnc_port"/novnc/
	export ub_gcloud_cloud_server_novnc_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_novnc_port"/novnc/
	
	export ub_gcloud_cloud_server_shellinabox_port=
	export ub_gcloud_cloud_server_shellinabox_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_shellinabox_port"/shellinabox/
	export ub_gcloud_cloud_server_shellinabox_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_gcloud_cloud_server_remotedesktopwebclient_port=
	export ub_gcloud_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_gcloud_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_gcloud_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}






























































_gcloud() {
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	local currentBin_gcloud
	currentBin_gcloud="$ub_function_override_gcloud"
	[[ "$currentBin_gcloud" == "" ]] && currentBin_gcloud=$(type -p gcloud 2> /dev/null)
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/gcloud/.ssh
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	
	# CAUTION: Highly irregular.
	
	# https://cloud.google.com/sdk/docs/configurations
	
	[[ "$currentBin_gcloud" == "" ]] && return 1
	[[ ! -e "$currentBin_gcloud" ]] && return 1
	
	_editFakeHome "$currentBin_gcloud" "$@"
}

_gcloud_reset() {
	export ub_function_override_gcloud=''
	unset ub_function_override_gcloud
	unset gcloud
}

_gcloud_set() {
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	export ub_function_override_gcloud=$(type -p gcloud 2> /dev/null)
	gcloud() {
		_gcloud "$@"
	}
}





















# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_gcloud' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'


# ###

# https://github.com/tensorflow/cloud#cluster-and-distribution-strategy-configuration
# https://www.tensorflow.org/api_docs/python/tf/distribute/OneDeviceStrategy
# https://www.tensorflow.org/guide/distributed_training
# https://colab.research.google.com/notebooks/intro.ipynb

# https://github.com/tensorflow/cloud#setup-instructions

#which gcloud

#export PROJECT_ID=<your-project-id>
#gcloud config set project $PROJECT_ID

#export SA_NAME=<your-sa-name>
#gcloud iam service-accounts create $SA_NAME
#gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --role 'roles/editor'
#gcloud iam service-accounts keys create ~/key.json --iam-account $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

#export GOOGLE_APPLICATION_CREDENTIALS=~/key.json

#BUCKET_NAME="your-bucket-name"
#REGION="us-central1"
#gcloud auth login
#gsutil mb -l $REGION gs://$BUCKET_NAME

#gcloud auth configure-docker





# https://cloud.google.com/sdk/docs/install
# https://cloud.google.com/sdk/gcloud/reference/components/update

# ###





_test_gcloud_upstream_sequence() {
	_start
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$safeTmp"
	
	
	_mustGetSudo
	! _wantSudo && return 1
	
	
	echo
	
	_gcloud --quiet components update
	
	echo
	
	cp "$scriptLocal"/upstream/google-cloud-sdk-338.0.0-linux-x86_64.tar.gz ./ > /dev/null 2>&1
	
	# ATTENTION: ATTENTION: WARNING: CAUTION: DANGER: High maintenance. Expect to break and manually update frequently!
	local currentIterations
	currentIterations=0
	while [[ $(cksum google-cloud-sdk-338.0.0-linux-x86_64.tar.gz | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9' 2> /dev/null) != '3136626824' ]]
	do
		let currentIterations="$currentIterations + 1"
		! [[ "$currentIterations" -lt 2 ]] && _stop 1
		curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-338.0.0-linux-x86_64.tar.gz
	done
	
	! tar -xpf google-cloud-sdk-338.0.0-linux-x86_64.tar.gz && _stop 1
	
	
	# WARNING: CAUTION: DANGER: Highly irregular. Replaces entire directory in 'HOME' directory after making a temporary copy for user.
	
	
	! [[ -e "$HOME" ]] && return 1
	[[ "$HOME" == "" ]] && _stop 1
	[[ "$HOME" == "/" ]] && _stop 1
	[[ "$HOME" == "-"* ]] && _stop 1
	
	if ! mkdir -p "$HOME"/'.gcloud/google-cloud-sdk'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$HOME"/'.gcloud/google-cloud-sdk'
	then
		_stop 1
	fi
	
	if ! mkdir -p "$HOME"/'.gcloud/google-cloud-sdk_bak'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$HOME"/'.gcloud/google-cloud-sdk_bak'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$safeTmp"/'google-cloud-sdk'
	then
		_stop 1
	fi
	
	sudo -n rsync -ax --delete "$HOME"/'.gcloud/google-cloud-sdk'/. "$HOME"/'.gcloud/google-cloud-sdk_bak'/.
	sudo -n rsync -ax --delete "$safeTmp"/'google-cloud-sdk'/. "$HOME"/'.gcloud/google-cloud-sdk'/.
	
	
	cd "$HOME"/'.gcloud'/
	
	#export CLOUDSDK_ROOT_DIR="$HOME"/google-cloud-sdk
	
	./google-cloud-sdk/install.sh --help
	
	./google-cloud-sdk/install.sh --quiet --usage-reporting false --command-completion false --path-update false
	
	#./google-cloud-sdk/bin/gcloud init
	
	cd "$safeTmp"
	
	echo
	
	_gcloud --quiet config set disable_usage_reporting false
	
	echo
	
	_gcloud --quiet components update

	echo
	
	
	
	cd "$functionEntryPWD"
	_stop
}






_test_gcloud() {
	_getDep 'python3'
	_getDep 'pip'
	
	if [[ "$nonet" != "true" ]] && cat /etc/issue 2> /dev/null | grep 'Debian' > /dev/null 2>&1
	then
		_messagePlain_request 'ignore: upstream progress ->'
		"$scriptAbsoluteLocation" _test_gcloud_upstream_sequence "$@"
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		[[ -e "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc ]] && . "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		[[ -e "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc ]] && . "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	#_wantSudo && _wantGetDep gcloud
	
	
	! _typeDep gcloud && echo 'warn: missing: gcloud'
	
	
	
	return 0
}








#ibm

#oracle

#azure

#digitalocean

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .


# https://docs.digitalocean.com/reference/api/example-usage/
# https://developers.digitalocean.com/documentation/v2/#introduction

# https://developers.digitalocean.com/documentation/spaces/

# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_digitalocean_cloud_cred() {
	export ub_digitalocean_TOKEN=''
}
_digitalocean_cloud_cred_reset() {
	export ub_digitalocean_TOKEN=''
}




# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_digitalocean_cloud_server_name
_digitalocean_cloud_server_create() {
	_messageNormal 'init: _digitalocean_cloud_server_create'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	export ub_digitalocean_cloud_server_name="$1"
	[[ "$ub_digitalocean_cloud_server_name" == "" ]] && export ub_digitalocean_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _digitalocean_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_digitalocean_cloud_server_uid=
	while [[ "$ub_digitalocean_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_digitalocean_cloud_server_create_API--nyc3_s-1vcpu-1gb_ubuntu-20-04-x64 "$ub_digitalocean_cloud_server_name" > "$cloudTmp"/reply
		export ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplet.'id | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _digitalocean_cloud_server_create: miss'
	done
	[[ "$ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _digitalocean_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _digitalocean_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_digitalocean_cloud_server_status "$ub_digitalocean_cloud_server_uid"
	
	_digitalocean_cloud_cred_reset
	
	return 0
}
_digitalocean_cloud_server_create_API--nyc3_s-1vcpu-1gb_ubuntu-20-04-x64() {
	curl -X POST "https://api.digitalocean.com/v2/droplets" -d '{"name":"'"$ub_digitalocean_cloud_server_name"'","region":"nyc3","size":"s-1vcpu-1gb","image":"ubuntu-20-04-x64"}' -H "Authorization: Bearer $ub_digitalocean_TOKEN" -H "Content-Type: application/json"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.droplets[0].id,.droplets[0].name' )
# EXAMPLE: _digitalocean_cloud_self_server_list _digitalocean_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _digitalocean_cloud_self_server_list _digitalocean_cloud_self_server_status-filter 'workstation'
_digitalocean_cloud_self_server_list() {
	_messageNormal 'init: _digitalocean_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	_messagePlain_nominal 'attempt: _digitalocean_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_digitalocean_cloud_server_uid
	current_ub_digitalocean_cloud_server_uid=
	while [[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		curl -X GET "https://api.digitalocean.com/v2/droplets" -H "Authorization: Bearer $ub_digitalocean_TOKEN" > "$cloudTmp"/reply
		current_ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets[0].id' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _digitalocean_cloud_self_server_list: miss'
	done
	[[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _digitalocean_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _digitalocean_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.droplets[].id,.droplets[].name'
	_stop_cloud_tmp
	_digitalocean_cloud_cred_reset
	
	return 0
}



_digitalocean_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _digitalocean_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _digitalocean_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_digitalocean_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_digitalocean_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_digitalocean_cloud_server_uid" != "null" ]] && [[ "$ub_digitalocean_cloud_server_name" != "null" ]] && [[ "$ub_digitalocean_cloud_server_uid" != "" ]] && [[ "$ub_digitalocean_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_digitalocean_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			#while ! curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/""$ub_digitalocean_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			while ! curl -I -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/""$ub_digitalocean_cloud_server_uid" | grep '204 No Content' > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_digitalocean_cloud_server_uid=
		export ub_digitalocean_cloud_server_name=
		
		ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_digitalocean_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].name' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_digitalocean_cloud_server_uid
		_messagePlain_probe_var ub_digitalocean_cloud_server_name
		
	done
	_messagePlain_good  'done: _digitalocean_cloud_self_server_dispose-filter'
	
	return 0
}


_digitalocean_cloud_self_server_status-filter() {
	_messageNormal 'init: _digitalocean_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _digitalocean_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_digitalocean_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_digitalocean_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_digitalocean_cloud_server_uid" != "null" ]] && [[ "$ub_digitalocean_cloud_server_name" != "null" ]] && [[ "$ub_digitalocean_cloud_server_uid" != "" ]] && [[ "$ub_digitalocean_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_digitalocean_cloud_server_name" | grep "$@"
		then
			_digitalocean_cloud_self_server_status "$ub_digitalocean_cloud_server_uid"
		fi
		
		export ub_digitalocean_cloud_server_uid=
		export ub_digitalocean_cloud_server_name=
		
		ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_digitalocean_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].name' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_digitalocean_cloud_server_uid
		_messagePlain_probe_var ub_digitalocean_cloud_server_name
		
	done
	_messagePlain_good  'done: _digitalocean_cloud_self_server_status-filter'
	
	return 0
}


_digitalocean_cloud_self_server_status() {
	_messageNormal 'init: _digitalocean_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	
	curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/$ub_digitalocean_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_digitalocean_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.droplet.networks.v4[0].ip_address' | tr -dc 'a-zA-Z0-9.:_-')
	export ub_digitalocean_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.droplet.networks.v6[0].ip_address' | tr -dc 'a-zA-Z0-9.:_-')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_digitalocean_cloud_server_ssh_cred=
	export ub_digitalocean_cloud_server_ssh_port=
	
	export ub_digitalocean_cloud_server_vnc_cred=
	export ub_digitalocean_cloud_server_vnc_port=
	
	export ub_digitalocean_cloud_server_serial=
	
	export ub_digitalocean_cloud_server_novnc_cred=
	export ub_digitalocean_cloud_server_novnc_port=
	export ub_digitalocean_cloud_server_novnc_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_novnc_port"/novnc/
	export ub_digitalocean_cloud_server_novnc_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_novnc_port"/novnc/
	
	export ub_digitalocean_cloud_server_shellinabox_port=
	export ub_digitalocean_cloud_server_shellinabox_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_shellinabox_port"/shellinabox/
	export ub_digitalocean_cloud_server_shellinabox_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_digitalocean_cloud_server_remotedesktopwebclient_port=
	export ub_digitalocean_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_digitalocean_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_digitalocean_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}










_test_digitalocean_cloud() {
	_getDep curl
	
	# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
	_getDep jq
}



#linode

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_linode_cloud_cred() {
	export ub_linode_TOKEN=''
}
_linode_cloud_cred_reset() {
	export ub_linode_TOKEN=''
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_linode_cloud_server_name
_linode_cloud_server_create() {
	_messageNormal 'init: _linode_cloud_server_create'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	export ub_linode_cloud_server_name="$1"
	[[ "$ub_linode_cloud_server_name" == "" ]] && export ub_linode_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _linode_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_linode_cloud_server_uid=
	while [[ "$ub_linode_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_linode_cloud_server_create_API--us-east_g5-standard-2_debian9 "$ub_linode_cloud_server_name" > "$cloudTmp"/reply
		export ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.'id | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$ub_linode_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _linode_cloud_server_create: miss'
	done
	[[ "$ub_linode_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _linode_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _linode_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_linode_cloud_server_status "$ub_linode_cloud_server_uid"
	
	_linode_cloud_cred_reset
	
	return 0
}
_linode_cloud_server_create_API--us-east_g5-standard-2_debian9() {
	# WARNING: Random 'root' 'password' by default - expect to use SSH instead.
	curl -X POST "https://api.linode.com/v4/linode/instances" -H "Authorization: Bearer $ub_linode_TOKEN" -H "Content-type: application/json" -d '{"type": "g5-standard-2", "region": "us-east", "image": "linode/debian9", "root_pass": "'$(_uid 18)'", "label": "'"$ub_linode_cloud_server_name"'"}'
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _linode_cloud_self_server_list _linode_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _linode_cloud_self_server_list _linode_cloud_self_server_status-filter 'workstation'
_linode_cloud_self_server_list() {
	_messageNormal 'init: _linode_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	_messagePlain_nominal 'attempt: _linode_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_linode_cloud_server_uid
	current_ub_linode_cloud_server_uid=
	while [[ "$current_ub_linode_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		curl -X GET "https://api.linode.com/v4/linode/instances" -H "Authorization: Bearer $ub_linode_TOKEN" > "$cloudTmp"/reply
		current_ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data[0].id' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_linode_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _linode_cloud_self_server_list: miss'
	done
	[[ "$current_ub_linode_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _linode_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _linode_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.data[].id,.data[].label'
	_stop_cloud_tmp
	_linode_cloud_cred_reset
	
	return 0
}



_linode_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _linode_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _linode_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_linode_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_linode_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_linode_cloud_server_uid" != "null" ]] && [[ "$ub_linode_cloud_server_name" != "null" ]] && [[ "$ub_linode_cloud_server_uid" != "" ]] && [[ "$ub_linode_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_linode_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			while ! curl -I -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_linode_TOKEN" "https://api.linode.com/v4/linode/instances/""$ub_linode_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_linode_cloud_server_uid=
		export ub_linode_cloud_server_name=
		
		ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_linode_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_linode_cloud_server_uid
		_messagePlain_probe_var ub_linode_cloud_server_name
		
	done
	_messagePlain_good  'done: _linode_cloud_self_server_dispose-filter'
	
	return 0
}


_linode_cloud_self_server_status-filter() {
	_messageNormal 'init: _linode_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _linode_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_linode_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_linode_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_linode_cloud_server_uid" != "null" ]] && [[ "$ub_linode_cloud_server_name" != "null" ]] && [[ "$ub_linode_cloud_server_uid" != "" ]] && [[ "$ub_linode_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_linode_cloud_server_name" | grep "$@"
		then
			_linode_cloud_self_server_status "$ub_linode_cloud_server_uid"
		fi
		
		export ub_linode_cloud_server_uid=
		export ub_linode_cloud_server_name=
		
		ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_linode_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_linode_cloud_server_uid
		_messagePlain_probe_var ub_linode_cloud_server_name
		
	done
	_messagePlain_good  'done: _linode_cloud_self_server_status-filter'
	
	return 0
}


_linode_cloud_self_server_status() {
	_messageNormal 'init: _linode_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	
	curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_linode_TOKEN" "https://api.linode.com/v4/linode/instances/$ub_linode_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_linode_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.ipv4[0]' | tr -dc 'a-zA-Z0-9.:_-')
	export ub_linode_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.ipv6' | tr -dc 'a-zA-Z0-9.:_-')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_linode_cloud_server_ssh_cred=
	export ub_linode_cloud_server_ssh_port=
	
	export ub_linode_cloud_server_vnc_cred=
	export ub_linode_cloud_server_vnc_port=
	
	export ub_linode_cloud_server_serial=
	
	export ub_linode_cloud_server_novnc_cred=
	export ub_linode_cloud_server_novnc_port=
	export ub_linode_cloud_server_novnc_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_novnc_port"/novnc/
	export ub_linode_cloud_server_novnc_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_novnc_port"/novnc/
	
	export ub_linode_cloud_server_shellinabox_port=
	export ub_linode_cloud_server_shellinabox_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_shellinabox_port"/shellinabox/
	export ub_linode_cloud_server_shellinabox_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_linode_cloud_server_remotedesktopwebclient_port=
	export ub_linode_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_linode_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_linode_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}










_test_linode_cloud() {
	_getDep curl
	
	# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
	_getDep jq
}






























#aws_s3_compatible

#blackblaze

#apacheLibcloud

# https://www.pixelite.co.nz/article/using-apache-libcloud-provision-cloud-servers/

#nubo

# https://pythonhosted.org/nubo/

#rclone




# ATTENTION: Intended to be used by '_index' shortcuts as with 'cautossh' '_setup' .
_rclone() {
	local currentBin_rclone
	currentBin_rclone="$ub_function_override_rclone"
	[[ "$currentBin_rclone" == "" ]] && currentBin_rclone=$(type -p rclone 2> /dev/null)
	
	mkdir -p "$scriptLocal"/rclone
	[[ ! -e "$scriptLocal"/rclone ]] && return 1
	[[ ! -d "$scriptLocal"/rclone ]] && return 1
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	#env XDG_CONFIG_HOME="$scriptLocal"/rclone HOME="$scriptLocal"/rclone rclone --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
	#env XDG_CONFIG_HOME="$scriptLocal"/rclone rclone --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
	
	# https://forum.rclone.org/t/how-to-change-rclone-config-location-windows/13073
	#export RCLONE_CONFIG="$scriptLocal"/rclone/rclone/rclone.conf
	#env RCLONE_CONFIG="$scriptLocal"/rclone/rclone/rclone.conf XDG_CONFIG_HOME="$scriptLocal"/rclone "$currentBin_rclone" --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
	
	env XDG_CONFIG_HOME="$scriptLocal"/rclone "$currentBin_rclone" --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
}

_rclone_reset() {
	export ub_function_override_rclone=''
	unset ub_function_override_rclone
	unset rclone
}

# ATTENTION: Intended to be called from '_cloud_set' or similar, in turn called by '_cloud_hook', in turn used by '_index' shortcuts as with 'cautossh' '_setup' .
_rclone_set() {
	export ub_function_override_rclone=$(type -p rclone 2> /dev/null)
	rclone() {
		_rclone "$@"
	}
}









# https://en.wikipedia.org/wiki/Rclone
# https://par.nsf.gov/servlets/purl/10073416
# https://www.chpc.utah.edu/documentation/software/rclone.php#eteooop

# https://packages.debian.org/sid/rclone
# https://rclone.org/downloads/

# https://linuxaria.com/howto/how-to-install-a-single-package-from-debian-sid-or-debian-testing
# https://askubuntu.com/questions/27362/how-to-only-install-updates-from-a-specific-repository

# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_rclone' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'

# WARNING: Infinite loop risk, do not call '_wantGetDep rclone' within this function.
_test_rclone_upstream_beta() {
	! _wantSudo && return 1
	
	echo
	curl https://rclone.org/install.sh | sudo bash -s beta
	echo
}

# WARNING: Infinite loop risk, do not call '_wantGetDep rclone' within this function.
_test_rclone_upstream() {
	! _wantSudo && return 1
	
	echo
	curl https://rclone.org/install.sh | sudo bash
	echo
}


_test_rclone() {
	if [[ "$nonet" != "true" ]] && ! _if_cygwin
	then
		_messagePlain_request 'ignore: upstream progress ->'
		
		_test_rclone_upstream "$@"
		#_test_rclone_upstream_beta "$@"
		
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	_wantSudo && _wantGetDep rclone
	
	! _typeDep rclone && echo 'warn: missing: rclone'
	
	return 0
}





#paramiko

#terraform

# https://en.wikipedia.org/wiki/Terraform_(software)
# https://www.terraform.io/docs/language/index.html
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started




_test_terraform() {
	_wantGetDep gpg
	_wantGetDep python3/dist-packages/softwareproperties/dbus/SoftwarePropertiesDBus.py
	_wantGetDep curl
	
	_wantGetDep terraform
	
	#! _typeDep terraform && echo 'warn: missing: terraform'
	if ! _typeDep terraform || ! terraform -help 2>/dev/null | grep 'terraform' > /dev/null 2>&1
	then
		echo 'warn: missing: terraform'
		return 1
	fi
	
	return 0
}

#cloud

# ATTENTION: Highly irregular means of keeping temporary data from cloud replies to API queries, due to the expected high probability of failures.
_start_cloud_tmp() {
	export ub_cloudTmp_id=$(_uid)
	export ub_cloudTmp="$scriptLocal"/cloud/cloudTmp/"$cloudTmp_id"
	
	#mkdir -p "$scriptLocal"/cloud/cloudTmp
	#! [[ -e "$scriptLocal"/cloud/cloudTmp ]] && _messageFAIL && _stop 1
	#! [[ -d "$scriptLocal"/cloud/cloudTmp ]] && _messageFAIL && _stop 1
	
	mkdir -p "$ub_cloudTmp"
	! [[ -e "$ub_cloudTmp" ]] && _messageFAIL && _stop 1
	! [[ -d "$ub_cloudTmp" ]] && _messageFAIL && _stop 1
	
	echo '*' > "$scriptLocal"/cloud/cloudTmp/.gitignore
	
	return 0
}
# WARNING: Do NOT call from '_stop' !
# WARNING: *Requires* variable "$ub_cloudTmp" to have been exported/set by '_start_cloud_tmp' !
_stop_cloud_tmp() {
	[[ "$cloudTmp" == "" ]] && return 1
	! [[ -e "$cloudTmp" ]] && return 1
	! [[ -d "$cloudTmp" ]] && return 1
	
	_safeRMR "$ub_cloudTmp" > /dev/null 2>&1
	
	return 0
}




_cloud_hook_here() {
	cat << CZXWXcRMTo8EmM8i4d
	. "$scriptAbsoluteLocation" --profile _importShortcuts
	_cloud_set
	_cloudPrompt
	
CZXWXcRMTo8EmM8i4d
}


_cloud_hook() {
	_messageNormal "init: _cloud_hook"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	
	_cloud_hook_here > "$ubcoreDir"/cloudrc
	
	_tryExec '_aws_hook'
	_tryExec '_google_hook'
}

# WARNING: End user function. Do NOT call within scripts.
# ATTENTION: TODO: Needs to be written out with 'declare -f' to '~/bin' and/or similar during '_setup_ssh' '_index' shortcut '_setup' and/or similar.
_cloud_unhook() {
	_messageNormal "init: _cloud_unhook"
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	
	rm -f "$ubcoreDir"/cloudrc
	
	_tryExec '_google_unhook'
}

_cloud_shell() {
	#_cloudPrompt
	
	# https://unix.stackexchange.com/questions/428175/how-to-export-all-bash-functions-in-a-file-in-one-line
	#set -a
	##. "$scriptAbsoluteLocation" --parent _importShortcuts
	#. "$scriptAbsoluteLocation" --profile _importShortcuts
	#_cloud_set
	#_cloudPrompt
	#set +a
	
	# https://serverfault.com/questions/368054/run-an-interactive-bash-subshell-with-initial-commands-without-returning-to-the
	#/usr/bin/env bash --init-file <(_safeEcho ". "\"$scriptAbsoluteLocation\"" --profile _importShortcuts ; _cloud_set ; _cloudPrompt")
	/usr/bin/env bash --init-file <(_cloud_hook_here)
}



_cloudPrompt() {
	export prompt_cloudNetName='(cloud-'"$netName"')-'
	
	_visualPrompt
	
	#cloud-$netName
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(cloud-$netName)-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
}


_cloud_set() {
	_rclone_set "$@"
	
	_aws_set "$@"
	_aws_eb_set "$@"
	
	_gcloud_set
	
	
	
	_cloudPrompt "$@"
}


_cloud_reset() {
	_rclone_reset "$@"
	
	_aws_reset "$@"
	_aws_eb_reset "$@"
	
	_gcloud_reset
	
	
	
	_visualPrompt
}







_test_cloud() {
	
	
	_tryExec '_test_digitalocean_cloud'
	_tryExec '_test_linode_cloud'
	
	_tryExec '_test_aws'
	_tryExec '_test_gcloud'
	
	_tryExec '_test_ubVirt'
	_tryExec '_test_phpvirtualbox_self'
	_tryExec '_test_virtualbox_self'
	
	
	return 0
}

#cloud_abstraction
# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.


# ATTENTION: In practice, this duplicates the functionality of Cloud service 'control panel' GUI , VirtualBox GUI , VMWare GUI , etc. Intended as an abstraction layer for VM custom image building or VR access through non-web UI.






# ATTENTION: Many providers (eg. Linode ) offer a WebUI , in which case any 'cloud API' may be most useful only for automation or to create VMs more quickly.
# DigitalOcean 'Droplet Console' was less effective. Apparently 'lightdm' is required and mouse input is inaccurate.
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-remote-desktop-with-x2go-on-ubuntu-20-04


# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# ATTENTION: Although primarily intended for 'cloud' this is equally applicable to 'self' networks created by 'copying' the appropriate "ubiquitous_bash.sh" and 'vm.img' files to separate directories and such. The 'CLI' for such a cloud could be using a filesystem location for such 'image' files as the equivalent of 'credentials' to create new VMs.
_cloud_server_create() {
	true
	
	
	_cloud_server_status
}


# List 'cloud' 'servers' .
_cloud_server_list() {
	true
}


# Determine if a 'named' or 'uniqueid' 'cloud' 'server' is working correctly and able to report (presumably by either by serial/IPC or public ipv4/ipv6) own IP addresses and such for access to an 'internal' 'graphical console'. With a valid result, automation or remote control is expected to be available.
_cloud_server_status() {
	true
	
	# ATTENTION: Many providers (eg. Linode ) offer a WebUI , in which case any 'cloud API' may be most useful only to create VMs more quickly.
	
	#export_ub_cloud_server_service_url
	
	#export ub_cloud_server_addr_ipv4
	#export ub_cloud_server_addr_ipv6
	
	#export ub_cloud_server_ssh_cred
	#export ub_cloud_server_ssh_port
	
	#export ub_cloud_server_vnc_cred
	#export ub_cloud_server_vnc_port
	
	#export ub_cloud_server_serial
	
	#export ub_cloud_server_novnc_cred
	#export_ub_cloud_server_novnc_port
	#export ub_cloud_server_novnc_url_ipv4
	#export ub_cloud_server_novnc_url_ipv6
	
	#export ub_cloud_server_shellinabox_port
	#export ub_cloud_server_shellinabox_url_ipv4
	#export ub_cloud_server_shellinabox_url_ipv6
	
	#export ub_cloud_server_remotedesktopwebclient_port
	#export ub_cloud_server_remotedesktopwebclient_url_ipv4
	#export ub_cloud_server_remotedesktopwebclient_url_ipv6
}












#vagrant_build

# WARNING: DANGER: Always use '_custom' from '_lib/kit/raspi' in addition to any 'cloud' built data (or otherwise dependent on cloud to built data) to ensure adequate completeness.






_test_vagrant_build() {
	#sudo -n usermod --append --groups libvirt $USER
	
	_wantGetDep systemd/system/libvirtd.service
	
	#libvirt-daemon
	_wantGetDep libvirt/libvirt-guests.sh
	_wantGetDep libvirt/connection-driver/libvirt_driver_qemu.so
	
	#libvirt-clients
	_wantGetDep virsh
	
	! _typeShare 'vagrant-plugins/plugins.d/vagrant-libvirt.json' && _wantGetDep 'vagrant-plugins/plugins.d/vagrant-libvirt.json'
	_wantGetDep vagrant
}

_testDistro() {
	_wantGetDep sha256sum
	_wantGetDep sha512sum
	_wantGetDep axel
}

_kernelConfig_list_here() {
	cat << CZXWXcRMTo8EmM8i4d



CZXWXcRMTo8EmM8i4d
}





_kernelConfig_reject-comments() {
	grep -v '^\#\|\#'
}

_kernelConfig_request() {
	local current_kernelConfig_statement
	current_kernelConfig_statement=$(cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=' | tr -dc 'a-zA-Z0-9\=\_')
	
	_messagePlain_request 'hazard: '"$1"': '"$current_kernelConfig_statement"
}


_kernelConfig_require-yes() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 0
	return 1
}

_kernelConfig_require-module-or-yes() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=m' > /dev/null 2>&1 && return 0
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 0
	return 1
}

# DANGER: Currently assuming lack of an entry is equivalent to option set as '=n' with make menuconfig or similar.
_kernelConfig_require-no() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=m' > /dev/null 2>&1 && return 1
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 1
	return 0
}


_kernelConfig_warn-y__() {
	_kernelConfig_require-yes "$1" && return 0
	_messagePlain_warn 'warn: not:    Y: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-y_m() {
	_kernelConfig_require-module-or-yes "$1" && return 0
	_messagePlain_warn 'warn: not:  M/Y: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-n__() {
	_kernelConfig_require-no "$1" && return 0
	_messagePlain_warn 'warn: not:    N: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-any() {
	_kernelConfig_warn-y_m "$1"
	_kernelConfig_warn-n__ "$1"
}

_kernelConfig__bad-y__() {
	_kernelConfig_require-yes "$1" && return 0
	_messagePlain_bad 'bad: not:     Y: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig__bad-y_m() {
	_kernelConfig_require-module-or-yes "$1" && return 0
	_messagePlain_bad 'bad: not:   M/Y: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig__bad-n__() {
	_kernelConfig_require-no "$1" && return 0
	_messagePlain_bad 'bad: not:     N: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig_require-tradeoff-legacy() {
	_messagePlain_nominal 'kernelConfig: tradeoff-legacy'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-legacy'\'' for specific use cases.'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-n__ LEGACY_VSYSCALL_EMULATE
}

# WARNING: Risk must be evaluated for specific use cases.
# WARNING: Insecure.
# Standalone simulators (eg. flight sim):
# * May have hard real-time frame latency limits within 10% of the fastest avaialble from a commercially avaialble CPU.
# * May be severely single-thread CPU constrained.
# * May have real-time workloads exactly matching those suffering half performance due to security mitigations.
# * May not require real-time security mitigations.
# Disabling hardening may as much as double performance for some workloads.
# https://www.phoronix.com/scan.php?page=article&item=linux-retpoline-benchmarks&num=2
# https://www.phoronix.com/scan.php?page=article&item=linux-416early-spectremelt&num=4
_kernelConfig_require-tradeoff-perform() {
	_messagePlain_nominal 'kernelConfig: tradeoff-perform'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-perform'\'' for specific use cases.'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-n__ CONFIG_RETPOLINE
	_kernelConfig__bad-n__ CONFIG_PAGE_TABLE_ISOLATION
	_kernelConfig__bad-n__ CONFIG_X86_SMAP
	
	_kernelConfig_warn-n__ AMD_MEM_ENCRYPT
	
	_kernelConfig__bad-y__ CONFIG_X86_INTEL_TSX_MODE_ON
}

# WARNING: Risk must be evaluated for specific use cases.
# WARNING: BREAKS some high-performance real-time applicatons (eg. flight sim, VR, AR).
# Standalone simulators (eg. flight sim):
# * May have hard real-time frame latency limits within 10% of the fastest avaialble from a commercially avaialble CPU.
# * May be severely single-thread CPU constrained.
# * May have real-time workloads exactly matching those suffering half performance due to security mitigations.
# * May not require real-time security mitigations.
# Disabling hardening may as much as double performance for some workloads.
# https://www.phoronix.com/scan.php?page=article&item=linux-retpoline-benchmarks&num=2
# https://www.phoronix.com/scan.php?page=article&item=linux-416early-spectremelt&num=4
_kernelConfig_require-tradeoff-harden() {
	_messagePlain_nominal 'kernelConfig: tradeoff-harden'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-harden'\'' for specific use cases.'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_RETPOLINE
	_kernelConfig__bad-y__ CONFIG_PAGE_TABLE_ISOLATION
	_kernelConfig__bad-y__ CONFIG_X86_SMAP
	
	# Uncertain.
	#_kernelConfig_warn-y__ AMD_MEM_ENCRYPT
	
	_kernelConfig__bad-y__ CONFIG_X86_INTEL_TSX_MODE_OFF
}

# ATTENTION: Override with 'ops.sh' or similar.
_kernelConfig_require-tradeoff() {
	_kernelConfig_require-tradeoff-legacy "$@"
	
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	
	if [[ "$kernelConfig_tradeoff_perform" == 'true' ]]
	then
		_kernelConfig_require-tradeoff-perform "$@"
		return
	fi
	
	_kernelConfig_require-tradeoff-harden "$@"
	return
}

# Based on kernel config documentation and Debian default config.
_kernelConfig_require-virtualization-accessory() {
	_messagePlain_nominal 'kernelConfig: virtualization-accessory'
	export kernelConfig_file="$1"
	
	_kernelConfig_warn-y_m CONFIG_KVM
	_kernelConfig_warn-y_m CONFIG_KVM_INTEL
	_kernelConfig_warn-y_m CONFIG_KVM_AMD
	
	_kernelConfig_warn-y__ CONFIG_KVM_AMD_SEV
	
	_kernelConfig_warn-y_m CONFIG_VHOST_NET
	_kernelConfig_warn-y_m CONFIG_VHOST_SCSI
	_kernelConfig_warn-y_m CONFIG_VHOST_VSOCK
	
	_kernelConfig__bad-y_m DRM_VMWGFX
	
	_kernelConfig__bad-n__ CONFIG_VBOXGUEST
	_kernelConfig__bad-n__ CONFIG_DRM_VBOXVIDEO
	
	_kernelConfig_warn-y__ VIRTIO_MENU
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI_LEGACY
	_kernelConfig__bad-y_m CONFIG_VIRTIO_BALLOON
	_kernelConfig__bad-y_m CONFIG_VIRTIO_INPUT
	_kernelConfig__bad-y_m CONFIG_VIRTIO_MMIO
	_kernelConfig_warn-y__ CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES
	
	_kernelConfig_warn-y_m CONFIG_DRM_VIRTIO_GPU
	
	# Uncertain. Apparently new feature.
	_kernelConfig_warn-y_m CONFIG_VIRTIO_FS
	
	_kernelConfig_warn-y_m CONFIG_HYPERV
	_kernelConfig_warn-y_m CONFIG_HYPERV_UTILS
	_kernelConfig_warn-y_m CONFIG_HYPERV_BALLOON
	
	_kernelConfig_warn-y__ CONFIG_XEN_BALLOON
	_kernelConfig_warn-y__ CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
	_kernelConfig_warn-y__ CONFIG_XEN_SCRUB_PAGES_DEFAULT
	_kernelConfig__bad-y_m CONFIG_XEN_DEV_EVTCHN
	_kernelConfig_warn-y__ CONFIG_XEN_BACKEND
	_kernelConfig__bad-y_m CONFIG_XENFS
	_kernelConfig_warn-y__ CONFIG_XEN_COMPAT_XENFS
	_kernelConfig_warn-y__ CONFIG_XEN_SYS_HYPERVISOR
	_kernelConfig__bad-y_m CONFIG_XEN_SYS_HYPERVISOR
	_kernelConfig__bad-y_m CONFIG_XEN_GRANT_DEV_ALLOC
	_kernelConfig__bad-y_m CONFIG_XEN_PCIDEV_BACKEND
	_kernelConfig__bad-y_m CONFIG_XEN_SCSI_BACKEND
	_kernelConfig__bad-y_m CONFIG_XEN_ACPI_PROCESSOR
	_kernelConfig_warn-y__ CONFIG_XEN_MCE_LOG
	_kernelConfig_warn-y__ CONFIG_XEN_SYMS
	
	_kernelConfig_warn-y__ CONFIG_DRM_XEN
	
	# Uncertain.
	#_kernelConfig_warn-n__ CONFIG_XEN_SELFBALLOONING
	#_kernelConfig_warn-n__ CONFIG_IOMMU_DEFAULT_PASSTHROUGH
	#_kernelConfig_warn-n__ CONFIG_INTEL_IOMMU_DEFAULT_ON
}

# https://wiki.gentoo.org/wiki/VirtualBox
_kernelConfig_require-virtualbox() {
	_messagePlain_nominal 'kernelConfig: virtualbox'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_X86_SYSFB
	
	_kernelConfig__bad-y__ CONFIG_ATA
	_kernelConfig__bad-y__ CONFIG_SATA_AHCI
	_kernelConfig__bad-y__ CONFIG_ATA_SFF
	_kernelConfig__bad-y__ CONFIG_ATA_BMDMA
	_kernelConfig__bad-y__ CONFIG_ATA_PIIX
	
	_kernelConfig__bad-y__ CONFIG_NETDEVICES
	_kernelConfig__bad-y__ CONFIG_ETHERNET
	_kernelConfig__bad-y__ CONFIG_NET_VENDOR_INTEL
	_kernelConfig__bad-y__ CONFIG_E1000
	
	_kernelConfig__bad-y__ CONFIG_INPUT_KEYBOARD
	_kernelConfig__bad-y__ CONFIG_KEYBOARD_ATKBD
	_kernelConfig__bad-y__ CONFIG_INPUT_MOUSE
	_kernelConfig__bad-y__ CONFIG_MOUSE_PS2
	
	_kernelConfig__bad-y__ CONFIG_DRM
	_kernelConfig__bad-y__ CONFIG_DRM_FBDEV_EMULATION
	_kernelConfig__bad-y__ CONFIG_DRM_VIRTIO_GPU
	
	_kernelConfig__bad-y__ CONFIG_FB
	_kernelConfig__bad-y__ CONFIG_FIRMWARE_EDID
	_kernelConfig__bad-y__ CONFIG_FB_SIMPLE
	
	_kernelConfig__bad-y__ CONFIG_FRAMEBUFFER_CONSOLE
	_kernelConfig__bad-y__ CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
	
	_kernelConfig__bad-y__ CONFIG_SOUND
	_kernelConfig__bad-y__ CONFIG_SND
	_kernelConfig__bad-y__ CONFIG_SND_PCI
	_kernelConfig__bad-y__ CONFIG_SND_INTEL8X0
	
	_kernelConfig__bad-y__ CONFIG_USB_SUPPORT
	_kernelConfig__bad-y__ CONFIG_USB_XHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_EHCI_HCD
}


# https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Activating_required_options
_kernelConfig_require-boot() {
	_messagePlain_nominal 'kernelConfig: boot'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_FW_LOADER
	#_kernelConfig__bad-y__ CONFIG_FIRMWARE_IN_KERNEL
	
	_kernelConfig__bad-y__ CONFIG_DEVTMPFS
	_kernelConfig__bad-y__ CONFIG_DEVTMPFS_MOUNT
	_kernelConfig__bad-y__ CONFIG_BLK_DEV_SD
	
	
	_kernelConfig__bad-y__ CONFIG_EXT4_FS
	_kernelConfig__bad-y__ CONFIG_EXT4_FS_POSIX_ACL
	_kernelConfig__bad-y__ CONFIG_EXT4_FS_SECURITY
	#_kernelConfig__bad-y__ CONFIG_EXT4_ENCRYPTION
	
	if ! _kernelConfig_warn-y__ CONFIG_EXT4_USE_FOR_EXT2 > /dev/null 2>&1
	then
		_kernelConfig__bad-y__ CONFIG_EXT2_FS
		_kernelConfig__bad-y__ CONFIG_EXT3_FS
		_kernelConfig__bad-y__ CONFIG_EXT3_FS_POSIX_ACL
		_kernelConfig__bad-y__ CONFIG_EXT3_FS_SECURITY
	else
		_kernelConfig_warn-y__ CONFIG_EXT4_USE_FOR_EXT2
	fi
	
	_kernelConfig__bad-y__ CONFIG_MSDOS_FS
	_kernelConfig__bad-y__ CONFIG_VFAT_FS
	
	_kernelConfig__bad-y__ CONFIG_PROC_FS
	_kernelConfig__bad-y__ CONFIG_TMPFS
	
	_kernelConfig__bad-y__ CONFIG_PPP
	_kernelConfig__bad-y__ CONFIG_PPP_ASYNC
	_kernelConfig__bad-y__ CONFIG_PPP_SYNC_TTY
	
	_kernelConfig__bad-y__ CONFIG_SMP
	
	# https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide
	# 'Support for Host-side USB'
	_kernelConfig__bad-y__ CONFIG_USB_SUPPORT
	_kernelConfig__bad-y__ CONFIG_USB_XHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_EHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_OHCI_HCD
	
	_kernelConfig__bad-y__ CONFIG_HID
	_kernelConfig__bad-y__ CONFIG_HID_GENERIC
	_kernelConfig__bad-y__ CONFIG_HID_BATTERY_STRENGTH
	_kernelConfig__bad-y__ CONFIG_USB_HID
	
	_kernelConfig__bad-y__ CONFIG_PARTITION_ADVANCED
	_kernelConfig__bad-y__ CONFIG_EFI_PARTITION
	
	_kernelConfig__bad-y__ CONFIG_EFI
	_kernelConfig__bad-y__ CONFIG_EFI_STUB
	_kernelConfig__bad-y__ CONFIG_EFI_MIXED
	
	_kernelConfig__bad-y__ CONFIG_EFI_VARS
}


_kernelConfig_require-arch-x64() {
	_messagePlain_nominal 'kernelConfig: arch-x64'
	export kernelConfig_file="$1"
	
	# CRITICAL! Expected to accommodate modern CPUs.
	_messagePlain_request 'request: -march=sandybridge -mtune=skylake'
	_messagePlain_request 'export KCFLAGS="-O2 -march=sandybridge -mtune=skylake -pipe"'
	_messagePlain_request 'export KCPPFLAGS="-O2 -march=sandybridge -mtune=skylake -pipe"'
	
	_kernelConfig_warn-n__ CONFIG_GENERIC_CPU
	
	_kernelConfig_request MCORE2
	
	_kernelConfig_warn-y__ CONFIG_X86_MCE
	_kernelConfig_warn-y__ CONFIG_X86_MCE_INTEL
	_kernelConfig_warn-y__ CONFIG_X86_MCE_AMD
	
	# Uncertain. May or may not improve performance.
	_kernelConfig_warn-y__ CONFIG_INTEL_RDT
	
	# Maintenance may be easier with this enabled.
	_kernelConfig_warn-y_m CONFIG_EFIVAR_FS
	
	# Presumably mixing entropy may be preferable.
	_kernelConfig__bad-n__ CONFIG_RANDOM_TRUST_CPU
	
	
	# If possible, it may be desirable to check clocksource defaults.
	
	_kernelConfig__bad-y__ X86_TSC
	
	_kernelConfig_warn-y__ HPET
	_kernelConfig_warn-y__ HPET_EMULATE_RTC
	_kernelConfig_warn-y__ HPET_MMAP
	_kernelConfig_warn-y__ HPET_MMAP_DEFAULT
	_kernelConfig_warn-y__ HPET_TIMER
	
	
	_kernelConfig__bad-y__ CONFIG_IA32_EMULATION
	_kernelConfig_warn-n__ IA32_AOUT
	_kernelConfig__bad-y__ CONFIG_X86_X32
	
	_kernelConfig__bad-y__ CONFIG_BINFMT_ELF
	_kernelConfig__bad-y_m CONFIG_BINFMT_MISC
	
	# May not have been optional under older kernel configurations.
	_kernelConfig__bad-y__ CONFIG_BINFMT_SCRIPT
}

_kernelConfig_require-accessory() {
	_messagePlain_nominal 'kernelConfig: accessory'
	export kernelConfig_file="$1"
	
	# May be critical to 'ss' tool functionality typically expected by Ubiquitous Bash.
	_kernelConfig_warn-y_m CONFIG_PACKET_DIAG
	_kernelConfig_warn-y_m CONFIG_UNIX_DIAG
	_kernelConfig_warn-y_m CONFIG_INET_DIAG
	_kernelConfig_warn-y_m CONFIG_NETLINK_DIAG
	
	# Essential for a wide variety of platforms.
	_kernelConfig_warn-y_m CONFIG_MOUSE_PS2_TRACKPOINT
	
	# Common and useful GPU features.
	_kernelConfig_warn-y_m CONFIG_DRM_RADEON
	_kernelConfig_warn-y_m CONFIG_DRM_AMDGPU
	_kernelConfig_warn-y_m CONFIG_DRM_I915
	_kernelConfig_warn-y_m CONFIG_DRM_VIA
	_kernelConfig_warn-y_m CONFIG_DRM_NOUVEAU
	
	# Uncertain.
	#_kernelConfig_warn-y__ CONFIG_IRQ_REMAP
	
	# TODO: Accessory features which may become interesting.
	#ACPI_HMAT
	#PCIE_BW
	#ACRN_GUEST
	#XILINX SDFEC
}

_kernelConfig_require-build() {
	_messagePlain_nominal 'kernelConfig: build'
	export kernelConfig_file="$1"
	
	# May cause failure if set incorrectly.
	if ! cat "$kernelConfig_file" | grep 'CONFIG_SYSTEM_TRUSTED_KEYS\=\"\"' > /dev/null 2>&1 && ! cat "$kernelConfig_file" | grep -v 'CONFIG_SYSTEM_TRUSTED_KEYS' > /dev/null 2>&1
	then
		#_messagePlain_bad 'bad: not:    Y: '"$1"
		 _messagePlain_bad 'bad: not:    _: 'CONFIG_SYSTEM_TRUSTED_KEYS
	fi
	
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
# ATTENTION: Dependency of '_kernelConfig_require-latency' .
_kernelConfig_require-latency_frequency() {
	# High HZ rate (ie. HZ 1000) may be preferable for machines directly rendering simulator/VR graphics.
	# Theoretically graphics VSYNC might prefer HZ 300 or similar, as a multiple of common graphics refresh rates.
	# 25,~29.97,30,60=300 60,72=360 60,75=300 60,80=240 32,36,64,72=576
	# Theoretically, a setting of 250 may be beneficial for virtualization where the host kernel may be 1000 .
	# Typically values: 250,300,1000 .
	# https://passthroughpo.st/config_hz-how-does-it-affect-kvm/
	# https://github.com/vmprof/vmprof-python/issues/163
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	
	
	if ! cat "$kernelConfig_file" | grep 'HZ='"$kernelConfig_frequency" > /dev/null 2>&1
	then
		#_messagePlain_bad  'bad: not:     Y: '"$1"
		#_messagePlain_warn 'warn: not:    Y: '"$1"
		 _messagePlain_bad 'bad: not:   '"$kernelConfig_frequency"': 'HZ
	fi
	_kernelConfig__bad-y__ HZ_"$kernelConfig_frequency"
}

_kernelConfig_require-latency() {
	_messagePlain_nominal 'kernelConfig: latency'
	export kernelConfig_file="$1"
	
	# Uncertain. Default off per Debian config.
	_kernelConfig_warn-n__ CONFIG_X86_GENERIC
	
	# CRITICAL!
	_kernelConfig__bad-y__ CPU_FREQ_DEFAULT_GOV_ONDEMAND
	_kernelConfig__bad-y__ CONFIG_CPU_FREQ_GOV_ONDEMAND
	
	# CRITICAL!
	# CONFIG_PREEMPT is significantly more stable and compatible with third party (eg. VirtualBox) modules.
	# CONFIG_PREEMPT_RT is significantly less likely to incurr noticeable worst-case latency.
	# Lack of both CONFIG_PREEMPT and CONFIG_PREEMPT_RT may incurr noticeable worst-case latency.
	_kernelConfig_request CONFIG_PREEMPT
	_kernelConfig_request CONFIG_PREEMPT_RT
	if ! _kernelConfig__bad-y__ CONFIG_PREEMPT_RT > /dev/null 2>&1 && ! _kernelConfig__bad-y__ CONFIG_PREEMPT > /dev/null 2>&1 
	then
		_kernelConfig__bad-y__ CONFIG_PREEMPT
		_kernelConfig__bad-y__ CONFIG_PREEMPT_RT
	fi
	
	_kernelConfig_require-latency_frequency "$@"
	
	# Dynamic/Tickless kernel *might* be the cause of irregular display updates on some platforms.
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	if [[ "$kernelConfig_tickless" == 'true' ]]
	then
		#_kernelConfig__bad-n__ CONFIG_HZ_PERIODIC
		#_kernelConfig__bad-y__ CONFIG_NO_HZ
		#_kernelConfig__bad-y__ CONFIG_NO_HZ_COMMON
		#_kernelConfig__bad-y__ CONFIG_NO_HZ_FULL
		_kernelConfig__bad-y__ CONFIG_NO_HZ_IDLE
		#_kernelConfig__bad-y__ CONFIG_RCU_FAST_NO_HZ
	else
		_kernelConfig__bad-y__ CONFIG_HZ_PERIODIC
		_kernelConfig__bad-n__ CONFIG_NO_HZ
		_kernelConfig__bad-n__ CONFIG_NO_HZ_COMMON
		_kernelConfig__bad-n__ CONFIG_NO_HZ_FULL
		_kernelConfig__bad-n__ CONFIG_NO_HZ_IDLE
		_kernelConfig__bad-n__ CONFIG_RCU_FAST_NO_HZ
		
		_kernelConfig__bad-y__ CPU_IDLE_GOV_MENU
	fi
	
	# Essential.
	_kernelConfig__bad-y__ CONFIG_LATENCYTOP
	
	
	# CRITICAL!
	_kernelConfig__bad-y__ CONFIG_CGROUP_SCHED
	_kernelConfig__bad-y__ FAIR_GROUP_SCHED
	_kernelConfig__bad-y__ CONFIG_CFS_BANDWIDTH
	
	# CRITICAL!
	# Expected to protect single-thread interactive applications from competing multi-thread workloads.
	_kernelConfig__bad-y__ CONFIG_SCHED_AUTOGROUP
	
	
	# CRITICAL!
	# Default cannot be set currently.
	_messagePlain_request 'request: Set '\''bfq'\'' as default IO scheduler (strongly recommended).'
	#_kernelConfig__bad-y__ DEFAULT_IOSCHED
	#_kernelConfig__bad-y__ DEFAULT_BFQ
	
	# CRITICAL!
	# Expected to protect interactive applications from background IO.
	# https://www.youtube.com/watch?v=ANfqNiJVoVE
	_kernelConfig__bad-y__ CONFIG_IOSCHED_BFQ
	_kernelConfig__bad-y__ CONFIG_BFQ_GROUP_IOSCHED
	
	
	# Uncertain.
	# https://forum.manjaro.org/t/please-enable-writeback-throttling-by-default-linux-4-10/18135/22
	#_kernelConfig__bad-y__ BLK_WBT
	#_kernelConfig__bad-y__ BLK_WBT_MQ
	#_kernelConfig__bad-y__ BLK_WBT_SQ
	
	
	# https://lwn.net/Articles/789304/
	_kernelConfig__bad-y__ CONFIG_SPARSEMEM
	
	
	_kernelConfig__bad-n__ CONFIG_REFCOUNT_FULL
	_kernelConfig__bad-n__ CONFIG_DEBUG_NOTIFIERS
	_kernelConfig_warn-n__ CONFIG_FTRACE
	
	_kernelConfig__bad-y__ CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
	
	# CRITICAL!
	# Lightweight kernel compression theoretically may significantly accelerate startup from slow disks.
	_kernelConfig__bad-y__ CONFIG_KERNEL_LZO
	
}

_kernelConfig_require-memory() {
	_messagePlain_nominal 'kernelConfig: memory'
	export kernelConfig_file="$1"
	
	# Uncertain.
	# https://fa.linux.kernel.narkive.com/CNnVwDlb/hack-bench-regression-with-config-slub-cpu-partial-disabled-info-only
	_kernelConfig_warn-y__ CONFIG_SLUB_CPU_PARTIAL
	
	# Uncertain.
	_kernelConfig_warn-y__ CONFIG_TRANSPARENT_HUGEPAGE
	_kernelConfig_warn-y__ CONFIG_CLEANCACHE
	_kernelConfig_warn-y__ CONFIG_FRONTSWAP
	_kernelConfig_warn-y__ CONFIG_ZSWAP
	
	
	_kernelConfig__bad-y__ CONFIG_COMPACTION
	_kernelConfig_warn-y__ CONFIG_BALLOON_COMPACTION
	
	# Uncertain.
	_kernelConfig_warn-y__ CONFIG_MEMORY_FAILURE
	
	# CRITICAL!
	_kernelConfig_warn-y__ CONFIG_KSM
}

_kernelConfig_require-integration() {
	_messagePlain_nominal 'kernelConfig: integration'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y_m CONFIG_FUSE_FS
	_kernelConfig__bad-y_m CONFIG_CUSE
	_kernelConfig__bad-y__ CONFIG_OVERLAY_FS
	_kernelConfig__bad-y_m CONFIG_NTFS_FS
	_kernelConfig_request CONFIG_NTFS_RW
	_kernelConfig__bad-y__ CONFIG_MSDOS_FS
	_kernelConfig__bad-y__ CONFIG_VFAT_FS
	_kernelConfig__bad-y__ CONFIG_MSDOS_PARTITION
	
	# TODO: LiveCD UnionFS or similar boot requirements.
	
	# Gentoo specific. Start with "gentoo-sources" if possible.
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_UDEV
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_PORTAGE
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_INIT_SCRIPT
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_INIT_SYSTEMD
}

# Recommended by docker ebuild during installation under Gentoo.
_kernelConfig_require-investigation_docker() {
	_messagePlain_nominal 'kernelConfig: investigation: docker'
	export kernelConfig_file="$1"
	
	_kernelConfig_warn-y__ CONFIG_MEMCG_SWAP_ENABLED
	_kernelConfig_warn-y__ CONFIG_CGROUP_HUGETLB
	_kernelConfig_warn-y__ CONFIG_RT_GROUP_SCHED
	
	true
}


# ATTENTION: Insufficiently investigated stuff to think about. Unknown consequences.
_kernelConfig_require-investigation() {
	_messagePlain_nominal 'kernelConfig: investigation'
	export kernelConfig_file="$1"
	
	_kernelConfig_warn-any ACPI_HMAT
	_kernelConfig_warn-any PCIE_BW
	
	_kernelConfig_warn-any CONFIG_UCLAMP_TASK
	
	_kernelConfig_warn-any CPU_IDLE_GOV_TEO
	
	_kernelConfig_warn-any LOCK_EVENT_COUNTS
	
	
	_kernelConfig_require-investigation_docker "$@"
	_kernelConfig_require-investigation_prog "$@"
	true
}


_kernelConfig_require-investigation_prog() {
	_messagePlain_nominal 'kernelConfig: investigation: prog'
	export kernelConfig_file="$1"
	
	true
}






_kernelConfig_request_build() {
	_messagePlain_request 'request: make menuconfig'
	
	_messagePlain_request 'request: make -j $(nproc)'
	
	# WARNING: Building debian kernel packages from Gentoo may be complex.
	#https://forums.gentoo.org/viewtopic-t-1096872-start-0.html
	#_messagePlain_request 'emerge dpkg fakeroot bc kmod cpio ; touch /var/lib/dpkg/status'
	
	_messagePlain_request 'request: make deb-pkg -j $(nproc)'
}


# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_panel() {
	_messageNormal 'kernelConfig: panel'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	_kernelConfig_require-investigation "$@"
	
	
	_kernelConfig_request_build
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_mobile() {
	_messageNormal 'kernelConfig: mobile'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='true'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	_kernelConfig_require-investigation "$@"
	
	
	_kernelConfig_request_build
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_desktop() {
	_messageNormal 'kernelConfig: desktop'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=1000
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	_kernelConfig_require-investigation "$@"
	
	
	_kernelConfig_request_build
}


# "$1" == alternateRootPrefix
_write_bfq() {
	_messagePlain_nominal 'write_bfq: init'
	
	_mustGetSudo
	
	
	_messagePlain_nominal 'write_bfq: write'
	
	sudo -n cat << 'CZXWXcRMTo8EmM8i4d' | sudo tee "$1"'/etc/modules-load.d/bfq-'"$ubiquitiousBashIDshort"'.conf' > /dev/null
bfq

CZXWXcRMTo8EmM8i4d


	cat << 'CZXWXcRMTo8EmM8i4d' | sudo tee "$1"'/etc/udev/rules.d/60-scheduler-'"$ubiquitiousBashIDshort"'.rules' > /dev/null
ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="bfq"

CZXWXcRMTo8EmM8i4d

	_messagePlain_good 'write_bfq: success'

}






# ATTENTION: Override with 'ops.sh' , 'core.sh' , or similar.
_setupUbiquitous_accessories_here-gnuoctave() {
	cat << CZXWXcRMTo8EmM8i4d

%# https://stackoverflow.com/questions/8260619/how-can-i-suppress-the-output-of-a-command-in-octave
%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);


format long g;


deci = 10^-1;
centi = 10^-2;
milli = 10^-3;
micro = 10^-6;
nano =-10^-9;
pico = 10^-12;
femto = 10^-15;
atto = 10^-18;

kilo = 10^3;
mega = kilo * 10^3;
giga = mega * 10^3;
tera = giga * 10^3;


bit = 1;
byte = bit * 8;

kilobit = kilo * bit;
megabit = mega * bit;
gigabit = giga * bit;
terabit = tera * bit;

kb = kilobit;
Kb = kilobit;
Mb = megabit;
Gb = gigabit;
Tb = terabit;

kilobyte = kilobit * byte;
megabyte = megabit * byte;
gigabyte = gigabit * byte;
terabyte = terabit * byte;

kB = kilobyte;
KB = kilobyte;
MB = megabyte;
GB = gigabyte;
TB = terabyte;


kibi = 1024;
mebi = kibi * 1024;
gibi = mebi * 1024;
tebi = gibi * 1024;

kibibit = kibi * bit;
mebibit = mebi * bit;
gibibit = gibi * bit;
tebibit = tebi * bit;

Kib = kibibit;
Mib = mebibit;
Gib = gibibit;
Tib = tebibit;

kibibyte = kibi * byte;
mebibyte = mebi * byte;
gibibyte = gibi * byte;
tebibyte = tebi * byte;

KiB = kibibyte;
MiB = mebibyte;
GiB = gibibyte;
TiB = tebibyte;



meter = 1;

kilometer = kilo * meter;
megameter = mega * meter;
Megameter = megameter;

decimeter = deci * meter;
centimeter = centi * meter;
millimeter = milli * meter;
micrometer = micro * meter;
nanometer = nano * meter;
picometer = pico * meter;
femtometer = femto * meter;
attometer = atto * meter;



%# 1 * lightsecond ~= 300 * Mega * meter
lightsecond = 299792458 * meter;
lightSecond = lightsecond;

lightyear = lightsecond * 365 * 24 * 3600;
lightYear = lightyear;



hertz = 1;

kilohertz = kilo * hertz;
megahertz = mega * hertz;
gigahertz = giga * hertz;
terahertz = tera * hertz;

kHz = kilohertz;
KHz = kilohertz;
MHz = megahertz;
GHz = gigahertz;
THz = terahertz;



unix("true");
system("true");

cd;

%# Equivalent to Ctrl-L . 
%# https://stackoverflow.com/questions/11269571/how-to-clear-the-command-line-in-octave
clc;


%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d


	! _if_cygwin && cat << CZXWXcRMTo8EmM8i4d

pkg load symbolic;

syms a b c d e f g h i j k l m n o p q r s t u v w x y z;


%# https://octave.sourceforge.io/symbolic/overview.html
nsolve = @vpasolve;

CZXWXcRMTo8EmM8i4d

}


_setupUbiquitous_accessories_here-gnuoctave_hook() {
	cat << CZXWXcRMTo8EmM8i4d

%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);

%# ubcore
run("$ubcore_accessoriesFile_gnuoctave_ubhome");

%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d
}




_setupUbiquitous_accessories_here-cloud_bin() {
	cat << CZXWXcRMTo8EmM8i4d

if [[ "$PATH" != *'.ebcli-virtual-env/executables'* ]] && [[ -e "$HOME"/.ebcli-virtual-env/executables ]]
then
	# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
	export PATH="$HOME"/.ebcli-virtual-env/executables:"$PATH"
fi


if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc ]]
then
	. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
	. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
fi

CZXWXcRMTo8EmM8i4d
}





_setupUbiquitous_accessories_here-python() {
	
	_generate_lean-lib-python_here "$@"
	
} 

_setupUbiquitous_accessories_here-python_hook() {
	cat << CZXWXcRMTo8EmM8i4d

# ATTENTION: Without either 'exec(exec(open()))' or 'execfile()' , 'from ubcorerc_pythonrc import *' must take effect!
# If 'exec(exec(open()))' is substituted for 'from ubcorerc_pythonrc import *' then copying home directory files independent of '.ubcore' 
import os
if os.path.exists("$ubcore_accessoriesFile_python"):
	import sys
	import os
	# https://stackoverflow.com/questions/2349991/how-to-import-other-python-files
	sys.path.append(os.path.abspath("$ubcoreDir_accessories/python"))
	from ubcorerc_pythonrc import *





import sys
# https://stackoverflow.com/questions/436198/what-is-an-alternative-to-execfile-in-python-3
if sys.hexversion > 0x03000000:
	exec('exec(open( "$ubcore_accessoriesFile_python_ubhome" ).read() )')
else:
	execfile("$ubcore_accessoriesFile_python_ubhome")




CZXWXcRMTo8EmM8i4d
}



_setupUbiquitous_accessories_here-python_bashrc() {
	cat << CZXWXcRMTo8EmM8i4d

# Interactive bash shell will default to calling 'python3' while scripts invoking '#! /usr/bin/env python' or similar may still be given 'python2' equivalent.
alias python=python3

export PYTHONSTARTUP="$HOME"/.pythonrc

CZXWXcRMTo8EmM8i4d
}























_setupUbiquitous_accessories-gnuoctave() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-gnuoctave'
	
	mkdir -p "$ubcoreDir_accessories"/gnuoctave
	
	export ubcore_accessoriesFile_gnuoctave="$ubcoreDir_accessories"/gnuoctave/ubcorerc.m
	export ubcore_accessoriesFile_gnuoctave_ubhome="$ubHome"/.ubcorerc-gnuoctave.m
	
	rm -f "$ubcore_accessoriesFile_gnuoctave"
	rm -f "$ubcore_accessoriesFile_gnuoctave_ubhome"
	ln -s "$ubcore_accessoriesFile_gnuoctave_ubhome" "$ubcore_accessoriesFile_gnuoctave"
	
	_setupUbiquitous_accessories_here-gnuoctave > "$ubcore_accessoriesFile_gnuoctave_ubhome"
	
	
	if ! grep ubcore "$ubHome"/.octaverc > /dev/null 2>&1 && _messagePlain_probe 'octaverc'
	then
		# https://www.mathworks.com/matlabcentral/answers/194868-what-about-the-character
		#echo '%# ubcore' >> "$ubHome"/.octaverc
		#_safeEcho_newline run'("'"$ubcore_accessoriesFile_gnuoctave_ubhome"'")' >> "$ubHome"/.octaverc
		_setupUbiquitous_accessories_here-gnuoctave_hook >> "$ubHome"/.octaverc
	fi
	
	return 0
}


_setupUbiquitous_accessories_bashrc-cloud_bin() {
	
	_setupUbiquitous_accessories_here-cloud_bin
	
	echo 'true'
	
	return 0
}



_setupUbiquitous_accessories-python() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-python'
	
	mkdir -p "$ubcoreDir_accessories"/python
	
	export ubcore_accessoriesFile_python="$ubcoreDir_accessories"/python/ubcorerc_pythonrc.py
	export ubcore_accessoriesFile_python_ubhome="$ubHome"/.ubcorerc_pythonrc.py
	
	rm -f "$ubcore_accessoriesFile_python"
	rm -f "$ubcore_accessoriesFile_python_ubhome"
	ln -s "$ubcore_accessoriesFile_python_ubhome" "$ubcore_accessoriesFile_python"
	
	_setupUbiquitous_accessories_here-python > "$ubcore_accessoriesFile_python_ubhome"
	
	
	if ! grep ubcore "$ubHome"/.pythonrc > /dev/null 2>&1 && _messagePlain_probe 'pythonrc'
	then
		# https://www.mathworks.com/matlabcentral/answers/194868-what-about-the-character
		#echo '%# ubcore' >> "$ubHome"/.pythonrc
		#_safeEcho_newline run'("'"$ubcore_accessoriesFile_python_ubhome"'")' >> "$ubHome"/.pythonrc
		_setupUbiquitous_accessories_here-python_hook >> "$ubHome"/.pythonrc
	fi
	
	return 0
}



_setupUbiquitous_accessories() {
	
	_setupUbiquitous_accessories-gnuoctave "$@"
	
	_setupUbiquitous_accessories-python "$@"
	
	return 0
}

_setupUbiquitous_accessories_bashrc() {
	#_messagePlain_nominal 'init: _setupUbiquitous_accessories_bashrc'
	
	_setupUbiquitous_accessories_bashrc-cloud_bin "$@"
	
	_setupUbiquitous_accessories_here-python_bashrc "$@"
}


_setupUbiquitous_accessories_requests() {
	
	# EXAMPLE .
	#_messagePlain_request 'request: request'
	
	return 0
}






_setupUbiquitous_here() {
	! uname -a | grep -i cygwin > /dev/null 2>&1 && cat << CZXWXcRMTo8EmM8i4d

if type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1 && ! uname -a | grep -i cygwin > /dev/null 2>&1
then
	# Greater or equal, '_priority_critical_pid_root' .
	sudo -n renice -n -15 -p \$\$ > /dev/null 2>&1
	sudo -n ionice -c 2 -n 2 -p \$\$ > /dev/null 2>&1
fi

# ^
# Ensures admin user shell startup, including Ubiquitous Bash, is relatively quick under heavy system load.
# Near-realtime priority may be acceptable, due to reliability of relevant Ubiquitous Bash functions.
# WARNING: Do NOT prioritize highly enough to interfere with embedded hard realtime processes.

CZXWXcRMTo8EmM8i4d


	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && cat << CZXWXcRMTo8EmM8i4d

[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && echo -n '.'

[[ "\$profileScriptLocation" == "" ]] && export profileScriptLocation_new='true'

CZXWXcRMTo8EmM8i4d


	cat << CZXWXcRMTo8EmM8i4d
PS1_lineNumber=""


# WARNING: Importing complete 'ubiquitous_bash.sh' may cause other scripts to call functions inappropriate for their needs during "_test" and "_setup" .
# This may be acceptable if the user has already run "_setup" from the imported script .
#export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptLocation="$ubcoreUBdir"/ubcore.sh
#export profileScriptLocation="$ubcoreUBdir"/lean.sh
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

[[ -e "$ubcoreDir"/cloudrc ]] && . "$ubcoreDir"/cloudrc

true

CZXWXcRMTo8EmM8i4d


	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && cat << CZXWXcRMTo8EmM8i4d

if [[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	#echo -n '.'
	#clear
	
	# https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
	echo -e -n '.\r'
	
	if [[ "\$profileScriptLocation_new" == 'true' ]]
	then
		export profileScriptLocation_new=''
		unset profileScriptLocation_new
		
		sleep 0.1
		echo '.'
		sleep 0.1
		echo '.'
		sleep 0.1
		clear
	fi
fi

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
	
	return 0
}

_gitPull_ubiquitous() {
	git pull
}

_gitClone_ubiquitous() {
	git clone --depth 1 git@github.com:mirage335/ubiquitous_bash.git
}

_selfCloneUbiquitous() {
	"$scriptBin"/.ubrgbin.sh _ubrgbin_cpA "$scriptBin" "$ubcoreUBdir"/ > /dev/null 2>&1
	cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/lean.sh
	cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/ubcore.sh
	cp -a "$scriptAbsoluteFolder"/lean.sh "$ubcoreUBdir"/lean.sh > /dev/null 2>&1
	cp -a "$scriptAbsoluteFolder"/lean.sh "$ubcoreUBdir"/ubcore.sh > /dev/null 2>&1
	cp -a "$scriptAbsoluteFolder"/ubcore.sh "$ubcoreUBdir"/ubcore.sh > /dev/null 2>&1
	cp -a "$scriptAbsoluteLocation" "$ubcoreUBdir"/ubiquitous_bash.sh
	
	cp -a "$scriptAbsoluteFolder"/lean.py "$ubcoreUBdir"/lean.py > /dev/null 2>&1
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
	
	_if_cygwin && _setup_ubiquitousBash_cygwin_procedure
	
	
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	export ubcoreFile="$ubcoreDir"/.ubcorerc
	
	export ubcoreDir_accessories="$ubHome"/.ubcore/accessories
	
	
	# WARNING: Despite the name, do NOT point this to 'ubcore.sh' or similar. Full set of functions are expected from this file by some use cases!
	export ubcoreUBdir="$ubcoreDir"/ubiquitous_bash
	export ubcoreUBfile="$ubcoreDir"/ubiquitous_bash/ubiquitous_bash.sh
	
	_messagePlain_probe 'ubHome= '"$ubHome"
	_messagePlain_probe 'ubcoreDir= '"$ubcoreDir"
	_messagePlain_probe 'ubcoreFile= '"$ubcoreFile"
	
	_messagePlain_probe 'ubcoreUBdir= '"$ubcoreUBdir"
	_messagePlain_probe 'ubcoreUBfile= '"$ubcoreUBfile"
	
	mkdir -p "$ubcoreUBdir"
	! [[ -e "$ubcoreUBdir" ]] && _messagePlain_bad 'missing: ubcoreUBdir= '"$ubcoreUBdir" && _messageFAIL && return 1
	
	mkdir -p "$ubcoreDir_accessories"
	! [[ -e "$ubcoreDir_accessories" ]] && _messagePlain_bad 'missing: ubcoreUBdir_accessories= '"$ubcoreDir_accessories" && _messageFAIL && return 1
	
	
	_messageNormal "install: setupUbiquitous"
	! _installUbiquitous && _messageFAIL && return 1
	! [[ -e "$ubcoreUBfile" ]] && _messagePlain_bad 'missing: ubcoreUBfile= '"$ubcoreUBfile" && _messageFAIL && return 1
	
	
	_messageNormal "hook: setupUbiquitous"
	if ! _permissions_ubiquitous_repo "$ubcoreUBdir" && _messagePlain_bad 'permissions: ubcoreUBdir = '"$ubcoreUBdir"
	then
		if ! _if_cygwin
		then
			_messageFAIL
			return 1
		else
			echo 'warn: accepted: cygwin: permissions'
		fi
	fi
	
	mkdir -p "$ubHome"/bin/
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/ubiquitous_bash.sh
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winehere
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winecfghere
	
	_setupUbiquitous_here > "$ubcoreFile"
	_setupUbiquitous_accessories_bashrc >> "$ubcoreFile"
	! [[ -e "$ubcoreFile" ]] && _messagePlain_bad 'missing: ubcoreFile= '"$ubcoreFile" && _messageFAIL && return 1
	
	
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_probe "$ubcoreFile"' >> '"$ubHome"/.bashrc && echo ". ""$ubcoreFile" >> "$ubHome"/.bashrc
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_bad 'missing: bashrc hook' && _messageFAIL && return 1
	
	
	
	
	_messageNormal "install: setupUbiquitous_accessories"
	
	_setupUbiquitous_accessories "$@"
	
	
	_messageNormal "request: setupUbiquitous_accessories , setupUbiquitous"
	
	_setupUbiquitous_accessories_requests "$@"
	
	if ! _if_cygwin
	then
		# WARNING: End user file association. Do NOT call within scripts.
		# WARNING: Necessarily relies on a 'deprecated' 'field code' with the 'Exec key' of a 'Desktop Entry' file association.
		# https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
		_messagePlain_request 'association: *.bat'
		echo 'konsole --workdir %d -e /bin/bash %f (open in graphical terminal emulator from file manager)'
		echo 'bash'
	fi
	
	_messagePlain_request "Now import new functionality into current shell if not in current shell."
	_messagePlain_request ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
	
	sleep 3
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
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_test
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_true
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_false
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_test.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_true.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_false.bat
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_bin.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_bash.bat
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_setup_ubcp.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_setup_ubiquitousBash_cygwin.bat
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_setupUbiquitous.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_setupUbiquitous_nonet.bat
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_demand_broadcastPipe_page.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_terminate_broadcastPipe_page.bat
}


_refresh_anchors_cautossh() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_test
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_setup
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_bash
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_bin
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_grsync
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_test.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_setup.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_bash.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_bin.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_grsync.bat
}


# EXAMPLE ONLY.
# _refresh_anchors() {
# 	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_true
# }


# CAUTION: Anchor scripts MUST include code to ignore '--' suffix specific software name convention!
# CAUTION: ONLY intended to be used either with generic software, or anchors following '--' suffix specific software name convention!
# WARNING: DO NOT enable in "core.sh". Intended to be enabled by "_local/ops.sh".
# ATTENTION: Set "$ub_anchor_specificSoftwareName" or similar in "ops.sh".
# ATTENTION: Set ub_anchor_user='true' or similar in "ops.sh".
#export ub_anchor_specificSoftwareName='experimental'
#export ub_anchor_user="true"
_set_refresh_anchors_specific() {
	export ub_anchor_suffix=
	export ub_anchor_suffix
	
	[[ "$ub_anchor_specificSoftwareName" == "" ]] && return 0
	
	export ub_anchor_suffix='--'"$ub_anchor_specificSoftwareName"
	
	return 0
}

_refresh_anchors_specific_single_procedure() {
	[[ "$ub_anchor_specificSoftwareName" == "" ]] && return 1
	
	_set_refresh_anchors_specific
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/"$1""$ub_anchor_suffix"
	
	return 0
}
# Assumes user has included "$HOME"/bin in their "$PATH".
_refresh_anchors_user_single_procedure() {
	[[ "$ub_anchor_user" != 'true' ]] && return 1
	
	_set_refresh_anchors_specific
	! mkdir -p "$HOME"/bin && return 1
	
	
	# WARNING: Default to replacement. Rare case considered acceptable for several reasons.
	# Negligible damage potential - all replaced files are symlinks or anchors.
	# Limited to specifically named anchor symlinks, defined in "_associate_anchors_request", typically overloaded with 'core.sh' or similar.
	# Usually requested 'manually' through "_setup" or "_anchor", even if called through a multi-installation request.
	# Incorrectly calling a moved, uninstalled, or otherwise incorrect previous version, of linked software, is anticipated to be a more commonly impose greater risk.
	#ln -s "$scriptAbsoluteFolder"/"$1""$ub_anchor_suffix" "$HOME"/bin/ > /dev/null 2>&1
	ln -sf "$scriptAbsoluteFolder"/"$1""$ub_anchor_suffix" "$HOME"/bin/
	
	return 0
}

# ATTENTION: Overload with 'core.sh' or similar.
# # EXAMPLE ONLY.
# _refresh_anchors_specific() {
# 	_refresh_anchors_specific_single_procedure _true
# }
# # EXAMPLE ONLY.
# _refresh_anchors_user() {
# 	_refresh_anchors_user_single_procedure _true
# }


# ATTENTION: Overload with 'core'sh' or similar.
# _associate_anchors_request() {
# 	if type "_refresh_anchors_user" > /dev/null 2>&1
# 	then
# 		_tryExec "_refresh_anchors_user"
# 		#return
# 	fi
# 	
# 	_messagePlain_request 'association: dir'
# 	echo _scope_konsole"$ub_anchor_suffix"
# 	
# 	_messagePlain_request 'association: dir'
# 	echo _scope_designer_designeride"$ub_anchor_suffix"
# 	
# 	_messagePlain_request 'association: dir, *.ino'
# 	echo _designer_generate"$ub_anchor_suffix"
# }



# ATTENTION: Overload with 'core.sh' or similar.
# WARNING: May become default behavior.
_anchor_autoupgrade() {
	local currentScriptBaseName
	currentScriptBaseName=$(basename $scriptAbsoluteLocation)
	[[ "$currentScriptBaseName" != "ubiquitous_bash.sh" ]] && return 1
	
	[[ "$ub_anchor_autoupgrade" != 'true' ]] && return 0
	
	_findUbiquitous
	
	[[ -e "$ubiquitiousLibDir"/_anchor ]] && cp -a "$ubiquitiousLibDir"/_anchor "$scriptAbsoluteFolder"/_anchor
}

_anchor_configure() {
	export ubAnchorTemplateCurrent="$scriptAbsoluteFolder"/_anchor
	[[ "$1" != "" ]] && export ubAnchorTemplateCurrent="$1"
	
	! [[ -e "$ubAnchorTemplateCurrent" ]] && return 1
	
	#https://superuser.com/questions/450868/what-is-the-simplest-scriptable-way-to-check-whether-a-shell-variable-is-exporte
	! [ "$(bash -c 'echo ${objectName}')" ] && return 1
	
	
	rm -f "$scriptAbsoluteFolder"/_anchor.tmp "$scriptAbsoluteFolder"/_anchor.tmp1 "$scriptAbsoluteFolder"/_anchor.tmp2 > /dev/null 2>&1
	cp "$ubAnchorTemplateCurrent" "$scriptAbsoluteFolder"/_anchor.tmp
	cp "$ubAnchorTemplateCurrent" "$scriptAbsoluteFolder"/_anchor.tmp1
	cp "$ubAnchorTemplateCurrent" "$scriptAbsoluteFolder"/_anchor.tmp2
	
	cat "$scriptAbsoluteFolder"/_anchor.tmp  | sed 's/^export anchorSourceDir\=.*$/export anchorSourceDir\=\"'"$objectName"'\"/g' > "$scriptAbsoluteFolder"/_anchor.tmp1
	#perl -p -e 's/export anchorSourceDir=.*/export anchorSourceDir="$ENV{objectName}"/g' "$scriptAbsoluteFolder"/_anchor.tmp > "$scriptAbsoluteFolder"/_anchor.tmp1
	
	cat "$scriptAbsoluteFolder"/_anchor.tmp1 | sed 's/^SET \"MSWanchorSourceDir\=.*$/SET \"MSWanchorSourceDir\='"$objectName"'\"/g' > "$scriptAbsoluteFolder"/_anchor.tmp2
	#perl -p -e 's/SET "MSWanchorSourceDir=.*/SET "MSWanchorSourceDir=$ENV{objectName}"/g' "$scriptAbsoluteFolder"/_anchor.tmp1 > "$scriptAbsoluteFolder"/_anchor.tmp2
	
	local currentScriptBaseName
	currentScriptBaseName=$(basename $scriptAbsoluteLocation)
	
	# ATTENTION: Configure with 'ops.sh' , 'core.sh' , or similar.
	if [[ "$scriptAbsoluteLocation" == *"cautossh" ]] || [[ "$scriptAbsoluteLocation" != *"ubiquitous_bash.sh" ]]
	then
		cat "$scriptAbsoluteFolder"/_anchor.tmp2  | sed 's/^export anchorSource\=.*$/export anchorSource\=\"'"$currentScriptBaseName"'\"/g' > "$scriptAbsoluteFolder"/_anchor.tmp3
		#perl -p -e 's/export anchorSource=.*/export anchorSource="cautossh"/g' "$scriptAbsoluteFolder"/_anchor.tmp2 > "$scriptAbsoluteFolder"/_anchor.tmp3
		
		cat "$scriptAbsoluteFolder"/_anchor.tmp3 | sed 's/^SET \"MSWanchorSource\=.*$/SET \"MSWanchorSource\='"$currentScriptBaseName"'\"/g' > "$scriptAbsoluteFolder"/_anchor.tmp4
		#perl -p -e 's/SET "MSWanchorSource=.*/SET "MSWanchorSource=cautossh"/g' "$scriptAbsoluteFolder"/_anchor.tmp3 > "$scriptAbsoluteFolder"/_anchor.tmp4
	else
		cat "$scriptAbsoluteFolder"/_anchor.tmp2 > "$scriptAbsoluteFolder"/_anchor.tmp4
	fi
	
	mv "$scriptAbsoluteFolder"/_anchor.tmp4 "$ubAnchorTemplateCurrent"
	chmod u+x "$ubAnchorTemplateCurrent"
	rm -f "$scriptAbsoluteFolder"/_anchor.tmp "$scriptAbsoluteFolder"/_anchor.tmp1 "$scriptAbsoluteFolder"/_anchor.tmp2 "$scriptAbsoluteFolder"/_anchor.tmp3 "$scriptAbsoluteFolder"/_anchor.tmp4 > /dev/null 2>&1
}


_anchor() {
	_anchor_autoupgrade
	
	_anchor_configure
	_anchor_configure "$scriptAbsoluteFolder"/_anchor.bat
	
	! [[ -e "$scriptAbsoluteFolder"/_anchor ]] && ! [[ -e "$scriptAbsoluteFolder"/_anchor.bat ]] && return 1
	
	[[ "$scriptAbsoluteFolder" == *"ubiquitous_bash" ]] && _refresh_anchors_ubiquitous
	
	if type "_refresh_anchors_cautossh" > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" == *"cautossh" ]]
	then
		_tryExec "_refresh_anchors_cautossh"
		#return
	fi
	
	
	if type "_refresh_anchors" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors"
		#return
	fi
	
	# CAUTION: Anchor scripts MUST include code to ignore '--' suffix specific software name convention!
	# WARNING: DO NOT enable in "core.sh". Intended to be enabled by "_local/ops.sh".
	if type "_refresh_anchors_specific" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors_specific"
		#return
	fi
	
	# CAUTION: ONLY intended to be used either with generic software, or anchors following '--' suffix specific software name convention!
	# WARNING: DO NOT enable in "core.sh". Intended to be enabled by "_local/ops.sh".
	if type "_refresh_anchors_user" > /dev/null 2>&1
	then
		_tryExec "_refresh_anchors_user"
		#return
	fi
	
	# WARNING: Calls _refresh_anchors_user . Same variables required to enable, intended to be set by "_local/ops.sh".
	#if type "_associate_anchors_request" > /dev/null 2>&1
	#then
		#_tryExec "_associate_anchors_request"
		##return
	#fi
	
	
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
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
export tmpSelf=""

# ATTENTION: CAUTION: Should only be used by a single unusual Cygwin override. Must be reset if used for any other purpose.
#export descriptiveSelf=""

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
elif ( [[ "$ub_import_param" == "--parent" ]] || [[ "$ub_import_param" == "--embed" ]] || [[ "$ub_import_param" == "--return" ]] || [[ "$ub_import_param" == "--devenv" ]] ) && [[ "$scriptAbsoluteLocation" != "" ]] && [[ "$scriptAbsoluteFolder" != "" ]] && [[ "$sessionid" != "" ]]
then
	ub_import=true
	true #Do not override.
	_messagePlain_probe_expr 'parent: scriptAbsoluteLocation= '"$scriptAbsoluteLocation"'\n ''parent: scriptAbsoluteFolder= '"$scriptAbsoluteFolder"'\n ''parent: sessionid= '"$sessionid" | _user_log-ub
elif [[ "$ub_import_param" == "--call" ]] || [[ "$ub_import_param" == "--script" ]] || [[ "$ub_import_param" == "--bypass" ]] || [[ "$ub_import_param" == "--shell" ]] || ( [[ "$ub_import" == "true" ]] && [[ "$ub_import_param" == "" ]] )
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
export abstractfs_root=/tmp/"$ubiquitiousBashIDnano"
( [[ "$bootTmp" == '/dev/shm' ]] || [[ "$bootTmp" == '/tmp' ]] || [[ "$tmpMSW" != "" ]] ) && export abstractfs_root="$bootTmp"/"$ubiquitiousBashIDnano"
export abstractfs_lock="$bootTmp"/"$ubiquitiousBashID"/afslock

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



#Machine information.

if [[ -e "/proc/meminfo" ]]
then
	export hostMemoryTotal=$(cat /proc/meminfo | grep MemTotal | tr -cd '[[:digit:]]')
	export hostMemoryAvailable=$(cat /proc/meminfo | grep MemAvailable | tr -cd '[[:digit:]]')
	export hostMemoryQuantity="$hostMemoryTotal"
else
	export hostMemoryTotal="384000"
	export hostMemoryAvailable="256000"
	export hostMemoryQuantity="$hostMemoryTotal"
fi

export virtGuestUserDrop="ubvrtusr"
export virtGuestUser="$virtGuestUserDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestUser="root"

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$tmpSelf"/v_"$sessionid"
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
export instancedFakeHome="$tmpSelf"/h_"$sessionid"
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
	
	
	# Invalid.
	[[ "$hostMemoryQuantity" -lt "64000" ]] && return 1
	! [[ "$hostMemoryQuantity" -ge "64000" ]] && return 1
	
	
	# Embedded host typical.
	[[ "$hostMemoryQuantity" -lt "500000" ]] && export vmMemoryAllocationDefault=256 && return 1
	
	# Obsolete hardware or guest typical.
	[[ "$hostMemoryQuantity" -lt "1256000" ]] && export vmMemoryAllocationDefault=512 && return 0
	[[ "$hostMemoryQuantity" -lt "1768000" ]] && export vmMemoryAllocationDefault=1024 && return 0
	[[ "$hostMemoryQuantity" -lt "6000000" ]] && export vmMemoryAllocationDefault=1512 && return 0
	
	# Modern host typical.
	[[ "$hostMemoryQuantity" -lt "7000000" ]] && export vmMemoryAllocationDefault=2048 && return 0
	[[ "$hostMemoryQuantity" -lt "18000000" ]] && export vmMemoryAllocationDefault=2560 && return 0
	[[ "$hostMemoryQuantity" -lt "34000000" ]] && export vmMemoryAllocationDefault=3072 && return 0
	
	# Workstation typical.
	[[ "$hostMemoryQuantity" -lt "72000000" ]] && export vmMemoryAllocationDefault=4096 && return 0
	[[ "$hostMemoryQuantity" -lt "132000000" ]] && export vmMemoryAllocationDefault=4096 && return 0
	
	# Atypical host.
	export vmMemoryAllocationDefault=4096 && return 0
	
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


# WARNING: Any changes to output text format *will* break API compatibility.
# Example usage: currentPortList=( $(./ubiquitous_bash.sh _show_reversePorts '*') ) ; echo ${currentPortList[@]} ; echo ${currentPortList[0]} ; echo ${currentPortList[1]}
_show_reversePorts_sequence() {
	_get_reversePorts "$1"
	echo "${matchingReversePorts[@]}"
}
_show_reversePorts() {
	"$scriptAbsoluteLocation" _show_reversePorts_sequence "$@"
}
_show_reversePorts_single_sequence() {
	_get_reversePorts "$1"
	echo "${matchingReversePorts[0]}"
}
_show_reversePorts_single() {
	"$scriptAbsoluteLocation" _show_reversePorts_single_sequence "$@"
}
_show_offset_reversePorts_sequence() {
	_get_reversePorts "$1"
	_offset_reversePorts
	echo "${matchingOffsetPorts[@]}"
}
_show_offset_reversePorts() {
	"$scriptAbsoluteLocation" _show_offset_reversePorts_sequence "$@"
}
_show_offset_reversePorts_single_sequence() {
	_get_reversePorts "$1"
	_offset_reversePorts
	echo "${matchingOffsetPorts[0]}"
}
_show_offset_reversePorts_single() {
	"$scriptAbsoluteLocation" _show_offset_reversePorts_single_sequence "$@"
}

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


_queue_descriptiveSelf() {
	[[ ! -e "$scriptAbsoluteFolder" ]] && exit 1
	[[ ! -d "$scriptAbsoluteFolder" ]] && exit 1
	
	if type -p md5sum > /dev/null 2>&1
	then
		_safeEcho "$scriptAbsoluteFolder" | md5sum | head -c 18
		return 0
	fi
	if type -p sha512sum > /dev/null 2>&1
	then
		_safeEcho "$scriptAbsoluteFolder" | sha512sum | head -c 18
		return 0
	fi
	
	
	_stop 1
}

_prepare_demand_dir_queue() {
	mkdir -p "$scriptLocal"/_queue
}

# ATTENTION: Override with 'ops' or similar.
_demand_dir_broadcastPipe_page() {
	_prepare_demand_dir_queue "$@"
	
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	local currentLink
	currentLink="$scriptLocal"/_queue/broadcastPipe_page_lnk
	
	local currentValue
	currentValue="$scriptLocal"/_queue/broadcastPipe_page_dir
	
	if [[ "$1" != "" ]]
	then
		mkdir -p "$currentValue"
		_safeEcho "$currentValue"
		return 0
	fi
	
	if [[ -e '/dev/shm' ]] && ! _if_cygwin && type -p mount > /dev/null 2>&1 && mount | grep '/dev/shm' > /dev/null 2>&1
	then
		currentValue=/dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_dir
		mkdir -p "$currentValue"
		_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		_safeEcho "$currentValue"
		return 0
	fi
	
	mkdir -p "$currentValue"
	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	_safeEcho "$currentValue"
	
	return 0
}


_rm_dir_broadcastPipe_page() {
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_page_lnk > /dev/null 2>&1
	
	rmdir "$scriptLocal"/_queue/broadcastPipe_page_dir > /dev/null 2>&1
	rmdir "$scriptLocal"/_queue > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_dir/inputBufferDir > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_dir/outputBufferDir > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_dir > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	return 0
}





# ATTENTION: Override with 'ops' or similar.
_demand_dir_broadcastPipe_aggregatorStatic() {
	_prepare_demand_dir_queue "$@"
	
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	local currentLink
	currentLink="$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_lnk
	
	local currentValue
	currentValue="$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir
	
	if [[ "$1" != "" ]]
	then
		mkdir -p "$currentValue"
		_safeEcho "$currentValue"
		return 0
	fi
	
	# Pipe/Socket backends (eg. 'aggregatorStatic' , 'aggregatorDynamic' ) should NOT be expected to benefit from 'shared memory'.
	#if [[ -e '/dev/shm' ]] && ! _if_cygwin && type -p mount > /dev/null 2>&1 && mount | grep '/dev/shm' > /dev/null 2>&1
	#then
		#currentValue=/dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir
		#mkdir -p "$currentValue"
		#_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		#_safeEcho "$currentValue"
		#return 0
	#fi
	
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# DANGER: Assumption: If possibility of script running from network drive excluded, "$tmpMSW" == "" .
	if _if_cygwin && [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]] && [[ "$tmpMSW" != "" ]] && [[ "$LOCALAPPDATA" != "" ]] && [[ -e "$LOCALAPPDATA" ]] && [[ -d "$LOCALAPPDATA" ]]
	then
		currentValue="$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir
		mkdir -p "$currentValue"
		
		#_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		rm -f "$currentLink" > /dev/null 2>&1
		_safeEcho "$currentValue" > "$currentLink"
		
		_safeEcho "$currentValue"
		return 0
	fi
	
	mkdir -p "$currentValue"
	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	_safeEcho "$currentValue"
	
	return 0
}


_rm_dir_broadcastPipe_aggregatorStatic() {
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_lnk > /dev/null 2>&1
	
	rmdir "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	rmdir "$scriptLocal"/_queue > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir/inputBufferDir > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir/outputBufferDir > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	return 0
}




_demand_socket_broadcastPipe_page_unixAddress() {
	_prepare_demand_dir_queue "$@"
	
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	local currentLink
	currentLink="$scriptLocal"/_queue/broadcastPipe_page_socketUNIX_lnk
	
	local currentValue
	currentValue="$scriptLocal"/_queue/broadcastPipe_page_socketUNIX_dir
	
	if [[ "$1" != "" ]]
	then
		mkdir -p "$currentValue"
		_safeEcho "$currentValue"/unix.sock
		return 0
	fi
	
	# Pipe/Socket backends (eg. 'aggregatorStatic' , 'aggregatorDynamic' ) should NOT be expected to benefit from 'shared memory'.
	#if [[ -e '/dev/shm' ]] && ! _if_cygwin && type -p mount > /dev/null 2>&1 && mount | grep '/dev/shm' > /dev/null 2>&1
	#then
	#	currentValue=/dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir
	#	mkdir -p "$currentValue"
	#	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	#	_safeEcho "$currentValue"/unix.sock
	#	return 0
	#fi
	
	# WARNING: At best, no benefit is expected from using a 'unix domain socket' through Cygwin .
	# https://stackoverflow.com/questions/23086038/what-mechanism-is-used-by-msys-cygwin-to-emulate-unix-domain-sockets
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# DANGER: Assumption: If possibility of script running from network drive excluded, "$tmpMSW" == "" .
	#if _if_cygwin && [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]] && [[ "$tmpMSW" != "" ]] && [[ "$LOCALAPPDATA" != "" ]] && [[ -e "$LOCALAPPDATA" ]] && [[ -d "$LOCALAPPDATA" ]]
	#then
		#currentValue="$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir
		#mkdir -p "$currentValue"
		
		##_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		#rm -f "$currentLink" > /dev/null 2>&1
		#_safeEcho "$currentValue" > "$currentLink"
		
		#_safeEcho "$currentValue"/unix.sock
		#return 0
	#fi
	
	# WARNING: UNIX domain socket apparently requires short address.
	# 'E unix socket address 111 characters long, max length is 108'
	if [[ -e '/tmp' ]]
	then
		#currentValue=/tmp/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir
		currentValue=/tmp/que_skt_"$currentDescriptiveSelf"/bP_p_sktU_d
		mkdir -p "$currentValue"
		
		#_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		rm -f "$currentLink" > /dev/null 2>&1
		_safeEcho "$currentValue" > "$currentLink"
		
		_safeEcho "$currentValue"/unix.sock
		return 0
	fi
	
	
	mkdir -p "$currentValue"
	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	_safeEcho "$currentValue"/unix.sock
	
	return 0
}


_rm_socket_broadcastPipe_page_unixAddress() {
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_lnk > /dev/null 2>&1
	
	
	
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir/unix.sock > /dev/null 2>&1
	
	rmdir "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	rmdir "$scriptLocal"/_queue > /dev/null 2>&1
	
	
	
	rm -f rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir/unix.sock > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	
	
	rm -f "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir/unix.sock > /dev/null 2>&1
	
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir > /dev/null 2>&1
	
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_page_socketUNIX_dir > /dev/null 2>&1
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	
	
	
	rm -f /tmp/que_skt_"$currentDescriptiveSelf"/bP_p_sktU_d/unix.sock > /dev/null 2>&1
	rmdir /tmp/que_skt_"$currentDescriptiveSelf"/bP_p_sktU_d > /dev/null 2>&1
	rmdir /tmp/que_skt_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	
	return 0
}













_demand_socket_broadcastPipe_aggregatorStatic_unixAddress() {
	_prepare_demand_dir_queue "$@"
	
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	local currentLink
	currentLink="$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_socketUNIX_lnk
	
	local currentValue
	currentValue="$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir
	
	if [[ "$1" != "" ]]
	then
		mkdir -p "$currentValue"
		_safeEcho "$currentValue"/unix.sock
		return 0
	fi
	
	# Pipe/Socket backends (eg. 'aggregatorStatic' , 'aggregatorDynamic' ) should NOT be expected to benefit from 'shared memory'.
	#if [[ -e '/dev/shm' ]] && ! _if_cygwin && type -p mount > /dev/null 2>&1 && mount | grep '/dev/shm' > /dev/null 2>&1
	#then
	#	currentValue=/dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir
	#	mkdir -p "$currentValue"
	#	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	#	_safeEcho "$currentValue"/unix.sock
	#	return 0
	#fi
	
	# WARNING: At best, no benefit is expected from using a 'unix domain socket' through Cygwin .
	# https://stackoverflow.com/questions/23086038/what-mechanism-is-used-by-msys-cygwin-to-emulate-unix-domain-sockets
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
	# DANGER: Assumption: If possibility of script running from network drive excluded, "$tmpMSW" == "" .
	#if _if_cygwin && [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]] && [[ "$tmpMSW" != "" ]] && [[ "$LOCALAPPDATA" != "" ]] && [[ -e "$LOCALAPPDATA" ]] && [[ -d "$LOCALAPPDATA" ]]
	#then
		#currentValue="$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir
		#mkdir -p "$currentValue"
		
		##_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		#rm -f "$currentLink" > /dev/null 2>&1
		#_safeEcho "$currentValue" > "$currentLink"
		
		#_safeEcho "$currentValue"/unix.sock
		#return 0
	#fi
	
	# WARNING: UNIX domain socket apparently requires short address.
	# 'E unix socket address 111 characters long, max length is 108'
	if [[ -e '/tmp' ]]
	then
		#currentValue=/tmp/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir
		currentValue=/tmp/que_skt_"$currentDescriptiveSelf"/bP_aS_sktU_d
		mkdir -p "$currentValue"
		
		#_relink "$currentValue" "$currentLink" > /dev/null 2>&1
		rm -f "$currentLink" > /dev/null 2>&1
		_safeEcho "$currentValue" > "$currentLink"
		
		_safeEcho "$currentValue"/unix.sock
		return 0
	fi
	
	
	mkdir -p "$currentValue"
	_relink "$currentValue" "$currentLink" > /dev/null 2>&1
	_safeEcho "$currentValue"/unix.sock
	
	return 0
}


_rm_socket_broadcastPipe_aggregatorStatic_unixAddress() {
	local currentDescriptiveSelf
	currentDescriptiveSelf=$(_queue_descriptiveSelf)
	[[ "$currentDescriptiveSelf" == "" ]] && _stop 1
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_lnk > /dev/null 2>&1
	
	
	
	
	rm -f "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir/unix.sock > /dev/null 2>&1
	
	rmdir "$scriptLocal"/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	rmdir "$scriptLocal"/_queue > /dev/null 2>&1
	
	
	
	rm -f rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir/unix.sock > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_dir > /dev/null 2>&1
	
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	rmdir /dev/shm/queue_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	
	
	rm -f "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir/unix.sock > /dev/null 2>&1
	
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir > /dev/null 2>&1
	
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue/broadcastPipe_aggregatorStatic_socketUNIX_dir > /dev/null 2>&1
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local/_queue > /dev/null 2>&1
	rmdir "$tmpMSW"/queue_"$currentDescriptiveSelf"/_local > /dev/null 2>&1
	
	
	
	rm -f /tmp/que_skt_"$currentDescriptiveSelf"/bP_aS_sktU_d/unix.sock > /dev/null 2>&1
	rmdir /tmp/que_skt_"$currentDescriptiveSelf"/bP_aS_sktU_d > /dev/null 2>&1
	rmdir /tmp/que_skt_"$currentDescriptiveSelf" > /dev/null 2>&1
	
	
	return 0
}




















_default_page_write_maxTime() {
	local currentValue
	currentValue=725
	_if_cygwin && currentValue=4475
	echo "$currentValue"
}

_default_page_write_maxBytes() {
	local currentValue
	currentValue=86400
	#_if_cygwin && currentValue=864000
	echo "$currentValue"
}



_default_page_read_maxTime() {
	local currentValue
	currentValue=100
	_if_cygwin && currentValue=575
	echo "$currentValue"
}





_broadcastPipe_page_read_maxTime() {
	local currentValue
	currentValue=100
	_if_cygwin && currentValue=975
	echo "$currentValue"
}















# ATTENTION: Only the test procedures are disabled if the 'queue' dependency is not declared. Due to the lengthy timing required to reliabily test the inherently unpredictability of any InterProcess-Communication with non-dedicated non-realtime software.
unset _test_queue
unset _test_selfTime
unset _test_bashTime
unset _test_filemtime
unset _test_timeoutRead
#unset _timetest
unset _test_broadcastPipe_page
unset _test_broadcastPipe_aggregatorStatic






# "$1" == inputBufferDir
# "$2" == inputFilesPrefix
# "$3" == maxTime (approximately how many milliseconds buffer should be checked for new data)
# "$4" == maxBytes (IGNORED)
# "$ub_force_limit_page_rate"
#	'' == Write new pages as fast as buffers fill up. Readers may miss some pages. (Default. Strongly recommended.)
#	'true' == Write only one page per "$maxTime" interval. WARNING: Writes may backlog indefinitely, breaking real-time messaging. (IGNORED by '_page_read')
#	'false' == Write and read new pages continiously. WARNING: Read processes will consume 100% CPU. Readers may still miss some pages, although reads may happen faster than writes.
_page_read() {
	local inputBufferDir="$1"
	local inputFilesPrefix="$2"
	local service_inputBufferDir
	if [[ "$inputBufferDir" == "" ]] || [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		! mkdir -p "$inputBufferDir" && return 1
		
		service_inputBufferDir="$current_demand_dir"/inputBufferDir
		
		[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix='out-'
	fi
	
	
	! mkdir -p "$inputBufferDir" && return 1
	! [[ -e "$inputBufferDir" ]] && return 1
	! [[ -d "$inputBufferDir" ]] && return 1
	
	local currentMaxTime
	currentMaxTime="$3"
	# 6/60Hz == 100ms , loop time ~ 35ms
	# 0.1s desired minimum sleep
	#[[ "$currentMaxTime" == "" ]] && currentMaxTime=175
	[[ "$currentMaxTime" == "" ]] && currentMaxTime=$(_default_page_read_maxTime)
	
	local currentMaxTime_seconds
	currentMaxTime_seconds=$(bc <<< "$currentMaxTime * 0.001")
	
	
	local measureTickA
	local measureTickB
	
	while true
	do
		if [[ "$service_inputBufferDir" != "" ]]
		then
			#[[ ! -d "$service_inputBufferDir" ]] && return 0
			[[ -e "$service_inputBufferDir"/terminate ]] && return 0
		fi
		
		[[ "$ub_force_limit_page_rate" != 'false' ]] && sleep "$currentMaxTime_seconds"
		
		[[ -e "$inputBufferDir"/"$inputFilesPrefix"tick ]] && measureTickA=$(head -n 1 "$inputBufferDir"/"$inputFilesPrefix"tick 2>/dev/null)
		[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && continue
		
		[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
		[[ "$measureTickA" == "$measureTickB" ]] && continue
		
		cat "$inputBufferDir"/"$inputFilesPrefix""$measureTickA" 2>/dev/null
		
		measureTickB="$measureTickA"
	done
}





# "$1" == "$inputTickFile"
# "$2" == "$inputFilesPrefix"
# "$3" == "sessionid" (optional)
_page_read_single() {
	local inputTickFile="$1"
	local inputFilesPrefix="$2"
	local currentSession="$3"
	if [[ "$inputTickFile" == "" ]] && [[ "$inputFilesPrefix" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputTickFile="$current_demand_dir"/outputBufferDir/out-tick
		
		[[ "$currentSession" == "" ]] && currentSession="single"
		[[ "$currentSession" == "" ]] && currentSession="false"
	fi
	[[ "$currentSession" == "" ]] && currentSession="$sessionid"
	
	
	measureTickA=$(head -n 1 "$inputTickFile" 2>/dev/null)
	[[ "$measureTickA" != '0' ]] && [[ "$measureTickA" != '1' ]] && [[ "$measureTickA" != '2' ]] && return 0
	
	if [[ "$currentSession" != 'false' ]]
	then
		measureTickB=$(head -n 1  "$inputTickFile"-prev-"$currentSession" 2>/dev/null)
		
		[[ "$measureTickB" == '' ]] && measureTickB='doNotMatch'
		[[ "$measureTickA" == "$measureTickB" ]] && return 0
	fi
	
	currentExitStatus='0'
	
	cat ${inputTickFile/-tick/}-"$measureTickA" 2>/dev/null
	[[ "$?" != '0' ]] && currentExitStatus='1'
	
	if [[ "$currentSession" != 'false' ]]
	then
		cp "$inputTickFile" "$inputTickFile"-prev-"$currentSession" 2>/dev/null
		[[ "$?" != '0' ]] && currentExitStatus='1'
	fi
	
	if [[ "$currentExitStatus" != '0' ]]
	then
		rm -f "$inputTickFile" > /dev/null 2>&1
		return "$currentExitStatus"
	fi
	
	return 0
}




# Intended to be called by users and programs which are only able to call one other program which must accept both standard input/output connections.
# Specifically intended to be compatible with 'socat' .
# "$1" == inputBufferDir (inverted - typically output of broadcastPipe)
# "$2" == outputBufferDir (inverted - typically input of broadcastPipe)
# "$4" == inputFilesPrefix
# "$4" == outputFilesPrefix
_page_converse() {
	local inputBufferDir="$1"
	local outputBufferDir="$2"
	if [[ "$inputBufferDir" == "" ]] || [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		outputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	local inputFilesPrefix="$3"
	[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix='out-'
	
	local outputFilesPrefix="$4"
	#[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix='converse-'
	#[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix=$(_uid 14)'-'
	[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix=$(_uid 18)'-'
	
	
	# DANGER: Without this hook, temporary buffers may persist indefinitely!
	export current_page_write_sessionid="$sessionid"
	export current_broadcastPipe_inputBufferDir="$inputBufferDir"
	export current_broadcastPipe_outputBufferDir="$outputBufferDir"
	export current_broadcastPipe_outputFilesPrefix="$outputFilesPrefix"
	_stop_queue_page() {
		rm -f "$current_broadcastPipe_outputBufferDir"/t_"$current_page_write_sessionid" > /dev/null 2>&1
		rm -f "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix"-tick > /dev/null 2>&1
		_sleep_spinlock
		rm -f "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix"-tick > /dev/null 2>&1
		rm -f "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix"* > /dev/null 2>&1
	}
	export ub_nohook_current_page_write_stop_queue_page='true'
	
	#echo "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix"
	
	_page_read "$inputBufferDir" "$inputFilesPrefix" &
	_page_write "$outputBufferDir" "$outputFilesPrefix"
}



_reset_page_write() {
	rm -f "$1"/temp > /dev/null 2>&1
	rm -f "$1"/"$2"tick > /dev/null 2>&1
	rm -f "$1"/"$2"0 > /dev/null 2>&1
	rm -f "$1"/"$2"1 > /dev/null 2>&1
	rm -f "$1"/"$2"2 > /dev/null 2>&1
}

# "$1" == outputBufferDir
# "$2" == outputFilesPrefix
# "$3" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick)
# "$4" == maxBytes (how many bytes should be allowed to 'accumulate' in the buffer before writing out a new tick) (MAY BE IGNORED)
# "$ub_force_limit_page_rate"
#	'' == Write new pages as fast as buffers fill up. Readers may miss some pages. (Default. Strongly recommended.)
#	'true' == Write only one page per "$maxTime" interval. WARNING: Writes may backlog indefinitely, breaking real-time messaging.
#	'false' == Write and read new pages continiously. WARNING: Read processes will consume 100% CPU. Readers may still miss some pages, although reads may happen faster than writes. (IGNORED by '_page_write')
_page_write() {
	local outputBufferDir="$1"
	local outputFilesPrefix="$2"
	if [[ "$outputBufferDir" == "" ]] || [[ "$outputFilesPrefix" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		outputBufferDir="$current_demand_dir"/inputBufferDir
		! mkdir -p "$outputBufferDir" && return 1
		
		[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix='stream-'
	fi
	
	
	! mkdir -p "$outputBufferDir" && return 1
	! [[ -e "$outputBufferDir" ]] && return 1
	! [[ -d "$outputBufferDir" ]] && return 1
	
	if [[ "$ub_nohook_current_page_write_stop_queue_page" != 'true' ]] && ! [[ -e "$safeTmp" ]]
	then
		export current_page_write_outputBufferDir="$outputBufferDir"
		export current_page_write_sessionid="$sessionid"
		_stop_queue_page() {
			rm -f "$current_page_write_outputBufferDir"/t_"$current_page_write_sessionid" > /dev/null 2>&1
		}
	fi
	
	
	# https://stackoverflow.com/questions/13889659/read-a-file-by-bytes-in-bash
	# https://www.cyberciti.biz/faq/linux-unix-read-one-character-atatime-while-loop/
		# 'The way using `read -r -n1` for reading every character is wrong, it can’t handle multi-byte characters.'
	#echo test | while IFS= read -r -n2 car;do [ "$car" ] && echo -n "$car" || echo ; sleep 1 ; done
	
	# Inaccurate. Tests with random data ('/dev/urandom') seem to show errors.
# 	local currentString
# 	export IFS=
# 	export LANG=C
# 	export LC_ALL=C
# 	#LANG=C IFS= read -r -d '' -n 1 currentString
# 	while read -r -d '' -n 1 currentString
# 	do
# 		#[ "$currentString" ] && echo -n "$currentString" || echo
# 		[ "$currentString" ] && printf '%b' "$currentString" || echo
# 	done
	
# 	# Accurate, albeit extremely slow.
# 	while head --bytes=1
# 	do
# 		true
# 	done
	
	
	local currentMaxTime
	local currentMaxBytes
	currentMaxTime="$3"
	currentMaxBytes="$4"
	
	
	[[ "$currentMaxTime" == "" ]] && currentMaxTime=$(_default_page_write_maxTime)
	[[ "$currentMaxBytes" == "" ]] && currentMaxBytes=$(_default_page_write_maxBytes)
	
	local currentMaxTime_seconds
	currentMaxTime_seconds=$(bc <<< "$currentMaxTime * 0.001")
	
	
	
	local measureDateA
	local measureDateB
	local measureDateDifference
	
	measureDateA=$(date +%s%N | cut -b1-13)
	
	local currentTick
	currentTick=
	[[ -e "$outputBufferDir"/"$outputFilesPrefix"tick ]] && currentTick=$(head -c 1 "$outputBufferDir"/"$outputFilesPrefix"tick)
	( [[ "$currentTick" == '0' ]] || [[ "$currentTick" == '1' ]] || [[ "$currentTick" == '2' ]] ) && let currentTick="$currentTick"+1
	[[ "$currentTick" != '0' ]] && [[ "$currentTick" != '1' ]] && [[ "$currentTick" != '2' ]] && [[ "$currentTick" != '3' ]] && currentTick='0'
	[[ "$currentTick" -ge '3' ]] && currentTick=0
	local currentTempSize
	currentTempSize='0'
	rm -f "$outputBufferDir"/t_"$sessionid" > /dev/null 2>&1
	rm -f "$outputBufferDir"/"$outputFilesPrefix"tick > /dev/null 2>&1
	rm -f "$outputBufferDir"/"$outputFilesPrefix"0 > /dev/null 2>&1
	rm -f "$outputBufferDir"/"$outputFilesPrefix"1 > /dev/null 2>&1
	rm -f "$outputBufferDir"/"$outputFilesPrefix"2 > /dev/null 2>&1
	#while _timeout "$currentMaxTime_seconds" head --bytes="$currentMaxBytes" 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	#while _timeout "$currentMaxTime_seconds" cat 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	#while "$scriptAbsoluteLocation" _bin cat | _timeout "$currentMaxTime_seconds" dd bs="$currentMaxBytes" count=1 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	#while _timeout "$currentMaxTime_seconds" ( ! dd bs="$currentMaxBytes" count=1 2>/dev/null >> "$outputBufferDir"/t_"$sessionid" && rm -f "$outputBufferDir"/t_"$sessionid" > /dev/null 2>&1 )
	#while cat 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	#while _timeout "$currentMaxTime_seconds" head --bytes="2" 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	#while _timeout "$currentMaxTime_seconds" dd bs="$currentMaxBytes" count=1 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	
	#while cat 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	while _timeout "$currentMaxTime_seconds" dd bs="$currentMaxBytes" count=1 2>/dev/null >> "$outputBufferDir"/t_"$sessionid"
	do
		#[[ ! -d "$outputBufferDir" ]] && return 0
		[[ -e "$outputBufferDir"/terminate ]] && return 0
		
		#true | cat "$outputBufferDir"/t_"$sessionid" > /dev/tty
		measureDateB=$(true | date +%s%N | cut -b1-13)
		measureDateDifference=$(bc <<< "$measureDateB - $measureDateA")
		
		currentTempSize='0'
		[[ -s "$outputBufferDir"/t_"$sessionid" ]] && currentTempSize=$(true | stat -c%s "$outputBufferDir"/t_"$sessionid" 2>/dev/null)
		[[ "$currentTempSize" == "" ]] && currentTempSize='0'
		#[[ -s "$outputBufferDir"/t_"$sessionid" ]] && true | stat -c%s "$outputBufferDir"/t_"$sessionid" > /dev/tty
		#[[ "$rewrite" == 'true' ]] && [[ -s "$outputBufferDir"/t_"$sessionid" ]] && true | stat -c%s "$outputBufferDir"/t_"$sessionid" > /dev/tty
		
		#[[ "$currentTempSize" -gt "0" ]] && true | echo "$measureDateDifference" "$currentMaxTime" > /dev/tty
		if [[ "$currentTempSize" -gt "0" ]] && ( [[ "$measureDateDifference" -ge "$currentMaxTime" ]] || [[ "$currentTempSize" -ge "$currentMaxBytes" ]] )
		then
			# ATTENTION: Optional 'page rate' limiting.
			# If buffer was completely filled, then ' _timeout "$currentMaxTime_seconds" ' may not have completed. A delay may ensure '_page_read' has enough time to notice a tick, before new pages are written.
			# No production use. Expected to be set only for benchmarking, diagnostics, etc.
			# WARNING: Beware this is bad for real-time messaging. Much better to discard some flood data.
			[[ "$ub_force_limit_page_rate" == 'true' ]] && [[ "$currentTempSize" -ge "$currentMaxBytes" ]] && sleep "$currentMaxTime_seconds"
			
			#rm -f "$outputBufferDir"/"$outputFilesPrefix""$currentTick" > /dev/null 2>&1
			true | mv "$outputBufferDir"/t_"$sessionid" "$outputBufferDir"/"$outputFilesPrefix""$currentTick"
			true | echo -n "$currentTick" > "$outputBufferDir"/"$outputFilesPrefix"tick-temp
			true | mv "$outputBufferDir"/"$outputFilesPrefix"tick-temp "$outputBufferDir"/"$outputFilesPrefix"tick
			
			measureDateA=$(true | date +%s%N | cut -b1-13)
			#echo "$currentTick" > /dev/tty
			let currentTick="$currentTick"+1
		fi
		
		[[ "$currentTick" -ge '3' ]] && currentTick=0
	done
	
	return 0
}




# "$1" == outputBufferDir
# "$2" == outputFilesPrefix
# "$3" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick)
# DANGER: Any changes may unexpectedly break '_broadcastPipe' ! Takes standard input from 'script' run by 'find' 'exec' .
_page_write_single() {
	local outputBufferDir="$1"
	local outputFilesPrefix="$2"
	if [[ "$outputBufferDir" == "" ]] || [[ "$outputFilesPrefix" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		outputBufferDir="$current_demand_dir"/inputBufferDir
		! mkdir -p "$outputBufferDir" && return 1
		
		[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix='single-'
	fi
	
	local currentTmpUID
	currentTmpUID=$(_uid)
	cat 2>/dev/null >> "$outputBufferDir"/t_"$currentTmpUID"
	
	
	if ! [[ -s "$outputBufferDir"/t_"$currentTmpUID" ]] || ! _moveconfirm "$outputBufferDir"/t_"$currentTmpUID" "$outputBufferDir"/temp 2>/dev/null
	then
		rm -f "$outputBufferDir"/t_"$currentTmpUID" > /dev/null 2>&1
		return 1
	fi
	
	local currentTick
	currentTick=
	[[ -e "$outputBufferDir"/"$outputFilesPrefix"tick ]] && currentTick=$(head -c 1 "$outputBufferDir"/"$outputFilesPrefix"tick)
	( [[ "$currentTick" == '0' ]] || [[ "$currentTick" == '1' ]] || [[ "$currentTick" == '2' ]] ) && let currentTick="$currentTick"+1
	[[ "$currentTick" != '0' ]] && [[ "$currentTick" != '1' ]] && [[ "$currentTick" != '2' ]] && [[ "$currentTick" != '3' ]] && currentTick='0'
	[[ "$currentTick" -ge '3' ]] && currentTick=0
	
	mv "$outputBufferDir"/temp "$outputBufferDir"/"$outputFilesPrefix""$currentTick"
	echo -n "$currentTick" > "$outputBufferDir"/"$outputFilesPrefix"tick-temp
	mv "$outputBufferDir"/"$outputFilesPrefix"tick-temp "$outputBufferDir"/"$outputFilesPrefix"tick
	
	
	#rm -f "$outputBufferDir"/temp > /dev/null 2>&1
	#rm -f "$outputBufferDir"/"$outputFilesPrefix"tick-temp > /dev/null 2>&1
	return 0
}

_here_broadcastPipe_page_read_single() {
	cat << CZXWXcRMTo8EmM8i4d
#!/usr/bin/env bash

CZXWXcRMTo8EmM8i4d
	
	declare -f _page_read_single
	declare -f _broadcastPipe_page_read_single
	
	cat << CZXWXcRMTo8EmM8i4d
_broadcastPipe_page_read_single "\$@"

CZXWXcRMTo8EmM8i4d

}




# "$1" == inputBufferDir
# "$2" == outputBufferDir
# "$3" == maxTime (approximately how many milliseconds buffer should be checked for new data)
# "$4" == maxBytes (how many bytes should be allowed to 'accumulate' in the buffer before writing out a new tick) (MAY BE IGNORED)
# "$5" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick) (MAY BE IGNORED)
_broadcastPipe_page_write() {
	#true | _reset_page_write "$2" "out-" "$5" "$4"
	
	#export rewrite=true
	# DANGER: Continiously piping through '_page_write' may be inherently less reliable than '_page_write_single' .
	#_page_write "$2" "out-" "$5" "$4"
	
	_page_write_single "$2" "out-" "$5" "$4"
	
}


_broadcastPipe_page_read_single() {
	_page_read_single "$@"
}


# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_page() {
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 -type f ! -name 'terminate' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/*-tick-prev* > /dev/null 2>&1
	
	
	return 0
}




# Reduce environment to perhaps improve performance.
_env_broadcastPipe_page() {
	env -i HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" sessionid="$sessionid" LD_PRELOAD="$LD_PRELOAD" USER="$USER" ub_force_limit_page_rate="$ub_force_limit_page_rate" "$@"
}


# WARNING: May delete all existing files (to 'clear the buffers').
# WARNING: Must be running before any desired data is written to buffer - existing buffers are always discarded.
# "$1" == inputBufferDir
# "$2" == outputBufferDir
# "$3" == maxTime (approximately how many milliseconds buffer should be checked for new data) (MAY ALSO PARTIALLY OR FULLY DISPLACE VALUE OF "$5")
# "$4" == maxBytes (how many bytes should be allowed to 'accumulate' in the buffer before writing out a new tick) (MAY BE IGNORED)
# "$5" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick) (MAY BE IGNORED)
_broadcastPipe_page_read() {
	_start
	
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	
	local current_demand_dir
	current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
	
	local currentMaxTime
	currentMaxTime="$3"
	[[ "$currentMaxTime" == "" ]] && currentMaxTime="$(_broadcastPipe_page_read_maxTime)"
	
	local currentMaxTime_seconds
	currentMaxTime_seconds=$(bc <<< "$currentMaxTime * 0.001")
	
	# May perhaps take effect when SIGTERM is received directly (eg. when SIGTERM may be sent to all processes) .
	export current_broadcastPipe_inputBufferDir="$1"
	export current_broadcastPipe_outputBufferDir="$2"
	export current_broadcastPipe_current_demand_dir="$current_demand_dir"
	_stop_queue_page() {
		#_terminate_broadcastPipe_page "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		_terminate_broadcastPipe_page_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		sleep 1
		_rm_broadcastPipe_page "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
		
		_sleep_spinlock
		rm -f "$current_broadcastPipe_inputBufferDir"/reset > /dev/null 2>&1
		rm -f "$current_broadcastPipe_inputBufferDir"/terminate > /dev/null 2>&1
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
	}
	
	rm -f "$1"/reset > /dev/null 2>&1
	rm -f "$1"/terminate > /dev/null 2>&1
	#_rm_broadcastPipe_page "$@"
	
	_here_broadcastPipe_page_read_single "$@" > "$safeTmp"/broadcastPipe_page_read.sh
	chmod u+x "$safeTmp"/broadcastPipe_page_read.sh
	
	echo > "$1"/listen
	
	while [[ ! -e "$1"/terminate ]]
	do
		# WARNING: Although sequential throughput may be important in some cases, a 'pair of wires' is fundamentally not a parallel device. Simultaneous writing to aggregator should only occur during (usually undesirable) collisions. Nevertheless, processing these collisions out of order is entirely reasonable.
		# WARNING: Imposing limits on the number of inputs (eg. due to command line argument length limitations), below a few thousand, is strongly discouraged.
		# https://serverfault.com/questions/193319/a-better-unix-find-with-parallel-processing
		_env_broadcastPipe_page find "$1" -mindepth 1 -maxdepth 1 -mmin -0.4 -type f -name '*-tick' -exec "$safeTmp"/broadcastPipe_page_read.sh {} \; 2> /dev/null | _broadcastPipe_page_write "" "$2" "$3" "$4" "$5" 2>/dev/null
		
		# DANGER: Allowing this bus to run without any idle time may result in an immediately overwhelming processor load, if find loop is allowed to 'fork' new processes.
		[[ "$ub_force_limit_page_rate" != 'false' ]] && sleep "$currentMaxTime_seconds"
		#sleep "$currentMaxTime_seconds"
	done
	
	# WARNING: Since only one program may successfully remove a single file, that mechanism should allow only one 'broadcastPipe' process to remain in the unlikely case multiple were somehow started.
	[[ -e "$1"/terminate ]] && [[ -e "$1"/reset ]] && rm "$1"/reset > /dev/null 2>&1 && _broadcastPipe_page_read "$@"
	rm -f "$1"/reset > /dev/null 2>&1
	
	_rm_broadcastPipe_page "$@"
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
	
	_sleep_spinlock
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
	
	_stop
}








_here_rmloop_broadcastPipe_page() {
	_here_header_bash_or_dash "$@"
	
	declare -f _rmloop_broadcastPipe_page
	
	cat << CZXWXcRMTo8EmM8i4d
_rmloop_broadcastPipe_page "\$@"

CZXWXcRMTo8EmM8i4d

}


_rmloop_broadcastPipe_page() {
	while true
	do
		rm -f "$1"/rmloop > /dev/null 2>&1
		
		#sleep 1
		sleep 0.1
	done
	
}


_safePath_demand_broadcastPipe_page() {
	if [[ "$1" == "$scriptLocal"* ]] && ! _if_cygwin
	then
		return 0
	fi
	if [[ "$1" == '/dev/shm/'* ]] && ! _if_cygwin
	then
		return 0
	fi
	
	
	! _safePath "$1" && _stop 1
	return 0
}

# WARNING: Deletes all existing files (to 'clear the buffers').
# "$1" == inputBufferDir
# "$2" == outputBufferDir
# "$3" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick)
# "$4" == maxBytes (how many bytes should be allowed to 'accumulate' in the buffer before writing out a new tick)
_demand_broadcastPipe_page_sequence() {
	_start
	
	! mkdir -p "$1" && _stop 1
	! mkdir -p "$2" && _stop 1
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	if ! _safePath_demand_broadcastPipe_page "$@"
	then
		_terminate_broadcastPipe_page "$1"
		_stop 1
	fi
	
	_here_rmloop_broadcastPipe_page "$@" > "$safeTmp"/_rmloop_broadcastPipe_page
	chmod u+x "$safeTmp"/_rmloop_broadcastPipe_page
	
	echo > "$1"/rmloop
	
	
	_sleep_spinlock
	
	
	! [[ -e "$1"/rmloop ]] && return 0
	! mv "$1"/rmloop "$1"/rmloop.rm > /dev/null 2>&1 && return 0
	if ! rm "$1"/rmloop.rm > /dev/null 2>&1
	then
		rm -f "$1"/rmloop.rm > /dev/null 2>&1
		return 0
	fi
	
	
	_rm_broadcastPipe_page "$@"
	"$safeTmp"/_rmloop_broadcastPipe_page "$@" &
	#"$scriptAbsoluteLocation" _rmloop_broadcastPipe_page "$@" &
	
	
	#"$scriptAbsoluteLocation" _broadcastPipe_page_read "$@" | _broadcastPipe_page_write "$@"
	"$scriptAbsoluteLocation" _broadcastPipe_page_read "$@"
	
	# May not be necessary. Theoretically redundant.
	local currentStopJobs
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	[[ "$currentStopJobs" != "" ]] && kill "$currentStopJobs" > /dev/null 2>&1
	
	
	_sleep_spinlock
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
	
	_stop
}

_demand_broadcastPipe_page() {
	local inputBufferDir="$1"
	local outputBufferDir="$2"
	shift
	shift
	
	if [[ "$inputBufferDir" == "" ]] || [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
		outputBufferDir="$current_demand_dir"/outputBufferDir
	elif [[ -e "$safeTmp" ]]
	then
		# DANGER: Without this hook, temporary "$safeTmp" directories may persist indefinitely!
		# Only hook '_stop_queue_page' if called from within another 'sequence' (to cause termination of service when that 'sequence' terminates for any reason).
		export current_broadcastPipe_inputBufferDir="$inputBufferDir"
		export current_broadcastPipe_outputBufferDir="$outputBufferDir"
		_stop_queue_page() {
			_terminate_broadcastPipe_page "$current_broadcastPipe_inputBufferDir" 2> /dev/null
			#_terminate_broadcastPipe_page_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
			#sleep 1
			_rm_broadcastPipe_page "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
			[[ "$inputBufferDir" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
		}
	fi
	
	
	"$scriptAbsoluteLocation" _demand_broadcastPipe_page_sequence "$inputBufferDir" "$outputBufferDir" "$@" &
	while [[ -e "$inputBufferDir"/rmloop ]]
	do
		sleep 0.1
	done
	[[ ! -e "$inputBufferDir"/listen ]] && _sleep_spinlock
	[[ ! -e "$inputBufferDir"/listen ]] && _sleep_spinlock
	[[ ! -e "$inputBufferDir"/listen ]] && return 1
	
	[[ "$ub_force_limit_page_rate" == 'true' ]] && _sleep_spinlock
	#[[ "$ub_force_limit_page_rate" == 'false' ]] && _sleep_spinlock
	
	disown -a -h -r
	disown -a -r
	
	return 0
}


_terminate_broadcastPipe_page_fast() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	[[ "$inputBufferDir" == "" ]] && return 1
	[[ "$inputBufferDir" == "/" ]] && return 1
	[[ ! -e "$inputBufferDir" ]] && return 1
	
	echo > "$inputBufferDir"/terminate
}

_terminate_broadcastPipe_page() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	mkdir -p "$inputBufferDir"
	
	_terminate_broadcastPipe_page_fast "$@"
	_sleep_spinlock
	
	rm -f "$inputBufferDir"/terminate > /dev/null 2>&1
	[[ "$inputBufferDir" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_page
	
	_sleep_spinlock
	
	return 0
}

# WARNING: No production use. Intended for end-user (interactive) only.
# WARNING: Untested.
# One possible benefit - a reset should happen much more quickly than a '_terminate ..." "_demand ..." cycle due to lack of spinlock sleep.
_reset_broadcastPipe_page() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_page "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	mkdir -p "$inputBufferDir"
	
	[[ "$inputBufferDir" == "" ]] && return 1
	[[ "$inputBufferDir" == "/" ]] && return 1
	[[ ! -e "$inputBufferDir" ]] && return 1
	
	echo > "$inputBufferDir"/reset
	echo > "$inputBufferDir"/terminate
}


# Under ideal conditions, small quantities of data may be continiously copied completely or identically (<10M).
#./ubiquitous_bash.sh _page_read ./outputBufferDir 'testfill-' "175" > ./rewrite
#cat ./testfill | pv | ./ubiquitous_bash.sh _page_write ./outputBufferDir 'testfill-' "725" "86400"
_benchmark_page() {
	_start
	
	export ub_force_limit_page_rate='false'
	local current_Write_MaxBytes=864000
	
	
	#dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1M count=4 > /dev/null 2>&1
	
	
	#>&2 echo "read"
	#_messagePlain_probe "$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'testfill-' "$current_Read_MaxTime" \> "$safeTmp"/rewrite
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'testfill-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	sleep 1
	
	#>&2 echo "write"
	#_messagePlain_probe _timeout 150 cat "$safeTmp"/testfill \| pv \| _timeout 15 "$scriptAbsoluteLocation" _page_write "$safeTmp"/outputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/outputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	
	(
	cd "$safeTmp"
	du -sh ./testfill ./rewrite
	md5sum ./testfill ./rewrite
	)
	
	_stop
}



# Modify as required for MSW/Cygwin compatibility.
_aggregator_fifo() {
	mkfifo "$@"
}



# "$1" == inputBufferDir
# "$2" == inputFilesPrefix (MUST adhere to strictly blank or 18 alphanumeric characters!)
_aggregator_read_procedure() {
	local inputBufferDir="$1"
	local inputFilesPrefix="$2"
	local service_inputBufferDir
	#if [[ "$inputBufferDir" == "" ]] || [[ "$inputBufferDir" == "" ]]
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		! mkdir -p "$inputBufferDir" && return 1
		
		service_inputBufferDir="$current_demand_dir"/inputBufferDir
		
		#[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix='out-'
	fi
	
	[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix=$(_uid 18)
	
	
	! mkdir -p "$inputBufferDir" && return 1
	! [[ -e "$inputBufferDir" ]] && return 1
	! [[ -d "$inputBufferDir" ]] && return 1
	
	
	
	
	local currentFifo
	currentFifo="$inputBufferDir"/"$inputFilesPrefix"
	_aggregator_fifo "$currentFifo"
	
	
	#if ! [[ -e "$safeTmp" ]]
	#then
		if [[ "$ub_nohook_current_aggregator_write_stop_queue_aggregator" != 'true' ]]
		then
			export current_aggregator_read_fifo="$currentFifo"
			_stop_queue_aggregator() {
				rm -f "$current_aggregator_read_fifo" > /dev/null 2>&1
			}
		fi
	#fi
	
	# WARNING: Removal of FIFO may not occur while not connected to both input and output. Apparently 'trap' does not work here.
	# WARNING: May be incompatible with '_timeout' .
	cat "$currentFifo"
	
	rm -f "$currentFifo" > /dev/null 2>&1
	
	return 0
}



_aggregator_read_sequence() {
	_start
	
	_aggregator_read_procedure "$@"
	
	_stop
}

_aggregator_read() {
	"$scriptAbsoluteLocation" _aggregator_read_sequence "$@"
}


# "$1" == inputBufferDir (inverted, client input, service output)
# "$2" == outputBufferDir (OPTIONAL. inverted)
_aggregatorStatic_read() {
	if ! _aggregatorStatic_delayIPC_EmptyOrWaitOrReset "$2" "$1"
	then
		return 1
	fi
	_aggregator_read_procedure "$1"
	#"$scriptAbsoluteLocation" _aggregator_read_sequence "$2"
	#"$scriptAbsoluteLocation" _aggregator_read_sequence "$@"
}





_aggregator_delayIPC_isEmpty() {
	# Although this may seem inefficient, the alternatives of calling external programs, filling variables, or setting 'shopt', may also be undesirable.
	# https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
	currentIsEmptyOut='true'
	for currentFile in "$1"/??????????????????
	do
		[[ "$currentFile" != *'??????????????????' ]] && currentIsEmptyOut='false' && break
	done
	
	[[ "$currentIsEmptyOut" == 'true' ]] && return 0
	return 1
}

_aggregator_delayIPC_isReset() {
	#&& [[ ! -e "$1"/reset ]] && [[ ! -e "$1"/terminate ]] && [[ ! -e "$1"/rmloop ]]
	# && ! _aggregator_delayIPC_isEmpty "$2"
	#[[ ! -e "$1"/attempt ]]
	
	if [[ -e "$1"/vaccancy ]] && _aggregator_delayIPC_isEmpty "$1" && _aggregator_delayIPC_isEmpty "$2"
	then
		return 0
	fi
	return 1
}


# May allow a new set of 'connections' to replace an existing (presumably broken) set of 'connections'.
# May require >>24seconds delay to allow previous (invalid) 'delay: Inter-Process Communications' to expire.
# WARNING: May not be compatible with '_skip_broadcastPipe_aggregatorStatic' .
# "$1" == inputBufferDir
# "$2" == outputBufferDir
# ATTENTION: EXAMPLE
#./lean.sh _aggregatorStatic_delayIPC_EmptyOrWaitOrReset && echo done && ./lean.sh _aggregator_write
#/lean.sh _aggregatorStatic_delayIPC_EmptyOrWaitOrReset && echo done && ./lean.sh _aggregator_read
_aggregator_delayIPC_EmptyOrWaitOrReset() {
	local inputBufferDir="$1"
	local outputBufferDir="$2"
	
	if [[ "$inputBufferDir" == "" ]] || [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregator_delayIPC_EmptyOrWaitOrReset "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		# Not inverted. After all, this function will typically be called by other functions, and so uses the service convention.
		inputBufferDir="$current_demand_dir"/inputBufferDir
		outputBufferDir="$current_demand_dir"/outputBufferDir
	fi
	
	
	local currentIterations
	
	local currentFile
	local currentIsEmptyBuffer
	
	
	
	# DANGER: CAUTION: Relies on several relatively marginal assumptions regarding '_broadcastPipe_aggregatorStatic_read_procedure' algorithm and OS/kernel latency.
	
	
	# Expect 18seconds total sleep after all iterations and one attempt.
	currentIterations='0'
	currentAttempts='0'
	while [[ "$currentIterations" -lt 6 ]] && [[ "$currentAttempts" -lt 3 ]] && ! _aggregator_delayIPC_isReset "$inputBufferDir" "$outputBufferDir"
	do
		sleep 3
		let currentIterations="$currentIterations"+1
		
		if ! [[ "$currentIterations" -lt 6 ]]
		then
			if ! _aggregator_delayIPC_isReset "$inputBufferDir" "$outputBufferDir"
			then
				echo > "$inputBufferDir"/attempt.tmp
				_moveconfirm "$inputBufferDir"/attempt.tmp "$inputBufferDir"/attempt && _reset_broadcastPipe_aggregatorStatic "$inputBufferDir"
			fi
			#sleep 3
			currentIterations='0'
			let currentAttempts="$currentAttempts"+1
		fi
	done
	! _aggregator_delayIPC_isReset "$inputBufferDir" "$outputBufferDir" && return 1
	
	# WARNING: Delay must be <<24seconds .
	# Must be long enough to allow all waiting clients to 'see' the 'vaccancy' and 'empty' conditions, but not long enough to overrun the 'vaccancy' delay.
	# Delaying an entire '_sleep_spinlock' cycle may be undesirable in practice. Multiple clients will be connecting simultaneously, and external (or 'user') latencies may be much more likely than an extreme ~7seconds spinlock event from the kernel.
	#sleep 3
	#sleep 5
	sleep 7
	#_sleep_spinlock
	
	#if _aggregator_delayIPC_isReset "$inputBufferDir" "$outputBufferDir"
	#then
		rm -f "$inputBufferDir"/attempt.tmp > /dev/null 2>&1
		rm -f "$inputBufferDir"/attempt > /dev/null 2>&1
	#fi
	
	return 0
}

_aggregatorStatic_delayIPC_EmptyOrWaitOrReset() {
	_demand_dir_broadcastPipe_aggregator_delayIPC_EmptyOrWaitOrReset() {
		_demand_dir_broadcastPipe_aggregatorStatic "$@"
	}
	if ! true | _aggregator_delayIPC_EmptyOrWaitOrReset "$@"
	then
		return 1
	fi
	return 0
}





# Intended to be called by users and programs which are only able to call one other program which must accept both standard input/output connections.
# Specifically intended to be compatible with 'socat' .
# "$1" == inputBufferDir (inverted - typically output of broadcastPipe)
# "$2" == outputBufferDir (inverted - typically input of broadcastPipe)
# "$4" == inputFilesPrefix (MUST adhere to strictly blank or 18 alphanumeric characters!)
# "$4" == outputFilesPrefix (MUST adhere to strictly blank or 18 alphanumeric characters!)
_aggregator_converse_procedure() {
	local inputBufferDir="$1"
	local outputBufferDir="$2"
	if [[ "$inputBufferDir" == "" ]] || [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregator_converse "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/outputBufferDir
		outputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	local inputFilesPrefix="$3"
	[[ "$inputFilesPrefix" == "" ]] && inputFilesPrefix=$(_uid 18)
	
	local outputFilesPrefix="$4"
	[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix=$(_uid 18)
	
	# DANGER: Without this hook, temporary buffers may persist indefinitely!
	# CAUTION: Reset may be necessitated - testing suggests this hook does not work.
	export current_broadcastPipe_inputBufferDir="$inputBufferDir"
	export current_broadcastPipe_outputBufferDir="$outputBufferDir"
	export current_broadcastPipe_inputFilesPrefix="$inputFilesPrefix"
	export current_broadcastPipe_outputFilesPrefix="$outputFilesPrefix"
	_stop_queue_aggregator() {
		rm -f "$current_broadcastPipe_inputBufferDir"/"$current_broadcastPipe_inputFilesPrefix" > /dev/null 2>&1
		rm -f "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix" > /dev/null 2>&1
		_sleep_spinlock
		rm -f "$current_broadcastPipe_inputBufferDir"/"$current_broadcastPipe_inputFilesPrefix" > /dev/null 2>&1
		rm -f "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix" > /dev/null 2>&1
	}
	export ub_nohook_current_aggregator_write_stop_queue_aggregator='true'
	
	#echo "$current_broadcastPipe_outputBufferDir"/"$current_broadcastPipe_outputFilesPrefix"
	
	_aggregator_read_procedure "$inputBufferDir" "$inputFilesPrefix" &
	_aggregator_write_procedure "$outputBufferDir" "$outputFilesPrefix"
}

_aggregatorStatic_converse_noEmptyOrWaitOrReset() {
	_demand_dir_broadcastPipe_aggregator_converse() {
		_demand_dir_broadcastPipe_aggregatorStatic "$@"
	}
	_aggregator_converse_procedure "$@" 2> /dev/null
}

_aggregatorStatic_converse_EmptyOrWaitOrReset() {
	if ! _aggregatorStatic_delayIPC_EmptyOrWaitOrReset "$2" "$1" 2> /dev/null
	then
		return 1
	fi
	_aggregatorStatic_converse_noEmptyOrWaitOrReset "$@" 2> /dev/null
}

_aggregatorStatic_converse() {
	_aggregatorStatic_converse_EmptyOrWaitOrReset "$@" 2> /dev/null
}


# "$1" == outputBufferDir
# "$2" == outputFilesPrefix (MUST adhere to strictly blank or 18 alphanumeric characters!)
_aggregator_write_procedure() {
	local outputBufferDir="$1"
	local outputFilesPrefix="$2"
	#if [[ "$outputBufferDir" == "" ]] || [[ "$outputFilesPrefix" == "" ]]
	if [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		outputBufferDir="$current_demand_dir"/inputBufferDir
		! mkdir -p "$outputBufferDir" && return 1
		
		#[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix='stream-'
	fi
	
	[[ "$outputFilesPrefix" == "" ]] && outputFilesPrefix=$(_uid 18)
	
	
	! mkdir -p "$outputBufferDir" && return 1
	! [[ -e "$outputBufferDir" ]] && return 1
	! [[ -d "$outputBufferDir" ]] && return 1
	
	
	
	
	local currentFifo
	currentFifo="$outputBufferDir"/"$outputFilesPrefix"
	_aggregator_fifo "$currentFifo"
	
	#if ! [[ -e "$safeTmp" ]]
	#then
		if [[ "$ub_nohook_current_aggregator_write_stop_queue_aggregator" != 'true' ]]
		then
			export current_aggregator_write_fifo="$currentFifo"
			_stop_queue_aggregator() {
				rm -f "$current_aggregator_write_fifo" > /dev/null 2>&1
			}
		fi
	#fi
	
	# WARNING: Removal of FIFO may not occur while not connected to both input and output. Apparently 'trap' does not work here.
	# WARNING: May be incompatible with '_timeout' .
	cat > "$currentFifo"
	
	rm -f "$currentFifo" > /dev/null 2>&1
	
	return 0
}



_aggregator_write_sequence() {
	_start
	
	_aggregator_write_procedure "$@" 2> /dev/null
	
	_stop
}

_aggregator_write() {
	"$scriptAbsoluteLocation" _aggregator_write_sequence "$@" 2> /dev/null
}


# "$1" == outputBufferDir (inverted, client output, service input)
# "$2" == inputBufferDir (OPTIONAL. inverted)
_aggregatorStatic_write() {
	if ! _aggregatorStatic_delayIPC_EmptyOrWaitOrReset "$1" "$2"
	then
		return 1
	fi
	_aggregator_write_procedure "$1" 2> /dev/null
	#"$scriptAbsoluteLocation" _aggregator_write_sequence "$1" 2> /dev/null
	#"$scriptAbsoluteLocation" _aggregator_write_sequence "$@" 2> /dev/null
}





# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_aggregatorStatic() {
	! _safePath_demand_broadcastPipe_aggregatorStatic "$1" && return 1
	! _safePath_demand_broadcastPipe_aggregatorStatic "$2" && return 1
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 \( -type f -o -type p -o -type l \) ! -name 'terminate' ! -name 'reset' ! -name 'attempt' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	
	return 0
}

# ATTENTION: Override with 'ops' or similar.
_rm_broadcastPipe_aggregatorStatic_keepListen() {
	! _safePath_demand_broadcastPipe_aggregatorStatic "$1" && return 1
	! _safePath_demand_broadcastPipe_aggregatorStatic "$2" && return 1
	
	#[[ -e "$1" ]] && [[ "$1" != "" ]] && rm -f "$1"/* > /dev/null 2>&1
	[[ -e "$1" ]] && [[ "$1" != "" ]] && find "$1" -mindepth 1 -maxdepth 1 \( -type f -o -type p -o -type l \) ! -name 'terminate' ! -name 'listen' ! -name 'attempt' -delete > /dev/null 2>&1
	[[ -e "$2" ]] && [[ "$2" != "" ]] && rm -f "$2"/* > /dev/null 2>&1
	
	
	return 0
}



_jobs_terminate_aggregatorStatic_procedure() {
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	# WARNING: Although usually bad practice, it is useful for the spaces between PIDs to be interpreted in this case.
	# DANGER: Apparently, it is possible for some not running background jobs to be included in the PID list.
	[[ "$currentStopJobs" != "" ]] && kill $currentStopJobs > /dev/null 2>&1
	kill "$1" > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '3' ]]
	do
		sleep 0.6
		let currentIterations="$currentIterations"+1
	done
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	kill -KILL $currentStopJobs > /dev/null 2>&1
	kill -KILL "$1" > /dev/null 2>&1
	
	currentIterations='0'
	while [[ $(jobs -p -r) != "" ]] && [[ "$currentIterations" -lt '16' ]]
	do
		sleep 1
		let currentIterations="$currentIterations"+1
	done
}



_broadcastPipe_aggregatorStatic_read_procedure() {
	_messageNormal 'init: _broadcastPipe_aggregatorStatic_read_procedure'
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	
	local current_demand_dir
	current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
	
	# May perhaps take effect when SIGTERM is received directly (eg. when SIGTERM may be sent to all processes) .
	export current_broadcastPipe_inputBufferDir="$1"
	export current_broadcastPipe_outputBufferDir="$2"
	export current_broadcastPipe_current_demand_dir="$current_demand_dir"
	_stop_queue_aggregatorStatic() {
		#_terminate_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		_terminate_broadcastPipe_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
		sleep 1
		_rm_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
		
		_sleep_spinlock
		rm -f "$current_broadcastPipe_inputBufferDir"/reset > /dev/null 2>&1
		rm -f "$current_broadcastPipe_inputBufferDir"/terminate > /dev/null 2>&1
		[[ "$current_broadcastPipe_inputBufferDir" == "$current_broadcastPipe_current_demand_dir"* ]] && [[ "$current_broadcastPipe_current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	}
	
	
	local currentTerminate='false'
	
	while [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentTerminate" == 'false' ]]
	do
		
		
		
		local currentIterations
		
		
		_rm_broadcastPipe_aggregatorStatic "$@"
		rm -f "$1"/reset > /dev/null 2>&1
		rm -f "$1"/terminate > /dev/null 2>&1
		
		echo > "$1"/listen
		echo > "$1"/vaccancy
		echo > "$2"/vaccancy
		
		local currentInputBufferCount='0'
		local currentInputBufferCount_prev='0'
		local currentOutputBufferCount='0'
		local currentOutputBufferCount_prev='0'
		
		local currentFile
		
		
		local currentStopJobs
		
		local currentIsEmptyOut
		
		local currentPID
		
		local noJobsTwice
		
		_messagePlain_nominal ' 0 : reached loop'
		_messagePlain_probe "$1"
		_messagePlain_probe "$2"
		while [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
		do
			_messagePlain_nominal ' 1 : loop'
			
			#rm -f "$1"/skip > /dev/null 2>&1
			
			currentInputBufferCount_prev="$currentInputBufferCount"
			currentOutputBufferCount_prev="$currentOutputBufferCount"
			#[[ $(jobs -p -r) != "" ]] && 
			while [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
			do
				_messagePlain_nominal ' 2 : wait for change'
				
				currentInputBufferCount=0
				for currentFile in "$1"/??????????????????
				do
					_messagePlain_nominal '11 : count: currentInputBufferCount= '"$currentInputBufferCount"
					[[ "$currentFile" != *'??????????????????' ]] && let currentInputBufferCount="$currentInputBufferCount"+1
				done
				
				currentOutputBufferCount=0
				for currentFile in "$2"/??????????????????
				do
					_messagePlain_nominal '11 : count: currentOutputBufferCount= '"$currentOutputBufferCount"
					[[ "$currentFile" != *'??????????????????' ]] && let currentOutputBufferCount="$currentOutputBufferCount"+1
				done
				
				_messagePlain_probe_var currentInputBufferCount_prev
				_messagePlain_probe_var currentOutputBufferCount_prev
				_messagePlain_probe_var currentInputBufferCount
				_messagePlain_probe_var currentOutputBufferCount
				
				if ( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] ) && [[ $(jobs -p -r) == "" ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ "$noJobsTwice" == 'true' ]]
				then
					_messagePlain_warn 'obscure: 2.1: change: no jobs 2x: remove: unused pipe files'
					_rm_broadcastPipe_aggregatorStatic_keepListen "$@"
					#rm -f "$1"/skip > /dev/null 2>&1
					noJobsTwice='false'
				elif ( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] ) && [[ $(jobs -p -r) == "" ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ "$noJobsTwice" != 'true' ]]
				then
					_messagePlain_warn 'obscure: 2.1: change: no jobs 1x: set: noJobsTwice'
					noJobsTwice='true'
				fi
				
				
				# DANGER: Delay time > ~24seconds may result in unused/blocking FIFO pipes remaining (additional delay in remainder of loop is tolerable).
				# Iterations >1 may reduce CPU consumption with Cygwin/MSW , assuming file exists check is reasonably efficient.
				currentIterations='0'
				while [[ "$currentIterations" -lt '3' ]] && [[ "$currentInputBufferCount" == "$currentInputBufferCount_prev" ]] && [[ "$currentOutputBufferCount" == "$currentOutputBufferCount_prev" ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]]
				do
					# If pipes are already connected, maybe delay a while longer to reduce CPU consumption.
					if [[ $(jobs -p -r) != "" ]]
					then
						_messagePlain_nominal '12 : idle: jobs: long delay'
						sleep 6
					fi
					
					# If pipes are not already connected, maybe delay a less, to improve interactivity.
					if [[ $(jobs -p -r) == "" ]]
					then
						# DANGER: CAUTION: Any 'sleep' > 3seconds (9seconds total) may break '_aggregator_delayIPC_'... .
						_messagePlain_nominal '12 : idle: no jobs: short delay'
						sleep 3
					fi
					
					let currentIterations="$currentIterations"+1
				done
			done
			#_messagePlain_warn 'obscure:  3 : done: loop: detected: new pipe files: complicated procedure: suspected failability'
			_messagePlain_good ' 3 : done: loop: detected: new pipe files'
			
			
			# ATTENTION: delay: InterProcess-Communication
			# CAUTION: Before reducing the delay (24 seconds recommended), consider that remote/peripherial may have latencies independent of any OS 'kernel', 'real-time' or otherwise!
			echo -e '\E[1;33;47m ''13 : delay: InterProcess-Communication: 24 seconds'' \E[0m'
			currentIterations='0'
			while [[ "$currentIterations" -lt 4 ]] && [[ ! -e "$1"/skip ]] && [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentOutputBufferCount" -gt 0 ]]
			#( [[ "$currentInputBufferCount" -gt 0 ]] || [[ "$currentOutputBufferCount" -gt 0 ]] )
			do
				if [[ "$currentIterations" == '0' ]]
				then
					echo > "$1"/vaccancy
					echo > "$2"/vaccancy
				fi
				
				#_messageDELAYipc
				_messagePlain_probe '13 : delay: InterProcess-Communication: 6 second iteration'
				#_messagePlain_probe '13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'
				#_messagePlain_nominal '13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'
				#echo -e '\E[1;33;47m ''13 : delay: InterProcess-Communication: 6 second iteration: 24 seconds'' \E[0m'
				sleep 6
				let currentIterations="$currentIterations"+1
			done
			if [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentOutputBufferCount" -gt 0 ]]
			then
				rm -f "$1"/vaccancy
				rm -f "$2"/vaccancy
				rm -f "$1"/attempt
				rm -f "$2"/attempt
			fi
			rm "$1"/skip > /dev/null 2>&1 && _messagePlain_good 'good: skip'
			rm -f "$1"/skip > /dev/null 2>&1
			
			currentInputBufferCount=0
			for currentFile in "$1"/??????????????????
			do
				_messagePlain_nominal '14 : count: currentInputBufferCount= '"$currentInputBufferCount"
				[[ "$currentFile" != *'??????????????????' ]] && let currentInputBufferCount="$currentInputBufferCount"+1
			done
			
			currentOutputBufferCount=0
			for currentFile in "$2"/??????????????????
			do
				_messagePlain_nominal '15 : count: currentOutputBufferCount= '"$currentOutputBufferCount"
				[[ "$currentFile" != *'??????????????????' ]] && let currentOutputBufferCount="$currentOutputBufferCount"+1
			done
			
			
			# https://stackoverflow.com/questions/25906020/are-pid-files-still-flawed-when-doing-it-right/25933330
			# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits
			
			_messagePlain_nominal ' 4 : _jobs_terminate_aggregatorStatic_procedure'
			_jobs_terminate_aggregatorStatic_procedure "$currentPID"
			
			_messagePlain_nominal ' 5 : detect: currentIsEmptyOut'
			#currentIsEmptyOut='false'
			# Although this may seem inefficient, the alternatives of calling external programs, filling variables, or setting 'shopt', may also be undesirable.
			# https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
			currentIsEmptyOut='true'
			for currentFile in "$2"/??????????????????
			do
				if [[ "$currentFile" != *'??????????????????' ]]
				then
					_messagePlain_good '16 : detected: output pipe file'
					currentIsEmptyOut='false'
					break
				fi
			done
			_messagePlain_nominal ' 6 : decision'
			_messagePlain_probe_var currentInputBufferCount
			_messagePlain_probe_var currentOutputBufferCount
			[[ ! -e "$1"/terminate ]] && _messagePlain_probe ' 7.1: flag: missing: terminate'
			[[ -d "$1" ]] && _messagePlain_probe ' 7.2: detect: present: input directory'
			[[ "$currentIsEmptyOut" == 'false' ]] && _messagePlain_good ' 7.3: flag: detect: output pipe files'
			if [[ ! -e "$1"/terminate ]] && [[ -d "$1" ]] && [[ "$currentIsEmptyOut" == 'false' ]] && [[ "$currentInputBufferCount" -gt 0 ]] && [[ "$currentOutputBufferCount" -gt 0 ]]
			then
				_messagePlain_nominal ' 7 : ##### connect pipes #####'
				#https://unix.stackexchange.com/questions/139490/continuous-reading-from-named-pipe-cat-or-tail-f
				#https://stackoverflow.com/questions/11185771/bash-script-to-iterate-files-in-directory-and-pattern-match-filenames
				(
				for currentFile in "$1"/??????????????????
				do
					[[ "$currentFile" != *'??????????????????' ]] && cat "$currentFile" 2>/dev/null &
				done
				) | tee "$2"/?????????????????? > /dev/null 2>&1 &
				currentPID="$!"
				
				#rm -f "$1"/skip > /dev/null 2>&1
			fi
			
			_messagePlain_nominal ' 8 : repeat'
			
			# WARNING: Some processes within the subshell (ie. 'sleep' ) may allow the subshell to terminate rather than maintain a 'jobs' PID.
			_messagePlain_probe 'jobs: '$(jobs -p -r)
		done
		
		_messagePlain_nominal ' 9 : ##### terminate or reset #####'
		
		_jobs_terminate_aggregatorStatic_procedure "$currentPID"
		
		
		# WARNING: Since only one program may successfully remove a single file, that mechanism should allow only one 'broadcastPipe' process to remain in the unlikely case multiple were somehow started.
		currentTerminate='true'
		[[ -e "$1"/terminate ]] && [[ -e "$1"/reset ]] && rm "$1"/reset > /dev/null 2>&1 && rm "$1"/terminate > /dev/null 2>&1 && rm -f "$1"/listen > /dev/null 2>&1 && currentTerminate='false'
		rm -f "$1"/reset > /dev/null 2>&1
		
		# Recursive reset. Abandoned due to possibility of practical 'limit of recursion' with "bash" shell (and presumably similar as well) .
		# https://rosettacode.org/wiki/Find_limit_of_recursion
		# 'The Bash reference manual says No limit is placed on the number of recursive calls, nonetheless a segmentation fault occurs at 13777 (Bash v3.2.19 on 32bit GNU/Linux) '
		#[[ -e "$1"/terminate ]] && [[ -e "$1"/reset ]] && rm "$1"/reset > /dev/null 2>&1 && _broadcastPipe_aggregatorStatic_read_procedure "$@"
		#rm -f "$1"/reset > /dev/null 2>&1
		
	done
	
	
	rm -f "$1"/reset > /dev/null 2>&1
	rm -f "$1"/terminate > /dev/null 2>&1
	
	_rm_broadcastPipe_aggregatorStatic "$@"
	rm -f "$1"/reset > /dev/null 2>&1
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	_sleep_spinlock
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	return 0
}



# WARNING: Any unconnected pipe will block all pipes.
# WARNING: Any disconnection or new pipe will cause 'reset' of all pipes.
# "$1" == inputBufferDir
# "$2" == outputBufferDir
_broadcastPipe_aggregatorStatic_read() {
	_start
	
	_broadcastPipe_aggregatorStatic_read_procedure "$@"
	
	_stop
}










_here_rmloop_broadcastPipe_aggregatorStatic() {
	_here_header_bash_or_dash "$@"
	
	declare -f _rmloop_broadcastPipe_aggregatorStatic
	
	cat << CZXWXcRMTo8EmM8i4d
_rmloop_broadcastPipe_aggregatorStatic "\$@"

CZXWXcRMTo8EmM8i4d

}


_rmloop_broadcastPipe_aggregatorStatic() {
	while true
	do
		rm -f "$1"/rmloop > /dev/null 2>&1
		
		#sleep 1
		sleep 0.1
	done
	
}


_safePath_demand_broadcastPipe_aggregatorStatic() {
	if [[ "$1" == "$scriptLocal"* ]] && ! _if_cygwin
	then
		return 0
	fi
	if [[ "$1" == '/dev/shm/'* ]] && ! _if_cygwin
	then
		return 0
	fi
	
	
	! _safePath "$1" && _stop 1
	return 0
}

# WARNING: Deletes all existing files (to 'clear the buffers').
# "$1" == inputBufferDir
# "$2" == outputBufferDir
_demand_broadcastPipe_aggregatorStatic_sequence() {
	_start
	
	! mkdir -p "$1" && _stop 1
	! mkdir -p "$2" && _stop 1
	[[ "$1" == "" ]] && _stop 1
	[[ "$1" == "/" ]] && _stop 1
	[[ "$2" == "/" ]] && _stop 1
	if ! _safePath_demand_broadcastPipe_aggregatorStatic "$@"
	then
		_terminate_broadcastPipe_aggregatorStatic "$1"
		_stop 1
	fi
	
	_here_rmloop_broadcastPipe_aggregatorStatic "$@" > "$safeTmp"/_rmloop_broadcastPipe_aggregatorStatic
	chmod u+x "$safeTmp"/_rmloop_broadcastPipe_aggregatorStatic
	
	echo > "$1"/rmloop
	
	
	_sleep_spinlock
	
	
	! [[ -e "$1"/rmloop ]] && return 0
	! mv "$1"/rmloop "$1"/rmloop.rm > /dev/null 2>&1 && return 0
	if ! rm "$1"/rmloop.rm > /dev/null 2>&1
	then
		rm -f "$1"/rmloop.rm > /dev/null 2>&1
		return 0
	fi
	
	
	_rm_broadcastPipe_aggregatorStatic "$@"
	"$safeTmp"/_rmloop_broadcastPipe_aggregatorStatic "$@" &
	#"$scriptAbsoluteLocation" _rmloop_broadcastPipe_aggregatorStatic "$@" &
	
	
	#"$scriptAbsoluteLocation" _broadcastPipe_aggregatorStatic_read "$@" | _broadcastPipe_aggregatorStatic_write "$@"
	"$scriptAbsoluteLocation" _broadcastPipe_aggregatorStatic_read "$@"
	
	# May not be necessary. Theoretically redundant.
	local currentStopJobs
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	[[ "$currentStopJobs" != "" ]] && kill "$currentStopJobs" > /dev/null 2>&1
	
	
	_sleep_spinlock
	rm -f "$1"/terminate > /dev/null 2>&1
	[[ "$1" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	_stop
}

_demand_broadcastPipe_aggregatorStatic() {
	local inputBufferDir="$1"
	local outputBufferDir="$2"
	shift
	shift
	
	if [[ "$inputBufferDir" == "" ]] || [[ "$outputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
		outputBufferDir="$current_demand_dir"/outputBufferDir
	elif [[ -e "$safeTmp" ]]
	then
		# DANGER: Without this hook, temporary "$safeTmp" directories may persist indefinitely!
		# Only hook '_stop_queue_aggregatorStatic' if called from within another 'sequence' (to cause termination of service when that 'sequence' terminates for any reason).
		export current_broadcastPipe_inputBufferDir="$inputBufferDir"
		export current_broadcastPipe_outputBufferDir="$outputBufferDir"
		_stop_queue_aggregatorStatic() {
			_terminate_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" 2> /dev/null
			#_terminate_broadcastPipe_fast "$current_broadcastPipe_inputBufferDir" 2> /dev/null
			#sleep 1
			_rm_broadcastPipe_aggregatorStatic "$current_broadcastPipe_inputBufferDir" "$current_broadcastPipe_outputBufferDir"
			[[ "$inputBufferDir" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
		}
	fi
	
	
	"$scriptAbsoluteLocation" _demand_broadcastPipe_aggregatorStatic_sequence "$inputBufferDir" "$outputBufferDir" "$@" &
	while [[ -e "$inputBufferDir"/rmloop ]]
	do
		sleep 0.1
	done
	[[ ! -e "$inputBufferDir"/listen ]] && _sleep_spinlock
	[[ ! -e "$inputBufferDir"/listen ]] && _sleep_spinlock
	[[ ! -e "$inputBufferDir"/listen ]] && return 1
	
	[[ "$ub_force_limit_aggregatorStatic_rate" == 'true' ]] && _sleep_spinlock
	#[[ "$ub_force_limit_aggregatorStatic_rate" == 'false' ]] && _sleep_spinlock
	
	disown -a -h -r
	disown -a -r
	
	return 0
}


_terminate_broadcastPipe_aggregatorStatic_fast() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	[[ "$inputBufferDir" == "" ]] && return 1
	[[ "$inputBufferDir" == "/" ]] && return 1
	[[ ! -e "$inputBufferDir" ]] && return 1
	
	echo > "$inputBufferDir"/terminate
}

_terminate_broadcastPipe_aggregatorStatic() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	mkdir -p "$inputBufferDir"
	
	_terminate_broadcastPipe_aggregatorStatic_fast "$@"
	_sleep_spinlock
	
	rm -f "$inputBufferDir"/terminate > /dev/null 2>&1
	[[ "$inputBufferDir" == "$current_demand_dir"* ]] && [[ "$current_demand_dir" != "" ]] && _rm_dir_broadcastPipe_aggregatorStatic
	
	_sleep_spinlock
	
	return 0
}


_reset_broadcastPipe_aggregatorStatic() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	mkdir -p "$inputBufferDir"
	
	[[ "$inputBufferDir" == "" ]] && return 1
	[[ "$inputBufferDir" == "/" ]] && return 1
	[[ ! -e "$inputBufferDir" ]] && return 1
	
	echo > "$inputBufferDir"/reset
	echo > "$inputBufferDir"/terminate
}


_skip_broadcastPipe_aggregatorStatic() {
	local inputBufferDir="$1"
	
	if [[ "$inputBufferDir" == "" ]]
	then
		local current_demand_dir
		current_demand_dir=$(_demand_dir_broadcastPipe_aggregatorStatic "$1")
		[[ "$current_demand_dir" == "" ]] && _stop 1
		
		inputBufferDir="$current_demand_dir"/inputBufferDir
	fi
	
	mkdir -p "$inputBufferDir"
	
	[[ "$inputBufferDir" == "" ]] && return 1
	[[ "$inputBufferDir" == "/" ]] && return 1
	[[ ! -e "$inputBufferDir" ]] && return 1
	
	echo > "$inputBufferDir"/skip
}




# ATTENTION: Override with 'ops' or similar.
# Lock (if at all) the socket, not the buffers.
# Ports 6391 or alternatively 24671 preferred for one-per-machine IPC service with high-latency no-reset (ie. 'tripleBuffer' ) backend.
# Consider the limited availability of TCP/UDP port numbers not occupied by some other known purpose.
# TCP server intended for compatibility with platforms (ie. MSW/Cygwin) which may not have sufficient performance or flexibility to read/write (ie. 'tripleBuffer' ) backend directly.
# https://blog.travismclarke.com/post/socat-tutorial/
# https://fub2.github.io/powerful-socat/
# https://jdimpson.livejournal.com/tag/socat
# https://stackoverflow.com/questions/57299019/make-socat-open-port-only-on-localhost-interface
_page_socket_tcp_server() {
	_messagePlain_nominal '_page_socket_tcp_server: init: _demand_broadcastPipe_page'
	_demand_broadcastPipe_page
	
	_messagePlain_nominal '_page_socket_tcp_server: socat'
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 EXEC:"$scriptAbsoluteLocation"' '"_page_converse"
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 SYSTEM:'echo $HOME; ls -la'
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 SYSTEM:\'\""$scriptAbsoluteLocation"\"\'' _page_converse'
	socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 EXEC:\'\""$scriptAbsoluteLocation"\"\'' _page_converse'
	
	#_messagePlain_nominal '_page_socket_tcp_server: _terminate_broadcastPipe_page'
	#_terminate_broadcastPipe_page
}

_page_socket_tcp_client() {
	socat TCP:localhost:6391 -
}









# ATTENTION: Override with 'ops' or similar.
# Lock (if at all) the socket, not the buffers.
# Ports 6391 or alternatively 24671 preferred for one-per-machine IPC service with high-latency no-reset (ie. 'tripleBuffer' ) backend.
# Consider the limited availability of TCP/UDP port numbers not occupied by some other known purpose.
# TCP server intended for compatibility with platforms (ie. MSW/Cygwin) which may not have sufficient performance or flexibility to read/write (ie. 'tripleBuffer' ) backend directly.
# 'UNIX domain socket' server not specifically intended for any known purpose and not necessarily recommended for any purpose.
# https://blog.travismclarke.com/post/socat-tutorial/
# https://fub2.github.io/powerful-socat/
# https://jdimpson.livejournal.com/tag/socat
# https://stackoverflow.com/questions/57299019/make-socat-open-port-only-on-localhost-interface
# https://en.wikipedia.org/wiki/Unix_domain_socket
_page_socket_unix_server() {
	_messagePlain_nominal '_page_socket_unix_server: _init'
	
	local current_unixAddress
	current_unixAddress=$(_demand_socket_broadcastPipe_page_unixAddress)
	
	export current_broadcastPipe_address="$current_unixAddress"
	export current_broadcastPipe_dir=$(dirname "$current_unixAddress" 2> /dev/null)
	[[ ! -e "$current_broadcastPipe_dir" ]] && return 1
	[[ ! -d "$current_broadcastPipe_dir" ]] && return 1
	_stop_queue_page() {
		rm -f "$current_broadcastPipe_address" > /dev/null 2>&1
		#rmdir "$current_broadcastPipe_dir" > /dev/null 2>&1
		#_sleep_spinlock
		rm -f "$current_broadcastPipe_address" > /dev/null 2>&1
		rmdir "$current_broadcastPipe_dir" > /dev/null 2>&1
		_rm_socket_broadcastPipe_page_unixAddress
	}
	
	
	_messagePlain_nominal '_page_socket_unix_server: _demand_broadcastPipe_page'
	_demand_broadcastPipe_page
	
	_messagePlain_nominal '_page_socket_unix_server: socat'
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 EXEC:"$scriptAbsoluteLocation"' '"_page_converse"
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 SYSTEM:'echo $HOME; ls -la'
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 SYSTEM:\'\""$scriptAbsoluteLocation"\"\'' _page_converse'
	#socat TCP-LISTEN:6391,reuseaddr,pf=ip4,fork,bind=127.0.0.1 EXEC:\'\""$scriptAbsoluteLocation"\"\'' _page_converse'
	
	socat UNIX-LISTEN:"$current_broadcastPipe_dir"/unix.sock,fork EXEC:\'\""$scriptAbsoluteLocation"\"\'' _page_converse'
	
	
	#_messagePlain_nominal '_page_socket_unix_server: _terminate_broadcastPipe_page'
	#_terminate_broadcastPipe_page
	
	return 0
}

_page_socket_unix_client() {
	local current_unixAddress
	current_unixAddress=$(_demand_socket_broadcastPipe_page_unixAddress)
	
	#socat TCP:localhost:6391 -
	socat UNIX-CONNECT:"$current_unixAddress" -
	
	return 0
}










# ATTENTION: Override with 'ops' or similar.
# Lock (if at all) the socket, not the buffers.
# Ports 6392 or alternatively 24672 preferred for one-per-machine IPC service with low-latency frequent-reset (ie. 'aggregatorStatic' ) backend.
# Consider the limited availability of TCP/UDP port numbers not occupied by some other known purpose.
# TCP server intended for compatibility with platforms (ie. MSW/Cygwin) which may not have sufficient performance or flexibility to frequent-reset (ie. 'aggregatorStatic' ) backend directly.
# https://blog.travismclarke.com/post/socat-tutorial/
# https://fub2.github.io/powerful-socat/
# https://jdimpson.livejournal.com/tag/socat
# https://stackoverflow.com/questions/57299019/make-socat-open-port-only-on-localhost-interface
_aggregatorStatic_socket_tcp_server() {
	_messagePlain_nominal '_aggregatorStatic_socket_tcp_server: init: _demand_broadcastPipe_aggregatorStatic'
	_demand_broadcastPipe_aggregatorStatic
	
	_messagePlain_nominal '_aggregatorStatic_socket_tcp_server: socat'
	socat TCP-LISTEN:6392,reuseaddr,pf=ip4,fork,bind=127.0.0.1 EXEC:\'\""$scriptAbsoluteLocation"\"\'' _aggregatorStatic_converse'
	
	#_messagePlain_nominal '_aggregatorStatic_socket_tcp_server: _terminate_broadcastPipe_aggregatorStatic'
	#_terminate_broadcastPipe_aggregatorStatic
}

_aggregatorStatic_socket_tcp_client() {
	socat TCP:localhost:6392 -
}









# ATTENTION: Override with 'ops' or similar.
# Lock (if at all) the socket, not the buffers.
# Ports 6392 or alternatively 24672 preferred for one-per-machine IPC service with low-latency frequent-reset (ie. 'aggregatorStatic' ) backend.
# Consider the limited availability of TCP/UDP port numbers not occupied by some other known purpose.
# TCP server intended for compatibility with platforms (ie. MSW/Cygwin) which may not have sufficient performance or flexibility to frequent-reset (ie. # 'UNIX domain socket' server not specifically intended for any known purpose and not necessarily recommended for any purpose.
# https://blog.travismclarke.com/post/socat-tutorial/
# https://fub2.github.io/powerful-socat/
# https://jdimpson.livejournal.com/tag/socat
# https://stackoverflow.com/questions/57299019/make-socat-open-port-only-on-localhost-interface
# https://en.wikipedia.org/wiki/Unix_domain_socket
_aggregatorStatic_socket_unix_server() {
	_messagePlain_nominal '_aggregatorStatic_socket_unix_server: _init'
	
	local current_unixAddress
	current_unixAddress=$(_demand_socket_broadcastPipe_aggregatorStatic_unixAddress)
	
	export current_broadcastPipe_address="$current_unixAddress"
	export current_broadcastPipe_dir=$(dirname "$current_unixAddress" 2> /dev/null)
	[[ ! -e "$current_broadcastPipe_dir" ]] && return 1
	[[ ! -d "$current_broadcastPipe_dir" ]] && return 1
	_stop_queue_aggregatorStatic() {
		rm -f "$current_broadcastPipe_address" > /dev/null 2>&1
		#rmdir "$current_broadcastPipe_dir" > /dev/null 2>&1
		#_sleep_spinlock
		rm -f "$current_broadcastPipe_address" > /dev/null 2>&1
		rmdir "$current_broadcastPipe_dir" > /dev/null 2>&1
		_rm_socket_broadcastPipe_aggregatorStatic_unixAddress
	}
	
	
	_messagePlain_nominal '_aggregatorStatic_socket_unix_server: _demand_broadcastPipe_aggregatorStatic'
	_demand_broadcastPipe_aggregatorStatic
	
	_messagePlain_nominal '_aggregatorStatic_socket_unix_server: socat'
	socat UNIX-LISTEN:"$current_broadcastPipe_dir"/unix.sock,fork EXEC:\'\""$scriptAbsoluteLocation"\"\'' _aggregatorStatic_converse'
	
	
	#_messagePlain_nominal '_aggregatorStatic_socket_unix_server: _terminate_broadcastPipe_aggregatorStatic'
	#_terminate_broadcastPipe_aggregatorStatic
	
	return 0
}

_aggregatorStatic_socket_unix_client() {
	local current_unixAddress
	current_unixAddress=$(_demand_socket_broadcastPipe_aggregatorStatic_unixAddress)
	
	socat UNIX-CONNECT:"$current_unixAddress" -
	
	return 0
}











# Create Read Update Delete
# "$scriptLocal"/ops-ubdb.sh

# Reads a file or directory.
# Writes a file.


_db_list_var() {
	( set -o posix ; set )
	return
	
	#if type -p printenv > /dev/null 2>&1
	#then
		#printenv "$@"
		#return
	#elif type -p env > /dev/null 2>&1
	#then
		#env "$@"
		#return
	#fi
	#return 1
}

_db_filter_characters() {
	tr -d '(){}<>$:;&|#?!@%^*,`\t\\'
}

# "$1" == grepPattern
_db_filter_identifier() {
	grep '^ubdb_'"$ubiquitiousBashID"'_'"$1" | _db_filter_characters
}

_db_reinit() {
	# https://stackoverflow.com/questions/13823706/capture-multiline-output-as-array-in-bash
	local currentVarList
	currentVarList=($(_db_list_var | cut -f1 -d\= | _db_filter_identifier "$1"))
	
	#local currentLine
	#_db_list_var | cut -f1 -d\= | _db_filter_identifier "$1" | while IFS='' read -r currentLine || [[ -n "$currentLine" ]]; do
		#_messagePlain_probe_var "$currentLine"
		
		
		#_messagePlain_probe_cmd declare -x -g "$currentLine"=''
		
		#eval export "$currentLine"=''
		#eval unset "$currentLine"
		
		#_messagePlain_probe_var "$currentLine"
		
		
		
		
	#done | _db_filter_characters
	
	currentVarList+=("$currentLine")
	for currentLine in "${currentVarList[@]}"
	do
		if ! [[ "$currentLine" == "" ]] && ! [[ "$currentLine" == "\$" ]]
		then
			#_messagePlain_probe "$currentLine"
			
			#_messagePlain_probe_var "$currentLine"
			
			declare -x -g "$currentLine"=''
			eval export "$currentLine"=''
			eval unset "$currentLine"
			
			#_messagePlain_probe_var "$currentLine"
		fi
	done
	
}


# Internal use intended - called by '_db_write' .
_demand_db() {
	local current_db="$scriptLocal"/ops-db.sh
	[[ "$ub_db_file" != "" ]] && current_db="$ub_db_file"
	
	! [[ -e "$current_db" ]] && echo -e -n '' >> "$current_db"
	
	# NOT VALID. Create directories (and files within) directly using mkdir/echo .
	[[ -d "$current_db" ]] && return 1
	
	
	
	! [[ -e "$current_db" ]] && return 1
	return 0
}




_db_importSource() {
	# https://stackoverflow.com/questions/28783509/override-a-builtin-command-with-an-alias
	
	declare() {
		builtin declare -g "$@"
	}
	
	
	# https://unix.stackexchange.com/questions/160256/can-you-source-a-here-document
	source <( cat "$1" | _db_filter_characters )
	#. "$1"
	
	unset -f declare > /dev/null 2>&1
	
	return 0
}




_db_source() {
	local current_db="$scriptLocal"/ops-db.sh
	[[ "$ub_db_file" != "" ]] && current_db="$ub_db_file"
	! [[ -e "$current_db" ]] && return 1
	
	if [[ -d "$current_db" ]]
	then
		# Not yet implemented.
		return 1
	else
		_db_importSource "$current_db"
	fi
}

# "$1" == grepPattern
# "$ub_db_file"
_db_enumerate() {
	local currentLine
	#local processedLine
	#local currentVarName
	#local processedVarName
	
	local currentLineValue
	
	_db_list_var | cut -f1 -d\= | _db_filter_identifier "$1" | while IFS='' read -r currentLine || [[ -n "$currentLine" ]]; do
		currentLineValue=$(eval _safeEcho "\$"$currentLine"")
		[[ "$currentLineValue" == "" ]] && continue
		
		#processedLine=$(declare -p "$currentLine")
		
		# ATTENTION: OPTIONAL - always export variables (recommended)
		# 'declare -x' apparently causes value of variable to be dropped
		export "$currentLine"
		#declare -x "$currentLine"
		
		declare -p "$currentLine"
	done | _db_filter_characters
}





_db_read() {
	_db_reinit
	_db_source
	#_db_enumerate ""
}


_db_show() {
	_db_read
	_db_enumerate "$1"
}



_db_write_sequence() {
	_start
	
	local current_db="$scriptLocal"/ops-db.sh
	[[ "$ub_db_file" != "" ]] && current_db="$ub_db_file"
	#! [[ -e "$current_db" ]] && return 1
	
	# INVALID.
	[[ -d "$current_db" ]] && return 1
	
	
	local currentEmptyUID=$(_uid)
	
	echo -e -n '' >> "$current_db"."$currentEmptyUID"
	if ! _moveconfirm "$current_db"."$currentEmptyUID" "$current_db".lock
	then
		! rm "$current_db"."$currentEmptyUID" > /dev/null 2>&1 && _stop 255
		rm -f "$current_db"."$currentEmptyUID" > /dev/null 2>&1
		_stop 1
	fi
	
	# Read in a list of variables.
	_demand_db
	_db_read
	_db_importSource "$1"
	
	_db_enumerate | cat - > "$safeTmp"/db_input_replacement_tmp
	
	! _moveconfirm "$current_db" "$current_db".obsolete && _stop 1
	! _moveconfirm "$safeTmp"/db_input_replacement_tmp "$current_db" && _stop 1
	! rm "$current_db".obsolete && _stop 255
	! rm "$current_db".lock > /dev/null 2>&1 && _stop 255
	
	_stop 0
}


# "$1" == db_input_file (recommended: "$safeTmp"/db_input )
_db_write() {
	# More than 50 repeats/recursions is extremely unreasonable under expected loads.
	[[ "$ub_db_write_currentRecursive" -gt 50 ]] && return 1
	[[ "$ub_db_write_currentRecursive" == "" ]] && export ub_db_write_currentRecursive='0'
	
	
	if ! "$scriptAbsoluteLocation" _db_write_sequence "$1"
	then
		let ub_db_write_currentRecursive="$ub_db_write_currentRecursive"+1
		local currentDelay
		local currentDelayTenths
		let currentDelay="$RANDOM"%3
		let currentDelayTenths="$RANDOM"%10
		#echo "$currentDelay"."$currentDelayTenths"
		sleep "$currentDelay"."$currentDelayTenths"
		
		_db_write "$@"
		
		return 0
	fi
	
	return 0
}


_db_rm() {
	local current_db="$scriptLocal"/ops-db.sh
	[[ "$ub_db_file" != "" ]] && current_db="$ub_db_file"
	! [[ -e "$current_db" ]] && return 1
	
	if [[ -d "$current_db" ]]
	then
		# NOT VALID. Remove directories (and files within) directly using rmdir/_safeRMR/rm .
		return 1
	else
		rm -f "$current_db" > /dev/null 2>&1
		[[ -e "$current_db" ]] && return 1
		return 0
	fi
	return 1
}









_interactive_pipe_procedure() {
	[[ ! -e "$1" ]] && return 1
	[[ ! -d "$1" ]] && return 1
	
	local currentExitStatus=1
	
	_aggregator_fifo "$1"/p0
	_aggregator_fifo "$1"/p1
	_aggregator_fifo "$1"/p2
	
	
	bash -s -l -i 0<"$1"/p0 1>"$1"/p1 2>"$1"/p2
	currentExitStatus="$?"
	
	
	rm -f "$1"/p0 > /dev/null 2>&1
	rm -f "$1"/p1 > /dev/null 2>&1
	rm -f "$1"/p2 > /dev/null 2>&1
	rmdir "$1" > /dev/null 2>&1
	
	return "$currentExitStatus"
}

_interactive_pipe_sequence() {
	local currentPipeUID=$(_uid)
	[[ "$ub_force_interactive_pipe_id" != "" ]] && currentPipeUID="$ub_force_interactive_pipe_id"
	local currentPipeDir="$safeTmp"/interactive_pipe_"$currentPipeUID"
	#[[ "$ub_force_interactive_pipe_id" != "" ]] && currentPipeDir="$currentSub_safeTmp"/interactive_pipe_"$currentPipeUID"
	_safeEcho_newline "$currentPipeDir"
	
	_start
	
	[[ ! -e "$safeTmp" ]] && return 1
	[[ ! -d "$safeTmp" ]] && return 1
	mkdir -p "$currentPipeDir"
	[[ ! -e "$currentPipeDir" ]] && return 1
	[[ ! -d "$currentPipeDir" ]] && return 1
	
	_interactive_pipe_procedure "$currentPipeDir"
	
	_stop
}

# CAUTION: Requires calling 'sequence' not to run "_stop" until terminal is no longer needed.
# WARNING: Untested.
_demand_interactive_pipe_procedure() {
	true | "$scriptAbsoluteLocation" --devenv _interactive_pipe_sequence "$currentPipeDir" &
	
	disown -h "$!"
	
	sleep 7
}

# Intended to allow lower-latency access to internal commands, as well as their responses, such as through a 'physical' 'terminal emulator' . Especially including access to other 'queue' InterProcess-Communication procedures, and to procedures which communicate through such a bus.
# In practice, this approach has limitations.
# An error message will be displayed if the pipes are connected to after the 'parent' process has exited .
# Keyboard interactive programs (eg. vim) are unusable.
# Much 'noise' is present, likely requiring specialized text parsing of commands and responses, as would be expected of a more elaborate protocol.
_demand_interactive_pipe() {
	true | "$scriptAbsoluteLocation" _interactive_pipe_sequence &
	
	disown -h "$!"
	
	sleep 7
}


# ./ubiquitous_bash.sh _interactive_client_pipe ./w_*/interactive_pipe_??????????????????
_interactive_client_pipe() {
	[[ ! -e "$1"/p0 ]] && return 1
	[[ ! -e "$1"/p1 ]] && return 1
	#[[ ! -e "$1"/p2 ]] && return 1
	cat "$1"/p1 & [[ -e "$1"/p2 ]] && cat "$1"/p2 >&2 & cat > "$1"/p0
}


_interactive_pipe_konsole() {
	# Force 'known' sessionid and safeTmp of next "$scriptAbsoluteLocation" .
	export ub_force_sessionid=$(_uid)
	export ub_force_interactive_pipe_id=$(_uid)
	local currentSub_safeTmp=$(
		export sessionid="$ub_force_sessionid"
		_get_ub_globalVars_sessionDerived
		_safeEcho "$safeTmp"
	)
	
	local currentPipeUID=$(_uid)
	[[ "$ub_force_interactive_pipe_id" != "" ]] && currentPipeUID="$ub_force_interactive_pipe_id"
	local currentPipeDir="$safeTmp"/interactive_pipe_"$currentPipeUID"
	[[ "$ub_force_interactive_pipe_id" != "" ]] && currentPipeDir="$currentSub_safeTmp"/interactive_pipe_"$currentPipeUID"
	_safeEcho_newline "$currentPipeDir" > /dev/null 2>&1
	
	
	# demand ...
	_demand_interactive_pipe > /dev/null 2>&1
	
	
	# Connect to known pipe location.
	set +m
	konsole -e "$scriptAbsoluteLocation" _interactive_client_pipe "$currentPipeDir" > /dev/null 2>&1
	#sleep 7
	set -m
}








# TODO: An implementation using 'tmux' or 'GNU Screen' may be more capable.


_test_interactive_tmux() {
	_getDep tmux
}

_test_interactive_screen() {
	_getDep screen
}











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
	
	if _if_cygwin
	then
		if ! chown "$USER":None "$abstractfs_root" > /dev/null 2>&1
		then
			! chown "$USER" "$abstractfs_root" && exit 1
		fi
	else
		if ! chown "$USER":"$USER" "$abstractfs_root" > /dev/null 2>&1
		then
			! /sbin/chown "$USER" "$abstractfs_root" && exit 1
		fi
	fi
	
	
	
	
	! mkdir -p "$abstractfs_lock" && exit 1
	chmod 0700 "$abstractfs_lock" > /dev/null 2>&1
	! chmod 700 "$abstractfs_lock" && exit 1
	
	if _if_cygwin
	then
		if ! chown "$USER":None "$abstractfs_lock" > /dev/null 2>&1
		then
			! chown "$USER" "$abstractfs_lock" && exit 1
		fi
	else
		if ! chown "$USER":"$USER" "$abstractfs_lock" > /dev/null 2>&1
		then
			! /sbin/chown "$USER" "$abstractfs_lock" && exit 1
		fi
	fi
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	! mkdir -p "$scriptLocal" && exit 1
	
	! mkdir -p "$bootTmp" && exit 1
	
	# WARNING: No production use. Not guaranteed to be machine readable.
	[[ "$tmpSelf" != "$scriptAbsoluteFolder" ]] && echo "$tmpSelf" 2> /dev/null > "$scriptAbsoluteFolder"/__d_$(echo "$sessionid" | head -c 16)
	
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
	
	_tryExec "_stop_queue_page"
	_tryExec "_stop_queue_aggregatorStatic"
	
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
	
	
	# https://stackoverflow.com/questions/25906020/are-pid-files-still-flawed-when-doing-it-right/25933330
	# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits
	local currentStopJobs
	currentStopJobs=$(jobs -p -r 2> /dev/null)
	# WARNING: Although usually bad practice, it is useful for the spaces between PIDs to be interpreted in this case.
	# DANGER: Apparently, it is possible for some not running background jobs to be included in the PID list.
	[[ "$currentStopJobs" != "" ]] && kill $currentStopJobs > /dev/null 2>&1
	
	
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
	
	[[ "$tmpSelf" != "$scriptAbsoluteFolder" ]] && [[ "$tmpSelf" != "/" ]] && [[ -e "$tmpSelf" ]] && rmdir "$tmpSelf" > /dev/null 2>&1
	rm -f "$scriptAbsoluteFolder"/__d_$(echo "$sessionid" | head -c 16) > /dev/null 2>&1
	
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
		#rm -f "$lock_open" || return 1
		rm -f "$lock_open"
		[[ -e "$lock_open" ]] && return 1
		
		if [[ "$specialLock" != "" ]] && [[ -e "$specialLock" ]]
		then
			#rm -f "$specialLock" || return 1
			rm -f "$specialLock"
			[[ -e "$specialLock" ]] && return 1
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

_installation_nonet_default() {
	if [[ "$nonet" != 'false' ]]
	then
		[[ "$scriptAbsoluteFolder" == /media/"$USER"* ]] && [[ -e /media/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /mnt/"$USER"* ]] && [[ -e /mnt/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /var/run/media/"$USER"* ]] && [[ -e /var/run/media/"$USER" ]] && export nonet='true'
		[[ "$scriptAbsoluteFolder" == /run/"$USER"* ]] && [[ -e /run/"$USER" ]] && currentParameter=/run/"$USER" && export nonet='true'
		[[ "$scriptAbsoluteFolder" == "/cygdrive"* ]] && [[ -e /cygdrive ]] && export nonet='true'
	fi
	
	return 0
}

_vector_line_cksum() {
	[[ $(echo test | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '935282863' ]] && echo 'broken cksum' && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n +2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '2409981071' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n +2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '9' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n 2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '763220757' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | tail -n 2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '2' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n 2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '1864731933' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n 2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '2' ]] && _messageFAIL && _stop 1
	
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n -2 | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9') != '3336706933' ]] && _messageFAIL && _stop 1
	[[ $(echo -e '1\n2\n3\n4\n5\n6\n7\n8\n9\n0' | head -n -2 | wc -l | cut -f1 -d\  | tr -dc '0-9') != '8' ]] && _messageFAIL && _stop 1
	
	return 0
}

_vector() {
	_tryExec "_vector_line_cksum"
	
	
	_tryExec "_vector_virtUser"
}




#Verifies the timeout and sleep commands work properly, with subsecond specifications.
_timetest() {
	
	local iterations
	local dateA
	local dateB
	local dateDelta
	
	local nsDateA
	local nsDateB
	local nsDateDelta
	
	iterations=0
	#while false && [[ "$iterations" -lt 3 ]]
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
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
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		sleep 0.123
		
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		_timeout 0.123 sleep 10
		
		dateB=$(date +%s)
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		dateA=$(date +%s)
		nsDateA=$(date +%s%N)
		
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		sleep .123
		
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		_timeout .123 sleep 10
		
		dateB=$(date +%s)
		nsDateB=$(date +%s%N)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		nsDateDelta=$(bc <<< "$nsDateB - $nsDateA")
		
		if [[ "$dateDelta" -lt "1" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt "5" ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | wc -c) != '10' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$nsDateDelta" -lt '1000000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt 1000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '50000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt 5000 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		
		
		
		let iterations="$iterations + 1"
	done
	
	
	local nsDateC
	local nsDateD
	local nsDateDeltaA
	local nsDateDeltaB
	local msIterations
	
	if uname -a | grep -i 'cygwin' > /dev/null 2>&1
	then
		nsDateA=$(date +%s%N)
		for msIterations in {1..100}
		do
			sleep 0.011
		done
		nsDateB=$(date +%s%N)
		
		#nsDateC=$(date +%s%N)
		nsDateC="$nsDateB"
		for msIterations in {1..100}
		do
			sleep 0.091
		done
		nsDateD=$(date +%s%N)
		
		nsDateDeltaA=$(bc <<< "$nsDateB - $nsDateA")
		nsDateDeltaB=$(bc <<< "$nsDateD - $nsDateC")
		nsDateDelta=$(bc <<< "$nsDateDeltaB - $nsDateDeltaA")
		
		#echo "$nsDateDelta"
		
		
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -lt '10000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '640000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt '1000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt '64000' ]]
		then
			_messageFAIL
			_stop 1
		fi
	else
		nsDateA=$(date +%s%N)
		for msIterations in {1..100}
		do
			sleep 0.001
		done
		nsDateB=$(date +%s%N)
		
		#nsDateC=$(date +%s%N)
		nsDateC="$nsDateB"
		for msIterations in {1..100}
		do
			sleep 0.009
		done
		nsDateD=$(date +%s%N)
		
		nsDateDeltaA=$(bc <<< "$nsDateB - $nsDateA")
		nsDateDeltaB=$(bc <<< "$nsDateD - $nsDateC")
		nsDateDelta=$(bc <<< "$nsDateDeltaB - $nsDateDeltaA")
		
		#echo "$nsDateDelta"
		
		
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -lt '10000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-8) -gt '640000000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -lt '1000' ]]
		then
			_messageFAIL
			_stop 1
		fi
		if [[ $(echo -e -n "$nsDateDelta" | cut -b1-4) -gt '64000' ]]
		then
			_messageFAIL
			_stop 1
		fi
	fi
	
	
	
	
	_messagePASS
	return 0
}


_testarglength() {
	local testArgLength
	
	! testArgLength=$(getconf ARG_MAX) && _messageFAIL && _stop 1
	
	
	# Typical UNIX.
	if [[ "$testArgLength" -lt 131071 ]]
	then
		# Typical Cygwin. Marginal result at best.
		[[ "$testArgLength" -ge 32000 ]] && uname -a | grep -i 'cygwin' > /dev/null 2>&1 && _messagePASS && return 0
		
		_messageFAIL && _stop 1
	fi
	
	_messagePASS
}



_variableLocalTestA_procedure() {
	local currentLocalA
	currentLocalA='false'
	[[ "$currentGlobalA" != 'true' ]] && _stop 1
	[[ "$currentLocalA" == '' ]] && _stop 1
	[[ "$currentLocalA" != 'false' ]] && _stop 1
	
	local currentLocalB
	currentLocalB='true'
	
	currentNotLocalA='true'
	
	
	return 0
}

_variableLocalTestB_procedure() {
	[[ "$currentGlobalA" != 'true' ]] && return 1
	[[ "$currentLocalA" != '' ]] && return 1
	[[ "$currentLocalA" == 'true' ]] && return 1
	
	return 0
}

_variableLocalTestC_procedure() {
	[[ "$currentGlobalA" != '' ]] && _stop 1
	[[ "$currentGlobalA" == 'true' ]] && _stop 1
	
	return 0
}

_variableLocalTest_sequence() {
	_start
	
	local currentSubshellTest1=$(
		echo x
	)
	[[ "$currentSubshellTest1" != 'x' ]] && _stop 1
	
	local currentSubshellTest2
	currentSubshellTest2=$(
		echo x
	)
	[[ "$currentSubshellTest2" != 'x' ]] && _stop 1
	
	
	echo $(
		echo 1
		echo 2
	) | grep '1 2' > /dev/null || _stop 1
	
	! echo $(
		echo 1
		echo 2
	) | grep '1 2' > /dev/null && _stop 1
	
	
	export currentGlobalA='true'
	
	local currentLocalA
	currentLocalA='true'
	
	( export currentSubshellTestA='true' )
	[[ ! -z "$currentSubshellTestA" ]] && _stop 1
	[[ "$currentSubshellTestA" != "" ]] && _stop 1
	[[ "$currentSubshellTestA" != '' ]] && _stop 1
	[[ "$currentSubshellTestA" == 'true' ]] && _stop 1
	
	( currentSubshellTestB='true' )
	[[ "$currentSubshellTestB" != "" ]] && _stop 1
	[[ "$currentSubshellTestB" == 'true' ]] && _stop 1
	
	( local currentSubshellTestC='true' )
	[[ "$currentSubshellTestC" != "" ]] && _stop 1
	[[ "$currentSubshellTestC" == 'true' ]] && _stop 1
	
	! ( echo true ) | grep 'true' > /dev/null && _stop 1
	! ( echo "$currentGlobalA" ) | grep 'true' > /dev/null && _stop 1
	! ( echo "$currentLocalA" ) | grep 'true' > /dev/null && _stop 1
	( echo "$currentLocalB" ) | grep 'true' > /dev/null && _stop 1
	
	[[ "$currentLocalA" != 'true' ]] && _stop 1
	! _variableLocalTestA_procedure && _stop 1
	[[ "$currentLocalA" != 'true' ]] && _stop 1
	[[ "$currentLocalB" != '' ]] && _stop 1
	[[ "$currentLocalB" == 'true' ]] && _stop 1
	[[ "$currentNotLocalA" != 'true' ]] && _stop 1
	
	_variableLocalTestB_procedure && _stop 1
	! "$scriptAbsoluteLocation" _variableLocalTestB_procedure && _stop 1
	
	local currentGlobalA
	! _variableLocalTestC_procedure && _stop 1
	
	export currentGlobalB='false'
	local currentGlobalB='true'
	[[ "$currentGlobalB" != 'true' ]] && _stop 1
	
	local currentLocalB='true'
	! ( echo "$currentLocalB" ) | grep 'true' > /dev/null && _stop 1
	[[ "$currentLocalB" != 'true' ]] && _stop 1
	
	local currentLocalC='true'
	[[ "$currentLocalC" != 'true' ]] && _stop 1
	
	! env -i  HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" sessionid="$sessionid" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i  HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" sessionid="" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i HOME="$HOME" TERM="${TERM}" SHELL="${SHELL}" PATH="${PATH}" PWD="$PWD" scriptAbsoluteLocation="$scriptAbsoluteLocation" scriptAbsoluteFolder="$scriptAbsoluteFolder" LD_PRELOAD="$LD_PRELOAD" USER="$USER" "bash" -c '[[ "$sessionid" != "" ]]' && _stop 1
	
	local currentBashBinLocation
	currentBashBinLocation=$(type -p bash)
	[[ "$sessionid" == '' ]] &&  _stop 1
	! env -i sessionid="$sessionid" "$currentBashBinLocation" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i sessionid="" "$currentBashBinLocation" -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i "$currentBashBinLocation" -c '[[ "$sessionid" != "" ]]' && _stop 1
	
	
	
	local currentVariableFunctionText
	
	export UB_TEST_VARIABLE_FUNCTION_COMMAND='_variableFunction_variableLocalTest() { echo true; }'' ; _variableFunction_variableLocalTest'
	currentVariableFunctionText=$(bash -c "$UB_TEST_VARIABLE_FUNCTION_COMMAND")
	#currentVariableFunctionText=$($UB_TEST_VARIABLE_FUNCTION_COMMAND)
	[[ "$currentVariableFunctionText" != "true" ]] && _messageFAIL && _stop 1
	export UB_TEST_VARIABLE_FUNCTION_COMMAND=
	unset UB_TEST_VARIABLE_FUNCTION_COMMAND
	
	_exportFunction_variableLocalTest() {
		echo true
	}
	currentVariableFunctionText=$(bash -c '_exportFunction_variableLocalTest' 2>/dev/null)
	[[ "$currentVariableFunctionText" != "" ]] && _messageFAIL && _stop 1
	export -f _exportFunction_variableLocalTest
	currentVariableFunctionText=$(bash -c '_exportFunction_variableLocalTest' 2>/dev/null)
	[[ "$currentVariableFunctionText" != "true" ]] && _messageFAIL && _stop 1
	unset _exportFunction_variableLocalTest
	
	
	_stop
}


_variableLocalTest() {
	if "$scriptAbsoluteLocation" _variableLocalTest_sequence "$@"
	then
		return 0
	fi
	return 1
}


_uid_test() {
	local current_uid_1
	local current_uid_2
	local current_uid_3
	
	current_uid_1=$(_uid)
	current_uid_2=$(_uid)
	current_uid_3_char=$(_uid 8 | wc -c)
	
	if [[ "$current_uid_1" == "" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_2" == "" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_1" == "$current_uid_2" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ "$current_uid_3_char" != "8" ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	return 0
}


# Creating a function from within a function may be relied upon for some overrides.
# Enumerating a function's text with 'declare -f' may be relied upon by some 'here document' functions.
_define_function_test() {
	local current_uid_1
	current_uid_1=$(_uid)
	
	local current_uid_2
	current_uid_2=$(_uid)
	
	# https://stackoverflow.com/questions/7145337/bash-how-do-i-create-function-from-variable
	eval "__$current_uid_1() { __$current_uid_2() { echo $ubiquitiousBashID; }; }"
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -lt 50 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	__$current_uid_1
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -lt 15 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	# https://superuser.com/questions/154332/how-do-i-unset-or-get-rid-of-a-bash-function
	unset -f __$current_uid_2
	
	if [[ $(declare -f __$current_uid_2 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -lt 50 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	unset -f __$current_uid_1
	
	if [[ $(declare -f __$current_uid_1 | wc -c) -gt 0 ]]
	then
		_messageFAIL
		_stop 1
	fi
	
	
	return 0
}

#_test_prog() {
#	true
#}

_test_embed_procedure-embed() {
	#echo $ub_import
	#echo $ub_import_param
	
	[[ "$ub_import" != 'true' ]] && return 1
	[[ "$ub_import" == '' ]] && return 1
	[[ "$ub_import_param" != '--embed' ]] && return 1
	
	return 0
}

_test_embed_sequence() {
	_start
	
	#echo $ub_import
	#echo $ub_import_param
	
	# CAUTION: Profoundly unexpected to have called '_test' or similar functions after importing into a current shell in any way.
	[[ "$ub_import" == 'true' ]] && return 1
	[[ "$ub_import" != '' ]] && return 1
	[[ "$ub_import_param" != '' ]] && return 1
	
	
	! "$safeTmp"/.embed.sh _true && _stop 1
	"$safeTmp"/.embed.sh _false && _stop 1
	
	
	
	! "$safeTmp"/.embed.sh _test_embed_procedure-embed && _stop 1
	
	! . "$safeTmp"/.embed.sh _test_embed_procedure-embed && _stop 1
	
	_stop
}

_test_embed() {
	"$scriptAbsoluteLocation" _test_embed_sequence "$@"
}

_test_parallelFifo_procedure() {
	mkfifo "$safeTmp"/parallel_fifo
	cat "$safeTmp"/parallel_fifo > "$safeTmp"/parallel_fifo_out &
	
	local currentIterationsA
	currentIterationsA=0
	local currentIterationsB
	currentIterationsB=0
	
	while [[ "$currentIterationsA" -lt "2" ]]
	do
		echo a
		sleep 1
		let currentIterationsA="$currentIterationsA"" + 1"
	done | cat > "$safeTmp"/parallel_fifo &
	
	sleep 0.4
	
	while [[ "$currentIterationsB" -lt "2" ]]
	do
		echo b
		sleep 1
		let currentIterationsB="$currentIterationsB"" + 1"
	done | cat > "$safeTmp"/parallel_fifo
	
	sleep 1
	sleep 7
	
	
	#echo $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' 2> /dev/null)
	
	# WARNING: Strongly discouraged! Strict test highly dependent on unpredictable InterProcess-Communication timing requiring >7s latency margins at each 'step'!
	if _if_cygwin
	then
		[[ $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' 2> /dev/null) != "abab" ]] && _messageFAIL && return 1
	fi
	
	[[ $(cat "$safeTmp"/parallel_fifo_out | tr -dc 'a-zA-Z0-9' | wc -c) != "4" ]] && _messageFAIL && return 1
	
	
	rm -f "$safeTmp"/parallel_fifo
	rm -f "$safeTmp"/parallel_fifo_out
}

# No production use.
_test_parallelFifo_sequence() {
	_start
	
	_test_parallelFifo_procedure "$@"
	
	_stop
}

_test_sanity() {
	if (exit 0)
	then
		true
	else
		_messageFAIL && return 1
	fi
	if ! (exit 0)
	then
		_messageFAIL && return 1
	fi
	if (exit 1)
	then
		_messageFAIL && return 1
	fi
	if (exit 2)
	then
		_messageFAIL && return 1
	fi
	if (exit 3)
	then
		_messageFAIL && return 1
	fi
	if (exit 126)
	then
		_messageFAIL && return 1
	fi
	if (exit 127)
	then
		_messageFAIL && return 1
	fi
	if (exit 128)
	then
		_messageFAIL && return 1
	fi
	if (exit 129)
	then
		_messageFAIL && return 1
	fi
	if (exit 130)
	then
		_messageFAIL && return 1
	fi
	if (exit 131)
	then
		_messageFAIL && return 1
	fi
	if (exit 132)
	then
		_messageFAIL && return 1
	fi
	if (exit 255)
	then
		_messageFAIL && return 1
	fi
	
	local currentSubReturnStatus
	(exit 0)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '0' ]] && _messageFAIL && return 1
	(exit 1)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '1' ]] && _messageFAIL && return 1
	(exit 2)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '2' ]] && _messageFAIL && return 1
	(exit 3)
	currentSubReturnStatus="$?"
	[[ "$currentSubReturnStatus" != '3' ]] && _messageFAIL && return 1
	
	
	# Do NOT allow 'rm' to be a shell function alias to 'rm -i' or similar.
	[[ $(type -p rm) == "" ]] && _messageFAIL && return 1
	
	#! [[ -2147483648 -lt 2147483647 ]] && _messageFAIL && return 1
	#! [[ -2000000000 -lt 2000000000 ]] && _messageFAIL && return 1
	
	! [[ -1234567890 -le -1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -le 1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt 1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -ge -1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -ge 1234567890 ]] && _messageFAIL && return 1
	! [[ 1234567890 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt -0 ]] && _messageFAIL && return 1
	! [[ -1234567890 -lt 0 ]] && _messageFAIL && return 1
	! [[ 0 -lt 1234567890 ]] && _messageFAIL && return 1
	! [[ -0 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ 0 -gt -1234567890 ]] && _messageFAIL && return 1
	! [[ 0 -gt -1234567890 ]] && _messageFAIL && return 1
	
	! [[ -900000000 -le -900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -le 900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt 900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -ge -900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -ge 900000000 ]] && _messageFAIL && return 1
	! [[ 900000000 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt -0 ]] && _messageFAIL && return 1
	! [[ -900000000 -lt 0 ]] && _messageFAIL && return 1
	! [[ 0 -lt 900000000 ]] && _messageFAIL && return 1
	! [[ -0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -gt -900000000 ]] && _messageFAIL && return 1
	! [[ 0 -le -0 ]] && _messageFAIL && return 1
	! [[ -0 -le 0 ]] && _messageFAIL && return 1
	! [[ 0 -ge -0 ]] && _messageFAIL && return 1
	! [[ -0 -ge 0 ]] && _messageFAIL && return 1
	
	
	
	! "$scriptAbsoluteLocation" _true && _messageFAIL && return 1
	"$scriptAbsoluteLocation" _false && _messageFAIL && return 1
	
	# CAUTION: Profoundly unexpected to have called '_test' or similar functions after importing into a current shell in any way.
	[[ "$ub_import" == 'true' ]] && _messageFAIL && _stop 1
	[[ "$ub_import" != '' ]] && _messageFAIL && _stop 1
	[[ "$ub_import_param" != '' ]] && _messageFAIL && _stop 1
	
	local santiySessionID_length
	santiySessionID_length=$(echo -n "$sessionid" | wc -c | tr -dc '0-9')
	
	[[ "$santiySessionID_length" -lt "18" ]] && _messageFAIL && return 1
	[[ "$uidLengthPrefix" != "" ]] && [[ "$santiySessionID_length" -lt "$uidLengthPrefix" ]] && _messageFAIL && return 1
	
	[[ -e "$safeTmp" ]] && _messageFAIL && return 1
	
	_start
	
	
	[[ ! -e "$safeTmp" ]] && _messageFAIL && return 1
	
	[[ $( cd "$safeTmp" 2>/dev/null ; ls *doNotMatch* 2>/dev/null | wc -c) != "0" ]] && _messageFAIL && return 1
	[[ $( cd "$safeTmp" 2>/dev/null ; ls -A *doNotMatch* 2>/dev/null | wc -c) != "0" ]] && _messageFAIL && return 1
	
	echo -e -n >> "$safeTmp"/empty
	[[ ! -e "$safeTmp"/empty ]] && _messageFAIL && return 1
	[[ $(cat "$safeTmp"/empty | wc -c) != '0' ]] && _messageFAIL && return 1
	
	[[ $( cd "$safeTmp" 2>/dev/null ; ls *empty* 2>/dev/null | wc -c) == "0" ]] && _messageFAIL && return 1
	[[ $( cd "$safeTmp" 2>/dev/null ; ls -A *empty* 2>/dev/null | wc -c) == "0" ]] && _messageFAIL && return 1
	
	rm -f "$safeTmp"/empty > /dev/null 2>&1
	
	
	! _test_moveconfirm_procedure && _messageFAIL && return 1
	
	
	local currentTestUID=$(_uid 245)
	mkdir -p "$safeTmp"/"$currentTestUID"
	echo > "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	
	[[ ! -e "$safeTmp"/"$currentTestUID"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	rm -f "$safeTmp"/"$currentTestUID"/"$currentTestUID"
	rmdir "$safeTmp"/"$currentTestUID"
	
	[[ -e "$safeTmp"/"$currentTestUID" ]] && _messageFAIL && return 1
	
	echo 'true' > "$safeTmp"/shouldNotOverwrite
	mv "$safeTmp"/doesNotExist "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1 && _messageFAIL && return 1
	echo > "$safeTmp"/replacement
	mv -n "$safeTmp"/replacement "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1
	[[ $(cat "$safeTmp"/shouldNotOverwrite) != "true" ]] && _messageFAIL && return 1
	rm -f "$safeTmp"/replacement > /dev/null 2>&1
	rm -f "$safeTmp"/shouldNotOverwrite > /dev/null 2>&1
	
	
	_uid_test
	
	[[ $(_getUUID | wc -c) != '37' ]] && _messageFAIL && return 1
	
	[[ $(_getUUID | cut -f1 -d\- | wc -c) != '9' ]] &&  _messageFAIL && return 1
	
	
	! env | grep 'PATH' > /dev/null 2>&1 && _messageFAIL && return 1
	! printenv | grep 'PATH' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	_define_function_test
	
	! _variableLocalTest && _messageFAIL && return 1
	
	
	
	mkdir -p "$safeTmp"/maydeletethisfolder
	[[ ! -d "$safeTmp"/maydeletethisfolder ]] && return 1
	echo > "$safeTmp"/maydeletethisfolder/maydeletethisfile
	[[ ! -e "$safeTmp"/maydeletethisfolder/maydeletethisfile ]] && return 1
	_safeRMR "$safeTmp"/maydeletethisfolder
	[[ -e "$safeTmp"/maydeletethisfolder/maydeletethisfile ]] && return 1
	[[ -e "$safeTmp"/maydeletethisfolder ]] && return 1
	
	
	
	# WARNING: Not tested by default, due to lack of use except where faults are tolerable, and slim possibility of useful embedded systems not able to pass.
	#! echo \$123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	#! echo \.123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	#echo 123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	local currentJobsList
	currentJobsList=$(jobs -p -r)
	
	[[ "$currentJobsList" != "" ]] && return 1
	
	sleep 7 &
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" == "" ]] && return 1
	
	wait
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" != "" ]] && return 1
	
	
	
	
	if ! _test_embed
	then
		_messageFAIL && _stop 1
		#! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		#echo 'warn: broken (cygwin): _test_embed - cygwin detected'
	fi
	
	
	
	
	_getDep flock
	
	( flock 200; echo > "$safeTmp"/ready ; sleep 3 ) 200>"$safeTmp"/flock &
	sleep 1
	if ( flock 200; ! [[ -e "$safeTmp"/ready ]] ) 200>"$safeTmp"/flock
	then
		! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'warn: broken (cygwin): flock - cygwin may not be able to use flock through MSW network drive'
		return 1
	fi
	rm -f "$safeTmp"/flock > /dev/null 2>&1
	rm -f "$safeTmp"/ready > /dev/null 2>&1
	
	ln -s /dev/null "$safeTmp"/working
	ln -s /dev/null/broken "$safeTmp"/broken
	if ! [[ -h "$safeTmp"/broken ]] || ! [[ -h "$safeTmp"/working ]] || [[ -e "$safeTmp"/broken ]] || ! [[ -e "$safeTmp"/working ]]
	then
		! uname -a | grep -i cygwin > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'warn: broken (cygwin): flock - cygwin may not be able to use flock through MSW network drive'
		return 1
	fi
	rm -f "$safeTmp"/working
	rm -f "$safeTmp"/broken
	
	
	
	_tryExec _test_parallelFifo_procedure
	
	
	return 0
}



_test() {
	_installation_nonet_default
	
	# ATTENTION: As part of sanity test, "$safeTmp" must not exist until '_start' is called from within '_test_sanity' .
	#_start
	_messageNormal "Sanity..."
	_test_sanity && _messagePASS
	
	
	
	_messageNormal "Permissions..."
	! _test_permissions_ubiquitous && _messageFAIL
	_messagePASS
	
	#Environment generated by ubiquitous bash is typically 10000 characters.
	echo -n -e '\E[1;32;46m Argument length...	\E[0m'
	
	_testarglength
	
	_messageNormal "Absolute pathfinding..."
	#if ! uname -a | grep -i cygwin > /dev/null 2>&1
	#then
		_tryExec "_test_getAbsoluteLocation"
	#fi
	_messagePASS
	
	if type _timetest > /dev/null 2>&1
	then
		echo -n -e '\E[1;32;46m Timing...		\E[0m'
		echo
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		if type _test_selfTime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_selfTime \E[0m'
			if ! _test_selfTime
			then
				if _if_cygwin
				then
					echo 'warn: accepted: cygwin: _test_selfTime broken'
				else
					echo '_test_selfTime broken'
					_stop 1
				fi
			fi
		fi
		
		if type _test_bashTime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_bashTime \E[0m'
			! _test_bashTime && echo '_test_selfTime broken' && _stop 1
		fi
		
		if type _test_filemtime > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_filemtime \E[0m'
			! _test_filemtime && echo '_test_selfTime broken' && _stop 1
		fi
		
		if type _test_timeoutRead > /dev/null 2>&1
		then
			echo -e '\E[0;36m Timing: _test_timeoutRead \E[0m'
			! _test_timeoutRead && echo '_test_timeoutRead broken' && _stop 1
		fi
		
		echo -e '\E[0;36m Timing: _timetest \E[0m'
		! _timetest && echo '_timetest broken' && _stop 1
	fi
	
	
	_messageNormal "Dependency checking..."
	
	## Check dependencies
	
	# WARNING: Although '#!/usr/bin/env bash' is used as header when possible, some high-speed 'heredoc' scripts may instead rely on '#!/bin/bash' or '#!/bin/dash' to ensure performance. For these important use cases, the typical '/bin/bash' and '/bin/dash' binary locations are required.
	_getDep /bin/bash
	! [[ -e /bin/bash ]] && echo '/bin/bash missing' && _stop 1
	! [[ -x /bin/bash ]] && echo '/bin/bash nonexecutable' && _stop 1
	_getDep /bin/dash
	! [[ -e /bin/dash ]] && echo '/bin/dash missing' && _stop 1
	! [[ -x /bin/dash ]] && echo '/bin/dash nonexecutable' && _stop 1
	
	#"generic/filesystem"/permissions.sh
	_checkDep stat
	
	_getDep cksum
	
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
	_getDep printenv
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
	
	_getDep stat
	_getDep touch
	
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
	
	_getDep uuidgen
	
	_getDep bc
	_getDep xxd
	
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
	
	
	_tryExec "_test_devqalculate"
	_tryExec "_test_devgnuoctave"
	
	
	
	_tryExec "_test_devatom"
	_tryExec "_test_devemacs"
	_tryExec "_test_deveclipse"
	
	_tryExec "_test_ethereum"
	_tryExec "_test_ethereum_parity"
	
	
	
	_tryExec "_test_mktorrent"
	
	
	_tryExec "_test_cloud"
	
	_tryExec "_test_rclone"
	_tryExec "_test_terraform"
	
	
	_tryExec "_test_vagrant_build"
	
	
	
	
	_tryExec "_test_clog"
	
	_tryExec "_test_metaengine"
	
	_tryExec "_test_channel"
	
	! [[ -e /dev/urandom ]] && echo /dev/urandom missing && _stop 1
	[[ $(_timeout 3 cat /dev/urandom 2> /dev/null | _timeout 3 base64 2> /dev/null | _timeout 3 tr -dc 'a-zA-Z0-9' 2> /dev/null | _timeout 3 head -c 18 2> /dev/null) == "" ]] && echo /dev/urandom fail && _stop 1
	
	_messagePASS
	
	if type _test_queue > /dev/null 2>&1
	then
		_messageNormal "Queue..."
		
		_tryExec '_test_queue'
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		echo -e '\E[0;36m Queue: _test_broadcastPipe_page \E[0m'
		if ! _test_broadcastPipe_page
		then
			if _if_cygwin
			then
				echo 'warn: accepted: cygwin: _test_broadcastPipe_page broken'
			else
				echo '_test_broadcastPipe_page broken'
				_stop 1
			fi
		fi
		
		# DANGER: Even under MSW/Cygwin, should ONLY fail IF extremely slow storage is attached.
		echo -e '\E[0;36m Queue: _test_broadcastPipe_aggregatorStatic \E[0m'
		if ! _test_broadcastPipe_aggregatorStatic
		then
			if _if_cygwin
			then
				#echo 'warn: accepted: cygwin: _test_broadcastPipe_aggregatorStatic broken'
				echo '_test_broadcastPipe_aggregatorStatic broken'
				_stop 1
			else
				echo '_test_broadcastPipe_aggregatorStatic broken'
				_stop 1
			fi
		fi
		
		_messagePASS
	fi
	
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
	find -L "$scriptAbsoluteFolder" -not \( -path \*_arc\* -prune \) -not \( -path \*__disk\* -prune \) -not \( -path \*/_local/h/\* -prune \) -not \( -path \*/_local/fs/\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) "$@"
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


_setup_anchor() {
	if ! _if_cygwin && [[ "$objectName" == "ubiquitous_bash" ]]
	then
		# WARNING: End user file association. Do NOT call within scripts.
		# WARNING: Necessarily relies on a 'deprecated' 'field code' with the 'Exec key' of a 'Desktop Entry' file association.
		# https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
		_messagePlain_request 'association: *.bat'
		echo 'konsole --workdir %d -e /bin/bash %f (open in graphical terminal emulator from file manager)'
		echo 'bash'
	fi
	
	if type "_associate_anchors_request" > /dev/null 2>&1
	then
		_tryExec "_associate_anchors_request"
		return
	fi
}

_setup() {
	_installation_nonet_default
	
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
	
	_setup_anchor
	
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
	
	_getDep xz
}

_package_prog() {
	true
}


_package_ubcp_copy_copy() {
	#cp -a "$1" "$2"
	if [[ "$ubPackage_enable_ubcp" != 'true' ]]
	then
		rsync -av --progress --exclude "/ubcp/conemu" --exclude "/ubcp/cygwin" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" "$1" "$2"
	else
		rsync -av --progress --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" "$1" "$2"
	fi
	
	
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.gz
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
	
	return 0
}

_package_ubcp_copy() {
	mkdir -p "$safeTmp"/package/_local
	
	if [[ -e "$scriptLocal"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLocal"/ubcp "$safeTmp"/package/_local/
		return 0
	fi
	if [[ -e "$scriptLib"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptAbsoluteFolder"/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptAbsoluteFolder"/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	
	
	if [[ -e "$scriptLib"/ubiquitous_bash/_local/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/_local/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptLib"/ubiquitous_bash/_lib/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/_lib/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	if [[ -e "$scriptLib"/ubiquitous_bash/ubcp ]]
	then
		_package_ubcp_copy_copy "$scriptLib"/ubiquitous_bash/ubcp "$safeTmp"/package/_local/
		rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
		return 0
	fi
	
	
	cd "$outerPWD"
	_stop 1
}

# ATTENTION: Override with 'ops' or similar ONLY if necessary.
_package_subdir() {
	#return 0
	
	# ATTENTION: Error message about 'cannot move' ... 'subdirectory of itself' ... is normal .
	mkdir -p "$safeTmp"/package/"$objectName"/
	( shopt -s dotglob ; mv "$safeTmp"/package/* "$safeTmp"/package/"$objectName"/ )
}

# WARNING Must define "_package_license" function in ops to include license files in package!
_package_procedure() {
	_start
	mkdir -p "$safeTmp"/package
	
	# WARNING: Largely due to presence of '.gitignore' files in 'ubcp' .
	export safeToDeleteGit="true"
	
	_package_prog
	
	_tryExec "_package_license"
	
	_tryExec "_package_cautossh"
	
	#cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/.gitignore "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/.gitmodules "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/COPYING "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/COPYING* "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/gpl.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/gpl-*.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/gpl-3.0.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/agpl.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/agpl-*.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/agpl-3.0.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	cp "$scriptAbsoluteFolder"/license.txt "$safeTmp"/package/ > /dev/null 2>&1
	cp "$scriptAbsoluteFolder"/license*.txt "$safeTmp"/package/ > /dev/null 2>&1
	
	#scriptBasename=$(basename "$scriptAbsoluteLocation")
	#cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/"$scriptBasename"
	cp -a "$scriptAbsoluteLocation" "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/ops "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/ops.sh "$safeTmp"/package/
	
	cp "$scriptAbsoluteFolder"/_* "$safeTmp"/package/
	cp "$scriptAbsoluteFolder"/*.sh "$safeTmp"/package/
	cp "$scriptAbsoluteFolder"/*.py "$safeTmp"/package/
	
	cp -a "$scriptLocal"/ops "$safeTmp"/package/
	cp -a "$scriptLocal"/ops.sh "$safeTmp"/package/
	
	#cp -a "$scriptAbsoluteFolder"/_bin "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_config "$safeTmp"
	#cp -a "$scriptAbsoluteFolder"/_prog "$safeTmp"
	
	#cp -a "$scriptAbsoluteFolder"/_local "$safeTmp"/package/
	
	cp -a "$scriptAbsoluteFolder"/README.md "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/USAGE.html "$safeTmp"/package/
	
	
	cp -a "$scriptAbsoluteFolder"/_config "$safeTmp"/package/
	
	
	cp -a "$scriptAbsoluteFolder"/_bin "$safeTmp"/package/
	
	
	cp "$scriptAbsoluteFolder"/fork "$safeTmp"/package/
	
	
	rm -f "$safeTmp"/package/devtask* > /dev/null 2>&1
	rm -f "$safeTmp"/package/__d_* > /dev/null 2>&1
	rm -f "$safeTmp"/package/_d_* > /dev/null 2>&1
	
	
	#if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	#then
		#_package_ubcp_copy "$@"
	#fi
	
	_package_ubcp_copy "$@"
	if [[ "$ubPackage_enable_ubcp" != 'true' ]]
	then
		_safeRMR "$safeTmp"/package/_local/ubcp/conemu
		_safeRMR "$safeTmp"/package/_local/ubcp/cygwin
	fi
	
	cd "$safeTmp"/package/
	_package_subdir
	
	#! [[ "$ubPackage_enable_ubcp" == 'true' ]] && env GZIP=-9 tar -czvf "$scriptAbsoluteFolder"/package.tar.gz .
	! [[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT=-e9 tar -cJvf "$scriptAbsoluteFolder"/package.tar.xz .
	#[[ "$ubPackage_enable_ubcp" == 'true' ]] && env GZIP=-9 tar -czvf "$scriptAbsoluteFolder"/package_ubcp.tar.gz .
	#[[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT=-e9 tar -cJvf "$scriptAbsoluteFolder"/package_ubcp.tar.xz .
	[[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT=-5 tar -cJvf "$scriptAbsoluteFolder"/package_ubcp.tar.xz .
	
	if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	then
		_messagePlain_request 'request: review contents of _local/ubcp/cygwin/home and similar directories'
	fi
	
	cd "$outerPWD"
	_stop
}

_package() {
	export ubPackage_enable_ubcp='false'
	"$scriptAbsoluteLocation" _package_procedure "$@"
	
	export ubPackage_enable_ubcp='true'
	"$scriptAbsoluteLocation" _package_procedure "$@"
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
export gatewayName=gtw-"$netName"-"$netName"
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










#################################################
# ATTENTION: Add '_prog' script code here!







def _main():
	pass


















# ATTENTION: Add '_prog' script code here!
#################################################


import sys
if sys.hexversion > 0x03000000:
	exec('_print = print')

import sys
import string
#./lean.py "_python(c('1 + 2'))"
#./lean.py "_print(c('1 + 2'))"
#./lean.py "print(c('1 + 2'))"
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
	if [[ -e "$scriptAbsoluteFolder"/lean.py ]]
	then
		"$scriptAbsoluteFolder"/lean.py '_python()'
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

# WARNING: Do not add code directly here without disabling checksum!
# WARNING: Checksum may only be disabled either by override of 'generic/minimalheader.sh' or by adding appropriate '.nck' file !

#"$scriptAbsoluteLocation" _setup


_main "$@"


