
_test_live_debianpackages() {
	! dpkg-query -W grub-pc-bin > /dev/null 2>&1 && echo 'warn: missing: grub-pc-bin'
	! dpkg-query -W grub-efi-amd64-bin > /dev/null 2>&1 && echo 'warn: missing: grub-efi-amd64-bin'
	
	return 0
}

_test_live() {
	_getDep debootstrap
	#_getDep squashfs-tools
	_getDep xorriso
	#_getDep grub-pc-bin
	#_getDep grub-efi-amd64-bin
	_getDep mtools
	
	
	_getDep mksquashfs
	_getDep grub-mkstandalone
	
	_getDep mkfs.vfat
	
	_getDep mkswap
	
	
	_getDep mmd
	_getDep mcopy
	
	
	_getDep grub/i386-pc/cdboot.img
	_getDep grub/i386-pc/boot_hybrid.img
	
	
	[[ -e '/sbin/fdisk' ]] && _getDep fdisk
	[[ -e '/sbin/sfdisk' ]] && _getDep sfdisk
	
	
	# Currently only Debian is supported as a build host.
	_test_live_debianpackages
	
	
	#_getDep VBoxManage
	_getDep qemu-img
	
	return 0
}




_live_fdisk() {
	if [[ -e '/sbin/fdisk' ]]
	then
		sudo -n /sbin/fdisk "$@"
		return
	fi
	sudo -n fdisk "$@"
	return
}

_live_sfdisk() {
	if [[ -e '/sbin/sfdisk' ]]
	then
		sudo -n /sbin/sfdisk "$@"
		return
	fi
	sudo -n sfdisk "$@"
	return
}









# https://manpages.debian.org/testing/live-boot-doc/persistence.conf.5.en.html
 # WARNING: 'persistence.conf' ... 'root of its file system' ... 'Any such labeled volume must have such a file, or it will be ignored.'
_live_persistent_conf_here() {
	cat <<'CZXWXcRMTo8EmM8i4d'
/ union
#/home union
CZXWXcRMTo8EmM8i4d
}

_live_more_copy() {
	_messagePlain_nominal '_live_more_copy'
	
	rm -f "$scriptLocal"/vm-live-more.iso
	
	cp "$scriptLocal"/vm-live.iso "$scriptLocal"/vm-live-more.iso
}

_live_more_move() {
	_messagePlain_nominal '_live_more_move'
	
	rm -f "$scriptLocal"/vm-live-more.iso
	
	mv "$scriptLocal"/vm-live.iso "$scriptLocal"/vm-live-more.iso
}

