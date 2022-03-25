
# May transfer large files out of cloud CI services, or may copy files into cloud or CI services for installation.


_rclone_limited_sequence() {
	export rclone_limited_file="$scriptLocal"/rclone_limited/rclone.conf
	! [[ -e "$rclone_limited_file" ]] && export rclone_limited_file=/rclone.conf
	! [[ -e "$rclone_limited_file" ]] && _messageError 'FAIL: rclone_limited_file' && _stop 1
	
	
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


