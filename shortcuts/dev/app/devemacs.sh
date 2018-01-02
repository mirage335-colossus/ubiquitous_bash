_test_devemacs() {
	_getDep emacs
	
	local emacsDetectedVersion=$(emacs --version | head -n 1 | cut -f 3 -d\ | cut -d\. -f1)
	! [[ "$emacsDetectedVersion" -ge "24" ]] && echo emacs too old && _stop 1
}

_emacsDev_fakehome() {
	cp -a "$scriptLib"/app/emacs/home/. "$HOME"
	
	echo -n '(bashdb "bashdb \"' >> "$HOME"/.emacs
	
	echo -n "$@" >> "$HOME"/.emacs
	
	echo -n '\"")' >> "$HOME"/.emacs
	
	emacs
}

_emacsDev() {
	"$scriptAbsoluteLocation" _userFakeHome "$scriptAbsoluteLocation" _emacsDev_fakehome "$@"
}

_emacs() {
	_emacsDev "$@"
}
