
# WARNING: Untested!
# Especially needed, testing with chroot and ssh backends.

# ATTENTION: Expected use case is to attempt installation of dependencies and user software, once, before using '_test'. Not every command is expected to succeed.



# ATTENTION: Examples. Copy relevant files to automatically enable such installations (file existence will be detected).
	#[[ "$getMost_backend" == "chroot" ]]
		#sudo -n cp "$scriptLib"/debian/packages/bup_0.29-3_amd64.deb "$globalVirtFS"/
	#[[ "$getMost_backend" == "ssh" ]]
		#_rsync -axvz --rsync-path='mkdir -p '"'"$currentDestinationDirPath"'"' ; rsync' --delete "$1" "$2"







_install_debian11() {
	! "$scriptAbsoluteLocation" _mustGetSudo && _messageError 'FAIL: _mustGetSudo' && return 1
	_mustGetSudo
	
	"$scriptAbsoluteLocation" _setupUbiquitous
	"$scriptAbsoluteLocation" _getMost_debian11
	type _get_veracrypt > /dev/null 2>&1 && "$scriptAbsoluteLocation" _get_veracrypt
	"$scriptAbsoluteLocation" _test
	
	#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get --install-recommends -y upgrade
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --install-recommends -y upgrade
}





# Workaround to prevent 'tasksel' from going to 'background' locking subsequent other 'apt-get' and similar commands.
# Nevertheless, using any 'tasksel' commands only at the end of any script is preferable.
_wait_debianInstall() {
	# Loop expected much slower than 0.1s/iteration, expect reasonable CPU and such ~0.3s/iteration.
	# If CPU and such are faster, than both this loop and any debian install program to detect, are both expected to change timing comparably, so adjustments are expected NOT necessary.
	
	# https://blog.sinjakli.co.uk/2021/10/25/waiting-for-apt-locks-without-the-hacky-bash-scripts/
	local currentIteration
	local currentIteration_continuing
	currentIteration=0
	currentIteration_continuing=99999
	while [[ "$currentIteration" -lt 900 ]] && [[ "$currentIteration_continuing" == 99999 ]] ; do
		_messagePlain_probe 'wait: install: debian'
		
		currentIteration_continuing=0
		while [[ "$currentIteration_continuing" -lt 300 ]] ; do
			sleep 0.1
			echo 'busy: '"$currentIteration_continuing"
			let currentIteration_continuing="$currentIteration_continuing"+1
			if pgrep ^tasksel$ || pgrep ^apt-get$ || pgrep ^dpkg$ || ( fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || ( type -p sudo > /dev/null 2>&1 && sudo -n fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ) )
			then
				currentIteration_continuing=99999
			fi
			let currentIteration="$currentIteration"+1
		done
		echo 'wait: '"$currentIteration"
	done
	sleep 1
}


