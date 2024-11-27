_test_devemacs() {
	_wantGetDep emacs

	#_if_cygwin && return 0
	
	if type -p emacs > /dev/null 2>&1
	then
		echo 'warn: missing: emacs'
		return 0
	else
		local emacsDetectedVersion=$(emacs --version | head -n 1 | cut -f 3 -d\ | cut -d\. -f1)
		! [[ "$emacsDetectedVersion" -ge "24" ]] && echo 'warn: obsolete: emacs' && return 1
	fi
	
	return 0
}

_set_emacsFakeHomeSource() {
	#if [[ ! -e "$scriptLib"/app/emacs/home ]]
	#then
		#_messageError 'missing: '"$scriptLib"'/app/emacs/home'
		#_messageFAIL
		#_stop 1
	#fi
	
	if [[ ! -e "$scriptBundle"/app/emacs/home ]]
	then
		_messageError 'missing: '"$scriptBundle"'/app/emacs/home'
		_messageFAIL
		_stop 1
	fi
	
	#export emacsFakeHomeSource="$scriptLib"/app/emacs/home
	export emacsFakeHomeSource="$scriptBundle"/app/emacs/home
	if ! [[ -e "$emacsFakeHomeSource" ]]
	then
		#export emacsFakeHomeSource="$scriptLib"/ubiquitous_bash/_lib/app/emacs/home
		export emacsFakeHomeSource="$scriptLib"/ubiquitous_bash/_bundle/app/emacs/home
	fi
}

_install_fakeHome_emacs() {
	_link_fakeHome "$emacsFakeHomeSource"/.emacs .emacs
	_link_fakeHome "$emacsFakeHomeSource"/.emacs.d .emacs.d
}

_emacs_edit_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	_fakeHome emacs "$@"
}

_emacs_edit_sequence() {
	_start
	
	_emacs_edit_procedure "$@"
	
	_stop $?
}

_emacs_edit() {
	"$scriptAbsoluteLocation" _emacs_edit_sequence "$@"
}

_emacs_user_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	_fakeHome emacs "$@"
}

_emacs_user_sequence() {
	_start
	
	_emacs_user_procedure "$@"
	
	_stop $?
}

_emacs_user() {
	"$scriptAbsoluteLocation" _emacs_user_sequence "$@"
}

_emacs() {
	_emacs_user "$@"
}

_bashdb_procedure() {
	_set_emacsFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="false"
	
	_install_fakeHome_emacs
	
	#echo -n '(bashdb "bash --debugger' >> "$actualFakeHome"/.emacs
	echo -n '(bashdb-large "bash --debugger' >> "$actualFakeHome"/.emacs
	
	local currentArg
	
	for currentArg in "$@"
	do
		echo -n ' ' >> "$actualFakeHome"/.emacs
		echo -n '\"' >> "$actualFakeHome"/.emacs
		echo -n "$currentArg" >> "$actualFakeHome"/.emacs
		echo -n '\"' >> "$actualFakeHome"/.emacs
	done
	
	echo '")' >> "$actualFakeHome"/.emacs
	
	_fakeHome emacs
}

_bashdb_sequence() {
	_start
	
	_bashdb_procedure "$@"
	
	_stop $?
}

_bashdb() {
	"$scriptAbsoluteLocation" _bashdb_sequence "$@"
}

_ubdb() {
	_bashdb "$scriptAbsoluteLocation" "$@"
}
