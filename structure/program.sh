#####Program

_build() {
	_start
	
	echo -e -n '\E[1;32;46m Binary compiling...	\E[0m'
	
	_tryExec _buildIdle
	_tryExec _buildChRoot
	_tryExec _buildQEMU
	
	_tryExec _buildExtra
	
	echo "PASS"
	
	_stop
}

#Typically launches an application - ie. through virtualized container.
_launch() {
	false
}

#Typically gathers command/variable scripts from other (ie. yaml) file types (ie. AppImage recipes).
_collect() {
	false
}

#Typical program entry point, absent any instancing support.
_enter() {
	_launch
}

#Typical program entry point.
_main() {
	_start
	
	_collect
	
	_enter
	
	_stop
}
