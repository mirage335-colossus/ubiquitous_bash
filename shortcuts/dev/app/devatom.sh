_test_devatom() {
	_wantGetDep rsync
	
	_wantGetDep atom
	
	#local atomDetectedVersion=$(atom --version | head -n 1 | cut -f 2- -d \: | cut -f 2- -d \  | cut -f 2 -d \. )
	#! [[ "$atomDetectedVersion" -ge "27" ]] && echo atom too old && return 1
	
	return 0
}

_install_fakeHome_atom() {	
	_link_fakeHome "$atomFakeHomeSource"/.atom .atom
	
	_link_fakeHome "$atomFakeHomeSource"/.config/Atom .config/Atom
}

_set_atomFakeHomeSource() {
	export atomFakeHomeSource="$scriptLib"/app/atom/home
	
	if ! [[ -e "$atomFakeHomeSource" ]]
	then
		true
		#export atomFakeHomeSource="$scriptLib"/ubiquitous_bash/_lib/app/atom/home
	fi
	
	if [[ ! -e "$scriptLib"/app/atom/home ]]
	then
		_messageError 'missing: atomFakeHomeSource= '"$atomFakeHomeSource" > /dev/tty
		_messageFAIL
		_stop 1
	fi
}

_atom_user_procedure() {
	_set_atomFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="true"
	
	_install_fakeHome_atom
	
	_fakeHome atom --foreground "$@"
}

_atom_user_sequence() {
	_start
	
	"$scriptAbsoluteLocation" _atom_user_procedure "$@"
	
	_stop $?
}

_atom_user() {
	_atom_user_sequence "$@"  > /dev/null 2>&1 &
}

_atom_edit_procedure() {
	_set_atomFakeHomeSource
	
	export actualFakeHome="$instancedFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="true"
	
	_install_fakeHome_atom
	
	_fakeHome atom --foreground "$@"
}

_atom_edit_sequence() {
	_start
	
	_atom_edit_procedure "$@"
	
	_stop $?
}

_atom_edit() {
	"$scriptAbsoluteLocation" _atom_edit_sequence "$@"  > /dev/null 2>&1 &
}

_atom_config() {
	_set_atomFakeHomeSource
	
	export ATOM_HOME="$atomFakeHomeSource"/.atom
	atom "$@"
}

_atom_tmp_procedure() {
	_set_atomFakeHomeSource
	
	mkdir -p "$safeTmp"/atom
	
	rsync -q -ax --exclude "/.cache" "$atomFakeHomeSource"/.atom/ "$safeTmp"/atom/
	
	export ATOM_HOME="$safeTmp"/atom
	atom --foreground "$@"
	unset ATOM_HOME
}

_atom_tmp_sequence() {
	_start
	
	_atom_tmp_procedure "$@"
	
	_stop $?
}

_atom_tmp() {
	"$scriptAbsoluteLocation" _atom_tmp_sequence "$@"  > /dev/null 2>&1 &
	wait
}

_atom() {
	_atom_tmp "$@"
}

_ubide() {
	_atom . ./ubiquitous_bash.sh "$@"
}
