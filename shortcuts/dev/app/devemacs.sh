_test_devemacs() {
	_getDep emacs
	
	local emacsDetectedVersion=$(emacs --version | head -n 1 | cut -f 3 -d\ | cut -d\. -f1)
	! [[ "$emacsDetectedVersion" -ge "24" ]] && echo emacs too old && _stop 1
}

_prepare_emacsDev_fakeHome() {
	cp -a "$scriptLib"/app/emacs/home/. "$HOME"
}

_emacsDev_sequence() {
	_prepare_emacsDev_fakeHome
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	emacs "$@"
}

_emacsDev() {
	_selfFakeHome _emacsDev_sequence "$@"
}

_emacs() {
	_emacsDev "$@"
}

_emacsDev_edit_sequence() {
	export appGlobalFakeHome="$scriptLib"/app/emacs/home
	
	_editFakeHome emacs "$@"
}

_emacsDev_edit() {
	"$scriptAbsoluteLocation" _emacsDev_edit_sequence "$@"
}

_bashdb_sequence() {
	_prepare_emacsDev_fakeHome
	
	echo -n '(bashdb "bash --debugger' >> "$HOME"/.emacs
	
	local currentArg
	
	for currentArg in "$@"
	do
		echo -n ' ' >> "$HOME"/.emacs
		echo -n '\"' >> "$HOME"/.emacs
		echo -n "$currentArg" >> "$HOME"/.emacs
		echo -n '\"' >> "$HOME"/.emacs
	done
	
	echo '")' >> "$HOME"/.emacs
	
	emacs
}

_bashdb() {
	_selfFakeHome _bashdb_sequence "$@"
}

_ubdb() {
	_bashdb "$scriptAbsoluteLocation" "$@"
}
