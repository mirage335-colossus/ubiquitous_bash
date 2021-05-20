#ubVirt_self
# WARNING: Not to be confused with 'ubVirtImageLocal' and similar.

# ATTENTION: Intended to rely on 'ubiquitous bash' '_editVBox' , '_editQemu' and similar , with file copy/deduplication , to 'create' a 'server' , as well as to perform relevant 'list' , 'status' , and similar functions.


# ATTENTION: Override with 'ops.sh' or similar.
# WARNING: DANGER: WIP. Untested!
_ubVirt_self_server_create() {
	_messageNormal 'init: _ubVirt_self_server_create'
	
	export ub_ubVirt_dir="$scriptLocal"/ubVirt
	export ub_ubVirt_dir_template="$scriptLocal"/ubVirt/template
	
	! mkdir -p "$ub_ubVirt_dir_template"/_local && return 1
	! [[ -e "$ub_ubVirt_dir_template"/_local ]] && return 1
	! [[ -d "$ub_ubVirt_dir_template"/_local ]] && return 1
	
	export ub_ubVirt_server_uid=$(_uid)
	export ub_ubVirt_server_dir="$ub_ubVirt_dir"/"$ub_ubVirt_server_uid"
	
	! mkdir -p "$ub_ubVirt_server_dir" && return 1
	! [[ -e "$ub_ubVirt_server_dir" ]] && return 1
	! [[ -d "$ub_ubVirt_server_dir" ]] && return 1
	
	if ! [[ -e "$ub_ubVirt_dir"/template/ubiquitous_bash.sh ]]
	then
		_messagePlain_nominal '_ubVirt_self_server_create: copy: template'
		cp -a "$scriptAbsoluteLocation" "$ub_ubVirt_dir_template"/ubiquitous_bash.sh
		cp -a "$scriptLocal"/ops.sh "$ub_ubVirt_dir_template"/_local/ops.sh
	fi
	
	if ! [[ -e "$ub_ubVirt_dir"/template/_local/vm.img ]] && ! [[ -e "$ub_ubVirt_dir"/template/_local/vm.vdi ]]
	then
		_messagePlain_nominal '_ubVirt_self_server_create: build: '"'OS' image"
		true
		# Call functions to build 'OS' image .
		# TODO: Necessarily will not match all steps expected of a 'custom' image, but must include everything a user would expect to be able to customize 'offline' (ie. all typical 'programs' must be installed, etc).
	fi
	
	
	_ubVirt_self_server_status "$ub_ubVirt_server_uid"
}


_ubVirt_self_server_list() {
	true
}


_ubVirt_self_server_status() {
	_messageNormal 'init: _ubVirt_self_server_status'
	
	#export ub_ubVirt_server_addr_ipv4
	#export ub_ubVirt_server_addr_ipv6
	
	#export ub_ubVirt_server_ssh_cred
	#export ub_ubVirt_server_ssh_port
	
	#export ub_ubVirt_server_vnc_cred
	#export ub_ubVirt_server_vnc_port
	
	#export ub_ubVirt_server_serial
	
	#export ub_ubVirt_server_novnc_cred
	#export_ub_ubVirt_server_novnc_port
	#export ub_ubVirt_server_novnc_url_ipv4
	#export ub_ubVirt_server_novnc_url_ipv6
	
	#export ub_ubVirt_server_shellinabox_port
	#export ub_ubVirt_server_shellinabox_url_ipv4
	#export ub_ubVirt_server_shellinabox_url_ipv6
	
	#export ub_ubVirt_server_remotedesktopwebclient_port
	#export ub_ubVirt_server_remotedesktopwebclient_url_ipv4
	#export ub_ubVirt_server_remotedesktopwebclient_url_ipv6
}



_test_ubVirt() {
	# ATTENTION: TODO: A custom 'GUI' frontend and backend may be required to integrate with VR.
	
	_tryExec _testQEMU_x64-x64
	_tryExec _testVBox
	
	return 0
}