_live_more_procedure() {
	_messageNormal 'init: _live_more_procedure'
	
	#_start
	
	
	[[ ! -e "$scriptLocal"/vm-live-more.iso ]] && _messageFAIL && _stop 1
	
	
	
	
	
	
	
	_messagePlain_nominal '_live_more_procedure: append'
	
	# 32 * 1000 MB to GiB == 29.8023224 GiB
	# 29.8 GB to MiB == 28419 MiB
	
	# 1024 MiB to GiB == 1 GiB
	# 1 GiB == 1073.74 MB
	# 1024 MB + 64 MB == 1088 MB
	
	# 1088 * 12 + 32 == 13088 MB
	
	dd if=/dev/zero bs=1M count=13088 >> "$scriptLocal"/vm-live-more.iso
	
	
	
	_messagePlain_nominal '_live_more_procedure: partitions: add'
	
	#sudo -n parted --script "$scriptLocal"/vm-live-more.iso mklabel msdos
	#sudo -n partprobe > /dev/null 2>&1
	#sudo -n parted "$scriptLocal"/vm-live-more.iso --script -- mkpart primary 0% 100%
	#sudo -n partprobe > /dev/null 2>&1
	
	# https://unix.stackexchange.com/questions/200582/scripteable-gpt-partitions-using-parted
	
	#sudo -n parted "$scriptLocal"/vm-live-more.iso --script -a optimal -- mkpart primary -12288MiB -8192MiB
	#sudo -n parted "$scriptLocal"/vm-live-more.iso --script -a optimal -- mkpart primary -8192MiB -4096MiB
	#sudo -n parted "$scriptLocal"/vm-live-more.iso --script -a optimal -- mkpart primary -4096MiB -0MiB
	#sudo -n partprobe > /dev/null 2>&1
	
	
	
	# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
	
	! _live_sfdisk -l "$scriptLocal"/vm-live-more.iso | grep 'Sector size (logical/physical): 512 bytes / 512 bytes' > /dev/null 2>&1 && _stop 1
	
	rm -f "$safeTmp"/vm-live-more.iso.sfdisk
	
	#_live_sfdisk -d "$scriptLocal"/vm-live-more.iso > "$safeTmp"/vm-live-more.iso.sfdisk
	#echo 'size=8G, type=83' >> "$safeTmp"/vm-live-more.iso.sfdisk
	
	#echo 'size=4G, type=83' >> "$safeTmp"/vm-live-more.iso.sfdisk
	#echo 'size=5G, type=5' >> "$safeTmp"/vm-live-more.iso.sfdisk
	#echo 'size=4G, type=85' >> "$safeTmp"/vm-live-more.iso.sfdisk
	
	#echo 'size=1G, type=85' >> "$safeTmp"/vm-live-more.iso.sfdisk
	
	
	echo 'size=2G, type=83' >> "$safeTmp"/vm-live-more.iso.sfdisk
	echo 'type=5' >> "$safeTmp"/vm-live-more.iso.sfdisk
	echo 'size=4G, type=82' >> "$safeTmp"/vm-live-more.iso.sfdisk
	echo 'size=6G, type=83' >> "$safeTmp"/vm-live-more.iso.sfdisk
	
	
	# Tested , working .
	#echo 'size=4G, type=82' >> "$safeTmp"/vm-live-more.iso.sfdisk
	#echo 'size=6G, type=83' >> "$safeTmp"/vm-live-more.iso.sfdisk
	
	
	cat "$safeTmp"/vm-live-more.iso.sfdisk | _live_sfdisk --append "$scriptLocal"/vm-live-more.iso
	
	! _live_sfdisk -l "$scriptLocal"/vm-live-more.iso | grep 'Sector size (logical/physical): 512 bytes / 512 bytes' > /dev/null 2>&1 && _stop 1
	
	
	
	
	
	
	
	_messagePlain_nominal '_live_more_procedure: filesystems: format'
	
	
	
	_messagePlain_nominal 'Attempt: _closeLoop'
	! _closeLoop && _messageFAIL && _stop 1
	
	_messagePlain_nominal 'Attempt: _openLoop'
	! [[ -e "$scriptLocal"/vm-live-more.iso ]] && _messageFAIL && _stop 1
	export ubVirtImageOverride_alternate="$scriptLocal"/vm-live-more.iso
	! _openLoop && _messageFAIL && _stop 1
	
	local current_imagedev
	current_imagedev=$(cat "$scriptLocal"/imagedev)
	
	[[ "$current_imagedev" != '/dev/loop'* ]] && _messageFAIL && _stop 1
	
	
	! _live_sfdisk -l "$current_imagedev" | grep 'Sector size (logical/physical): 512 bytes / 512 bytes' > /dev/null 2>&1 && _messageFAIL && _stop 1
	
	! _live_sfdisk -l "$current_imagedev" | grep "$current_imagedev"p3 | grep '4194304' > /dev/null 2>&1 && _messageFAIL && _stop 1
	! _live_sfdisk -l "$current_imagedev" | grep "$current_imagedev"p5 | grep '8388608' > /dev/null 2>&1 && _messageFAIL && _stop 1
	! _live_sfdisk -l "$current_imagedev" | grep "$current_imagedev"p6 | grep '12582912' > /dev/null 2>&1 && _messageFAIL && _stop 1
	
	! [[ -e "$current_imagedev"p6 ]] && _messageFAIL && _stop 1
	
	
	sudo -n mkfs.ext4 -L 'bulk' -U 'f1edb7fb-13b1-4c97-91d2-baf50e6d65d8' "$current_imagedev"p3
	sudo -n mkswap -L 'hint' -U '469457fc-293f-46ec-92da-27b5d0c36b17' "$current_imagedev"p5
	sudo -n mkfs.ext4 -L 'dent' -U 'd82e3d89-3156-4484-bde2-ccc534ca440b' "$current_imagedev"p6
	
	
	
	# https://manpages.debian.org/testing/live-boot-doc/persistence.conf.5.en.html
	 # WARNING: 'persistence.conf' ... 'root of its file system' ... 'Any such labeled volume must have such a file, or it will be ignored.'
	mkdir -p "$safeTmp"/fsmount_temp/bulk
	sudo -n mount "$current_imagedev"p3 "$safeTmp"/fsmount_temp/bulk
	
	_live_persistent_conf_here | sudo tee "$safeTmp"/fsmount_temp/bulk/persistence.conf > /dev/null
	
	sudo -n mkdir -p "$safeTmp"/fsmount_temp/bulk/persist/bulk
	_live_persistent_conf_here | sudo tee "$safeTmp"/fsmount_temp/bulk/persist/persistence.conf > /dev/null
	_live_persistent_conf_here | sudo tee "$safeTmp"/fsmount_temp/bulk/persist/bulk/persistence.conf > /dev/null
	
	
	sudo -n umount "$safeTmp"/fsmount_temp/bulk
	
	
	#_live_sfdisk -l "$current_imagedev"
	#ls -l "$current_imagedev"*
	#sudo -n gparted "$current_imagedev" "$current_imagedev"p1 "$current_imagedev"p2 "$current_imagedev"p3 "$current_imagedev"p5 "$current_imagedev"p6
	
	
	_messagePlain_nominal 'Attempt: _closeLoop'
	! _closeLoop && _messageFAIL && _stop 1
	
	export ubVirtImageOverride_alternate=
	
	
	
	
	
	
	
	_messageNormal '_live_more_procedure: done'
	
	#_stop 0
}
_live_more_sequence() {
	_start
	
	_live_more_procedure "$@"
	
	_stop 0
}


