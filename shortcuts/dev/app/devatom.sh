_test_devatom() {
	_getDep atom
	
	#local atomDetectedVersion=$(atom --version | head -n 1 | cut -f 2- -d \: | cut -f 2- -d \  | cut -f 2 -d \. )
	#! [[ "$atomDetectedVersion" -ge "27" ]] && echo atom too old && _stop 1
}

_set_atomFakeHomeSource() {
	if [[ ! -e "$scriptLib"/app/atom/home ]]
	then
		_messageError 'missing: '"$scriptLib"'/app/atom/home'
		_messageFAIL
		_stop 1
	fi
	
	export atomFakeHomeSource="$scriptLib"/app/atom/home
	if ! [[ -e "$atomFakeHomeSource" ]]
	then
		export atomFakeHomeSource="$scriptLib"/ubiquitous_bash/_lib/app/atom/home
	fi
}

_prepare_atomDev_fakeHome() {
	_set_atomFakeHomeSource
	
	cp -a "$atomFakeHomeSource"/. "$HOME"
}

_atomDev_sequence() {
	_prepare_atomDev_fakeHome
	
	#echo -n "$@" >> "$HOME"/.atom
	
	atom "$@"
	wait "$!"
}

_atomDev() {
	_selfFakeHome _atomDev_sequence "$@"
}

_atom() {
	_atomDev "$@" &
}

_atomDev_edit_sequence() {
	_set_atomFakeHomeSource
	export appGlobalFakeHome="$atomFakeHomeSource"
	
	_editFakeHome atom "$@"
}

_atomDev_edit() {
	"$scriptAbsoluteLocation" _atomDev_edit_sequence "$@"
}

_atom_edit() {
	_atomDev_edit "$@" &
}
