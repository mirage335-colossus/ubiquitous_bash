_hook_systemd_shutdown() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	_here_systemd_shutdown | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service
	
}

_hook_systemd_shutdown_action() {
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	_here_systemd_shutdown_action "$@" | sudo -n tee /etc/systemd/system/"$sessionid".service > /dev/null
	sudo -n systemctl enable "$sessionid".service
	
}

#"$1" == sessionid (optional override for cleaning up stale systemd files)
_unhook_systemd_shutdown() {
	local hookSessionid
	hookSessionid="$sessionid"
	[[ "$1" != "" ]] && hookSessionid="$1"
	
	[[ ! -e /etc/systemd/system/"$hookSessionid".service ]] && return 0
	
	! _wantSudo && return 1
	
	sudo -n systemctl disable "$hookSessionid".service
	_wantSudo && sudo -n rm /etc/systemd/system/"$hookSessionid".service
}
