#####Idle

_gosuBinary() {
	echo "$hostArch" | grep x86_64 > /dev/null 2>&1 && export gosuBinary="gosu-amd64" && return
	echo "$hostArch" | grep x86 > /dev/null 2>&1 && export gosuBinary="gosu-i386" && return
	echo "$hostArch" | grep arm > /dev/null 2>&1 && export gosuBinary="gosu-armel" && return
	
	uname -m | grep x86_64 > /dev/null 2>&1 && export gosuBinary="gosu-amd64" && return
	uname -m | grep x86 > /dev/null 2>&1 && export gosuBinary="gosu-i386" && return
	uname -m | grep arm > /dev/null 2>&1 && export gosuBinary="gosu-armel" && return
}

_gosuExecVirt() {
	_gosuBinary
	
	if [[ "$1" == "" ]]
	then
		exec "$scriptBin"/"$gosuBinary" "$virtSharedUser" /bin/bash "$@"
		return
	fi
	
	exec "$scriptBin"/"$gosuBinary" "$virtSharedUser" "$@"
}

_test_buildGoSu() {
	_getDep gpg
	_getDep dirmngr
}

_testBuiltGosu() {
	#export PATH="$PATH":"$scriptBin"
	
	_getDep gpg
	_getDep dirmngr
	
	_gosuBinary
	
	_checkDep "$gosuBinary"
	
	#Beware, this test requires either root or sudo to actually verify functionality.
	if ! "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1 && ! sudo -n "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1
	then
		echo gosu invalid response
		_stop 1
	fi
	
	return 0
}

_verifyGosu_sequence() {
	_start
	
	local gpgTestDir
	gpgTestDir="$safeTmp"
	[[ -e "$scriptBin"/gosu-armel ]] && [[ -e "$scriptBin"/gosu-armel.asc ]] && [[ -e "$scriptBin"/gosu-amd64 ]] && [[ -e "$scriptBin"/gosu-amd64.asc ]] && [[ -e "$scriptBin"/gosu-i386 ]] && [[ -e "$scriptBin"/gosu-i386.asc ]] && [[ -e "$scriptBin"/gosudev.asc ]] && gpgTestDir="$scriptBin" #&& _stop 1
	
	[[ "$1" != "" ]] && gpgTestDir="$1"
	
	if ! [[ -e "$gpgTestDir"/gosu-armel ]] || ! [[ -e "$gpgTestDir"/gosu-armel.asc ]] || ! [[ -e "$gpgTestDir"/gosu-amd64 ]] || ! [[ -e "$gpgTestDir"/gosu-amd64.asc ]] || ! [[ -e "$gpgTestDir"/gosu-i386 ]] || ! [[ -e "$gpgTestDir"/gosu-i386.asc ]] || ! [[ -e "$gpgTestDir"/gosudev.asc ]]
	then
		_stop 1
	fi
	
	# verify the signature
	export GNUPGHOME="$shortTmp"/vgosu
	mkdir -m 700 -p "$GNUPGHOME" > /dev/null 2>&1
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/vgosu
	
	# TODO Add further verification steps.
	gpg -q --batch --armor --import "$gpgTestDir"/gosudev.asc || _stop 1
	
	gpg --batch --verify "$gpgTestDir"/gosu-armel.asc "$gpgTestDir"/gosu-armel || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-amd64.asc "$gpgTestDir"/gosu-amd64 || _stop 1
	gpg --batch --verify "$gpgTestDir"/gosu-i386.asc "$gpgTestDir"/gosu-i386 || _stop 1
	
	_stop
}

_verifyGosu() {
	if ! "$scriptAbsoluteLocation" _verifyGosu_sequence "$@"
	then
		return 1
	fi
	return 0
}

_testGosu() {
	_getDep gpg
	_getDep dirmngr
	
	if ! _verifyGosu > /dev/null 2>&1
	then
		echo 'need valid gosu'
		_stop 1
	fi
	return 0
}

#From https://github.com/tianon/gosu/blob/master/INSTALL.md .
# TODO Build locally from git repo and verify.
_buildGosu_sequence() {
	_start
	
	local haveGosuBin
	haveGosuBin=false
	if [[ -e "$scriptBin"/gosu-armel ]] && [[ -e "$scriptBin"/gosu-armel.asc ]] && [[ -e "$scriptBin"/gosu-amd64 ]] && [[ -e "$scriptBin"/gosu-amd64.asc ]] && [[ -e "$scriptBin"/gosu-i386 ]] && [[ -e "$scriptBin"/gosu-i386.asc ]] && [[ -e "$scriptBin"/gosudev.asc ]] && haveGosuBin=true
	then
		_wantSudo && _testBuiltGosu && return 0
	fi
	#&& return 0
	
	local GOSU_VERSION
	GOSU_VERSION=1.10
	
	if [[ "$haveGosuBin" != "true" ]]
	then
		wget -O "$safeTmp"/gosu-armel https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel
		wget -O "$safeTmp"/gosu-armel.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel.asc
		
		wget -O "$safeTmp"/gosu-amd64 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
		wget -O "$safeTmp"/gosu-amd64.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc
		
		wget -O "$safeTmp"/gosu-i386 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386
		wget -O "$safeTmp"/gosu-i386.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386.asc
	fi
	
	export GNUPGHOME="$shortTmp"/bgosu
	mkdir -m 700 -p "$GNUPGHOME" > /dev/null 2>&1
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/bgosu
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || _stop 1
	gpg --armor --export 036A9C25BF357DD4 > "$safeTmp"/gosudev.asc || _stop 1
	
	if [[ "$haveGosuBin" != "true" ]]
	then
		_verifyGosu "$safeTmp" > /dev/null 2>&1 || _stop 1
	fi
	if [[ "$haveGosuBin" == "true" ]]
	then
		_verifyGosu "$scriptBin" > /dev/null 2>&1 || _stop 1
	fi
	
	[[ "$haveGosuBin" != "true" ]] && mv "$safeTmp"/gosu* "$scriptBin"/
	[[ "$haveGosuBin" != "true" ]] && chmod ugoa+rx "$scriptBin"/gosu-*
	
	_stop
}

_buildGosu() {
	"$scriptAbsoluteLocation" _buildGosu_sequence "$@"
}
