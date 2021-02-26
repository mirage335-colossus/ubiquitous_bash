
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
	
	return 0
}




_live_fdisk() {
	if [[ -e '/sbin/fdisk' ]]
	then
		/sbin/fdisk "$@"
		return
	fi
	fdisk "$@"
	return
}

_live_sfdisk() {
	if [[ -e '/sbin/sfdisk' ]]
	then
		/sbin/sfdisk "$@"
		return
	fi
	sfdisk "$@"
	return
}



_live_more_procedure() {
	_messageNormal 'init: _live_more_procedure'
	
	#_start
	
	
	[[ ! -e "$scriptLocal"/vm-live.iso ]] && _messageFAIL && _stop 1
	
	
	
	_messagePlain_nominal '_live_more_procedure: copy'
	
	rm -f "$scriptLocal"/vm-live-more.iso
	
	cp "$scriptLocal"/vm-live.iso "$scriptLocal"/vm-live-more.iso
	
	
	
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
	
	
	
	#_live_sfdisk -l "$current_imagedev"
	#ls -l "$current_imagedev"*
	#sudo -n gparted "$current_imagedev" "$current_imagedev"p1 "$current_imagedev"p2 "$current_imagedev"p3 "$current_imagedev"p5 "$current_imagedev"p6
	
	
	_messagePlain_nominal 'Attempt: _closeLoop'
	! _closeLoop && _messageFAIL && _stop 1
	
	
	
	_messageNormal '_live_more_procedure: done'
	
	#_stop 0
}

_live_more_sequence() {
	_start
	
	_live_more_procedure "$@"
	
	_stop 0
}

_live_more() {
	"$scriptAbsoluteLocation" _live_more_sequence "$@"
}


_live_grub_here() {
	cat <<'CZXWXcRMTo8EmM8i4d'

insmod all_video

search --set=root --file /ROOT_TEXT

set default="0"
set timeout=2

menuentry "Live" {
    #linux /vmlinuz boot=live selinux=0 mem=3712M resume=UUID=469457fc-293f-46ec-92da-27b5d0c36b17
    #linux /vmlinuz boot=live selinux=0 mem=3712M resume=PARTUUID=469457fc-293f-46ec-92da-27b5d0c36b17
    linux /vmlinuz boot=live selinux=0 mem=3712M resume=/dev/sda5
    initrd /initrd
}

menuentry "Live - ( hint: ignored: resume disabled )" {
    linux /vmlinuz boot=live selinux=0
    initrd /initrd
}
CZXWXcRMTo8EmM8i4d
}


