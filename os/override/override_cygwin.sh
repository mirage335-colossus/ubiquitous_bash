#Override, cygwin.

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


# WARNING: Native 'vncviewer.exe' has not been successfully tested and cannot be launched from Cygwin SSH server.

#if ! type vncviewer > /dev/null 2>&1 && type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1

if type '/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		'/cygdrive/c/Program Files/TigerVNC/vncviewer.exe' "$@"
	}
fi

if type '/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	export override_cygwin_vncviewer='true'
	vncviewer() {
		'/cygdrive/c/Program Files (x86)/TigerVNC/vncviewer.exe' "$@"
	}
fi

