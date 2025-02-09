
_get_veracrypt() {
	_messagePlain_nominal 'init: _get_veracrypt'
	if type veracrypt > /dev/null 2>&1
	then
		_messagePlain_good 'good: found: veracrypt'
	fi
	
	if _if_cygwin && type "choco"
	then
		choco install veracrypt -y
		return
	fi
	
	
	_start
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	cd "$safeTmp"
	
	
	_getDep lbzip2

	_getDep libfuse.so.2
	
	
	
	# https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-setup.tar.bz2
	export currentVeracryptURL=$(wget -q -O - 'https://www.veracrypt.fr/en/Downloads.html' | grep https | grep 'tar\.bz2' | head -n1 | sed 's/^.*https/https/' | sed 's/.tar.bz2.*$/\.tar\.bz2/' | sed 's/&#43;/+/g' | tr -dc 'a-zA-Z0-9.:\=\_\-/%+')
	export currentVeracryptName=$(_safeEcho_newline "$currentVeracryptURL" | sed 's/^.*\///' | sed 's/\.tar\.bz2$//')
	
	wget "$currentVeracryptURL"
	
	tar xf "$currentVeracryptName".tar.bz2
	
	
	#./veracrypt-1.25.9-setup-gui-x64 --nox11 --quiet
	
	
	_getDep expect
	
	
	
	# https://stackoverflow.com/questions/58239247/veracript-install-script-fails-if-run-from-script
	# -console-x64
	# -gui-x64
	echo '#!/usr/bin/expect -f

set timeout -1
spawn '"$safeTmp"/"$currentVeracryptName"-console-x64'
expect "To select, enter 1 or 2:"
send -- "1\r"
expect "Press Enter to display the license terms..."
send -- "\r"
expect ":"
send -- "q\r"
expect "Do you accept and agree to be bound by the license terms?"
send -- "yes\r"
expect "Press Enter to continue..."
send -- "\r"
expect "Press Enter to exit..."
send -- "\r"
send -- "\r"
send -- "\r"
expect eof' > "$safeTmp"/veracrypt.exp
	
	expect -f "$safeTmp"/veracrypt.exp
	
	cd "$functionEntryPWD"
	
	
	if ! type veracrypt > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: missing: veracrypt'
		_messageFAIL
	fi
	_stop
}




