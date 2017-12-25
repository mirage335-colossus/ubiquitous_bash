_fetchDep_debianStretch_sequence() {
	_start
	
	! _wantSudo && _stop 1
	
	! _wantDep apt-file && sudo -n apt-get install -y apt-file
	
	sudo -n apt-file update
	sudo -n apt-get update
	sudo -n apt update
	
	sudo -n apt-file search --regexp "$1"'$' > "$safeTmp"/pkgs
	
	sudo -n apt-get install -y "$1"
	_wantDep "$1" && _stop 0
	
	local sysPathAll
	sysPathAll=$(sudo bash -c "echo \$PATH")
	sysPathAll="$PATH":"$sysPathAll"
	local sysPathArray
	IFS=':' read -r -a sysPathArray <<< "$sysPathAll"
	
	local currentSysPath
	local matchingPackageFile
	local matchingPackagePath
	for currentSysPath in "${sysPathArray[@]}"
	do
		matchingPackageFile=""
		matchingPackagePath=""
		matchingPackageFilename=^"$currentSysPath"/"$1"$
		matchingPackageFile=$(grep "$safeTmp"/pkgs \'"$matchingPackageFilename"\' | cut -f2- -d' ')
		
		if [[ "$matchingPackageFile" != "" ]]
		then
			sudo -n apt-get install -y "$matchingPackageFile"
			_wantDep "$1" && _stop 0
		fi
	done
	
	matchingPackageFile=$(head -n 1 "$safeTmp"/pkgs | cut -f2- -d' ')
	sudo -n apt-get install -y "$matchingPackageFile"
	_wantDep "$1" && _stop 0
	
	
	
	_stop 1
}

_fetchDep_debianStretch() {
	"$scriptAbsoluteLocation" _fetchDep_debianStretch_sequence "$@"
}

_fetchDep_debian() {
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 1 | grep 9 > /dev/null 2>&1
	then
		_fetchDep_debianStretchh
		return
	fi
	
	return 1
}
