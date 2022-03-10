_testVBox() {
	if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	then
		if ! dpkg -l | grep linux-headers-$(uname -r) > /dev/null 2>&1
		then
			sudo -n apt-get install -y linux-headers-$(uname -r)
		fi
	fi
	
	_getDep VirtualBox
	_getDep VBoxSDL
	_getDep VBoxManage
	_getDep VBoxHeadless
	
	#sudo -n checkDep dkms
	
	! _noFireJail virtualbox && _stop 1
	
	return 0
}
