#vagrant_build

# WARNING: DANGER: Always use '_custom' from '_lib/kit/raspi' in addition to any 'cloud' built data (or otherwise dependent on cloud to built data) to ensure adequate completeness.






_test_vagrant_build() {
	#sudo -n usermod --append --groups libvirt $USER
	
	_wantGetDep systemd/system/libvirtd.service
	
	#libvirt-daemon
	_wantGetDep libvirt/libvirt-guests.sh
	_wantGetDep libvirt/connection-driver/libvirt_driver_qemu.so
	
	#libvirt-clients
	_wantGetDep virsh
	
	! _typeShare 'vagrant-plugins/plugins.d/vagrant-libvirt.json' && _wantGetDep 'vagrant-plugins/plugins.d/vagrant-libvirt.json'
	_wantGetDep vagrant
}
