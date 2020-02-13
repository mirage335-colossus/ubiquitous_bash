# ATTENTION: Override (rarely, if necessary) .
_custom_write_hostname() {
	echo "$custom_hostname" | sudo -n tee "$globalVirtFS"/etc/hostname > /dev/null 2>&1
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/etc/hosts > /dev/null 2>&1
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1	$custom_hostname

CZXWXcRMTo8EmM8i4d
}

# ATTENTION: Override (rarely, if necessary) .
_custom_write_sudoers() {
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/etc/sudoers > /dev/null
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL:ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
#%sudo	ALL=(ALL:ALL) ALL
#pi ALL=(ALL:ALL) NOPASSWD: ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d

CZXWXcRMTo8EmM8i4d
}

# ATTENTION: Override .
_custom_write_boot() {
	echo | sudo -n tee "$globalVirtFS"/../boot/ssh
	
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/../boot/wpa_supplicant.conf > /dev/null 2>&1
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
        ssid="ssid"
        psk="psk"
	key_mgmt=WPA-PSK
}

CZXWXcRMTo8EmM8i4d
	
	
	# Write only to new image.
	[[ -e "$globalVirtFS"/../boot/"$ubiquitiousBashIDshort" ]] && return 1
	echo | sudo -n tee "$globalVirtFS"/../boot/"$ubiquitiousBashIDshort"
	
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee -a "$globalVirtFS"/../boot/config.txt > /dev/null 2>&1

dtoverlay=pi3-disable-wifi
dtoverlay=pi3-disable-bt

CZXWXcRMTo8EmM8i4d
}

_custom_write_bfq() {
	_write_bfq "$globalVirtFS"
}

_custom_write_fs() {
	_custom_write_hostname
	_custom_write_sudoers
	_custom_write_boot
}
