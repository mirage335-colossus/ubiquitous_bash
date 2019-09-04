# ATTENTION: Override .
_set_custom_cautossh-limited() {
	_messagePlain_nominal 'init: SET: _set_custom_cautossh-limited'
	_custom_set
	
	export custom_cautossh_limited_dirname="$custom_netName"-limited
}

_prepare_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _prepare_custom_cautossh-limited'
	_custom_prepare
	
	export custom_cautossh_limited_src_dir="$scriptLib"/"$custom_cautossh_limited_dirname"
	export custom_cautossh_limited_dst_dir="$globalVirtFS"/home/"$custom_user"/core/"$custom_cautossh_limited_dirname"
	_messagePlain_probe 'cautossh-limited DIR'
	_messagePlain_probe_var custom_cautossh_limited_src_dir
	_messagePlain_probe_var custom_cautossh_limited_dst_dir
	
	export custom_cautossh_limited_src_exe="$custom_cautossh_limited_src_dir"/cautossh
	export custom_cautossh_limited_dst_exe="$custom_cautossh_limited_dst_dir"/cautossh
	_messagePlain_probe 'cautossh-limited EXE'
	_messagePlain_probe_var custom_cautossh_limited_src_exe
	_messagePlain_probe_var custom_cautossh_limited_dst_exe
	
	export custom_cautossh_limited_reversePort=$("$custom_cautossh_limited_src_exe" _show_reversePorts_single "$custom_hostname")
	
	# WARNING: Must report all 'reversePorts' matching '*' . If not exactly two, warning should be issued.
	export custom_cautossh_limited_reversePort_all=( $("$custom_cautossh_limited_src_exe" _show_reversePorts '*' 2> /dev/null) )
	export custom_cautossh_limited_reversePort_count=${#custom_cautossh_limited_reversePort_all[@]}
	
	_messagePlain_probe 'cautossh-limited PORT'
	_messagePlain_probe_var custom_cautossh_limited_reversePort
	_messagePlain_probe_var custom_cautossh_limited_reversePort_all
	_messagePlain_probe_var custom_cautossh_limited_reversePort_count
}



_prepare_self_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _prepare_self_custom_cautossh-limited'
	
	export custom_self_cautossh_limited_comment='cautossh@'"$custom_cautossh_limited_dirname"_"$custom_hostname"
	
	export custom_self_cautossh_limited_identity_src_dir="$custom_cautossh_limited_src_dir"/_local/ssh
	export custom_self_cautossh_limited_identity_dst_dir="$custom_cautossh_limited_dst_dir"/_local/ssh
	export custom_self_cautossh_limited_identity_lcl_dir="$scriptLocal"/self
	
	_messagePlain_probe 'cautossh-limited identity DIR'
	_messagePlain_probe_var custom_self_cautossh_limited_identity_src_dir
	_messagePlain_probe_var custom_self_cautossh_limited_identity_dst_dir
	_messagePlain_probe_var custom_self_cautossh_limited_identity_lcl_dir
	
	mkdir -p "$custom_self_cautossh_limited_identity_src_dir"
	mkdir -p "$custom_self_cautossh_limited_identity_dst_dir"
	mkdir -p "$custom_self_cautossh_limited_identity_lcl_dir"
	
	chmod 700 "$custom_self_cautossh_limited_identity_src_dir"
	chmod 700 "$custom_self_cautossh_limited_identity_dst_dir"
	chmod 700 "$custom_self_cautossh_limited_identity_lcl_dir"
	
	mkdir -p "$custom_cautossh_limited_dst_dir"/_local/tor/
	chmod 700 "$custom_cautossh_limited_dst_dir"/_local/tor/
	
	export custom_self_cautossh_limited_identity_src_file="$custom_self_cautossh_limited_identity_src_dir"/id_rsa
	export custom_self_cautossh_limited_identity_dst_file="$custom_self_cautossh_limited_identity_dst_dir"/id_rsa
	export custom_self_cautossh_limited_identity_lcl_file="$custom_self_cautossh_limited_identity_lcl_dir"/id_rsa
	
	_messagePlain_probe 'cautossh-limited identity FILE'
	_messagePlain_probe_var custom_self_cautossh_limited_identity_src_file
	_messagePlain_probe_var custom_self_cautossh_limited_identity_dst_file
	_messagePlain_probe_var custom_self_cautossh_limited_identity_lcl_file
}

