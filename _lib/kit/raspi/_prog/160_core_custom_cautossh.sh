

# ATTENTION: Configure .
_set_custom_cautossh() {
	_messagePlain_nominal 'init: _set_custom_cautossh'
	_custom_set
	
	export custom_cautossh_dirname="$custom_netName"
}

_prepare_custom_cautossh() {
	_messagePlain_nominal 'init: _prepare_custom_cautossh'
	_custom_prepare
	
	export custom_cautossh_src_dir="$scriptLib"/"$custom_cautossh_dirname"
	export custom_cautossh_dst_dir="$globalVirtFS"/home/"$custom_user"/core/"$custom_cautossh_dirname"
	
	export custom_cautossh_src_exe="$custom_cautossh_src_dir"/cautossh
	export custom_cautossh_dst_exe="$custom_cautossh_dst_dir"/cautossh
}

_custom_cautossh_safety() {
	[[ ! -e "$custom_cautossh_src_dir"/cautossh ]] && _messagePlain_bad 'missing: cautossh: cautossh' && return 1
}


_custom_cautossh_cron_entry() {
	[[ ! -e "$custom_cautossh_dst_exe" ]] && return 1
	echo '@reboot /home/'"$custom_user"'/core/'"$custom_cautossh_dirname"'/cautossh _ssh_autoreverse' | _custom_hook_crontab
}




# ATTENTION: Override .
_custom_cautossh_prog() {
	_custom_cautossh_cron_entry
	
	_chroot su "$custom_user" -c 'cd '"$custom_cautossh_dst_dir"' ; '"$custom_cautossh_dst_exe"'/ ; ./cautossh _setup_ssh'
	_chroot su "$custom_user" -c 'cd '"$custom_cautossh_dst_dir"' ; '"$custom_cautossh_dst_exe"'/ ; ./cautossh _setupCommands'
	
	#true
}


_custom_cautossh() {
	_messageNormal '_custom_cautossh: SET , PREPARE , SAFETY'
	
	_set_custom_cautossh
	_prepare_custom_cautossh
	! _custom_cautossh_safety && return 1
	
	_messageNormal '_custom_cautossh: ...'
	
	_custom_rsync "$custom_cautossh_src_dir"/ "$custom_cautossh_dst_dir"/
	sudo -n mkdir -p "$globalVirtFS"/home/"$custom_user"/.ssh
	sudo -n chmod 700 "$globalVirtFS"/home/"$custom_user"/.ssh
	sudo -n rm -f "$globalVirtFS"/home/"$custom_user"/.ssh/authorized_keys > /dev/null 2>&1
	
	cat "$custom_cautossh_src_dir"/_local/ssh/id_rsa.pub | sudo -n tee -a "$globalVirtFS"/home/"$custom_user"/.ssh/authorized_keys > /dev/null
	
	_custom_cautossh_prog
	
	local current_user_uid
	current_user_uid=$(_chroot id -u "$custom_user" 2>/dev/null)
	sudo -n chown -R "$current_user_uid":"$current_user_uid" "$globalVirtFS"/home/"$custom_user"
	
	
}


