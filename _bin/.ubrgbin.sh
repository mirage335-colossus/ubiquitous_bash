#!/usr/bin/env bash

# WARNING Changes to this script's API may necessitate changes to several ubiquitous_bash functions.

#Copies only smaller binaries necessary for general purpose shell glue or virtualization operations, leaving out specialized applications which may inflate embedded resources (eg. bootdisc) or cause interference (setupUbiquitous).
#"$1" == "$scriptBin"
#"$2" == destination
_ubrgbin_cpA() {
	mkdir -p "$2"
	
	cp -a "$1"/dockerHello.tar "$2"
	cp -a "$1"/getIdle "$2"
	cp -a "$1"/gosu-amd64 "$2"
	cp -a "$1"/gosu-amd64.asc "$2"
	cp -a "$1"/gosu-armel "$2"
	cp -a "$1"/gosu-armel.asc "$2"
	cp -a "$1"/gosu-i386 "$2"
	cp -a "$1"/gosu-i386.asc "$2"
	cp -a "$1"/gosudev.asc "$2"
	cp -a "$1"/hello "$2"
	cp -a "$1"/MAKEDEV "$2"
	
	[[ -e "$1"/b85 ]] && cp -a "$1"/b85 "$2"
	
	cp -a "$1"/.ubrgbin.sh "$2"
}


#Launch internal commands as parameters.
if [[ "$1" == '_'* ]]
then
	"$@"
	ubrgbin_exitStatus="$?"
	#Exit if not imported into existing shell, or bypass requested, else fall through to subsequent return.
	if ! [[ "${BASH_SOURCE[0]}" != "${0}" ]] || ! [[ "$1" != "--bypass" ]]
	then
		exit "$ubrgbin_exitStatus"
	fi
fi
