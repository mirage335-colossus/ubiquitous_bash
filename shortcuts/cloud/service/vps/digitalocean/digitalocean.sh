#digitalocean

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .


# https://docs.digitalocean.com/reference/api/example-usage/
# https://developers.digitalocean.com/documentation/v2/#introduction

# https://developers.digitalocean.com/documentation/spaces/

# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_digitalocean_cloud_cred() {
	export ub_digitalocean_TOKEN=''
}
_digitalocean_cloud_cred_reset() {
	export ub_digitalocean_TOKEN=''
}




# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_digitalocean_cloud_server_name
_digitalocean_cloud_server_create() {
	_messageNormal 'init: _digitalocean_cloud_server_create'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	export ub_digitalocean_cloud_server_name="$1"
	[[ "$ub_digitalocean_cloud_server_name" == "" ]] && export ub_digitalocean_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _digitalocean_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_digitalocean_cloud_server_uid=
	while [[ "$ub_digitalocean_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_digitalocean_cloud_server_create_API--nyc3_s-1vcpu-1gb_ubuntu-20-04-x64 "$ub_digitalocean_cloud_server_name" > "$cloudTmp"/reply
		export ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplet.'id | tr -dc 'a-zA-Z0-9_-.:')
		
		[[ "$ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _digitalocean_cloud_server_create: miss'
	done
	[[ "$ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _digitalocean_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _digitalocean_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_digitalocean_cloud_server_status "$ub_digitalocean_cloud_server_uid"
	
	_digitalocean_cloud_cred_reset
	
	return 0
}
_digitalocean_cloud_server_create_API--nyc3_s-1vcpu-1gb_ubuntu-20-04-x64() {
	curl -X POST "https://api.digitalocean.com/v2/droplets" -d '{"name":"'"$ub_digitalocean_cloud_server_name"'","region":"nyc3","size":"s-1vcpu-1gb","image":"ubuntu-20-04-x64"}' -H "Authorization: Bearer $ub_digitalocean_TOKEN" -H "Content-Type: application/json"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.droplets[0].id,.droplets[0].name' )
# EXAMPLE: _digitalocean_cloud_self_server_list _digitalocean_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _digitalocean_cloud_self_server_list _digitalocean_cloud_self_server_status-filter 'workstation'
_digitalocean_cloud_self_server_list() {
	_messageNormal 'init: _digitalocean_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	_messagePlain_nominal 'attempt: _digitalocean_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_digitalocean_cloud_server_uid
	current_ub_digitalocean_cloud_server_uid=
	while [[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		curl -X GET "https://api.digitalocean.com/v2/droplets" -H "Authorization: Bearer $ub_digitalocean_TOKEN" > "$cloudTmp"/reply
		current_ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets[0].id' | tr -dc 'a-zA-Z0-9_-.:')
		
		[[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _digitalocean_cloud_self_server_list: miss'
	done
	[[ "$current_ub_digitalocean_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _digitalocean_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _digitalocean_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.droplets[].id,.droplets[].name'
	_stop_cloud_tmp
	_digitalocean_cloud_cred_reset
	
	return 0
}



_digitalocean_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _digitalocean_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _digitalocean_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_digitalocean_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_digitalocean_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_digitalocean_cloud_server_uid" != "null" ]] && [[ "$ub_digitalocean_cloud_server_name" != "null" ]] && [[ "$ub_digitalocean_cloud_server_uid" != "" ]] && [[ "$ub_digitalocean_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_digitalocean_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			#while ! curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/""$ub_digitalocean_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			while ! curl -I -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/""$ub_digitalocean_cloud_server_uid" | grep '204 No Content' > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_digitalocean_cloud_server_uid=
		export ub_digitalocean_cloud_server_name=
		
		ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9_-.:')
		ub_digitalocean_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].name' | tr -dc 'a-zA-Z0-9_-.:')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_digitalocean_cloud_server_uid
		_messagePlain_probe_var ub_digitalocean_cloud_server_name
		
	done
	_messagePlain_good  'done: _digitalocean_cloud_self_server_dispose-filter'
	
	return 0
}


_digitalocean_cloud_self_server_status-filter() {
	_messageNormal 'init: _digitalocean_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _digitalocean_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_digitalocean_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_digitalocean_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_digitalocean_cloud_server_uid" != "null" ]] && [[ "$ub_digitalocean_cloud_server_name" != "null" ]] && [[ "$ub_digitalocean_cloud_server_uid" != "" ]] && [[ "$ub_digitalocean_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_digitalocean_cloud_server_name" | grep "$@"
		then
			_digitalocean_cloud_self_server_status "$ub_digitalocean_cloud_server_uid"
		fi
		
		export ub_digitalocean_cloud_server_uid=
		export ub_digitalocean_cloud_server_name=
		
		ub_digitalocean_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9_-.:')
		ub_digitalocean_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.droplets['"$currentIterations"'].name' | tr -dc 'a-zA-Z0-9_-.:')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_digitalocean_cloud_server_uid
		_messagePlain_probe_var ub_digitalocean_cloud_server_name
		
	done
	_messagePlain_good  'done: _digitalocean_cloud_self_server_status-filter'
	
	return 0
}


_digitalocean_cloud_self_server_status() {
	_messageNormal 'init: _digitalocean_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_digitalocean_cloud_cred
	
	
	curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_digitalocean_TOKEN" "https://api.digitalocean.com/v2/droplets/$ub_digitalocean_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_digitalocean_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.droplet.networks.v4[0].ip_address' | tr -dc 'a-zA-Z0-9_-.:')
	export ub_digitalocean_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.droplet.networks.v6[0].ip_address' | tr -dc 'a-zA-Z0-9_-.:')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_digitalocean_cloud_server_ssh_cred=
	export ub_digitalocean_cloud_server_ssh_port=
	
	export ub_digitalocean_cloud_server_vnc_cred=
	export ub_digitalocean_cloud_server_vnc_port=
	
	export ub_digitalocean_cloud_server_serial=
	
	export ub_digitalocean_cloud_server_novnc_cred=
	export ub_digitalocean_cloud_server_novnc_port=
	export ub_digitalocean_cloud_server_novnc_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_novnc_port"/novnc/
	export ub_digitalocean_cloud_server_novnc_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_novnc_port"/novnc/
	
	export ub_digitalocean_cloud_server_shellinabox_port=
	export ub_digitalocean_cloud_server_shellinabox_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_shellinabox_port"/shellinabox/
	export ub_digitalocean_cloud_server_shellinabox_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_digitalocean_cloud_server_remotedesktopwebclient_port=
	export ub_digitalocean_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_digitalocean_cloud_server_addr_ipv4":"$ub_digitalocean_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_digitalocean_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_digitalocean_cloud_server_addr_ipv6":"$ub_digitalocean_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_digitalocean_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}










_test_digitalocean_cloud() {
	_getDep curl
	
	# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
	_getDep jq
}


