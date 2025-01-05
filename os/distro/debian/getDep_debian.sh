_apt-file_sequence() {
	_start
	
	_mustGetSudo
	#_mustGetDep su
	
	! _wantDep apt-file && sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y apt-file
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












_fetchDep_debianBookworm_special() {
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
	
# 	if [[ "$1" == *"java"* ]]
# 	then
# 		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y default-jdk default-jre
# 		return 0
# 	fi
	
	if [[ "$1" == *"wine"* ]] && ! dpkg --print-foreign-architectures | grep i386 > /dev/null 2>&1
	then
		sudo -n dpkg --add-architecture i386
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y wine wine32 wine64 libwine libwine:i386 fonts-wine
		return 0
	fi
	
	if [[ "$1" == "realpath" ]] || [[ "$1" == "readlink" ]] || [[ "$1" == "dirname" ]] || [[ "$1" == "basename" ]] || [[ "$1" == "sha512sum" ]] || [[ "$1" == "sha256sum" ]] || [[ "$1" == "head" ]] || [[ "$1" == "tail" ]] || [[ "$1" == "sleep" ]] || [[ "$1" == "env" ]] || [[ "$1" == "cat" ]] || [[ "$1" == "mkdir" ]] || [[ "$1" == "dd" ]] || [[ "$1" == "rm" ]] || [[ "$1" == "ln" ]] || [[ "$1" == "ls" ]] || [[ "$1" == "test" ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y coreutils
		return 0
	fi
	
	if [[ "$1" == "mount" ]] || [[ "$1" == "umount" ]] || [[ "$1" == "losetup" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mount
		return 0
	fi
	
	if [[ "$1" == "mountpoint" ]] || [[ "$1" == "mkfs" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y util-linux
		return 0
	fi
	
	if [[ "$1" == "mkfs.ext4" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y e2fsprogs
		return 0
	fi
	
	if [[ "$1" == "parted" ]] || [[ "$1" == "partprobe" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y parted
		return 0
	fi
	
	if [[ "$1" == "qemu-arm-static" ]] || [[ "$1" == "qemu-armeb-static" ]] || [[ "$1" == "update-binfmts" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu qemu-user-static binfmt-support
		#update-binfmts --display
		return 0
	fi
	
	if [[ "$1" == "qemu-system-x86_64" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu-system-x86
		return 0
	fi
	
	if [[ "$1" == "qemu-img" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu-utils
		return 0
	fi
	
	if [[ "$1" == "VirtualBox" ]] || [[ "$1" == "VBoxSDL" ]] || [[ "$1" == "VBoxManage" ]] || [[ "$1" == "VBoxHeadless" ]]
	then
		sudo -n mkdir -p /etc/apt/sources.list.d
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bookworm contrib' | sudo -n tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		"$scriptAbsoluteLocation" _getDep wget
		! _wantDep wget && return 1
		
		# TODO Check key fingerprints match "B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF" and "7B0F AB3A 13B9 0743 5925  D9C9 5442 2A4B 98AB 5139" respectively.
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -n apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo -n apt-key add -
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms virtualbox-6.1
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms virtualbox-7.0
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms virtualbox-7.1
		
		# https://www.virtualbox.org/ticket/20949
		if ! type -p virtualbox > /dev/null 2>&1 && ! type -p VirtualBox > /dev/null 2>&1
		then
			#curl -L "https://download.virtualbox.org/virtualbox/6.1.34/virtualbox-6.1_6.1.34-150636.1~Debian~bookworm_amd64.deb" -o "$safeTmp"/"virtualbox-6.1_6.1.34-150636.1~Debian~bookworm_amd64.deb"
			#curl -L "https://download.virtualbox.org/virtualbox/7.0.10/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb" -o "$safeTmp"/"virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb"
			curl -L "https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Debian~bookworm_amd64.deb" -o "$safeTmp"/"virtualbox-7.1_7.1.4-165100~Debian~bookworm_amd64.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms
			#yes | sudo -n dpkg -i "$safeTmp"/"virtualbox-6.1_6.1.34-150636.1~Debian~bookworm_amd64.deb"
			#yes | sudo -n dpkg -i "$safeTmp"/"virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb"
			yes | sudo -n dpkg -i "$safeTmp"/"virtualbox-7.1_7.1.4-165100~Debian~bookworm_amd64.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -f
		fi
		
		echo "WARNING: Recommend manual system configuration after install. See https://www.virtualbox.org/wiki/Downloads ."
		
		return 0
	fi
	
	if [[ "$1" == "gpg" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y gnupg
		return 0
	fi
	
	#Unlikely scenario for hosts.
	if [[ "$1" == "grub-install" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grub2
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grub-legacy
		return 0
	fi
	
	if [[ "$1" == "MAKEDEV" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y makedev
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "awk" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mawk
		return 0
	fi
	
	if [[ "$1" == "kill" ]] || [[ "$1" == "ps" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y procps
		return 0
	fi
	
	if [[ "$1" == "find" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y findutils
		return 0
	fi
	
	if [[ "$1" == "docker" ]] || [[ "$1" == "docker-compose" ]]
	then
		sudo -n update-alternatives --set iptables /usr/sbin/iptables-legacy
		sudo -n update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
		#sudo -n systemctl restart docker
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
		
		# Sometimes may be useful as a workaround for docker 'overlay2' 'storage-driver' .
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y fuse-overlayfs
		
		"$scriptAbsoluteLocation" _getDep curl
		! _wantDep curl && return 1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo -n apt-key add -
		local aptKeyFingerprint
		aptKeyFingerprint=$(sudo -n apt-key fingerprint 0EBFCD88 2> /dev/null)
		[[ "$aptKeyFingerprint" == "" ]] && return 1
		
		sudo -n add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get remove -y docker docker-engine docker.io docker-ce docker
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y docker-ce
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y docker-compose-plugin
		
		sudo -n usermod -a -G docker "$USER"
		
		return 0
	fi
	
	if [[ "$1" == "smbd" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y samba
		return 0
	fi
	
	if [[ "$1" == "atom" ]]
	then
		#curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo -n apt-key add -
		#sudo -n sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/ub_atom.list'
		
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y atom
		
		return 1
	fi
	
	if [[ "$1" == "GL/gl.h" ]] || [[ "$1" == "GL/glext.h" ]] || [[ "$1" == "GL/glx.h" ]] || [[ "$1" == "GL/glxext.h" ]] || [[ "$1" == "GL/dri_interface.h" ]] || [[ "$1" == "x86_64-linux-gnu/pkgconfig/dri.pc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mesa-common-dev
		
		return 0
	fi
	
	if [[ "$1" == "go" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y golang-go
		
		return 0
	fi
	
	if [[ "$1" == "php" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y php
		
		return 0
	fi
	
	if [[ "$1" == "cura-lulzbot" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See https://www.lulzbot.com/learn/tutorials/cura-lulzbot-edition-installation-debian ."
cat << 'CZXWXcRMTo8EmM8i4d'
wget -qO - https://download.alephobjects.com/ao/aodeb/aokey.pub | sudo -n apt-key add -
sudo -n cp /etc/apt/sources.list /etc/apt/sources.list.bak && sudo -n sed -i '$a deb http://download.alephobjects.com/ao/aodeb jessie main' /etc/apt/sources.list && sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update && sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install cura-lulzbot
CZXWXcRMTo8EmM8i4d
		echo "(typical)"
		_stop 1
	fi
	
	if [[ "$1" =~ "FlashPrint" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See http://www.flashforge.com/support-center/flashprint-support/ ."
		_stop 1
	fi
	
	if [[ "$1" == "cargo" ]] || [[ "$1" == "rustc" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
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
	
	
	if [[ "$1" == "nix-env" ]]
	then
		_tryExec '_test_nix-env_upstream'
		#_tryExec '_test_nix-env_upstream_beta'
		
		return 0
	fi
	
	
	if [[ "$1" == "croc" ]]
	then
		_tryExec '_test_croc_upstream'
		#_tryExec '_test_croc_upstream_beta'
		
		return 0
	fi
	
	if [[ "$1" == "rclone" ]]
	then
		_tryExec '_test_rclone_upstream'
		#_tryExec '_test_rclone_upstream_beta'
		
		return 0
	fi
	
	
	if [[ "$1" == "terraform" ]]
	then
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		sudo -n apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y terraform
		
		return 0
	fi
	
	if [[ "$1" == "vagrant" ]]
	then
		#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		#sudo -n apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y vagrant-libvirt
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y vagrant
		
		return 0
	fi
	
	if [[ "$1" == "digimend-debug" ]] || [[ "$1" == 'udev/rules.d/90-digimend.rules' ]] || [[ "$1" == 'X11/xorg.conf.d/50-digimend.conf' ]]
	then
		if ! _wantDep digimend-debug && [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
		then
			if [[ -e "$HOME"/core/installations/digimend-dkms/digimend-dkms_10_all.deb ]]
			then
				yes | sudo -n dpkg -i "$HOME"/core/installations/digimend-dkms/digimend-dkms_10_all.deb
			fi
			
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y digimend-dkms
			
			#curl -L "https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v10/digimend-dkms_10_all.deb" -o "$safeTmp"/"digimend-dkms_10_all.deb"
			curl -L "https://deb.debian.org/debian/pool/main/d/digimend-dkms/digimend-dkms_11-3_amd64.deb" -o "$safeTmp"/"digimend-dkms_11-3_amd64.deb"
			yes | sudo -n dpkg -i "$safeTmp"/"digimend-dkms_11-3_amd64.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -f
			sudo rm -f "$safeTmp"/"digimend-dkms_11-3_amd64.deb"
		fi
		
		return 0
	fi
	
	if [[ "$1" == "openssl/ssl.h" ]] || [[ "$1" == "include/openssl/ssl.h" ]] || [[ "$1" == "/usr/include/openssl/ssl.h" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y libssl-dev
		
		return 0
	fi
	
	if [[ "$1" == "sqlite3.h" ]] || [[ "$1" == "sqlite3ext.h" ]] || [[ "$1" == "pkgconfig/sqlite3.pc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y libsqlite3-dev
		
		return 0
	fi
	
	if [[ "$1" == "qalculate-gtk" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qalculate-gtk
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -t bookworm-backports qalc
		
		! _wantDep 'qalculate-gtk' && echo 'warn: missing: qalculate-gtk'
		
		return 0
	fi
	
	if [[ "$1" == "qalc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -t bookworm-backports qalc
		
		! _wantDep 'qalc' && echo 'warn: missing: qalc'
		
		return 0
	fi
	
	if [[ "$1" == "nc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y netcat-openbsd
		
		! _wantDep 'nc' && echo 'warn: missing: nc'
		
		return 0
	fi
	
	
	return 1
}

_fetchDep_debianBookworm_sequence() {
	_start
	
	_mustGetSudo
	
	_wantDep "$1" && _stop 0
	
	_fetchDep_debianBookworm_special "$@" && _wantDep "$1" && _stop 0
	
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$1" && _wantDep "$1" && _stop 0
	
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
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$matchingPackage"
			_wantDep "$1" && _stop 0
		fi
	done
	matchingPackage=""
	matchingPackage=$(head -n 1 "$safeTmp"/pkgsOut | cut -f1 -d':')
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$matchingPackage"
	_wantDep "$1" && _stop 0
	
	_stop 1
}

_fetchDep_debianBookworm() {
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | sudo tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | sudo tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	export DEBIAN_FRONTEND=noninteractive
	
	#Run up to 2 times. On rare occasion, cache will become unusable again by apt-find before an installation can be completed. Overall, apt-find is the single weakest link in the system.
	"$scriptAbsoluteLocation" _fetchDep_debianBookworm_sequence "$@"
	"$scriptAbsoluteLocation" _fetchDep_debianBookworm_sequence "$@"
}




























































_fetchDep_debianBullseye_special() {
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
	
# 	if [[ "$1" == *"java"* ]]
# 	then
# 		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y default-jdk default-jre
# 		return 0
# 	fi
	
	if [[ "$1" == *"wine"* ]] && ! dpkg --print-foreign-architectures | grep i386 > /dev/null 2>&1
	then
		sudo -n dpkg --add-architecture i386
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y wine wine32 wine64 libwine libwine:i386 fonts-wine
		return 0
	fi
	
	if [[ "$1" == "realpath" ]] || [[ "$1" == "readlink" ]] || [[ "$1" == "dirname" ]] || [[ "$1" == "basename" ]] || [[ "$1" == "sha512sum" ]] || [[ "$1" == "sha256sum" ]] || [[ "$1" == "head" ]] || [[ "$1" == "tail" ]] || [[ "$1" == "sleep" ]] || [[ "$1" == "env" ]] || [[ "$1" == "cat" ]] || [[ "$1" == "mkdir" ]] || [[ "$1" == "dd" ]] || [[ "$1" == "rm" ]] || [[ "$1" == "ln" ]] || [[ "$1" == "ls" ]] || [[ "$1" == "test" ]] || [[ "$1" == "true" ]] || [[ "$1" == "false" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y coreutils
		return 0
	fi
	
	if [[ "$1" == "mount" ]] || [[ "$1" == "umount" ]] || [[ "$1" == "losetup" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mount
		return 0
	fi
	
	if [[ "$1" == "mountpoint" ]] || [[ "$1" == "mkfs" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y util-linux
		return 0
	fi
	
	if [[ "$1" == "mkfs.ext4" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y e2fsprogs
		return 0
	fi
	
	if [[ "$1" == "parted" ]] || [[ "$1" == "partprobe" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y parted
		return 0
	fi
	
	if [[ "$1" == "qemu-arm-static" ]] || [[ "$1" == "qemu-armeb-static" ]] || [[ "$1" == "update-binfmts" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu qemu-user-static binfmt-support
		#update-binfmts --display
		return 0
	fi
	
	if [[ "$1" == "qemu-system-x86_64" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu-system-x86
		return 0
	fi
	
	if [[ "$1" == "qemu-img" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qemu-utils
		return 0
	fi
	
	if [[ "$1" == "VirtualBox" ]] || [[ "$1" == "VBoxSDL" ]] || [[ "$1" == "VBoxManage" ]] || [[ "$1" == "VBoxHeadless" ]]
	then
		sudo -n mkdir -p /etc/apt/sources.list.d
		echo 'deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bullseye contrib' | sudo -n tee /etc/apt/sources.list.d/ub_vbox.list > /dev/null 2>&1
		
		"$scriptAbsoluteLocation" _getDep wget
		! _wantDep wget && return 1
		
		# TODO Check key fingerprints match "B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF" and "7B0F AB3A 13B9 0743 5925  D9C9 5442 2A4B 98AB 5139" respectively.
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo -n apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo -n apt-key add -
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms virtualbox-6.1
		
		# https://www.virtualbox.org/ticket/20949
		if ! type -p virtualbox > /dev/null 2>&1 && ! type -p VirtualBox > /dev/null 2>&1
		then
			curl -L "https://download.virtualbox.org/virtualbox/6.1.34/virtualbox-6.1_6.1.34-150636.1~Debian~bullseye_amd64.deb" -o "$safeTmp"/"virtualbox-6.1_6.1.34-150636.1~Debian~bullseye_amd64.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y dkms
			yes | sudo -n dpkg -i "$safeTmp"/"virtualbox-6.1_6.1.34-150636.1~Debian~bullseye_amd64.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -f
		fi
		
		echo "WARNING: Recommend manual system configuration after install. See https://www.virtualbox.org/wiki/Downloads ."
		
		return 0
	fi
	
	if [[ "$1" == "gpg" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y gnupg
		return 0
	fi
	
	#Unlikely scenario for hosts.
	if [[ "$1" == "grub-install" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grub2
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grub-legacy
		return 0
	fi
	
	if [[ "$1" == "MAKEDEV" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y makedev
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "fgrep" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y grep
		return 0
	fi
	
	if [[ "$1" == "awk" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mawk
		return 0
	fi
	
	if [[ "$1" == "kill" ]] || [[ "$1" == "ps" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y procps
		return 0
	fi
	
	if [[ "$1" == "find" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y findutils
		return 0
	fi
	
	if [[ "$1" == "docker" ]]
	then
		sudo -n update-alternatives --set iptables /usr/sbin/iptables-legacy
		sudo -n update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
		#sudo -n systemctl restart docker
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
		
		# Sometimes may be useful as a workaround for docker 'overlay2' 'storage-driver' .
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y fuse-overlayfs
		
		"$scriptAbsoluteLocation" _getDep curl
		! _wantDep curl && return 1
		
		curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo -n apt-key add -
		local aptKeyFingerprint
		aptKeyFingerprint=$(sudo -n apt-key fingerprint 0EBFCD88 2> /dev/null)
		[[ "$aptKeyFingerprint" == "" ]] && return 1
		
		sudo -n add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get remove -y docker docker-engine docker.io docker-ce docker
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y docker-ce
		
		sudo -n usermod -a -G docker "$USER"
		
		return 0
	fi
	
	if [[ "$1" == "smbd" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y samba
		return 0
	fi
	
	if [[ "$1" == "atom" ]]
	then
		#curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo -n apt-key add -
		#sudo -n sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/ub_atom.list'
		
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y atom
		
		return 1
	fi
	
	if [[ "$1" == "GL/gl.h" ]] || [[ "$1" == "GL/glext.h" ]] || [[ "$1" == "GL/glx.h" ]] || [[ "$1" == "GL/glxext.h" ]] || [[ "$1" == "GL/dri_interface.h" ]] || [[ "$1" == "x86_64-linux-gnu/pkgconfig/dri.pc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y mesa-common-dev
		
		return 0
	fi
	
	if [[ "$1" == "go" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y golang-go
		
		return 0
	fi
	
	if [[ "$1" == "php" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y php
		
		return 0
	fi
	
	if [[ "$1" == "cura-lulzbot" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See https://www.lulzbot.com/learn/tutorials/cura-lulzbot-edition-installation-debian ."
cat << 'CZXWXcRMTo8EmM8i4d'
wget -qO - https://download.alephobjects.com/ao/aodeb/aokey.pub | sudo -n apt-key add -
sudo -n cp /etc/apt/sources.list /etc/apt/sources.list.bak && sudo -n sed -i '$a deb http://download.alephobjects.com/ao/aodeb jessie main' /etc/apt/sources.list && sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update && sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install cura-lulzbot
CZXWXcRMTo8EmM8i4d
		echo "(typical)"
		_stop 1
	fi
	
	if [[ "$1" =~ "FlashPrint" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
		echo "Requires manual installation. See http://www.flashforge.com/support-center/flashprint-support/ ."
		_stop 1
	fi
	
	if [[ "$1" == "cargo" ]] || [[ "$1" == "rustc" ]]
	then
		#Testing/Sid only as of Stretch release cycle.
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y rustc cargo
		
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
	
	
	if [[ "$1" == "nix-env" ]]
	then
		_tryExec '_test_nix-env_upstream'
		#_tryExec '_test_nix-env_upstream_beta'
		
		return 0
	fi
	
	
	if [[ "$1" == "croc" ]]
	then
		_tryExec '_test_croc_upstream'
		#_tryExec '_test_croc_upstream_beta'
		
		return 0
	fi
	
	if [[ "$1" == "rclone" ]]
	then
		_tryExec '_test_rclone_upstream'
		#_tryExec '_test_rclone_upstream_beta'
		
		return 0
	fi
	
	
	if [[ "$1" == "terraform" ]]
	then
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		sudo -n apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y terraform
		
		return 0
	fi
	
	if [[ "$1" == "vagrant" ]]
	then
		#curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo -n apt-key add -
		#sudo -n apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		#sudo -n env DEBIAN_FRONTEND=noninteractive apt-get -y update
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y vagrant-libvirt
		
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y vagrant
		
		return 0
	fi
	
	if [[ "$1" == "digimend-debug" ]] || [[ "$1" == 'udev/rules.d/90-digimend.rules' ]] || [[ "$1" == 'X11/xorg.conf.d/50-digimend.conf' ]]
	then
		if ! _wantDep digimend-debug && [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
		then
			if [[ -e "$HOME"/core/installations/digimend-dkms/digimend-dkms_10_all.deb ]]
			then
				yes | sudo -n dpkg -i "$HOME"/core/installations/digimend-dkms/digimend-dkms_10_all.deb
			fi
			
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y digimend-dkms
			
			curl -L "https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v10/digimend-dkms_10_all.deb" -o "$safeTmp"/"digimend-dkms_10_all.deb"
			yes | sudo -n dpkg -i "$safeTmp"/"digimend-dkms_10_all.deb"
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -f
			sudo rm -f "$safeTmp"/"digimend-dkms_10_all.deb"
		fi
		
		return 0
	fi
	
	if [[ "$1" == "openssl/ssl.h" ]] || [[ "$1" == "include/openssl/ssl.h" ]] || [[ "$1" == "/usr/include/openssl/ssl.h" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y libssl-dev
		
		return 0
	fi
	
	if [[ "$1" == "sqlite3.h" ]] || [[ "$1" == "sqlite3ext.h" ]] || [[ "$1" == "pkgconfig/sqlite3.pc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y libsqlite3-dev
		
		return 0
	fi
	
	if [[ "$1" == "qalculate-gtk" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y qalculate-gtk
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -t bullseye-backports qalc
		
		! _wantDep 'qalculate-gtk' && echo 'warn: missing: qalculate-gtk'
		
		return 0
	fi
	
	if [[ "$1" == "qalc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y -t bullseye-backports qalc
		
		! _wantDep 'qalc' && echo 'warn: missing: qalc'
		
		return 0
	fi
	
	if [[ "$1" == "nc" ]]
	then
		sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y netcat-openbsd
		
		! _wantDep 'nc' && echo 'warn: missing: nc'
		
		return 0
	fi
	
	
	return 1
}

_fetchDep_debianBullseye_sequence() {
	_start
	
	_mustGetSudo
	
	_wantDep "$1" && _stop 0
	
	_fetchDep_debianBullseye_special "$@" && _wantDep "$1" && _stop 0
	
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$1" && _wantDep "$1" && _stop 0
	
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
			sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$matchingPackage"
			_wantDep "$1" && _stop 0
		fi
	done
	matchingPackage=""
	matchingPackage=$(head -n 1 "$safeTmp"/pkgsOut | cut -f1 -d':')
	sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y "$matchingPackage"
	_wantDep "$1" && _stop 0
	
	_stop 1
}

_fetchDep_debianBullseye() {
	# ATTRIBUTION-AI: ChatGPT o1-preview 2024-11-20 .
	echo 'APT::AutoRemove::RecommendsImportant "true";
APT::AutoRemove::SuggestsImportant "true";' | sudo -n tee /etc/apt/apt.conf.d/99autoremove-recommends > /dev/null

	
	# https://askubuntu.com/questions/104899/make-apt-get-or-aptitude-run-with-y-but-not-prompt-for-replacement-of-configu
	echo 'Dpkg::Options {"--force-confdef"};' | sudo -n tee /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	echo 'Dpkg::Options {"--force-confold"};' | sudo -n tee -a /etc/apt/apt.conf.d/50unattended-replaceconfig-ub > /dev/null
	
	export DEBIAN_FRONTEND=noninteractive
	
	#Run up to 2 times. On rare occasion, cache will become unusable again by apt-find before an installation can be completed. Overall, apt-find is the single weakest link in the system.
	"$scriptAbsoluteLocation" _fetchDep_debianBullseye_sequence "$@"
	"$scriptAbsoluteLocation" _fetchDep_debianBullseye_sequence "$@"
}



































_fetchDep_debian() {
	
	# WARNING: Obsolete. Disabled.
	#if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 1 | grep 9 > /dev/null 2>&1
	#then
		#_fetchDep_debianStretch "$@"
		#return
	#fi
	
	
	# WARNING: Obsolete. Disabled.
	#if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 10 > /dev/null 2>&1
	#then
		#_fetchDep_debianBuster "$@"
		#return
	#fi
	
	
	# WARNING: Obsolete. Declining support. Eventual removal expected approximately one year after two Debian stable releases.
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 11 > /dev/null 2>&1
	then
		_fetchDep_debianBullseye "$@"
		return
	fi


	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 12 > /dev/null 2>&1
	then
		_fetchDep_debianBookworm "$@"
		return
	fi
	
	return 1
}
