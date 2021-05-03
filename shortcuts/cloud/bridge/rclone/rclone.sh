#rclone




# ATTENTION: Intended to be used by '_index' shortcuts as with 'cautossh' '_setup' .
_rclone() {
	local currentBin_rclone
	currentBin_rclone="$ub_function_override_rclone"
	[[ "$currentBin_rclone" == "" ]] && currentBin_rclone=$(type -p rclone 2> /dev/null)
	
	mkdir -p "$scriptLocal"/rclone
	[[ ! -e "$scriptLocal"/rclone ]] && return 1
	[[ ! -d "$scriptLocal"/rclone ]] && return 1
	
	# WARNING: Changing '$HOME' may interfere with 'cautossh' , specifically function '_ssh' .
	#env XDG_CONFIG_HOME="$scriptLocal"/rclone HOME="$scriptLocal"/rclone rclone --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
	#env XDG_CONFIG_HOME="$scriptLocal"/rclone rclone --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
	
	env XDG_CONFIG_HOME="$scriptLocal"/rclone "$currentBin_rclone" --config="$scriptLocal"/rclone/rclone/rclone.conf "$@"
}

_rclone_reset() {
	export ub_function_override_rclone=''
	unset ub_function_override_rclone
	unset rclone
}

# ATTENTION: Intended to be called from '_cloud_set' or similar, in turn called by '_cloud_hook', in turn used by '_index' shortcuts as with 'cautossh' '_setup' .
_rclone_set() {
	export ub_function_override_rclone=$(type -p rclone 2> /dev/null)
	rclone() {
		_rclone "$@"
	}
}









# https://en.wikipedia.org/wiki/Rclone
# https://par.nsf.gov/servlets/purl/10073416
# https://www.chpc.utah.edu/documentation/software/rclone.php#eteooop

# https://packages.debian.org/sid/rclone
# https://rclone.org/downloads/

# https://linuxaria.com/howto/how-to-install-a-single-package-from-debian-sid-or-debian-testing
# https://askubuntu.com/questions/27362/how-to-only-install-updates-from-a-specific-repository

# WARNING: Exceptional. Unlike the vast majority of other programs, 'cloud' API software may require frequent updates, due to the strong possibility of frequent breaking changes to what actually ammounts to an *ABI* (NOT an API) . Due to this severe irregularity, '_test_rclone' and similar functions must *always* attempt an upstream update if possible and available .
	# https://par.nsf.gov/servlets/purl/10073416
	# ' Navigating the Unexpected Realities of Big Data Transfers in a Cloud-based World '
		# 'Because many of these tools are relatively new and are evolving rapidly they tend to be rather fragile. Consequently, one cannot assume they will actually work reliably in all situations.'

# WARNING: Infinite loop risk, do not call '_wantGetDep rclone' within this function.
_test_rclone_upstream_beta() {
	! _wantSudo && return 1
	
	echo
	curl https://rclone.org/install.sh | sudo bash -s beta
	echo
}

# WARNING: Infinite loop risk, do not call '_wantGetDep rclone' within this function.
_test_rclone_upstream() {
	! _wantSudo && return 1
	
	echo
	curl https://rclone.org/install.sh | sudo bash
	echo
}


_test_rclone() {
	if [[ "$nonet" != "true" ]]
	then
		_messagePlain_request 'ignore: upstream progress ->'
		
		_test_rclone_upstream "$@"
		#_test_rclone_upstream_beta "$@"
		
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	_wantSudo && _wantGetDep rclone
	
	! _typeDep rclone && echo 'warn: missing: rclone'
	
	return 0
}




