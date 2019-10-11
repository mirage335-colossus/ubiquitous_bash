_generate_self_custom_cautossh-limited() {
	_check_self_custom_cautossh-limited
	
	if ! grep "$custom_self_cautossh_limited_comment" "$custom_self_cautossh_limited_identity_dst_file".pub > /dev/null 2>&1
	then
		_messagePlain_probe 'generate: identity'
		ssh-keygen -b 4096 -t rsa -N "" -f "$custom_self_cautossh_limited_identity_dst_file" -C "$custom_self_cautossh_limited_comment"
	fi
	
	local current_user_uid
	current_user_uid=$(_chroot id -u "$custom_name" 2>/dev/null)
	[[ "$current_user_uid" == "" ]] && current_user_uid='1000'
	
	sudo -n chown "$current_user_uid":"$current_user_uid" "$custom_self_cautossh_limited_identity_dst_file"
	sudo -n chown "$current_user_uid":"$current_user_uid" "$custom_self_cautossh_limited_identity_dst_file".pub
}

_remove_custom_cautossh_identity() {
	sudo -n rm -f "$1" > /dev/null 2>&1
	sudo -n rm -f "$1".pub > /dev/null 2>&1
}

_copy_custom_cautossh_identity() {
	_sudo _cpDiff "$1" "$2"
	_sudo _cpDiff "$1".pub "$2".pub
}

_copy_custom_cautossh_identity_local() {
	_copy_custom_cautossh_identity "$@"
	_sudo chown "$USER":"$USER" "$2"
	_sudo chown "$USER":"$USER" "$2".pub
}

_override_custom_cautossh_identity() {
	_remove_custom_cautossh_identity "$2"
	_copy_custom_cautossh_identity "$@"
}

# "$1" == src
# "$2" == dst
# "$3" == userName (optional)
_custom_rsync() {
	_messagePlain_probe 'rsync ...'
	! _safePath "$1" && return 1
	
	! [[ -d "$1" ]] && return 1
	
	local current_user_name
	local current_user_uid
	
	current_user_name="$3"
	[[ "$current_user_name" == "" ]] && current_user_name="$custom_user"
	
	current_user_uid=$(_chroot id -u "$current_user_name" 2>/dev/null)
	
	[[ "$current_user_uid" == "" ]] && current_user_uid='1000'
	
	
	_messagePlain_probe 'current_user_name= '"$current_user_name"
	_messagePlain_probe ' ... '"$1"' ... '"$2"' ... '"$current_user_uid"
	
	sudo -n mkdir -p "$2"
	sudo -n rsync -avx --delete "$1" "$2"
	sudo -n chown -R "$current_user_uid":"$current_user_uid" "$1"
}


