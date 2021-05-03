#google

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .



































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







