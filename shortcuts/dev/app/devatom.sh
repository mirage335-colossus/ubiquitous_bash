_test_devatom() {
	_getDep rsync
	
	_getDep atom
	
	#local atomDetectedVersion=$(atom --version | head -n 1 | cut -f 2- -d \: | cut -f 2- -d \  | cut -f 2 -d \. )
	#! [[ "$atomDetectedVersion" -ge "27" ]] && echo atom too old && _stop 1
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

_prepare_atomDev_fakeHome() {
	_set_atomFakeHomeSource
	
	cp -a "$atomFakeHomeSource"/. "$HOME"
}

_atomDev_sequence() {
	_prepare_atomDev_fakeHome
	
	export keepFakeHome="false"
	
	atom --foreground true "$@"
}

_atomDev() {
	_selfFakeHome _atomDev_sequence "$@"
}

_atom_user() {
	_atomDev "$@"  > /dev/null 2>&1 &
}

_atomDev_edit_sequence() {
	_set_atomFakeHomeSource
	export appGlobalFakeHome="$atomFakeHomeSource"
	
	export keepFakeHome="false"
	
	_editFakeHome atom --foreground true "$@"
}

_atomDev_edit() {
	"$scriptAbsoluteLocation" _atomDev_edit_sequence "$@"
}

_atom_edit() {
	_atomDev_edit "$@"  > /dev/null 2>&1 &
}

_atom_config() {
	_set_atomFakeHomeSource
	
	export ATOM_HOME="$atomFakeHomeSource"/.atom
	atom "$@"
}

_atom_tmp_sequence() {
	_start
	_set_atomFakeHomeSource
	
	mkdir -p "$safeTmp"/appcfg
	
	rsync -q -ax --exclude "/.cache" "$atomFakeHomeSource"/.atom/ "$safeTmp"/appcfg/
	
	export ATOM_HOME="$safeTmp"/appcfg
	atom --foreground true "$@"
	
	_stop
}

_atom_tmp() {
	_atom_tmp_sequence "$@"
}

_atom() {
	_atom_tmp "$@"
}

_ubide() {
	_atom . ./ubiquitous_bash.sh "$@"
}
