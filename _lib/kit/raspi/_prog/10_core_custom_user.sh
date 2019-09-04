_custom_construct_permissions_user() {
	local current_user_uid
	current_user_uid=$(_chroot id -u "$1" 2>/dev/null)
	
	_messagePlain_probe 'chown '"$current_user_uid":"$current_user_uid" "$globalVirtFS"/home/"$1"
	
	if [[ "$1" == "root" ]] || [[ "$current_user_uid" == '0' ]]
	then
		sudo -n chmod 700 "$globalVirtFS"/root
		sudo -n chown -R "$current_user_uid":"$current_user_uid" "$globalVirtFS"/root
		return
	fi
	
	sudo -n chmod 700 "$globalVirtFS"/home/"$1"
	sudo -n chown -R "$current_user_uid":"$current_user_uid" "$globalVirtFS"/home/"$1"
}

# "$1" == username
_custom_construct_user() {
	_messagePlain_nominal 'init: _custom_construct_user'
	
	_messagePlain_probe 'user= '"$1"
	! _chroot id -u "$1" > /dev/null 2>&1 && _chroot useradd -m "$1"
	! _chroot id -u "$1" > /dev/null 2>&1 && _messageError 'FAIL: User NOT included!' && _stop 1
	
	_custom_construct_permissions_user "$1"
}

_custom_construct_user_root_ssh() {
	sudo -n mkdir -p "$globalVirtFS"/root/.ssh
	sudo -n chmod 700 "$globalVirtFS"/root/.ssh
	sudo -n rm -f "$globalVirtFS"/root/.ssh/authorized_keys > /dev/null 2>&1
	
	mkdir -p "$scriptLocal"/ssh_pub_"$1"
	cat "$scriptLocal"/ssh_pub_"$1"/*.pub 2>/dev/null | sudo -n tee "$globalVirtFS"/root/.ssh/authorized_keys > /dev/null
	
	_custom_construct_permissions_user "$1"
}

_custom_construct_user_ssh() {
	local current_user_uid
	current_user_uid=$(_chroot id -u "$1" 2>/dev/null)
	
	if [[ "$1" == "root" ]] || [[ "$current_user_uid" == '0' ]]
	then
		_custom_construct_user_root_ssh "$@"
		return
	fi
	
	sudo -n mkdir -p "$globalVirtFS"/home/"$1"/.ssh
	sudo -n chmod 700 "$globalVirtFS"/home/"$1"/.ssh
	sudo -n rm -f "$globalVirtFS"/home/"$1"/.ssh/authorized_keys > /dev/null 2>&1
	
	mkdir -p "$scriptLocal"/ssh_pub_"$1"
	cat "$scriptLocal"/ssh_pub_"$1"/*.pub 2>/dev/null | sudo -n tee "$globalVirtFS"/home/"$1"/.ssh/authorized_keys > /dev/null
	
	_custom_construct_permissions_user "$1"
}

# ATTENTION: Override (if necessary) .
_custom_construct_crontab_prog() {
	true
}

_custom_construct_crontab() {
	mkdir -p "$scriptLocal"/_custom
	
	[[ ! -e "$scriptLocal"/_custom/crontab ]] && return 1
	! grep '_custom_hook_crontab' "$scriptLocal"/_custom/crontab > /dev/null 2>&1 && echo '# _custom_hook_crontab' >> "$scriptLocal"/_custom/crontab
	
	_custom_construct_crontab_prog
	
	_chroot crontab -u "$custom_user" -r
	cat "$scriptLocal"/_custom/crontab | _chroot crontab -u "$custom_user" '-'
}

_custom_hook_crontab() {
	cat - >> "$scriptLocal"/_custom/crontab
}

