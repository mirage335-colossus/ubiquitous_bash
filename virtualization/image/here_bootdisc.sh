_here_bootdisc_statup_xdg() {
cat << 'CZXWXcRMTo8EmM8i4d'
[Desktop Entry]
Comment=
Exec=sudo -n mount -t iso9660 -o ro,nofail LABEL=uk4uPhB663kVcygT0q /media/bootdisc ; sudo -n /media/bootdisc/rootnix.sh ; /media/bootdisc/cmd.sh
GenericName=
Icon=exec
MimeType=
Name=
Path=
StartupNotify=false
Terminal=false
TerminalOptions=
Type=Application
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_rootnix() {
cat << 'CZXWXcRMTo8EmM8i4d'
#!/usr/bin/env bash

if [[ "$0" != "/media/bootdisc/rootnix.sh" ]] && [[ -e "/media/bootdisc" ]]
then
	for iteration in `seq 1 25`;
	do
		! /bin/mountpoint /media/bootdisc > /dev/null 2>&1 && ! [[ -e "/media/bootdisc/rootnix.sh" ]] && sleep 6
	done
	sleep 0.1
	/media/bootdisc/rootnix.sh "$@"
	exit
fi

#Equivalent "fstab" entries for reference. Not used due to conflict for mountpoint, as well as lack of standard mounting options in vboxsf driver.
#//10.0.2.4/qemu	/home/user/.pqm cifs	guest,_netdev,uid=user,user,nofail,exec		0 0
#appFolder		/home/user/.pvb	vboxsf	uid=user,_netdev				0 0

_mountGuestShareNIX() {
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && /bin/mount -t vboxsf -o uid=user,_netdev appFolder /home/user/project 2>&1
	! /bin/mountpoint /home/user/Downloads > /dev/null 2>&1 && /bin/mount -t vboxsf -o uid=user,_netdev Downloads /home/user/Downloads 2>&1
	
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && /bin/mount -t cifs -o guest,_netdev,uid=user,user,nofail,exec '//10.0.2.4/qemu' /home/user/project > /dev/null 2>&1
	
}

#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) }

_uid() {
	local uidLength
	[[ -z "$1" ]] && uidLength=18 || uidLength="$1"
	
	cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c "$uidLength"
}

export sessionid=$(_uid)
[[ -d /tmp ]] && export bootTmp=/tmp		#Typical BSD
[[ -d /dev/shm ]] && export bootTmp=/dev/shm	#Typical Linux

echo "rootnix" > "$bootTmp"/"$sessionid".rnx

#/bin/mkdir -p /home/user/.pqm
#/bin/mkdir -p /home/user/.pvb

/bin/mkdir -p /home/user/Downloads
! /bin/mountpoint /home/user/Downloads && /bin/chown user:user /home/user/Downloads

/bin/mkdir -p /home/user/project
! /bin/mountpoint /home/user/project && /bin/chown user:user /home/user/project

! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.1 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 0.3 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 1 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 3 && _mountGuestShareNIX

for iteration in `seq 1 15`;
do
	! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 6 && _mountGuestShareNIX
done

! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 9 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 18 && _mountGuestShareNIX
! /bin/mountpoint /home/user/project > /dev/null 2>&1 && sleep 27 && _mountGuestShareNIX

CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_startupbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
REM CALL A:\uk4uPhB6.bat
REM CALL B:\uk4uPhB6.bat
CALL D:\uk4uPhB6.bat
CALL E:\uk4uPhB6.bat
CALL F:\uk4uPhB6.bat
CALL G:\uk4uPhB6.bat
CALL H:\uk4uPhB6.bat
CALL Y:\shell.bat
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_shellbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
CALL Y:\loader.bat
CALL Y:\application.bat
CZXWXcRMTo8EmM8i4d
}

#No production use.
_here_bootdisc_loaderZbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use z: /delete

:checkMount

net use /USER:guest z: \\VBOXSVR\root ""

ping -n 2 127.0.0.1 > nul
IF NOT EXIST "Z:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}

_here_bootdisc_loaderXbat() {
cat << 'CZXWXcRMTo8EmM8i4d'
net use x: /delete

:checkMount

net use /USER:guest x: \\VBOXSVR\appFolder ""
net use /USER:guest x: \\10.0.2.4\qemu ""

ping -n 2 127.0.0.1 > nul
IF NOT EXIST "X:\" GOTO checkMount
CZXWXcRMTo8EmM8i4d
}
