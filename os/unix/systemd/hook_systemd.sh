_hook_systemd_shutdown() {
	! _wantSudo && return 1
	
	[[ -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	_here_systemd_shutdown | sudo -n tee > /etc/systemd/system/"$sessionid".service
	sudo -n systemctl enable "$sessionid".service
	
}

#"$1" == sessionid (optional override for cleaning up stale systemd files)
_unhook_systemd_shutdown() {
	! _wantSudo && return 1
	
	[[ ! -e /etc/systemd/system/"$sessionid".service ]] && return 0
	
	sudo -n systemctl disable "$sessionid".service
	_wantSudo && sudo -n rm /etc/systemd/system/"$sessionid".service
}
