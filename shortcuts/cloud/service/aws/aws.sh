#aws

# ATTENTION: ATTENTION: Cloud VPS API wrapper 'de-facto' reference implementation is 'digitalocean' !
# Obvious naming conventions and such are to be considered from that source first.


# WARNING: DANGER: WIP, Untested .


# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
# https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
_aws_cloud_cred() {
	_aws_set "$@"
}
_aws_cloud_cred_reset() {
	_aws_reset "$@"
}



# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# "$1" == ub_aws_cloud_server_name
_aws_cloud_server_create() {
	_messageNormal 'init: _aws_cloud_server_create'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	export ub_aws_cloud_server_name="$1"
	[[ "$ub_aws_cloud_server_name" == "" ]] && export ub_aws_cloud_server_name=$(_uid)
	
	
	_messagePlain_nominal 'attempt: _aws_cloud_server_create: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	export ub_aws_cloud_server_uid=
	while [[ "$ub_aws_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		_aws_cloud_server_create_API--us-east_g5-standard-2_debian9 "$ub_aws_cloud_server_name" > "$cloudTmp"/reply
		export ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | grep -v 'PrivateDnsName' |  jq '.'Instances[].InstanceId | tr -dc 'a-zA-Z0-9.:_-')
		_aws_cloud_server_name_API "$ub_aws_cloud_server_uid" "$ub_aws_cloud_server_name"
		
		[[ "$ub_aws_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _aws_cloud_server_create: miss'
	done
	[[ "$ub_aws_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _aws_cloud_server_create: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _aws_cloud_server_create: pass'
	
	_stop_cloud_tmp
	
	
	
	_aws_cloud_server_status "$ub_aws_cloud_server_uid"
	
	_aws_cloud_cred_reset
	
	return 0
}
_aws_cloud_server_create_API--image_ami-xxxxxxxx() {
	# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
	#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name "$ubiquitousBashIDshort" --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e
	aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name "$ubiquitousBashIDshort" --security-group-ids sg-"$ubiquitousBashIDshort" --subnet-id subnet-"$ubiquitousBashIDshort"
}
_aws_cloud_server_name_API() {
	aws ec2 create-tags --resources "$ub_aws_cloud_server_uid" --tags Key=Name,Value="$ub_aws_cloud_server_name"
}



# ATTENTION: Consider that Cloud services are STRICTLY intended as end-user functions - manual 'cleanup' of 'expensive' resources MUST be feasible!
# "$@" == _functionName (must process JSON file - ie. loop through - jq '.data[0].id,.data[0].label' )
# EXAMPLE: _aws_cloud_self_server_list _aws_cloud_self_server_dispose-filter 'temporaryBuild'
# EXAMPLE: _aws_cloud_self_server_list _aws_cloud_self_server_status-filter 'workstation'
_aws_cloud_self_server_list() {
	_messageNormal 'init: _aws_cloud_self_server_list'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	_messagePlain_nominal 'attempt: _aws_cloud_self_server_list: Cloud Services API Request'
	local currentIterations
	currentIterations=0
	local current_ub_aws_cloud_server_uid
	current_ub_aws_cloud_server_uid=
	while [[ "$current_ub_aws_cloud_server_uid" == "" ]] && [[ "$currentIterations" -lt 3 ]]
	do
		let currentIterations="$currentIterations + 1"
		
		# WARNING: WIP, Untested.
		# https://serverfault.com/questions/578921/how-would-you-go-about-listing-instances-using-aws-cli-in-certain-vpc-with-the-t
		#aws ec2 describe-instances --no-paginate --filters "Name=instance-type,Values=t2.micro" --query 'Reservations[*].Instances[*].{Instance:InstanceId,Tags[0]}' --output json > "$cloudTmp"/reply
		#aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value[]]' --output json > "$cloudTmp"/reply
		aws ec2 describe-instances --no-paginate --query 'Reservations[].Instances[].{InstanceId,Tags[?Key==`Name`].Value[0]}' --output json > "$cloudTmp"/reply
		current_ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.[0].Instance' | tr -dc 'a-zA-Z0-9.:_-')
		
		[[ "$current_ub_aws_cloud_server_uid" == "" ]] && _messagePlain_warn 'attempt: _aws_cloud_self_server_list: miss'
	done
	[[ "$current_ub_aws_cloud_server_uid" == "" ]] && _messagePlain_bad 'attempt: _aws_cloud_self_server_list: fail' && _stop_cloud_tmp && _messageFAIL && _stop 1
	_messagePlain_good  'attempt: _aws_cloud_self_server_list: pass'
	
	
	"$@"
	
	
	_messagePlain_request 'request: Please review CloudVM list for unnecessary expense.'
	cat "$cloudTmp"/reply | jq '.[].Instance,.[].Tags'
	_stop_cloud_tmp
	_aws_cloud_cred_reset
	
	return 0
}



_aws_cloud_self_server_dispose-filter() {
	_messageNormal 'init: _aws_cloud_self_server_dispose-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _aws_cloud_self_server_dispose-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_aws_cloud_server_uid="$ubiquitousBashIDnano"$(_uid 18)"$ubiquitousBashIDnano"
	export ub_aws_cloud_server_name="$ubiquitousBashIDnano"$(_uid 18)"$ubiquitousBashIDnano"
	while [[ "$ub_aws_cloud_server_uid" != "null" ]] && [[ "$ub_aws_cloud_server_name" != "null" ]] && [[ "$ub_aws_cloud_server_uid" != "" ]] && [[ "$ub_aws_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_aws_cloud_server_name" | grep "$@"
		then
			currentIterations_inner=0
			
			# WARNING: Significant experimentation may be required.
			# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
			
			#"$ub_aws_cloud_server_uid"
			while ! aws ec2 terminate-instances --instance-ids "$ub_aws_cloud_server_uid" > /dev/null 2>&1 && [[ "$currentIterations_inner" -lt 3 ]]
			do
				let currentIterations_inner="$currentIterations_inner + 1"
			done
		fi
		
		export ub_aws_cloud_server_uid=
		export ub_aws_cloud_server_name=
		
		# WARNING: May work as intended without properly filtering for 'Name' 'tag' .
		ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.['"$currentIterations"'].Instance' | tr -dc 'a-zA-Z0-9.:_-')
		ub_aws_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.['"$currentIterations"'].Tags' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_aws_cloud_server_uid
		_messagePlain_probe_var ub_aws_cloud_server_name
		
	done
	_messagePlain_good  'done: _aws_cloud_self_server_dispose-filter'
	
	return 0
}


_aws_cloud_self_server_status-filter() {
	_messageNormal 'init: _aws_cloud_self_server_status-filter: '"$@"
	
	# WARNING: To match 'all' consider '.*' instead of empty.
	[[ "$1" == "" ]] && return 1
	
	
	_messagePlain_nominal 'loop: _aws_cloud_self_server_status-filter'
	local currentIterations
	currentIterations=0
	local currentIterations_inner
	currentIterations_inner=0
	export ub_aws_cloud_server_uid="$ubiquitousBashIDnano"$(_uid 18)"$ubiquitousBashIDnano"
	export ub_aws_cloud_server_name="$ubiquitousBashIDnano"$(_uid 18)"$ubiquitousBashIDnano"
	while [[ "$ub_aws_cloud_server_uid" != "null" ]] && [[ "$ub_aws_cloud_server_name" != "null" ]] && [[ "$ub_aws_cloud_server_uid" != "" ]] && [[ "$ub_aws_cloud_server_name" != "" ]] && [[ "$currentIterations" -lt 999 ]]
	do
		if _safeEcho "$ub_aws_cloud_server_name" | grep "$@"
		then
			_aws_cloud_self_server_status "$ub_aws_cloud_server_uid"
		fi
		
		export ub_aws_cloud_server_uid=
		export ub_aws_cloud_server_name=
		
		ub_aws_cloud_server_uid=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].id' | tr -dc 'a-zA-Z0-9.:_-')
		ub_aws_cloud_server_name=$(cat "$cloudTmp"/reply | jq '.data['"$currentIterations"'].label' | tr -dc 'a-zA-Z0-9.:_-')
		let currentIterations="$currentIterations + 1"
		
		_messagePlain_probe_var ub_aws_cloud_server_uid
		_messagePlain_probe_var ub_aws_cloud_server_name
		
	done
	_messagePlain_good  'done: _aws_cloud_self_server_status-filter'
	
	return 0
}


_aws_cloud_self_server_status() {
	_messageNormal 'init: _aws_cloud_self_server_status'
	
	_start_cloud_tmp
	
	_aws_cloud_cred
	
	# ATTENTION: NOTICE: Possibly an excellent means to obtain sample data for 'describe-instances' .
	
	aws ec2 describe-instances --instance-ids "$ub_aws_cloud_server_uid"
	
	
	
	# WARNING: WIP, Untested.
	
	
	
	#export ub_aws_cloud_server_addr_ipv4=$(cat "$cloudTmp"/reply_status | jq '.' | tr -dc 'a-zA-Z0-9.:_-')
	#export ub_aws_cloud_server_addr_ipv6=$(cat "$cloudTmp"/reply_status | jq '.' | tr -dc 'a-zA-Z0-9.:_-')
	
	export ub_aws_cloud_server_addr_ipv4=
	export ub_aws_cloud_server_addr_ipv6=
	
	
	# ATTENTION: Ubiquitous Bash 'queue' 'database' may be an appropriate means to store sane default 'cred' values after '_server_create' . Also consider storing relevant files under "$scriptLocal" .
	
	export ub_aws_cloud_server_ssh_cred=
	export ub_aws_cloud_server_ssh_port=
	
	export ub_aws_cloud_server_vnc_cred=
	export ub_aws_cloud_server_vnc_port=
	
	export ub_aws_cloud_server_serial=
	
	export ub_aws_cloud_server_novnc_cred=
	export ub_aws_cloud_server_novnc_port=
	export ub_aws_cloud_server_novnc_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_novnc_port"/novnc/
	export ub_aws_cloud_server_novnc_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_novnc_port"/novnc/
	
	export ub_aws_cloud_server_shellinabox_port=
	export ub_aws_cloud_server_shellinabox_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_shellinabox_port"/shellinabox/
	export ub_aws_cloud_server_shellinabox_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_shellinabox_port"/shellinabox/
	
	export ub_aws_cloud_server_remotedesktopwebclient_port=
	export ub_aws_cloud_server_remotedesktopwebclient_url_ipv4=https://"$ub_aws_cloud_server_addr_ipv4":"$ub_aws_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	export ub_aws_cloud_server_remotedesktopwebclient_url_ipv6=https://"$ub_aws_cloud_server_addr_ipv6":"$ub_aws_cloud_server_remotedesktopwebclient_port"/remotedesktopwebclient/
	
	
	
	if ! [[ -e "$cloudTmp"/reply ]]
	then
		_aws_cloud_cred_reset
		_stop_cloud_tmp
	fi
	
	return 0
}



























# ATTENTION: Intended to be used by '_index' shortcuts as with 'cautossh' '_setup' .
_aws() {
	local currentBin_aws
	currentBin_aws="$ub_function_override_aws"
	[[ "$currentBin_aws" == "" ]] && currentBin_aws=$(type -p aws 2> /dev/null)
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.ssh
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	env AWS_PROFILE="$netName" AWS_CONFIG_FILE="$scriptLocal"/cloud/aws/.aws/config HOME="$scriptLocal"/cloud/aws "$currentBin_aws" "$@"
}

_aws_reset() {
	export ub_function_override_aws=''
	unset ub_function_override_aws
	unset aws
}

# ATTENTION: Intended to be called from '_cloud_set' or similar, in turn called by '_cloud_hook', in turn used by '_index' shortcuts as with 'cautossh' '_setup' .
_aws_set() {
	export ub_function_override_aws=$(type -p aws 2> /dev/null)
	aws() {
		_aws "$@"
	}
}


# CAUTION: Discouraged. No production use. Historical installation failure.
# https://github.com/aws/aws-cli/issues/8036#issuecomment-1638544754
#  SEVERE - 'We do not recommend installing an older version of PyYAML as PyYAML version 5.3.1 is associated with CVE-2020-14343 that was fixed in version 5.4.'
_aws_eb() {
	local currentBin_aws_eb
	currentBin_aws_eb="$ub_function_override_aws_eb"
	[[ "$currentBin_aws_eb" == "" ]] && currentBin_aws_eb=$(type -p eb 2> /dev/null)
	
	#if [[ "$PATH" != *'.pyenv/versions'* ]]
	#then
		local current_python_path_version
		current_python_path_version=$("$currentBin_aws_eb" --version | sed 's/.*Python\ //g' | tr -dc 'a-zA-Z0-9.')
		#export PATH="$HOME/.pyenv/versions/$current_python_path_version/bin:$PATH"
	#fi
	
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.aws
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
	env PATH="$HOME/.pyenv/versions/$current_python_path_version/bin:$PATH" AWS_PROFILE="$netName" AWS_CONFIG_FILE="$scriptLocal"/cloud/aws/.aws/config HOME="$scriptLocal"/cloud/aws "$currentBin_aws_eb" "$@"
}
# CAUTION: Discouraged. No production use. Historical installation failure.
# https://github.com/aws/aws-cli/issues/8036#issuecomment-1638544754
#  SEVERE - 'We do not recommend installing an older version of PyYAML as PyYAML version 5.3.1 is associated with CVE-2020-14343 that was fixed in version 5.4.'
_eb() {
	_aws_eb "$@"
}

# CAUTION: Discouraged. No production use. Historical installation failure.
# https://github.com/aws/aws-cli/issues/8036#issuecomment-1638544754
#  SEVERE - 'We do not recommend installing an older version of PyYAML as PyYAML version 5.3.1 is associated with CVE-2020-14343 that was fixed in version 5.4.'
_aws_eb_reset() {
	export ub_function_override_aws_eb=''
	unset ub_function_override_aws_eb
	unset eb
}

# CAUTION: Discouraged. No production use. Historical installation failure.
# https://github.com/aws/aws-cli/issues/8036#issuecomment-1638544754
#  SEVERE - 'We do not recommend installing an older version of PyYAML as PyYAML version 5.3.1 is associated with CVE-2020-14343 that was fixed in version 5.4.'
_aws_eb_set() {
	if [[ "$PATH" != *'.ebcli-virtual-env/executables'* ]]
	then
		# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
		export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
	fi
	
	export ub_function_override_aws_eb=$(type -p eb 2> /dev/null)
	eb() {
		_eb "$@"
	}
}





# ATTENTION: Theoretically, it may be useful to merge an 'aws' 'home' directory to a user's actual 'home' directory. However, at best it is not known if this can be done with sufficiently portable programs. Moreover, it is not yet obvious whether this is in any way more desirable than function/path overrides alone, or may cause expensive 'human error' mistakes.
_aws_hook() {
	true
}
_aws_unhook() {
	true
}






# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_aws' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'


# ###

# https://aws.amazon.com/blogs/machine-learning/running-distributed-tensorflow-training-with-amazon-sagemaker/
# https://horovod.ai/getting-started/

#horovodrun -np 16 -H server1:4,server2:4,server3:4,server4:4 python train.py


# https://nodered.org/docs/getting-started/aws
#eb create


# https://nodered.org/docs/getting-started/aws
#sudo npm install -g --unsafe-perm pm2
#pm2 start `which node-red` -- -v
#pm2 save
#pm2 startup


# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-buckets-creating
#aws s3 mb s3://bucket-name

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html
#aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pe

# https://stackoverflow.com/questions/30809822/how-to-get-aws-command-line-interface-to-work-in-cygwin
# 'I had the same problem. I got around it by installing a new copy of AWSCLI within Cygwin. You first need to install the "curl" and "python" Cygwin packages, then you can install AWSCLI as follows:'
#curl -O https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
#pip install awscli
#hash -d aws

# ###


# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# WARNING: Infinite loop risk, do not call '_wantGetDep aws' or similar within this function.
_test_aws_upstream_sequence() {
	_start
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$safeTmp"
	
	
	_mustGetSudo
	! _wantSudo && return 1
	
	_getDep virtualenv
	
	echo
	
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip -q awscliv2.zip
	sudo -n ./aws/install
	sudo -n ./aws/install --update
	
	echo
	
	# CAUTION: Discouraged. No production use. Historical installation failure.
	# WARNING: Apparently there are upstream issues due to upstream python dependency breakage.
	# https://github.com/aws/aws-elastic-beanstalk-cli-setup/issues/148#issuecomment-1649387220
	# https://github.com/aws/aws-cli/issues/8036#issuecomment-1638544754
	#  SEVERE - 'We do not recommend installing an older version of PyYAML as PyYAML version 5.3.1 is associated with CVE-2020-14343 that was fixed in version 5.4.'
	# ATTENTION: Disabled by default.
	if false
	then

	sudo -n pip install --upgrade pip
	sudo -n pip install aws-shell
	#sudo -n pip install --break-system-packages aws-shell
	#sudo -n pip install --break-system-packages --upgrade aws-shell
	
	echo
	
	git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
	#./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
	#sudo -n ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
	python3 ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py
	
	export safeToDeleteGit="true"
	_safeRMR "$safeTmp"/aws-elastic-beanstalk-cli-setup
	export safeToDeleteGit=
	unset safeToDeleteGit
	
	echo
	
	# ATTENTION: Theoretically this should install 'nodered' and 'pm2' . Not enabled yet by default.
	# https://nodered.org/docs/getting-started/aws
	# https://github.com/nodesource/distributions#debinstall
	#curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -n -E bash -
	#sudo -n apt-get install -y nodejs
	#sudo -n npm install -g --unsafe-perm node-red
	#sudo -n npm install -g --unsafe-perm pm2
	
	#echo

	fi
	
	sudo chown -R "$USER":"$USER" "$safeTmp"
	cd "$functionEntryPWD"
	_stop
}

# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_aws() {
	# ATTENTION: Disabling for Docker containers is unusual , and may change. This is due to the unusual variety of Docker container dist/OS used, and that a use case has not been found for AWS, etc.
	if ! _if_cygwin
	then
		# zlib1g-dev
		_getDep 'zconf.h'
		_getDep 'zlib.h'
		_getDep 'pkgconfig/zlib.pc'
		
		# libssl-dev
		_getDep 'openssl/ssl3.h'
		_getDep 'openssl/aes.h'
		_getDep 'pkgconfig/openssl.pc'
		_getDep 'pkgconfig/libssl.pc'
		_getDep 'pkgconfig/libcrypto.pc'
		
		# libncurses-dev
		_getDep 'ncurses6-config'
		_getDep 'ncursesw6-config'
		_wantGetDep 'ncurses5-config'
		_wantGetDep 'ncursesw5-config'
		_getDep 'curses.h'
		_getDep 'pkgconfig/ncurses.pc'
		_getDep 'pkgconfig/ncursesw.pc'
		
		# libffi-dev
		_getDep 'ffitarget.h'
		_getDep 'pkgconfig/libffi.pc'
		
		# libsqlite3-dev
		_getDep 'sqlite3.h'
		_getDep 'sqlite3ext.h'
		_getDep 'pkgconfig/sqlite3.pc'
		
		# libreadline-dev
		_getDep 'readline/readline.h'
		_getDep 'libreadline.so'
		
		# libbz2-dev
		_getDep 'bzlib.h'
		_getDep 'libbz2.so'
		
		
		# python3-pypillowfight
		_getDep 'python3/dist-packages/pillowfight/__init__.py'
		
		# python3-wxgtk4.0
		_getDep 'python3/dist-packages/wx/__init__.py'
		
		# wxglade
		_getDep 'wxglade'
		
		
		_getDep 'unzip'
		
		
		_getDep 'python3'
		_getDep 'pip'
		
		
		
		
		if [[ "$nonet" != "true" ]] && cat /etc/issue 2>/dev/null | grep 'Debian' > /dev/null 2>&1
		then
			_messagePlain_request 'ignore: upstream progress ->'
			"$scriptAbsoluteLocation" _test_aws_upstream_sequence "$@"
			_messagePlain_request 'ignore: <- upstream progress'
		fi
	fi
	
	_wantSudo && _wantGetDep aws
	
	! _typeDep aws && echo 'warn: missing: aws'
	! _typeDep aws-shell && echo 'warn: missing: aws-shell'
	
	
	if [[ "$PATH" != *'.ebcli-virtual-env/executables'* ]]
	then
		# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
		export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
	fi
	
	
	! _typeDep eb && echo 'warn: missing: eb'
	
	
	
	return 0
}



