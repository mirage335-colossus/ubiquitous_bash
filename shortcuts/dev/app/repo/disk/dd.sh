
# DANGER: Of course the 'dd' command can cause severe data loss. Be careful. Maybe use 'type -p' to see function code for reference instead of calling directly.


_dd_user() {
	dd "$@" oflag=direct conv=fdatasync status=progress
}
_dd() {
	sudo -n "$scriptAbsoluteLocation" _dd_user "$@"
}

_dropCache() {
	sync ; echo 3 | sudo -n tee /proc/sys/vm/drop_caches
}







