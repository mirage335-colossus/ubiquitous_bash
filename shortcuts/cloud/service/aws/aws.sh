#aws



# ATTENTION: Intended to be used by '_index' shortcuts as with 'cautossh' '_setup' .
_aws() {
	local currentBin_aws
	currentBin_aws="$ub_function_override_aws"
	[[ "$currentBin_aws" == "" ]] && currentBin_aws=$(type -p aws 2> /dev/null)
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.aws
	
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



_aws_eb() {
	local currentBin_aws_eb
	currentBin_aws_eb="$ub_function_override_aws_eb"
	[[ "$currentBin_aws_eb" == "" ]] && currentBin_aws_eb=$(type -p eb 2> /dev/null)
	
	if [[ "$PATH" != *'.pyenv/versions'* ]]
	then
		local current_python_path_version
		current_python_path_version=$("$currentBin_aws_eb" --version | sed 's/.*Python\ //g' | tr -dc 'a-zA-Z0-9.')
		export PATH="$HOME/.pyenv/versions/$current_python_path_version/bin:$PATH"
	fi
	
	
	mkdir -p "$scriptLocal"/cloud/aws/.aws
	[[ ! -e "$scriptLocal"/cloud/aws/.aws ]] && return 1
	[[ ! -d "$scriptLocal"/cloud/aws/.aws ]] && return 1
	
	# WARNING: Not guaranteed.
	_relink "$HOME"/.ssh "$scriptLocal"/cloud/aws/.aws
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	
	env AWS_PROFILE="$netName" AWS_CONFIG_FILE="$scriptLocal"/cloud/aws/.aws/config HOME="$scriptLocal"/cloud/aws "$currentBin_aws_eb" "$@"
}

_aws_eb_reset() {
	export ub_function_override_aws_eb=''
	unset ub_function_override_aws_eb
	unset eb
}

_aws_eb_set_() {
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
	
	echo
	
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo -n ./aws/install
	
	echo
	
	git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
	./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
	#sudo -n ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
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
	
	
	cd "$functionEntryPWD"
	_stop
}

# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_aws() {
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
	_getDep 'ncurses5-config'
	_getDep 'ncursesw5-config'
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
	
	
	
	
	if [[ "$nonet" != "true" ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	then
		_test_aws_upstream_sequence "$@"
	fi
	
	_wantSudo && _wantGetDep aws
	
	! _typeDep aws && echo 'warn: missing: aws'
	! _typeDep aws-shell && echo 'warn: missing: aws-shell'
	
	return 0
}



