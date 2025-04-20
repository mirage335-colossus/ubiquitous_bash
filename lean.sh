#!/usr/bin/env bash

[[ "$PATH" != *"/usr/local/bin"* ]] && [[ -e "/usr/local/bin" ]] && export PATH=/usr/local/bin:"$PATH"
[[ "$PATH" != *"/usr/bin"* ]] && [[ -e "/usr/bin" ]] && export PATH=/usr/bin:"$PATH"
[[ "$PATH" != *"/bin:"* ]] && [[ -e "/bin" ]] && export PATH=/bin:"$PATH"

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
export ub_setScriptChecksum_header='2591634041'
export ub_setScriptChecksum_contents='2095185864'

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


# Seems Ubuntu 20 used an 'alias' for 'python', which may not be usable by shell scripts.
if ! type python > /dev/null 2>&1 && type python3 > /dev/null 2>&1
then
	python() {
		python3 "$@"
	}
fi



# ATTENTION: NOTICE: https://nixos.wiki/wiki/Locales

# WARNING: May conflict with 'export LANG=C' or similar.
# Workaround for very minor OS misconfiguration. Setting this variable at all may be undesirable however. Consider enabling and generating all locales with 'sudo dpkg-reconfigure locales' or similar .
#[[ "$LC_ALL" == '' ]] && export LC_ALL="en_US.UTF-8"

# WARNING: Do NOT use 'ubKeep_LANG' unless necessary!
# nix-shell --run "locale -a" -p bash
#  C   C.utf8   POSIX
[[ "$ubKeep_LANG" != "true" ]] && [[ "$LANG" != "C" ]] && export LANG="C"


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


# ATTENTION: Highly irregular. Workaround due to gsch2pcb installed by nix package manager not searching for installed footprints.
#if [[ "$NIX_PROFILES" != "" ]]
#then
	if [[ -e "$HOME"/.nix-profile/bin/gsch2pcb ]] && [[ -e /usr/local/share/pcb/newlib ]] && [[ -e /usr/local/lib/pcb_lib ]]
	then
		gsch2pcb() {
			"$HOME"/.nix-profile/bin/gsch2pcb --elements-dir /usr/local/share/pcb/newlib --elements-dir /usr/local/lib/pcb_lib "$@"
		}
	elif [[ -e /usr/share/pcb/pcblib-newlib ]]
	then
		gsch2pcb() {
			"$HOME"/.nix-profile/bin/gsch2pcb --elements-dir /usr/share/pcb/pcblib-newlib "$@"
		}
	fi
#fi


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

# WARNING: Multiple reasons to instead consider direct detection by other commands -  ' uname -a | grep -i cygwin > /dev/null 2>&1 ' , ' [[ -e '/cygdrive' ]] ' , etc .
_if_cygwin() {
	if uname -a | grep -i cygwin > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}


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


# ATTENTION: Workaround - Cygwin Portable - append MSW PATH if reasonable.
# NOTICE: Also see '_test-shell-cygwin' .
# MSWEXTPATH lengths up to 33, 38, are known reasonable values.
if [[ "$MSWEXTPATH" != "" ]] && ( [[ "$PATH" == *"/cygdrive"* ]] || [[ "$PATH" == "/cygdrive"* ]] ) && [[ "$convertedMSWEXTPATH" == "" ]] && _if_cygwin
then
	if [[ $(echo "$MSWEXTPATH" | grep -o ';\|:' | wc -l | tr -dc '0-9') -le 44 ]] && [[ $(echo "$PATH" | grep -o ':' | wc -l | tr -dc '0-9') -le 44 ]]
	then
		export convertedMSWEXTPATH=$(cygpath -p "$MSWEXTPATH")
		export PATH=/usr/bin:"$convertedMSWEXTPATH":"$PATH"
	fi
fi



# ATTENTION: Workaround - Cygwin Portable - change directory to current directory as detected by 'ubcp.cmd' .
if [[ "$CWD" != "" ]] && [[ "$cygwin_CWD_onceOnly_done" != 'true' ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	! cd "$CWD" && exit 1
	export cygwin_CWD_onceOnly_done='true'
fi



# ATTENTION: Workaround - Cygwin Portable - symlink home directory if nonexistent .
# https://stackoverflow.com/questions/39551802/how-to-fix-cygwin-using-wrong-ssh-directory-no-matter-what-i-do
#  'OpenSSH never honors $HOME.'
# https://sourceware.org/legacy-ml/cygwin/2016-06/msg00404.html
#  'OpenSSH never honors $HOME.'
# https://cygwin.com/cygwin-ug-net/ntsec.html
if [[ "$HOME" == "/home/root" ]] && [[ ! -e /home/"$USER" ]] && _if_cygwin
then
	ln -s --no-target-directory "/home/root" /home/"$USER" > /dev/null 2>&1
fi



# Forces Cygwin symlinks to best compatibility. Should be set by default elsewhere. Use sparingly only if necessary (eg. _setup_ubcp) .
_force_cygwin_symlinks() {
	! _if_cygwin && return 0
	[[ "$CYGWIN" != *"winsymlinks:lnk"* ]] && export CYGWIN="winsymlinks:lnk ""$CYGWIN"
}


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
	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc
	# Prioritizes native git binaries if available. Mostly a disadvantage over the Cygwin/MSW git binaries, but adds more usable git-lfs , and works surprisingly well, apparently still defaulting to: Cygwin HOME '.gitconfig' , Cygwin '/usr/bin/ssh' , correctly understanding the overrides of '_gitBest' , etc.
	#  Alternatives:
	#   git-lfs compiled for Cygwin/MSW - requires installing 'go' compiler for Cygwin/MSW
	#   git fetch commands - manual effort
	#   wrapper script to detect git lfs error and retry with subsequent separate fetch - technically possible
	#   avoid git-lfs - usually sufficient
	_override_msw_git() {
		local git_path="/cygdrive/c/Program Files/Git/cmd"
		
		# Optionally iterate through additional drive letters:
		# for drive in c ; do
		# for drive in c d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W ; do
		#   local git_path="/cygdrive/${drive}/Program Files/Git/cmd"
		#   if [ -d "${git_path}" ]; then
		#     break
		#   fi
		# done
		
		[ -d "$git_path" ] || return 0  # Return quietly if the git_path is not a directory

		# ATTENTION: To use with 'ops.sh' or similar if necessary, appropriate, and safe.
		export PATH_pre_override_git="$PATH"
		
		local path_entry entry IFS=':'
		local new_path=""
		
		for entry in $PATH ; do
			# Skip adding if this entry matches git_path exactly
			[ "$entry" = "$git_path" ] && continue
			
			# Append current entry to the new_path
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:${entry}"
			fi
		done

		# Finally, explicitly prepend the git path
		export PATH="${git_path}:${new_path}"

		#( _messagePlain_probe_var PATH >&2 ) > /dev/null
		#( _messagePlain_probe_var PATH_pre_override_git >&2 ) > /dev/null

		# CAUTION: DANGER: MSW native git binaries can perceive 'parent directories' outside the 'root' directory provided by Cygwin, equivalent to calling git binaries through remote (eg. SSH, etc) commands to a filesystem encapsulating a ChRoot !
		#  This function limits that behavior, especially for 'ubiquitous_bash' projects with MSW installers shipping standalone 'ubcp' environments.
		_override_msw_git_CEILING() {
			# On the unusual occasion "$scriptLocal" is defined as something other than "$scriptAbsoluteFolder"/_local, the 'ubcp' directory is not expected to have been included as a standard subdirectory under any other definition of "$scriptLocal" . Since this information is only used to add redundant configuration (ie. directories are not created, etc), no issues should be possible.
			#current_script_ubcp_msw=$(cygpath -w "$scriptLocal")
			current_script_ubcp_msw=$(cygpath -w "$scriptAbsoluteFolder"/_local)
			current_script_ubcp_msw_escaped="${current_script_ubcp_msw//\\/\\\\}"
			current_script_ubcp_msw_slash="${current_script_ubcp_msw//\\/\/}"

			# ONLY for the MSW git binaries override case (if "$git_path" is not valid, this function will already return before this)
			export GIT_CEILING_DIRECTORIES="/home/root/.ubcore/ubiquitous_bash;/home/root/.ubcore;/home/root;/cygdrive;/cygdrive/d/a/ubiquitous_bash/ubiquitous_bash;/cygdrive/c/a/ubiquitous_bash/ubiquitous_bash;C:\core\infrastructure\ubcp\cygwin;C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin;C:\core\infrastructure\extendedInterface\_local\ubcp;C:\core\infrastructure\ubDistBuild\_local\ubcp"
			
			[[ "$scriptAbsoluteFolder" != "" ]] && export GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"';'"$current_script_ubcp_msw"
		}
		#export -f _override_msw_git_CEILING
		_override_msw_git_CEILING
	}
	# CAUTION: Early in the script for a reason! Changing the PATH drastically later has been known to cause WSL 'bash' to override Cygwin 'bash' with very obviously unpredictable results.
	#  ATTENTION: There would be a '_test' function in 'ubiquitous_bash' for this, but the state of 'wsl' which may not be installed with 'ubdist', etc, is not necessarily predictable enough for a simple PASS/FAIL .
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]]
	#then
		_override_msw_git
		#_override_msw_git_CEILING
	#fi

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# ATTRIBUTION-AI: ChatGPT 4o  2025-04-12  web search  (partially)
	# ATTRIBUTION-AI: ChatGPT o3-mini-high  2025-04-12
	_write_configure_git_safe_directory_if_admin_owned_sequence() {
		local functionEntryPWD="$PWD"

		# DUBIOUS
		local functionEntry_GIT_DIR="$GIT_DIR"
		local functionEntry_GIT_WORK_TREE="$GIT_WORK_TREE"
		local functionEntry_GIT_INDEX_FILE="$GIT_INDEX_FILE"
		local functionEntry_GIT_OBJECT_DIRECTORY="$GIT_OBJECT_DIRECTORY"
		#local functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES="$GIT_ALTERNATE_OBJECT_DIRECTORIES"
		local functionEntry_GIT_CONFIG="$GIT_CONFIG"
		local functionEntry_GIT_CONFIG_GLOBAL="$GIT_CONFIG_GLOBAL"
		local functionEntry_GIT_CONFIG_SYSTEM="$GIT_CONFIG_SYSTEM"
		local functionEntry_GIT_CONFIG_NOSYSTEM="$GIT_CONFIG_NOSYSTEM"
		#local functionEntry_GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
		#local functionEntry_GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
		#local functionEntry_GIT_AUTHOR_DATE="$GIT_AUTHOR_DATE"
		#local functionEntry_GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME"
		#local functionEntry_GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL"
		#local functionEntry_GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
		#local functionEntry_GIT_EDITOR="$GIT_EDITOR"
		#local functionEntry_GIT_PAGER="$GIT_PAGER"
		local functionEntry_GIT_NAMESPACE="$GIT_NAMESPACE"
		local functionEntry_GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"
		local functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM="$GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#local functionEntry_GIT_SSL_NO_VERIFY="$GIT_SSL_NO_VERIFY"
		#local functionEntry_GIT_SSH="$GIT_SSH"
		#local functionEntry_GIT_SSH_COMMAND="$GIT_SSH_COMMAND"

		git config --global --add safe.directory "$1"
		#if [[ $(type -p git) != '/usr/bin/git' ]]
		#then
			##git config --global --add safe.directory "$2"
			git config --global --add safe.directory "$3"
			git config --global --add safe.directory "$4"
		#fi

		cd "$functionEntryPWD"

		# DUBIOUS
		GIT_DIR="$functionEntry_GIT_DIR"
		GIT_WORK_TREE="$functionEntry_GIT_WORK_TREE"
		GIT_INDEX_FILE="$functionEntry_GIT_INDEX_FILE"
		GIT_OBJECT_DIRECTORY="$functionEntry_GIT_OBJECT_DIRECTORY"
		#GIT_ALTERNATE_OBJECT_DIRECTORIES="$functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES"
		GIT_CONFIG="$functionEntry_GIT_CONFIG"
		GIT_CONFIG_GLOBAL="$functionEntry_GIT_CONFIG_GLOBAL"
		GIT_CONFIG_SYSTEM="$functionEntry_GIT_CONFIG_SYSTEM"
		GIT_CONFIG_NOSYSTEM="$functionEntry_GIT_CONFIG_NOSYSTEM"
		#GIT_AUTHOR_NAME="$functionEntry_GIT_AUTHOR_NAME"
		#GIT_AUTHOR_EMAIL="$functionEntry_GIT_AUTHOR_EMAIL"
		#GIT_AUTHOR_DATE="$functionEntry_GIT_AUTHOR_DATE"
		#GIT_COMMITTER_NAME="$functionEntry_GIT_COMMITTER_NAME"
		#GIT_COMMITTER_EMAIL="$functionEntry_GIT_COMMITTER_EMAIL"
		#GIT_COMMITTER_DATE="$functionEntry_GIT_COMMITTER_DATE"
		#GIT_EDITOR="$functionEntry_GIT_EDITOR"
		#GIT_PAGER="$functionEntry_GIT_PAGER"
		GIT_NAMESPACE="$functionEntry_GIT_NAMESPACE"
		GIT_CEILING_DIRECTORIES="$functionEntry_GIT_CEILING_DIRECTORIES"
		GIT_DISCOVERY_ACROSS_FILESYSTEM="$functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#GIT_SSL_NO_VERIFY="$functionEntry_GIT_SSL_NO_VERIFY"
		#GIT_SSH="$functionEntry_GIT_SSH"
		#GIT_SSH_COMMAND="$functionEntry_GIT_SSH_COMMAND"

		return 0
	}

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# CAUTION: NOT sufficient to call this function only during installation (as Administrator, which is what normally causes this issue). If the user subsequently installs native 'git for Windows', additional '.gitconfig' entries are needed, with the different MSWindows native style path format.
	# Historically this was apparently at least mostly not necessary until prioritizing native git binaries (if available) instead of relying on Cygwin/MSW git binaries.
	_write_configure_git_safe_directory_if_admin_owned() {
		local current_path="$1"
		local win_path win_path_escaped win_path_slash cygwin_path
		win_path="$(cygpath -w "$current_path")"
		#cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
		win_path_escaped="${win_path//\\/\\\\}"
		win_path_slash="${win_path//\\/\/}"

		# Single call to verify Administrators ownership explicitly (fast Windows API call)
		local owner_line
		owner_line="$(icacls "$win_path" 2>/dev/null)"
		if [[ "$owner_line" != *"BUILTIN\\Administrators"* ]]; then
			# Not Administrators-owned, no further action needed, immediate return
			return 0
		fi
		# Read "$HOME"/.gitconfig just once (efficient builtin file reading)
		local gitconfig_content
		if [[ -e "$HOME"/.gitconfig ]]; then
			gitconfig_content="$(< "$HOME"/.gitconfig)"

			## Check 1: Exact Windows path (C:\...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]]; then
				#return 0
			#fi

			## Check 2: Double-backslash-escaped Windows path (C:\\...)
			#win_path_escaped="${win_path//\\/\\\\}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]]; then
				#return 0
			#fi

			## Check 3: Normal-slash Windows path (C:/...)
			#win_path_slash="${win_path//\\/\/}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]]; then
				#return 0
			#fi

			## Check 4: Original Cygwin POSIX path (/cygdrive/c/...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]]; then
				#return 0
			#fi

			#( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && ( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0

			# Slightly more performance efficient. No expected scenario in which a MSW path has been added but a UNIX path has not.
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && return 0
			cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0
		fi

		# Explicit message clearly communicating safe-configuration action for transparency
		#echo "Administrators ownership detected; configuring git safe.directory entry."

		# perform safe git configuration exactly once after all efficient checks
		# CAUTION: Tested to create functionally identical log entries through both '/usr/bin/git' and native git binaries. Ensure that remains the case if making any changes.
		#"$scriptAbsoluteLocation" _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path"
		( _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path" )
	}
	# Must be later, after set global variable "$scriptAbsoluteFolder" .
	#_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
	
	# NOTICE: Recent versions of Cygwin seem to have replaced or omitted '/usr/bin/gpg.exe', possibly in favor of a symlink to '/usr/bin/gpg2.exe' .
	# CAUTION: This override is specifically to ensure availability of 'gpg' binary through a function, but that could have the effect of presenting an incorrect gpg2 CLI interface to software expecting a gpg1 CLI interface.
	 # In practice, Debian Linux seem to impose gpg v2 as the CLI interface for gpg - 'gpg --version' responds v2 .
	# WARNING: All of which is a good reason to always automatically prefer a specified major version binary of gpg (ie. gpg2) in other software.
	if ! type -p gpg > /dev/null && type -p gpg2 > /dev/null
	then
		gpg() {
			gpg2 "$@"
		}
	fi
	
	
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

	# ATTENTION: Sets the priority for '_wsl' as well as 'u' shortcuts. Override with '_bashrc' or similar as desired (eg. replace 'ubdist_embedded' with some specialized 3D printer firwmare/klipper dist/OS, etc).
	_wsl() {
		local currentBin_wsl
		#currentBin_wsl=$(type -p wsl)

		currentBin_wsl="wsl"

		if ( [[ "$1" != "-"* ]] || [[ "$1" == "-u" ]] || [[ "$1" == "-e" ]] || [[ "$1" == "--exec" ]] ) && ( [[ "$1" != "-d" ]] || [[ "$2" != "-d" ]] || [[ "$3" != "-d" ]] || [[ "$4" != "-d" ]] || [[ "$5" != "-d" ]] || [[ "$6" != "-d" ]] )
		then
			if "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubdist' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubdist "$@"
				"$currentBin_wsl" -d ubdist "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubDistBuild' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubDistBuild "$@"
				"$currentBin_wsl" -d ubDistBuild "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubdist_embedded' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubdist_embedded "$@"
				"$currentBin_wsl" -d ubdist_embedded "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^Debian' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d Debian "$@"
				"$currentBin_wsl" -d Debian "$@"
				return
			fi
			"$currentBin_wsl" "$@"
			return
		fi
		"$currentBin_wsl" "$@"
		return
	}
	#l() {
		#_wsl "$@"
	#}
	#alias l='_wsl'
	alias u='_wsl'
fi
	
_sudo_cygwin-if_parameter-skip2() {
	[[ "$1" == "-u" ]] && return 0
	return 1
}
_sudo_cygwin-if_parameter-skip1() {
	[[ "$1" == "-n" ]] && return 0
	[[ "$1" == "--preserve-env"* ]] && return 0
	return 1
}

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

	echo "cd \"$PWD"\" >> "$safeTmp"/cygwin_sudo_temp.sh

	echo "export PATH=\"$PATH\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	# No production use.
	echo "export GH_TOKEN=\"$GH_TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export INPUT_GITHUB_TOKEN=\"$INPUT_GITHUB_TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export TOKEN=\"$TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	# No production use.
	echo "export nonet=\"$nonet\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export devfast=\"$devfast\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export skimfast=\"$skimfast\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	local currentParam1
	while _sudo_cygwin-if_parameter-skip2 "$@" || _sudo_cygwin-if_parameter-skip1 "$@"
	do
		currentParam1="$1"

		if _sudo_cygwin-if_parameter-skip2 "$currentParam1"
		then
			! shift && _messageFAIL
			! shift && _messageFAIL
			currentParam1=""
		fi

		if _sudo_cygwin-if_parameter-skip1 "$currentParam1"
		then
			! shift && _messageFAIL
			currentParam1=""
		fi
	done

	#echo 'local currentExitStatus' >> "$safeTmp"/cygwin_sudo_temp.sh
	_safeEcho_newline "$safeTmp"/_bin.bat "$@" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'currentExitStatus=$?' >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'echo > "'"$safeTmp"'"/sequenceDone_'"$ubiquitousBashID" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'sleep 3' >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'exit $currentExitStatus' >> "$safeTmp"/cygwin_sudo_temp.sh
	chmod u+x "$safeTmp"/cygwin_sudo_temp.sh
	
	
		
	cp "$scriptAbsoluteLocation" "$safeTmp"/
	local currentScriptBasename
	currentScriptBasename=$(basename "$scriptAbsoluteLocation")
	chmod u+x "$safeTmp"/"$currentScriptBasename"
	
	cp "$scriptLib"/ubiquitous_bash/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	#cp /home/root/.ubcore/ubiquitous_bash/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	cp -f "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	chmod u+x "$safeTmp"/_bin.bat

	[[ ! -e "$safeTmp"/_bin.bat ]] && _messagePlain_bad 'bad: missing: _bin.bat' && _messageFAIL && _stop 1

	if type _anchor_configure > /dev/null 2>&1
	then
		"$safeTmp"/"$currentScriptBasename" _anchor_configure "$safeTmp"/_bin.bat
	else
		_messagePlain_bad 'bad: missing: _anchor_configure'
		_messageFAIL && _stop 1
		_stop 1
	fi
	

	# 'Do it as Administrator.'
	#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat bash
	
	if [[ "$scriptAbsoluteFolder" == "/cygdrive/c"* ]]
	then
		# WARNING: May be untested, or (especially under interactive shell) may call obsolete code.
		#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh

		cygstart --action=runas "$safeTmp"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
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
# (at least historically this did not work reliably though it may or may not be reliable now)
if _if_cygwin && type cygstart > /dev/null 2>&1
then
	sudo_cygwin() {
		#[[ "$1" == "-n" ]] && shift
		if type cygstart > /dev/null 2>&1
		then
			_sudo_cygwin "$@"
			#cygstart --action=runas "$@"
			#"$@"
			return
		fi
		
		"$@"
		return
		
		return 1
	}
	sudoc() {
		#[[ "$1" == "-n" ]] && return 1
		sudo_cygwin "$@"
	}
	alias sudo=sudoc
fi




# Calls MSW native programs from Cygwin/MSW with file parameter translation.
#_userMSW kate /etc/fstab
_userMSW() {
	if ! _if_cygwin || ! type cygpath > /dev/null 2>&1
	then
		"$@"
		return
	fi
	
	
	local currentArg
	local currentResult
	processedArgs=()
	for currentArg in "$@"
	do
		if [[ -e "$currentArg" ]] || [[ "$currentArg" == "/cygdrive/"* ]] || [[ "$currentArg" == "/home/"* ]] || [[ "$currentArg" == "/root/"* ]]
		then
			currentResult=$(cygpath -w "$currentArg")
		else
			currentResult="$currentArg"
		fi
		
		processedArgs+=("$currentResult")
	done
	
	
	"${processedArgs[@]}"
}


_powershell() {
    local currentPowershellBinary
    currentPowershellBinary=$(find /cygdrive/c/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/d/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/e/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/f/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)

	#_userMSW "$currentPowershellBinary" "$@"
    "$currentPowershellBinary" "$@"
}



_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles() {
	local currentBinary
	currentBinary="$1"
	
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	
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
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	
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
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q="$currentCygdriveC_equivalent"
	_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	# ATTENTION: Configure: 'c..w' (aka. 'w..c') .
	# WARNING: Program Files at drive letters other than 'c' may not be supported now or ever. Especially other than 'c,d,e'.
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	#for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {c..w}
	for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {c..f}
	do
		_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
		[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	done
	
	_discoverResource-cygwinNative-ProgramFiles-declaration-core "$@"
	
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	return 1
}


_set_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	export functionEntry_USERPROFILE="$USERPROFILE"
	export functionEntry_HOMEDRIVE="$HOMEDRIVE"
	export functionEntry_HOMEPATH="$HOMEPATH"
	
	# https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/vboxconfigdata.html
	#  'Windows: $HOME/.VirtualBox.'
	# https://en.wikipedia.org/wiki/Home_directory
	# %USERPROFILE%
	# %HOMEDRIVE%%HOMEPATH%
	# echo $USERPROFILE
	# export USERPROFILE="$USERPROFILE"'\Downloads'
	# cmd
	# echo %USERPROFILE%
	
	if [[ "$HOME" != "/root" ]] && [[ "$HOME" != "/home/root" ]] && [[ "$HOME" != "/home/""$USER" ]]
	then
		export USERPROFILE=$(cygpath -w "$HOME")
		export HOMEDRIVE=$(echo "$USERPROFILE" | head -c 2)
		export HOMEPATH=$(echo "$USERPROFILE" | tail -c +3)
	fi
	
	# WARNING: Cygwin/MSW HOME directory redirection may be disabled for future versions of 'ubiquitous bash'.
	if [[ "$USERPROFILE" == "$functionEntry_USERPROFILE" ]] && [[ "$VBOX_USER_HOME_short" != "" ]]
	then
		export USERPROFILE=$(cygpath -w "$VBOX_USER_HOME_short")
		export HOMEDRIVE=$(echo "$VBOX_USER_HOME_short" | head -c 2)
		export HOMEPATH=$(echo "$VBOX_USER_HOME_short" | tail -c +3)
	fi
	
	export functionEntry_VBOXID="$VBOXID"
	export functionEntry_vBox_vdi="$vBox_vdi"
	export functionEntry_vBoxInstanceDir="$vBoxInstanceDir"
	export functionEntry_VBOX_ID_FILE="$VBOX_ID_FILE"
	export functionEntry_VBOX_USER_HOME="$VBOX_USER_HOME"
	export functionEntry_VBOX_USER_HOME_local="$VBOX_USER_HOME_local"
	export functionEntry_VBOX_USER_HOME_short="$VBOX_USER_HOME_short"
	export functionEntry_VBOX_IPC_SOCKETID="$VBOX_IPC_SOCKETID"
	export functionEntry_VBoxXPCOMIPCD_PIDfile="$VBoxXPCOMIPCD_PIDfile"
	
	[[ -e "$VBOXID" ]] && export VBOXID=$(cygpath -w "$VBOXID")
	[[ -e "$vBox_vdi" ]] && export vBox_vdi=$(cygpath -w "$vBox_vdi")
	[[ -e "$vBoxInstanceDir" ]] && export vBoxInstanceDir=$(cygpath -w "$vBoxInstanceDir")
	[[ -e "$VBOX_ID_FILE" ]] && export VBOX_ID_FILE=$(cygpath -w "$VBOX_ID_FILE")
	[[ -e "$VBOX_USER_HOME" ]] && export VBOX_USER_HOME=$(cygpath -w "$VBOX_USER_HOME")
	[[ -e "$VBOX_USER_HOME_local" ]] && export VBOX_USER_HOME_local=$(cygpath -w "$VBOX_USER_HOME_local")
	[[ -e "$VBOX_USER_HOME_short" ]] && export VBOX_USER_HOME_short=$(cygpath -w "$VBOX_USER_HOME_short")
	[[ -e "$VBOX_IPC_SOCKETID" ]] && export VBOX_IPC_SOCKETID=$(cygpath -w "$VBOX_IPC_SOCKETID")
	[[ -e "$VBoxXPCOMIPCD_PIDfile" ]] && export VBoxXPCOMIPCD_PIDfile=$(cygpath -w "$VBoxXPCOMIPCD_PIDfile")
}

_setFunctionEntry_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	export USERPROFILE="$functionEntry_USERPROFILE"
	export HOMEDRIVE="$functionEntry_HOMEDRIVE"
	export HOMEPATH="$functionEntry_HOMEPATH"
	
	export VBOXID="$functionEntry_VBOXID"
	export vBox_vdi="$functionEntry_vBox_vdi"
	export vBoxInstanceDir="$functionEntry_vBoxInstanceDir"
	export VBOX_ID_FILE="$functionEntry_VBOX_ID_FILE"
	export VBOX_USER_HOME="$functionEntry_VBOX_USER_HOME"
	export VBOX_USER_HOME_local="$functionEntry_VBOX_USER_HOME_local"
	export VBOX_USER_HOME_short="$functionEntry_VBOX_USER_HOME_short"
	export VBOX_IPC_SOCKETID="$functionEntry_VBOX_IPC_SOCKETID"
	export VBoxXPCOMIPCD_PIDfile="$functionEntry_VBoxXPCOMIPCD_PIDfile"
}

_prepare_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	mkdir -p "$HOME"
	
	_set_at_userMSW_discoverResource-cygwinNative-ProgramFiles "$@"
}


#_at_userMSW_discoverResource-cygwinNative-ProgramFiles VBoxManage Oracle/VirtualBox false
_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles "$@"
}

