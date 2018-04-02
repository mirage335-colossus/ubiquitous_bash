#####Program

#Typically launches an application - ie. through virtualized container.
_launch() {
	local scriptLinkCommand
	
	if scriptLinkCommand=$(_getScriptLinkName)
	then
		"$scriptLinkCommand" "$@"
	else
		_gnucash "$@"
		return 0
	fi
}

#Typically gathers command/variable scripts from other (ie. yaml) file types (ie. AppImage recipes).
_collect() {
	false
}

#Typical program entry point, absent any instancing support.
_enter() {
	_launch "$@"
}

#Typical program entry point.
_main() {
	_start
	
	_collect
	
	_enter "$@"
	
	_stop
}