# https://willhaley.com/blog/custom-debian-live-environment-grub-only/
# https://web.archive.org/web/*/https://willhaley.com/blog/custom-debian-live-environment-grub-only/*
# https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81
# https://manpages.debian.org/jessie/initramfs-tools/initramfs-tools.8.en.html
# http://www.opopop.net/booting_linux_from_a_loop_file_system/
# https://forums.gentoo.org/viewtopic-t-931250-start-0.html
# https://wiki.debian.org/InitramfsDebug
# https://gist.github.com/avinash-oza/9791c4edd78a03540dc69d6fbf21bd9c
_live() {
	_messageNormal 'init: _live'
	
	_mustGetSudo || return 0
	
	
	
	
	_messagePlain_nominal 'Attempt: _openChRoot'
	! _openChRoot && _messageFAIL && _stop 1
	
	_messagePlain_nominal 'Compression: zero blanking'
	
	sudo -n dd if=/dev/zero of="$globalVirtFS"/zero.del bs=8M
	sudo -n rm -f "$globalVirtFS"/zero.del
	
	_messagePlain_nominal 'Attempt: _closeChRoot'
	! _closeChRoot && _messageFAIL && _stop 1
	
	
	
	
	
	_start
	
	cd "$safeTmp"
	
	
	_messagePlain_nominal 'Attempt: _openImage'
	! _openImage && _messageFAIL && _stop 1
	
	#/DEBIAN_CUSTOM
	#/ROOT_TEXT
	
	
	#LIVE_BOOT/chroot
	#"$globalVirtFS"
	
	#LIVE_BOOT/scratch
	#"$safeTmp"/partial
	
	#LIVE_BOOT/image
	#"$safeTmp"/image
	
	
	mkdir -p "$safeTmp"/partial
	mkdir -p "$safeTmp"/image/live
	
	# TODO: Consider LZO compression and such.
	# TODO: May need to install live-boot , firmware-amd-graphics
	#sudo -n mksquashfs "$globalVirtFS" "$safeTmp"/image/live/filesystem.squashfs -no-xattrs -noI -noD -noF -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	sudo -n mksquashfs "$globalVirtFS" "$safeTmp"/image/live/filesystem.squashfs -no-xattrs -noI -noX -comp lzo -Xalgorithm lzo1x_1 -e boot -e etc/fstab
	
	local currentFilesList
	
	# ATTENTION: Configure, remove extra vmlinuz/initrd files, or accept possibility of matching an undesired kernel version.
	currentFilesList=( "$globalVirtFS"/boot/vmlinuz-* )
	cp "${currentFilesList[0]}" "$safeTmp"/image/vmlinuz
	
	currentFilesList=( "$globalVirtFS"/boot/initrd.img-* )
	cp "${currentFilesList[0]}" "$safeTmp"/image/initrd
	
	_live_grub_here > "$safeTmp"/partial/grub.cfg
	touch "$safeTmp"/image/ROOT_TEXT
	
	_messagePlain_nominal 'Attempt: _closeImage'
	! _closeImage && _messageFAIL && _stop 1
	
	
	
	
	
	
	
	
	grub-mkstandalone --format=x86_64-efi --output="$safeTmp"/partial/bootx64.efi --locales="" --fonts="" "boot/grub/grub.cfg="$safeTmp"/partial/grub.cfg"
	
	
	cd "$safeTmp"/partial
	dd if=/dev/zero of="$safeTmp"/partial/efiboot.img bs=1M count=10
	"$(sudo -n bash -c 'type -p mkfs.vfat' || echo /sbin/mkfs.vfat)" "$safeTmp"/partial/efiboot.img
	mmd -i "$safeTmp"/partial/efiboot.img efi efi/boot
	mcopy -i "$safeTmp"/partial/efiboot.img "$safeTmp"/partial/bootx64.efi ::efi/boot/
	cd "$safeTmp"
	
	
	
	grub-mkstandalone --format=i386-pc --output="$safeTmp"/partial/core.img --install-modules="linux normal iso9660 biosdisk memdisk search tar ls" --modules="linux normal iso9660 biosdisk search" --locales="" --fonts="" "boot/grub/grub.cfg="$safeTmp"/partial/grub.cfg"
	
	
	cat /usr/lib/grub/i386-pc/cdboot.img "$safeTmp"/partial/core.img > "$safeTmp"/partial/bios.img
	
	
	xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -volid "ROOT_TEXT" -eltorito-boot boot/grub/bios.img -no-emul-boot -boot-load-size 4 -boot-info-table --eltorito-catalog boot/grub/boot.cat --grub2-boot-info --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img -eltorito-alt-boot -e EFI/efiboot.img -no-emul-boot -append_partition 2 0xef "$safeTmp"/partial/efiboot.img -output "$safeTmp"/live.iso -graft-points "$safeTmp"/image /boot/grub/bios.img="$safeTmp"/partial/bios.img /EFI/efiboot.img="$safeTmp"/partial/efiboot.img
	
	
	mv "$safeTmp"/live.iso "$scriptLocal"/vm-live.iso
	
	
	
	
	! _live_more && _stop 1
	
	
	_messageNormal '_live: done'
	
	_stop 0
}


_override_VBox-live() {
	#export ub_keepInstance='true'
	export ub_override_vbox_livecd_more="$scriptLocal"/vm-live-more.iso
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


