
# ATTENTION: Configure .
_custom_set() {
	_messagePlain_nominal 'init: _custom_set'
	
	export custom_netName="$netName"
	export custom_hostname='hostname'
	
	export custom_user="user"
	[[ -e "$scriptLocal"/vm-raspbian.img ]] && export custom_user="pi"
	#export custom_user="username"
	
	# DANGER: Extremely rare. Do NOT enable without a SPECIFIC reason.
      # export allow_multiple_reversePorts='true'
}

# ATTENTION: Configure (if necessary) .
# User-specific SSH identity will be taken from "$scriptLocal"/ssh_pub_[user]/*.pub (if available) .
_custom_users() {
	_custom_construct_user root
	echo 'root:password' | _chroot chpasswd
	
	_custom_construct_user "$custom_user"
	echo "$custom_user"':password' | _chroot chpasswd
	_chroot usermod -a -G sudo "$custom_user"
	_chroot usermod -a -G wireshark "$custom_user"
	
	_custom_construct_user user1
	echo 'user1:password' | _chroot chpasswd
	_chroot usermod -s /bin/false user1
	
	_custom_construct_user user2
	echo 'user2:password' | _chroot chpasswd
	_chroot usermod -s /bin/false user2
}

# ATTENTION: Configure (if necessary) .
_custom_users_ssh() {
	_custom_construct_user_ssh root
	_custom_construct_user_ssh "$custom_user"
	
	_custom_construct_user_ssh user1
	_custom_construct_user_ssh user2
}


_custom_packages_debian-special() {
	
	sudo -n cp "$scriptLib"/core/installations/firmware-amd-graphics_20190114-2_all.deb "$globalVirtFS"/
	_chroot dpkg -i /firmware-amd-graphics_20190114-2_all.deb
	_chroot rm -f /firmware-amd-graphics_20190114-2_all.deb
	_chroot apt-get install -y -f
	
	_chroot apt-get install -y firmware-amd-graphics
	
	
	sudo -n cp "$scriptLib"/core/installations/preload_0.6.4-2_amd64.deb "$globalVirtFS"/
	_chroot dpkg -i /preload_0.6.4-2_amd64.deb
	_chroot rm -f /preload_0.6.4-2_amd64.deb
	_chroot apt-get install -y -f
	
	_chroot apt-get install -y preload
	
	
	_chroot apt-get install -y rsync makedev gparted
	
	
	_chroot apt-get install -y qalculate-gtk freecad geda geda-symbols geda-xgsch2pcb gerbv pcb
	
	_chroot apt-get install -y geda-gschem geda-xgsch2pcb pcb geda-gnetlist gerbv inkscape pstoedit imagemagick ghostscript ghostscript-x libreoffice zip
	_chroot apt-get install -y openjdk-11-jdk openjdk-11-jre
	
	
	_chroot apt-get install -y ddd build-essential
	_chroot apt-get install -y openjdk-11-jdk openjdk-11-jre
	_chroot apt-get install -y gperf xsltproc
	
	
	
	_chroot apt-get install -y filelight iotop kdiff3
	
	
	
	sudo -n mkdir -p "$globalVirtFS"/etc/apt/sources.list.d
	echo 'deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ buster main' | sudo -n tee "$globalVirtFS"/etc/apt/sources.list.d/adoptopenjdk.list > /dev/null 2>&1
	_chroot wget -q https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public -O- | _chroot apt-key add -
	
	_chroot apt-get update
	
	
	_chroot apt-get install -y adoptopenjdk-8-hotspot
	
}


# ATTENTION: Override (if necessary) .
_custom_packages() {
	true
	
	_custom_packages_debian "$@"
	_custom_packages_debian-special "$@"
	
	#_custom_packages_gentoo "$@"
}

