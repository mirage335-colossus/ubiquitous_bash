#cloud_abstraction


# ATTENTION: In practice, this duplicates the functionality of Cloud service 'control panel' GUI , VirtualBox GUI , VMWare GUI , etc. Intended as an abstraction layer for VM custom image building or VR access through non-web UI.






# ATTENTION: Many providers (eg. Linode ) offer a WebUI , in which case any 'cloud API' may be most useful only for automation or to create VMs more quickly.
# DigitalOcean 'Droplet Console' was less effective. Apparently 'lightdm' is required and mouse input is inaccurate.
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-remote-desktop-with-x2go-on-ubuntu-20-04


# ATTENTION: Override with 'ops.sh' or 'core.sh' or similar.
# ATTENTION: Although primarily intended for 'cloud' this is equally applicable to 'self' networks created by 'copying' the appropriate "ubiquitous_bash.sh" and 'vm.img' files to separate directories and such. The 'CLI' for such a cloud could be using a filesystem location for such 'image' files as the equivalent of 'credentials' to create new VMs.
_cloud_server_create() {
	true
	
	
	_cloud_server_status
}


# List 'cloud' 'servers' .
_cloud_server_list() {
	true
}


# Determine if a 'named' or 'uniqueid' 'cloud' 'server' is working correctly and able to report (presumably by either by serial/IPC or public ipv4/ipv6) own IP addresses and such for access to an 'internal' 'graphical console'. With a valid result, automation or remote control is expected to be available.
_cloud_server_status() {
	true
	
	# ATTENTION: Many providers (eg. Linode ) offer a WebUI , in which case any 'cloud API' may be most useful only to create VMs more quickly.
	
	#export_ub_cloud_server_service_url
	
	#export ub_cloud_server_addr_ipv4
	#export ub_cloud_server_addr_ipv6
	
	#export ub_cloud_server_ssh_cred
	#export ub_cloud_server_ssh_port
	
	#export ub_cloud_server_vnc_cred
	#export ub_cloud_server_vnc_port
	
	#export ub_cloud_server_serial
	
	#export ub_cloud_server_novnc_cred
	#export_ub_cloud_server_novnc_port
	#export ub_cloud_server_novnc_url_ipv4
	#export ub_cloud_server_novnc_url_ipv6
	
	#export ub_cloud_server_shellinabox_port
	#export ub_cloud_server_shellinabox_url_ipv4
	#export ub_cloud_server_shellinabox_url_ipv6
	
	#export ub_cloud_server_remotedesktopwebclient_port
	#export ub_cloud_server_remotedesktopwebclient_url_ipv4
	#export ub_cloud_server_remotedesktopwebclient_url_ipv6
}











