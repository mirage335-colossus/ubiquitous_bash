#phpvirtualbox_self

# WARNING: End-user ONLY. NOT intended to provide VirtualMachines for embedded (eg. '3D printer') or application specific (ie. running a program in a VM with file parameter translation) use cases! Intended SOLELY for use cases where a VM 'in the cloud' would be perfectly usable if not for cost or bandwidth constraints.

# https://www.howtoforge.com/managing-a-headless-virtualbox-installation-with-phpvirtualbox-opensuse-12.2
# https://wiki.archlinux.org/index.php/PhpVirtualBox
# https://www.techrepublic.com/article/how-to-install-phpvirtualbox-for-cloud-based-virtualbox-management/


# Consider 'phpvirtualbox_self' simply as a means to install 'phpvirtualbox' as the web interface may be usable as-is. API may not be necessary in this case, and may be better dealt with by 'virtualbox_self' .
# https://www.youtube.com/watch?v=aDRWIN86W1s



_phpvirtualbox_self_status() {
	true
	
	# Of course, the 'ipv4' address may be disregarded in favor of '127.0.0.1' .
	#export ub_phpvirtualbox_self_port
	#export ub_phpvirtualbox_self_url_ipv4
	#export ub_phpvirtualbox_self_url_ipv6
}


_test_phpvirtualbox_self() {
	true
	
	# WARNING: This will not be perfect. An installation of 'phpvirtualbox' may be detected through network port (which causes a popup dialog if MSW host), or through a standard location (which may as well be required with MSW).
	
	# WARNING: While 'VirtualBox' may require a 'native' MSW installation, it is likely 'phpvirtualbox' will require Cygwin .
	
	! type _testVBox > /dev/null 2>&1 && _messageFAIL && _stop 1
	_testVBox "$@"
}
