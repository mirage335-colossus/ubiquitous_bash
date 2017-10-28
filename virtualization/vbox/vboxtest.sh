_testVBox() {
	_checkDep VirtualBox
	_checkDep VBoxSDL
	_checkDep VBoxManage
	_checkDep VBoxHeadless
	
	#sudo -n checkDep dkms
}
