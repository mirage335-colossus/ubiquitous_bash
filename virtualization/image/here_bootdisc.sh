_here_bootdisc_shellbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
CALL Y:\loader.bat
CALL Y:\application.bat
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderZbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use z: \\VBOXSVR\root

:checkMount
ping -n 2 127.0.0.1 > nul
IF NOT EXIST "Z:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderXbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use x: \\VBOXSVR\appFolder

:checkMount
ping -n 2 127.0.0.1 > nul
IF NOT EXIST "X:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}
