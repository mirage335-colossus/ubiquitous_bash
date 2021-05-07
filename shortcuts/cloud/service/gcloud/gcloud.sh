#google

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .



# https://cloud.google.com/compute/docs/instances/create-start-instance#gcloud


# https://dev.to/0xbanana/automating-deploys-with-bash-scripting-and-google-cloud-sdk-4976









# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_gcloud_cloud_cred() {
	_gcloud_set "$@"
}
_gcloud_cloud_cred_reset() {
	_gcloud_reset "$@"
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_gcloud_cloud_server_name
_gcloud_cloud_server_create() {
	_messageNormal 'init: _gcloud_cloud_server_create'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	export ub_gcloud_cloud_server_name="$1"
	[[ "$ub_gcloud_cloud_server_name" == "" ]] && export ub_gcloud_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _gcloud_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_gcloud_cloud_server_uid=
	while [[ "$ub_gcloud_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_gcloud_cloud_server_create_API--default "$ub_gcloud_cloud_server_name" > "$cloudTmp"/reply
		
		# WARNING: WIP, Untested.
		if gcloud compute instances describe "$ub_gcloud_cloud_server_name" | grep "$ub_gcloud_cloud_server_name" > /dev/null 2>&1
		then
			export ub_gcloud_cloud_server_uid="$ub_gcloud_cloud_server_name"
		fi
		
		[[ "$ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _gcloud_cloud_server_create: miss'
	done
	[[ "$ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _gcloud_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _gcloud_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	
	_gcloud_cloud_server_status "$ub_gcloud_cloud_server_uid"
	
	_gcloud_cloud_cred_reset
	
	return 0
}
_gcloud_cloud_server_create_API--default() {
	# https://cloud.google.com/compute/docs/instances/create-start-instance#gcloud
	gcloud compute instances create "$ub_gcloud_cloud_server_name" --image-family=debian-10 --image-project=debian-cloud --machine-type="N1 shared-core"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _gcloud_cloud_self_server_list _gcloud_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _gcloud_cloud_self_server_list _gcloud_cloud_self_server_status-filter 'workstation'
_gcloud_cloud_self_server_list() {
	_messageNormal 'init: _gcloud_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	_messagePlain_nominal 'attempt: _gcloud_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_gcloud_cloud_server_uid
	current_ub_gcloud_cloud_server_uid=
	while [[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		# WARNING: WIP, Untested.
		# WARNING: TODO
		
		#curl -X GET "https://api.gcloud.com/v4/gcloud/instances" -H "Authorization: Bearer $ub_gcloud_TOKEN" > "$cloudTmp"/reply
		#current_ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data[0].id' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _gcloud_cloud_self_server_list: miss'
	done
	[[ "$current_ub_gcloud_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _gcloud_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _gcloud_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.data[].id,.data[].label'
	_stop_cloud_tmp
	_gcloud_cloud_cred_reset
	
	return 0
}



_gcloud_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _gcloud_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _gcloud_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_gcloud_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_gcloud_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_gcloud_cloud_server_uid" != "null" ]] && [[ "$ub_gcloud_cloud_server_name" != "null" ]] && [[ "$ub_gcloud_cloud_server_uid" != "" ]] && [[ "$ub_gcloud_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_gcloud_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			# WARNING: WIP, Untested.
			
			while ! gcloud compute instances delete "$ub_gcloud_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_gcloud_cloud_server_uid=
		export ub_gcloud_cloud_server_name=
		
		ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_gcloud_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_gcloud_cloud_server_uid
		_messagePlain_probe_var ub_gcloud_cloud_server_name
		
	done
	_messagePlain_good  'done: _gcloud_cloud_self_server_dispose-filter'
	
	return 0
}


_gcloud_cloud_self_server_status-filter() {
	_messageNormal 'init: _gcloud_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _gcloud_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_gcloud_cloud_server_uid="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	export ub_gcloud_cloud_server_name="$ubiquitiousBashIDnano"$(_uid 18)"$ubiquitiousBashIDnano"
	while [[ "$ub_gcloud_cloud_server_uid" != "null" ]] && [[ "$ub_gcloud_cloud_server_name" != "null" ]] && [[ "$ub_gcloud_cloud_server_uid" != "" ]] && [[ "$ub_gcloud_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_gcloud_cloud_server_name" | grep "$@"
		then
			_gcloud_cloud_self_server_status "$ub_gcloud_cloud_server_uid"
		fi
		
		export ub_gcloud_cloud_server_uid=
		export ub_gcloud_cloud_server_name=
		
		ub_gcloud_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_gcloud_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_gcloud_cloud_server_uid
		_messagePlain_probe_var ub_gcloud_cloud_server_name
		
	done
	_messagePlain_good  'done: _gcloud_cloud_self_server_status-filter'
	
	return 0
}


_gcloud_cloud_self_server_status() {
	_messageNormal 'init: _gcloud_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_gcloud_cloud_cred
	
	
	# WARNING: WIP, Untested.
	# WARNING: TODO
	
	#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $ub_gcloud_TOKEN" "https://api.gcloud.com/v4/gcloud/instances/$ub_gcloud_cloud_server_uid" > "$cloudTmp"/reply_status
	
	
	
	
	export ub_gcloud_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.ipv4[0]' | tr -dc 'a-zA-Z0-9.:_-')
	export ub_gcloud_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.ipv6' | tr -dc 'a-zA-Z0-9.:_-')
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_gcloud_cloud_server_ssh_cred=
	export ub_gcloud_cloud_server_ssh_port=
	
	export ub_gcloud_cloud_server_vnc_cred=
	export ub_gcloud_cloud_server_vnc_port=
	
	export ub_gcloud_cloud_server_serial=
	
	export ub_gcloud_cloud_server_novnc_cred=
	export ub_gcloud_cloud_server_novnc_port=
	export ub_gcloud_cloud_server_novnc_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_novnc_port"/novnc/
	export ub_gcloud_cloud_server_novnc_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_novnc_port"/novnc/
	
	export ub_gcloud_cloud_server_shellinabox_port=
	export ub_gcloud_cloud_server_shellinabox_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_shellinabox_port"/shellinabox/
	export ub_gcloud_cloud_server_shellinabox_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_gcloud_cloud_server_remotedesktopwebclient_port=
	export ub_gcloud_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_gcloud_cloud_server_addr_ipv4":"$ub_gcloud_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_gcloud_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_gcloud_cloud_server_addr_ipv6":"$ub_gcloud_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_gcloud_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}






























































_gcloud() {
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	local currentBin_gcloud
	currentBin_gcloud="$ub_function_override_gcloud"
	[[ "$currentBin_gcloud" == "" ]] && currentBin_gcloud=$(type -p gcloud 2> /dev/null)
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/gcloud/.ssh
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	
	# CAUTION: Highly irregular.
	
	# https://cloud.google.com/sdk/docs/configurations
	
	[[ "$currentBin_gcloud" == "" ]] && return 1
	[[ ! -e "$currentBin_gcloud" ]] && return 1
	
	_editFakeHome "$currentBin_gcloud" "$@"
}

_gcloud_reset() {
	export ub_function_override_gcloud=''
	unset ub_function_override_gcloud
	unset gcloud
}

_gcloud_set() {
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	export ub_function_override_gcloud=$(type -p gcloud 2> /dev/null)
	gcloud() {
		_gcloud "$@"
	}
}





















# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_gcloud' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'


# ###

# https://github.com/tensorflow/cloud#cluster-and-distribution-strategy-configuration
# https://www.tensorflow.org/api_docs/python/tf/distribute/OneDeviceStrategy
# https://www.tensorflow.org/guide/distributed_training
# https://colab.research.google.com/notebooks/intro.ipynb

# https://github.com/tensorflow/cloud#setup-instructions

#which gcloud

#export PROJECT_ID=<your-project-id>
#gcloud config set project $PROJECT_ID

#export SA_NAME=<your-sa-name>
#gcloud iam service-accounts create $SA_NAME
#gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --role 'roles/editor'
#gcloud iam service-accounts keys create ~/key.json --iam-account $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

#export GOOGLE_APPLICATION_CREDENTIALS=~/key.json

#BUCKET_NAME="your-bucket-name"
#REGION="us-central1"
#gcloud auth login
#gsutil mb -l $REGION gs://$BUCKET_NAME

#gcloud auth configure-docker





# https://cloud.google.com/sdk/docs/install
# https://cloud.google.com/sdk/gcloud/reference/components/update

# ###





_test_gcloud_upstream_sequence() {
	_start
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$safeTmp"
	
	
	_mustGetSudo
	! _wantSudo && return 1
	
	
	echo
	
	_gcloud components update
	
	echo
	
	cp "$scriptLocal"/upstream/google-cloud-sdk-338.0.0-linux-x86_64.tar.gz ./ > /dev/null 2>&1
	
	# ATTENTION: ATTENTION: WARNING: CAUTION: DANGER: High maintenance. Expect to break and manually update frequently!
	local currentIterations
	currentIterations=0
	while [[ $(cksum google-cloud-sdk-338.0.0-linux-x86_64.tar.gz | env CMD_ENV=xpg4 cksum | cut -f1 -d\  | tr -dc '0-9' 2> /dev/null) != '3136626824' ]]
	do
		let currentIterations="$currentIterations + 1"
		! [[ "$currentIterations" -lt 2 ]] && _stop 1
		curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-338.0.0-linux-x86_64.tar.gz
	done
	
	! tar -xpf google-cloud-sdk-338.0.0-linux-x86_64.tar.gz && _stop 1
	
	
	# WARNING: CAUTION: DANGER: Highly irregular. Replaces entire directory in 'HOME' directory after making a temporary copy for user.
	
	
	! [[ -e "$HOME" ]] && return 1
	[[ "$HOME" == "" ]] && _stop 1
	[[ "$HOME" == "/" ]] && _stop 1
	[[ "$HOME" == "-"* ]] && _stop 1
	
	if ! mkdir -p "$HOME"/'.gcloud/google-cloud-sdk'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$HOME"/'.gcloud/google-cloud-sdk'
	then
		_stop 1
	fi
	
	if ! mkdir -p "$HOME"/'.gcloud/google-cloud-sdk_bak'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$HOME"/'.gcloud/google-cloud-sdk_bak'
	then
		_stop 1
	fi
	
	if ! _safeBackup "$safeTmp"/'google-cloud-sdk'
	then
		_stop 1
	fi
	
	sudo -n rsync -ax --delete "$HOME"/'.gcloud/google-cloud-sdk'/. "$HOME"/'.gcloud/google-cloud-sdk_bak'/.
	sudo -n rsync -ax --delete "$safeTmp"/'google-cloud-sdk'/. "$HOME"/'.gcloud/google-cloud-sdk'/.
	
	
	cd "$HOME"/'.gcloud'/
	
	#export CLOUDSDK_ROOT_DIR="$HOME"/google-cloud-sdk
	
	./google-cloud-sdk/install.sh --help
	
	./google-cloud-sdk/install.sh --quiet --usage-reporting false --command-completion false --path-update false
	
	#./google-cloud-sdk/bin/gcloud init
	
	cd "$safeTmp"
	
	echo
	
	_gcloud config set disable_usage_reporting false
	
	echo
	
	_gcloud components update

	echo
	
	
	
	cd "$functionEntryPWD"
	_stop
}






_test_gcloud() {
	_getDep 'python3'
	_getDep 'pip'
	
	if [[ "$nonet" != "true" ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	then
		_messagePlain_request 'ignore: upstream progress ->'
		"$scriptAbsoluteLocation" _test_gcloud_upstream_sequence "$@"
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	
	if [[ "$PATH" != *'.gcloud/google-cloud-sdk'* ]]
	then
		. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
		. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
	fi
	
	#_wantSudo && _wantGetDep gcloud
	
	
	! _typeDep gcloud && echo 'warn: missing: gcloud'
	
	
	
	return 0
}







