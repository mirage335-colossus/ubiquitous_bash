#Override, cygwin.

if ! type nmap > /dev/null && type '/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' > /dev/null 2>&1
then
	nmap() {
		'/cygdrive/c/Program Files (x86)/Nmap/nmap.exe' "$@"
	}
fi
