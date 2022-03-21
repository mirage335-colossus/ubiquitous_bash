
# WARNING: Untested!
# Especially needed, testing with chroot and ssh backends.


_getMost_debian11_aptSources() {
	# May be an image copied while dpkg was locked. Especially if 'chroot'.
	_getMost_backend /var/lib/apt/lists/lock
	_getMost_backend /var/lib/dpkg/lock
	
	
	_getMost_backend mkdir -p /etc/apt/sources.list.d
	echo 'deb http://deb.debian.org/debian bullseye-backports main contrib' | _getMost_backend tee /etc/apt/sources.list.d/custom_backports.list
	echo 'deb http://download.virtualbox.org/virtualbox/debian bullseye contrib' | _getMost_backend tee /etc/apt/sources.list.d/vbox.list > /dev/null 2>&1
	
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
	
	
}

_getMost_debian11_special_early() {
	true
}

_getMost_debian11_special_late() {
	_getMost_backend_aptGetInstall curl
	
	_messagePlain_probe 'install: rclone'
	_getMost_backend curl https://rclone.org/install.sh | _getMost_backend bash -s beta
}

_getMost_debian11_install() {
	# ATTENTION: Examples. Copy relevant files to automatically enable such installations (file existence will be detected).
	#[[ "$getMost_backend" == "chroot" ]]
		#sudo -n cp "$scriptLib"/debian/packages/bup_0.29-3_amd64.deb "$globalVirtFS"/
	#[[ "$getMost_backend" == "ssh" ]]
		#_rsync -axvz --rsync-path='mkdir -p '"'"$currentDestinationDirPath"'"' ; rsync' --delete "$1" "$2"
	
	
	_messagePlain_probe 'apt-get update'
	_getMost_backend apt-get update
	
	
	_getMost_debian11_special_early
	
	
	if _getMost_backend_fileExists "/bup_0.29-3_amd64.deb"
	then
		_getMost_backend dpkg -i "/bup_0.29-3_amd64.deb"
		_getMost_backend rm -f /bup_0.29-3_amd64.deb
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install -y -f
	fi
	
	
	_getMost_backend_aptGetInstall sudo
	
	
	
	_getMost_debian11_special_late
}




_getMost_debian11() {
	_messagePlain_probe 'begin: _getMost_debian11_install'
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	_set_getMost_backend "$@"
	
	_getMost_backend_aptGetInstall() {
		_messagePlain_probe _getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$@"
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$@"
	}
	export -f _getMost_backend_aptGetInstall
	
	
	_getMost_debian11_install "$@"
	
	_messagePlain_probe 'end: _getMost_debian11_install'
}







_set_getMost_backend_command() {
	[[ "$getMost_backend" == "" ]] && export getMost_backend="direct"
	#[[ "$getMost_backend" == "" ]] && export getMost_backend="chroot"
	#[[ "$getMost_backend" == "" ]] && export getMost_backend="ssh"
	
	
	
	if [[ "$getMost_backend" == "direct" ]] && [[ $(id -u) == 0 ]]
	then
		! _mustBeRoot && exit 1
		_getMost_backend() {
			"$@"
		}
		export -f _getMost_backend
		return 0
	fi
	if [[ "$getMost_backend" == "direct" ]]
	then
		! _mustGetSudo && exit 1
		_getMost_backend() {
			sudo -n "$@"
		}
		export -f _getMost_backend
		return 0
	fi
	[[ "$getMost_backend" == "direct" ]] && return 1
	
	
	
	if [[ "$getMost_backend" == "chroot" ]]
	then
		_getMost_backend() {
			_chroot "$@"
		}
		export -f _getMost_backend
	fi
	
	if [[ "$getMost_backend" == "ssh" ]]
	then
		_getMost_backend() {
			local currentExitStatus
			
			#export custom_user="user"
			#export custom_hostname='hostname'
			#export custom_netName="$netName"
			#export SSHuserAndMachine="$custom_user""@""$custom_hostname"-"$custom_netName"
			#export SSHuserAndMachine="$1"
			_ssh_internal_command "$SSHuserAndMachine" "$@"
			currentExitStatus="$?"
			
			#Preventative workaround, not normally necessary.
			stty echo > /dev/null 2>&1
			return "$currentExitStatus"
		}
		export -f _getMost_backend
	fi
	
	return 0
}
_set_getMost_backend_fileExists() {
	_getMost_backend_fileExists() {
		# Any modern GNU/Linux, Cygwin/MSW, etc, OS distribution, is expected to have '/bin/bash'.
		# Override to '/bin/dash' may very slightly improve performance, the compatibility tradeoff is NOT expected worthwhile.
		_getMost_backend /bin/bash -c '[ -e "'"$1"'" ]'
	}
	export -f _getMost_backend_fileExists
}
_set_getMost_backend() {
	_set_getMost_backend_command "$@"
	_set_getMost_backend_fileExists "$@"
}

# WARNING: No production use. Installation commands may be called through 'chroot' or 'ssh' , expected as such not reasonably able to detect the OS distribution . User is expected to instead call the correct function with the correct configuration.
_getMost() {
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian' > /dev/null 2>&1
	then
		_tryExecFull _getMost_debian11 "$@"
		return
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		_tryExecFull _getMost_ubuntu20 "$@"
		return
	fi
	return 1
}


