#NO PRODUCTION USE
#These functions were developed before it was determined fstab would automatically handle the relevant use cases appropriately.

_testSMBmount() {
	_getDep smbclient
	_getDep nmap
}

_checkSMB_qemu_app() {
	true
}

_checkSMB_vbox_app() {
	true
}

_checkSMB_vbox_root() {
	true
}

_checkSMB() {
	#! nmap -Pn -p 139,445 "$1" | grep open > /dev/null 2>&1 && return 1
	! echo | smbclient -L "$1" | grep "$2" > /dev/null 2>&1 && return 1
	
	return 0
}

#"$1" == hostname/ip
#"$2" == sharename
#"$3" == mountpoint
_checkAndMountSMB() {
	_checkSMB || return 1
	
	mkdir -p "$mountpoint" > /dev/null 2>&1
	
	! [[ -d "$mountpoint" ]] && return 1
	
	#Assumes fstab entry has been created.
	#//10.0.2.4/qemu		/home/user/project	cifs	guest,noauto,_netdev,uid=user,user	0 0
	mount "$3"
}


