
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
			if pgrep "^tasksel$" || pgrep "^apt-get$" || pgrep "^dpkg$" || ( fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || ( type -p sudo > /dev/null 2>&1 && sudo -n fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ) )
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
		echo 'deb http://download.virtualbox.org/virtualbox/debian bullseye contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | _getMost_backend apt-key add -
		echo 'deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable' | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '20.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb http://download.virtualbox.org/virtualbox/debian focal contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | _getMost_backend apt-key add -
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		echo "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	elif [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' | grep '22.04' > /dev/null 2>&1
	then
		true
		
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | _getMost_backend apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | _getMost_backend apt-key add -
		echo 'deb http://download.virtualbox.org/virtualbox/debian jammy contrib' | _getMost_backend tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | _getMost_backend apt-key add -
		_getMost_backend add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		echo "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | _getMost_backend tee /etc/apt/sources.list.d/ub_docker.list > /dev/null 2>&1
	fi
	
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | _getMost_backend apt-key add -
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

_getMost_debian11_install() {
	_messagePlain_probe 'apt-get update'
	_getMost_backend apt-get update
	
	
	_getMost_debian11_special_early
	
	
	
	
	_getMost_backend_aptGetInstall sudo
	_getMost_backend_aptGetInstall gpg
	_getMost_backend_aptGetInstall --reinstall wget
	
	
	_messagePlain_probe 'apt-get update'
	_getMost_backend apt-get update
	
	# DANGER: Requires expanded (raspi) image (ie. raspi image is too small by default)!
	# May be able to resize with some combination of 'dd' and 'gparted' , possibly '_gparted' . May be untested.
	#_messagePlain_probe 'apt-get upgrade'
	#_getMost_backend apt-get upgrade
	
	
	_getMost_backend_aptGetInstall locales-all
	
	
	if _getMost_backend_fileExists "/bup_0.29-3_amd64.deb"
	then
		_getMost_backend dpkg -i "/bup_0.29-3_amd64.deb"
		_getMost_backend rm -f /bup_0.29-3_amd64.deb
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get install -y -f
	fi
	
	_getMost_backend_aptGetInstall bup
	
	_getMost_backend_aptGetInstall bc autossh nmap socat sockstat rsync net-tools
	_getMost_backend_aptGetInstall bc nmap autossh socat sshfs tor
	_getMost_backend_aptGetInstall sockstat
	_getMost_backend_aptGetInstall x11-xserver-utils
	
	_getMost_backend_aptGetInstall uuid-runtime
	
	_getMost_backend_aptGetInstall tigervnc-viewer
	_getMost_backend_aptGetInstall x11vnc
	_getMost_backend_aptGetInstall tigervnc-standalone-server
	_getMost_backend_aptGetInstall tigervnc-scraping-server
	
	_getMost_backend_aptGetInstall iperf3
	
	#_getMost_backend_aptGetInstall synergy quicksynergy
	
	_getMost_backend_aptGetInstall vim
	
	if _getMost_backend bash -c '! dpkg --print-foreign-architectures | grep i386'
	then
		_getMost_backend dpkg --add-architecture i386
		_getMost_backend apt-get update
	fi
	_getMost_backend_aptGetInstall wmctrl xprintidle
	
	_getMost_backend_aptGetInstall okular
	_getMost_backend_aptGetInstall libreoffice
	_getMost_backend_aptGetInstall firefox-esr
	_getMost_backend_aptGetInstall xournal
	_getMost_backend_aptGetInstall kwrite
	_getMost_backend_aptGetInstall netcat-openbsd
	_getMost_backend_aptGetInstall iperf
	_getMost_backend_aptGetInstall axel
	_getMost_backend_aptGetInstall unionfs-fuse
	_getMost_backend_aptGetInstall samba
	
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
	
	# ATTENTION: ONLY uncomment if needed to ensure a kernel is installed AND custom kernel is not in use.
	_getMost_backend_aptGetInstall linux-image-amd64
	
	_getMost_backend_aptGetInstall net-tools wireless-tools rfkill
	
	
	# https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/install-linux-host.html
	echo 'virtualbox virtualbox/module-compilation-allowed boolean true
	virtualbox virtualbox/delete-old-modules boolean true' | sudo -n debconf-set-selections
	
	if false && !  [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		# WARNING: Untested. May be old version of VirtualBox. May conflict with guest additions.
		#_getMost_backend_aptGetInstall virtualbox-6.1
		_getMost_backend apt-get -d install -y virtualbox-6.1
		
		
		# WARNING: Untested. May cause problems.
		#_getMost_backend_aptGetInstall docker-ce
		_getMost_backend apt-get -d install -y docker-ce
	fi
	
	
	# WARNING: Untested. May incorrectly remove supposedly 'old' kernel versions.
	#_getMost_backend apt-get autoremove -y
	
	
	# WARNING: Strongly discouraged here.
	#sudo -n rm -f "$globalVirtFS"/ubtest.sh > /dev/null 2>&1
	#sudo -n cp "$scriptAbsoluteLocation" "$globalVirtFS"/ubtest.sh
	#_getMost_backend /ubtest.sh _test
	
	
	_getMost_backend_aptGetInstall live-boot
	_getMost_backend_aptGetInstall pigz
	
	_getMost_backend_aptGetInstall falkon
	_getMost_backend_aptGetInstall konqueror
	
	_getMost_backend_aptGetInstall xserver-xorg-video-all
	
	_getMost_backend_aptGetInstall qalculate-gtk
	_getMost_backend_aptGetInstall qalc
	
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
	_getMost_backend_aptGetInstall octave-ltfat
	_getMost_backend_aptGetInstall octave-mapping
	_getMost_backend_aptGetInstall octave-miscellaneous
	_getMost_backend_aptGetInstall octave-missing-functions
	_getMost_backend_aptGetInstall octave-mpi
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
	
	_getMost_backend_aptGetInstall build-essential
	_getMost_backend_aptGetInstall bison
	_getMost_backend_aptGetInstall libelf-dev
	_getMost_backend_aptGetInstall elfutils
	
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
	
	
	_getMost_backend_aptGetInstall mkisofs
	_getMost_backend_aptGetInstall genisoimage
	
	
	
	_getMost_backend_aptGetInstall synaptic
	
	_getMost_backend_aptGetInstall cifs-utils
	
	
	
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
	
	
	_getMost_backend_aptGetInstall pavucontrol
	_getMost_backend_aptGetInstall filelight
	
	_getMost_backend_aptGetInstall obs-studio
	
	
	
	_getMost_backend_aptGetInstall lepton-eda
	_getMost_backend_aptGetInstall pcb
	_getMost_backend_aptGetInstall pcb-rnd
	_getMost_backend_aptGetInstall gerbv
	_getMost_backend_aptGetInstall electronics-pcb
	_getMost_backend_aptGetInstall pcb2gcode
	
	_getMost_backend_aptGetInstall kicad
	
	_getMost_backend_aptGetInstall electric
	
	_getMost_backend_aptGetInstall freecad
	
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover
	
	
	_getMost_debian11_special_late
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





# ATTENTION: Override with 'ops.sh' or similar .
# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
_set_getMost_backend_debian() {
	_getMost_backend_aptGetInstall() {
		# --no-upgrade
		_messagePlain_probe _getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
		_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install --install-recommends -y "$@"
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
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian\|Raspbian' > /dev/null 2>&1
	then
		_tryExecFull _getMost_debian11 "$@"
		return
	fi
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		_tryExecFull _getMost_ubuntu22 "$@"
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
