
_setupUbiquitous_accessories-plasma() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-plasma'
	
	mkdir -p "$HOME"/.config/plasma-workspace/env

	_setupUbiquitous_accessories_here-plasma_hook > "$HOME"/.config/plasma-workspace/env/profile.sh
	chmod u+x "$HOME"/.config/plasma-workspace/env/profile.sh
	
	
	return 0
}

_setupUbiquitous_accessories-gnuoctave() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-gnuoctave'
	
	mkdir -p "$ubcoreDir_accessories"/gnuoctave
	
	export ubcore_accessoriesFile_gnuoctave="$ubcoreDir_accessories"/gnuoctave/ubcorerc.m
	export ubcore_accessoriesFile_gnuoctave_ubhome="$ubHome"/.ubcorerc-gnuoctave.m
	
	rm -f "$ubcore_accessoriesFile_gnuoctave"
	rm -f "$ubcore_accessoriesFile_gnuoctave_ubhome"
	ln -s "$ubcore_accessoriesFile_gnuoctave_ubhome" "$ubcore_accessoriesFile_gnuoctave"
	
	_setupUbiquitous_accessories_here-gnuoctave > "$ubcore_accessoriesFile_gnuoctave_ubhome"
	
	
	if ! grep ubcore "$ubHome"/.octaverc > /dev/null 2>&1 && _messagePlain_probe 'octaverc'
	then
		# https://www.mathworks.com/matlabcentral/answers/194868-what-about-the-character
		#echo '%# ubcore' >> "$ubHome"/.octaverc
		#_safeEcho_newline run'("'"$ubcore_accessoriesFile_gnuoctave_ubhome"'")' >> "$ubHome"/.octaverc
		_setupUbiquitous_accessories_here-gnuoctave_hook >> "$ubHome"/.octaverc
	fi
	
	return 0
}


_setupUbiquitous_accessories_bashrc-cloud_bin() {
	
	_setupUbiquitous_accessories_here-cloud_bin
	
	echo 'true'
	
	return 0
}



_setupUbiquitous_accessories-python() {
	_messagePlain_nominal 'init: _setupUbiquitous_accessories-python'
	
	mkdir -p "$ubcoreDir_accessories"/python
	
	export ubcore_accessoriesFile_python="$ubcoreDir_accessories"/python/ubcorerc_pythonrc.py
	export ubcore_accessoriesFile_python_ubhome="$ubHome"/.ubcorerc_pythonrc.py
	
	rm -f "$ubcore_accessoriesFile_python"
	rm -f "$ubcore_accessoriesFile_python_ubhome"
	ln -s "$ubcore_accessoriesFile_python_ubhome" "$ubcore_accessoriesFile_python"
	
	_setupUbiquitous_accessories_here-python > "$ubcore_accessoriesFile_python_ubhome"
	
	export ubcore_ubcorerc_pythonrc="ubcorerc_pythonrc"
	
	if ! grep ubcore "$ubHome"/.pythonrc > /dev/null 2>&1 && _messagePlain_probe 'pythonrc'
	then
		# https://www.mathworks.com/matlabcentral/answers/194868-what-about-the-character
		#echo '%# ubcore' >> "$ubHome"/.pythonrc
		#_safeEcho_newline run'("'"$ubcore_accessoriesFile_python_ubhome"'")' >> "$ubHome"/.pythonrc
		_setupUbiquitous_accessories_here-python_hook >> "$ubHome"/.pythonrc
	fi
	
	return 0
}



_setupUbiquitous_accessories-git() {
	git config --global checkout.workers -1
	
	git config --global pull.rebase false

	git config --global core.autocrlf input
	git config --global core.eol lf

	git config --global init.defaultBranch main
}




_setupUbiquitous_accessories() {

	_setupUbiquitous_accessories-plasma "$@"

	
	_setupUbiquitous_accessories-gnuoctave "$@"
	
	_setupUbiquitous_accessories-python "$@"

	_setupUbiquitous_accessories-git "$@"
	
	return 0
}

_setupUbiquitous_accessories_bashrc() {
	#_messagePlain_nominal 'init: _setupUbiquitous_accessories_bashrc'
	
	_setupUbiquitous_accessories_bashrc-cloud_bin "$@"
	
	_setupUbiquitous_accessories_here-nixenv-bashrc "$@"
	
	#echo true
	
	
	_setupUbiquitous_accessories_here-coreoracle_bashrc "$@"
	
	
	# WARNING: Python must remain last. Failure to hook python is a failure that must show as an error exit status from the users profile (a red "1" on the first line of first visual prompt command prompt).
	_setupUbiquitous_accessories_here-python_bashrc "$@"
	
	
	_setupUbiquitous_accessories_here-user_bashrc "$@"
	
	#echo true
}


_setupUbiquitous_accessories_requests() {
	
	# EXAMPLE .
	#_messagePlain_request 'request: request'
	
	return 0
}