# WARNING: Output of 'probe' messages may interfere if program (eg. VBoxManage) output is expected not to include such messages.
#_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false
#_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VBoxManage Oracle/VirtualBox false
_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles() {
	if declare -f orig_"$1" > /dev/null 2>&1
	then
		_messagePlain_probe 'exists: override: '"$1"
		return 0
	fi
	
	unset "$1"
	_discoverResource-cygwinNative-ProgramFiles "$1" "$2" "$3"
	
	! type "$1" > /dev/null 2>&1 && return 1
	
	
	# https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
	eval orig_"$(declare -f ""$1"")"
	
	unset "$1"
	eval "$1"'() { _prepare_at_userMSW_discoverResource-cygwinNative-ProgramFiles ; _userMSW _messagePlain_probe_cmd orig_'"$1"' "$@" ; _setFunctionEntry_at_userMSW_discoverResource-cygwinNative-ProgramFiles ; }'
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

# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
[[ "$profileScriptLocation_new" == 'true' ]] && echo -n '.'

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
		
		
		_discoverResource-cygwinNative-ProgramFiles 'ykman' 'Yubico/YubiKey Manager' false

		# For efficiency, do not search locations other than ' C:\ ' (aka. '/cygdrive/c' ).
		[[ -e '/cygdrive/c/Program Files/Yubico/Yubico PIV Tool/bin/yubico-piv-tool.exe' ]] && _discoverResource-cygwinNative-ProgramFiles 'yubico-piv-tool' 'Yubico/Yubico PIV Tool/bin' false
		
		
		# WARNING: Prefer to avoid 'nmap' for Cygwin/MSW .
		#_discoverResource-cygwinNative-ProgramFiles 'nmap' 'Nmap' false
		
		_discoverResource-cygwinNative-ProgramFiles 'qalc' 'Qalculate' false
		
		
		# WARNING: CAUTION: DANGER: UNIX EOL *MANDATORY* !
		[[ -e "$scriptAbsoluteFolder"/ops-cygwin.sh ]] && . "$scriptAbsoluteFolder"/ops-cygwin.sh
		
		# export ubiquitousBashID=uk4uPhB663kVcygT0q
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
		export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
		[[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q ]] && [[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh ]] && . /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh
		
		#_ops_cygwinOverride_allDisks "$@"
		
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
		
		
		
		# CAUTION: Performance - such '_discoverResource' functions are time consuming . If reasonable, instead call only from functions as necessary (eg. as part of '_userVBox') .
		# ATTENTION: Expect 0.500s for any program which is not found at 'C:\Program Files' or similar, and 0.200s for any program which is found quickly.
		# Other inefficiencies of Cygwin are usually more substantial if only a few entries are here.
		
		
		# WARNING: Native 'vncviewer.exe' is a GUI app, and cannot be launched directly from Cygwin SSH server.
		_discoverResource-cygwinNative-ProgramFiles 'vncviewer' 'TigerVNC' false '_workaround_cygwin_tmux '
		
		#_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false
		
		
		
		
		
		_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false > /dev/null 2>&1
	fi
	
	export override_cygwin_vncviewer="true"

	kwrite() {
		kate -n "$@"
	}

	_aria2c_cygwin_overide() {
		if _safeEcho_newline "$@" | grep '\--async-dns' > /dev/null
		then
			aria2c "$@"
			return
		else
			aria2c --async-dns=false "$@"
			return
		fi
	}
	alias aria2c=_aria2c_cygwin_overide

	##! type -p wslg
	#[[ -e '/cygdrive/c/WINDOWS/system32/wslg.exe' ]] && wsl() { '/cygdrive/c/WINDOWS/system32/wslg.exe' "$@" ; }
	[[ -e '/cygdrive/c/Program Files/WSL/wslg.exe' ]] && wslg() { '/cygdrive/c/Program Files/WSL/wslg.exe' "$@" ; } && wslg.exe() { wslg "$@" ; }
	##! type -p wsl
	#[[ -e '/cygdrive/c/WINDOWS/system32/wsl.exe' ]] && wsl() { '/cygdrive/c/WINDOWS/system32/wsl.exe' "$@" ; }
	[[ -e '/cygdrive/c/Program Files/WSL/wsl.exe' ]] && wsl() { '/cygdrive/c/Program Files/WSL/wsl.exe' "$@" ; } && wsl.exe() { wsl "$@" ; }
fi

# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
[[ "$profileScriptLocation_new" == 'true' ]] && echo -n '.'







_discoverResource-cygwinNative-nmap() {
	type nmap > /dev/null 2>&1 && return 0
	# WARNING: Prefer to avoid 'nmap' for Cygwin/MSW .
	_if_cygwin && _discoverResource-cygwinNative-ProgramFiles 'nmap' 'Nmap' false
}





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
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')
	
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
	
	cp "$scriptAbsoluteFolder"/_setupUbiquitous.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_setupUbiquitous_nonet.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/fork "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	
	cp "$scriptAbsoluteFolder"/package.tar.xz "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/ > /dev/null 2>&1
	
	
	
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
	
	cp "$scriptLocal"/ubcp/cygwin-portable-installer-config.cmd  "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
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
	
	
	# ATTENTION: NOTICE: Any installer for developers which relies on unpacking directories to '/core/infrastructure' must also add this to '/' .
	# Having '_bash.bat' at '/' normally allows developers to get a bash prompt from both 'CMD' and 'PowerShell' terminal windows by '/_bash' command.
	cp "$scriptAbsoluteFolder"/_bash.bat "$currentCygdriveC_equivalent"/
	
	
	_messagePlain_good 'done: _setup_ubiquitousBash_cygwin: lean'
	sleep 1
}


_setup_ubiquitousBash_cygwin() {
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$@"
}


_report_setup_ubcp() {
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')


	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/
	#cd "$currentCygdriveC_equivalent"/core/infrastructure/


	find /bin/ /usr/bin/ /sbin/ /usr/sbin/ | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-binReport > /dev/null
	find /home/root/ | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-homeReport > /dev/null


	apt-cyg show | cut -f1 -d\ | tail -n +2 | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-packageReport > /dev/null
}


_setup_ubcp_procedure() {
	_messagePlain_nominal 'init: _setup_ubcp_procedure'
	! uname -a | grep -i cygwin > /dev/null 2>&1 && _stop 1
	
	tskill ssh-pageant > /dev/null 2>&1
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')
	
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
	#tar -xvf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz

	if [[ "$skimfast" != "true" ]]
	then
		cat "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx | lz4 -d -c | tar -xvf -
	else
		cat "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx | lz4 -d -c | tar -xf -
		#tar -xf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx
	fi
	
	_messagePlain_good 'done: _setup_ubcp_procedure: ubcp'
	sleep 10
	
	cd "$outerPWD"
}



# CAUTION: Do NOT hook to '_setup' .
# WARNING: ATTENTION: NOTICE: No production use. Developer feature.
# Highly irregular accommodation for usage of 'ubiquitous_bash' through 'ubcp' (cygwin portable) compatibility layer through MSW network drive (especially '_userVBox' MSW guest network drive) .
# WARNING: May require 'administrator' privileges under MSW. However, it may be better for this directory to be 'owned' by the 'primary' 'user' account. Particularly considering the VR/gaming/CAD software that remains 'exclusive' to MSW is 'legacy' software which for both licensing and technical reasons may be inherently incompatible with 'multi-user' access.
# WARNING: MSW 'administrator' 'privileges' may break 'ubcp' .
_setup_ubcp() {
	_force_cygwin_symlinks
	
	# WARNING: May break if 'mitigation' has not been applied!
	#! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz ]] && 
	#! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz ]] && 
	if ! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx ]] && [[ -e "$scriptLocal"/ubcp/cygwin ]]
	then
		export ubPackage_enable_ubcp='true'
		"$scriptAbsoluteLocation" _package_procedure-cygwinOnly
	fi
	
	"$scriptAbsoluteLocation" _setup_ubcp_procedure "$1"
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$1"

	"$scriptAbsoluteLocation" _report_setup_ubcp "$1"
}






