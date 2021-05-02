#linode

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_linode_cloud_cred() {
	export ub_linode_TOKEN=''
}
_linode_cloud_cred_reset() {
	export ub_linode_TOKEN=''
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_digitalocean_cloud_server_name
_linode_cloud_server_create() {
	_messageNormal 'init: _linode_cloud_server_create'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	export ub_linode_cloud_server_name="$1"
	[[ "$ub_linode_cloud_server_name" == "" ]] && export ub_linode_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _linode_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_linode_cloud_server_uid=
	while [[ "$ub_linode_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_linode_cloud_server_create_API--us-east_g5-standard-2_debian9 "$ub_linode_cloud_server_name" > "$cloudTmp"/reply
		export ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.'id | tr -dc 'a-zA-Z0-9_-.:')
		
		[[ "$ub_linode_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _linode_cloud_server_create: miss'
	done
	[[ "$ub_linode_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _linode_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _linode_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_linode_cloud_server_status "$ub_linode_cloud_server_uid"
	
	_linode_cloud_cred_reset
	
	return 0
}
_linode_cloud_server_create_API--us-east_g5-standard-2_debian9() {
	# WARNING: Random 'root' 'password' by default - expect to use SSH instead.
	curl -X POST "https://api.linode.com/v4/linode/instances" -H "Authorization: Bearer $ub_linode_TOKEN" -H "Content-type: application/json" -d '{"type": "g5-standard-2", "region": "us-east", "image": "linode/debian9", "root_pass": "'$(_uid 18)'", "label": "'"$ub_linode_cloud_server_name"'"}'
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _linode_cloud_self_server_list _linode_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _linode_cloud_self_server_list _linode_cloud_self_server_status-filter 'workstation'
_linode_cloud_self_server_list() {
	_messageNormal 'init: _linode_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	_messagePlain_nominal 'attempt: _linode_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_linode_cloud_server_uid
	current_ub_linode_cloud_server_uid=
	while [[ "$current_ub_linode_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		curl -X GET "https://api.linode.com/v4/linode/instances" -H "Authorization: Bearer $ub_linode_TOKEN" > "$cloudTmp"/reply
		current_ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data[0].id' | tr -dc 'a-zA-Z0-9_-.:')
		
		[[ "$current_ub_linode_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _linode_cloud_self_server_list: miss'
	done
	[[ "$current_ub_linode_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _linode_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _linode_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.data[].id,.data[].label'
	_stop_cloud_tmp
	_linode_cloud_cred_reset
	
	return 0
}



_linode_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _linode_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _linode_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_linode_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_linode_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_linode_cloud_server_uid" != "null" ]] && [[ "$ub_linode_cloud_server_name" != "null" ]] && [[ "$ub_linode_cloud_server_uid" != "" ]] && [[ "$ub_linode_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_linode_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			while ! curl -I -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_linode_TOKEN" "https://api.linode.com/v4/linode/instances/""$ub_linode_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_linode_cloud_server_uid=
		export ub_linode_cloud_server_name=
		
		ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9_-.:')
		ub_linode_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9_-.:')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_linode_cloud_server_uid
		_messagePlain_probe_var ub_linode_cloud_server_name
		
	done
	_messagePlain_good  'done: _linode_cloud_self_server_dispose-filter'
	
	return 0
}


_linode_cloud_self_server_status-filter() {
	_messageNormal 'init: _linode_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _linode_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_linode_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_linode_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_linode_cloud_server_uid" != "null" ]] && [[ "$ub_linode_cloud_server_name" != "null" ]] && [[ "$ub_linode_cloud_server_uid" != "" ]] && [[ "$ub_linode_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_linode_cloud_server_name" | grep "$@"
		then
			_linode_cloud_self_server_status "$ub_linode_cloud_server_uid"
		fi
		
		export ub_linode_cloud_server_uid=
		export ub_linode_cloud_server_name=
		
		ub_linode_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9_-.:')
		ub_linode_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9_-.:')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_linode_cloud_server_uid
		_messagePlain_probe_var ub_linode_cloud_server_name
		
	done
	_messagePlain_good  'done: _linode_cloud_self_server_status-filter'
	
	return 0
}


_linode_cloud_self_server_status() {
	_messageNormal 'init: _linode_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_linode_cloud_cred
	
	
	curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_linode_TOKEN" "https://api.linode.com/v4/linode/instances/$ub_linode_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_linode_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.ipv4[0]' | tr -dc 'a-zA-Z0-9_-.:')
	export ub_linode_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.ipv6' | tr -dc 'a-zA-Z0-9_-.:')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_linode_cloud_server_ssh_cred=
	export ub_linode_cloud_server_ssh_port=
	
	export ub_linode_cloud_server_vnc_cred=
	export ub_linode_cloud_server_vnc_port=
	
	export ub_linode_cloud_server_serial=
	
	export ub_linode_cloud_server_novnc_cred=
	export ub_linode_cloud_server_novnc_port=
	export ub_linode_cloud_server_novnc_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_novnc_port"/novnc/
	export ub_linode_cloud_server_novnc_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_novnc_port"/novnc/
	
	export ub_linode_cloud_server_shellinabox_port=
	export ub_linode_cloud_server_shellinabox_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_shellinabox_port"/shellinabox/
	export ub_linode_cloud_server_shellinabox_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_linode_cloud_server_remotedesktopwebclient_port=
	export ub_linode_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_linode_cloud_server_addr_ipv4":"$ub_linode_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_linode_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_linode_cloud_server_addr_ipv6":"$ub_linode_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_digitalocean_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}










_test_linode_cloud() {
	_getDep curl
	
	# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
	_getDep jq
}





