_live_more_convert_vdi() {
	_messagePlain_nominal '_live_more_convert_vdi: convert: vdi'
	
	
	# ATTENTION: Delete 'vm-live-more.vdi.uuid' to force generation of new uuid .
	local current_UUID
	current_UUID=$(head -n1 "$scriptLocal"/vm-live-more.vdi.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	if [[ $(echo "$current_UUID" | wc -c) != 37 ]]
	then
		current_UUID=$(_getUUID)
		rm -f "$scriptLocal"/vm-live-more.vdi.uuid > /dev/null 2>&1
		echo "$current_UUID" > "$scriptLocal"/vm-live-more.vdi.uuid
	fi
	
	
	rm -f "$scriptLocal"/vm-live-more.vdi > /dev/null 2>&1
	
	! [[ -e "$scriptLocal"/vm-live-more.iso ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm-live-more.vdi ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm-live-more.vdi && return 1
	
	_messagePlain_nominal '_img_to_vdi: convertdd'
	if _userVBoxManage convertdd "$scriptLocal"/vm-live-more.iso "$scriptLocal"/vm-live-more-c.vdi --format VDI
	then
		#_messagePlain_nominal '_img_to_vdi: closemedium'
		#_userVBoxManage closemedium "$scriptLocal"/vm-live-more-c.vdi
		_messagePlain_nominal '_img_to_vdi: mv vm-live-more-c.vdi vm.vdi'
		_moveconfirm "$scriptLocal"/vm-live-more-c.vdi "$scriptLocal"/vm-live-more.vdi
		_messagePlain_nominal '_img_to_vdi: setuuid'
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm-live-more.vdi "$current_UUID"
		#_messagePlain_request 'request: rm '"$scriptLocal"/vm-live-more.iso
		_messagePlain_good 'End.'
		return 0
	else
		_messageFAIL
		_stop 1
	fi
}

_live_more_convert_vmdk() {
	_messagePlain_nominal '_live_more_convert_vmdk: convert: vmdk'
	
	
	# ATTENTION: Delete 'vm-live-more.vmdk.uuid' to force generation of new uuid .
	local current_UUID
	current_UUID=$(head -n1 "$scriptLocal"/vm-live-more.vmdk.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	if [[ $(echo "$current_UUID" | wc -c) != 37 ]]
	then
		current_UUID=$(_getUUID)
		rm -f "$scriptLocal"/vm-live-more.vmdk.uuid > /dev/null 2>&1
		echo "$current_UUID" > "$scriptLocal"/vm-live-more.vmdk.uuid
	fi
	
	
	rm -f "$scriptLocal"/vm-live-more.vmdk > /dev/null 2>&1
	
	! [[ -e "$scriptLocal"/vm-live-more.iso ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm-live-more.vmdk ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm-live-more.vmdk && return 1
	
	_messagePlain_nominal '_img_to_vmdk: convertdd'
	
	
	# https://stackoverflow.com/questions/454899/how-to-convert-flat-raw-disk-image-to-vmdk-for-virtualbox-or-vmplayer
	if _userVBoxManage convertdd "$scriptLocal"/vm-live-more.iso "$scriptLocal"/vm-live-more-c.vmdk --format VMDK
	#if qemu-img convert -O vmdk "$scriptLocal"/vm-live-more.iso "$scriptLocal"/vm-live-more-c.vmdk
	then
		#_messagePlain_nominal '_img_to_vmdk: closemedium'
		#_userVBoxManage closemedium "$scriptLocal"/vm-live-more-c.vmdk
		_messagePlain_nominal '_img_to_vmdk: mv vm-live-more-c.vmdk vm.vmdk'
		_moveconfirm "$scriptLocal"/vm-live-more-c.vmdk "$scriptLocal"/vm-live-more.vmdk
		_messagePlain_nominal '_img_to_vmdk: setuuid'
		
		
		#VBoxManage internalcommands sethduuid "$scriptLocal"/vm-live-more.vmdk "$current_UUID"
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm-live-more.vmdk "$current_UUID"
		
		
		#_messagePlain_request 'request: rm '"$scriptLocal"/vm-live-more.iso
		_messagePlain_good 'End.'
		return 0
	else
		_messageFAIL
		_stop 1
	fi
}





# Extra features for the exceptional situation of storing multiple hibernation states, as would be available through 'suspend/snapshot' features of VirtualBox, VMWare, etc, but for computers which do not have such features.
# End users should not normally be expected to use 'live-more.iso' as a disk image for a personal workstation computer.
# NOTICE: Such features may not be completely automatic.
# Only iso filesystem will show to 'sudo gparted /dev/sda' . As usual, do NOT rely on '/dev/sda' (may become instead eg. '/dev/sdb').
#sudo gparted /dev/sda1 /dev/sda2 /dev/sda3 /dev/sda4 /dev/sda5 ...
#sudo swapon /dev/sda5
#sudo mount /dev/sda6 /mnt/dent
# Hibernate, Reboot/Ignore, ...
#sudo dd if=/dev/sda5 of=/mnt/dent bs=1M status=progress
#_bupStore ...
_live_more() {
	_live_more_copy "$@"
	#_live_more_move "$@"
	"$scriptAbsoluteLocation" _live_more_sequence "$@"
}





_live_preload_here() {
	cat << 'CZXWXcRMTo8EmM8i4d'
#!/bin/sh

PREREQ=""

prereqs()
{
    echo "$PREREQ"
}

case "$1" in
prereqs)
    prereqs
    exit 0
;;
esac

if type dd > /dev/null 2>&1
then
	progressFeed() {
		! dd of=/dev/null bs=1M count=1 && return 0

		! dd of=/dev/null bs=1M count=9 && return 0
		echo x1 10MB
		
		! dd of=/dev/null bs=1M count=90 && return 0
		echo x1 100MB
		
		while dd of=/dev/null bs=1M count=100
		do
			echo "x1 100MB"
		done
	}

	echo "_____ preload: /root/home -not core -not .nix -not .gcloud"
	find /root/home -not \( -path \/home/\*/core\* -prune \) -not \( -path \/home/\*/.nix\* -prune \) -not \( -path \/home/\*/.gcloud\* -prune \) -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/klipper -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/moonraker -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/moonraker-env -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/mainsail -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed


	echo "_____ preload: /root/usr/lib -maxdepth 9 -iname '*.so*'"
	find /root/usr/lib -maxdepth 9 -type f -iname '*.so*' -exec dd if={} bs=16384 2>/dev/null \; | progressFeed


	echo "_____ preload: /root/home -not core -not .nix -not .gcloud"
	find /root/home/*/.config -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/.kde -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home/*/.ubcore -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
	find /root/home -maxdepth 1 -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed


	echo "_____ preload: /root/root"
	find /root/root -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed


	echo '_____ preload: /root/var'
	find /root/var -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed


	echo '_____ preload: /root/usr/lib/modules'
	find /root/usr/lib/modules -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/boot'
	find /root/boot -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/usr/lib/systemd'
	find /root/usr/lib/systemd -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/usr/bin'
	find /root/usr/bin -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/bin'
	find /root/bin -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/sbin'
	find /root/sbin -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed

	echo '_____ preload: /root/etc'
	find /root/etc -type f -exec dd if={} bs=16384 2>/dev/null \; | progressFeed
else
	echo "_____ preload: /root/home -not core -not .nix -not .gcloud"
	find /root/home -not \( -path \/home/\*/core\* -prune \) -not \( -path \/home/\*/.nix\* -prune \) -not \( -path \/home/\*/.gcloud\* -prune \) -type f -exec cat {} > /dev/null \;
	find /root/home/*/klipper -type f -exec cat {} > /dev/null \;
	find /root/home/*/moonraker -type f -exec cat {} > /dev/null \;
	find /root/home/*/moonraker-env -type f -exec cat {} > /dev/null \;
	find /root/home/*/mainsail -type f -exec cat {} > /dev/null \;


	echo "_____ preload: /root/usr/lib -maxdepth 9 -iname '*.so*'"
	find /root/usr/lib -maxdepth 9 -type f -iname '*.so*' -exec cat {} > /dev/null \;


	echo "_____ preload: /root/home -not core -not .nix -not .gcloud"
	find /root/home/*/.config -type f -exec cat {} > /dev/null \;
	find /root/home/*/.kde -type f -exec cat {} > /dev/null \;
	find /root/home/*/.ubcore -type f -exec cat {} > /dev/null \;
	find /root/home -maxdepth 1 -type f -exec cat {} > /dev/null \;


	echo "_____ preload: /root/root"
	find /root/root -type f -exec cat {} > /dev/null \;


	echo '_____ preload: /root/var'
	find /root/var -type f -exec cat {} > /dev/null \;


	echo '_____ preload: /root/usr/lib/modules'
	find /root/usr/lib/modules -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/boot'
	find /root/boot -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/usr/lib/systemd'
	find /root/usr/lib/systemd -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/usr/bin'
	find /root/usr/bin -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/bin'
	find /root/bin -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/sbin'
	find /root/sbin -type f -exec cat {} > /dev/null \;

	echo '_____ preload: /root/etc'
	find /root/etc -type f -exec cat {} > /dev/null \;
fi

CZXWXcRMTo8EmM8i4d
}


# https://manpages.debian.org/testing/live-boot-doc/live-boot.7.en.html
# https://github.com/bugra9/persistent
# https://manpages.debian.org/testing/live-boot-doc/persistence.conf.5.en.html
# https://www.freedesktop.org/software/systemd/man/systemd-gpt-auto-generator.html
#  systemd.gpt_auto=false 
#  rd.systemd.gpt_auto=false
 # WARNING: 'persistence.conf' ... 'root of its file system' ... 'Any such labeled volume must have such a file, or it will be ignored.'
# config debug=1 noeject persistence persistence-path=/persist persistence-label=bulk persistence-storage=directory
_live_grub_here() {
	cat <<'CZXWXcRMTo8EmM8i4d'

insmod all_video

search --set=root --file /ROOT_TEXT

#set default="0"
#set default="1"
set default="2"
set timeout=1

menuentry "Live" {
    #linux /vmlinuz boot=live config debug=1 noeject nopersistence selinux=0 mem=3712M resume=UUID=469457fc-293f-46ec-92da-27b5d0c36b17
    #linux /vmlinuz boot=live config debug=1 noeject nopersistence selinux=0 mem=3712M resume=PARTUUID=469457fc-293f-46ec-92da-27b5d0c36b17
    linux /vmlinuz boot=live config debug=1 noeject nopersistence selinux=0 mem=3712M resume=/dev/sda5
    initrd /initrd
}

menuentry "Live - ( persistence )" {
    linux /vmlinuz boot=live config debug=1 noeject persistence persistence-path=/persist persistence-label=bulk persistence-storage=directory selinux=0 mem=3712M resume=/dev/sda5
    initrd /initrd
}

menuentry "Live - ( hint: ignored: resume disabled ) ( mem: all )" {
    linux /vmlinuz boot=live config debug=1 noeject nopersistence selinux=0
    initrd /initrd
}

CZXWXcRMTo8EmM8i4d
}


_write_revert_live() {
	_messagePlain_nominal 'Attempt: _openChRoot'
	! "$scriptAbsoluteLocation" _openChRoot && _messagePlain_bad 'fail: _openChRoot' && _messageFAIL

	#_chroot systemctl enable nfs-blkmap
	#_chroot systemctl enable nfs-idmapd
	#_chroot systemctl enable nfs-mountd
	#_chroot systemctl enable nfs-server
	#_chroot systemctl enable nfsdcld

	#_chroot systemctl enable ssh
	#_chroot systemctl enable sshd

	_chroot systemctl enable exim4


	sudo -n rm -f "$globalVirtFS"/usr/share/initramfs-tools/scripts/init-bottom/preload_run

	[[ -e "$globalVirtFS"/etc/systemd/system.conf.orig ]] && sudo -n mv -f "$globalVirtFS"/etc/systemd/system.conf.orig "$globalVirtFS"/etc/systemd/system.conf


	_chroot update-initramfs -u -k all

	_messagePlain_nominal 'Attempt: _closeChRoot'
	#sudo -n umount "$globalVirtFS"/boot/efi > /dev/null 2>&1
	#sudo -n umount "$globalVirtFS"/boot > /dev/null 2>&1
	! "$scriptAbsoluteLocation" _closeChRoot && _messagePlain_bad 'fail: _closeChRoot' && _messageFAIL
}

# https://willhaley.com/blog/custom-debian-live-environment-grub-only/
# https://web.archive.org/web/*/https://willhaley.com/blog/custom-debian-live-environment-grub-only/*
# https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81
# https://manpages.debian.org/jessie/initramfs-tools/initramfs-tools.8.en.html
# http://www.opopop.net/booting_linux_from_a_loop_file_system/
# https://forums.gentoo.org/viewtopic-t-931250-start-0.html
# https://wiki.debian.org/InitramfsDebug
# https://gist.github.com/avinash-oza/9791c4edd78a03540dc69d6fbf21bd9c
_live_sequence_in() {
	_messageNormal 'init: _live'
	
	_mustGetSudo || return 0
	
	
	
	# WARNING: If the root filesystem has compressed, this would be absurd. Also not expected to affect iso image and such. Better to leave raw image compression to customization of the raw image.
	#_messagePlain_nominal 'Attempt: _openChRoot'
	#! _openChRoot && _messageFAIL && _stop 1
	
	#_messagePlain_nominal 'Compression: zero blanking'
	
	#sudo -n dd if=/dev/zero of="$globalVirtFS"/zero.del bs=8M
	#sudo -n rm -f "$globalVirtFS"/zero.del
	
	#_messagePlain_nominal 'Attempt: _closeChRoot'
	#! _closeChRoot && _messageFAIL && _stop 1
	
	
	
	
	
	_start
	
	cd "$safeTmp"

	_messagePlain_nominal 'Attempt: _openChRoot'
	! "$scriptAbsoluteLocation" _openChRoot && _messagePlain_bad 'fail: _openChRoot' && _messageFAIL

	##_chroot systemctl disable nfs-blkmap
	##_chroot systemctl disable nfs-idmapd
	##_chroot systemctl disable nfs-mountd
	##_chroot systemctl disable nfs-server
	##_chroot systemctl disable nfsdcld

	##_chroot systemctl disable ssh
	##_chroot systemctl disable sshd

	#_chroot systemctl disable exim4


	_live_preload_here | sudo -n tee "$globalVirtFS"/usr/share/initramfs-tools/scripts/init-bottom/preload_run > /dev/null
	_chroot chown root:root /usr/share/initramfs-tools/scripts/init-bottom/preload_run
	_chroot chmod 755 /usr/share/initramfs-tools/scripts/init-bottom/preload_run

	# Apparent repeated success with 'DefaultTasksMax=12' . In one case, some services - SMART and NetworkManager - may have failed to start within timeouts. Some have certainly been close to timeout.
	# Consider reducing below 12 iteratively.
	# Alternatively, this may need to increase. Cron jobs may otherwise fail with such error message as 'fork retry resource temporarily unavailable' .
	# Uncertain whether 'DefaultTasksMax' limits only the number of systemd services started simuntaneously, or also the number of threads total prior to interactive shell.
	sudo -n mv -n "$globalVirtFS"/etc/systemd/system.conf "$globalVirtFS"/etc/systemd/system.conf.orig
	echo '[Manager]
DefaultTasksMax=24' | sudo -n tee "$globalVirtFS"/etc/systemd/system.conf > /dev/null


	_chroot update-initramfs -u -k all



	# Solely to provide more information to convert 'vm-live.iso' back to 'vm.img' offline from only a Live BD-ROM disc .
	mkdir -p "$safeTmp"/root002
	#sudo -n cp -a "$globalVirtFS"/boot "$safeTmp"/root002/boot-copy
	sudo -n rsync -a --progress --exclude "lost+found" "$globalVirtFS"/boot "$safeTmp"/root002/boot-copy
	sudo -n cp -a "$globalVirtFS"/etc/fstab  "$safeTmp"/root002/fstab-copy



	_messagePlain_nominal 'Attempt: _closeChRoot'
	#sudo -n umount "$globalVirtFS"/boot/efi > /dev/null 2>&1
	#sudo -n umount "$globalVirtFS"/boot > /dev/null 2>&1
	! "$scriptAbsoluteLocation" _closeChRoot && _messagePlain_bad 'fail: _closeChRoot' && _messageFAIL





	export safeToDeleteGit="true"
	[[ -e "$scriptLocal"/livefs ]] && _safeRMR "$scriptLocal"/livefs
	[[ -e "$scriptLocal"/livefs ]] && _messageFAIL
	
	mkdir -p "$scriptLocal"/livefs
	[[ ! -e "$scriptLocal"/livefs ]] && _messageFAIL
	
	
	_messagePlain_nominal 'Attempt: _openImage'
	! _openImage && _messageFAIL && _stop 1
	imagedev=$(cat "$scriptLocal"/imagedev)
	if [[ "$ubVirtImageBoot" != "" ]]
	then
		sudo -n mkdir -p "$globalVirtFS"/boot
		sudo -n mount "$imagedev""$ubVirtImageBoot" "$globalVirtFS"/boot
	fi
	if [[ "$ubVirtImageEFI" != "" ]]
	then
		sudo -n mkdir -p "$globalVirtFS"/boot/efi
		sudo -n mount "$imagedev""$ubVirtImageEFI" "$globalVirtFS"/boot/efi
	fi
	
	#/DEBIAN_CUSTOM
	#/ROOT_TEXT
	
	
	#LIVE_BOOT/chroot
	#"$globalVirtFS"
	
	#LIVE_BOOT/scratch
	#"$scriptLocal"/livefs/partial
	
	#LIVE_BOOT/image
	#"$scriptLocal"/livefs/image
	
	
	mkdir -p "$scriptLocal"/livefs/partial
	mkdir -p "$scriptLocal"/livefs/image/live
	
	# TODO: Consider LZO compression and such.
	# TODO: May need to install live-boot , firmware-amd-graphics
	#sudo -n mksquashfs "$globalVirtFS" "$scriptLocal"/livefs/image/live/filesystem.squashfs -no-xattrs -noI -noD -noF -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	#sudo -n mksquashfs "$globalVirtFS" "$scriptLocal"/livefs/image/live/filesystem.squashfs -b  -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab




	#mkdir -p "$safeTmp"/root001
	#sudo -n cp -a "$globalVirtFS"/home  "$safeTmp"/root001/

	#mkdir -p "$safeTmp"/recycle
	#sudo -n mv -f "$safeTmp"/root001/home/user/* "$safeTmp"/recycle/
	#sudo -n mv -f "$safeTmp"/recycle/core "$safeTmp"/root001/home/user/
	#sudo -n chown -R "$USER":"$USER" "$safeTmp"/recycle
	#_safeRMR "$safeTmp"/recycle

	#mkdir -p "$safeTmp"/recycle
	#sudo -n mv -f "$safeTmp"/root001/home/* "$safeTmp"/recycle/
	#sudo -n mv -f "$safeTmp"/recycle/user "$safeTmp"/root001/home/
	#sudo -n chown -R "$USER":"$USER" "$safeTmp"/recycle
	#_safeRMR "$safeTmp"/recycle

	#_messagePlain_probe_cmd ls -ld "$safeTmp"/root001
	#_messagePlain_probe_cmd ls -ld "$safeTmp"/root001/home
	#_messagePlain_probe_cmd ls -ld "$safeTmp"/root001/home/user
	#_messagePlain_probe_cmd ls -ld "$safeTmp"/root001/home/user/core
	#_messagePlain_probe_cmd ls -l "$safeTmp"/root001/home/user/core/

	#sudo -n mksquashfs "$safeTmp"/root001 "$scriptLocal"/livefs/image/live/filesystem.squashfs -b 65536 -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	#sudo -n chown -R "$USER":"$USER" "$safeTmp"/root001
	#_safeRMR "$safeTmp"/root001


	# https://github.com/openwrt/openwrt/issues/9974
	# http://neoscientists.org/~tmueller/binsort/
	#sudo -n mksquashfs "$globalVirtFS" "$scriptLocal"/livefs/image/live/filesystem.squashfs -b 262144 -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e home/user/core -e boot -e etc/fstab



	# Solely to provide more information to convert 'vm-live.iso' back to 'vm.img' offline from only a Live BD-ROM disc .
	_messagePlain_nominal 'mksquashfs: root002: boot-copy , fstab-copy'
	_messagePlain_probe_cmd df -h
	if ! _messagePlain_probe_cmd sudo -n mksquashfs "$safeTmp"/root002 "$scriptLocal"/livefs/image/live/filesystem.squashfs -b 262144 -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	du -sh "$scriptLocal"/livefs/image/live/filesystem.squashfs
	sudo -n chown -R "$USER":"$USER" "$safeTmp"/root002
	export safeToDeleteGit="true"
	_safeRMR "$safeTmp"/root002
	if [[ -e "$safeTmp"/root002 ]]
	then
		_messageFAIL
		_stop 1
		return 1
	fi

	mkdir -p "$safeTmp"/root001
	sudo -n mkdir -p "$safeTmp"/root001/home
	#sudo -n cp -a "$globalVirtFS"/home "$safeTmp"/root001/
	sudo -n mount --bind "$globalVirtFS"/home "$safeTmp"/root001/home
	_messagePlain_probe_cmd mountpoint "$safeTmp"/root001/home
	_messagePlain_probe_cmd sudo -n ls -l "$safeTmp"/root001/home/user/core/
	_messagePlain_probe_cmd sudo -n du -sh "$safeTmp"/root001/home
	_messagePlain_nominal 'mksquashfs: root001: home'
	_messagePlain_probe_cmd df -h
	if ! _messagePlain_probe_cmd sudo -n mksquashfs "$safeTmp"/root001 "$scriptLocal"/livefs/image/live/filesystem.squashfs -b 262144 -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	du -sh "$scriptLocal"/livefs/image/live/filesystem.squashfs
	sudo -n umount "$safeTmp"/root001/home
	if mountpoint "$safeTmp"/root001/home
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	sudo -n chown -R "$USER":"$USER" "$safeTmp"/root001
	export safeToDeleteGit="true"
	_safeRMR "$safeTmp"/root001
	if [[ -e "$safeTmp"/root001 ]]
	then
		_messageFAIL
		_stop 1
		return 1
	fi

	_messagePlain_nominal 'mksquashfs: globalVirtFS'
	_messagePlain_probe_cmd df -h
	if ! _messagePlain_probe_cmd sudo -n mksquashfs "$globalVirtFS" "$scriptLocal"/livefs/image/live/filesystem.squashfs -b 262144 -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e home -e boot -e etc/fstab
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	du -sh "$scriptLocal"/livefs/image/live/filesystem.squashfs










	
	local currentFilesList
	
	
	# ATTENTION: Configure, remove extra vmlinuz/initrd files, or accept possibility of matching an undesired kernel version.
	#currentFilesList=( "$globalVirtFS"/boot/vmlinuz-* )
	
	# Usually, +1 will be highest version mainline, +2 will be lts, +3 will be much older from distribution.
	currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/vmlinuz-* | sort -r -V | tail -n+1 | head -n1)
	#currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/vmlinuz-* | sort -r -V | tail -n+2 | head -n1)
	#currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/vmlinuz-* | sort -r -V | tail -n+3 | head -n1)
	
	cp "${currentFilesList[0]}" "$scriptLocal"/livefs/image/vmlinuz
	
	
	#currentFilesList=( "$globalVirtFS"/boot/initrd.img-* )
	
	currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/initrd.img-* | sort -r -V | tail -n+1 | head -n1)
	#currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/initrd.img-* | sort -r -V | tail -n+2 | head -n1)
	#currentFilesList=$(ls -A -1 "$globalVirtFS"/boot/initrd.img-* | sort -r -V | tail -n+3 | head -n1)
	
	cp "${currentFilesList[0]}" "$scriptLocal"/livefs/image/initrd
	
	
	_live_grub_here > "$scriptLocal"/livefs/partial/grub.cfg
	touch "$scriptLocal"/livefs/image/ROOT_TEXT
	
	_messagePlain_nominal 'Attempt: _closeImage'
	sudo -n umount "$globalVirtFS"/boot/efi > /dev/null 2>&1
	sudo -n umount "$globalVirtFS"/boot > /dev/null 2>&1
	! _closeImage && _messageFAIL && _stop 1
	
	
	
	
	_write_revert_live
	
	
	
	grub-mkstandalone --format=x86_64-efi --output="$scriptLocal"/livefs/partial/bootx64.efi --locales="" --fonts="" "boot/grub/grub.cfg="$scriptLocal"/livefs/partial/grub.cfg"
	
	
	cd "$scriptLocal"/livefs/partial
	dd if=/dev/zero of="$scriptLocal"/livefs/partial/efiboot.img bs=1M count=10
	"$(sudo -n bash -c 'type -p mkfs.vfat' || echo /sbin/mkfs.vfat)" "$scriptLocal"/livefs/partial/efiboot.img
	mmd -i "$scriptLocal"/livefs/partial/efiboot.img efi efi/boot
	mcopy -i "$scriptLocal"/livefs/partial/efiboot.img "$scriptLocal"/livefs/partial/bootx64.efi ::efi/boot/
	cd "$scriptLocal"/livefs
	
	
	
	grub-mkstandalone --format=i386-pc --output="$scriptLocal"/livefs/partial/core.img --install-modules="linux normal iso9660 biosdisk memdisk search tar ls" --modules="linux normal iso9660 biosdisk search" --locales="" --fonts="" "boot/grub/grub.cfg="$scriptLocal"/livefs/partial/grub.cfg"
	
	
	cat /usr/lib/grub/i386-pc/cdboot.img "$scriptLocal"/livefs/partial/core.img > "$scriptLocal"/livefs/partial/bios.img
	
	
	
	
	
	
	
	_stop 0
}
_live_sequence_out() {
	[[ ! -e "$scriptLocal"/livefs ]] && _messageFAIL
	_start
	
	
	xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -volid "ROOT_TEXT" -eltorito-boot boot/grub/bios.img -no-emul-boot -boot-load-size 4 -boot-info-table --eltorito-catalog boot/grub/boot.cat --grub2-boot-info --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img -eltorito-alt-boot -e EFI/efiboot.img -no-emul-boot -append_partition 2 0xef "$scriptLocal"/livefs/partial/efiboot.img -output "$safeTmp"/live.iso -graft-points "$scriptLocal"/livefs/image /boot/grub/bios.img="$scriptLocal"/livefs/partial/bios.img /EFI/efiboot.img="$scriptLocal"/livefs/partial/efiboot.img
	
	
	mv "$safeTmp"/live.iso "$scriptLocal"/vm-live.iso
	
	
	
	
	_messageNormal '_live: done'
	
	_stop 0
}
_live() {
	if ! "$scriptAbsoluteLocation" _live_sequence_in "$@"
	then
		_stop 1
	fi
	
	#rm -f "$scriptLocal"/vm.img
	
	if ! "$scriptAbsoluteLocation" _live_sequence_out "$@"
	then
		_stop 1
	fi
	
	export safeToDeleteGit="true"
	_safeRMR "$scriptLocal"/livefs
	
	
	#! _live_more && _stop 1
	
	#return 0
}


_override_VBox-live() {
	#export ub_keepInstance='true'
	export ub_override_vbox_livecd_more="$scriptLocal"/vm-live-more.vdi
	#export ub_override_vbox_livecd_more="$scriptLocal"/vm-live-more.iso
	#export ub_override_vbox_livecd="$scriptLocal"/vm-live.iso
}


_userVBoxLive() {
	_override_VBox-live
	
	_userVBox "$@"
}

_editVBoxLive() {
	_override_VBox-live
	
	_editVBox "$@"
}

_persistentVBoxLive() {
	_override_VBox-live
	
	_persistentVBox "$@"
}


_override_qemu-live() {
	#export ub_keepInstance='true'
	export ub_override_qemu_livecd_more="$scriptLocal"/vm-live-more.iso
	#export ub_override_qemu_livecd="$scriptLocal"/vm-live.iso
}





_userQemuLive() {
	_override_qemu-live
	
	_userQemu "$@"
}

_editQemuLive() {
	_override_qemu-live
	
	_editQemu "$@"
}

_persistentQemuLive() {
	_override_qemu-live
	
	_persistentQemu "$@"
}