_mitigate-ubcp_rewrite_procedure() {
	[[ "$skimfast" != "true" ]] && _messagePlain_nominal 'init: _mitigate-ubcp_rewrite_procedure'
	[[ "$currentPWD" != "" ]] && cd "$currentPWD"
	local currentRoot=$(_getAbsoluteLocation "$PWD")
	
	local currentLink="$1"
	local currentLinkFile=$(basename "$1" )
	local currentLinkFolder=$(dirname "$1")
	currentLinkFolder=$(_getAbsoluteLocation "$currentLinkFolder")
	
	local currentLinkDirective=$(readlink "$1")
	
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentRoot
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLink
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkFile
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkFolder
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkDirective
	
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
			[[ "$skimfast" != "true" ]] && _messagePlain_probe "$currentLinkFolder"/"$currentDots"
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
	
	
	
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentRelativeRoot
	
	
	local processedLinkDirective
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		processedLinkDirective="$currentRelativeRoot""$currentLinkDirective"
		
	fi
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var processedLinkDirective
	
	
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		cd "$currentLinkFolder"
		
		[[ "$skimfast" != "true" ]] && ls -l "$processedLinkDirective"
		
		
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
		
		[[ -e "$processedLinkDirective" ]] && rm -f "$currentLinkFolder"/"$currentLinkFile"
		
		ln -sf "$processedLinkDirective" "$currentLinkFolder"/"$currentLinkFile"
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ "$skimfast" != "true" ]] && [[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
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
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		
		
		
		[[ "$skimfast" != "true" ]] && _messagePlain_nominal 'directive: replace: true'
		cp -L -R --preserve=all "$currentLinkFolder"/"$currentLinkFile" "$currentLinkFolder"/"$currentLinkFile".replace
		rm -f "$currentLinkFolder"/"$currentLinkFile"
		mv "$currentLinkFolder"/"$currentLinkFile".replace "$currentLinkFolder"/"$currentLinkFile"
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ "$skimfast" != "true" ]] && [[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
		cd "$outerPWD"
	fi
	
	
	
	return 0
}

# WARNING: May be untested.
_mitigate-ubcp_rewrite_parallel() {
	local currentArg
	for currentArg in "$@"
	do
		true
		
		_mitigate-ubcp_rewrite_procedure "$currentArg"
		
		# WARNING: May be untested.
		#_mitigate-ubcp_rewrite_procedure "$currentArg" &
		
		#/bin/echo "$currentArg" > /dev/tty
	done
}

_mitigate-ubcp_rewrite_sequence() {
	export safeToDeleteGit="true"
	! _safePath "$1" && _stop 1
	cd "$1"
	
	
	# WARNING: May be slow (multiple hours).
	unset currentPWD
	#find "$2" -type l -exec "$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_procedure '{}' \;
	
	
	# WARNING: May be untested.
	# https://stackoverflow.com/questions/4321456/find-exec-a-shell-function-in-linux
	# Since only the shell knows how to run shell functions, you have to run a shell to run a function.
	# export -f dosomething
	# find . -exec bash -c 'dosomething "$0"' {} \;
	unset currentPWD
	export currentPWD="$PWD"
	#export currentPWD="$1"
	unset currentFile
	export -f "_mitigate-ubcp_rewrite_procedure"
	export -f "_messagePlain_nominal"
	export -f "_color_begin_nominal"
	export -f "_color_end"
	export -f "_getAbsoluteLocation"
	export -f "_realpath_L_s"
	export -f "_realpath_L"
	export -f "_compat_realpath_run"
	export -f "_compat_realpath"
	export -f "_messagePlain_probe_var"
	export -f "_color_begin_probe"
	export -f "_messagePlain_probe"
	#find "$2" -print0 | while IFS= read -r -d '' currentFile; do _mitigate-ubcp_rewrite_procedure "$currentFile"; done
	
	
	
	# WARNING: May be untested.
	##find "$2" -type l -exec bash -c '_mitigate-ubcp_rewrite_procedure "$1"' _ {} \;
	
	
	#_experimentInteractive ()
	#{
		#echo begin: "$@";
		#sleep 1;
		#echo end
	#}
	#export -f _experimentInteractive
	#seq 1 500 | xargs -x -s 4096 -L 6 -P 4 bash -c 'echo begin: "$@" ; sleep 1 ; echo end' _
	#seq 1 500 | xargs -x -s 4096 -L 6 -P 4 bash -c '_experimentInteractive "$@"' _

	
	# WARNING: Diagnostic output will be corrupted by parallelism.
	# ATTENTION: Expect as much as 4x as many CPU threads may be saturated due to MSW (MSW, NOT Cygwin) inefficiencies.
	# Or only 2x if CPU has leading single-thread (ie. per-thread) performance and MSW inefficiencies have been reduced.
	# Expect done in as little as 15 minutes.
	# https://serverfault.com/questions/193319/a-better-unix-find-with-parallel-processing
	# https://stackoverflow.com/questions/11003418/calling-shell-functions-with-xargs
	export -f "_mitigate-ubcp_rewrite_parallel"
	find "$2" -type l -print0 | xargs -0 -x -s 4096 -L 6 -P $(nproc) bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _
	#find "$2" -type l -print0 | xargs -0 -n 1 -P 4 -I {} bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _ {}
	#find "$2" -type l -print0 | xargs -0 -n 1 -P 4 -I {} bash -c '_mitigate-ubcp_rewrite_procedure "$@"' _ {}
	
	return 0
}

_mitigate-ubcp_rewrite() {
	"$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_sequence "$@"

	# CAUTION: This may not catch mitigate failure . The actual issue with 'getconf' was removal of the 'ARG_MAX' value , which was not caused by mitigate failure .
	if [[ ! -e /usr/bin/getconf ]]
	then
		_messagePlain_bad 'missing: bad: /usr/bin/getconf'
		echo 'Usually, this is a symlink, if missing, indicative of failed symlink mitigation due to xargs parameter length or parallelism failure.'
		_messageFAIL
		_stop 1
		return 1
	fi
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
	"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
	
	export mitigate_ubcp_replaceSymlink='true'
	"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
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
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	
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
	#env XZ_OPT="-5 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz .
	#env XZ_OPT="-0 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz .
	#tar -cvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar .

	if [[ "$skimfast" != "true" ]]
	then
		tar -cvf - . | lz4 -z --fast=1 - "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx
	else
		tar -cf - . | lz4 -z --fast=1 - "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx
		#tar -cf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx .
	fi
	
	mkdir -p "$scriptLocal"/ubcp/
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx "$scriptLocal"/ubcp/
	
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














# Discouraged. Few file paths, some setup, etc, may be different. Otherwise, WSL should not be treated differently.
_if_wsl() {
    uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
}



# Ingredients. Debian pacakges mirror, docker images, pre-built dist/OS images, etc.
_set_ingredients() {
    export ub_INGREDIENTS=""

    local currentDriveLetter

    if ! _if_cygwin
    then
        [[ -e /mnt/ingredients/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients/ingredients && return 0

        # STRONGLY PREFERRED.
        [[ -e /mnt/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients && return 0

        # STRONGLY DISCOURAGED.
        # Do NOT create "$HOME"/core/ingredients unless for some very unexpected reason it is necessary for a non-root user to use ingredients.
        [[ -e "$HOME"/core/ingredients ]] && export ub_INGREDIENTS="$HOME"/core/ingredients && return 0

        # WSL(2) specific.
        #_if_wsl
        #uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
        if type _if_wsl > /dev/null 2>&1 && _if_wsl
        then
            [[ -e /mnt/host/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/host/z/mnt/ingredients && return 0
            [[ -e /mnt/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/z/mnt/ingredients && return 0
            [[ -e /mnt/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/c/core/ingredients && return 0
            [[ -e /mnt/host/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/host/c/core/ingredients && return 0
            #
            for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
            do
                [[ -e /mnt/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/"$currentDriveLetter"/ingredients && return 0
            done
            if [[ -e /mnt/host ]]
            then
                for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
                do
                    [[ -e /mnt/host/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/host/"$currentDriveLetter"/ingredients && return 0
                done
            fi
        fi
    fi

    if _if_cygwin
    then
        [[ -e /cygdrive/z/mnt/ingredients ]] && export ub_INGREDIENTS=/cygdrive/z/mnt/ingredients && return 0
        [[ -e /cygdrive/c/core/ingredients ]] && export ub_INGREDIENTS=/cygdrive/c/core/ingredients && return 0
        #
        for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
        do
            [[ -e /cygdrive/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/cygdrive/"$currentDriveLetter"/ingredients && return 0
        done
    fi




    [[ "$ub_INGREDIENTS" == "" ]] && return 1
    return 0
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
	#  ! [[ -e "$compat_realpath_bin" ]] && [[ "$compat_realpath_bin" != "" ]] && echo 'crit: missing: realpath' && _stop 1
	
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
	#  ! type realpath > /dev/null 2>&1 && return 1
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

	if [[ -e "$HOME"/.ubtmp ]] && uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		[[ "$1" == "$HOME"/.ubtmp/* ]] && safeToRM="true"
		[[ "$1" == "./"* ]] && [[ "$PWD" == "$HOME"/.ubtmp* ]] && safeToRM="true"
	fi
	
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#  ! type realpath > /dev/null 2>&1 && return 1
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

	if [[ -e "$HOME"/.ubtmp ]] && uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		[[ "$1" == "$HOME"/.ubtmp/* ]] && safeToRM="true"
		[[ "$1" == "./"* ]] && [[ "$PWD" == "$HOME"/.ubtmp* ]] && safeToRM="true"
	fi
	
	
	[[ "$safeToRM" == "false" ]] && return 1
	
	#Safeguards/
	[[ "$safeToDeleteGit" != "true" ]] && [[ -d "$1" ]] && [[ -e "$1" ]] && find "$1" 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	#Validate necessary tools were available for path building and checks.
	#  ! type realpath > /dev/null 2>&1 && return 1
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
	
	#  ! type realpath > /dev/null 2>&1 && return 1
	! type readlink > /dev/null 2>&1 && return 1
	! type dirname > /dev/null 2>&1 && return 1
	! type basename > /dev/null 2>&1 && return 1
	
	return 0
}




# Suggested for files used as Inter-Process Communication (IPC) or similar indicators (eg. temporary download files recently in progress).
# Works around files that may not be deleted by 'rm -f' when expected (ie. due to Cygwin/MSW file locking).
# ATTRIBUTION-AI: OpRt_.deepseek/deepseek-r1-distill-llama-70b  2025-03-27  (partial)
_destroy_lock() {
    [[ "$1" == "" ]] && return 0

    # Fraction of   2GB part file  divided by  1MB/s optical-disc write speed   .
    local currentLockWait="1250"

    local current_anyFilesExists
    local currentFile
    
    
    local currentIteration=0
    for ((currentIteration=0; currentIteration<"$currentLockWait"; currentIteration++))
    do
        rm -f "$@" > /dev/null 2>&1

        current_anyFilesExists="false"
        for currentFile in "$@"
        do
            [[ -e "$currentFile" ]] && current_anyFilesExists="true"
        done

        if [[ "$current_anyFilesExists" == "false" ]]
        then
            return 0
            break
        fi

        # DANGER: Does NOT use _safeEcho . Do NOT use with external input!
        ( echo "STACK_FAIL STACK_FAIL STACK_FAIL: software: wait: rm: exists: file: ""$@" >&2 ) > /dev/null
        sleep 1
    done

    [[ "$currentIteration" != "0" ]] && sleep 7
    return 1
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
		sudo -n pkill -P "$currentPID"
		kill "$currentPID"
		sudo -n kill "$currentPID"
	done < "$processListFile"
	
	if [[ "$ub_kill" == "true" ]]
	then
		sleep 9
		while read -r currentPID
		do
			pkill -KILL -P "$currentPID"
			sudo -n pkill -KILL -P "$currentPID"
			kill -KILL "$currentPID"
			sudo -n kill -KILL "$currentPID"
		done < "$processListFile"
	fi
	
	rm "$processListFile"
}

_killAll() {
	export ub_kill="true"
	_terminateAll
	export ub_kill=
}

_condition_lines_zero() {
	local currentLineCount
	currentLineCount=$(wc -l)
	
	[[ "$currentLineCount" == 0 ]] && return 0
	return 1
}


_safe_declare_uid() {
	unset _uid
	_uid() {
		local currentLengthUID
		currentLengthUID="$1"
		[[ "$currentLengthUID" == "" ]] && currentLengthUID=18
		cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "$currentLengthUID" 2> /dev/null
		return
	}
	export -f _uid
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
	#  ! _if_cygwin && _stop "$1"
	
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
# WARNING: Less track record with very unusual text. May or may not output correctly in some (unknown, unexpected) situations.
# DANGER: MUST use this function instead of _messagePlain_probe when text is from external origins!
_messagePlain_probe_safe() {
	_color_begin_probe
	#_color_begin_probe_noindent
	#echo -n "$@"
	_safeEcho "$@"
	_color_end
	echo
	return
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
	exit 1
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


_sep() {
	echo '________________________________________'
}

_mustcarry() {
	grep "$1" "$2" > /dev/null 2>&1 && return 0
	
	echo "$1" >> "$2"
	return
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
		# ATTENTION: Use of nmap on Cygwin/MSW is apparently unnecessary. Beginning to disable for this use case.
		#! type nmap > /dev/null 2>&1 && echo "missing socket detection: nmap" && _stop 1
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
	
	if type nmap > /dev/null 2>&1 && ! uname -a | grep -i cygwin > /dev/null
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
	_discoverResource-cygwinNative-nmap
	
	if _if_cygwin && ! type nmap > /dev/null 2>&1
	then
		echo 'warn: missing: nmap'
	else
	_getDep nmap
	fi
}

_showPort_ipv6() {
	_discoverResource-cygwinNative-nmap

	nmap -6 --host-timeout "$netTimeout" -Pn "$1" -p "$2" 2> /dev/null
}

_showPort_ipv4() {
	_discoverResource-cygwinNative-nmap
	
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
	_start scriptLocal_mkdir_disable
	
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
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian' > /dev/null 2>&1
	then
		_tryExecFull _fetchDep_debian "$@"
		return
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		_tryExecFull _fetchDep_ubuntu "$@"
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

_stopwatch() {
	local currentExitStatus_bin
	local currentExitStatus_self
	
	local measureDateA
	local measureDateB
	
	measureDateA=$(date +%s%N | cut -b1-13)

	"$@"
	currentExitStatus_bin="$?"

	measureDateB=$(date +%s%N | cut -b1-13)

	bc <<< "$measureDateB - $measureDateA"
	currentExitStatus_self="$?"

	[[ "$currentExitStatus_bin" != "0" ]] && return "$currentExitStatus_bin"
	[[ "$currentExitStatus_self" != "0" ]] && return "$currentExitStatus_self"
	return 0
}



_binToHex() {
	xxd -p | tr -d '\n'
}

_hexToBin() {
	xxd -r -p
}





_test_python() {
	_getDep python
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



# Suggested defaults. If your python code (not python itself, nor venv, etc, but filenames for files your python application uses, such as datasets, models, etc) insists on absolute paths, and you must use it under both UNIX/Linux and Cygwin/MSW, then it is probably only needed temporarily to generate static assets (ie. occasional experimental fine-tuning of the latest available AI models). In which case you can put into production under solely UNIX/Linux if necessary, and develop with Docker (ie. factory) instead.
# tldr; UNIX/Linux for python in production, Cygwin/MSW (ie. MSW native python) for python in development, as usual, and then you won't need abstractfs .
#
#_set_abstractfs_alwaysUNIXneverNative
#_set_abstractfs_disable



# EXAMPLE. Override or implement alternative with 'core.sh', 'ops.sh', or similar.
_msw_python() {
    #implies sequence
    _prepare_msw_python


    # ATTENTION: Dropping to an interactive shell in the midst of a bash function which provides standard output to another bash function
    #
    # ie. don't expect guaranteed sanity doing something like this in either bash or python
    # echo $( echo result ; bash -i ) | tee > ./logfile.txt
    #
    # ALWAYS call interactively unless 'stdout' will be consumed. Functions, scripts, commands, get an interactive terminal to talk to, except very simple functions.
    #
    # ie. _fineTune_model  <->  Interactive Shell
    # ie. _vector_model  <->  Interactive Shell
    # ie. _inferenceModel | grep 'stuff' > description.txt  <->  Interactive Shell
    # ie. result=$(_inferenceModel | grep 'correct')  <->  Non-Interactive
    #
    # Unfortunately, bash function calls from python do not enjoy the '$() > /dev/null 2>&1' syntactic convenience.
    # Python calls to '_bin()' , '_bash()' , etc, must explicitly declare or implicitly default sanely whether interactive or non-interactive captured output.
    
    # lean.py ... is a template script from 'ubiquitous_bash' for lightweight manual changes
    #"$scriptLocal"/python_msw/lean.py   #automatically replaced with autogenerated lean.py
    #"$scriptLib"/python_msw/lean.py    #ATTTENTION: create persistent custom lean.py here


    # WARNING: May be untested.
    #python "$scriptLib_msw"'\python\lean.py' '_bin(["sleep", "90",], True, r"'"$scriptCall_bin_msw"'")'

    #python "$scriptAbsoluteFolder_msw"'\lean.py' '_bash(["-i"], True, r"'"$scriptCall_bash_msw"'")'

    python "$scriptAbsoluteFolder_msw"'\lean.py' '_bin(["_demo_msw_python",], True, r"'"$scriptCall_bin_msw"'", interactive=True)'

    #python -i "$scriptAbsoluteFolder_msw"'\lean.py' '_python()'

    #_bash
}
_msw_python_bash() {
    #implies sequence
    _prepare_msw_python

    _bash
}
_msw_python_bin() {
    #implies sequence
    _prepare_msw_python

    _bin "$@"
}




# EXAMPLE. Override or implement alternative with 'core.sh', 'ops.sh', or similar.
_prepare_msw_python() {
    _prepare_msw_python_3
}
_prepare_msw_python_3() {
    _prepare_msw_python_3_10
}
# EXAMPLE. Override or implement alternative (discouraged) with 'core.sh', 'ops.sh', or similar, if necessary.
_prepare_msw_python_3_10() {
    _set_msw_python_3_10

    # ATTENTION: implies sequence
    local currentUID="$sessionid"

    # ATTENTION: Do NOT enable. Prevents 'trap' cleanup of abandoned lock file.
    #local currentUID=$(_uid 18)

    local currentUID_length=${#currentUID}
    local currentUID_length_plus1=$(( currentUID_length + 1 ))

    local currentPATH="$PATH"

    _write_python_hook_local() {
        _messagePlain_nominal 'prepare: python hook' > /dev/null >&2
    
        local ubcore_accessoriesFile_python
        local ubcoreDir_accessories_python
        local ubcore_accessoriesFile_python_ubhome

        ubcore_accessoriesFile_python=$(cygpath -w "$scriptLib"/python_msw/lean.py)
        ubcoreDir_accessories_python=$(cygpath -w "$scriptLib"/python_msw)
        ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLib"/python_msw/lean.py)
        if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcoreDir_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
        then
            ( _messagePlain_warn 'warn: missing: scriptLib/python_msw/...' >&2 ) > /dev/null
            
            ubcore_accessoriesFile_python=$(cygpath -w "$scriptLocal"/python_msw/lean.py)
            ubcoreDir_accessories_python=$(cygpath -w "$scriptLocal"/python_msw)
            ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLocal"/python_msw/lean.py)
            if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcoreDir_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
            then
                ( _messagePlain_warn 'warn: missing: scriptLocal/python_msw/...' >&2 ) > /dev/null
            fi
        fi

        local ubcore_ubcorerc_pythonrc="lean"
        
        _setupUbiquitous_accessories_here-python_hook > "$scriptLocal"/python_msw/pythonrc."$currentUID"
        if [[ ! -e "$scriptLocal"/python_msw/pythonrc ]] || ! diff --unified=3 "$scriptLocal"/python_msw/pythonrc."$currentUID" "$scriptLocal"/python_msw/pythonrc > /dev/null
        then
            mv -f "$scriptLocal"/python_msw/pythonrc."$currentUID" "$scriptLocal"/python_msw/pythonrc
        else
            rm -f "$scriptLocal"/python_msw/pythonrc."$currentUID"
        fi
        
        export _PYTHONSTARTUP=$(cygpath -w "$scriptLocal"/python_msw/pythonrc)
        export PYTHONSTARTUP="$_PYTHONSTARTUP"
    }
    unset _PYTHONSTARTUP
    

    local current_done__prepare_msw_python_procedure="false"


    _lock_prepare_python_msw() {
        _messagePlain_nominal 'prepare: wait: lock: _lock_prepare_python_msw' > /dev/null >&2
        local dateA
        local dateB
        local dateDelta
        while [[ $(cat "$scriptLocal"/python_msw.lock 2> /dev/null | head -c "$currentUID_length") != "$currentUID" ]]
        do
            if [[ ! -e "$scriptLocal"/python_msw.lock ]]
            then
                echo "$currentUID"$(date +%s | tr -dc '0-9') > "$scriptLocal"/python_msw.lock."$currentUID"
                mv -f "$scriptLocal"/python_msw.lock."$currentUID" "$scriptLocal"/python_msw.lock
            fi

            sleep 7
            [[ $(cat "$scriptLocal"/python_msw.lock 2> /dev/null | head -c "$currentUID_length") == "$currentUID" ]] && return 0

            _messagePlain_probe "wait: lock" > /dev/null >&2

            while [[ -e "$scriptLocal"/python_msw.lock ]] && [[ $(cat "$scriptLocal"/python_msw.lock 2> /dev/null | head -c "$currentUID_length") != "$currentUID" ]]
            do
                dateA=$(cat "$scriptLocal"/python_msw.lock 2> /dev/null | tail -c +"$currentUID_length_plus1" | tr -dc '0-9')
                dateB=$(date +%s | tr -dc '0-9')
                _messagePlain_probe "$dateB - $dateA"
                dateDelta=$(bc <<< "$dateB - $dateA")

                sleep 7

                # Normal prepare time is <<2minutes, if that.
                [[ "$dateDelta" -gt "2700" ]] && rm -f "$scriptLocal"/python_msw.lock
            done
        done
    }
    _lock_prepare_python_msw
    #...
    #rm -f "$scriptLocal"/python_msw.lock

    # WARNING: Do not add '-msw_python_3_10' or similar suffix to dumbpath_file . Use separate derivative projects for separate venv as normally needed for different python versions.
    local dumbpath_file="$scriptLocal"/"$dumbpath_prefix"dumbpath.var
    local dumbpath_contents=""
    dumbpath_contents=$(cat "$dumbpath_file" 2> /dev/null)
    if [[ "$dumbpath_contents" != "$dumbpath_file" ]]
    then
        # ATTENTION: WARNING: Anaconda is usually unnecessary, STRONGLY DISCOURAGED, and NOT automatically installed (eg. with 'ubdist/OS').
        # Automatic installation of Anaconda is not expected useful for any purpose - only workstations for personal evaluation of open-source projects which happen to use Anaconda for a non=production purpose are expected to use Anaconda, if at all.
        # Manual installation of Anaconda:
        # https://docs.conda.io/projects/conda/en/latest/user-guide/install/windows.html
        # https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html



        

        # erase any venv, etc, which may use absolute paths
        _messagePlain_nominal 'prepare: python_msw' > /dev/null >&2

        export safeToDeleteGit="true"
        _safeRMR "$scriptLocal"/python_msw
        mkdir -p "$scriptLocal"/python_msw


        #[[ "$current_done__prepare_msw_python_procedure" == "false" ]] && 
        _prepare_msw_python_procedure
        current_done__prepare_msw_python_procedure="true"


        
        # write python hook ; mv -f

        #[[ "$_PYTHONSTARTUP" == "" ]] && 
        _write_python_hook_local


#if false
#then
        # rebuild venv...
        _messagePlain_nominal 'prepare: venv' > /dev/null >&2
        
        mkdir -p "$scriptLocal"/python_msw/venv
        ! cd "$scriptLocal"/python_msw/venv && _stop 1
        python3 -m venv default_venv > /dev/null >&2

        
        cp -a default_venv/Scripts/activate default_venv/Scripts/activate_msw
        dos2unix default_venv/Scripts/activate_msw
        chmod u+x default_venv/Scripts/activate_msw

        #source default_venv/Scripts/activate > /dev/null >&2
        _messagePlain_probe source default_venv/Scripts/activate_msw > /dev/null >&2
        source default_venv/Scripts/activate_msw > /dev/null >&2
        PATH="$currentPATH"

        _messagePlain_nominal 'prepare: venv: set' > /dev/null >&2
        _set_msw_python_procedure

        _messagePlain_probe _install_dependencies_msw_python_procedure-specific "" "" > /dev/null >&2
        _install_dependencies_msw_python_procedure-specific "" ""
        
        _messagePlain_probe python -c "import sys; print(sys.path)" > /dev/null >&2
        python -c "import sys; print(sys.path)" > /dev/null >&2

        #deactivate > /dev/null >&2
#fi



        # morsels...
        _messagePlain_nominal 'prepare: morsels: pip' > /dev/null >&2

        _morsels_msw_pip_python_3_10











        # write > "$dumbpath_file" ; mv -f

        # ATTENTION: Disable (ie. comment out) to force always rebuild, packages install, etc.
        echo "$dumbpath_file" > "$dumbpath_file"."$currentUID"
        mv -f "$dumbpath_file"."$currentUID" "$dumbpath_file"



    fi

    [[ "$current_done__prepare_msw_python_procedure" == "false" ]] && _prepare_msw_python_procedure
    current_done__prepare_msw_python_procedure="true"

    [[ "$_PYTHONSTARTUP" == "" ]] && _write_python_hook_local

#if false
#then
    _messagePlain_nominal 'prepare: venv: activate' > /dev/null >&2
    ! cd "$scriptLocal"/python_msw/venv && _stop 1
    #sourcedefault_venv/Scripts/activate > /dev/null >&2
    _messagePlain_probe source  default_venv/Scripts/activate_msw > /dev/null >&2
    source default_venv/Scripts/activate_msw > /dev/null >&2
    PATH="$currentPATH"

    _messagePlain_nominal 'prepare: venv: set' > /dev/null >&2
    _set_msw_python_procedure
    
    _messagePlain_probe python -c "import sys; print(sys.path)" > /dev/null >&2
    python -c "import sys; print(sys.path)" > /dev/null >&2
#fi

    _messagePlain_probe _install_dependencies_msw_python_procedure-specific "" "" > /dev/null >&2
    _install_dependencies_msw_python_procedure-specific "" ""





    #set ACCELERATE="%VENV_DIR%\Scripts\accelerate.exe"


    rm -f "$scriptLocal"/python_msw.lock
}







# EXAMPLE. Override (preferred) or implement alternative (discouraged) with 'core.sh', 'ops.sh', or similar.
_morsels_msw_pip_python_3_10() {
    local currentPackages_indicator_list=( "huggingface_hub[cli]" )
    local currentPackages_list=( "huggingface_hub[cli]" )
    local currentPackage

    local currentWork="false"
    for currentPackage in "${currentPackages_indicator_list[@]}"
    do
        ! pip show "$currentPackage" > /dev/null 2>&1 && currentWork="true"
        #! python -m pip show "$currentPackage" > /dev/null 2>&1 && currentWork="true"
    done
    [[ "$currentWork" == "false" ]] && return 0

    [[ "$nonet" != "true" ]] && python -m pip install --upgrade pip > /dev/null >&2

    for currentPackage in "${currentPackages_list[@]}"
    do
        #,win32,win_arm64
        [[ "$nonet" != "true" ]] && pip download "$currentPackage" --platform win_amd64 --only-binary=:all: --dest "$(cygpath -w "$scriptAbsoluteFolder"/_bundle/morsels/pip)" > /dev/null >&2
        
        pip install --no-index --find-links="$(cygpath -w "$scriptAbsoluteFolder"/_bundle/morsels/pip)" "$currentPackage" > /dev/null >&2

        # Strongly discouraged! Avoid surprise breakage by never relying on upstream repositories.
        #[[ "$nonet" != "true" ]] && pip install "$currentPackage" > /dev/null >&2
    done
}

























_discover-msw_python() {
    _discover_procedure-msw_python "$@"
    if [[ "$lib_dir_msw_python_wheels" != "" ]]
    then
        export lib_dir_msw_python_wheels_msw=$(cygpath -w "$lib_dir_msw_python_wheels")
        if [[ "$_PATH_pythonDir" != "" ]]
        then
            export lib_dir_msw_python_wheels_relevant="$lib_dir_msw_python_wheels_msw"
        else
            export lib_dir_msw_python_wheels_relevant="$lib_dir_msw_python_wheels"
        fi
        return 0
    fi
    export lib_dir_msw_python_wheels_msw=""
    unset lib_dir_msw_python_wheels_msw
    export lib_dir_msw_python_wheels_relevant=""
    unset lib_dir_msw_python_wheels_relevant
    return 1
}
_discover_procedure-msw_python() {
    export lib_dir_msw_python_wheels
    
    export lib_dir_msw_python_wheels="$scriptAbsoluteFolder"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLocal"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLib"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi

    
    export lib_dir_msw_python_wheels="$scriptLib"/ubiquitous_bash/_lib/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi

    export lib_dir_msw_python_wheels=""
    unset lib_dir_msw_python_wheels
}
_install_dependencies_msw_python_procedure-specific() {
    _messagePlain_nominal 'install: dependencies' > /dev/null >&2

    _discover-msw_python

    # Not all of these packages are necessary for dist/OS other than native MSWindows.
    local currentPackages_list=("pyreadline3" "colorama")
    local currentPackage

    if [[ "$nonet" != "true" ]]
    then
        _pip_upgrade() {
            local currentUpgrade="false"
            for currentPackage in "${currentPackages_list[@]}"
            do
                ! "$1"pip show "$currentPackage" > /dev/null 2>&1 && currentUpgrade="true"
                #! "$2"python -m pip show "$currentPackage" > /dev/null 2>&1 && currentUpgrade="true"
            done
            [[ "$currentUpgrade" == "false" ]] && return 0
            "$2"python -m pip install --upgrade pip > /dev/null >&2
        }
        _pip_upgrade "$1" "$2"
    fi


    if [[ "$nonet" != "true" ]]
    then

        if [[ "$lib_dir_msw_python_wheels" != "" ]]
        then
            # ATTRIBUTION-AI: ChatGPT o3  2025-04-19  (partially)
            _pip_download() {
                "$1"pip show "$3" > /dev/null 2>&1 && return 0
                #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

                #--python-version 3.1
                "$1"pip download "$3" --platform win_amd64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                #"$1"pip download "$3" --platform win32 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                "$1"pip download "$3" --platform win_arm64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                
                #"$2"python -m pip download "$3" --platform win_amd64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                #"$2"python -m pip download "$3" --platform win32 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                #"$2"python -m pip download "$3" --platform win_arm64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
            }

            for currentPackage in "${currentPackages_list[@]}"
            do
                _pip_download "$1" "$2" "$currentPackage"
            done
        fi
    fi


    if [[ "$lib_dir_msw_python_wheels_relevant" != "" ]]
    then
        _pip_install_nonet() {
            "$1"pip show "$3" > /dev/null 2>&1 && return 0
            #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

            "$1"pip install --no-index --find-links="$lib_dir_msw_python_wheels_relevant" "$3" > /dev/null >&2
            #"$2"python -m pip install --no-index --find-links="$lib_dir_msw_python_wheels_relevant" "$3" > /dev/null >&2
        }
        for currentPackage in "${currentPackages_list[@]}"
        do
            _pip_install_nonet "$1" "$2" "$currentPackage"
        done
    fi
    
    if [[ "$nonet" != "true" ]]
    then
        _pip_install() {
            "$1"pip show "$3" > /dev/null 2>&1 && return 0
            #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

            "$1"pip install "$3" > /dev/null >&2
            #"$2"python -m pip install "$3" > /dev/null >&2
        }
        for currentPackage in "${currentPackages_list[@]}"
        do
            _pip_install "$1" "$2" "$currentPackage"
        done
    fi
}
_install_dependencies_msw_python_sequence-specific() {
    _messageNormal '     install: dependencies: '"$1" > /dev/null >&2
    _start

    "$1"
    if [[ ! -e "$_PATH_pythonDir" ]]
    then
        ( _messagePlain_warn 'warn: skip: missing: python: '"$1" >&2 ) > /dev/null
        _stop 1
    fi
    
    _install_dependencies_msw_python_procedure-specific

    _stop
}
_install_dependencies_msw_python() {
    _install_dependencies_msw_python_sequence-specific _set_msw_python_3_10
}




_prepare_msw_python_procedure() {
    local currentUID=$(_uid)

    if [[ ! -e "$_PATH_pythonDir"/python3 ]] && [[ $(find "$_PATH_pythonDir" -maxdepth 1 -iname 'python3' -type f -print -quit 2>/dev/null | tr -dc 'a-zA-Z0-9') == "" ]]
    then
        echo '#!/usr/bin/env bash
        python "$@"' > "$_PATH_pythonDir"/python3."$currentUID"
        chmod u+x "$_PATH_pythonDir"/python3."$currentUID"
        mv -f "$_PATH_pythonDir"/python3."$currentUID" "$_PATH_pythonDir"/python3
        chmod u+x "$_PATH_pythonDir"/python3
    fi
    

    mkdir -p "$scriptLocal"

    mkdir -p "$scriptLocal"/python_msw

    # In practice, 'pip' morsels may be all that is needed (ie. using 'pip' morsels for venv installation).
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/pip

    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/venv
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/accelerate

    # STRONGLY DISCOURAGED!
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/conda

    if [[ ! -e "$scriptLocal"/python_msw/lean.py ]] || ! diff --unified=3 "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/python_msw/lean.py > /dev/null
    then
        cp -f "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/python_msw/lean.py."$currentUID" > /dev/null 2>&1
        mv -f "$scriptLocal"/python_msw/lean.py."$currentUID" "$scriptLocal"/python_msw/lean.py
        if [[ ! -e "$scriptLocal"/python_msw/lean.py ]]
        then
            cp -f "$scriptLib"/ubiquitous_bash/lean.py "$scriptLocal"/python_msw/lean.py."$currentUID"
            mv -f "$scriptLocal"/python_msw/lean.py."$currentUID" "$scriptLocal"/python_msw/lean.py
        fi
    fi
    [[ ! -e "$scriptLocal"/python_msw/lean.py ]] && ( _messagePlain_warn 'warn: missing: scriptLocal/python_msw/lean.py' >&2 ) > /dev/null


    _install_dependencies_msw_python_procedure-specific "" ""

    return 0
}




# UNIX/Linux of course has no need for such overrides, having normal Python installations in directories in PATH and no distinction between native/MSW and Cygwin/MSW binaries .
_override_msw_path_python_procedure() {
		local path_entry entry IFS=':'
		local new_path=""
		for entry in $PATH ; do
			# Skip adding if this entry matches current_binaries_path exactly
			[ "$entry" = "$current_binaries_path" ] && continue
			
			# Append current entry to the new_path
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:${entry}"
			fi
		done

		# Finally, explicitly prepend the git path
		export PATH="${current_binaries_path}:${new_path}"

        [[ "$1" == "" ]] && export _PATH_pythonDir="$current_binaries_path"

        [[ "$1" != "" ]] && ( _messagePlain_probe_var PATH >&2 ) > /dev/null

        return 0
}
_detect_msw_path_python() {
        current_binaries_path="$1"

        ! [[ -d "$current_binaries_path" ]] && ( _messagePlain_warn 'warn: missing: python: '"$1" >&2 ) && return 1

        ( _messagePlain_good 'success: found: python: '"$1" >&2 ) > /dev/null
}
_detect_msw_path_python-localappdata() {
        current_binaries_path=$(cygpath -u "$LOCALAPPDATA")
        current_binaries_path="$current_binaries_path"/"$1"

        ! [[ -d "$current_binaries_path" ]] && ( _messagePlain_warn 'warn: missing: python: '"$1" >&2 ) && return 1

        ( _messagePlain_good 'success: found: python: '"$1" >&2 ) > /dev/null
}
_override_msw_path_python_3_10() {
    _messagePlain_nominal 'override: '${FUNCNAME[0]}

    local current_binaries_path=""

    # WARNING: Python 'embed' package may not be tested. Use the installer instead.

    _detect_msw_path_python "$scriptLib"/msw/python-3.10.11-embed-amd64
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python "$scriptLocal"/msw/python-3.10.11-embed-amd64
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python-localappdata "Programs/Python/python-3.10.11-embed-amd64"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python-localappdata "Programs/Python/Python310"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0


    ( _messagePlain_bad 'FAIL: missing: python: '${FUNCNAME[0]} >&2 ) > /dev/null
    ( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' >&2 ) > /dev/null
    #( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-embed-amd64.zip' >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$scriptLib"/msw/ >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$scriptLocal"/msw/ >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$LOCALAPPDATA"'Programs/Python' >&2 ) > /dev/null
    _messageFAIL >&2
}

# CAUTION: Called by _setupUbiquitous_accessories_here-python_hook .
_set_msw_python_procedure() {
    # WARNING: Invalid variables for 'python...embed' .
    export _pythonLib=$(find "$_PATH_pythonDir" -iname 'Lib' -type d -print -quit)
    export _pythonSitePackages=$(find "$_PATH_pythonDir" -iname 'site-packages' -type d -print -quit)
    export _pythonPip_file=$(find "$_PATH_pythonDir" -iname 'pip3.exe' -type f -print -quit)
    export _pythonPip=$([[ "$_pythonPip_file" != "" ]] && _getAbsoluteFolder "$_pythonPip_file")
    export _pythonPipInstaller_file=$(find "$_PATH_pythonDir" -iname 'get-pip.py' -type f -print -quit)

    # DUBIOUS
    export _transformersCache="$scriptLocal"/transformers-cache


    #export _python=$(find "$_PATH_pythonDir" -iname 'python.exe' -type f -print -quit)

    #export _accelerate=$(find "$_PATH_pythonDir" -iname 'accelerate.exe' -type f -print -quit)


    [[ ! -e "$_pythonLib" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonSitePackages" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonPip_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonPip" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    #[[ ! -e "$_pythonPipInstaller_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2

    local current_binaries_path
    current_binaries_path="$_PATH_pythonDir"
    _override_msw_path_python_procedure "_PATH_pythonDir"

    current_binaries_path="$_pythonPip"
    _override_msw_path_python_procedure "pip"

    local VIRTUAL_ENV_unix
    [[ "$VIRTUAL_ENV" != "" ]] && VIRTUAL_ENV_unix=$(cygpath -u "$VIRTUAL_ENV")
    VIRTUAL_ENV_unix="$VIRTUAL_ENV_unix"/Scripts
    if [[ -e "$VIRTUAL_ENV_unix" ]]
    then
        export _pythonLib=$(find "$VIRTUAL_ENV_unix"/.. -iname 'Lib' -type d -print -quit)
        export _pythonSitePackages=$(find "$VIRTUAL_ENV_unix"/.. -iname 'site-packages' -type d -print -quit)
        export _pythonPip_file=$(find "$VIRTUAL_ENV_unix" -iname 'pip3.exe' -type f -print -quit)
        export _pythonPip=$([[ "$_pythonPip_file" != "" ]] && _getAbsoluteFolder "$_pythonPip_file")
        export _pythonPipInstaller_file=$(find "$VIRTUAL_ENV_unix" -iname 'get-pip.py' -type f -print -quit)


        #export _python=$(find "$_PATH_pythonDir" -iname 'python.exe' -type f -print -quit)

        #export _accelerate=$(find "$_PATH_pythonDir" -iname 'accelerate.exe' -type f -print -quit)


        [[ ! -e "$_pythonLib" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
        [[ ! -e "$_pythonSitePackages" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
        [[ ! -e "$_pythonPip_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
        [[ ! -e "$_pythonPip" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
        #[[ ! -e "$_pythonPipInstaller_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2


        current_binaries_path="$VIRTUAL_ENV_unix"
        _override_msw_path_python_procedure "VIRTUAL_ENV"

        current_binaries_path="$_pythonPip"
        _override_msw_path_python_procedure "VIRTUAL_ENV_pip"
    fi

    unset PYTHONHOME
    export PYTHONSTARTUP="$_PYTHONSTARTUP"
    
    return 0
}

set_msw_python() {
    _set_msw_python_3_10 "$@"
}
_set_msw_python_3_10() {
    _override_msw_path_python_3_10 "$@"

    _set_msw_python_procedure "$@"
}



_demo_msw_python() {
    _messagePlain_nominal 'demo: '${FUNCNAME[0]} > /dev/null >&2
    sleep 0.6
    "$@"
    _bash
}


# STRONGLY DISCOURAGED




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
		PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\[\033[01;36m\]'1)
		#PS1_lineNumberText=$(echo -e -n '\033[01;36m'1)
	fi
}

_visualPrompt() {
	local currentHostname
	currentHostname="$HOSTNAME"
	
	[[ -e /etc/hostname ]] && export currentHostname=$(cat /etc/hostname)
	
	
	export currentChroot=
	[[ "$chrootName" != "" ]] && export currentChroot="$chrootName"
	#[[ "$VIRTUAL_ENV_PROMPT" != "" ]] && export currentChroot=python_"$VIRTUAL_ENV_PROMPT"
	
	
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
	
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	if [[ "$SHELL" == *"/nix/store/"*"/bin/bash"* ]]
	then
		export prompt_nixShell="nixShell"
	else
		export prompt_nixShell=""
	fi
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	
	#if _if_cygwin
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#else
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	#fi
	
	if _if_cygwin
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	else
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	fi
	
	#export PS1="$prompt_nixShell""$PS1"
}


_request_visualPrompt() {
	_messagePlain_request 'export profileScriptLocation="'"$scriptAbsoluteLocation"'"'
	_messagePlain_request 'export profileScriptFolder="'"$scriptAbsoluteFolder"'"'
	_messagePlain_request ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
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
	
	find . -not -path "./_local/*" -name '*.sh' -type f -size -3000k -exec grep -n "$@" '{}' /dev/null \;
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
	
	_safe_declare_uid
}

_queryServer_sequence() {
	_start
	
	_safe_declare_uid
	
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
	
	_safe_declare_uid
	
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


_self_gitMad_procedure() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	cd "$scriptAbsoluteFolder"
	_gitMad
	
	cd "$functionEntryPWD"
}
_self_gitMad() {
	"$scriptAbsoluteLocation" _self_gitMad_procedure "$@"
}
# https://stackoverflow.com/questions/1580596/how-do-i-make-git-ignore-file-mode-chmod-changes
_gitMad() {
	local currentDirectory=$(_getAbsoluteLocation "$PWD")
	_write_configure_git_safe_directory_if_admin_owned "$currentDirectory"

	git config core.fileMode false
	git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
}


_gitBest_detect_github_procedure() {
	[[ "$current_gitBest_source_GitHub" == "FAIL" ]] && export current_gitBest_source_GitHub=""
	[[ "$current_gitBest_source_GitHub" != "" ]] && return
	
	_messagePlain_nominal 'init: _gitBest_detect_github_procedure'
	
	if [[ "$current_gitBest_source_GitHub" == "" ]]
	then
		_messagePlain_request 'performance: export current_gitBest_source_GitHub=$("'"$scriptAbsoluteLocation"'" _gitBest_detect_github_sequence | tail -n1)'
		
		if [[ -e "$HOME"/core ]] && [[ "$gitBestNoCore" != "true" ]]
		then
			export current_gitBest_source_GitHub="github_core"
		fi
		
		local currentSSHoutput
		# CAUTION: Disabling this presumes "$HOME"/.ssh/config for GitHub (possibly through 'CoreAutoSSH') is now not necessary to support by default.
		#  ATTENTION: Good assumption. GH_TOKEN/INPUT_GITHUB_TOKEN is now used by _gitBest within 'compendium' functions, etc, usually much safer and more convenient.
		#   Strongly Discouraged: Override with ops.sh if necessary.
		# || [[ -e "$HOME"/.ssh/config ]]
		if ( [[ -e "$HOME"/.ssh/id_rsa ]] || ( [[ ! -e "$HOME"/.ssh/id_ed25519_sk ]] && [[ ! -e "$HOME"/.ssh/ecdsa-sk ]] ) ) && currentSSHoutput=$(ssh -o StrictHostKeyChecking=no -o Compression=yes -o ConnectionAttempts=3 -o ServerAliveInterval=6 -o ServerAliveCountMax=9 -o ConnectTimeout="$netTimeout" -o PubkeyAuthentication=yes -o PasswordAuthentication=no git@github.com 2>&1 ; true) && _safeEcho_newline "$currentSSHoutput" | grep 'successfully authenticated'
		then
			export current_gitBest_source_GitHub="github_ssh"
			return
		fi
		_safeEcho_newline "$currentSSHoutput"
		
		# Exceptionally rare cases of 'github.com' accessed from within GitHub Actions runner (most surprisingly) not responding have apparently happened.
		local currentIteration
		for currentIteration in $(seq 1 2)
		do
			#if _checkPort github.com 443
			if wget -qO- https://github.com > /dev/null
			then
				export current_gitBest_source_GitHub="github_https"
				return
			fi
		done
		
		
		[[ "$current_gitBest_source_GitHub" == "" ]] && export current_gitBest_source_GitHub="FAIL"
		return 1
	fi
	return 0
}
_gitBest_detect_github_sequence() {
	_gitBest_detect_github_procedure "$@"
	_messagePlain_probe_var current_gitBest_source_GitHub
	echo "$current_gitBest_source_GitHub"
}
_gitBest_detect_github() {
	local currentOutput
	currentOutput=$("$scriptAbsoluteLocation" _gitBest_detect_github_sequence "$@")
	_safeEcho_newline "$currentOutput"
	export current_gitBest_source_GitHub=$(_safeEcho_newline "$currentOutput" | tail -n 1)
	[[ "$current_gitBest_source_GitHub" != "github_"* ]] && export current_gitBest_source_GitHub="FAIL"
	
	return 0
}
_gitBest_detect() {
	_gitBest_detect_github "$@"
}



_gitBest_override_config_insteadOf-core() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335/"$1".git git@github.com:mirage335/"$1"
}
_gitBest_override_config_insteadOf-core--colossus() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335-colossus/"$1".git git@github.com:mirage335-colossus/"$1"
}
_gitBest_override_config_insteadOf-core--gizmos() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335-gizmos/"$1".git git@github.com:mirage335-gizmos/"$1"
}
_gitBest_override_config_insteadOf-core--distllc() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:soaringDistributions/"$1".git git@github.com:soaringDistributions/"$1"
}


_gitBest_override_github-github_core() {
	_gitBest_override_config_insteadOf-core--colossus ubiquitous_bash
	_gitBest_override_config_insteadOf-core--colossus extendedInterface

	_gitBest_override_config_insteadOf-core--gizmos flightDeck
	_gitBest_override_config_insteadOf-core--gizmos kinematicBase-large

	_gitBest_override_config_insteadOf-core--distllc ubDistBuild
	_gitBest_override_config_insteadOf-core--distllc ubDistFetch
	
	_gitBest_override_config_insteadOf-core mirage335_documents
	_gitBest_override_config_insteadOf-core mirage335GizmoScience

	_gitBest_override_config_insteadOf-core scriptedIllustrator
	_gitBest_override_config_insteadOf-core arduinoUbiquitous
	
	_gitBest_override_config_insteadOf-core BOM_designer
	_gitBest_override_config_insteadOf-core CoreAutoSSH
	_gitBest_override_config_insteadOf-core coreoracle
	_gitBest_override_config_insteadOf-core flipKey
	_gitBest_override_config_insteadOf-core freecad-assembly2
	_gitBest_override_config_insteadOf-core Freerouting
	_gitBest_override_config_insteadOf-core gEDA_designer
	_gitBest_override_config_insteadOf-core metaBus
	_gitBest_override_config_insteadOf-core PanelBoard
	_gitBest_override_config_insteadOf-core PatchRap
	_gitBest_override_config_insteadOf-core PatchRap_LulzBot
	_gitBest_override_config_insteadOf-core PatchRap_to_CNC
	_gitBest_override_config_insteadOf-core pcb-ioAutorouter
	_gitBest_override_config_insteadOf-core RigidTable
	_gitBest_override_config_insteadOf-core SigBlockly-mod
	_gitBest_override_config_insteadOf-core stepperTester
	_gitBest_override_config_insteadOf-core TazIntermediate
	_gitBest_override_config_insteadOf-core translate2geda
	_gitBest_override_config_insteadOf-core webClient
	_gitBest_override_config_insteadOf-core zipTiePanel
}
_gitBest_override_github-github_https() {
	# && [[ "$1" == "push" ]]
	if [[ "$INPUT_GITHUB_TOKEN" == "" ]]
	then
		git config --global url."https://github.com/".insteadOf git@github.com:
	elif [[ "$INPUT_GITHUB_TOKEN" != "" ]]
	then
		git config --global url."https://""$INPUT_GITHUB_TOKEN""@github.com/".insteadOf git@github.com:
	fi
}



_gitBest_override_github() {
	_messagePlain_nominal 'init: _gitBest_override_github'
	
	cat "$realHome"/.gitconfig >> "$HOME"/.gitconfig
	
	if [[ "$current_gitBest_source_GitHub" == "github_core" ]]
	then
		_gitBest_override_github-github_core
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "github_https" ]]
	then
		_gitBest_override_github-github_https "$@"
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "github_ssh" ]]
	then
		_messagePlain_good 'good: preferred: github_ssh'
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "FAIL" ]]
	then
		_messageError 'FAIL: missing: GitHub'
		_stop 1
	fi
	return 0
}








_gitBest_sequence() {
	_messagePlain_nominal 'init: _gitBest_sequence'
	
	_start scriptLocal_mkdir_disable
	
	export realHome="$HOME"
	export HOME="$safeTmp"/special_fakeHome
	mkdir -p "$HOME"
	
	_messagePlain_probe_var current_gitBest_source_GitHub
	_messagePlain_probe_var HOME
	
	
	_gitBest_override_github "$@"
	
	if ! [[ -e "$HOME"/.gitconfig ]]
	then
		_messagePlain_good 'good: write: overrides: none'
	else
		echo
		echo
		cat "$HOME"/.gitconfig
		echo
		echo
	fi
	
	
	_messagePlain_nominal 'init: git'
	
	local currentExitStatus
	git "$@"
	currentExitStatus="$?"


	export HOME="$realHome"
	if _if_cygwin
	then
		if [ "$1" = "clone" ]
		then
			_messagePlain_nominal 'init: git safe directory'

			# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-12  (partially)
			local currentDirectory
			local currentURL
			local currentArg=""
			local currentArg_previous=""
			for currentArg in "$@"
			do
				# Ignore parameters:
				#  begins with "-" dash
				#  preceeded by parameter taking an argument, but no argument or "="
				if [[ "$currentArg" != -* ]] && [[ "$currentArg" != "clone" ]] && [[ "$currentArg_previous" != "--template" ]] && [[ "$currentArg_previous" != "-o" ]] && [[ "$currentArg_previous" != "-b" ]] && [[ "$currentArg_previous" != "-u" ]] && [[ "$currentArg_previous" != "--reference" ]] && [[ "$currentArg_previous" != "--separate-git-dir" ]] && [[ "$currentArg_previous" != "--depth" ]] && [[ "$currentArg_previous" != "--jobs" ]] && [[ "$currentArg_previous" != "--filter" ]]
				then
					currentURL="$currentArg"
					echo "$currentURL"
					#break

					[[ -e "$currentArg" ]] && currentDirectory="$currentArg"
				fi
				currentArg_previous="$currentArg"
			done
		fi
		
		[[ "$currentDirectory" == "" ]] && [[ "$currentURL" != "" ]] && currentDirectory=$(basename --suffix=".git" "$currentURL")
		
		if [[ -e "$currentDirectory" ]]
		then
			_messagePlain_probe 'exists: '"$currentDirectory"
			if type _write_configure_git_safe_directory_if_admin_owned > /dev/null 2>&1
			then
				currentDirectory=$(_getAbsoluteLocation "$currentDirectory")
				_write_configure_git_safe_directory_if_admin_owned "$currentDirectory"
			fi
		fi
	fi
	
	_stop "$currentExitStatus"
}

_gitBest() {
	_messageNormal 'init: _gitBest'
	
	_gitBest_detect "$@"
	
	"$scriptAbsoluteLocation" _gitBest_sequence "$@"
}


_test_gitBest() {
	_wantGetDep stty
	_wantGetDep ssh
	
	_wantGetDep git
	
	#_wantGetDep nmap
	#_wantGetDep curl
	#_wantGetDep wget
}






# CAUTION: This file is very necessarily part of 'rotten' . Do NOT move functions or rename to other files without updating the build shellcode for 'rotten' !

# Refactored from code which was very robust with fast ISP, however often failed with slower ISP, as explained by ChatGPT due to AWS S3 temporary link expiration.
# See "_ref/wget_githubRelease_internal-OBSOLETE.sh" for original code, which due to the more iterative development process at the time, may be more reliable in untested cases.

# WARNING: May be untested.

# CAUTION: WARNING: Unusually, inheritance of local variables in procedure functions is relied upon. Theoretically, this has been long tested by 'ubiquitous_bash.sh _test' .
#"$api_address_type"
#"$currentStream"
#"$currentAxelTmpFileRelative" "$currentAxelTmpFile"
#
#"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile"
#"$currentOutFile"

# WARNING: CAUTION: Many functions rely on emitting to standard output . Experiment/diagnose by copying code to override with 'ops.sh' . CAUTION: Be very careful enabling or using diagnostic output to stderr, as stderr may also be redirected by calling functions, terminal may not be present, etc.
#( echo x >&2 ) > /dev/null
#_messagePlain_probe_var page >&2 | cat /dev/null
#_messagePlain_probe_safe "current_API_page_URL= ""$current_API_page_URL" >&2 | cat /dev/null
# WARNING: Limit stderr pollution for log (including CI logs) and terminal readability , using 'tail' .
#( cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | tail -n 10
#( set -o pipefail ; false | cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | cat > /dev/null
#( set -o pipefail ; false 2> >(tail -n 10 >&2) | cat > /dev/null )

# DANGER: Use _messagePlain_probe_safe , _safeEcho , _safeEcho_newline , etc .

# CAUTION: ATTENTION: Uncommented lines add to ALL 'compiled' bash shell scripts - INCLUDING rotten_compressed.sh !
# Thus, it may be preferable to keep example code as a separate line commented at the beginning of that line, rather than a comment character after code on the same line .





# ATTENTION: 'MANDATORY_HASH == true' claim requirement can be imposed without any important effect on reliability or performance.
# In practice, such multi-part-per-file download programs as 'aria2c' may or may not have any worse integrity safety concerns than other download programs.
# NOTICE: Track record from historically imposing MANDATORY_HASH has been long enough to establish excellent confidence for imposing the requirement for this safety claim again without serious issue if necessary.
# https://www.cvedetails.com/vulnerability-list/vendor_id-12682/Haxx.html
#  'Haxx'
# https://www.cvedetails.com/vulnerability-list/vendor_id-3385/Wget.html
# https://www.cvedetails.com/vulnerability-list/vendor_id-19755/product_id-53327/Aria2-Project-Aria2.html
# https://www.cvedetails.com/vulnerability-list/vendor_id-2842/Axel.html
# ATTENTION: DANGER: Client downloading function explicitly sets 'MANDATORY_HASH == true' to claim resulting file EITHER will be checked by external hash before production use OR file is downloaded within an internal safer network (ie. GitHub Actions) using integrity guarded computers (ie. GitHub Runners). Potentially less integrity-safe downloading as multi-part-per-file parallel 'axel' 'download accelerator' style downloading can be limited to require a safety check for the MANDATORY_HASH claim.
# NOTICE: Imposing safety check for MANDATORY_HASH claim has long track record and no known use cases combine BOTH the jittery contentious internet connections over which multi-part-per-file downloading may or may not be more reliable, AND cannot test build steps without download large files to cycle the entire build completely. That is to say, ONLY CI environments would be usefully faster from not requiring a MANDATORY_HASH claim, yet CI environments can already make an integrity claim relevant for MANDATORY_HASH, and CI environments usually have high-quality internet connections not needing complex trickery to improve download reliability/speed.
#[[ "$FORCE_AXEL" != "" ]] && ( [[ "$MANDATORY_HASH" == "true" ]] )



#export FORCE_DIRECT="true"
#export FORCE_WGET="true"
#export FORCE_AXEL="4"

# Actually buffers files in progress behind completed files, in addition to downloading over multiple connections. Streaming without buffer underrun (ie. directly to packetDisc, ie. directly to optical disc) regardless of internet connection quality may require such buffer.
#export FORCE_PARALLEL="3"

# Already default. FORCE_BUFFER="true" implies FORCE_PARALLEL=3 or similar and sets FORCE_DIRECT="false". FORCE_BUFFER="false" implies and sets FORCE_DIRECT="true" .
#FORCE_BUFFER="true"

#export GH_TOKEN="..."





#_get_vmImg_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_beforeBoot_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist_beforeBoot.txt"


#_get_vmImg_ubDistBuild-live_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso"
#currentHash_bytes=$(_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt" | head -n 14 | tail -n 1 | sed 's/^.*count=$(bc <<< '"'"'//' | cut -f1 -d\  )
# write packetDisc (eg. '/dev/sr0', '/dev/dvd'*, '/dev/cdrom'*)
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n growisofs -speed=3 -dvd-compat -Z "$3"=/dev/stdin -use-the-force-luke=notray -use-the-force-luke=spare:min -use-the-force-luke=bufsize:128m
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_ubDistBuild-rootfs_sequence
#export MANDATORY_HASH="true"
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_rootfs.tar.flx" | lz4 -d -c > ./package_rootfs.tar
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"



#! "$scriptAbsoluteLocation" _wget_githubRelease_join "owner/repo" "internal" "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext"


#_wget_githubRelease_join "soaringDistributions/Llama-augment_bundle" "" "llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf"



#_wget_githubRelease-stdout
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join-stdout
#export MANDATORY_HASH="true"







#type -p gh > /dev/null 2>&1


#_wget_githubRelease_internal

#curl --no-progress-meter
#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10

## Use variables to construct the gh release download command
#local currentIteration
#currentIteration=0
#while ! [[ -e "$current_fileOut" ]] && [[ "$currentIteration" -lt 3 ]]
#do
	##gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@"
	#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10
	#! [[ -e "$current_fileOut" ]] && sleep 7
	#let currentIteration=currentIteration+1
#done
#[[ -e "$current_fileOut" ]]
#return "$?"



# ATTENTION: Override with 'ops.sh' or similar. Do NOT attempt to override with exported variables: do indeed override the function.

_set_wget_githubRelease() {
	export githubRelease_retriesMax=25
	export githubRelease_retriesWait=18
}
_set_wget_githubRelease

_set_wget_githubRelease-detect() {
	export githubRelease_retriesMax=2
	export githubRelease_retriesWait=4
}

_set_wget_githubRelease-detect-parallel() {
	export githubRelease_retriesMax=25
	export githubRelease_retriesWait=18
}

_set_curl_github_retry() {
	export curl_retries_args=( --retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600 )
}
#_set_wget_githubRelease
#unset curl_retries_args


_if_gh() {
	if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]]
	then
		( _messagePlain_probe '_if_gh: gh' >&2 ) > /dev/null
		return 0
	fi
	( _messagePlain_probe '_if_gh: NOT gh' >&2 ) > /dev/null
	return 1
}


#_wget_githubRelease-URL "owner/repo" "" "file.ext"
#_wget_githubRelease-URL "owner/repo" "latest" "file.ext"
#_wget_githubRelease-URL "owner/repo" "internal" "file.ext"
_wget_githubRelease-URL() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-URL' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-curl "$@"
		return
	fi
}
#_wget_githubRelease-URL "owner/repo" "file.ext"
_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}
#_wget_githubRelease-address "owner/repo" "" "file.ext"
#_wget_githubRelease-address "owner/repo" "latest" "file.ext"
#_wget_githubRelease-address "owner/repo" "internal" "file.ext"
_wget_githubRelease-address() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-address' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-address-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-address-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-address-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-address-curl "$@"
		return
	fi
}

#"$api_address_type" == "tagName" || "$api_address_type" == "url"
# ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
_jq_github_browser_download_address() {
	( _messagePlain_probe 'init: _jq_github_browser_download_address' >&2 ) > /dev/null
	local currentReleaseLabel="$2"
	local currentFile="$3"
	
	# 'latest'
	#  or alternatively (untested, apparently incompatible), for all tags from the 'currentData' regardless of 'currentReleaseLabel'
	if [[ "$currentReleaseLabel" == "latest" ]] || [[ "$currentReleaseLabel" == "" ]]
	then
		if [[ "$api_address_type" == "" ]] || [[ "$api_address_type" == "url" ]]
        then
            #jq -r ".assets[] | select(.name == "'"$currentFile"'") | .browser_download_url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.assets[] | select(.name == $filename) | .browser_download_url'
            return
        fi
		if [[ "$api_address_type" == "tagName" ]]
        then
            #jq -r ".tag_name"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.tag_name'
            return
        fi
		if [[ "$api_address_type" == "api_url" ]]
		then
			#jq -r ".assets[] | select(.name == "'"$currentFile"'") | .url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r '.assets[] | select(.name == $filename) | .url'
			return
		fi
	# eg. 'internal', 'build', etc
	else
		if [[ "$api_address_type" == "" ]] || [[ "$api_address_type" == "url" ]]
        then
            #jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .assets[] | select(.name == "'"$currentFile"'") | .browser_download_url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .assets[] | select(.name == $filename) | .browser_download_url'
            return
        fi
		if [[ "$api_address_type" == "tagName" ]]
        then
            #jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .tag_name"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .tag_name'
            return
        fi
		if [[ "$api_address_type" == "api_url" ]]
		then
			#jq -r "sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentReleaseLabel"'") | .assets[] | select(.name == "'"$currentFile"'") | .url"
			jq --arg filename "$currentFile" --arg releaseLabel "$currentReleaseLabel" -r 'sort_by(.published_at) | reverse | .[] | select(.name == $releaseLabel) | .assets[] | select(.name == $filename) | .url'
			return
		fi
	fi
}
_curl_githubAPI_releases_page() {
	( _messagePlain_nominal "$currentStream"'\/\/\/ init: _curl_githubAPI_releases_page' >&2 ) > /dev/null
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

	local currentPageNum="$4"
	[[ "$currentPageNum" == "" ]] && currentPageNum="1"
	_messagePlain_probe_var currentPageNum >&2 | cat /dev/null
	
	local current_API_page_URL
	current_API_page_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases?per_page=100&page=""$currentPageNum"
	[[ "$currentReleaseLabel" == "latest" ]] && current_API_page_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases""/latest"
	_messagePlain_probe_safe "current_API_page_URL= ""$current_API_page_URL" >&2 | cat /dev/null

	local current_curl_args
	current_curl_args=()
	[[ "$GH_TOKEN" != "" ]] && current_curl_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	#current_curl_args+=( -H "Accept: application/octet-stream" )
	current_curl_args+=( -S )
	current_curl_args+=( -s )

    local currentFailParam="$5"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"
	current_curl_args+=( "$currentFailParam" )
	shift ; shift ; shift ; shift ; shift
	# CAUTION: Discouraged unless proven necessary. Causes delays and latency beyond "$githubRelease_retriesWait"*"$githubRelease_retriesMax" , possibly exceeding prebuffering on a single error.
	#--retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600
	#_set_curl_github_retry
	#"${curl_retries_args[@]}"
	current_curl_args+=( "$@" )

	local currentPage
	currentPage=""

	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	( _messagePlain_probe '_curl_githubAPI_releases_page: IPv6 (false)' >&2 ) > /dev/null
	# ATTENTION: IPv6 is NOT offered by GitHub API, and so usually only wastes time at best.
	#currentPage=$(curl -6 "${current_curl_args[@]}" "$current_API_page_URL")
	false
	currentExitStatus_ipv6="$?"
	if [[ "$currentExitStatus_ipv6" != "0" ]]
	then
		( _messagePlain_probe '_curl_githubAPI_releases_page: IPv4' >&2 ) > /dev/null
		[[ "$currentPage" == "" ]] && currentPage=$(curl -4 "${current_curl_args[@]}" "$current_API_page_URL")
		currentExitStatus_ipv4="$?"
	fi
	
	_safeEcho_newline "$currentPage"

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_page' >&2 ) > /dev/null
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

	[[ "$currentPage" == "" ]] && return 1
	return 0
}
# WARNING: No production use. May be untested.
#  Rapidly skips part files which are not upstream, using only a single page from the GitHub API, saving time and API calls.
# Not guaranteed reliable. Structure of this non-essential function is provider-specific, code is written ad-hoc.
# Duplicates much code from other functions:
#  '_wget_githubRelease_procedure-address-curl'
#  '_wget_githubRelease_procedure-address_fromTag-curl'
#  '_wget_githubRelease-address-backend-curl'
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join-skip soaringDistributions/ubDistBuild spring package_image.tar.flx
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join-skip soaringDistributions/ubDistBuild latest package_image.tar.flx
_curl_githubAPI_releases_join-skip() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _curl_githubAPI_releases_join-skip' >&2 ) > /dev/null
	( _messagePlain_probe_safe _curl_githubAPI_releases_join-skip "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    [[ "$GH_TOKEN" != "" ]] && local api_address_type="api_url"
	[[ "$GH_TOKEN" == "" ]] && local api_address_type="url"

	local currentPartDownload
	currentPartDownload=""

	local currentExitStatus=1

	local currentIteration=0

	#[[ "$currentPartDownload" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentPartDownload=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _curl_githubAPI_releases_join-skip: _curl_githubAPI_releases_join_procedure-skip: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _curl_githubAPI_releases_join_procedure-skip >&2 ) > /dev/null
		currentPartDownload=$(_curl_githubAPI_releases_join_procedure-skip "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentPartDownload"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join_procedure-skip soaringDistributions/ubDistBuild spring package_image.tar.flx
#env maxCurrentPart=63 ./ubiquitous_bash.sh _curl_githubAPI_releases_join_procedure-skip soaringDistributions/ubDistBuild latest package_image.tar.flx
_curl_githubAPI_releases_join_procedure-skip() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0


	local currentPart
	local currentAddress


	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		local currentData
		local currentData_page
		
		#(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile")
		#return

		currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		currentExitStatus="$?"

		currentData="$currentData_page"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		#( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		#currentExitStatus_tmp="$?"

		# ###
		for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
		do
			currentAddress=$(set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile".part"$currentPart" | head -n 1)
			currentExitStatus_tmp="$?"

			[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"

			[[ "$currentAddress" != "" ]] && echo "$currentPart" && return 0
		done

		
		# ### ATTENTION: No part files found is not 'skip' but FAIL .
		[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null && return 1
		
		return 0
	else
		local currentData
		currentData=""
		
		local currentData_page
		currentData_page="doNotMatch"
		
		local currentIteration
		currentIteration=1
		
		# ATTRIBUTION-AI: Many-Chat 2025-03-23
		# Alternative detection of empty array, as suggested by AI LLM .
		#[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
		while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
		do
			currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
			currentExitStatus_tmp="$?"
			[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
			currentData="$currentData"'
'"$currentData_page"

            ( _messagePlain_probe "_wget_githubRelease_procedure-address-curl: ""$currentIteration" >&2 ) > /dev/null
            #( _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 >&2 ) > /dev/null
            [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

			let currentIteration=currentIteration+1
		done

		#( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		#currentExitStatus_tmp="$?"

		# ###
		for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
		do
			currentAddress=$( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile".part"$currentPart" | head -n 1 )
			currentExitStatus_tmp="$?"

			[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
			[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
			[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

			[[ "$currentAddress" != "" ]] && echo "$currentPart" && return 0
		done

		
		# ### ATTENTION: No part files found is not 'skip' but FAIL .
		[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_join-skip: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null && return 1
		
        return 0
	fi
}
_wget_githubRelease_procedure-address-curl() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0

	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		local currentData
		local currentData_page
		
		#(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile")
		#return

		currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		currentExitStatus="$?"

		currentData="$currentData_page"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		currentExitStatus_tmp="$?"

		[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"

		# ATTENTION: Part file does NOT exist upstream. Page did NOT match 'Not Found', page NOT empty, and data NOT empty, implying repo, releaseLabel , indeed EXISTS upstream.
		# Retries/wait must NOT continue in that case - calling function must detect and either fail or skip file on empty address if appropriate.
		#[[ "$(_safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 | wc -c )" -le 0 ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null  && return 1
		
		return 0
	else
		local currentData
		currentData=""
		
		local currentData_page
		currentData_page="doNotMatch"
		
		local currentIteration
		currentIteration=1
		
		# ATTRIBUTION-AI: Many-Chat 2025-03-23
		# Alternative detection of empty array, as suggested by AI LLM .
		#[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
		while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
		do
			currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
			currentExitStatus_tmp="$?"
			[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
			currentData="$currentData"'
'"$currentData_page"

            ( _messagePlain_probe "_wget_githubRelease_procedure-address-curl: ""$currentIteration" >&2 ) > /dev/null
            #( _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 >&2 ) > /dev/null
            [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

			let currentIteration=currentIteration+1
		done

		( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		currentExitStatus_tmp="$?"

		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: pipefail: _jq_github_browser_download_address: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: currentData' >&2 ) > /dev/null && return 1

		# ATTENTION: Part file does NOT exist upstream. Page did NOT match 'Not Found', page NOT empty, and data NOT empty, implying repo, releaseLabel , indeed EXISTS upstream.
		# Retries/wait must NOT continue in that case - calling function must detect and either fail or skip file on empty address if appropriate.
		#[[ "$(_safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 | wc -c )" -le 0 ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-curl: empty: _safeEcho_newline | _jq_github_browser_download_address' >&2 ) > /dev/null  && return 1
		
        return 0
	fi
}
_wget_githubRelease-address-backend-curl() {
	local currentAddress
	currentAddress=""

	local currentExitStatus=1

	local currentIteration=0

	#[[ "$currentAddress" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentAddress=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL-curl: _wget_githubRelease_procedure-address-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-address-curl >&2 ) > /dev/null
		currentAddress=$(_wget_githubRelease_procedure-address-curl "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-address-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-address-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="tagName"

    _wget_githubRelease-address-backend-curl "$@"
    return
}
_wget_githubRelease-URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}

# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-URL-curl() {
	_wget_githubRelease-skip-URL-curl "$@"
}

# WARNING: May be untested.
_wget_githubRelease-API_URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-API_URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-API_URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-API_URL-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}

# WARNING: May be untested.
# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-API_URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-API_URL-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

    #_wget_githubRelease-address-backend-curl "$@"
	currentAddress=$(_wget_githubRelease-address-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-API_URL-curl() {
	_wget_githubRelease-skip-API_URL-curl "$@"
}

_wget_githubRelease_procedure-address-gh-awk() {
	#( _messagePlain_probe 'init: _wget_githubRelease_procedure-address-gh-awk' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_procedure-address-gh-awk "$@" >&2 ) > /dev/null
    local currentReleaseLabel="$2"
    #( _messagePlain_probe_var currentReleaseLabel >&2 ) > /dev/null
    
    # WARNING: Use of complex 'awk' scripts historically has seemed less resilient, less portable, less reliable.
    # ATTRIBUTION-AI: ChatGPT o1 2025-01-22 , 2025-01-27 .
	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		#gh release list -L 1
		# In theory, simply accepting single line output from gh release list (ie. -L 1) should provide the same result (in case this awk script ever breaks).
		awk '
			# Skip a header line if it appears first:
			NR == 1 && $1 == "TITLE" && $2 == "TYPE" {
				# Just move on to the next line and do nothing else
				next
			}
			
			# The real match: find the line whose second column is "Latest"
			$2 == "Latest" {
				# Print the third column (TAG NAME) and exit
				print $3
				exit
			}
		'
	else
		awk -v label="$currentReleaseLabel" '
		# For each line where the first column equals the label we are looking for...
		$1 == label {
			# If the second column is one of the known “types,” shift fields left so
			# the *real* tag moves into $2. Repeat until no more known types remain.
			while ($2 == "Latest" || $2 == "draft" || $2 == "pre-release" || $2 == "prerelease") {
			for (i=2; i<NF; i++) {
				$i = $(i+1)
			}
			NF--
			}
			# At this point, $2 is guaranteed to be the actual tag.
			print $2
		}
		'
	fi
}
# Requires "$GH_TOKEN" .
_wget_githubRelease_procedure-address-gh() {
	( _messagePlain_nominal "$currentStream"'\/\/\/ init: _wget_githubRelease_procedure-address-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_procedure-address-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

    local currentTag

	local currentExitStatus=0
	local currentExitStatus_tmp=0

    local currentIteration
    currentIteration=1

    while [[ "$currentTag" == "" ]] && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
    do
        #currentTag=$(gh release list -L 100 -R "$currentAbsoluteRepo" | sed 's/Latest//' | grep '^'"$currentReleaseLabel" | awk '{ print $2 }' | head -n 1)
        
        currentTag=$(set -o pipefail ; gh release list -L $(( $currentIteration * 100 )) -R "$currentAbsoluteRepo" | _wget_githubRelease_procedure-address-gh-awk "" "$currentReleaseLabel" "" | head -n 1)    # or pick whichever match you want
        currentExitStatus_tmp="$?"
		[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
		
        let currentIteration++
    done

    _safeEcho_newline "$currentTag"
    #_safeEcho_newline "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTag""/""$currentFile"

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-gh: pipefail: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentTag" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address-gh: empty: currentTag' >&2 ) > /dev/null && return 1

    return 0
}
_wget_githubRelease-address-gh() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-address-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-address-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-address-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1

	#local currentURL
	#currentURL=""
	local currentTag
	currentTag=""

	local currentExitStatus=1

	local currentIteration=0

	#while ( [[ "$currentURL" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	while ( [[ "$currentTag" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		#currentURL=""
		currentTag=""

		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-address-gh: _wget_githubRelease_procedure-address-gh: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-address-gh >&2 ) > /dev/null
		#currentURL=$(_wget_githubRelease_procedure-address-gh "$@")
		currentTag=$(_wget_githubRelease_procedure-address-gh "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	#_safeEcho_newline "$currentURL"
	_safeEcho_newline "$currentTag"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-address-gh: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-URL-gh() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-URL-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

    local currentTag

	local currentExitStatus=1

	currentTag=$(_wget_githubRelease-address-gh "$@")
	currentExitStatus="$?"
	

	#echo "$currentTag"
    _safeEcho_newline "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTag""/""$currentFile"

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	[[ "$currentTag" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: empty: currentTag' >&2 ) > /dev/null && return 1
	
	return 0
}





# _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_download() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-curl .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _gh_download' >&2 ) > /dev/null
	
	! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentTagName="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFileParameter="$5"

	local currentOutFile="$currentFile"

	shift
	shift
	shift
	[[ "$currentOutParameter" == "--output" ]] && currentOutParameter="-O"
	[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFileParameter" && shift && shift

	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	# CAUTION: Assumed 'false' by 'rotten' !
	# (ie. 'rotten' does NOT support Cygwin/MSW)
	local currentOutFile_translated_cygwinMSW=""
	( _if_cygwin && type -p cygpath > /dev/null 2>&1 ) && ( [[ "$currentOutFile" != "" ]] && [[ "$currentOutFile" != "-" ]] ) && currentOutFile_translated_cygwinMSW=$(cygpath -w $(_getAbsoluteLocation "$currentOutFile"))

	local currentExitStatus=1

	local currentIteration
	currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _gh_download: gh release download: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		# CAUTION: Assumed 'false' by 'rotten' !
		# (ie. 'rotten' does NOT support Cygwin/MSW)
		if [[ "$currentOutFile_translated_cygwinMSW" != "" ]]
		then
			# WARNING: Apparently, 'gh release download' will throw an error with filename '/cygdrive'...'.m_axelTmp__'"$(_uid14)" .
			( _messagePlain_probe_safe gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile_translated_cygwinMSW" "$@" >&2 ) > /dev/null
			( set -o pipefail ; gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile_translated_cygwinMSW" "$@" 2> >(tail -n 30 >&2) )
			currentExitStatus="$?"
		else
			( _messagePlain_probe_safe gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile" "$@" >&2 ) > /dev/null
			( set -o pipefail ; gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" -O "$currentOutFile" "$@" 2> >(tail -n 30 >&2) )
			currentExitStatus="$?"
		fi

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_download: gh release download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}
#_gh_downloadURL "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTagName""/""$currentFile" "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_downloadURL() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _gh_downloadURL' >&2 ) > /dev/null
	
	! _if_gh && return 1

	# ATTRIBUTION-AI: ChatGPT GPT-4 2023-11-04 ... refactored 2025-01-22 ... .

	local currentURL="$1"
	local currentOutParameter="$2"
	local currentOutFileParameter="$3"

	[[ "$currentURL" == "" ]] && return 1

	# Use `sed` to extract the parts of the URL
	local currentAbsoluteRepo=$(echo "$currentURL" | sed -n 's|https://github.com/\([^/]*\)/\([^/]*\)/.*|\1/\2|p')
	[[ "$?" != "0" ]] && return 1
	local currentTagName=$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/\([^/]*\)/.*|\1|p')
	[[ "$?" != "0" ]] && return 1
	local currentFile=$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/[^/]*/\(.*\)|\1|p')
	[[ "$?" != "0" ]] && return 1

	local currentOutFile="$currentFile"

	shift
	[[ "$currentOutParameter" == "--output" ]] && currentOutParameter="-O"
	[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFileParameter" && shift && shift

	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile"
	##[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1
	#currentExitStatus=1

	#local currentIteration
	#currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	#while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	#do
		#if [[ "$currentIteration" != "0" ]]
		#then 
			#( _messagePlain_warn 'warn: BAD: RETRY: _gh_downloadURL: _gh_download: currentIteration != 0' >&2 ) > /dev/null
			#sleep "$githubRelease_retriesWait"
		#fi

		# CAUTION: Do NOT translate file parameter (ie. for Cygwin/MSW) for an underlying backend function (ie. '_gh_download') - that will be done by underlying backend function if at all. Similarly, also do NOT state '--clobber' or similar parameters to backend function.
		#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile"
		##[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"
		( _messagePlain_probe_safe _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@" >&2 ) > /dev/null
		_gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@"
		currentExitStatus="$?"

		#let currentIteration=currentIteration+1
	#done

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_downloadURL: _gh_download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}






#_wget_githubRelease-stdout

#_wget_githubRelease



_wget_githubRelease-stdout() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease-stdout' >&2 ) > /dev/null
	local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
	
	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	[[ "$FORCE_DIRECT" == "true" ]] && _wget_githubRelease_procedure-stdout "$@"

	# ATTENTION: /dev/null assures that stdout is not corrupted by any unexpected output that should have been sent to stderr
	[[ "$FORCE_DIRECT" != "true" ]] && _wget_githubRelease_procedure-stdout "$@" > /dev/null

	if ! [[ -e "$currentAxelTmpFile".PASS ]]
	then
		currentExitStatus=$(cat "$currentAxelTmpFile".FAIL)
		( [[ "$currentExitStatus" == "" ]] || [[ "$currentExitStatus" = "0" ]] || [[ "$currentExitStatus" = "0"* ]] ) && currentExitStatus=1
		#rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile".PASS
		#rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile".FAIL
		#rm -f "$currentAxelTmpFile" > /dev/null 2>&1
		_destroy_lock "$currentAxelTmpFile"
		return "$currentExitStatus"
		#return 1
	fi
	[[ "$FORCE_DIRECT" != "true" ]] && cat "$currentAxelTmpFile"
	#rm -f "$currentAxelTmpFile" > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile"
	#rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile".PASS
	#rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
	_destroy_lock "$currentAxelTmpFile".FAIL
	return 0
}
_wget_githubRelease_procedure-stdout() {
	( _messagePlain_probe_safe _wget_githubRelease_procedure-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	if [[ "$FORCE_DIRECT" == "true" ]]
	then
		_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O - "$@"
		currentExitStatus="$?"
		if [[ "$currentExitStatus" != "0" ]]
		then
			echo > "$currentAxelTmpFile".FAIL
			return "$currentExitStatus"
		fi
		echo > "$currentAxelTmpFile".PASS
		return 0
	fi

	_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
	currentExitStatus="$?"
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
		return "$currentExitStatus"
	fi
	echo > "$currentAxelTmpFile".PASS
	return 0
}





#! "$scriptAbsoluteLocation" _wget_githubRelease_join "owner/repo" "internal" "file.ext" -O "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext" -O "file.ext"
# ATTENTION: WARNING: Warn messages correspond to inability to assuredly, effectively, use GH_TOKEN .
_wget_githubRelease() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease "$@" >&2 ) > /dev/null

	_wget_githubRelease_procedure "$@"
}
_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}
_wget_githubRelease_procedure() {
	# ATTENTION: Distinction nominally between '_wget_githubRelease' and '_wget_githubRelease_procedure' should only be necessary if a while loop retries the procedure .
	# ATTENTION: Potentially more specialized logic within download procedures should remain delegated with the responsibility to attempt retries , for now.
	# NOTICE: Several functions should already have retry logic: '_gh_download' , '_gh_downloadURL' , '_wget_githubRelease-address' , '_wget_githubRelease_procedure-curl' , '_wget_githubRelease-URL-curl' , etc .
	#( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_procedure' >&2 ) > /dev/null
	#( _messagePlain_probe_safe _wget_githubRelease_procedure "$@" >&2 ) > /dev/null

    local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

    local currentExitStatus=1

    # Discouraged .
    if [[ "$FORCE_WGET" == "true" ]]
    then
		local currentURL_typeSelected=""
        _warn_githubRelease_FORCE_WGET
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-curl
		_wget_githubRelease_loop-curl
        return "$?"
    fi

	# Discouraged . Benefits of multi-part-per-file downloading are less essential given that files are split into <2GB chunks.
	if [[ "$FORCE_AXEL" != "" ]] # && [[ "$MANDATORY_HASH" == "true" ]]
    then
		local currentURL_typeSelected=""
        ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

		[[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL==true is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && return 1

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-axel
		_wget_githubRelease_loop-axel
        return "$?"
    fi

    if _if_gh
    then
        #_wget_githubRelease-address-gh
        local currentTag=$(_wget_githubRelease-address "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        ( _messagePlain_probe _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@" >&2 ) > /dev/null
        _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@"
        currentExitStatus="$?"

        [[ "$currentExitStatus" != "0" ]] && _bad_fail_githubRelease_currentExitStatus && return "$currentExitStatus"
        [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1
        return 0
    fi

    if ! _if_gh
    then
		local currentURL_typeSelected=""
        ( _messagePlain_warn 'warn: WARNING: FALLBACK: wget/curl' >&2 ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL_typeSelected="api_url" && currentURL=$(_wget_githubRelease-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL_typeSelected="url" && currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        #"$GH_TOKEN"
        #"$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentOutFile"
        #_wget_githubRelease_procedure-curl
		_wget_githubRelease_loop-curl
        return "$?"
    fi
    
    return 1
}
_wget_githubRelease_procedure-curl() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_procedure-curl' >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentURL= ""$currentURL" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutFile= ""$currentOutFile" >&2 ) > /dev/null

	# ATTENTION: Better if the loop does this only once. Resume may be possible.
	##[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	#[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

    local current_curl_args
	current_curl_args=()
	[[ "$GH_TOKEN" != "" ]] && current_curl_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	current_curl_args+=( -H "Accept: application/octet-stream" )
	current_curl_args+=( -S )
	current_curl_args+=( -s )
	#current_curl_args+=( --clobber )
	current_curl_args+=( --continue-at - )

    local currentFailParam="$1"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"
	current_curl_args+=( "$currentFailParam" )
	shift
	# ATTENTION: Usually '_wget_githubRelease_procedure-curl' is used ONLY through '_wget_githubRelease_loop-curl' - the total timeout is similar but the latency is much safer.
	# CAUTION: Discouraged unless proven necessary. Causes delays and latency beyond "$githubRelease_retriesWait"*"$githubRelease_retriesMax" , possibly exceeding prebuffering on a single error.
	#--retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600
	#_set_curl_github_retry
	#"${curl_retries_args[@]}"
	current_curl_args+=( "$@" )
	
	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	( _messagePlain_probe '_wget_githubRelease_procedure-curl: IPv6 (false)' >&2 ) > /dev/null
	# ATTENTION: IPv6 is NOT offered by GitHub API, and so usually only wastes time at best.
	#curl -6 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL"
	false
	# WARNING: May be untested.
	#( set -o pipefail ; curl -6 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL" 2> >(tail -n 30 >&2) )
	currentExitStatus_ipv6="$?"
	if [[ "$currentExitStatus_ipv6" != "0" ]]
	then
		( _messagePlain_probe '_wget_githubRelease_procedure-curl: IPv4' >&2 ) > /dev/null
		curl -4 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL"
		# WARNING: May be untested.
		#( set -o pipefail ; curl -4 "${current_curl_args[@]}" -L -o "$currentOutFile" "$currentURL" 2> >(tail -n 30 >&2) )
		currentExitStatus_ipv4="$?"
	fi

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		#( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-curl' >&2 ) > /dev/null
        _bad_fail_githubRelease_currentExitStatus
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

    [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1

    return 0
}
_wget_githubRelease_loop-curl() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-curl .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_loop-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_loop-curl "$@" >&2 ) > /dev/null

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease_procedure-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe_safe _wget_githubRelease_procedure-curl >&2 ) > /dev/null
		_wget_githubRelease_procedure-curl
		# WARNING: May be untested.
		#( set -o pipefail ; _wget_githubRelease_procedure-curl 2> >(tail -n 100 >&2) )
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_loop-curl: _wget_githubRelease_procedure-curl: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease_procedure-axel() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_procedure-axel' >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentURL= ""$currentURL" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutFile= ""$currentOutFile" >&2 ) > /dev/null

    # ATTENTION: Quirk of aria2c , default dir is "$PWD" , is prepended to absolute paths , and the resulting '//' does not direct the absolute path to root.
    local currentOutFile_relative=$(basename "$currentOutFile")
    local currentOutDir=$(_getAbsoluteFolder "$currentOutFile")
    ( _messagePlain_probe_safe "currentOutFile_relative= ""$currentOutFile_relative" >&2 ) > /dev/null
    ( _messagePlain_probe_safe "currentOutDir= ""$currentOutFile" >&2 ) > /dev/null

    ( _messagePlain_probe_safe "FORCE_AXEL= ""$FORCE_AXEL" >&2 ) > /dev/null

	# ATTENTION: Better if the loop does this only once. Resume may be possible.
	##[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	#[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	#aria2c --timeout=180 --max-tries=25 --retry-wait=15 "$@"
    ##_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" >&2
    ##_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
    ##messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" >&2
    ##_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
    local current_axel_args
	current_axel_args=()
	##[[ "$GH_TOKEN" != "" ]] && current_axel_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	[[ "$GH_TOKEN" != "" ]] && current_axel_args+=( --header="Authorization: token $GH_TOKEN" )
	current_axel_args+=( --header="Accept: application/octet-stream" )
	#current_axel_args+=( --quiet=true )
	#current_axel_args+=( --timeout=180 --max-tries=25 --retry-wait=15 )
    current_axel_args+=( --stderr=true --summary-interval=0 --console-log-level=error --async-dns=false )
    [[ "$FORCE_AXEL" != "" ]] && current_axel_args+=( -x "$FORCE_AXEL" )
	
	local currentExitStatus_ipv4=1
	local currentExitStatus_ipv6=1

	#( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv6' >&2 ) > /dev/null
	( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv6 (false)' >&2 ) > /dev/null
    #( _messagePlain_probe_safe aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" >&2 ) > /dev/null
	##aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL"
	## WARNING: May be untested.
	##( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
	#( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" > "$currentOutFile".log 2>&1 )
	#currentExitStatus_ipv6="$?"
	#( tail -n 40 "$currentOutFile".log >&2 )
	#rm -f "$currentOutFile".log > /dev/null 2>&1
	false
    if [[ "$currentExitStatus_ipv6" != "0" ]]
    then
        ( _messagePlain_probe '_wget_githubRelease_procedure-axel: IPv4' >&2 ) > /dev/null
        ( _messagePlain_probe_safe aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" >&2 ) > /dev/null
        #aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL"
        #( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
		( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" > "$currentOutFile".log 2>&1 )
        currentExitStatus_ipv4="$?"
		( tail -n 40 "$currentOutFile".log >&2 )
		rm -f "$currentOutFile".log > /dev/null 2>&1
    fi

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		#( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-axel' >&2 ) > /dev/null
        _bad_fail_githubRelease_currentExitStatus
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

    [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1

	# WARNING: Partial download is FAIL, but aria2c may set exit status '0' (ie. true). Return FALSE in this case.
	#if ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).aria2* > /dev/null 2>&1
	#if ls -1 "$currentAxelTmpFile".aria2* > /dev/null 2>&1
	#if ls -1 "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".aria2* > /dev/null 2>&1
	if ls -1 "$currentOutFile".aria2* > /dev/null 2>&1
	then
		return 1
	fi

	# Disabled (commented out). Contradictory state of PASS with part files remaining should terminate script with FAIL , _stop , exit , etc .
	# ie.
	##  _messagePlain_bad 'bad: FAIL: currentAxelTmpFile*: EXISTS !'
	##  _messageError 'FAIL'
	##_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).part*
	#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".part*
	##_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).aria2*
	#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".aria2*

    return 0
}
_wget_githubRelease_loop-axel() {
	# Similar retry logic for all similar functions: _gh_download , _wget_githubRelease_loop-axel .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_loop-axel' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_loop-axel "$@" >&2 ) > /dev/null

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease_procedure-axel: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe_safe _wget_githubRelease_procedure-axel >&2 ) > /dev/null
		_wget_githubRelease_procedure-axel
		# WARNING: May be untested.
		#( set -o pipefail ; _wget_githubRelease_procedure-axel 2> >(tail -n 100 >&2) )
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_loop-axel: _wget_githubRelease_procedure-axel: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}















_wget_githubRelease_join() {
    local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	if [[ "$currentOutParameter" == "-O" ]]
	then
		shift
		shift
	fi

	#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1
	[[ "$currentOutFile" != "-" ]] && _destroy_lock "$currentOutFile"


	# ATTENTION
	currentFile=$(basename "$currentFile")




	( _messagePlain_probe_safe _wget_githubRelease_join "$@" >&2 ) > /dev/null

	_messagePlain_probe_safe _wget_githubRelease_join-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$@" '>' "$currentOutFile" >&2
	_wget_githubRelease_join-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$@" > "$currentOutFile"

	[[ ! -e "$currentOutFile" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1

	return 0
}




_wget_githubRelease_join-stdout() {
	"$scriptAbsoluteLocation" _wget_githubRelease_join_sequence-stdout "$@"
}
_wget_githubRelease_join_sequence-stdout() {
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease_join-stdout' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_join-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			#echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


    _set_wget_githubRelease "$@"


    local currentPart
    local currentSkip
    local currentStream
	local currentStream_wait
	local currentBusyStatus

	# CAUTION: Any greater than 50 is not expected to serve any purpose, may exhaust expected API rate limits, may greatly delay download, and may disrupt subsequent API requests. Any less than 50 may fall below the ~100GB capacity that is both expected necessary for some complete toolchains and at the limit of ~100GB archival quality optical disc (ie. M-Disc) .
	#local maxCurrentPart=50

	# ATTENTION: Graceful degradation to a maximum part count of 49 can be achieved by reducing API calls using the _curl_githubAPI_releases_join-skip function. That single API call can get 100 results, leaving 49 unused API calls remaining to get API_URL addresses to download 49 parts. Files larger than ~200GB are likely rare, specialized.
	#local maxCurrentPart=98

	# ATTENTION: In practice, 128GB storage media - reputable brand BD-XL near-archival quality optical disc, SSDs, etc - is the maximum file size that is convenient.
	# '1997537280' bytes truncate/tail
	# https://en.wikipedia.org/wiki/Blu-ray
	#  '128,001,769,472' ... 'Bytes'
	# https://fy.chalmers.se/~appro/linux/DVD+RW/Blu-ray/
	#  'only inner spare area of 256MB'
	local maxCurrentPart=63


    local currentExitStatus=1



    (( [[ "$FORCE_BUFFER" == "true" ]] && [[ "$FORCE_DIRECT" == "true" ]] ) || ( [[ "$FORCE_BUFFER" == "false" ]] && [[ "$FORCE_DIRECT" == "false" ]] )) && ( _messagePlain_bad 'bad: fail: FORCE_BUFFER , FORCE_DIRECT: conflict' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1

	[[ "$FORCE_PARALLEL" == "1" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
	[[ "$FORCE_PARALLEL" == "0" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
    
    [[ "$FORCE_AXEL" != "" ]] && [[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1

    [[ "$FORCE_AXEL" != "" ]] && ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null



    _if_buffer() {
        if ( [[ "$FORCE_BUFFER" == "true" ]] || [[ "$FORCE_DIRECT" == "false" ]] ) || [[ "$FORCE_BUFFER" == "" ]]
        then
            true
            return
        else
            false
            return
        fi
        true
        return
    }


    
    # WARNING: FORCE_DIRECT="true" , "FORCE_BUFFER="false" very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
    if ! _if_buffer
    then
        #export FORCE_DIRECT="true"

        _set_wget_githubRelease-detect "$@"
        currentSkip="skip"

        currentStream="noBuf"
        #local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	    #local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

		maxCurrentPart=$(_curl_githubAPI_releases_join-skip "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

        currentPart=""
        for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
        do
            if [[ "$currentSkip" == "skip" ]]
            then
				# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
				#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				if [[ "$GH_TOKEN" != "" ]]
				then
					currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
					#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
					#[[ "$?" != "0" ]] && currentSkip="skip"
					[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
				else
					currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
					#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
					#[[ "$?" != "0" ]] && currentSkip="skip"
					[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
				fi
            fi
            
            [[ "$currentSkip" == "skip" ]] && continue

            
            if [[ "$currentExitStatus" == "0" ]] || [[ "$currentSkip" != "skip" ]]
            then
                _set_wget_githubRelease "$@"
                currentSkip="download"
            fi


            _wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart" -O - "$@"
            currentExitStatus="$?"
            #[[ "$currentExitStatus" != "0" ]] && break
        done

        return "$currentExitStatus"
    fi





	# ### ATTENTION: _if_buffer (IMPLICIT)

	# NOTICE: Parallel downloads may, if necessary, be adapted to first cache a list of addresses (ie. URLs) to download. API rate limits could then have as much time as possible to recover before subsequent commands (eg. analysis of builds). Such a cache must be filled with addresses BEFORE the download loop.
	#  However, at best, this can only be used with non-ephemeral 'browser_download_url' addresses .


	export currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"

	currentStream="$currentStream_min"


	currentPart="$maxCurrentPart"


	_set_wget_githubRelease-detect "$@"
	currentSkip="skip"

	maxCurrentPart=$(_curl_githubAPI_releases_join-skip "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")

	currentPart=""
	for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
	do
		if [[ "$currentSkip" == "skip" ]]
		then
			# ATTENTION: EXPERIMENT
			# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
			#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
			##currentSkip=$([[ "$currentPart" -gt "17" ]] && echo 'skip' ; true)
			if [[ "$GH_TOKEN" != "" ]]
			then
				currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
				#[[ "$?" != "0" ]] && currentSkip="skip"
				[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
			else
				currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
				#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
				#[[ "$?" != "0" ]] && currentSkip="skip"
				[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null
			fi
		fi
		
		[[ "$currentSkip" == "skip" ]] && continue


		#[[ "$currentExitStatus" == "0" ]] || 
		if [[ "$currentSkip" != "skip" ]]
		then
			_set_wget_githubRelease "$@"
			currentSkip="download"
			break
		fi
	done

	export currentSkipPart="$currentPart"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))

	"$scriptAbsoluteLocation" _wget_githubRelease_join_sequence-parallel "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" &


	# Prebuffer .
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  preBUFFER: WAIT  ...  currentPart='"$currentPart" >&2 ) > /dev/null
	if [[ "$currentPart" -ge "01" ]] && [[ "$currentStream_max" -ge "2" ]]
	then
		#currentStream="2"
		for currentStream in $(seq "$currentStream_min" "$currentStream_max" | sort -r)
		do
			( _messagePlain_probe 'prebuffer: currentStream= '"$currentStream" >&2 ) > /dev/null
			while ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
			do
				sleep 3
			done
		done
	fi
	currentStream="$currentStream_min"


	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  outputLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Stream must have written PASS/FAIL file .
		local currentDiagnosticIteration_outputLOOP_wait=0
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: WAIT:  P_A_S_S/F_A_I_L  ... currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
		do
			sleep 1

			let currentDiagnosticIteration_outputLOOP_wait=currentDiagnosticIteration_outputLOOP_wait+1
			if [[ "$currentDiagnosticIteration_outputLOOP_wait" -gt 15 ]]
			then
				currentDiagnosticIteration_outputLOOP_wait=0
				( _messagePlain_probe "diagnostic_outputLOOP_wait: pid: ""$!" >&2 ) > /dev/null
				# ATTRIBUTION-AI: ChatGPT 4.5-preview 2025-03-29
				#( echo "diagnostic_outputLOOP_wait: checking filenames exactly as seen by script: |$scriptAbsoluteFolder/$(_axelTmp).busy| and |$scriptAbsoluteFolder/$(_axelTmp).PASS|" >&2 ) > /dev/null
				#( ls -l "$scriptAbsoluteFolder"/$(_axelTmp).* >&2 )
				#stat "$scriptAbsoluteFolder"/$(_axelTmp).busy >&2 || ( echo 'diagnostic_outputLOOP_wait: '"stat busy - file truly doesn't exist at this name!" >&2 )
				#stat "$scriptAbsoluteFolder"/$(_axelTmp).PASS >&2 || ( echo 'diagnostic_outputLOOP_wait: '"stat PASS - file truly doesn't exist at this name!" >&2 )
			fi
		done
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: OUTPUT  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# ATTENTION: EXPERIMENT
		#status=none
		dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
		#cat "$scriptAbsoluteFolder"/$(_axelTmp)
		#dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M | pv --rate-limit 100M 2>/dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp)
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).busy

		#_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).*
		#_destroy_lock "$scriptAbsoluteFolder"/.m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID".*

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	true
}
_wget_githubRelease_join_sequence-parallel() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			#echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


	#export currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	#local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	# Due to parallelism , only API rate limits, NOT download speeds, are a concern with larger number of retries. 
	_set_wget_githubRelease "$@"
	#_set_wget_githubRelease-detect "$@"
	#_set_wget_githubRelease-detect-parallel "$@"
	local currentSkip="skip"
	
	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))
	
	currentStream="$currentStream_min"
	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  downloadLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Slot in use. Downloaded  "$scriptAbsoluteFolder"/$(_axelTmp)  file will be DELETED after use by calling process.
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: detect skip  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && _set_wget_githubRelease "$@" && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELAY: stagger, Inter-Process Communication, _stop  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# Staggered Delay.
		[[ "$currentPart" == "$currentSkipPart" ]] && sleep 2
		[[ "$currentPart" != "$currentSkipPart" ]] && sleep 6
		# Inter-Process Communication Delay.
		# Prevents new download from starting before previous download process has done  rm -f "$currentAxelTmpFile"*  .
		#  Beware that  rm  is inevitable or at least desirable - called by _stop() through trap, etc.
		sleep 7
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DOWNLOAD  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		export currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
		if ls -1 "$currentAxelTmpFile"* > /dev/null 2>&1
		then
			( _messagePlain_bad 'bad: FAIL: currentAxelTmpFile*: EXISTS !' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			_messageError 'FAIL' >&2
			exit 1
			return 1
		fi
		"$scriptAbsoluteLocation" _wget_githubRelease_procedure-join "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part$(printf "%02g" "$currentPart") &
		echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid

		# Stream must have written either in-progress download or PASS/FAIL file .
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 0.6
		done

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: DELETE' >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: DELETE ...  currentStream='"$currentStream" >&2 ) > /dev/null
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
		#rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: WAIT PID  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).pid ]] && _pauseForProcess $(cat "$scriptAbsoluteFolder"/$(_axelTmp).pid) > /dev/null
	done
	wait >&2

	true
}
_wget_githubRelease_procedure-join() {
	( _messagePlain_probe_safe _wget_githubRelease_procedure-join "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	echo -n > "$currentAxelTmpFile".busy

	# ATTENTION: EXPERIMENT
	_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
    #dd if=/dev/zero bs=1M count=1500 > "$currentAxelTmpFile"
	#echo "$currentFile" >> "$currentAxelTmpFile"
    #dd if=/dev/urandom bs=1M count=1500 | pv --rate-limit 300M 2>/dev/null > "$currentAxelTmpFile"
	currentExitStatus="$?"

	# Inter-Process Communication Delay
	# Essentially a 'minimum download time' .
	sleep 7

	[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo -n > "$currentAxelTmpFile"
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
	fi

    while [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
    do
        sleep 1
    done

	# WARNING: Already inevitable (due to _stop , etc).
    #[[ "$currentAxelTmpFile" != "" ]] && rm -f "$currentAxelTmpFile".*
	[[ "$currentAxelTmpFile" != "" ]] && _destroy_lock "$currentAxelTmpFile".*

    #unset currentAxelTmpFile

    [[ "$currentExitStatus" == "0" ]] && return 0
    return "$currentExitStatus"
}










_warn_githubRelease_FORCE_WGET() {
    ( _messagePlain_warn 'warn: WARNING: FORCE_WGET=true' >&2 ; echo 'FORCE_WGET is a workaround. Only expected FORCE_WGET uses: low RAM , cloud testing/diagnostics .' >&2  ) > /dev/null
    return 0
}
_bad_fail_githubRelease_currentExitStatus() {
    ( _messagePlain_bad 'fail: wget_githubRelease: currentExitStatus: '"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile" >&2 ) > /dev/null
    return 0
}
_bad_fail_githubRelease_missing() {
    ( _messagePlain_bad 'fail: wget_githubRelease: missing: '"$currentAbsoluteRepo"' '"$currentReleaseLabel"' '"$currentFile" >&2 ) > /dev/null
    return 0
}






_vector_wget_githubRelease-URL-gh() {
    local currentReleaseLabel="build"
    
    [[ $(
cat <<'CZXWXcRMTo8EmM8i4d' | _wget_githubRelease_procedure-address-gh-awk "" "$currentReleaseLabel" "" 2> /dev/null
TITLE  TYPE    TAG NAME             PUBLISHED        
build  Latest  build-1002-1  about 1 days ago
build          build-1001-1  about 2 days ago
CZXWXcRMTo8EmM8i4d
) == "build-1002-1
build-1001-1" ]] || ( _messagePlain_bad 'fail: bad: _wget_githubRelease_procedure-address-gh-awk' && _messageFAIL )

	return 0
}















# May transfer large files out of cloud CI services, or may copy files into cloud or CI services for installation.

_set_rclone_limited_file() {
	export rclone_limited_file="$scriptLocal"/rclone_limited/rclone.conf
	! [[ -e "$rclone_limited_file" ]] && export rclone_limited_file=/rclone.conf
}
_prepare_rclone_limited_file() {
	if type RCLONE_LIMITED_CONF_BASE64 > /dev/null 2>&1
	then
		export rclone_limited_conf_base64=$(RCLONE_LIMITED_CONF_BASE64)
	fi
	
	_set_rclone_limited_file
	if ! [[ -e "$rclone_limited_file" ]] && [[ "$rclone_limited_conf_base64" != "" ]]
	then
		if ! [[ -e /rclone.conf ]]
		then
			echo "$rclone_limited_conf_base64" | base64 -d | sudo -n tee /rclone.conf > /dev/null
		fi
		
		if ! [[ -e "$scriptLocal"/rclone_limited/rclone.conf ]]
		then
			mkdir -p "$scriptLocal"/rclone_limited
			echo "$rclone_limited_conf_base64" | base64 -d > "$scriptLocal"/rclone_limited/rclone.conf
		fi
	fi
	_set_rclone_limited_file
	if ! [[ -e "$rclone_limited_file" ]]
	then
		_messageError 'FAIL: missing: rclone_limited_file'
		_stop 1
	fi
	if ! [[ -s "$rclone_limited_file" ]]
	then
		_messageError 'FAIL: empty: rclone_limited_file'
		_stop 1
	fi
	return 0
}

_rclone_limited_sequence() {
	_prepare_rclone_limited_file
	
	export ub_function_override_rclone=''
	unset ub_function_override_rclone
	unset rclone
	env XDG_CONFIG_HOME="$scriptLocal"/rclone_limited rclone --config="$rclone_limited_file" "$@"
}

_rclone_limited() {
	"$scriptAbsoluteLocation" _rclone_limited_sequence "$@"
	[[ "$?" != "0" ]] && _stop 1
	return 0
}

_test_rclone_limited() {
	! _wantGetDep 'rclone' && echo 'missing: rclone'
	return 0
}



_importShortcuts() {
	_tryExec "_resetFakeHomeEnv"
	
	if ! [[ "$PATH" == *":""$HOME""/bin"* ]] && ! [[ "$PATH" == "$HOME""/bin"* ]] && [[ -e "$HOME"/bin ]] && [[ -d "$HOME"/bin ]]
	then
		#export PATH="$PATH":"$HOME"/bin
		
		# CAUTION: Dubious workaround to prevent '/usr/local/bin/ubiquitous_bash.sh' , or '/usr/local/bin' , from overriding later program versions in '~/bin' .
		if [[ $( ( export PATH="$PATH":"$HOME"/bin ; type -p ubiquitous_bash.sh ) ) == "/usr/local/bin/ubiquitous_bash.sh" ]]
		then
			export PATH="$HOME"/bin:"$PATH"
		else
			export PATH="$PATH":"$HOME"/bin
		fi
	fi
	
	_tryExec "_visualPrompt"
	
	_tryExec "_scopePrompt"
	
	return 0
}


# CAUTION: Compatibility with shells other than bash is apparently important .
# CAUTION: Compatibility with bash shell is important (eg. for '_dropBootdisc' ) .
_setupUbiquitous_accessories_here-plasma_hook() {
	cat << CZXWXcRMTo8EmM8i4d

# sourced by /usr/lib/x86_64-linux-gnu/libexec/plasma-sourceenv.sh

LANG=C
export LANG

CZXWXcRMTo8EmM8i4d

	_setupUbiquitous_accessories_here-nixenv-bashrc

	
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
Byte = bit * 8;

kilobit = kilo * bit;
megabit = mega * bit;
gigabit = giga * bit;
terabit = tera * bit;

kb = kilobit;
Kb = kilobit;
Mb = megabit;
Gb = gigabit;
Tb = terabit;

kiloByte = kilobit * Byte;
megaByte = megabit * Byte;
gigaByte = gigabit * Byte;
teraByte = terabit * Byte;

kilobyte = kilobit * Byte;
megabyte = megabit * Byte;
gigabyte = gigabit * Byte;
terabyte = terabit * Byte;

kB = kiloByte;
KB = kiloByte;
MB = megaByte;
GB = gigaByte;
TB = teraByte;


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

kibiByte = kibi * Byte;
mebiByte = mebi * Byte;
gibiByte = gibi * Byte;
tebiByte = tebi * Byte;

kibibyte = kibi * Byte;
mebibyte = mebi * Byte;
gibibyte = gibi * Byte;
tebibyte = tebi * Byte;

KiB = kibiByte;
MiB = mebiByte;
GiB = gibiByte;
TiB = tebiByte;



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

if [[ "\$PATH" != *'.ebcli-virtual-env/executables'* ]] && [[ -e "$HOME"/.ebcli-virtual-env/executables ]]
then
	# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
	export PATH="$HOME"/.ebcli-virtual-env/executables:"\$PATH"
fi


if [[ "\$PATH" != *'.gcloud/google-cloud-sdk'* ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc ]]
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
if os.path.exists(r"$ubcore_accessoriesFile_python"):
	import sys
	import os
	# https://stackoverflow.com/questions/2349991/how-to-import-other-python-files
	sys.path.append(os.path.abspath(r"$ubcoreDir_accessories_python"))
	from $ubcore_ubcorerc_pythonrc import *





import sys
# https://stackoverflow.com/questions/436198/what-is-an-alternative-to-execfile-in-python-3
if sys.hexversion > 0x03000000:
	exec(r'exec(open( r"$ubcore_accessoriesFile_python_ubhome" ).read() )')
else:
	execfile(r"$ubcore_accessoriesFile_python_ubhome")




CZXWXcRMTo8EmM8i4d
}



_setupUbiquitous_accessories_here-python_bashrc() {
	cat << CZXWXcRMTo8EmM8i4d

# Interactive bash shell will default to calling 'python3' while scripts invoking '#! /usr/bin/env python' or similar may still be given 'python2' equivalent.
[[ "\$_PATH_pythonDir" == "" ]] && alias python=python3

[[ "\$_PATH_pythonDir" == "" ]] && [[ "\$_PYTHONSTARTUP" == "" ]] && export PYTHONSTARTUP="$HOME"/.pythonrc

[[ "\$_PATH_pythonDir" != "" ]] && _set_msw_python_procedure

CZXWXcRMTo8EmM8i4d
}




_setupUbiquitous_accessories_here-nixenv-bashrc() {
	cat << CZXWXcRMTo8EmM8i4d

[[ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME"/.nix-profile/etc/profile.d/nix.sh

# WARNING: Binaries from Nix should not be prepended to Debian PATH, as they may be incompatible with other Debian software (eg. incorrect Python version).
# Scripts that need to rely preferentially on Nix binaries should detect this situation, defining and calling an appropriate wrapper function.
# CAUTION: SEVERE - Issue unresolved. PATH written out to log file matches ' [[ "\$PATH" == *"nix-profile/bin"* ]] ' when run through interactive shell, but, with the exact same PATH value, not when called through some script contexts (eg. 'plasma-workspace/env' ) . Yet grep does match .
#  Hidden or invalid characters in "\$PATH" would seem a sensible cause, but how grep would disregard this while bash would not, seems difficult to explain.
#  Expected cause is interpretation by a shell other than bash .
#   CAUTION: Compatability with shells other than bash may be important .
# CAUTION: Compatibility with bash shell is important (eg. for '_dropBootdisc' ) .
if echo "\$PATH" | grep 'nix-profile/bin' > /dev/null 2>&1 || [[ "\$PATH" == *"nix-profile/bin"* ]]
then
	PATH=\$(echo "\$PATH" | sed 's|:'"$HOME"'/.nix-profile/bin||g;s|'"$HOME"'/.nix-profile/bin:||g')
	export PATH
	PATH="\$PATH":"$HOME"/.nix-profile/bin
	export PATH
fi

CZXWXcRMTo8EmM8i4d
}









_setupUbiquitous_accessories_here-coreoracle_bashrc() {
	
	if _if_cygwin
	then
		cat << CZXWXcRMTo8EmM8i4d

if [[ -e /cygdrive/c/core/infrastructure/coreoracle ]]
then
	export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/coreoracle"
	. /cygdrive/c/core/infrastructure/coreoracle/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle-msw ]]
then
	export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/coreoracle-msw"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle-msw/_shortcuts-cygwin.sh
#elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle ]]
#then
	#export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/coreoracle"
	#. /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle/_shortcuts-cygwin.sh
fi


if [[ -e /cygdrive/c/core/infrastructure/quickWriter ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/quickWriter"
	. /cygdrive/c/core/infrastructure/quickWriter/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter-msw ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/quickWriter-msw"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter-msw/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/quickWriter"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter/_shortcuts-cygwin.sh
fi

CZXWXcRMTo8EmM8i4d
	else
		cat << CZXWXcRMTo8EmM8i4d

if type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1 && ! uname -a | grep -i cygwin > /dev/null 2>&1
then
	# Greater or equal, '_priority_critical_pid_root' .
	sudo -n renice -n -15 -p \$\$ > /dev/null 2>&1
	sudo -n ionice -c 2 -n 2 -p \$\$ > /dev/null 2>&1
fi



if [[ -e "$HOME"/core/infrastructure/coreoracle ]]
then
	export shortcutsPath_coreoracle="$HOME"/core/infrastructure/coreoracle/
	. "$HOME"/core/infrastructure/coreoracle/_shortcuts.sh
fi


if [[ -e "$HOME"/core/infrastructure/quickWriter ]]
then
	export shortcutsPath_quickWriter="$HOME"/core/infrastructure/quickWriter/
	. "$HOME"/core/infrastructure/quickWriter/_shortcuts.sh
fi



# Returns priority to normal.
# Greater or equal, '_priority_app_pid_root' .
#ionice -c 2 -n 3 -p \$\$
#renice -n -5 -p \$\$ > /dev/null 2>&1

# Returns priority to normal.
# Greater or equal, '_priority_app_pid' .
ionice -c 2 -n 4 -p \$\$
renice -n 0 -p \$\$ > /dev/null 2>&1


CZXWXcRMTo8EmM8i4d
	fi
}







_setupUbiquitous_accessories_here-user_bashrc() {
	
	# Calls   "$HOME"/_bashrc   as a place for user defined functions, environment varialbes, etc, which should NOT follow dist/OS updates (eg. extendedInterface reinstallation) and should be copied after dist/OS reinstallation (ie. placed on an SDCard or similar before '_revert-fromLive /dev/sda' .
	#  WARNING: Nevertheless, bashrc is very bad practice . Instead, functionality should be pushed upstream (eg. to 'ubiquitous bash', etc) .
	#   The exception may be very specialized infrastructure (ie. conveniently calling specialized Virtual Machines).
	
	cat << CZXWXcRMTo8EmM8i4d

if [[ -e "$HOME"/_bashrc ]]
then
	. "$HOME"/_bashrc
fi

CZXWXcRMTo8EmM8i4d

}

















_setupUbiquitous_accessories-plasma() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-plasma'
	
	mkdir -p "$HOME"/.config/plasma-workspace/env

	_setupUbiquitous_accessories_here-plasma_hook > "$HOME"/.config/plasma-workspace/env/profile.sh
	chmod u+x "$HOME"/.config/plasma-workspace/env/profile.sh
	
	
	return 0
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
	
	export ubcore_ubcorerc_pythonrc="ubcorerc_pythonrc"
	
	if ! grep ubcore "$ubHome"/.pythonrc > /dev/null 2>&1 && _messagePlain_probe 'pythonrc'
	then
		# https://www.mathworks.com/matlabcentral/answers/194868-what-about-the-character
		#echo '%# ubcore' >> "$ubHome"/.pythonrc
		#_safeEcho_newline run'("'"$ubcore_accessoriesFile_python_ubhome"'")' >> "$ubHome"/.pythonrc
		_setupUbiquitous_accessories_here-python_hook >> "$ubHome"/.pythonrc
	fi
	
	return 0
}



_setupUbiquitous_accessories-git() {
	git config --global checkout.workers -1
	
	git config --global pull.rebase false

	git config --global core.autocrlf input
	git config --global core.eol lf

	git config --global init.defaultBranch main
}




_setupUbiquitous_accessories() {

	_setupUbiquitous_accessories-plasma "$@"

	
	_setupUbiquitous_accessories-gnuoctave "$@"
	
	_setupUbiquitous_accessories-python "$@"

	_setupUbiquitous_accessories-git "$@"
	
	return 0
}

_setupUbiquitous_accessories_bashrc() {
	#_messagePlain_nominal 'init: _setupUbiquitous_accessories_bashrc'
	
	_setupUbiquitous_accessories_bashrc-cloud_bin "$@"
	
	_setupUbiquitous_accessories_here-nixenv-bashrc "$@"
	
	#echo true
	
	
	_setupUbiquitous_accessories_here-coreoracle_bashrc "$@"
	
	
	# WARNING: Python must remain last. Failure to hook python is a failure that must show as an error exit status from the users profile (a red "1" on the first line of first visual prompt command prompt).
	_setupUbiquitous_accessories_here-python_bashrc "$@"
	
	
	_setupUbiquitous_accessories_here-user_bashrc "$@"
	
	#echo true
}


_setupUbiquitous_accessories_requests() {
	
	# EXAMPLE .
	#_messagePlain_request 'request: request'
	
	return 0
}





_setupUbiquitous_safe_bashrc() {

cat << CZXWXcRMTo8EmM8i4d
#Generates semi-random alphanumeric characters, default length 18.
#_uid() {
	#local currentLengthUID
	#currentLengthUID="\$1"
	#[[ "\$currentLengthUID" == "" ]] && currentLengthUID=18
	#cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "\$currentLengthUID" 2> /dev/null
	#return
#}
_safe_declare_uid
CZXWXcRMTo8EmM8i4d

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

# WARNING: Do NOT use 'ubKeep_LANG' unless necessary!
# nix-shell --run "locale -a" -p bash
#  C   C.utf8   POSIX
[[ "\$ubKeep_LANG" != "true" ]] && [[ "\$LANG" != "C" ]] && export LANG="C"

# Not known or expected to cause significant issues. Not known to affect 'ubiquitous_bash' bash scripts, may affect the separate python 'lean.py' script.
if [[ "\$USER" == "" ]]
then
	[[ "\$UID" == "0" ]] && export USER="root"
	[[ "\$USER" == "" ]] && export USER=\$(id -u -n 2>/dev/null)
fi

CZXWXcRMTo8EmM8i4d


	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && cat << CZXWXcRMTo8EmM8i4d

[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && echo -n '_'

[[ "\$profileScriptLocation" == "" ]] && export profileScriptLocation_new='true'

#[[ -e "/etc/ssl/openssl_legacy.cnf" ]] && export OPENSSL_CONF="/etc/ssl/openssl_legacy.cnf"
[[ -e "/etc/ssl/openssl.cnf" ]] && export OPENSSL_CONF="/etc/ssl/openssl.cnf"

CZXWXcRMTo8EmM8i4d

	# WARNING: CAUTION: Precautionary. No known issues, may be unnecessary. Unusual.
	#However, theoretically nix package manager could otherwise override default programs (eg. python , gschem , pcb) before 'ubiquitous_bash' , causing severely incompatible shell environment configuration .
	_setupUbiquitous_accessories_here-nixenv-bashrc


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
[[ "\$ub_setScriptChecksum_disable" == 'true' ]] && export ub_setScriptChecksum_disable="" && unset ub_setScriptChecksum_disable

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

if [[ "\$HOME" == "/home/root" ]] && [[ ! -e /home/"\$USER" ]]
then
	ln -s --no-target-directory "/home/root" /home/"\$USER" > /dev/null 2>&1
fi

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
		
		# May have prevented issues from services (eg. ssh-pageant) that now do not continue to cause such issues, have been disabled, or have been removed, etc. Uncomment 'sleep 0.1' commands, replacing the other true/noop/sleep, if necessary or desired.
		#sleep 0.1
		true
		echo '_'
		#sleep 0.1
		true
		echo '_'
		#sleep 0.1
		true
		
		clear
	fi
fi

true

CZXWXcRMTo8EmM8i4d

}


_setupUbiquitous_bashProfile_here() {
	! uname -a | grep -i cygwin > /dev/null 2>&1 && cat << CZXWXcRMTo8EmM8i4d

if [[ -e "$HOME"/.bashrc ]] && [[ "\$ubiquitousBashID" == "" ]]
then
	source "$HOME"/.bashrc
fi

CZXWXcRMTo8EmM8i4d
}



_setupUbiquitous_resize() {
	echo "# Hardware serial terminals connected through screen require explicit resize to change number of columns/lines. Usually doing this once will at least increase the usable 'screen real estate' from the very small defaults."
	echo "# Ignored by Cygwin/MSW, etc."
	echo "type -p resize > /dev/null 2>&1 && resize > /dev/null 2>&1"
	echo "true"
	
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

_gitPull_ubiquitous() {
	#git pull
	_gitBest pull
}

_gitClone_ubiquitous() {
	#git clone --depth 1 git@github.com:mirage335/ubiquitous_bash.git
	_gitBest clone --recursive --depth 1 git@github.com:mirage335/ubiquitous_bash.git
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
	
	! cd "$ubcoreDir" && _messagePlain_bad 'bad: cd $ubcoreUBdir' && return 1
	
	! cd "$ubcoreUBdir" && _messagePlain_bad 'bad: cd $ubcoreUBdir' && return 1
	_messagePlain_nominal 'attempt: git pull: '"$PWD"
	if [[ "$nonet" != "true" ]] && type git > /dev/null 2>&1
	then
		_gitBest_detect
		
		# CAUTION: After calling 'ubcp-cygwin-portable-installer' during 'build_ubcp' job of GitHub Actions 'build.yml', or similar devops/CI, etc, '/home/root/.ubcore/ubiquitous_bash' is a subdirectory at 'C:\...\ubiquitous_bash\_local\ubcp\cygwin\home\root\.ubcore\ubiquitous_bash' or similar.
		#  DANGER: This causes MSWindows native 'git' binaries to perceive a git repository '.git' subdirectory already exists at the parent directory 'C:\...\ubiquitous_bash' , catastrophically causing 'git pull' to succeed, without populating the '/home/root/.ubcore/ubiquitous_bash' directory with 'ubiquitous_bash.sh' .
		# Preventing that scenario, detect whether a '.git' subdirectory exists at "$ubcoreUBdir"/.git , which should also be the same as './.git' .
		if [[ -e "$ubcoreUBdir"/.git ]] && [[ -e ./.git ]]
		then
			local ub_gitPullStatus
			#git pull
			_gitBest pull
			ub_gitPullStatus="$?"
			#[[ "$ub_gitPullStatus" != 0 ]] && git pull && ub_gitPullStatus="$?"
			if [[ "$ub_gitPullStatus" != 0 ]]
			then
				_gitBest pull
				ub_gitPullStatus="$?"
			fi
			! cd "$localFunctionEntryPWD" && return 1

		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: git pull' && cd "$localFunctionEntryPWD" && return 0
		fi
	fi
	_messagePlain_warn 'fail: git pull: '"$PWD"
	
	! cd "$ubcoreDir" && _messagePlain_bad 'bad: cd $ubcoreDir' && return 1
	_messagePlain_nominal 'attempt: git clone'
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ ! -e ".git" ]] && [[ ! -e "$ubcoreUBdir"/.git ]] && _gitClone_ubiquitous && _messagePlain_good 'pass: git clone' && return 0
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ ! -e ".git" ]] && [[ ! -e "$ubcoreUBdir"/.git ]] && _gitClone_ubiquitous && _messagePlain_good 'pass: git clone' && return 0
	_messagePlain_warn 'fail: git clone'
	
	cd "$ubcoreUBdir"
	_messagePlain_nominal 'attempt: self git pull'
	# WARNING: Not attempted if 'nonet' has been set 'true', due to possible conflicts with scripts intending only to copy one file (ie. by SSH transfer).
	if [[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ -e "$scriptAbsoluteFolder"/.git ]] && [[ -e "$scriptAbsoluteFolder"/.git ]]
	then
		
		local ub_gitPullStatus
		#git reset --hard
		[[ -e "$scriptAbsoluteFolder"/lean.sh ]] && rm -f "$ubcoreUBdir"/lean.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubcore.sh ]] && rm -f "$ubcoreUBdir"/ubcore.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubiquitous_bash.sh ]] && rm -f "$ubcoreUBdir"/ubiquitous_bash.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/lean_compressed.sh ]] && rm -f "$ubcoreUBdir"/lean_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/core_compressed.sh ]] && rm -f "$ubcoreUBdir"/core_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubcore_compressed.sh ]] && rm -f "$ubcoreUBdir"/ubcore_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubiquitous_bash_compressed.sh ]] && rm -f "$ubcoreUBdir"/ubiquitous_bash_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/lean.py ]] && rm -f "$ubcoreUBdir"/lean.py > /dev/null 2>&1
		#git reset --hard
		#git pull "$scriptAbsoluteFolder"
		_gitBest pull "$scriptAbsoluteFolder"
		_gitBest reset --hard
		ub_gitPullStatus="$?"
		! cd "$localFunctionEntryPWD" && return 1
		
		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: self git pull' && cd "$localFunctionEntryPWD" && return 0
	fi
	_messagePlain_warn 'fail: self git pull'
	
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
	export ub_under_setupUbiquitous="true"
	
	if _if_cygwin
	then
		echo 'detected: cygwin'
		_messagePlain_probe_cmd _setupUbiquitous_accessories-git
	fi
	
	_force_cygwin_symlinks
	_if_cygwin && _setup_ubiquitousBash_cygwin_procedure
	
	
	local ubHome
	ubHome="$HOME"
	[[ "$1" != "" ]] && ubHome="$1"
	
	export ubcoreDir="$ubHome"/.ubcore
	export ubcoreFile="$ubcoreDir"/.ubcorerc
	
	export ubcoreDir_accessories="$ubHome"/.ubcore/accessories
	export ubcoreDir_accessories_python="$ubcoreDir_accessories"/python
	
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
	rm -f "$ubHome"/bin/ubiquitous_bash.sh
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/ubiquitous_bash.sh
	rm -f "$ubHome"/bin/_winehere
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winehere
	rm -f "$ubHome"/bin/_winecfghere
	ln -sf "$ubcoreUBfile" "$ubHome"/bin/_winecfghere
	
	echo '#!/bin/bash
"$HOME"/bin/ubiquitous_bash.sh _vncf "$@"' > "$ubHome"/bin/vncf
	chmod u+x "$ubHome"/bin/vncf
	
	echo '#!/bin/bash
"$HOME"/bin/ubiquitous_bash.sh _sshf "$@"' > "$ubHome"/bin/sshf
	chmod u+x "$ubHome"/bin/vncf
	
	
	
	_setupUbiquitous_here > "$ubcoreFile"
	_setupUbiquitous_accessories_bashrc >> "$ubcoreFile"
	_setupUbiquitous_safe_bashrc >> "$ubcoreFile"
	! [[ -e "$ubcoreFile" ]] && _messagePlain_bad 'missing: ubcoreFile= '"$ubcoreFile" && _messageFAIL && return 1
	
	
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_probe "$ubcoreFile"' >> '"$ubHome"/.bashrc && echo ". ""$ubcoreFile" >> "$ubHome"/.bashrc
	! grep ubcore "$ubHome"/.bashrc > /dev/null 2>&1 && _messagePlain_bad 'missing: bashrc hook' && _messageFAIL && return 1
	
	
	if [[ ! -e "$HOME"/.bash_profile ]] || ! grep '\.bashrc' "$HOME"/.bash_profile > /dev/null 2>&1
	then
		_setupUbiquitous_bashProfile_here >> "$HOME"/.bash_profile
	fi
	
	_setupUbiquitous_resize >> "$ubcoreFile"
	
	
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
		echo 'konsole --workdir %d -e /bin/bash %f (open in graphical terminal emulator from file manager) (preferred)'
		echo "bash ('Advanced Options -> Run in terminal')"
	fi
	
	_messagePlain_request "Now import new functionality into current shell if not in current shell."
	if [[ "$profileScriptLocation" != "" ]] && [[ "$profileScriptFolder" != "" ]]
	then
		_messagePlain_request ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
	else
		_request_visualPrompt
	fi
	
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
	_start scriptLocal_mkdir_disable
	
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
	#cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_ubide
	
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
	
	
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_packetDriveDevice.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_packetDriveDevice_remove.bat
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
	rm -f "$HOME"/bin/"$1""$ub_anchor_suffix"
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
	
	[[ -e "$ubiquitousLibDir"/_anchor ]] && cp -a "$ubiquitousLibDir"/_anchor "$scriptAbsoluteFolder"/_anchor
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

	_tryExec "_anchor_special"
	
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
	#echo '@reboot '"$scriptAbsoluteLocation"' _unix_renice_execDaemon' | crontab -
	( crontab -l ; echo '@reboot '"$scriptAbsoluteLocation"' _unix_renice_execDaemon > /var/log/_unix_renice_execDaemon.log' ) | crontab -
	
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
	
	_priority_enumerate_pattern ^ksysguard$ >> "$processListFile"
	_priority_enumerate_pattern ^ksysguardd$ >> "$processListFile"
	_priority_enumerate_pattern ^top$ >> "$processListFile"
	_priority_enumerate_pattern ^iotop$ >> "$processListFile"
	_priority_enumerate_pattern ^latencytop$ >> "$processListFile"
	
	_priority_enumerate_pattern ^Xorg$ >> "$processListFile"
	_priority_enumerate_pattern ^modeset$ >> "$processListFile"
	
	_priority_enumerate_pattern ^smbd$ >> "$processListFile"
	_priority_enumerate_pattern ^nmbd$ >> "$processListFile"
	
	_priority_enumerate_pattern ^ssh$ >> "$processListFile"
	_priority_enumerate_pattern ^sshd$ >> "$processListFile"
	_priority_enumerate_pattern ^ssh-agent$ >> "$processListFile"
	
	_priority_enumerate_pattern ^sshfs$ >> "$processListFile"
	
	_priority_enumerate_pattern ^socat$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^cron$ >> "$processListFile"
	
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
	
	_priority_enumerate_pattern ^kwin$ >> "$processListFile"
	_priority_enumerate_pattern ^pager$ >> "$processListFile"
	
	_priority_enumerate_pattern ^pulseaudio$ >> "$processListFile"
	
	_priority_enumerate_pattern ^synergy$ >> "$processListFile"
	_priority_enumerate_pattern ^synergys$ >> "$processListFile"
	
	_priority_enumerate_pattern ^kactivitymanagerd$ >> "$processListFile"
	
	_priority_enumerate_pattern ^dbus >> "$processListFile"
	
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
	
	_priority_enumerate_pattern ^plasmashell$ >> "$processListFile"
	
	_priority_enumerate_pattern ^audacious$ >> "$processListFile"
	_priority_enumerate_pattern ^vlc$ >> "$processListFile"
	
	_priority_enumerate_pattern ^firefox$ >> "$processListFile"
	
	_priority_enumerate_pattern ^dolphin$ >> "$processListFile"
	
	_priority_enumerate_pattern ^kwrite$ >> "$processListFile"
	
	_priority_enumerate_pattern ^konsole$ >> "$processListFile"
	
	
	_priority_enumerate_pattern ^okular$ >> "$processListFile"
	
	_priority_enumerate_pattern ^xournal$ >> "$processListFile"
	
	_priority_enumerate_pattern ^soffice.bin$ >> "$processListFile"
	
	
	_priority_enumerate_pattern ^pavucontrol$ >> "$processListFile"
	
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
	
	_priority_enumerate_pattern ^packagekitd$ >> "$processListFile"
	
	_priority_enumerate_pattern ^apt-config$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^ModemManager$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^sddm$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^lpqd$ >> "$processListFile"
	#_priority_enumerate_pattern ^cupsd$ >> "$processListFile"
	#_priority_enumerate_pattern ^cups-browsed$ >> "$processListFile"
	
	_priority_enumerate_pattern ^akonadi >> "$processListFile"
	_priority_enumerate_pattern ^akonadi_indexing_agent$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^kdeconnectd$ >> "$processListFile"
	#_priority_enumerate_pattern ^kacceessibleapp$ >> "$processListFile"
	#_priority_enumerate_pattern ^kglobalaccel5$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^kded4$ >> "$processListFile"
	#_priority_enumerate_pattern ^ksmserver$ >> "$processListFile"
	
	_priority_enumerate_pattern ^sleep$ >> "$processListFile"
	
	_priority_enumerate_pattern ^exim4$ >> "$processListFile"
	_priority_enumerate_pattern ^apache2$ >> "$processListFile"
	_priority_enumerate_pattern ^mysqld$ >> "$processListFile"
	_priority_enumerate_pattern ^ntpd$ >> "$processListFile"
	#_priority_enumerate_pattern ^avahi-daemon$ >> "$processListFile"
	
	
	# WARNING: Probably unnecessary and counterproductive. May risk halting important compile jobs.
	#_priority_enumerate_pattern ^cc1$ >> "$processListFile"
	#_priority_enumerate_pattern ^cc1plus$ >> "$processListFile"
	
	#_priority_enumerate_pattern ^tar$ >> "$processListFile"
	#_priority_enumerate_pattern ^xz$ >> "$processListFile"
	#_priority_enumerate_pattern ^kcompactd0$ >> "$processListFile"
	
	
	local currentPID
	
	while read -r currentPID
	do
		_priority_idle_pid "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
}



# WARNING: End user function. Do NOT call within scripts.
# No production use.
# DANGER: Removes all 'service' files with the correct number of characters. In practice, no non-temporary service is known to meet this criteria.
_systemd_cleanup() {
	# DANGER: Obsolete, more likely to cause unintended deletion. Will be disabled eventually.
	sudo -n rm -f /etc/systemd/system/??????????????????.service
	
	# WARNING: Relies on a >72char filename.
	sudo -n rm -f /etc/systemd/system/????????????????????????????????????????????????????????????????????????.service
}

#####Basic Variable Management

#Reset prefixes.
export tmpPrefix=""
export tmpSelf=""

# ATTENTION: CAUTION: Should only be used by a single unusual Cygwin override. Must be reset if used for any other purpose.
#export descriptiveSelf=""


# ATTENTION: Set 'dumbpath_prefix' within functions, with '_prog/core.sh' , 'ops.sh' , or similar, etc.
# WARNING: Any prefix will break '8.3' compatibility (usually don't care, but could affect DosBox, etc).
unset dumbpath_prefix



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

if [[ "$scriptAbsoluteFolder" == '/cygdrive/'* ]] && [[ -e /cygdrive ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && [[ "$scriptAbsoluteFolder" != '/cygdrive/c'* ]] && [[ "$scriptAbsoluteFolder" != '/cygdrive/C'* ]]
then
	# ATTENTION: CAUTION: Unusual Cygwin override to accommodate MSW network drive ( at least when provided by '_userVBox' ) !
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

	#_override_msw_git
	type _override_msw_git_CEILING > /dev/null 2>&1 && _override_msw_git_CEILING
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]] && type _write_configure_git_safe_directory_if_admin_owned > /dev/null 2>&1
	#then
		_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
	#fi
elif uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
then
	if [[ "$tmpSelf" == "" ]]
	then
		export tmpWSL="$HOME"/.ubtmp
		[[ "$realHome" != "" ]] && export tmpWSL="$realHome"/.ubtmp
		[[ ! -e "$tmpWSL" ]] && mkdir -p "$tmpWSL"
		
		if [[ "$tmpWSL" != "" ]]
		then
			export descriptiveSelf="$sessionid"
			type md5sum > /dev/null 2>&1 && [[ "$scriptAbsoluteLocation" != '/bin/'* ]] && [[ "$scriptAbsoluteLocation" != '/usr/'* ]] && export descriptiveSelf=$(_getScriptAbsoluteLocation | md5sum | head -c 2)$(echo "$sessionid" | head -c 16)
			export tmpSelf="$tmpWSL"/"$descriptiveSelf"

			[[ "$descriptiveSelf" == "" ]] && export tmpSelf="$tmpWSL"/"$sessionid"
			true
		fi

		( [[ "$tmpSelf" == "" ]] || [[ "$tmpWSL" == "" ]] ) && export tmpSelf=/tmp/"$sessionid"
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

if type cygpath > /dev/null 2>&1
then
    export scriptAbsoluteLocation_msw=$(cygpath -w "$scriptAbsoluteLocation")
    export scriptAbsoluteFolder_msw=$(cygpath -w "$scriptAbsoluteFolder")

	export scriptLocal_msw=$(cygpath -w "$scriptLocal")
    export scriptLib_msw=$(cygpath -w "$scriptLib")
    
	export scriptCall_bash="$scriptAbsoluteFolder"'/_bash.bat'
    export scriptCall_bash_msw="$scriptAbsoluteFolder_msw"'\_bash.bat'
	export scriptCall_bin="$scriptAbsoluteFolder"/_bin.bat
    export scriptCall_bin_msw="$scriptAbsoluteFolder_msw"'\_bin.bat'
fi

#Essentially temporary tokens which may need to be reused.
# No, NOT AI tokens, predates widespread usage of that term.
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




#_set_GH_TOKEN() {
	#[[ "$GH_TOKEN" != "" ]] && export GH_TOKEN=$(_safeEcho "$GH_TOKEN" | tr -dc 'a-zA-Z0-9_')
	#[[ "$INPUT_GITHUB_TOKEN" != "" ]] && export INPUT_GITHUB_TOKEN=$(_safeEcho "$INPUT_GITHUB_TOKEN" | tr -dc 'a-zA-Z0-9_')
#}
#_set_GH_TOKEN



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
		# 'The way using `read -r -n1` for reading every character is wrong, it can't handle multi-byte characters.'
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
		_env_broadcastPipe_page find "$1" -mindepth 1 -maxdepth 1 -mmin -0.4 -type f -name '*-tick' -exec "$safeTmp"/broadcastPipe_page_read.sh '{}' \; 2> /dev/null | _broadcastPipe_page_write "" "$2" "$3" "$4" "$5" 2>/dev/null
		
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




# WARNING: Not a valid example of intended or otherwise correct usage.
# WARNING: Bus parameters are chosen to attempt synchronyous operation, which is usually highly undesirable!
# System latency and bandwidth indirectly measured by this test. Inability to triple buffer through the "$safeTmp" filesystem at expected rate (ie. ~15KiB/s) will return failure.
_test_broadcastPipe_page-stream_sequence() {
	_start
	
	#Benchmarked at >15KiB/s .
	export ub_force_limit_page_rate='true'
	local current_Service_MaxTime=975
	local current_Read_MaxTime=575
	local current_Write_MaxTime=4475
	local current_Write_MaxBytes=86400
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=288 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	
	#cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	#_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite
	#md5sum ./testfill ./rewrite
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}

# WARNING: Not a valid example of intended or otherwise correct usage.
# WARNING: Bus parameters are chosen to attempt synchronyous operation, which is usually highly undesirable!
_test_broadcastPipe_page-single_sequence() {
	_start
	
	#Benchmarked at >15KiB/s .
	export ub_force_limit_page_rate='true'
	local current_Service_MaxTime=975
	local current_Read_MaxTime=575
	local current_Write_MaxTime=4475
	local current_Write_MaxBytes=86400
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=288 > /dev/null 2>&1
	
	#>&2 echo "write"
	#_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	#_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	
	cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite
	#md5sum ./testfill ./rewrite
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}

_test_broadcastPipe_page() {
	_getDep md5sum
	_getDep sha512sum
	#_getDep pv
	
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_page-stream_sequence "$@" 2> /dev/null
	then
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_page-single_sequence "$@" 2> /dev/null
	then
		return 1
	fi
	return 0
}




# Under ideal conditions, small quantities of data may be continiously copied completely or identically (<10M).
_benchmark_broadcastPipe_page() {
	_start
	
	export ub_force_limit_page_rate='false'
	local current_Write_MaxBytes=864000
	
	
	_demand_broadcastPipe_page "$safeTmp"/inputBufferDir "$safeTmp"/outputBufferDir "$current_Service_MaxTime" "$current_Service_MaxBytes" "$current_Service_Write_MaxTime"
	
	#>&2 echo "read"
	"$scriptAbsoluteLocation" _page_read "$safeTmp"/outputBufferDir 'out-' "$current_Read_MaxTime" > "$safeTmp"/rewrite &
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1M count=4 > /dev/null 2>&1
	
	#>&2 echo "write"
	_timeout 150 cat "$safeTmp"/testfill | pv | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' "$current_Write_MaxTime" "$current_Write_MaxBytes"
	#_timeout 150 cat "$safeTmp"/testfill | _timeout 30 "$scriptAbsoluteLocation" _page_write "$safeTmp"/inputBufferDir 'testfill-' '$current_Write_MaxTime' '$current_Write_MaxBytes'
	
	#cat "$safeTmp"/testfill | _page_write_single "$safeTmp"/inputBufferDir 'testfill-' '$current_Write_MaxTime' '$current_Write_MaxBytes'
	#_sleep_spinlock
	
	_terminate_broadcastPipe_page "$safeTmp"/inputBufferDir
	
	(
	cd "$safeTmp"
	du -sh ./testfill ./rewrite
	md5sum ./testfill ./rewrite
	)
	
	#! [[ -s "$safeTmp"/testfill ]] && _stop 1
	#! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	#! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
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




_test_broadcastPipe_aggregatorStatic_sequence() {
	_start
	
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	
	# > /dev/null 2>&1
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir" > "$safeTmp"/log/demand.log
	
	
	
	
	
	
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	"$scriptAbsoluteLocation" _aggregator_read_procedure "$outputBufferDir" > "$safeTmp"/rewrite &
	#_reset_broadcastPipe_aggregatorStatic
	
	# WARNING: May be incompatible with '_timeout' .
	cat "$safeTmp"/testfill | "$scriptAbsoluteLocation" _aggregator_write_procedure "$inputBufferDir" &
	#_reset_broadcastPipe_aggregatorStatic
	
	
	_sleep_spinlock
	_skip_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	sleep 24
	_sleep_spinlock
	_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite
	#md5sum ./testfill ./rewrite
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	
	_stop
}


_test_broadcastPipe_aggregatorStatic_delayIPC__aggregatorStatic_converse() {
	true | _aggregatorStatic_converse "$1" "$2" > "$3"
}


_test_broadcastPipe_aggregatorStatic_delayIPC_sequence() {
	_start
	
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	
	# > /dev/null 2>&1
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir" > "$safeTmp"/log/demand.log
	_sleep_spinlock
	
	
	
	
	
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	"$scriptAbsoluteLocation" _aggregatorStatic_read "$outputBufferDir" "$inputBufferDir" > "$safeTmp"/rewrite &
	
	"$scriptAbsoluteLocation" _aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir" > "$safeTmp"/rewrite_converse &
 	"$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_delayIPC__aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir" "$safeTmp"/rewrite_converse_subprocess &
	
	#_reset_broadcastPipe_aggregatorStatic
	
	# WARNING: May be incompatible with '_timeout' .
	cat "$safeTmp"/testfill | "$scriptAbsoluteLocation" _aggregatorStatic_write "$inputBufferDir" "$outputBufferDir"
	#_reset_broadcastPipe_aggregatorStatic
	
	
	#_sleep_spinlock
	#_skip_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	sleep 18
	_sleep_spinlock
	
	sleep 24
	_sleep_spinlock
	
	_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#md5sum ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#)
	
	! [[ -s "$safeTmp"/testfill ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite ]] && _stop 1
	! [[ -s "$safeTmp"/rewrite_converse ]] && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite && _stop 1
	! diff "$safeTmp"/testfill "$safeTmp"/rewrite_converse && _stop 1
	
	_stop
}


_test_broadcastPipe_aggregatorStatic() {
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@" 2> /dev/null
	#if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@"
	then
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_delayIPC_sequence "$@" 2> /dev/null
	#if ! "$scriptAbsoluteLocation" _test_broadcastPipe_aggregatorStatic_sequence "$@"
	then
		return 1
	fi
	return 0
}


_benchmark_broadcastPipe_aggregatorStatic() {
	_start
	
	
	
	
	_stop
}


_aggregatorStatic_test_scope-konsole_tab-service() {
	_demand_broadcastPipe_aggregatorStatic "$inputBufferDir" "$outputBufferDir"
	while true
	do
		sleep 3
	done
}

_aggregatorStatic_test_scope-konsole_tab-dirLoop() {
	while true
	do
		echo '----------'
		clear
		ls -R
		sleep 0.1
	done
}



# ATTENTION: Experimental use intended. Provides a command line environment with temporary directories , functions , services , examples , etc .
# Requires 'scope' which is NOT usually pulled in as a dependency of 'queue' .
_aggregatorStatic_test_scope() {
	_start
	
	export inputBufferDir="$safeTmp"/_i
	export outputBufferDir="$safeTmp"/_o
	
	dd if=/dev/urandom of="$safeTmp"/testfill bs=1k count=2048 > /dev/null 2>&1
	
	
	
	
	# ATTENTION: EXAMPLE. Consider experimenting with these commands.
	
	#_aggregatorStatic_read "$outputBufferDir" "$inputBufferDir"
	
	#_aggregatorStatic_converse "$outputBufferDir" "$inputBufferDir"
 	
 	#echo test | _aggregatorStatic_write "$inputBufferDir" "$outputBufferDir"
 	
 	
 	#_terminate_broadcastPipe_aggregatorStatic "$inputBufferDir"
	
	
	
	
	cat << CZXWXcRMTo8EmM8i4d > "$safeTmp"/konsole_tabs
#title: true;; command:  "$scriptAbsoluteLocation" --devenv _true
title: _demand_broadcastPipe_aggregatorStatic;; command:  "$scriptAbsoluteLocation" --devenv _aggregatorStatic_test_scope-konsole_tab-service
title: dirLoop;; command:  "$scriptAbsoluteLocation" --devenv _aggregatorStatic_test_scope-konsole_tab-dirLoop
CZXWXcRMTo8EmM8i4d
	
	_scope_konsole "$safeTmp" --tabs-from-file "$safeTmp"/konsole_tabs
	
	#(
	#cd "$safeTmp"
	#du -sh ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#md5sum ./testfill ./rewrite ./rewrite_converse ./rewrite_converse_subprocess
	#)
	
	_stop
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
	grep '^ubdb_'"$ubiquitousBashID"'_'"$1" | _db_filter_characters
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











_test_queue() {
	_getDep md5sum
	_getDep sha512sum
	
	_getDep socat
}



# https://stackoverflow.com/questions/4774358/get-mtime-of-specific-file-using-bash
_test_selfTime_sequence() {
	_start scriptLocal_mkdir_disable
	
	local iterations
	
	local dateA
	local dateB
	local dateDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		! "$scriptAbsoluteLocation" _true && _messageFAIL && _stop 1
		"$scriptAbsoluteLocation" _false && _messageFAIL && _stop 1
		dateB=$(date +%s)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		#echo "$dateDelta"
		
		if [[ "$dateDelta" -lt 0 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt 14 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	_stop 0
}

_test_selfTime() {
	"$scriptAbsoluteLocation" _test_selfTime_sequence "$@"
}


_test_bashTime_sequence() {
	_start scriptLocal_mkdir_disable
	
	local iterations
	
	local dateA
	local dateB
	local dateDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		dateA=$(date +%s)
		! echo 'echo fake interactive' | bash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'false' | bash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		! echo 'echo fake interactive' | dash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		echo 'false' | dash -i > /dev/null 2>&1 && _messageFAIL && _stop 1
		dateB=$(date +%s)
		
		dateDelta=$(bc <<< "$dateB - $dateA")
		#echo "$dateDelta"
		
		if [[ "$dateDelta" -lt 0 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$dateDelta" -gt 14 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	_stop 0
}

_test_bashTime() {
	"$scriptAbsoluteLocation" _test_bashTime_sequence "$@"
}


# https://stackoverflow.com/questions/4774358/get-mtime-of-specific-file-using-bash
_test_filemtime_sequence() {
	_start scriptLocal_mkdir_disable
	
	local iterations
	
	local currentFileMtimeA
	local currentFileMtimeB
	local currentFileMtimeDelta
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		echo > "$safeTmp"/test_filemtime
		currentFileMtimeA=$(stat -c %Y "$safeTmp"/test_filemtime)
		sleep 2
		touch "$safeTmp"/test_filemtime
		currentFileMtimeB=$(stat -c %Y "$safeTmp"/test_filemtime)
		
		currentFileMtimeDelta=$(bc <<< "$currentFileMtimeB - $currentFileMtimeA")
		#echo "$currentFileMtimeDelta"
		
		if [[ "$currentFileMtimeDelta" -lt 1 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$currentFileMtimeDelta" -gt 12 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		echo > "$safeTmp"/test_filemtime
		currentFileMtimeA=$(stat -c %Y "$safeTmp"/test_filemtime)
		sleep 2
		echo 'x' >> "$safeTmp"/test_filemtime
		currentFileMtimeB=$(stat -c %Y "$safeTmp"/test_filemtime)
		
		currentFileMtimeDelta=$(bc <<< "$currentFileMtimeB - $currentFileMtimeA")
		#echo "$currentFileMtimeDelta"
		
		if [[ "$currentFileMtimeDelta" -lt 1 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		if [[ "$currentFileMtimeDelta" -gt 12 ]]
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	iterations=0
	while [[ "$iterations" -lt 3 ]]
	do
		if ! rm -f "$safeTmp"/test_filemtime
		then
			_messageFAIL
			_stop 1
		fi
		echo > "$safeTmp"/test_filemtime
		if ! find "$safeTmp"/ -type f -mmin 0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if ! find "$safeTmp"/ -type f -mmin -0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		sleep 16
		if find "$safeTmp"/ -type f -mmin 0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if find "$safeTmp"/ -type f -mmin -0.19 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		if ! find "$safeTmp"/ -type f -mmin 1 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if find "$safeTmp"/ -type f -mmin 2 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		if ! find "$safeTmp"/ -type f -mmin -1 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		if ! find "$safeTmp"/ -type f -mmin -2700 | grep test_filemtime > /dev/null 2>&1
		then
			_messageFAIL
			_stop 1
		fi
		
		let iterations="$iterations + 1"
	done
	
	
	_stop 0
}

_test_filemtime() {
	"$scriptAbsoluteLocation" _test_filemtime_sequence "$@"
}


_test_timeoutRead_slowByteRead() {
	while head --bytes=1
	do
		sleep 9
		#sleep 2
	done
}

_test_timeoutRead_multiByteRead() {
	#while head --bytes=3
	while dd bs="3" count=1 2>/dev/null
	do
		true
	done
}

_test_timeoutRead_bashRead() {
	# Inaccurate. Tests with random data ('/dev/urandom') seem to show errors.
	local currentString
	export IFS=
	export LANG=C
	export LC_ALL=C
	#LANG=C IFS= read -r -d '' -n 1 currentString
	while read -r -d '' -n 1 currentString
	do
		#[ "$currentString" ] && echo -n "$currentString" || echo
		[ "$currentString" ] && printf '%b' "$currentString" || echo
	done
}

_test_timeoutRead_read() {
	local currentIterations
	currentIterations=0
	while _timeout 0.1 cat 2>/dev/null && true | ( [[ "$currentIterations" -lt "$1" ]] )
	do
		true | (sleep 6 ; echo -n x)
		#true | (sleep 1 ; echo -n x)
		let currentIterations="$currentIterations"' + 1'
	done
}

_test_timeoutRead_procedure() {
	
	# Applying 'timeout' to 'echo' may have no effect (presumably due to immediately filling pipe buffer).
	# Applying 'timeout' to 'slowByteRead' should be able to limit the number of input characters. A 8s timeout at 3s/b read rate should apparently interrupt '12345' at '123'.
	# Applying timeout to '_test_timeoutRead_read' should immediately terminate all processes in the processing chain (presumably due to pipe close).
	
	#_timeout 75 echo '12345' | _timeout 26 _test_timeoutRead_slowByteRead | _timeout 75 _test_timeoutRead_multiByteRead | _timeout 75 _test_timeoutRead_bashRead | _timeout 75 _test_timeoutRead_read 6
	
	_timeout 75 echo '12345' | _timeout 75 _test_timeoutRead_multiByteRead | _timeout 26 _test_timeoutRead_slowByteRead | _timeout 75 _test_timeoutRead_bashRead | _timeout 75 _test_timeoutRead_read 6
	
	
	true
}

_test_timeoutRead() {
	#true | "$scriptAbsoluteLocation" _test_timeoutRead_procedure "$@" | cat
	#return 0
	
	local currentString
	currentString=$(true | "$scriptAbsoluteLocation" _test_timeoutRead_procedure "$@" | cat)
	#echo "$currentString"
	
	[[ "$currentString" == "" ]] && _stop 1
	[[ "$currentString" != "1xx2x3xxx" ]] && ! _if_cygwin && _stop 1
	[[ $(echo -n "$currentString" | wc -c) != '9' ]] && ! _if_cygwin && _stop 1
	
	_if_cygwin && [[ "$currentString" != "1x"* ]] && _stop 1
	_if_cygwin && [[ $(echo -n "$currentString" | wc -c) -lt '2' ]] && _stop 1
	
	return 0
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
	
	if [[ "$CI" != "" ]] && ! type chown > /dev/null 2>&1
	then
		chown() {
			true
		}
	fi
	
	if _if_cygwin
	then
		if ! chown "$USER":None "$abstractfs_root" > /dev/null 2>&1
		then
			! chown "$USER" "$abstractfs_root" && exit 1
		fi
	else
		if ! chown "$USER":"$USER" "$abstractfs_root" > /dev/null 2>&1
		then
			if [[ -e /sbin/chown ]]
			then
				! /sbin/chown "$USER" "$abstractfs_root" && exit 1
			else
				! /usr/bin/chown "$USER" "$abstractfs_root" && exit 1
			fi
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
			if [[ -e /sbin/chown ]]
			then
				! /sbin/chown "$USER" "$abstractfs_lock" && exit 1
			else
				! /usr/bin/chown "$USER" "$abstractfs_lock" && exit 1
			fi
		fi
	fi
}

_prepare() {
	
	! mkdir -p "$safeTmp" && exit 1
	
	! mkdir -p "$shortTmp" && exit 1
	
	! mkdir -p "$logTmp" && exit 1
	
	[[ "$*" != *scriptLocal_mkdir_disable* ]] && ! mkdir -p "$scriptLocal" && exit 1
	
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
	
	_prepare "$@"
	
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

	#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
	if [[ "$currentAxelTmpFile" != "" ]]
	then
		rm -f "$currentAxelTmpFile" > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp1.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp3.aria2 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4 > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4.st > /dev/null 2>&1
		#rm -f "$currentAxelTmpFile".tmp4.aria2 > /dev/null 2>&1
			
		rm -f "$currentAxelTmpFile"* > /dev/null 2>&1
	fi

	[[ -e "$scriptLocal"/python_msw.lock ]] && [[ $(head -c $(echo -n "$sessionid" | wc -c | tr -dc '0-9') "$scriptLocal"/python_msw.lock 2> /dev/null ) == "$sessionid" ]] && rm -f "$scriptLocal"/python_msw.lock > /dev/null 2>&1
	
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
_open_procedure() {
	mkdir -p "$scriptLocal"
	
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
	
	_open_procedure "$@"
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
_close_procedure() {
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
	
	_close_procedure "$@"
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


	_tryExec "_vector_wget_githubRelease-URL-gh"
	
	
	_tryExec "_vector_ollama"
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
	# && [[ "$testArgLength" != "" ]]
	if [[ "$testArgLength" -lt 131071 ]] && [[ "$testArgLength" != "-1" ]] && [[ "$testArgLength" != "undefined" ]]
	then

		# Typical Cygwin. Marginal result at best.
		[[ "$testArgLength" -ge 32000 ]] && uname -a | grep -i 'cygwin' > /dev/null 2>&1 && _messagePASS && return 0
		if _if_cygwin
		then
			# Fortunately, as of 2023-09-08 , from questions to the Cygwin mailing list, reportedly the undefined 'ARG_MAX' is a standards compliant delimiter of no limit except system resource limit.
			# Unfortunately, as of 2023-09-07 , apparently Cygwin has removed the 'ARG_MAX' definition from the provided 'getconf' .
			# Due to the narrower use case of Cygwin/MSW (as opposed to GNU/Linux) - not expecting to compile gEDA for Cygwin anytime soon - it will be more of a concern if other binaries in 'ubcp' cease to exist because newer versions of Cygwin packages upstream were failing to compile as a result. Hopefully, Cygwin itself has adequate testing to prevent release of such breakage.
			#echo "$testArgLength"
			return 0
		fi
		
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
	_start scriptLocal_mkdir_disable
	
	variableLocalTest_currentSubFunction() {
		if ! [[ "$currentSubFunctionTest" == "true" ]] || ! [[ $(echo "$currentSubFunctionTest") == "true" ]]
		then
			_stop 1
			return 1
		fi
		return 0
	}
	local currentSubFunctionTest
	currentSubFunctionTest='true'
	! variableLocalTest_currentSubFunction && _stop 1
	
	
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
	
	
	export currentGlobalSubshellTest="true"
	if [[ $( ( echo "$currentGlobalSubshellTest" ) ) != "true" ]]
	then
		_stop 1
	fi
	if [[ $( ( export currentGlobalSubshellTest="false" ; echo "$currentGlobalSubshellTest" ) ) != "false" ]]
	then
		_stop 1
	else
		true
	fi
	if [[ $( ( echo "$currentGlobalSubshellTest" ) ) != "true" ]]
	then
		_stop 1
	fi
	if [[ "$currentGlobalSubshellTest" != "true" ]]
	then
		_stop 1
	fi
	
	
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
	env -i sessionid="" "$currentBashBinLocation" --norc -c '[[ "$sessionid" != "" ]]' && _stop 1
	env -i "$currentBashBinLocation" --norc -c '[[ "$sessionid" != "" ]]' && _stop 1
	
	
	
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
	
	
	_currentFunctionDefinitionTest() { echo false; }
	true && _currentFunctionDefinitionTest() { echo true; }
	false && _currentFunctionDefinitionTest() { echo false; }
	[[ $(_currentFunctionDefinitionTest) != "true" ]] && _messageFAIL && _stop 1
	unset _currentFunctionDefinitionTest
	
	
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=1
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=2
	[[ "$doubleLocalDefinitionA" != "2" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=3
	[[ "$doubleLocalDefinitionA" != "3" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA
	doubleLocalDefinitionA=4
	[[ "$doubleLocalDefinitionA" != "4" ]] && _messageFAIL && _stop 1
	export doubleLocalDefinitionA=5
	[[ "$doubleLocalDefinitionA" != "5" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=6
	[[ "$doubleLocalDefinitionA" != "6" ]] && _messageFAIL && _stop 1
	doubleLocalDefinitionA=7
	[[ "$doubleLocalDefinitionA" != "7" ]] && _messageFAIL && _stop 1
	local doubleLocalDefinitionA=8
	[[ "$doubleLocalDefinitionA" != "8" ]] && _messageFAIL && _stop 1
	unset doubleLocalDefinitionA
	[[ "$doubleLocalDefinitionA" != "" ]] && _messageFAIL && _stop 1
	

	variableLocalTest_evalTest() { local currentVariableNum=1 ; eval local currentVariable_${currentVariableNum}_currentData=PASS ; ( eval "[[ \$currentVariable_${currentVariableNum}_currentData == PASS ]]" && eval "[[ \$currentVariable_${currentVariableNum}_currentData != '' ]]" && eval "echo \$currentVariable_${currentVariableNum}_currentData" ) ;} ; variableLocalTest_evalTest > /dev/null ; [[ $(variableLocalTest_evalTest) != "PASS" ]] && _messageFAIL && _stop 1

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
	eval "__$current_uid_1() { __$current_uid_2() { echo $ubiquitousBashID; }; }"
	
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
	
	#_stop 0
	#return 0
	true
}

_test_embed_sequence() {
	_start scriptLocal_mkdir_disable
	
	#echo $ub_import
	#echo $ub_import_param
	
	# CAUTION: Profoundly unexpected to have called '_test' or similar functions after importing into a current shell in any way.
	if ( [[ "$current_internal_CompressedScript" == "" ]] && [[ "$current_internal_CompressedScript_cksum" == "" ]] && [[ "$current_internal_CompressedScript_bytes" == "" ]] ) || ( ( [[ "$ub_import_param" != "--embed" ]] ) && [[ "$ub_import_param" != "--bypass" ]] && [[ "$ub_import_param" != "--call" ]] && [[ "$ub_import_param" != "--script" ]] && [[ "$ub_import_param" != "--compressed" ]] )
	then
		[[ "$ub_import" == 'true' ]] && _messageFAIL && _stop 1
		[[ "$ub_import" != '' ]] && _messageFAIL && _stop 1
		[[ "$ub_import_param" != '' ]] && _messageFAIL && _stop 1
	fi
	
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
	_start scriptLocal_mkdir_disable
	
	_test_parallelFifo_procedure "$@"
	
	_stop
}

_test_pipe_true() {
	true | tee /dev/null 2>&1
}

# Apparently, shell script functions and conditions default to pipefail or pipestatus, although "$scriptAbsoluteLocation" is able to use the exit status instead.
_test_pipe_false() {
	false | tee /dev/null 2>&1
}
_test_pipe_false_condition() {
	#false | tee /dev/null 2>&1 && return 0
	false | echo stuff | grep stuff > /dev/null 2>&1 && return 0
	return 1
}
_test_pipe_false_condition_special() {
	false | tee /dev/null
	[[ "$?" == "0" ]] && return 0
	return 1
}

# Expect return true (ie. 0).
_test_pipefail_forcePlus_true_sequence() {
	set +o pipefail
	true | tee /dev/null 2>&1
}
_test_pipefail_forcePlus_true() {
	"$scriptAbsoluteLocation" _test_pipefail_forcePlus_true_sequence "$@"
}

# Expect return true (ie. 0).
_test_pipefail_forcePlus_false_sequence() {
	set +o pipefail
	false | tee /dev/null 2>&1
}
_test_pipefail_forcePlus_false() {
	"$scriptAbsoluteLocation" _test_pipefail_forcePlus_false_sequence "$@"
}

# Expect return true (ie. 0).
_test_pipefail_forceMinus_true_sequence() {
	set -o pipefail
	true | tee /dev/null 2>&1
}
_test_pipefail_forceMinus_true() {
	"$scriptAbsoluteLocation" _test_pipefail_forceMinus_true_sequence "$@"
}

# Expect return false (ie. 1).
_test_pipefail_forceMinus_false_sequence() {
	set -o pipefail
	false | tee /dev/null 2>&1
}
_test_pipefail_forceMinus_false() {
	"$scriptAbsoluteLocation" _test_pipefail_forceMinus_false_sequence "$@"
}

# https://stackoverflow.com/questions/6871859/piping-command-output-to-tee-but-also-save-exit-code-of-command
_test_pipestatus_true() {
	true | tee /dev/null 2>&1
	return ${PIPESTATUS[0]}
}

_test_pipestatus_false() {
	false | tee /dev/null 2>&1
	return ${PIPESTATUS[0]}
}

# ATTENTION: NOTICE: Regard this as a relatively definitive specification of known bash pipe 'exit status', 'pipestatus', 'pipefail', defaults and inheritance.
# WARNING: If 'bash' software interpreter uses same code paths (eg. for shell functions and subshells) do not assume this will always remain the case. Test and consider specifically and explicitly.
_test_pipefail_sequence_sequence() {
	if ! _test_pipefail_forcePlus_true || ! _test_pipefail_forcePlus_false || ! _test_pipefail_forceMinus_true_sequence || _test_pipefail_forceMinus_false_sequence
	then
		echo 'fail: pipefail'
		_stop 1
		return 1
	fi
	
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	
	
	
	# ATTENTION: Apparently, "$scriptAbsoluteLocation" is able to correctly retrieve the expected (ie. 0, true) exit status of both '_test_pipe_true' and '_test_pipe_false', although calling these functions directly results in the unexpected use of pipestatus, pipefail, or similar, etc.
	# CAUTION: While such defaults may seem slightly undesirable for shell scripts, there may be some benefit to command prompt use (especailly when functions are called from an interactive shell through such as ubiquitous_bash.sh _true , etc), UNIX pipe input programs (eg. cat /file) rarely if ever fail when a grep match would occur, and best practice of using a condition (ie. [[ -e /file ]]) before such pipes already avoids severe issues in shell script usage.
	# CAUTION: Ensure all pipe exit status, pipe status, and pipe fail, default behavior remains *strictly* as-is.
	
	
	
	# ATTENTION: ! _test_pipe_false ... would return true if consistent with behavior when called by "$scriptAbsoluteLocation"
	_test_pipe_false
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false' && _stop 1 && return 1
	if _test_pipe_false
	then
		echo 'fail: _test_pipe_false'
		_stop 1
		return 1
	fi
	
	# ATTENTION: ! _test_pipe_false ... does return true if called by "$scriptAbsoluteLocation"
	! "$scriptAbsoluteLocation" _test_pipe_false
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false' && _stop 1 && return 1
	if ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false'
		_stop 1
		return 1
	fi
	
	_test_pipe_false_condition
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false_condition' && _stop 1 && return 1
	if _test_pipe_false_condition
	then
		echo 'fail: if: _test_pipe_false_condition'
		_stop 1
		return 1
	fi
	
	! "$scriptAbsoluteLocation" _test_pipe_false_condition
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false_condition' && _stop 1 && return 1
	if _test_pipe_false_condition
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false_condition'
		_stop 1
		return 1
	fi
	
	
	_test_pipe_false_condition_special
	[[ "$?" == "0" ]] && echo 'fail: _test_pipe_false_condition_special' && _stop 1 && return 1
	if _test_pipe_false_condition_special
	then
		echo 'fail: if: _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	! "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	[[ "$?" == "0" ]] && echo 'fail: ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special' && _stop 1 && return 1
	if ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	then
		echo 'fail: if: ! "$scriptAbsoluteLocation" _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	"$scriptAbsoluteLocation" _test_pipe_false_condition_special
	[[ "$?" != "0" ]] && echo 'fail: "$scriptAbsoluteLocation" _test_pipe_false_condition_special' && _stop 1 && return 1
	if "$scriptAbsoluteLocation" _test_pipe_false_condition_special
	then
		true
	else
		echo 'fail: if: "$scriptAbsoluteLocation" _test_pipe_false_condition_special'
		_stop 1
		return 1
	fi
	
	
	#! _test_pipe_true || ! _test_pipe_false || ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	#! _test_pipe_false
	if ! _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: value'
		_stop 1
		return 1
	fi
	
	set +o pipefail
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	if ( true | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: plus: subshell: true'
		_stop 1
		return 1
	fi
	if ( false | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: plus: subshell: false'
		_stop 1
		return 1
	fi
	if ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: pipefail: plus'
		_stop 1
		return 1
	fi
	
	set -o pipefail
	# NOTICE: Will FAIL if 'set -o pipefail' applies to script commands !
	if ! _test_pipestatus_true || _test_pipestatus_false || ! "$scriptAbsoluteLocation" _test_pipestatus_true || "$scriptAbsoluteLocation" _test_pipestatus_false
	then
		echo 'fail: pipestatus'
		_stop 1
		return 1
	fi
	if ( true | tee /dev/null 2>&1 )
	then
		true
	else
		echo 'fail: if: pipe: pipefail: minus: subshell: true'
		_stop 1
		return 1
	fi
	# ATTENTION: Seems this actually is sensitive to 'set -o pipefail' .
	if ( false | tee /dev/null 2>&1 )
	then
		echo 'fail: if: pipe: pipefail: minus: subshell: false'
		_stop 1
		return 1
	else
		true
	fi
	if ! "$scriptAbsoluteLocation" _test_pipe_true || ! "$scriptAbsoluteLocation" _test_pipe_false
	then
		echo 'fail: if: pipe: pipefail: minus'
		_stop 1
		return 1
	fi
	return 0
}
_test_pipefail_sequence() {
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	set +o pipefail
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	set -o pipefail
	! "$scriptAbsoluteLocation" _test_pipefail_sequence_sequence "$@" && return 1
	
	return 0
}
_test_pipefail() {
	if ! "$scriptAbsoluteLocation" _test_pipefail_sequence "$@"
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	"$scriptAbsoluteLocation" _test_pipefail_sequence "$@"
	if [[ "$?" != "0" ]]
	then
		_messageFAIL
		_stop 1
		return 1
	fi
}

# WARNING: Not necessarily tested by default, due to lack of use except where faults are tolerable, and slim possibility of useful embedded systems not able to pass.
_test_grep() {
	# If not known distribution/OS, do NOT test. Some embedded systems not able to pass may be nevertheless useful.
	! ( [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian\|Ubuntu' > /dev/null 2>&1 ) && ! _if_cygwin && return 0
	
	
	
	! echo \$123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo \.123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 123 | grep -E '^\$[0-9]|^\.[0-9]' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	
	! echo 'qwerty.*123' | grep -xF 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty.*123' | grep -F 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -x 'q.*3' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -xF 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -xF 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -xF 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -xF '123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -xF 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	! echo 'qwerty123' | grep -x 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -x 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	echo 'qwerty123' | grep -x 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -x '123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty123' | grep -x 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	echo 'qwerty123' | grep -F 'qwerty.*123' > /dev/null 2>&1 && _messageFAIL && return 1
	echo 'qwerty.*123' | grep -F 'qwerty123' > /dev/null 2>&1 && _messageFAIL && return 1
	
	! echo 'qwerty123' | grep -F 'qwerty' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -F '123' > /dev/null 2>&1 && _messageFAIL && return 1
	! echo 'qwerty123' | grep -F 'werty12' > /dev/null 2>&1 && _messageFAIL && return 1
	
	
	
	return 0
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
	
	
	! _test_pipefail && _messageFAIL && return 1
	
	
	
	
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
	if ( [[ "$current_internal_CompressedScript" == "" ]] && [[ "$current_internal_CompressedScript_cksum" == "" ]] && [[ "$current_internal_CompressedScript_bytes" == "" ]] ) || ( ( [[ "$ub_import_param" != "--embed" ]] ) && [[ "$ub_import_param" != "--bypass" ]] && [[ "$ub_import_param" != "--call" ]] && [[ "$ub_import_param" != "--script" ]] && [[ "$ub_import_param" != "--compressed" ]] )
	then
		[[ "$ub_import" == 'true' ]] && _messageFAIL && _stop 1
		[[ "$ub_import" != '' ]] && _messageFAIL && _stop 1
		[[ "$ub_import_param" != '' ]] && _messageFAIL && _stop 1
	fi
	
	local santiySessionID_length
	santiySessionID_length=$(echo -n "$sessionid" | wc -c | tr -dc '0-9')
	
	[[ "$santiySessionID_length" -lt "18" ]] && _messageFAIL && return 1
	[[ "$uidLengthPrefix" != "" ]] && [[ "$santiySessionID_length" -lt "$uidLengthPrefix" ]] && _messageFAIL && return 1
	
	[[ -e "$safeTmp" ]] && _messageFAIL && return 1
	
	_start scriptLocal_mkdir_disable
	
	
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
	
	
	
	_test_grep
	
	
	local currentJobsList
	currentJobsList=$(jobs -p -r)
	
	[[ "$currentJobsList" != "" ]] && return 1
	
	sleep 7 &
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" == "" ]] && return 1
	
	wait
	currentJobsList=$(jobs -p -r)
	[[ "$currentJobsList" != "" ]] && return 1
	
	
	echo -e -n "b" > "$safeTmp"/a
	[[ $(echo -e -n "c" | cat "$safeTmp"/a -) != "bc" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | cat "$safeTmp"/a /dev/stdin) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat "$safeTmp"/a /proc/self/fd/0) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat - "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | cat /dev/stdin "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | cat /proc/self/fd/0 "$safeTmp"/a) != "cb" ]] && _messageFAIL && _stop 1
	rm -f "$safeTmp"/a
	
	
	echo -e -n "b" > "$safeTmp"/a
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a - | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a /dev/stdin | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat "$safeTmp"/a /proc/self/fd/0 | tail -c 2) != "bc" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat - "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	#[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat /dev/stdin "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	[[ $(echo -e -n "c" | _messagePlain_probe_cmd cat /proc/self/fd/0 "$safeTmp"/a | tail -c 2) != "cb" ]] && _messageFAIL && _stop 1
	rm -f "$safeTmp"/a




	! (set -o pipefail; true | echo x | cat) > /dev/null 2>&1 && _messageFAIL && return 1
	(set -o pipefail; false | echo x | cat) > /dev/null 2>&1 && _messageFAIL && return 1

	[[ $(set -o pipefail; true | echo x | cat) != "x" ]] && _messageFAIL && return 1
	[[ $(set -o pipefail; false | echo x | cat) != "x" ]] && _messageFAIL && return 1

	! false | true && _messageFAIL && return 1
	false | true || _messageFAIL
	false | true || return 1
	true | false && _messageFAIL && return 1
	
	
	
	
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



_test-shell-cygwin() {
	_messageNormal "Cygwin detected... MSW configuration issues..."
	
	
	local currentScriptTime
	if type _stopwatch > /dev/null 2>&1
	then
		if [[ -e "$scriptAbsoluteFolder"/ubiquitous_bash.sh ]]
		then
			currentScriptTime=$(_timeout 45 _stopwatch "$scriptAbsoluteFolder"/ubiquitous_bash.sh _true 2>/dev/null | tr -dc '0-9')
		else
			currentScriptTime=$(_timeout 45 _stopwatch "$scriptAbsoluteLocation" _true 2>/dev/null | tr -dc '0-9')
		fi
	else
		# If '_stopwatch' is not available, assume this is not an issue.
		currentScriptTime="2000"
	fi
	
	# Unusual, broken, non-desktop, etc user/login/account/etc configuration in MSW, might cause prohibitively long Cygwin delays.
	# MSW has a fragile track record, and cannot be used for combining complex applications (eg. flight sim) with 'enterprise' user/login/account/etc and/or deployment. Unless extensive testing conclusively shows a long track record otherwise, or unless MS has a direct commitment under a valuable contract to specifically ensure compatibility with such a use case, it would be obviously gross negligence to put a business at risk of unacceptable downtime from such a fragile stack. Any 'bonus' compensation so earned should incur liability for the disproportionate risk.
	# Enterprise must either use GNU/Linux, or similar, or maybe swap single-user preinstalled physical laptops/desktops.
	if [[ "$currentScriptTime" == "" ]]
	then
		echo 'fail: blank: currentScriptTime'
		_messageFAIL
	fi
	if ( [[ "$currentScriptTime" -gt '9500' ]] && [[ "$CI" == "" ]] ) || [[ "$currentScriptTime" -gt '20000' ]]
	then
		echo 'fail: slow: currentScriptTime: '"$currentScriptTime"
		_messageFAIL
	fi
	if [[ "$currentScriptTime" -gt '4500' ]]
	then
		echo 'warn: slow: currentScriptTime: '"$currentScriptTime"
		_messagePlain_request 'request: obtain a CPU with better single-thread performance, disable HyperThreading, disable EfficiencyCores, and/or reduce MSW OS installed functionality'
	fi
	
	
	local currentPathCount
	currentPathCount=$(echo "$PATH" | grep -o ':' | wc -l | tr -dc '0-9')
	if [[ "$currentPathCount" -gt 50 ]]
	then
		echo 'fail: count: PATH: '"$currentPathCount"
		_messageFAIL
	fi
	if [[ "$currentPathCount" -gt 44 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH may be ignored'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	
	if [[ "$currentPathCount" -gt 32 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 32'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	if [[ "$currentPathCount" -gt 34 ]]
	then
		echo 'warn: count: PATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 34'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	
	
	
	local currentPathCount
	currentPathCount=$(echo "$MSWEXTPATH" | grep -o ';\|:' | wc -l | tr -dc '0-9')
	if [[ "$currentPathCount" -gt 50 ]] && [[ "$CI" == "" ]]
	then
		echo 'fail: count: MSWEXTPATH: '"$currentPathCount"
		_messageFAIL
	fi
	if [[ "$currentPathCount" -gt 44 ]]
	then
		echo 'warn: count: MSWEXTPATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH may be ignored by default'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	
	
	if [[ "$currentPathCount" -gt 32 ]]
	then
		echo 'warn: count: MSWEXTPATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 32'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	if [[ "$currentPathCount" -gt 34 ]]
	then
		echo 'warn: count: MSWEXTPATH: '"$currentPathCount"
		echo 'warn: MSWEXTPATH exceeds preferred 34'
		_messagePlain_request 'request: reduce the length of PATH variable'
	fi
	
	
	
	# Although use case specific (eg. flight sim with usual desktop applications installed) test cases may be necessary for MSW, to avoid ambiguity in expectations that every test includes an explicit PASS statement, a call to '_messagePASS' is still given.
	# Self-hosted 'runners' may be able to implement these test cases, with the resulting fragility reduced somewhat by another computer pulling frequent backups and artifacts.
	# Unusually, MSW may have use case specific issues due to a track record for configuration changes to the MSW OS causing prohibitive performance issues (eg. Cygwin being delayed more than tens of seconds possibly due to a program adding some kind of user account, some programs known to drastically increase frame dropping in intense applications, etc).
	_messagePASS
	
	
	return 0
}
_test-shell() {
	_installation_nonet_default
	
	# ATTENTION: As part of sanity test, "$safeTmp" must not exist until '_start scriptLocal_mkdir_disable' is called from within '_test_sanity' .
	#_start scriptLocal_mkdir_disable
	_messageNormal "Sanity..."
	_test_sanity && _messagePASS
	
	
	
	_messageNormal "Permissions..."
	! _test_permissions_ubiquitous && _messageFAIL
	_messagePASS
	
	#Environment generated by ubiquitous bash is typically 10000 characters.
	#echo -n -e '\E[1;32;46m Argument length...	\E[0m'
	_messageNormal 'Argument length...'
	_testarglength
	
	_messageNormal "Absolute pathfinding..."
	#if ! uname -a | grep -i cygwin > /dev/null 2>&1
	#then
		_tryExec "_test_getAbsoluteLocation"
	#fi
	_messagePASS
	
	
	if _if_cygwin
	then
		! _test-shell-cygwin && _messageFAIL
	fi
	
	
	return 0
}

_test() {
	_test-shell "$@"
	_installation_nonet_default
	
	if ! _typeDep sudo && [[ "$UID" == "0" ]]
	then
		if _typeDep 'apt-get'
		then
			apt-get -y install sudo
		fi
	fi
	#! _typeDep sudo && _stop 1
	
	if ! _typeDep bc
	then
		if _typeDep 'apt-get'
		then
			sudo -n apt-get -y install bc
		fi
	fi
	! _typeDep bc && _stop 1
	
	if type _timetest > /dev/null 2>&1 && [[ "$devfast" != 'true' ]]
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

		echo -e '\E[0;36m Timing: true/false \E[0m'
		! _timeout 10 true && echo '! _timeout 10 true  broken' && _stop 1
		_timeout 10 false && echo '_timeout 10 false  broken' && _stop 1
		if type _stopwatch > /dev/null 2>&1
		then
    		! _stopwatch _timeout 10 true > /dev/null 2>&1 && echo '! _stopwatch _timeout 10 true  broken' && _stop 1
    		_stopwatch _timeout 10 false > /dev/null 2>&1 && echo '_stopwatch _timeout 10 false  broken' && _stop 1
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
	
	_getDep seq
	
	_getDep wc
	
	_getDep fold
	
	
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
	_wantGetDep blockdev
	_wantGetDep lsblk
	
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
	_getDep od
	
	_getDep yes
	
	
	_getDep xargs
	
	
	
	_getDep perl
	
	
	# WARNING: Avoid if possible.
	# Not needed by 'ubiquitous_bash' itself up to at least commit 51ba42ed50b24a0e6eca749e8db7bee5c52cce47 .
	_wantGetDep expect
	
	
	_tryExec "_test_python"
	_tryExec "_test_haskell"
	
	
	
	_test_readlink_f
	
	_tryExec "_test_package"
	
	_tryExec "_test_daemon"
	
	_tryExec "_testFindPort"
	_tryExec "_test_waitport"
	
	
	_tryExec "_test_gitBest"
	
	_tryExec "_test_fw"
	_tryExec "_test_hosts"
	
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
	
	_tryExec "_test_live"
	
	_tryExec "_testExtra"
	
	_tryExec "_testGit"
	
	_tryExec "_test_bup"
	
	_tryExec "_testX11"
	
	_tryExec "_test_virtLocal_X11"
	
	_tryExec "_test_search"
	
	_tryExec "_test_packetDriveDevice"
	_tryExec "_test_gparted"


	_tryExec "_test_wsl2_internal"

	
	# WARNING: Disabled by default. Newer FLOSS (ie. 'barrier'), seems to have displaced the older 'synergy' software.
	# ATTENTION: Override with 'ops' or similar.
	# More portable computing (ie. better laptops) and hardware (eg. mechanical) USB switches are also displacing the usefulness of such keyboard/mouse sharing software.
	#_tryExec "_test_synergy"
	
	
	
	_tryExec "_test_ollama"
	
	
	
	_tryExec "_test_devqalculate"
	_tryExec "_test_devgnuoctave"
	
	
	
	_tryExec "_test_devatom"
	_tryExec "_test_devemacs"
	_tryExec "_test_deveclipse"
	
	
	_tryExec "_test_h1060p"
	
	
	_tryExec "_test_ethereum"
	_tryExec "_test_ethereum_parity"
	
	
	
	_tryExec "_test_mktorrent"
	
	
	_tryExec "_test_cloud"
	
	_tryExec "_test_rclone"
	_tryExec "_test_croc"
	
	_tryExec "_test_terraform"
	
	
	_tryExec "_test_vagrant_build"
	
	
	
	_tryExec "_test_rclone_limited"
	
	
	
	_tryExec "_test_kernelConfig"
	
	
	_tryExec "_test_clog"
	
	_tryExec "_test_metaengine"
	
	_tryExec "_test_channel"
	
	_tryExec "_test_nix-env"
	
	
	! [[ -e /dev/urandom ]] && echo /dev/urandom missing && _stop 1
	[[ $(_timeout 3 cat /dev/urandom 2> /dev/null | _timeout 3 base64 2> /dev/null | _timeout 3 tr -dc 'a-zA-Z0-9' 2> /dev/null | _timeout 3 head -c 18 2> /dev/null) == "" ]] && echo /dev/urandom fail && _stop 1
	
	_messagePASS
	
	if type _test_queue > /dev/null 2>&1 && [[ "$devfast" != 'true' ]]
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
	_start scriptLocal_mkdir_disable
	
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
	
	_start scriptLocal_mkdir_disable
	
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
		if [[ "$skimfast" != "true" ]]
		then
			rsync -av --progress --exclude "/ubcp/conemu" --exclude "/ubcp/cygwin" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		else
			rsync -a --exclude "/ubcp/conemu" --exclude "/ubcp/cygwin" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		fi
	else
		if [[ "$skimfast" != "true" ]]
		then
			rsync -av --progress --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		else
			rsync -a --exclude "/ubcp/package_ubcp-cygwinOnly.tar.gz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.xz" --exclude "/ubcp/package_ubcp-cygwinOnly.tar.flx" "$1" "$2"
		fi
	fi
	
	
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.gz
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.xz
	rm -f "$safeTmp"/package/_local/package_ubcp-cygwinOnly.tar.flx
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.gz
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.xz
	rm -f "$safeTmp"/package/_local/ubcp/package_ubcp-cygwinOnly.tar.flx
	
	return 0
}

# ATTENTION: Override with 'installation_prog.sh' or similar.
_package_ubcp_copy_prog() {
	false
	
	cd "$outerPWD"
	return 1
	_stop 1
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
	
	# ATTENTION: Override with 'installation_prog.sh' or similar.
	if _package_ubcp_copy_prog
	then
		return 0
	fi
	
	
	cd "$outerPWD"
	_stop 1
}

# ATTENTION: Override with 'ops' or similar ONLY if necessary.
_package_subdir() {
	#return 0
	
	# ATTENTION: Error message about 'cannot move' ... 'subdirectory of itself' ... is normal .
	mkdir -p "$safeTmp"/package/"$objectName"_tmp/
	( shopt -s dotglob ; mv "$safeTmp"/package/* "$safeTmp"/package/"$objectName"_tmp/ )
	mv "$safeTmp"/package/"$objectName"_tmp "$safeTmp"/package/"$objectName"
}

# WARNING Must define "_package_license" function in ops to include license files in package!
_package_procedure() {
	_start scriptLocal_mkdir_disable
	mkdir -p "$safeTmp"/package
	
	# May not have any effect - Cygwin symlinks should be transparent to 'tar' and similar.
	_force_cygwin_symlinks
	
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
	
	cp -a "$scriptAbsoluteFolder"/README.sh "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.html "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.pdf "$safeTmp"/package/
	cp -a "$scriptAbsoluteFolder"/README.md "$safeTmp"/package/
	
	
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
	[[ "$ubPackage_enable_ubcp" == 'true' ]] && env XZ_OPT="-5 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp.tar.xz .
	
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
	[[ "$testHostname" == "" ]] && testHostname=$(hostname -s 2>/dev/null)
	_if_cygwin && testHostname=$(hostname 2>/dev/null)

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
# ATTENTION: WARNING: Enjoy this python code. The '_bash' and '_bin' function are quite possibly, even probably, and for actual reasons for every line of code being annoying, the worst python code that will ever be written by people. In plainer language, only mess with parts of this code for which you have stopped to fully understand exactly why every negation, if/else, return, print, etc, is in the exact order that it is.
def _bash(currentArguments = ['-i'], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh", interactive=True):
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')):
            current_ubiquitous_bash = os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptAbsoluteLocation", "")):
            current_ubiquitous_bash = os.environ.get("scriptAbsoluteLocation", "")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"
    currentArguments = ['-i'] if currentArguments == '-i' else currentArguments
    if isinstance(currentArguments, str):
    # WARNING: Discouraged.
        if not ( ( currentArguments == '-i' ) or ( currentArguments == '' ) or ( interactive == True ) ):
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
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
        if not ( ( currentArguments == ['-i'] ) or ( currentArguments == [''] ) or ( interactive == True ) ):
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bash'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == [''] ): currentArguments = ['-i']
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
# ATTENTION: WARNING: Enjoy this python code. The '_bash' and '_bin' function are quite possibly, even probably, and for actual reasons for every line of code being annoying, the worst python code that will ever be written by people. In plainer language, only mess with parts of this code for which you have stopped to fully understand exactly why every negation, if/else, return, print, etc, is in the exact order that it is.
def _bin(currentArguments = [''], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh", interactive=False):
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')):
            current_ubiquitous_bash = os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptAbsoluteLocation", "")):
            current_ubiquitous_bash = os.environ.get("scriptAbsoluteLocation", "")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"
    # ATTENTION: Comment out next python line of code to test this code with an empty string.
    #./lean.py "_bin('', currentPrint=True)"
    currentArguments = [''] if currentArguments == '' else currentArguments
    if isinstance(currentArguments, str):
        # WARNING: Discouraged.
        if not ( ( ( currentArguments == '/bin/bash -i' ) or ( currentArguments == '/bin/bash' ) or ( currentArguments == '_bash' ) or ( currentArguments == '' ) ) or ( interactive == True ) ) :
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == '' ): currentArguments = '_bash'
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
        return (currentOut), currentProc.returncode
    else:
        if not ( ( ( currentArguments == ['/bin/bash', '-i'] ) or ( currentArguments == ['/bin/bash'] ) or ( currentArguments == ['_bash'] ) or ( currentArguments == ['_bash', '-i'] ) or ( currentArguments == ['_qalculate', ''] ) or ( currentArguments == ['_qalculate'] ) or ( currentArguments == ['_octave', ''] ) or ( currentArguments == ['_octave'] ) or ( currentArguments == [''] ) ) or ( interactive == True ) ):
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bin'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == [''] ): currentArguments = ['_bash']
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








if sys.platform == 'win32':
    try:
        import pyreadline3 as readline
    except ImportError:
        readline = None
else:
    try:
        import readline # optional, will allow Up/Down/History in the console
    except ImportError:
        readline = None
import code

# ATTRIBUTION-AI: ChatGPT o3  2025-04-19
def _enable_readline():
    """
    Make sure arrow keys, history and TAB completion work in the
    interpreter that we embed with code.InteractiveConsole.
    """
    try:
        import readline, rlcompleter, atexit, os
        # basic key bindings
        readline.parse_and_bind('tab: complete')
        # persistent history file
        histfile = os.path.expanduser('~/.pyhistory')
        if os.path.exists(histfile):
            readline.read_history_file(histfile)
        atexit.register(readline.write_history_file, histfile)
    except ImportError:
        # readline (or pyreadline on Windows) is not available
        pass




#_python()
# https://stackoverflow.com/questions/5597836/embed-create-an-interactive-python-shell-inside-a-python-program
def _python():
    _enable_readline()
    variables = globals().copy()
    variables.update(locals())
    shell = code.InteractiveConsole(variables)
    # ATTRIBUTION-AI: ChatGPT 4.1  2025-04-19
    if os.name == 'nt':  # True on Windows
        print(" Press Ctrl+D twice (or Ctrl+Z then Enter) to exit this Python shell.")
    # ATTRIBUTION: NOT AI !
    shell.interact()



import sys
import os
import socket
import string
import re

# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)
# Determine if running on Windows
is_windows = os.name == 'nt'

# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)
# Attempt to import colorama if on Windows
use_colorama = False
if is_windows:
    try:
        from colorama import init, Fore, Back, Style
        init(autoreset=True)
        use_colorama = True
    except ImportError:
        pass  # Silently proceed without colorama if import fails

# Color definitions (use ANSI if not on Windows or colorama is not used)
if use_colorama:
    # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)  ( also the preceeding line  if use_colorama:  )
    class ubPythonPS1(object):
        def __init__(self):
            self.line = 0

        def __str__(self):
            self.line += 1
            user = os.getenv('USER', 'root')
            hostname = socket.gethostname()
            cloud_net_name = os.environ.get('prompt_cloudNetName', '')
            #py_version = f"v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
            ## ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
            #py_version = f"v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}" if not os.getenv('VIRTUAL_ENV_PROMPT') else os.getenv('VIRTUAL_ENV_PROMPT', '')
            # ATTRIBUTION-AI: ChatGPT o3  2025-04-19
            py_version = os.getenv("VIRTUAL_ENV_PROMPT") or f"Python-v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
            cwd = os.path.expanduser(os.getcwd())

            home_dir = os.environ.get('HOME', os.environ.get('USERPROFILE', ''))
            if home_dir:
                cwd = re.sub(f'^{re.escape(home_dir)}', '~', cwd)

            # Color definitions (matched to ANSI colors)
            blue = Fore.BLUE
            red = Fore.RED
            green = Fore.GREEN  # Hostname color
            yellow = Fore.YELLOW
            magenta = Fore.MAGENTA  # Python version color
            cyan = Fore.CYAN
            white = Fore.WHITE
            reset = Style.RESET_ALL
            bg_white = Back.WHITE

            if self.line == 1:
                prompt = (
                    f"{blue}|{red}#{red}:{yellow}{user}{green}@{green}{hostname}{blue})-{cloud_net_name}({magenta}{bg_white}{py_version}{reset}{blue}){cyan}|\n"
                    #f"{blue}|{white}[{cwd}]\n"
                    f"{white}{cwd}\n"
                    f"{blue}|{cyan}{self.line}{blue}) {cyan}> {reset}"
                )
            else:
                prompt = (
                    f"{blue}|{red}#{red}:{yellow}{user}{green}@{green}{hostname}{blue})-{cloud_net_name}({magenta}{bg_white}{py_version}{reset}{blue}){cyan}|\n"
                    #f"{blue}|{white}[{cwd}]\n"
                    f"{white}{cwd}\n"
                    f"{blue}|{blue}{self.line}{blue}) {cyan}> {reset}"
                )
            return prompt

    sys.ps1 = ubPythonPS1()
    sys.ps2 = f"{Fore.CYAN}|...{Style.RESET_ALL} "
else:
    # ATTRIBUTION: NOT AI !
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
    #return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|\033[1;96m%d\033[1;94m) \033[1;96m>\033[0m " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
    #return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|%d\033[1;94m) \033[1;96m>\033[0m " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
    #os.environ['USER']
    #os.getenv('USER','root')
    class ubPythonPS1(object):
        def __init__(self):
            self.line = 0

        def __str__(self):
            self.line += 1
            if self.line == 1:
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
                return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion) if 'VIRTUAL_ENV_PROMPT' not in os.environ or not os.environ['VIRTUAL_ENV_PROMPT'] else os.environ['VIRTUAL_ENV_PROMPT'], re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
            else:
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
                return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion) if 'VIRTUAL_ENV_PROMPT' not in os.environ or not os.environ['VIRTUAL_ENV_PROMPT'] else os.environ['VIRTUAL_ENV_PROMPT'], re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)

    sys.ps1 = ubPythonPS1()
    sys.ps2 = "\x01\033[0;96m\x02|...\x01\033[0m\x02 "


# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18 (only the next line  if is_windows and not use_colorama:  )
if is_windows and not use_colorama:
    # ATTRIBUTION: NOT AI !
    # https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za
    sys.ps1 = '>>> '
    sys.ps2 = '... '

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



# ATTENTION: You probably do NOT want to bother with this specialized build system.
#
# WARNING: No production use.
#
# Functions here or imported here are NOT intended for functionality, installation, or build procedures of end-user programs.
# Imports functions from an external file ONLY when relevant functions are called, and does NOT compile substantial code into 'ubiquitous_bash.sh' script files.
#
# Function import through "$scriptLib"/build-ops.sh or similar is usually only appropriate in certain situations:
# 1) Esoteric derivative standalone binary products (eg. direct translations from shellcode functions to microcontroller firmware preprocessor macro libraries, 'ubcp' Cygwin/MSW compatibility layer, etc), ONLY if including/(re)compiling with the larger script is NOT desired and NOT practical.
# 2) Fallback modernizing (ie. upgrading previous versions) certain binary products (eg. static binary executables, dist/OS disk images, etc), skipping a full rebuild either for drastically reduced build times or due to loss of external dependencies.
# 3) Staging procedures called during such fallbacks to integrate and build track record with new functionality (eg. new 'apt-get install' commands for dist/OS disk images) before adding to the compiled script shellcode.
_bin-build_import() {
    
    # Very rare.
    [[ -e "$scriptLib"/_build-esoteric-ops.sh ]] && . "$scriptLib"/_build-esoteric-ops.sh


    [[ -e "$scriptLib"/_build-fallback-ops.sh ]] && . "$scriptLib"/_build-fallback-ops.sh

    [[ -e "$scriptLib"/_build-staging-ops.sh ]] && . "$scriptLib"/_build-staging-ops.sh


    # Discouraged.
    [[ -e "$scriptLib"/_build-ops.sh ]] && . "$scriptLib"/_build-ops.sh


    

    #_safe_declare_uid
    #"$@"
    _bin "$@"

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
	# WARNING: CAUTION: Use sparingly and carefully . Allows a user to globally override functions for all 'ubiquitous_bash' scripts, projects, etc.
	if [[ -e "$HOME"/_bashrc ]]
	then
		. "$HOME"/_bashrc
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
fi


# ATTENTION: May be redundantly redefined (ie. overloaded) if appropriate (eg. for use outside a 'ubiquitous_bash' environment).
_backend_override() {
	! type -f _backend > /dev/null 2>&1 && _backend() { "$@" ; unset -f _backend ; }
	_backend "$@"
}
## ...
## EXAMPLE
#! _openChRoot && _messageFAIL
## ...
#_backend() { _ubdistChRoot "$@" ; }
#_backend_override echo test
#unset -f _backend
## ...
#! _closeChRoot && _messageFAIL
## ...
## EXAMPLE
#_ubdistChRoot_backend_begin
#_backend_override echo test
#_ubdistChRoot_backend_end
## ...
## EXAMPLE
#_experiment() { _backend_override echo test ; }
#_ubdistChRoot_backend _experiment



#wsl '~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh' '_wrap' kwrite './gpl-3.0.txt'
#wsl '~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh' '_wrap' ldesk
_wrap() {
	[[ "$LANG" != "C" ]] && export LANG=C
	. "$HOME"/.ubcore/.ubcorerc
	
	_safe_declare_uid
	
	if uname -a | grep -i 'microsoft' > /dev/null 2>&1 && uname -a | grep -i 'WSL2' > /dev/null 2>&1
	then
		local currentArg
		local currentResult
		processedArgs=()
		for currentArg in "$@"
		do
			currentResult=$(wslpath -u "$currentArg")
			if [[ -e "$currentResult" ]]
			then
				true
			else
				currentResult="$currentArg"
			fi
			
			processedArgs+=("$currentResult")
		done
		
		
		"${processedArgs[@]}"
		return
	fi
	
	"$@"
}

#Wrapper function to launch arbitrary commands within the ubiquitous_bash environment, including its PATH with scriptBin.
_bin() {
	# Less esoteric than calling '_bash _bash', but calling '_bin _bin' is still not useful, and filtered out for Python scripts which may call either 'ubiquitous_bash.sh' or '_bash.bat' interchangeably.
	#  CAUTION: Shifting redundant '_bash' parameters is necessary for some Python scripts.
	if [[ "$1" == ${FUNCNAME[0]} ]] && [[ "$2" == ${FUNCNAME[0]} ]]
	then
		shift
		shift
	else
		[[ "$1" == ${FUNCNAME[0]} ]] && shift
	fi

	_safe_declare_uid
	
	"$@"
}
#Mostly intended to launch bash prompt for MSW/Cygwin users.
_bash() {
	# CAUTION: NEVER call _bash _bash , etc . This is different from calling '_bash "$scriptAbsoluteLocation" _bash', or '_bash -c bash -i' (not that those are known workable or useful either), cannot possibly provide any useful functionality (since 'bash' called by '_bash' is in the same environment), will only cause issues for no benefit, so don't.
	# ATTENTION: In practice, this can happen incidentally, due to calling '_bash.bat' instead of 'ubiquitous_bash.sh' to call '_bash' function, since MSW would not be able to run 'ubiquitous_bash.sh' without an anchor batch script properly calling Cygwin bash.exe . Python scripts which may call either 'ubiquitous_bash.sh' or '_bash.bat' interchangeably benefit from this, because the '_bash' parameter does not need to change depending on Native/MSW or UNIX/Linux. Since there is no useful purpose to calling '_bash _bash', etc, simply always dismissing the redundant '_bash' parameter is reasonable.
	#  CAUTION: Shifting redundant '_bash' parameters is necessary for some Python scripts.
	if [[ "$1" == "_bash" ]] && [[ "$2" == "_bash" ]]
	then
		shift
		shift
	else
		[[ "$1" == "_bash" ]] && shift
	fi

	_safe_declare_uid
	
	local currentIsCygwin
	currentIsCygwin='false'
	[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && _if_cygwin && currentIsCygwin='true'
	
	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	[[ "$currentIsCygwin" == 'true' ]] && echo -n '.'
	
	
	_visualPrompt
	[[ "$ub_scope_name" != "" ]] && _scopePrompt
	
	_safe_declare_uid
	
	
	[[ "$1" == '-i' ]] && shift
	
	
	_safe_declare_uid
	
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
	_safe_declare_uid
	
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
	_safe_declare_uid
	
	if ! _if_cygwin
	then
		sudo -n "$scriptAbsoluteLocation" _bin "$@"
		return
	fi
	if _if_cygwin
	then
		_sudo_cygwin "$@"
		return
	fi
	
	return 1
}

_true() {
	_safe_declare_uid
	
	#"$scriptAbsoluteLocation" _false && return 1
	#  ! "$scriptAbsoluteLocation" _bin true && return 1
	#"$scriptAbsoluteLocation" _bin false && return 1
	true
}
_false() {
	_safe_declare_uid
	
	false
}
_echo() {
	_safe_declare_uid
	
	echo "$@"
}

_diag() {
	_safe_declare_uid
	
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


#####Entry

# WARNING: Do not add code directly here without disabling checksum!
# WARNING: Checksum may only be disabled either by override of 'generic/minimalheader.sh' or by adding appropriate '.nck' file !

#"$scriptAbsoluteLocation" _setup




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

