
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

# ATTENTION: Override (if necessary) .
_custom_packages() {
	true
	
	_custom_packages_debian "$@"
	
	#_custom_packages_gentoo "$@"
}

# ATTENTION: Override (if necessary) .
_custom_copy_directory() {
	true
	#_custom_rsync "$scriptLib"/'directory'/ "$globalVirtFS"/home/"$custom_user"/core/'directory'/
	
	_custom_rsync "$scriptLib"/'core'/ "$globalVirtFS"/home/"$custom_user"/core/
	
	
	
	#_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/home/"$custom_user"/core/'infrastructure/ubiquitous_bash'/ "$custom_user"
	
	
	_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/home/"$custom_user"/core/'infrastructure/ubiquitous_bash'/ "$custom_user"
	_chroot su "$custom_user" -c /bin/bash -c '/home/"$custom_user"/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet'
	
	_custom_rsync "$scriptLib"/'ubiquitous_bash'/ "$globalVirtFS"/root/core/'infrastructure/ubiquitous_bash'/ root
	_chroot su root -c /bin/bash -c '/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet'
}

# ATTENTION: Override (if necessary) .
_custom_prog() {
	true
	
	_custom_cautossh
	
	_tryExec _custom_cautossh-limited
}


# ATTENTION: Override .
_custom_write_boot() {
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

