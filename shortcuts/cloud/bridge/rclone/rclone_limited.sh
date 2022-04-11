
# May transfer large files out of cloud CI services, or may copy files into cloud or CI services for installation.

_set_rclone_limited_file() {
	export rclone_limited_file="$scriptLocal"/rclone_limited/rclone.conf
	! [[ -e "$rclone_limited_file" ]] && export rclone_limited_file=/rclone.conf
}
_prepare_rclone_limited_file() {
	if type RCLONE_LIMITED_CONF_BASE64 > /dev/null 2>&1
	then
		export rclone_limited_conf_base64=$(RCLONE_LIMITED_CONF_BASE64)
	fi
	
	_set_rclone_limited_file
	if ! [[ -e "$rclone_limited_file" ]] && [[ "$rclone_limited_conf_base64" != "" ]]
	then
		if ! [[ -e /rclone.conf ]]
		then
			echo "$rclone_limited_conf_base64" | base64 -d | sudo -n tee /rclone.conf > /dev/null
		fi
		
		if ! [[ -e "$scriptLocal"/rclone_limited/rclone.conf ]]
		then
			mkdir -p "$scriptLocal"/rclone_limited
			echo "$rclone_limited_conf_base64" | base64 -d > "$scriptLocal"/rclone_limited/rclone.conf
		fi
	fi
	_set_rclone_limited_file
	if ! [[ -e "$rclone_limited_file" ]]
	then
		_messageError 'FAIL: missing: rclone_limited_file'
		_stop 1
	fi
	if ! [[ -s "$rclone_limited_file" ]]
	then
		_messageError 'FAIL: empty: rclone_limited_file'
		_stop 1
	fi
	return 0
}

_rclone_limited_sequence() {
	_prepare_rclone_limited_file
	
	export ub_function_override_rclone=''
	unset ub_function_override_rclone
	unset rclone
	env XDG_CONFIG_HOME="$scriptLocal"/rclone_limited rclone --config="$rclone_limited_file" "$@"
}

_rclone_limited() {
	"$scriptAbsoluteLocation" _rclone_limited_sequence "$@"
	[[ "$?" != "0" ]] && _stop 1
	return 0
}

_test_rclone_limited() {
	! _wantGetDep 'rclone' && echo 'missing: rclone'
	return 0
}


