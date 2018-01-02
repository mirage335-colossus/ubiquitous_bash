_test_devemacs() {
	_getDep emacs
	
	local emacsDetectedVersion=$(emacs --version | head -n 1 | cut -f 3 -d\ | cut -d\. -f1)
	! [[ "$emacsDetectedVersion" -ge "24" ]] && echo emacs too old && _stop 1
}

_emacsDev_fakehome() {
	cp -a "$scriptLib"/app/emacs/home/. "$HOME"
}

_emacsDev_sequence() {
	_emacsDev_fakehome
	
	#echo -n "$@" >> "$HOME"/.emacs
	
	emacs "$@"
}

_emacsDev() {
	_selfFakeHome _emacsDev_sequence "$@"
}

_emacs() {
	_emacsDev "$@"
}

_bashdb_sequence() {
	_emacsDev_fakehome
	
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

_uddb() {
	_bashdb "$scriptAbsoluteLocation" "$@"
}
