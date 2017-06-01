#!/bin/bash
#Script by mirage335.
#Purpose:
# Provides low level functions useful in many bash scripts.
#Usage:
# . ubiquitous_bash.sh
#Version:
# 1.5

# Copyright (c) 2012,2017 mirage335

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Retrieves absolute path of current script, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#However, will dereference symlinks IF the script location itself is a symlink. This is to allow symlinking to scripts to function normally.
#Suitable for allowing scripts to find other scripts they depend on. May look like an ugly hack, but it has proven reliable over the years.
getScriptAbsoluteLocation() {
	local absoluteLocation
	if [[ (-e $PWD\/$0) && ($0 != "") ]] && [[ "$1" != "/"* ]]
			then
	absoluteLocation="$PWD"\/"$0"
	absoluteLocation=$(realpath -L -s "$absoluteLocation")
			else
	absoluteLocation=$(realpath -L "$0")
	fi

	if [[ -h "$absoluteLocation" ]]
			then
	absoluteLocation=$(readlink -f "$absoluteLocation")
	absoluteLocation=$(realpath -L "$absoluteLocation")
	fi
	
	echo $absoluteLocation
}
alias _getScriptAbsoluteLocation=getScriptAbsoluteLocation

#Retrieves absolute path of current script, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for allowing scripts to find other scripts they depend on.
getScriptAbsoluteFolder() {
	dirname "$(getScriptAbsoluteLocation)"
}
alias _getScriptAbsoluteFolder=getScriptAbsoluteFolder

#Retrieves absolute path of parameter, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for finding absolute paths, when it is desirable not to interfere with symlink specified folder structure.
getAbsoluteLocation() {
	local absoluteLocation
	if [[ (-e $PWD\/$1) && ($1 != "") ]] && [[ "$1" != "/"* ]]
			then
	absoluteLocation="$PWD"\/"$1"
	absoluteLocation=$(realpath -L -s "$absoluteLocation")
			else
	absoluteLocation=$(realpath -L "$1")
	fi
	echo $absoluteLocation
}
alias _getAbsoluteLocation=getAbsoluteLocation

#Retrieves absolute path of parameter, while maintaining symlinks, even when "./" would translate with "readlink -f" into something disregarding symlinked components in $PWD.
#Suitable for finding absolute paths, when it is desirable not to interfere with symlink specified folder structure.
getAbsoluteFolder() {
	local absoluteLocation=$(_getAbsoluteLocation "$1")
	dirname "$absoluteLocation"
}
alias _getAbsoluteLocation=getAbsoluteLocation

#Returns a UUID in the form of xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
getUUID() {
	cat /proc/sys/kernel/random/uuid
}

#Executes config file specified by second parameter, and outputs the value of the variable specified by the first parameter.
getConfig() {
	(					#start subshell
		. "$2"				#execute config file
		eval echo \$$1		#output value
	)
}

#Sets variable specified by second parameter to value specified in first parameter in config file specified by third parameter.
writeConfig() {
	echo -e "\n$1=$2		#Automatic Entry" >> "$3"
}

#Creates low-enthropy random password, suitable for environments in which mass-guessing is infeasible and user-friendliness is unnecessary. First parameter specifies character count.
lowQualityPassword() {
	cat /dev/urandom | tr -dc A-Za-z0-9 | head -c $1
}

#Retrieves user password, and places result in $userConfirmedPassword
promptPassword() {
	local passwordAttemptOne="a"
	local passwordAttemptTwo="b"
	while [[ $passwordAttemptOne != $passwordAttemptTwo ]]
	do
		read -s -p "Enter or retry password:
" passwordAttemptOne
		read -s -p "Confirm password:
" passwordAttemptTwo
	done
	userConfirmedPassword=$passwordAttemptOne
}

#Determines if user is root. If yes, then continue. If not, exits after printing error message.
mustBeRoot() {
if [[ $(id -u) != 0 ]]; then 
	echo "This must be run as root!"
	exit
fi
}

#Waits for the process PID specified by first parameter to end. Useful in conjunction with $! to provide process control and/or PID files.
waitForProcess() {
	while ps --no-headers -p $1 &> /dev/null
	do
		sleep 0.1
	done
}
