#####Idle

_gosuBinary() {
	uname -m | grep x86 > /dev/null 2>&1 && export gosuBinary="gosu-i386"
	uname -m | grep x86_64 > /dev/null 2>&1 && export gosuBinary="gosu-amd64"
	uname -m | grep arm > /dev/null 2>&1 && export gosuBinary="gosu-armel"
}

_gosuExec() {
	_gosuBinary
	
	if [[ "$1" == "" ]]
	then
		exec "$scriptBin"/"$gosuBinary" "$virtGuestUser" /bin/bash "$@"
		return
	fi
	
	exec "$scriptBin"/"$gosuBinary" "$virtGuestUser" "$@"
}

_testBuiltGosu() {
	#export PATH="$PATH":"$scriptBin"
	
	_checkDep gpg
	_checkDep dirmngr
	
	_gosuBinary
	
	_checkDep "$gosuBinary"
	
	#Beware, this test requires either root or sudo to actually verify functionality.
	if ! "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1 && ! sudo -n "$scriptBin"/"$gosuBinary" "$USER" true >/dev/null 2>&1
	then
		echo gosu invalid response
		_stop 1
	fi
	
}

#From https://github.com/tianon/gosu/blob/master/INSTALL.md .
# TODO Build locally from git repo and verify.
_buildGosu() {
	_start
	
	local GOSU_VERSION
	GOSU_VERSION=1.10
	
	wget -O "$safeTmp"/gosu-armel https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel
	wget -O "$safeTmp"/gosu-armel.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-armel.asc
	
	wget -O "$safeTmp"/gosu-amd64 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
	wget -O "$safeTmp"/gosu-amd64.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc
	
	wget -O "$safeTmp"/gosu-i386 https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386
	wget -O "$safeTmp"/gosu-i386.asc https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-i386.asc
	
	# verify the signature
	export GNUPGHOME="$shortTmp"/vgosu
	mkdir -p "$GNUPGHOME"
	chmod 700 "$shortTmp"/vgosu
	
	# TODO Add further verification steps.
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
	
	gpg --batch --verify "$safeTmp"/gosu-armel.asc "$safeTmp"/gosu-armel || _stop 1
	gpg --batch --verify "$safeTmp"/gosu-amd64.asc "$safeTmp"/gosu-amd64 || _stop 1
	gpg --batch --verify "$safeTmp"/gosu-i386.asc "$safeTmp"/gosu-i386 || _stop 1
	
	mv "$safeTmp"/gosu-* "$scriptBin"/
	chmod ugoa+rx "$scriptBin"/gosu-*
	
	_stop
}