_safety_self_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _safety_self_custom_cautossh-limited'
	
	# DANGER: *Prohibit* git repository for any 'limited' CoreAutoSSH package.
	find "$custom_self_cautossh_limited_identity_src_dir" -prune -path '_lib' 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	find "$custom_self_cautossh_limited_identity_dst_dir" -prune -path '_lib' 2>/dev/null | grep -i '\.git$' >/dev/null 2>&1 && return 1
	
	
	# DANGER: *Prohibit* full package for any machine intended to use 'limited' CoreAutoSSH package.
	[[ -e "$custom_cautossh_dst_dir" ]] && 'FAIL: DANGER: #*#*UNSAFE*#*# !!!' && _stop 1
	! [[ "$custom_cautossh_limited_dirname" == *'limited' ]] && _messageError 'FAIL: DANGER: #*#*UNSAFE*#*# !!!' && _stop 1
	! [[ -e "$custom_cautossh_limited_src_exe" ]] && _messageError 'FAIL: DANGER: #*#*UNSAFE*#*# !!!' && _stop 1
	
	# DANGER: Do NOT include any unnecessary files.
	find "$custom_self_cautossh_limited_identity_src_dir" -mindepth 1 -maxdepth 2 -type f ! -name 'id_rsa' ! -name 'id_rsa.pub' ! -name 'ops.sh' ! -name 'known_hosts' -delete
	
	# WARNING: Presence of any file other than "id_rsa" should be reported.
	# WARNING: Presence of "ops.sh" should be reported.
	
	# Should not be possible.
	! find "$custom_self_cautossh_limited_identity_src_dir" -mindepth 1 -maxdepth 2 -type f ! -name 'id_rsa' ! -name 'id_rsa.pub' ! -name 'ops.sh' ! -name 'known_hosts' 2>/dev/null | _condition_lines_zero && _messagePlain_warn 'warn: uncertain: src'
	
	# Expected. Reminder.
	[[ -e "$custom_self_cautossh_limited_identity_src_dir"/ops.sh ]] && _messagePlain_warn 'warn: uncertain: src: ops.sh'
	[[ -e "$custom_self_cautossh_limited_identity_src_dir"/known_hosts ]] && _messagePlain_warn 'warn: uncertain: src: known_hosts'
	
	# Rare.
	if ! find "$custom_self_cautossh_limited_identity_dst_dir" -mindepth 1 -maxdepth 2 -type f ! -name 'id_rsa' ! -name 'id_rsa.pub' ! -name 'ops.sh' ! -name 'known_hosts' 2>/dev/null | _condition_lines_zero
	then
		_messagePlain_warn 'warn: uncertain: dst'
		ls -ld "$custom_self_cautossh_limited_identity_dst_dir"
		echo
		ls -R "$custom_self_cautossh_limited_identity_dst_dir"
		echo
	fi
	
	# Expected. Reminder.
	[[ -e "$custom_self_cautossh_limited_identity_dst_dir"/ops.sh ]] && _messagePlain_warn 'warn: uncertain: dst: ops.sh'
	[[ -e "$custom_self_cautossh_limited_identity_dst_dir"/known_hosts ]] && _messagePlain_warn 'warn: uncertain: dst: known_hosts'
	
	
	# DANGER: Do NOT include more than exactly two 'reversePorts' .
	[[ "$custom_cautossh_limited_reversePort_count" -gt '2' ]] && _messageError 'FAIL: DANGER: #*#*UNSAFE*#*# !!!' && _stop 1
	
	# DANGER: Do NOT include any unnecessary files.
	# Existence of 'dd' directory should instead be detected/reported by finding files/folders not matching expected 'reversePort' .
	#[[ -e "$custom_cautossh_limited_src_dir"/_local/tor/sshd/dd ]] && _safeRMR "$custom_cautossh_limited_src_dir"/_local/tor/sshd/dd
	if ! find "$custom_cautossh_limited_src_dir"/_local/tor/sshd -mindepth 1 -maxdepth 1 -type f ! -name "$custom_cautossh_limited_reversePort" 2>/dev/null | _condition_lines_zero
	then
		_messageError 'FAIL: DANGER: #*#*UNSAFE*#*# !!!' && _stop 1
	fi
	
	return 0
}


_remove_self_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _remove_self_custom_cautossh-limited'
	
	_set_custom_cautossh-limited
	_prepare_custom_cautossh-limited
	
	_prepare_self_custom_cautossh-limited
	
	_messagePlain_nominal '_remove_self_custom_cautossh-limited: ... REMOVE ...'
	
	_remove_custom_cautossh_identity "$custom_self_cautossh_limited_identity_src_file"
	_remove_custom_cautossh_identity "$custom_self_cautossh_limited_identity_dst_file"
	_remove_custom_cautossh_identity "$custom_self_cautossh_limited_identity_lcl_file"
}

_check_sync_self_custom_cautossh-limited() {
	[[ "$custom_self_cautossh_limited_file_exists" == 'true' ]] && [[ "$custom_self_cautossh_limited_file_broken" == 'true' ]] && _messagePlain_request 'request: _remove_self_custom_cautossh-limited' && _messageError 'FAIL: WARNING: BROKEN .' && _stop 1
	[[ "$custom_self_cautossh_limited_file_exists" == 'true' ]] && [[ "$custom_self_cautossh_limited_file_desync" == 'true' ]] && _messagePlain_request 'request: _remove_self_custom_cautossh-limited' && _messageError 'FAIL: WARNING: DESYNC .' && _stop 1
	
	[[ "$custom_self_cautossh_limited_file_exists" != 'true' ]] && [[ "$custom_self_cautossh_limited_file_exists" != 'false' ]] && _messageError 'FAIL: LOGIC .' && _stop 1
	[[ "$custom_self_cautossh_limited_file_broken" != 'true' ]] && [[ "$custom_self_cautossh_limited_file_broken" != 'false' ]] && _messageError 'FAIL: LOGIC .' && _stop 1
	[[ "$custom_self_cautossh_limited_file_desync" != 'true' ]] && [[ "$custom_self_cautossh_limited_file_desync" != 'false' ]] && _messageError 'FAIL: LOGIC .' && _stop 1
}