# ATTENTION: Override (if necessary) .
_custom_copy_directory() {
	true
	_custom_set
	
	#_custom_rsync "$scriptLib"/'directory'/ "$globalVirtFS"/home/"$custom_user"/core/'directory'/
	
	_custom_rsync "$scriptLib"/'core'/ "$globalVirtFS"/home/"$custom_user"/core/ "$custom_user"
	
	_custom_rsync "$scriptLib"/'core'/installations/program "$globalVirtFS"/home/"$custom_user"/core/installations/ "$custom_user"
	
	_custom_rsync "$scriptLib"/'app_config'/ "$globalVirtFS"/home/"$custom_user"/.program/ "$custom_user"
	_custom_rsync "$scriptLib"/'app_config'/ "$globalVirtFS"/home/"$custom_user"/core/installations/program_config/ "$custom_user"
	
	
	#_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/home/"$custom_user"/core/'infrastructure/ubiquitous_bash'/ "$custom_user"
	
	
	_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/home/"$custom_user"/core/'infrastructure/ubiquitous_bash'/ "$custom_user"
	_chroot su "$custom_user" -c /bin/bash -c '/home/'"$custom_user"'/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet'
	
	_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/root/core/'infrastructure/ubiquitous_bash'/ root
	_chroot su root -c /bin/bash -c '/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet'
}

_custom_prog-vboxguest() {
	# DANGER: Might still attempt to load mismatched kernel module.
	# ATTENTION: Should only need to run once.
	_chroot mv -f /sbin/modprobe /sbin/modprobe.disable
	_chroot mv -f /usr/sbin/modprobe /usr/sbin/modprobe.disable
	_chroot mv -f /sbin/insmod /sbin/insmod.disable
	_chroot mv -f /usr/sbin/insmod /usr/sbin/insmod.disable
	_chroot su root -c /bin/bash -c '/home/'"$custom_user"'/core/installations/vboxguest/unpack/VBoxLinuxAdditions.run --nox11 -- --no-setup'
	_chroot /sbin/rcvboxadd quicksetup all
	_chroot cp -n /sbin/modprobe.disable /sbin/modprobe
	_chroot cp -n /usr/sbin/modprobe.disable /usr/sbin/modprobe
	_chroot cp -n /sbin/insmod.disable /sbin/insmod
	_chroot cp -n /usr/sbin/insmod.disable /usr/sbin/insmod
}

# ATTENTION: Override (if necessary) .
_custom_prog() {
	true
	
	_custom_prog-vboxguest
	
	
	# ATTENTION: Some of these commands may fail. This is normal.
	_chroot usermod -a -G sudo "$custom_user"
	_chroot usermod -a -G wheel "$custom_user"
	_chroot usermod -a -G wireshark "$custom_user"
	
	_chroot usermod -a -G cdrom "$custom_user"
	_chroot usermod -a -G floppy "$custom_user"
	_chroot usermod -a -G audio "$custom_user"
	_chroot usermod -a -G dip "$custom_user"
	_chroot usermod -a -G video "$custom_user"
	_chroot usermod -a -G plugdev "$custom_user"
	_chroot usermod -a -G netdev "$custom_user"
	_chroot usermod -a -G bluetooth "$custom_user"
	_chroot usermod -a -G lpadmin "$custom_user"
	_chroot usermod -a -G scanner "$custom_user"
	
	_chroot usermod -a -G disk "$custom_user"
	_chroot usermod -a -G dialout "$custom_user"
	_chroot usermod -a -G lpadmin "$custom_user"
	_chroot usermod -a -G scanner "$custom_user"
	_chroot usermod -a -G vboxusers "$custom_user"
	_chroot usermod -a -G libvirt "$custom_user"
	_chroot usermod -a -G docker "$custom_user"
	
	
	
	sudo -n mkdir -p /boot/efi/EFI/BOOT/
	sudo -n cp "$globalVirtFS"/boot/efi/EFI/debian/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi
	
	
	_chroot cp -r /home/"$custom_user"/core/installations/kernel/_linux-firmware/. /lib/firmware/
	
	# Debian specific command.
	_chroot update-initramfs -u
	
	
	_custom_cautossh
	
	_tryExec _custom_cautossh-limited
	
}


