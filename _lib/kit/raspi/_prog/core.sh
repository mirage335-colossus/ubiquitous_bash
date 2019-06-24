##### Core

_mountChRoot_image_raspbian_prog() {
	mkdir -p "$globalVirtFS"/../boot
	
	sudo -n mount "$1"p1 "$globalVirtFS"/../boot
	
	return 0
}

# Technically superflous, as this functionality is already safeguarded within "_umountChRoot_image" .
_umountChRoot_image_prog() {
	sudo -n umount "$globalVirtFS"/../boot
	
	return 0
}

_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_custom
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openChRoot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_chroot
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_userChRoot
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_openLoop
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_closeLoop
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_gparted
}



_custom_rsync() {
	! _safePath "$1" && return 1
	
	! [[ -d "$1" ]] && return 1
	
	sudo -n mkdir -p "$2"
	sudo -n rsync -avx --delete "$1" "$2"
	sudo -n chown -R 1000:1000 "$1"
	
}



# ATTENTION: Configure.
# DANGER! Includes "rsync --delete", equivalent to "rm -r"!
_custom() {
	export safeToDeleteGit="true"
	
	# ATTENTION: Configure 'directory' .
	! _safePath "$globalVirtFS"/home/pi/core/'directory' && return 1
	! _safePath "$globalVirtFS" && return 1
	
	_openChRoot || return 1
	
	# ATTENTION: Configure 'directory' .
	_custom_rsync "$scriptLib"/'directory'/ "$globalVirtFS"/home/pi/core/'directory'/
	
	# ATTENTION: Configure 'cautossh' .
	_custom_rsync "$scriptLib"/'cautossh'/ "$globalVirtFS"/home/pi/core/'cautossh'/
	
	
	# ATTENTION: Configure .
	sudo -n mkdir -p "$globalVirtFS"/home/pi/.ssh
	sudo -n chmod 700 "$globalVirtFS"/home/pi/.ssh
	
	sudo -n rm -f "$globalVirtFS"/home/pi/.ssh/authorized_keys > /dev/null 2>&1
	cat "$scriptLib"/'cautossh'/_local/ssh/id_rsa.pub | sudo -n tee -a "$globalVirtFS"/home/pi/.ssh/authorized_keys > /dev/null
	cat "$scriptLib"/'cautossh'/_local/ssh/entity/id_rsa.pub | sudo -n tee -a "$globalVirtFS"/home/pi/.ssh/authorized_keys > /dev/null
	
	sudo -n chown -R 1000:1000 "$globalVirtFS"/home/pi/.ssh
	
	
	# ATTENTION: Configure .
	echo '@reboot /home/pi/core/cautossh/cautossh _ssh_autoreverse' | _chroot crontab -u pi -
	
	
	# ATTENTION: Configure.
	# DANGER: Chose network safe password. Minimum 8 char, random, alpha numeric, capitals.
	echo 'root:password' | _chroot chpasswd
	echo 'pi:password' | _chroot chpasswd
	
	_chroot apt-get update
	_chroot apt-get install -y bc nmap autossh socat sshfs tor bup
	
	# ATTENTION: Configure
	# Unable to pass tests for installation within QEMU ChRoot environment.
	#_chroot su pi -c 'cd /home/pi/core/cautossh/ ; ./cautossh _setup'
	_chroot su pi -c 'cd /home/pi/core/cautossh/ ; ./cautossh _setup_ssh'
	_chroot su pi -c 'cd /home/pi/core/cautossh/ ; ./cautossh _setupCommands'
	
	
	# ATTENTION: Configure, set hostname here.
	echo 'hostname' | sudo -n tee "$globalVirtFS"/etc/hostname > /dev/null 2>&1
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/etc/hosts > /dev/null 2>&1
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1	hostname

CZXWXcRMTo8EmM8i4d



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


	
	
	# ATTENTION: Configure .
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/../boot/custom-config-file.txt > /dev/null 2>&1
	EXAMPLE ONLY
CZXWXcRMTo8EmM8i4d

}