_check_self_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _check_self_custom_cautossh-limited'
	
	export custom_self_cautossh_limited_file_exists='false'
	export custom_self_cautossh_limited_file_broken='false'
	export custom_self_cautossh_limited_file_desync='false'
	
	[[ -e "$custom_self_cautossh_limited_identity_src_file".pub ]] && export custom_self_cautossh_limited_file_exists='true'
	[[ -e "$custom_self_cautossh_limited_identity_dst_file".pub ]] && export custom_self_cautossh_limited_file_exists='true'
	[[ -e "$custom_self_cautossh_limited_identity_lcl_file".pub ]] && export custom_self_cautossh_limited_file_exists='true'
	
	! grep "$custom_self_cautossh_limited_comment" "$custom_self_cautossh_limited_identity_src_file".pub > /dev/null 2>&1 && export custom_self_cautossh_limited_file_broken='true'
	! grep "$custom_self_cautossh_limited_comment" "$custom_self_cautossh_limited_identity_dst_file".pub > /dev/null 2>&1 && export custom_self_cautossh_limited_file_broken='true'
	! grep "$custom_self_cautossh_limited_comment" "$custom_self_cautossh_limited_identity_lcl_file".pub > /dev/null 2>&1 && export custom_self_cautossh_limited_file_broken='true'
	
	! sudo -n diff "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_src_file" > /dev/null 2>&1 && custom_self_cautossh_limited_file_desync='true'
	! sudo -n diff "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_lcl_file" > /dev/null 2>&1 && custom_self_cautossh_limited_file_desync='true'
	
	_check_sync_self_custom_cautossh-limited
}


# ATTENTION: Override .
_copy_self_custom_cautossh-limited_prog() {
	true
}


_copy_self_custom_cautossh-limited() {
	if ! diff "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_src_file" > /dev/null 2>&1 || ! diff "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_lcl_file" > /dev/null 2>&1
	then
		_messagePlain_probe 'copy: identity'
	fi
	
	_copy_custom_cautossh_identity_local "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_lcl_file"
	_copy_custom_cautossh_identity_local "$custom_self_cautossh_limited_identity_dst_file" "$custom_self_cautossh_limited_identity_src_file"
	
	sudo -n cp "$custom_cautossh_limited_src_exe" "$custom_cautossh_limited_dst_exe"
	sudo -n chmod 700 "$custom_cautossh_limited_dst_exe"
	
	cp "$custom_self_cautossh_limited_identity_src_dir"/ops.sh "$custom_self_cautossh_limited_identity_dst_dir"/ops.sh
	cp "$custom_self_cautossh_limited_identity_src_dir"/known_hosts "$custom_self_cautossh_limited_identity_dst_dir"/known_hosts
	
	_custom_rsync "$custom_cautossh_limited_src_dir"/_local/tor/ "$custom_cautossh_limited_dst_dir"/_local/tor/
	sudo -n chmod 700 "$custom_cautossh_limited_dst_dir"/_local/tor/
	
	_copy_self_custom_cautossh-limited_prog "$@"
	
	local current_user_uid
	current_user_uid=$(_chroot id -u "$custom_user" 2>/dev/null)
	sudo -n chown -R "$current_user_uid":"$current_user_uid" "$globalVirtFS"/home/"$custom_user"
}


_self_custom_cautossh-limited() {
	_messagePlain_nominal 'init: _self_custom_cautossh-limited'
	
	_messagePlain_nominal '_self_custom_cautossh-limited: ... GENERATE ...'
	
	_prepare_self_custom_cautossh-limited
	_check_self_custom_cautossh-limited
	_generate_self_custom_cautossh-limited
	_copy_self_custom_cautossh-limited
	
	_check_self_custom_cautossh-limited
}

_custom_cautossh-limited_cron_entry() {
	[[ ! -e "$custom_cautossh_limited_dst_exe" ]] && return 1
	echo '@reboot /home/'"$custom_user"'/core/'"$custom_cautossh_limited_dirname"'/cautossh _ssh_autoreverse' | _custom_hook_crontab
}

# ATTENTION: Override (rarely, if desired) .
_custom_cautossh-limited_prog() {
	_custom_cautossh-limited_cron_entry
}

_custom_cautossh-limited() {
	_messageNormal '_custom_cautossh-limited: SET , PREPARE , SAFETY'
	_set_custom_cautossh-limited
	_prepare_custom_cautossh-limited
	
	_prepare_self_custom_cautossh-limited
	! _safety_self_custom_cautossh-limited && return 1
	
	_messageNormal '_custom_cautossh-limited: SELF'
	_self_custom_cautossh-limited
	
	_custom_cautossh-limited_prog
}


