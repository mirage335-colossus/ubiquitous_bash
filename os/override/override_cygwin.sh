#Override, cygwin.

# ATTENTION: User must launch "tmux" (no parameters) in a graphical Cygwin terminal.
# Launches graphical application through "tmux new-window" if available.
# https://superuser.com/questions/531787/starting-windows-gui-program-in-windows-through-cygwin-sshd-from-ssh-client
_workaround_cygwin_tmux() {
	if pgrep -u "$USER" ^tmux$ > /dev/null 2>&1
	then
		tmux new-window "$@"
		return "$?"
	fi
	
	"$@"
	return "$?"
}

if ! type nmap > /dev/null 2>&1 && type '/cygdrive/c/Program Files/Nmap/nmap.exe' > /dev/null 2>&1
then
	nmap() {
		'/cygdrive/c/Program Files/Nmap/nmap.exe' "$@"
	}
fi

if ! type nmap > /dev/null 2>&1 && type '/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' > /dev/null 2>&1
then
	nmap() {
		'/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' "$@"
	}
fi

# DANGER: Severely differing functionality. Intended only to stand in for "ip addr show" and similar.
if ! type ip > /dev/null 2>&1 && type 'ipconfig' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	ip() {
		if [[ "$1" == "addr" ]] && [[ "$2" == "show" ]]
		then
			ipconfig
			return $?
		fi
		
		return 1
	}
fi



# WARNING: Native 'vncviewer.exe' is a GUI app, and cannot be launched directly from Cygwin SSH server.

#if ! type vncviewer > /dev/null 2>&1 && type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1

if type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		_workaround_cygwin_tmux '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' "$@"
	}
fi

if type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		_workaround_cygwin_tmux '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' "$@"
	}
fi

