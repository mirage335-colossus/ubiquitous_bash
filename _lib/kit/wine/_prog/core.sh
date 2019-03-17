##### Core

_app() {
	_wine "$scriptLocal"/"_wbottle/drive_c/Program Files (x86)/app/app.exe" "$@"
}

_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_app
}
