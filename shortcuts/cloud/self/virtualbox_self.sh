#virtualbox_self

# WARNING: End-user ONLY. NOT intended to provide VirtualMachines for embedded (eg. '3D printer') or application specific (ie. running a program in a VM with file parameter translation) use cases! Intended SOLELY for use cases where a VM 'in the cloud' would be perfectly usable if not for cost or bandwidth constraints.

# https://www.howtoforge.com/managing-a-headless-virtualbox-installation-with-phpvirtualbox-opensuse-12.2
# https://wiki.archlinux.org/index.php/PhpVirtualBox
# https://www.techrepublic.com/article/how-to-install-phpvirtualbox-for-cloud-based-virtualbox-management/


# Consider 'rdp' , apparently usable within web browser and used by 'phpVirtualBox' .
# https://github.com/phpvirtualbox/phpvirtualbox/wiki#virtualbox--40---remote-console-access-note
# https://github.com/phpvirtualbox/phpvirtualbox/issues/140
# https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-web-client-admin




# ATTENTION: CAUTION: Whether 'VBoxLab' or 'global' VirtualBox configuration is used must be configurable with 'ops.sh' or similar!



_virtualbox_self_server_create() {
	true
	
	
	_virtualbox_self_server_status
}


_virtualbox_self_server_list() {
	true
}


_virtualbox_self_server_status() {
	true
	
	# Of course, the 'ipv4' address may be disregarded in favor of '127.0.0.1' .
	# https://www.virtualbox.org/manual/ch07.html
	#export ub_virtualbox_self_server_vrde_port
	#export ub_virtualbox_self_server_vrde_addr_ipv4
	#export ub_virtualbox_self_server_vrde_addr_ipv6
	
	
	
	#export ub_virtualbox_server_addr_ipv4
	#export ub_virtualbox_server_addr_ipv6
	
	#export ub_virtualbox_server_ssh_cred
	#export ub_virtualbox_server_ssh_port
	
	#export ub_virtualbox_server_vnc_cred
	#export ub_virtualbox_server_vnc_port
	
	#export ub_virtualbox_server_serial
	
	#export ub_virtualbox_server_novnc_cred
	#export_ub_virtualbox_server_novnc_port
	#export ub_virtualbox_server_novnc_url_ipv4
	#export ub_virtualbox_server_novnc_url_ipv6
	
	#export ub_virtualbox_server_shellinabox_port
	#export ub_virtualbox_server_shellinabox_url_ipv4
	#export ub_virtualbox_server_shellinabox_url_ipv6
	
	#export ub_virtualbox_server_remotedesktopwebclient_port
	#export ub_virtualbox_server_remotedesktopwebclient_url_ipv4
	#export ub_virtualbox_server_remotedesktopwebclient_url_ipv6
}



_test_virtualbox_self() {
	# ATTENTION: TODO: A custom 'GUI' frontend and backend may be required to integrate with VR.
	
	
	
	
	# ATTENTION: WARNING: TODO: TEMPORARY.
	if _if_cygwin
	then
		if ! type _testVBox > /dev/null 2>&1 || ! "$scriptAbsoluteLocation" _testVBox
		then
			echo 'warn: accepted: cygwin: missing: vbox'
			return 0
		fi
	fi
	
	! type _testVBox > /dev/null 2>&1 && _messageFAIL && _stop 1
	_testVBox "$@"
	
	return 0
}