_getMost_debian11_aptSources() {
	# May be an image copied while dpkg was locked. Especially if 'chroot'.
	_getMost_backend rm -f /var/lib/apt/lists/lock
	_getMost_backend rm -f /var/lib/dpkg/lock
	
	
	_getMost_backend_aptGetInstall wget
	_getMost_backend_aptGetInstall gpg
	
	
	_getMost_backend mkdir -p /etc/apt/sources.list.d
	
	#echo 'deb http://deb.debian.org/debian bullseye-backports main contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_backports.list > /dev/null 2>&1
	#echo 'deb http://download.virtualbox.org/virtualbox/debian bullseye contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
	#echo 'deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	
	if ! ( [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1 ) || ( [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 11 > /dev/null 2>&1 )
	then
		echo 'deb http://deb.debian.org/debian bullseye-backports main contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_backports.list > /dev/null 2>&1
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bullseye contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		echo 'deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		
		## https://fasttrack.debian.net/
		#if ! grep 'fasttrack' /etc/apt/sources.list
		#then
			#_getMost_backend apt install -y fasttrack-archive-keyring
			#echo 'deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib' | _getMost_backend tee -a /etc/apt/sources.list
			#echo 'deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib' | _getMost_backend tee -a /etc/apt/sources.list
		#fi
		
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '20.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable"
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '22.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian jammy contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable"
	fi
	
	curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
}

_getMost_debian12_aptSources() {
	# May be an image copied while dpkg was locked. Especially if 'chroot'.
	_getMost_backend rm -f /var/lib/apt/lists/lock
	_getMost_backend rm -f /var/lib/dpkg/lock
	
	
	_getMost_backend_aptGetInstall wget
	_getMost_backend_aptGetInstall gpg
	
	
	_getMost_backend mkdir -p /etc/apt/sources.list.d
	
	#echo 'deb http://deb.debian.org/debian bookworm-backports main contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_backports.list > /dev/null 2>&1
	#echo 'deb http://download.virtualbox.org/virtualbox/debian bookworm contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
	#echo 'deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	
	if ! ( [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1 ) || ( [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 12 > /dev/null 2>&1 )
	then
		echo 'deb http://deb.debian.org/debian bookworm-backports main contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_backports.list > /dev/null 2>&1
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bookworm contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		
		## https://fasttrack.debian.net/
		#if ! grep 'fasttrack' /etc/apt/sources.list
		#then
			#_getMost_backend apt install -y fasttrack-archive-keyring
			#echo 'deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib' | _getMost_backend tee -a /etc/apt/sources.list
			#echo 'deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-backports-staging main contrib' | _getMost_backend tee -a /etc/apt/sources.list
		#fi
		
		# https://github.com/wireapp/wire-desktop/wiki/How-to-install-Wire-for-Desktop-on-Linux
		#wget -q https://wire-app.wire.com/linux/releases.key -O- | sudo -n apt-key add -
		#echo "deb [arch=amd64] https://wire-app.wire.com/linux/debian stable main" | sudo -n tee /etc/apt/sources.list.d/wire-desktop.list
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '20.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable"
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '22.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian jammy contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable"
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '24.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian noble contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
		echo "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"') $(_getMost_backend bash -c 'lsb_release -cs') stable"
	fi
	
	curl -fsSL https://download.docker.com/linux/$(_getMost_backend bash -c '. /etc/os-release; echo "$ID"')/gpg | _getMost_backend apt-key add -
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
	_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
}

_getMost_debian11_special_early() {
	true
}

_getMost_debian11_special_late() {
	_getMost_backend_aptGetInstall curl
	
	_messagePlain_probe 'install: rclone'
	#_getMost_backend curl https://rclone.org/install.sh | _getMost_backend bash -s beta
	_getMost_backend curl https://rclone.org/install.sh | _getMost_backend bash
}

_getMost_debian12_install() {
	_getMost_debian11_install "$@"

	_getMost_backend_aptGetInstall qalculate-gtk
	_getMost_backend_aptGetInstall qalc
	
	# CAUTION: Workaround. Debian defaults to an obsolete version of qalc which is unusable.
	_getMost_backend_aptGetInstall -t bookworm-backports qalc

	#_getMost_backend_aptGetInstall wire-desktop

	# ATTENTION: SEVERE: Cause for concern. Absence of this is not properly detected by '_getDep python', '_getDep /usr/bin/python'  .
	_getMost_backend_aptGetInstall python-is-python3


	# May be useful for WSL2 .
	_getMost_backend_aptGetInstall usbip

	
	#_getMost_backend apt-get -d install -y virtualbox-7.0
	_getMost_backend apt-get -d install -y virtualbox-7.1

	#_getMost_backend_aptGetInstall virtualbox-7.0
	_getMost_backend_aptGetInstall virtualbox-7.1


	_getMost_backend_aptGetInstall git-filter-repo
}

_getMost_debian11_install() {
	_messagePlain_probe 'apt-get update'
	_getMost_backend apt-get update
	
	
	_getMost_debian11_special_early
	
	
	
	
	_getMost_backend_aptGetInstall sudo
	_getMost_backend_aptGetInstall gpg
	_getMost_backend_aptGetInstall --reinstall wget
	
	_getMost_backend_aptGetInstall apt-utils
	
	_getMost_backend_aptGetInstall pigz
	_getMost_backend_aptGetInstall pixz


	_getMost_backend_aptGetInstall bash dash

	_getMost_backend_aptGetInstall aria2 curl gpg
	_getMost_backend_aptGetInstall gnupg
	_getMost_backend_aptGetInstall lsb-release

	if ! _getMost_backend dash -c 'type apt-fast' > /dev/null 2>&1
	then
		_getMost_backend_aptGetInstall aria2 curl gpg
		
		_getMost_backend mkdir -p /etc/apt/keyrings
		_getMost_backend curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xA2166B8DE8BDC3367D1901C11EE2FF37CA8DA16B' | _getMost_backend gpg --dearmor -o /etc/apt/keyrings/apt-fast.gpg
		_getMost_backend apt-get update
		_getMost_backend_aptGetInstall apt-fast

		echo debconf apt-fast/maxdownloads string 16 | _getMost_backend debconf-set-selections
		echo debconf apt-fast/dlflag boolean true | _getMost_backend debconf-set-selections
		echo debconf apt-fast/aptmanager string apt-get | _getMost_backend debconf-set-selections
	fi

	
	_messagePlain_probe 'apt-get update'
	_getMost_backend apt-get update
	
	# DANGER: Requires expanded (raspi) image (ie. raspi image is too small by default)!
	# May be able to resize with some combination of 'dd' and 'gparted' , possibly '_gparted' . May be untested.
	#_messagePlain_probe 'apt-get upgrade'
	#_getMost_backend apt-get upgrade

	# https://github.com/wireapp/wire-desktop/wiki/How-to-install-Wire-for-Desktop-on-Linux
	_getMost_backend_aptGetInstall apt-transport-https
	
	
	_getMost_backend_aptGetInstall locales-all
	
	
	if _getMost_backend_fileExists "/bup_0.29-3_amd64.deb"
	then
		_getMost_backend dpkg -i "/bup_0.29-3_amd64.deb"
		_getMost_backend rm -f /bup_0.29-3_amd64.deb
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install -y -f
	fi
	
	_getMost_backend_aptGetInstall git
	
	_getMost_backend_aptGetInstall git-lfs

	_getMost_backend_aptGetInstall bup
	
	# ATTENTION: WSL2 distribution instances may also need 'socat' for internal network port forwarding.
	_getMost_backend_aptGetInstall bc autossh nmap socat sockstat rsync net-tools
	_getMost_backend_aptGetInstall bc nmap autossh socat sshfs tor
	_getMost_backend_aptGetInstall sockstat
	_getMost_backend_aptGetInstall x11-xserver-utils
	_getMost_backend_aptGetInstall arandr

	if _getMost_backend_fileExists "/curlftpfs_0.9.2-9+b1_amd64.deb"
	then
		_getMost_backend dpkg -i "/curlftpfs_0.9.2-9+b1_amd64.deb"
		_getMost_backend rm -f "/curlftpfs_0.9.2-9+b1_amd64.deb"
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install -y -f
	fi

	_getMost_backend_aptGetInstall curlftpfs

	_getMost_backend_aptGetInstall liblinear4 liblua5.3-0 lua-lpeg nmap nmap-common
	
	_getMost_backend_aptGetInstall uuid-runtime
	
	_getMost_backend_aptGetInstall tigervnc-viewer
	_getMost_backend_aptGetInstall x11vnc
	_getMost_backend_aptGetInstall tigervnc-standalone-server
	_getMost_backend_aptGetInstall tigervnc-scraping-server
	
	_getMost_backend_aptGetInstall iperf3
	
	_getMost_backend_aptGetInstall ufw
	_getMost_backend_aptGetInstall gufw
	
	#_getMost_backend_aptGetInstall synergy quicksynergy
	
	_getMost_backend_aptGetInstall vim
	
	_getMost_backend_aptGetInstall strace

	_getMost_backend_aptGetInstall man-db
	
	# WARNING: Rust is not yet (2023-11-12) anywhere near as editable on the fly or pervasively available as bash .
	#  Criteria for such are far more necessarily far more stringent than might be intuitively obvious.
	#  Rust is expected to remain non-competitive with bash for purposes of 'ubiquitous_bash', even for reference implementations, for at least 6years .
	#   6 years
	# https://users.rust-lang.org/t/does-rust-work-in-cygwin-if-so-how-can-i-get-it-working/25735
	# https://stackoverflow.com/questions/31492799/cross-compile-a-rust-application-from-linux-to-windows
	# https://rustup.rs/
	#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	# https://packages.debian.org/search?keywords=rustup&searchon=names&suite=all&section=all
	# https://wiki.debian.org/Rust
	#  DANGER: Do NOT regard 'rustup' as available.
	_getMost_backend_aptGetInstall rustc
	_getMost_backend_aptGetInstall cargo
	#_getMost_backend_aptGetInstall rustup
	_getMost_backend_aptGetInstall mingw-w64
	_getMost_backend_aptGetInstall g++-mingw-w64-x86-64-win32
	_getMost_backend_aptGetInstall binutils-mingw-w64
	_getMost_backend_aptGetInstall mingw-w64-tools
	_getMost_backend_aptGetInstall gdb-mingw-w64
	
	if _getMost_backend bash -c '! dpkg --print-foreign-architectures | grep i386'
	then
		_getMost_backend dpkg --add-architecture i386
		_getMost_backend apt-get update
	fi
	_getMost_backend_aptGetInstall wmctrl xprintidle


	_getMost_backend_aptGetInstall dbus-x11


	_getMost_backend_aptGetInstall gnulib

	_getMost_backend_aptGetInstall libtool
	_getMost_backend_aptGetInstall libtool-bin

	_getMost_backend_aptGetInstall libgtk2.0-dev

	_getMost_backend_aptGetInstall libxss-dev
	_getMost_backend_aptGetInstall intltool
	_getMost_backend_aptGetInstall libgts-dev
	_getMost_backend_aptGetInstall libdbus-1-dev
	_getMost_backend_aptGetInstall libglu1-mesa-dev
	_getMost_backend_aptGetInstall libgtkglext1-dev
	_getMost_backend_aptGetInstall libgd-dev

	_getMost_backend_aptGetInstall libxcb-screensaver0-dev

	_getMost_backend_aptGetInstall desktop-file-utils

	
	_getMost_backend_aptGetInstall okular
	_getMost_backend_aptGetInstall libreoffice
	_getMost_backend_aptGetInstall firefox-esr
	_getMost_backend_aptGetInstall xournal
	_getMost_backend_aptGetInstall kwrite
	_getMost_backend_aptGetInstall netcat-openbsd
	_getMost_backend_aptGetInstall iperf
	_getMost_backend_aptGetInstall axel
	_getMost_backend_aptGetInstall aria2
	_getMost_backend_aptGetInstall unionfs-fuse
	_getMost_backend_aptGetInstall samba
	
	_getMost_backend_aptGetInstall dia
	
	_getMost_backend_aptGetInstall libcups2-dev

	_getMost_backend_aptGetInstall gimp
	_getMost_backend_aptGetInstall gimp-data-extras
	
	_getMost_backend_aptGetInstall aria2
	
	_getMost_backend_aptGetInstall qemu
	_getMost_backend_aptGetInstall qemu-system-x86
	_getMost_backend_aptGetInstall qemu-system-arm
	_getMost_backend_aptGetInstall qemu-efi-arm qemu-efi-aarch64 qemu-user-static qemu-utils
	_getMost_backend_aptGetInstall dosbox
	_getMost_backend_aptGetInstall wine wine32 wine64 libwine libwine:i386 fonts-wine
	_getMost_backend_aptGetInstall debootstrap xclip xinput gparted bup emacs xterm mesa-utils
	_getMost_backend_aptGetInstall kde-standard
	_getMost_backend_aptGetInstall chromium
	_getMost_backend_aptGetInstall openjdk-11-jdk openjdk-11-jre
	
	_getMost_backend_aptGetInstall openjdk-17-jdk openjdk-17-jre


	_getMost_backend_aptGetInstall vainfo
	_getMost_backend_aptGetInstall mesa-va-drivers
	_getMost_backend_aptGetInstall ffmpeg


	_getMost_backend_aptGetInstall gstreamer1.0-tools

	# ATTENTION: From analysis .
	#_getMost_backend_aptGetInstall gstreamer1.0-plugins-good


	_getMost_backend_aptGetInstall vdpau-driver-all
	_getMost_backend_aptGetInstall va-driver-all
	#_getMost_backend_aptGetInstall mesa-va-drivers
	_getMost_backend_aptGetInstall mesa-vdpau-drivers

	_getMost_backend_aptGetInstall libva-drm2
	_getMost_backend_aptGetInstall libva-x11-2
	_getMost_backend_aptGetInstall libva2
	_getMost_backend_aptGetInstall libvdpau-va-gl1
	_getMost_backend_aptGetInstall libvdpau1
	_getMost_backend_aptGetInstall libvpx7

	_getMost_backend_aptGetInstall libxv1
	

	_getMost_backend_aptGetInstall xvfb

	# terminal-serial: agetty, screen, resize
	_getMost_backend_aptGetInstall util-linux
	_getMost_backend_aptGetInstall screen
	_getMost_backend_aptGetInstall xterm
	
	#_getMost_backend_aptGetInstall original-awk
	_getMost_backend_aptGetInstall gawk
	
	_getMost_backend_aptGetInstall build-essential
	_getMost_backend_aptGetInstall flex
	_getMost_backend_aptGetInstall libelf-dev
	_getMost_backend_aptGetInstall libncurses-dev
	_getMost_backend_aptGetInstall autoconf
	_getMost_backend_aptGetInstall libudev-dev

	_getMost_backend_aptGetInstall imagemagick
	_getMost_backend_aptGetInstall graphicsmagick-imagemagick-compat

	_getMost_backend_aptGetInstall dwarves
	_getMost_backend_aptGetInstall pahole

	_getMost_backend_aptGetInstall cmake
	
	
	_getMost_backend_aptGetInstall gh
	
	
	
	_getMost_backend_aptGetInstall haskell-platform
	_getMost_backend_aptGetInstall pkg-haskell-tools
	_getMost_backend_aptGetInstall alex
	_getMost_backend_aptGetInstall cabal-install
	_getMost_backend_aptGetInstall happy
	_getMost_backend_aptGetInstall hscolour
	_getMost_backend_aptGetInstall ghc


	_getMost_backend_aptGetInstall libusb-dev
	_getMost_backend_aptGetInstall avrdude
	_getMost_backend_aptGetInstall gcc-avr
	_getMost_backend_aptGetInstall binutils-avr
	_getMost_backend_aptGetInstall avr-libc
	_getMost_backend_aptGetInstall stm32flash
	_getMost_backend_aptGetInstall dfu-util
	_getMost_backend_aptGetInstall libnewlib-arm-none-eabi
	_getMost_backend_aptGetInstall gcc-arm-none-eabi
	_getMost_backend_aptGetInstall binutils-arm-none-eabi
	_getMost_backend_aptGetInstall libusb-1.0
	
	_getMost_backend_aptGetInstall setserial

	_getMost_backend_aptGetInstall virtualenv
	_getMost_backend_aptGetInstall python3-dev
	_getMost_backend_aptGetInstall libffi-dev
	#_getMost_backend_aptGetInstall build-essential
	#_getMost_backend_aptGetInstall libncurses-dev
	#_getMost_backend_aptGetInstall libusb-dev
	#_getMost_backend_aptGetInstall avrdude
	#_getMost_backend_aptGetInstall gcc-avr
	#_getMost_backend_aptGetInstall binutils-avr
	#_getMost_backend_aptGetInstall avr-libc
	#_getMost_backend_aptGetInstall stm32flash
	#_getMost_backend_aptGetInstall libnewlib-arm-none-eabi
	#_getMost_backend_aptGetInstall gcc-arm-none-eabi
	#_getMost_backend_aptGetInstall binutils-arm-none-eabi
	#_getMost_backend_aptGetInstall libusb-1.0
	_getMost_backend_aptGetInstall libusb-1.0-0
	_getMost_backend_aptGetInstall libusb-1.0-0-dev
	_getMost_backend_aptGetInstall libusb-1.0-doc
	_getMost_backend_aptGetInstall pkg-config
	#_getMost_backend_aptGetInstall dfu-util
	
	_getMost_backend_aptGetInstall crudini
	_getMost_backend_aptGetInstall bsdutils
	_getMost_backend_aptGetInstall findutils
	_getMost_backend_aptGetInstall v4l-utils
	_getMost_backend_aptGetInstall libevent-dev
	_getMost_backend_aptGetInstall libjpeg-dev
	_getMost_backend_aptGetInstall libbsd-dev

	_getMost_backend_aptGetInstall libusb-1.0



	_getMost_backend_aptGetInstall ddd
	_getMost_backend_aptGetInstall gdb
	_getMost_backend_aptGetInstall libbabeltrace1
	_getMost_backend_aptGetInstall libc6-dbg
	_getMost_backend_aptGetInstall libsource-highlight-common
	_getMost_backend_aptGetInstall libsource-highlight4v5


	
	# ATTENTION: ONLY change (eg. to 'remove') if needed to ensure a kernel is installed AND custom kernel is not in use.
	_getMost_backend_aptGetInstall linux-image-amd64
	
	if [[ "$chrootName" == "" ]] && [[ "$getMost_backend" != "chroot" ]] && [[ "$CI" == "" ]]
	then
		_getMost_backend_aptGetInstall linux-headers-$(uname -r)
	fi

	_getMost_backend_aptGetInstall initramfs-tools
	
	_getMost_backend_aptGetInstall net-tools wireless-tools rfkill
	
	_getMost_backend_aptGetInstall dmidecode
	
	
	_getMost_backend_aptGetInstall p7zip
	_getMost_backend_aptGetInstall p7zip-full
	_getMost_backend_aptGetInstall unzip zip
	_getMost_backend_aptGetInstall lbzip2

	
	_getMost_backend_aptGetInstall jp2a
	
	
	
	_getMost_backend_aptGetInstall open-vm-tools-desktop
	
	#_getMost_backend_aptGetInstall virtualbox-guest-utils
	#_getMost_backend_aptGetInstall virtualbox-guest-x11
	
	
	
	# ATTENTION: ATTENTION: WARNING: CAUTION: DANGER: High maintenance. Expect to break and manually update frequently!
	#_getMost_backend wget -qO- 'https://download.virtualbox.org/virtualbox/6.1.34/VBoxGuestAdditions_6.1.34.iso' | _getMost_backend tee /VBoxGuestAdditions.iso > /dev/null
	#_getMost_backend wget -qO- 'https://download.virtualbox.org/virtualbox/7.0.10/VBoxGuestAdditions_7.0.10.iso' | _getMost_backend tee /VBoxGuestAdditions.iso > /dev/null
	_getMost_backend wget -qO- 'https://download.virtualbox.org/virtualbox/7.1.4/VBoxGuestAdditions_7.1.4.iso' | _getMost_backend tee /VBoxGuestAdditions.iso > /dev/null
	_getMost_backend 7z x /VBoxGuestAdditions.iso -o/VBoxGuestAdditions -aoa -y
	_getMost_backend rm -f /VBoxGuestAdditions.iso
	_getMost_backend chmod u+x /VBoxGuestAdditions/VBoxLinuxAdditions.run
	
	# https://forums.virtualbox.org/viewtopic.php?t=112770
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT kvm.enable_virt_at_load=0"' | _getMost_backend tee ""/etc/default/grub.d/99_vbox_kvm_compatibility.cfg


	
	# From '/var/log/vboxadd-*' , 'shared folder support module' 'modprobe vboxguest failed'
	# Due to 'rcvboxadd setup' and/or 'rcvboxadd quicksetup all' apparently ceasing to build subsequent modules (ie. 'vboxsf') after any error (ie. due to 'modprobe' failing unless VirtualBox virtual hardware is present).
	_getMost_backend mv -n /sbin/modprobe /sbin/modprobe.real
	_getMost_backend ln -s /bin/true /sbin/modprobe
	
	_getMost_backend /VBoxGuestAdditions/VBoxLinuxAdditions.run
	_getMost_backend /sbin/rcvboxadd quicksetup all
	_getMost_backend /sbin/rcvboxadd setup
	_getMost_backend /sbin/rcvboxadd quicksetup all
	#_getMost_backend /sbin/rcvboxadd setup

	_getMost_backend /sbin/rcvboxadd quicksetup $(_getMost_backend cat /boot/grub/grub.cfg 2>/dev/null | awk -F\' '/menuentry / {print $2}' | grep -v "Advanced options" | grep 'Linux [0-9]' | sed 's/ (.*//' | awk '{print $NF}' | head -n1)
	
	_getMost_backend rm -f /sbin/modprobe
	_getMost_backend mv -f /sbin/modprobe.real /sbin/modprobe
	
	
	
	
	# https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/install-linux-host.html
	echo 'virtualbox virtualbox/module-compilation-allowed boolean true
	virtualbox virtualbox/delete-old-modules boolean true' | _getMost_backend debconf-set-selections
	
	if false && !  [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		# WARNING: Untested. May be old version of VirtualBox. May conflict with guest additions.
		#_getMost_backend_aptGetInstall virtualbox-6.1
		_getMost_backend apt-get -d install -y virtualbox-6.1
	fi

		
	# WARNING: May be untested. May cause problems.
	#_getMost_backend_aptGetInstall docker-ce
	##_getMost_backend_aptGetInstall docker-compose-plugin
	#_getMost_backend_aptGetInstall docker-ce
	#_getMost_backend_aptGetInstall docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras
	_getMost_backend apt-get -d install -y docker-ce
	#_getMost_backend apt-get -d install -y docker-compose-plugin
	_getMost_backend apt-get -d install -y docker-ce
	#_getMost_backend apt-get -d install -y docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras

	# ATTENTION: Speculative . May be untested. Enable if ever necessary.
	#https://docs.docker.com/compose/install/
	#https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
	#if ! _getMost_backend type docker-compose > /dev/null 2>&1
	#then
		#mkdir -p /usr/local/lib/docker/cli-plugins/docker-compose
		#curl -SL https://github.com/docker/compose/releases/download/v2.32.2/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
		#chmod 755 /usr/local/lib/docker/cli-plugins/docker-compose
	#fi
	
	
	# WARNING: If VirtualBox was not installed by now (eg. due to 'if false' comment block or wrong distribution), this must be called later.
	# https://en.wiktionary.org/wiki/poke_the_bear
	# https://forums.virtualbox.org/viewtopic.php?t=25797
	_getMost_backend /usr/bin/VBoxManage setextradata global GUI/SuppressMessages "Update"
	_getMost_backend /usr/local/bin/VBoxManage setextradata global GUI/SuppressMessages "Update"
	
	
	
	# WARNING: Untested. May incorrectly remove supposedly 'old' kernel versions.
	#_getMost_backend apt-get autoremove -y
	
	
	# WARNING: Strongly discouraged here.
	#sudo -n rm -f "$globalVirtFS"/ubtest.sh > /dev/null 2>&1
	#sudo -n cp "$scriptAbsoluteLocation" "$globalVirtFS"/ubtest.sh
	#_getMost_backend /ubtest.sh _test
	

	_getMost_backend_aptGetInstall dnsutils
	_getMost_backend_aptGetInstall bind9-dnsutils

	
	_getMost_backend_aptGetInstall live-boot
	#_getMost_backend_aptGetInstall pigz
	
	_getMost_backend_aptGetInstall falkon
	_getMost_backend_aptGetInstall konqueror
	
	_getMost_backend_aptGetInstall xserver-xorg-video-all
	_getMost_backend_aptGetInstall xserver-xorg-video-amdgpu
	
	_getMost_backend_aptGetInstall qalculate-gtk
	_getMost_backend_aptGetInstall qalc
	
	# CAUTION: Workaround. Debian defaults to an obsolete version of qalc which is unusable.
	_getMost_backend_aptGetInstall -t bullseye-backports qalc
	
	
	
	_getMost_backend_aptGetInstall octave
	_getMost_backend_aptGetInstall octave-arduino
	_getMost_backend_aptGetInstall octave-bart
	_getMost_backend_aptGetInstall octave-bim
	_getMost_backend_aptGetInstall octave-biosig
	_getMost_backend_aptGetInstall octave-bsltl
	_getMost_backend_aptGetInstall octave-cgi
	_getMost_backend_aptGetInstall octave-communications
	_getMost_backend_aptGetInstall octave-control
	_getMost_backend_aptGetInstall octave-data-smoothing
	_getMost_backend_aptGetInstall octave-dataframe
	_getMost_backend_aptGetInstall octave-dicom
	_getMost_backend_aptGetInstall octave-divand
	_getMost_backend_aptGetInstall octave-econometrics
	_getMost_backend_aptGetInstall octave-financial
	_getMost_backend_aptGetInstall octave-fits
	_getMost_backend_aptGetInstall octave-fuzzy-logic-toolkit
	_getMost_backend_aptGetInstall octave-ga
	_getMost_backend_aptGetInstall octave-gdf
	_getMost_backend_aptGetInstall octave-geometry
	_getMost_backend_aptGetInstall octave-gsl
	_getMost_backend_aptGetInstall octave-image
	_getMost_backend_aptGetInstall octave-image-acquisition
	_getMost_backend_aptGetInstall octave-instrument-control
	_getMost_backend_aptGetInstall octave-interval
	_getMost_backend_aptGetInstall octave-io
	_getMost_backend_aptGetInstall octave-level-set
	_getMost_backend_aptGetInstall octave-linear-algebra
	_getMost_backend_aptGetInstall octave-lssa
	#_getMost_backend_aptGetInstall octave-ltfat
	_getMost_backend_aptGetInstall octave-mapping
	_getMost_backend_aptGetInstall octave-miscellaneous
	_getMost_backend_aptGetInstall octave-missing-functions
	#_getMost_backend_aptGetInstall octave-mpi
	_getMost_backend_aptGetInstall octave-msh
	_getMost_backend_aptGetInstall octave-mvn
	_getMost_backend_aptGetInstall octave-nan
	_getMost_backend_aptGetInstall octave-ncarry
	_getMost_backend_aptGetInstall octave-netcdf
	_getMost_backend_aptGetInstall octave-nlopt
	_getMost_backend_aptGetInstall octave-nurbs
	_getMost_backend_aptGetInstall octave-octclip
	_getMost_backend_aptGetInstall octave-octproj
	_getMost_backend_aptGetInstall octave-openems
	_getMost_backend_aptGetInstall octave-optics
	_getMost_backend_aptGetInstall octave-optim
	_getMost_backend_aptGetInstall octave-optiminterp
	_getMost_backend_aptGetInstall octave-parallel
	_getMost_backend_aptGetInstall octave-pfstools
	_getMost_backend_aptGetInstall octave-plplot
	_getMost_backend_aptGetInstall octave-psychtoolbox-3
	_getMost_backend_aptGetInstall octave-quarternion
	_getMost_backend_aptGetInstall octave-queueing
	_getMost_backend_aptGetInstall octave-secs1d
	_getMost_backend_aptGetInstall octave-secs2d
	_getMost_backend_aptGetInstall octave-secs3d
	_getMost_backend_aptGetInstall octave-signal
	_getMost_backend_aptGetInstall octave-sockets
	_getMost_backend_aptGetInstall octave-sparsersb
	_getMost_backend_aptGetInstall octave-specfun
	_getMost_backend_aptGetInstall octave-splines
	_getMost_backend_aptGetInstall octave-stk
	_getMost_backend_aptGetInstall octave-strings
	_getMost_backend_aptGetInstall octave-struct
	_getMost_backend_aptGetInstall octave-symbolic
	_getMost_backend_aptGetInstall octave-tsa
	_getMost_backend_aptGetInstall octave-vibes
	_getMost_backend_aptGetInstall octave-vlfeat
	_getMost_backend_aptGetInstall octave-rml
	_getMost_backend_aptGetInstall octave-zenity
	_getMost_backend_aptGetInstall octave-zeromq
	
	
	_getMost_backend_aptGetInstall mktorrent
	_getMost_backend_aptGetInstall curl
	_getMost_backend_aptGetInstall gdisk
	_getMost_backend_aptGetInstall kate
	_getMost_backend_aptGetInstall kde-config-tablet
	_getMost_backend_aptGetInstall kwrite
	_getMost_backend_aptGetInstall lz4
	_getMost_backend_aptGetInstall mawk
	_getMost_backend_aptGetInstall nano
	_getMost_backend_aptGetInstall nilfs-tools

	_getMost_backend_aptGetInstall jq
	
	_getMost_backend_aptGetInstall build-essential
	_getMost_backend_aptGetInstall bison
	_getMost_backend_aptGetInstall libelf-dev
	_getMost_backend_aptGetInstall elfutils
	
	_getMost_backend_aptGetInstall patch
	
	_getMost_backend_aptGetInstall tar
	_getMost_backend_aptGetInstall xz
	_getMost_backend_aptGetInstall gzip
	_getMost_backend_aptGetInstall bzip2
	
	_getMost_backend_aptGetInstall librecode0
	_getMost_backend_aptGetInstall wkhtmltopdf
	
	_getMost_backend_aptGetInstall recoll
	_getMost_backend_aptGetInstall sed
	_getMost_backend_aptGetInstall texinfo
	_getMost_backend_aptGetInstall udftools
	_getMost_backend_aptGetInstall wondershaper
	_getMost_backend_aptGetInstall sddm
	_getMost_backend_aptGetInstall task-kde-desktop
	
	
	_getMost_backend_aptGetInstall kdiff3
	_getMost_backend_aptGetInstall pstoedit
	_getMost_backend_aptGetInstall pdftk
	
	_getMost_backend_aptGetInstall sysbench
	
	_getMost_backend_aptGetInstall libssl-dev
	
	
	_getMost_backend_aptGetInstall cpio
	
	
	_getMost_backend_aptGetInstall pv
	_getMost_backend_aptGetInstall expect
	
	_getMost_backend_aptGetInstall libfuse2
	
	_getMost_backend_aptGetInstall libgtk2.0-0
	
	_getMost_backend_aptGetInstall libwxgtk3.0-gtk3-0v5
	
	_getMost_backend_aptGetInstall wipe
	
	_getMost_backend_aptGetInstall udftools
	
	
	
	_getMost_backend_aptGetInstall iputils-ping
	
	_getMost_backend_aptGetInstall btrfs-tools
	_getMost_backend_aptGetInstall btrfs-progs
	_getMost_backend_aptGetInstall btrfs-compsize
	_getMost_backend_aptGetInstall zstd
	
	_getMost_backend_aptGetInstall zlib1g
	
	_getMost_backend_aptGetInstall nilfs-tools
	
	
	
	# md5sum , sha512sum
	_getMost_backend_aptGetInstall coreutils
	
	_getMost_backend_aptGetInstall python3
	_getMost_backend_aptGetInstall python3.11-venv
	_getMost_backend_aptGetInstall python3-serial

	#_getMost_backend_aptGetInstall python3-websocket
	
	
	# blkdiscard
	_getMost_backend_aptGetInstall util-linux
	
	# sg_format
	_getMost_backend_aptGetInstall sg3-utils
	
	_getMost_backend_aptGetInstall kpartx
	
	_getMost_backend_aptGetInstall openssl
	
	_getMost_backend_aptGetInstall growisofs
	
	_getMost_backend_aptGetInstall udev
	
	_getMost_backend_aptGetInstall gdisk
	
	_getMost_backend_aptGetInstall cryptsetup
	
	_getMost_backend_aptGetInstall util-linux
	
	_getMost_backend_aptGetInstall parted
	
	_getMost_backend_aptGetInstall bc
	
	_getMost_backend_aptGetInstall e2fsprogs
	
	_getMost_backend_aptGetInstall xz-utils
	
	_getMost_backend_aptGetInstall libreadline8
	_getMost_backend_aptGetInstall libreadline-dev
	
	
	_getMost_backend_aptGetInstall mkisofs
	_getMost_backend_aptGetInstall genisoimage
	
	
	_getMost_backend_aptGetInstall wodim
	
	_getMost_backend_aptGetInstall eject
	
	
	
	
	
	_getMost_backend_aptGetInstall hdparm
	_getMost_backend_aptGetInstall sdparm
	
	
	
	
	
	_getMost_backend_aptGetInstall php
	
	
	
	
	
	_getMost_backend_aptGetInstall synaptic
	
	_getMost_backend_aptGetInstall cifs-utils


	_getMost_backend_aptGetInstall debhelper
	
	_getMost_backend_aptGetInstall p7zip
	_getMost_backend_aptGetInstall p7zip-full
	_getMost_backend_aptGetInstall nsis

	_getMost_backend_aptGetInstall dos2unix


	_getMost_backend_aptGetInstall xxd
	
	
	# Sometimes may be useful as a workaround for docker 'overlay2' 'storage-driver' .
	_getMost_backend_aptGetInstall fuse-overlayfs
	
	
	
	# purge-old-kernels
	_getMost_backend_aptGetInstall byobu
	
	
	
	
	_getMost_backend_aptGetInstall xorriso
	_getMost_backend_aptGetInstall squashfs-tools
	_getMost_backend_aptGetInstall grub-pc-bin
	_getMost_backend_aptGetInstall grub-efi-amd64-bin
	_getMost_backend_aptGetInstall mtools
	_getMost_backend_aptGetInstall mksquashfs
	_getMost_backend_aptGetInstall grub-mkstandalone
	_getMost_backend_aptGetInstall mkfs.vfat
	_getMost_backend_aptGetInstall dosfstools
	_getMost_backend_aptGetInstall mkswap
	_getMost_backend_aptGetInstall mmd
	_getMost_backend_aptGetInstall mcopy
	_getMost_backend_aptGetInstall fdisk
	_getMost_backend_aptGetInstall mkswap
	
	
	
	
	
	
	_messagePlain_probe _getMost_backend curl croc
	if ! _getMost_backend type croc > /dev/null 2>&1
	then
		_getMost_backend curl https://getcroc.schollz.com | _getMost_backend bash
	fi
	
	
	
	_getMost_backend_aptGetInstall iotop
	
	_getMost_backend_aptGetInstall latencytop
	
	
	_getMost_backend_aptGetInstall lsof
	
	
	
	#_getMost_backend_aptGetInstall nvflash
	
	_getMost_backend_aptGetInstall usbutils
	
	_getMost_backend_aptGetInstall lm-sensors
	_getMost_backend_aptGetInstall hddtemp
	_getMost_backend_aptGetInstall aptitude
	_getMost_backend_aptGetInstall recode
	_getMost_backend_aptGetInstall asciidoc
	
	_getMost_backend_aptGetInstall pandoc
	_getMost_backend_aptGetInstall texlive-xetex
	_getMost_backend_aptGetInstall texlive-latex-recommended
	_getMost_backend_aptGetInstall texlive-latex-extra
	_getMost_backend_aptGetInstall fonts-texgyre
	_getMost_backend_aptGetInstall fonts-texgyre-math
	_getMost_backend_aptGetInstall tex-gyre
	_getMost_backend_aptGetInstall texlive-fonts-recommended
	
	_getMost_backend_aptGetInstall asciinema
	_getMost_backend_aptGetInstall gifsicle imagemagick apngasm ffmpeg
	_getMost_backend_aptGetInstall webp

	_getMost_backend_aptGetInstall ansifilter
	_getMost_backend_aptGetInstall ansifilter-gui
	
	
	
	_getMost_backend_aptGetInstall pavucontrol
	_getMost_backend_aptGetInstall filelight
	
	_getMost_backend_aptGetInstall obs-studio
	
	
	_getMost_backend_aptGetInstall lepton-eda
	_getMost_backend_aptGetInstall pcb
	_getMost_backend_aptGetInstall pcb-rnd
	_getMost_backend_aptGetInstall gerbv
	_getMost_backend_aptGetInstall electronics-pcb
	_getMost_backend_aptGetInstall pcb2gcode
	
	_getMost_backend_aptGetInstall inkscape
	_getMost_backend_aptGetInstall libgdl-3-5
	_getMost_backend_aptGetInstall libgdl-3-common
	_getMost_backend_aptGetInstall libgtkspell3-3-0
	_getMost_backend_aptGetInstall libimage-magick-perl
	_getMost_backend_aptGetInstall libimage-magick-q16-perl
	_getMost_backend_aptGetInstall libpotrace0
	_getMost_backend_aptGetInstall libwmf-bin
	_getMost_backend_aptGetInstall python3-scour
	
	
	_getMost_backend_aptGetInstall kicad
	
	_getMost_backend_aptGetInstall electric
	
	
	
	_getMost_backend python -m pip install --upgrade pip
	_getMost_backend sudo -n pip install --upgrade pip
	
	_getMost_backend_aptGetInstall freecad
	
	
	_getMost_backend_aptGetInstall audacity
	
	
	_getMost_backend_aptGetInstall w3m


	_getMost_backend_aptGetInstall xclip

	_getMost_backend_aptGetInstall tcl
	_getMost_backend_aptGetInstall tk

	_getMost_backend_aptGetInstall xserver-xephyr


	_getMost_backend_aptGetInstall qt5-style-plugins
	_getMost_backend_aptGetInstall qt5ct



	_getMost_backend_aptGetInstall fldigi
	_getMost_backend_aptGetInstall flamp
	_getMost_backend_aptGetInstall psk31lx


	_getMost_backend_aptGetInstall zip
	_getMost_backend_aptGetInstall unzip
	
	_getMost_backend_aptGetInstall par2
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	
	_getMost_backend_aptGetInstall yubikey-manager
	


	_getMost_backend_aptGetInstall tboot

	_getMost_backend_aptGetInstall trousers
	_getMost_backend_aptGetInstall tpm-tools
	_getMost_backend_aptGetInstall trousers-dbg
	
	
	
	_getMost_backend_aptGetInstall scdaemon
	
	_getMost_backend_aptGetInstall tpm2-openssl
	_getMost_backend_aptGetInstall tpm2-openssl tpm2-tools tpm2-abrmd libtss2-tcti-tabrmd0
	
	_getMost_backend_aptGetInstall tpm2-abrmd
	
	
	
	_getMost_backend_aptGetInstall qrencode
	
	_getMost_backend_aptGetInstall qtqr
	
	_getMost_backend_aptGetInstall zbar-tools
	_getMost_backend_aptGetInstall zbarcam-gtk
	_getMost_backend_aptGetInstall zbarcam-qt
	
	
	_getMost_backend_aptGetInstall cloud-guest-utils




	
	
	_getMost_backend_aptGetInstall python3-piexif
	

	_getMost_backend_aptGetInstall python3-torch
	_getMost_backend_aptGetInstall python3-torchaudio
	_getMost_backend_aptGetInstall python3-torchtext
	_getMost_backend_aptGetInstall python3-torchvision
	
	
	
	_getMost_debian11_special_late
}

# ATTENTION: End user function.
_getMost_debian12() {
	_messagePlain_probe 'begin: _getMost_debian12'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_debian12_aptSources "$@"
	
	_getMost_debian12_install "$@"



	_here_opensslConfig_legacy | _getMost_backend tee /etc/ssl/openssl_legacy.cnf > /dev/null 2>&1

    if ! _getMost_backend grep 'openssl_legacy' /etc/ssl/openssl.cnf > /dev/null 2>&1
    then
        _getMost_backend cp -f /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.orig
        echo '


.include = /etc/ssl/openssl_legacy.cnf

' | _getMost_backend cat /etc/ssl/openssl.cnf.orig - | _getMost_backend tee /etc/ssl/openssl.cnf > /dev/null 2>&1
    fi
	
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	_messagePlain_probe 'end: _getMost_debian12'
}

# ATTENTION: End user function.
_getMost_debian11() {
	_messagePlain_probe 'begin: _getMost_debian11'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_debian11_aptSources "$@"
	
	_getMost_debian11_install "$@"
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	_messagePlain_probe 'end: _getMost_debian11'
}




_getMost_ubuntu24_aptSources() {
	## May be an image copied while dpkg was locked. Especially if 'chroot'.
	#_getMost_backend rm -f /var/lib/apt/lists/lock
	#_getMost_backend rm -f /var/lib/dpkg/lock
	
	
	#_getMost_backend_aptGetInstall wget
	#_getMost_backend_aptGetInstall gpg
	
	
	#_getMost_backend mkdir -p /etc/apt/sources.list.d
	#echo 'deb http://download.virtualbox.org/virtualbox/debian focal contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
	#echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	
	#_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
	#_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
	
	#_getMost_debian11_aptSources "$@"
	_getMost_debian12_aptSources "$@"
}
_getMost_ubuntu22_aptSources() {
	## May be an image copied while dpkg was locked. Especially if 'chroot'.
	#_getMost_backend rm -f /var/lib/apt/lists/lock
	#_getMost_backend rm -f /var/lib/dpkg/lock
	
	
	#_getMost_backend_aptGetInstall wget
	#_getMost_backend_aptGetInstall gpg
	
	
	#_getMost_backend mkdir -p /etc/apt/sources.list.d
	#echo 'deb http://download.virtualbox.org/virtualbox/debian focal contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
	#echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	
	#_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
	#_getMost_backend wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
	
	_getMost_debian11_aptSources "$@"
}
_getMost_ubuntu24_install() {
	_getMost_debian12_install "$@"
	
	# WARNING: Untested. May be old version of VirtualBox. May conflict with guest additions.
	#_getMost_backend_aptGetInstall virtualbox-6.1
	#_getMost_backend apt-get -d install -y virtualbox-6.1
	_getMost_backend apt-get -d install -y virtualbox-7.1
	
	
	# WARNING: Untested. May cause problems.
	#_getMost_backend_aptGetInstall docker-ce
	_getMost_backend apt-get -d install -y docker-ce
	
	_getMost_backend_aptGetInstall tasksel
	_getMost_backend_aptGetInstall kde-plasma-desktop
	
	#_getMost_backend tasksel --new-install install "ubuntu-desktop"
	#_wait_debianInstall
	_getMost_backend_aptGetInstall ubuntu-desktop
}
_getMost_ubuntu22_install() {
	_getMost_debian11_install "$@"
	
	# WARNING: Untested. May be old version of VirtualBox. May conflict with guest additions.
	#_getMost_backend_aptGetInstall virtualbox-6.1
	_getMost_backend apt-get -d install -y virtualbox-6.1
	
	
	# WARNING: Untested. May cause problems.
	#_getMost_backend_aptGetInstall docker-ce
	_getMost_backend apt-get -d install -y docker-ce
	
	_getMost_backend_aptGetInstall tasksel
	_getMost_backend_aptGetInstall kde-plasma-desktop
	
	#_getMost_backend tasksel --new-install install "ubuntu-desktop"
	#_wait_debianInstall
	_getMost_backend_aptGetInstall ubuntu-desktop
}

# ATTENTION: End user function.
_getMost_ubuntu24() {
	_messagePlain_probe 'begin: _getMost_ubuntu24'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_ubuntu24_aptSources "$@"
	
	_getMost_ubuntu24_install "$@"
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	_messagePlain_probe 'end: _getMost_ubuntu24'
}
_getMost_ubuntu22() {
	_messagePlain_probe 'begin: _getMost_ubuntu22'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_ubuntu22_aptSources "$@"
	
	_getMost_ubuntu22_install "$@"
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	_messagePlain_probe 'end: _getMost_ubuntu22'
}

# ATTENTION: Cloud 'end user' function.
_getMost_ubuntu24-VBoxManage() {
	_messagePlain_probe 'begin: _getMost_ubuntu24-VBoxManage'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_ubuntu24_aptSources "$@"
	
	#_getMost_ubuntu24_install "$@"
	#_getMost_backend apt-get -d install -y virtualbox-6.1
	#_getMost_backend apt-get -d install -y virtualbox-7.0
	_getMost_backend apt-get -d install -y virtualbox-7.1
	
	#_getMost_backend_aptGetInstall virtualbox-7.0
	_getMost_backend_aptGetInstall virtualbox-7.1
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	_getMost_backend apt-get -y clean
	
	
	_messagePlain_probe 'end: _getMost_ubuntu24-VBoxManage'
}
_getMost_ubuntu22-VBoxManage() {
	_messagePlain_probe 'begin: _getMost_ubuntu22-VBoxManage'
	
	_set_getMost_backend "$@"
	_set_getMost_backend_debian "$@"
	_test_getMost_backend "$@"
	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | _getMost_backend tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | _getMost_backend tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	
	_getMost_ubuntu22_aptSources "$@"
	
	#_getMost_ubuntu22_install "$@"
	#_getMost_backend apt-get -d install -y virtualbox-6.1
	#_getMost_backend apt-get -d install -y virtualbox-7.0
	_getMost_backend apt-get -d install -y virtualbox-7.1
	
	#_getMost_backend_aptGetInstall virtualbox-7.0
	_getMost_backend_aptGetInstall virtualbox-7.1
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	_getMost_backend apt-get -y clean
	
	
	_messagePlain_probe 'end: _getMost_ubuntu22-VBoxManage'
}



# ATTENTION: Override with 'ops.sh' or similar .
# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
_set_getMost_backend_debian() {
	_getMost_backend_aptGetInstall() {
		# --no-upgrade
		# -o Dpkg::Options::="--force-confold"

		# ATTRIBUTION-AI: ChatGPT o1-preview 2024-11-20 .
		echo 'APT::AutoRemove::RecommendsImportant "true";
APT::AutoRemove::SuggestsImportant "true";' | _getMost_backend tee /etc/apt/apt.conf.d/99autoremove-recommends > /dev/null
		
		if ! _getMost_backend dash -c 'type apt-fast' > /dev/null 2>&1 || [[ "$RUNNER_OS" != "" ]]
		then
			_messagePlain_probe _getMost_backend env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
			_getMost_backend env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
		else
			#DOWNLOADBEFORE=true
			_messagePlain_probe _getMost_backend env DOWNLOADBEFORE=true XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-fast -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
			_getMost_backend env DOWNLOADBEFORE=true XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-fast -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
		fi
		
		#_messagePlain_probe _getMost_backend env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
		#_getMost_backend env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
	}
	
	#if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	#then
		#_getMost_backend_aptGetInstall() {
		## --no-upgrade
			#_messagePlain_probe _getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
			#_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
		#}
	#fi
	
	export -f _getMost_backend_aptGetInstall
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
	
	_set_getMost_backend_debian "$@"
}

# WARNING: Do NOT call from '_test' or similar.
_test_getMost_backend() {
	_getMost_backend false && _messagePlain_bad 'fail: incorrect: _getMost_backend false' && _messageFAIL && _stop 1
	! _getMost_backend true && _messagePlain_bad 'fail: incorrect: _getMost_backend true' && _messageFAIL && _stop 1
}


# WARNING: No production use. Installation commands may be called through 'chroot' or 'ssh' , expected as such not reasonably able to detect the OS distribution . User is expected to instead call the correct function with the correct configuration.
_getMost() {
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian' > /dev/null 2>&1 && [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 12 > /dev/null 2>&1
	then
		_tryExecFull _getMost_debian12 "$@"
		return
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian' > /dev/null 2>&1
	then
		_tryExecFull _getMost_debian11 "$@"
		return
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '24.04' > /dev/null 2>&1
	then
		_tryExecFull _getMost_ubuntu24 "$@"
		return
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		_tryExecFull _getMost_ubuntu22 "$@"
		return
	else
		_tryExecFull _getMost_debian12 "$@"
		return
	fi
	return 1
}










# ATTENTION: Override with 'ops.sh' or similar.
#./ubiquitous_bash.sh _getMost_backend true
#./ubiquitous_bash.sh _getMost_backend false
if [[ "$1" == "_getMost"* ]] && [[ "$ub_import" != "true" ]] && [[ "$objectName" == "ubiquitous_bash" ]] && ( ! type -f _getMost_backend > /dev/null 2>&1 || ! type -f _getMost_backend_fileExists > /dev/null 2>&1 || ! type -f _getMost_backend_aptGetInstall > /dev/null 2>&1 )
then
	_set_getMost_backend
fi