# ATTENTION: Override .
_custom_write_boot() {
	# In case of situations where the correct architecture may not be detected, disable this function.
	#true
	#return
	
	
	#Only applies to some architectures .
	_loopImage_imagefilename > /dev/null 2>&1
	( [[ "$ubVirtPlatform" != 'raspbian' ]] ) && return 0
	
	echo | sudo -n tee "$globalVirtFS"/../boot/ssh
	
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/../boot/wpa_supplicant.conf > /dev/null 2>&1
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
        ssid="ssid"
        psk="psk"
	key_mgmt=WPA-PSK
}

CZXWXcRMTo8EmM8i4d
	
	
	# Write only to new image.
	[[ -e "$globalVirtFS"/../boot/"$ubiquitiousBashIDshort" ]] && return 1
	echo | sudo -n tee "$globalVirtFS"/../boot/"$ubiquitiousBashIDshort"
	
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee -a "$globalVirtFS"/../boot/config.txt > /dev/null 2>&1

dtoverlay=pi3-disable-wifi
dtoverlay=pi3-disable-bt

CZXWXcRMTo8EmM8i4d
}





# ATTENTION: Configure .
_copy_self_custom_cautossh-limited_prog() {
	true
	return
	
	# Example. Unusual.
	
	local currentEntity
	local currentFile
	
	currentEntity='entity'
	currentFile='id_rsa'
	mkdir -p "$custom_self_cautossh_limited_identity_src_dir"/"$currentEntity"
	mkdir -p "$custom_self_cautossh_limited_identity_dst_dir"/"$currentEntity"
	_override_custom_cautossh_identity "$custom_self_cautossh_limited_identity_dst_dir"/id_rsa "$custom_self_cautossh_limited_identity_dst_dir"/"$currentEntity"/"$currentFile"
}

# ATTENTION: Configure .
_custom_cautossh_prog() {
	_custom_cautossh_cron_entry
	
	_chroot su "$custom_user" -c 'cd '"$custom_cautossh_dst_dir"' ; '"$custom_cautossh_dst_exe"'/ ; ./cautossh _setup_ssh'
	_chroot su "$custom_user" -c 'cd '"$custom_cautossh_dst_dir"' ; '"$custom_cautossh_dst_exe"'/ ; ./cautossh _setupCommands'
	
	# Example. Unusual.
	#cat "$custom_cautossh_src_dir"/_local/ssh/entity/id_rsa.pub | sudo -n tee -a "$globalVirtFS"/home/"$custom_user"/.ssh/authorized_keys > /dev/null
	
	#true
}


# ATTENTION: Configure .
_set_custom_cautossh() {
	_messagePlain_nominal 'init: _set_custom_cautossh'
	_custom_set
	
	export custom_cautossh_dirname="$custom_netName"
}

# ATTENTION: Configure.
_set_custom_cautossh-limited() {
	_messagePlain_nominal 'init: SET: _set_custom_cautossh-limited'
	_custom_set
	
	export custom_cautossh_limited_dirname="$custom_netName"-limited
}



# ATTENTION: Configure (if necessary) .
_custom_construct_crontab_prog() {
	true
	
	#! grep '_custom_hook__crontab_prog' "$scriptLocal"/_custom/crontab > /dev/null 2>&1 && echo '# _custom_hook__crontab_prog' >> "$scriptLocal"/_custom/crontab
	
	#if sudo -n test -e "$globalVirtFS"/home/"$custom_user"/core/infrastructure/renice_daemon/ubiquitous_bash.sh
	#then
	#	echo '@reboot /home/'"$custom_user"'/core/infrastructure/renice_daemon/ubiquitous_bash.sh _unix_renice_execDaemon' | _custom_hook_crontab
	#fi
	
	return 0
}

