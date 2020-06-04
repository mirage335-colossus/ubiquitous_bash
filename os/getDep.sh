_typeDep() {
	
	# WARNING: Allows specification of entire path from root. *Strongly* prefer use of subpath matching, for increased portability.
	[[ "$1" == '/'* ]] && [[ -e "$1" ]] && return 0
	
	[[ -e /lib/"$1" ]] && return 0
	[[ -e /lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /lib64/"$1" ]] && return 0
	[[ -e /lib64/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/lib/"$1" ]] && return 0
	[[ -e /usr/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/local/lib/"$1" ]] && return 0
	[[ -e /usr/local/lib/x86_64-linux-gnu/"$1" ]] && return 0
	[[ -e /usr/include/"$1" ]] && return 0
	[[ -e /usr/local/include/"$1" ]] && return 0
	
	if ! type "$1" >/dev/null 2>&1
	then
		return 1
	fi
	
	return 0
}

_wantDep() {
	_typeDep "$1" && return 0
	
	_wantSudo && sudo -n "$scriptAbsoluteLocation" _typeDep "$1" && return 0
	
	return 1
}

_mustGetDep() {
	_typeDep "$1" && return 0
	
	_wantSudo && sudo -n "$scriptAbsoluteLocation" _typeDep "$1" && return 0
	
	echo "$1" missing
	_stop 1
}

_fetchDep_distro() {
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	then
		_tryExecFull _fetchDep_debian "$@"
		return
	fi
	return 1
}

_wantGetDep() {
	_wantDep "$@" && return 0
	
	_fetchDep_distro "$@"
	
	_wantDep "$@" && return 0
	return 1
}

_getDep() {
	_wantDep "$@" && return 0
	
	_fetchDep_distro "$@"
	
	_mustGetDep "$@"
}
