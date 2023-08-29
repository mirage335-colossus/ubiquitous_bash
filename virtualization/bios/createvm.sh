

# Creates a raw VM image. Default Hybrid/UEFI partitioning and formatting.
# ATTENTION: Override, if necessary.
_createVMimage() {
	_messageNormal '##### _createVMimage'
	
	mkdir -p "$scriptLocal"
	
	
	export vmImageFile="$scriptLocal"/vm.img
	[[ -e "$vmImageFile" ]] && _messagePlain_good 'exists: '"$vmImageFile" && return 0
	[[ -e "$scriptLocal"/vm.img ]] && _messagePlain_good 'exists: '"$vmImageFile" && return 0
	
	[[ -e "$lock_open" ]]  && _messagePlain_bad 'bad: locked!' && _messageFAIL && _stop 1
	[[ -e "$scriptLocal"/l_o ]]  && _messagePlain_bad 'bad: locked!' && _messageFAIL && _stop 1
	
	! [[ $(df --block-size=1000000000 --output=avail "$scriptLocal" | tr -dc '0-9') -gt "25" ]] && _messageFAIL && _stop 1
	
	
	
	local imagedev
	
	_open
	
	export vmImageFile="$scriptLocal"/vm.img
	[[ -e "$vmImageFile" ]] && _messagePlain_bad 'exists: '"$vmImageFile" && _messageFAIL && _stop 1
	
	
	_messageNormal 'create: vm.img'
	
	export vmSize=26880
	_createRawImage
	
	
	_messageNormal 'partition: vm.img'
	sudo -n parted --script "$vmImageFile" 'mklabel gpt'
	
	# Unusual.
	#   EFI, Image/Root.
	# Former default, only preferable if disk is strictly spinning CAV and many more bits per second with beginning tracks.
	#   Swap, EFI, Image/Root.
	# Compromise. May have better compatibility, may reduce CLV (and zoned CAV) speed changes from slowest tracks at beginning of some optical discs.
	#   EFI, Swap, Image/Root.
	# Expect <8MiB usage of EFI parition FAT32 filesystem, ~28GiB usage of Image/Root partition ext4 filesystem.
	# 512MiB EFI, 5120MiB Swap, remainder Image/Root
	# https://www.compuhoy.com/what-is-difference-between-bios-and-efi/
	#  'Does EFI partition have to be first?' 'UEFI does not impose a restriction on the number or location of System Partitions that can exist on a system. (Version 2.5, p. 540.) As a practical matter, putting the ESP first is advisable because this location is unlikely to be impacted by partition moving and resizing operations.'
	# http://blog.arainho.me/grub/gpt/arch-linux/2016/01/14/grub-on-gpt-partition.html
	#  'at the first 2GB of the disk with toggle bios_grub used for booting'
	
	# CAUTION: *As DEFAULT*, must match other definitions (eg. _set_ubDistBuild , 'core.sh' , 'ops.sh' , ubiquitous_bash , etc) .
	# NTFS, Recovery, partitions should not have set values in any other functions. Never used - documentation only.
	# Swap, partition should only have set values in this and fstab functions. Never used elsewhere.
	# x64-bios , raspbian , x64-efi
	export ubVirtImage_doNotOverride="true"
	export ubVirtPlatformOverride='x64-efi'
	export ubVirtImageBIOS=p1
	export ubVirtImageEFI=p2
	export ubVirtImageNTFS=
	export ubVirtImageRecovery=
	export ubVirtImageSwap=p3
	export ubVirtImageBoot=p4
	export ubVirtImagePartition=p5
	
	
	
	
	# ATTENTION: NOTICE: Larger EFI partition may be more compatible. Larger Swap partition may be more useful for hibernation.
	
	# BIOS
	sudo -n parted --script "$vmImageFile" 'mkpart primary ext2 1 2'
	sudo -n parted --script "$vmImageFile" 'set 1 bios_grub on'
	
	
	# EFI
	##sudo -n parted --script "$vmImageFile" 'mkpart EFI fat32 '"2"'MiB '"514"'MiB'
	#sudo -n parted --script "$vmImageFile" 'mkpart EFI fat32 '"2"'MiB '"74"'MiB'
	sudo -n parted --script "$vmImageFile" 'mkpart EFI fat32 '"2"'MiB '"42"'MiB'
	sudo -n parted --script "$vmImageFile" 'set 2 msftdata on'
	sudo -n parted --script "$vmImageFile" 'set 2 boot on'
	sudo -n parted --script "$vmImageFile" 'set 2 esp on'
	
	
	# Swap
	##sudo -n parted --script "$vmImageFile" 'mkpart primary '"514"'MiB '"5633"'MiB'
	##sudo -n parted --script "$vmImageFile" 'mkpart primary '"514"'MiB '"3073"'MiB'
	#sudo -n parted --script "$vmImageFile" 'mkpart primary '"74"'MiB '"98"'MiB'
	sudo -n parted --script "$vmImageFile" 'mkpart primary '"42"'MiB '"44"'MiB'
	
	
	# Boot
	#sudo -n parted --script "$vmImageFile" 'mkpart primary '"98"'MiB '"610"'MiB'
	sudo -n parted --script "$vmImageFile" 'mkpart primary '"44"'MiB '"384"'MiB'
	
	
	# Root
	# WARNING: Adjust vmSize to match +1MiB .
	# Try to keep this <23841MiB-256MiB-1MiB ( ie. <23584MiB ) (exactly 25000000000Bytes is 23841MiB ) . In practice, compression will obviate this issue, and the Live ISO may be more complete (ie. including 'accessories') for recovery purposes .
	# https://www.mail-archive.com/kde-bugs-dist@kde.org/msg618604.html
	#  '25025315816 bytes'   ...   'difference between the available space at the start and at the end is exactly 256M'
	# http://fy.chalmers.se/~appro/linux/DVD+RW/Blu-ray/
	#  '256MB'
	# https://forum.blu-ray.com/showthread.php?t=76407
	# https://forum.imgburn.com/topic/23120-overburn-or-truncate-for-blu-rays/
	# Try to keep this <23GiB-1MiB . Prefer to fit two copies within 46GiB ( eg. 23296MiB == 22.75GiB ) .
	# Try to keep this <28GiB-1MiB . Prefer to fit at least 18GiB (compressed rootfs tar, squashfs, etc) plus this 28GiB .
	# Expect 25.75GiB may suffice ( ie. 22.75GiB+5GiB-2GiB ) (assuming 22.75GiB may have been sufficient by ~5GiB until another ~5GiB was added, and from there ~2GiB may have already been freed by other changes) .
	# Expect 27.75GiB may suffice ( ie. 22.75GiB+5GiB-2GiB ) (assuming 22.75GiB may have been sufficient by ~5GiB until another ~5GiB was added) .

	# Tested successfully.
	# 22.75GiB-1MiB
	#sudo -n parted --script "$vmImageFile" 'mkpart primary '"610"'MiB '"23295"'MiB'

	# 22.95GiB-1MiB
	##sudo -n parted --script "$vmImageFile" 'mkpart primary '"384"'MiB '"23499"'MiB'

	# 23841MiB-256MiB-1MiB -2MiB
	#sudo -n parted --script "$vmImageFile" 'mkpart primary '"384"'MiB '"23582"'MiB'

	# 25.95GiB-1MiB
	#sudo -n parted --script "$vmImageFile" 'mkpart primary '"384"'MiB '"26571"'MiB'

	# 26.25GiB-1MiB
	sudo -n parted --script "$vmImageFile" 'mkpart primary '"384"'MiB '"26879"'MiB'
	
	
	
	sudo -n parted --script "$vmImageFile" 'unit MiB print'
	
	
	_close
	
	
	# Format partitions .
	_messageNormal 'format: vm.img'
	#"$scriptAbsoluteLocation" _loopImage_sequence || _stop 1
	! "$scriptAbsoluteLocation" _openLoop && _messagePlain_bad 'fail: _openLoop' && _messageFAIL
	
	mkdir -p "$globalVirtFS"
	"$scriptAbsoluteLocation" _checkForMounts "$globalVirtFS" && _messagePlain_bad 'bad: mounted: globalVirtFS' && _messageFAIL && _stop 1
	#local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	local imagepart
	local loopdevfs
	
	# Compression from btrfs may free up ~8GB . Some performance degradation may result if files with many random writes (eg. COW VM images) are used with btrfs .
	# https://www.phoronix.com/scan.php?page=article&item=btrfs-zstd-compress&num=4
	# https://btrfs.wiki.kernel.org/index.php/Compression
	# https://unix.stackexchange.com/questions/394973/why-would-i-want-to-disable-copy-on-write-while-creating-qemu-images
	# https://gist.github.com/niflostancu/03810a8167edc533b1712551d4f90a14
	
	# WARNING: Compression/btrfs of boot partition may cause BIOS compatibility issues.
	imagepart="$imagedev""$ubVirtImageBoot"
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$imagepart" | tr -dc 'a-zA-Z0-9')
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	sudo -n mkfs.ext2 -e remount-ro -E lazy_itable_init=0,lazy_journal_init=0 -m 0 "$imagepart" || _stop 1
	#sudo -n mkfs.btrfs --checksum xxhash -M -d single "$imagepart" || _stop 1
	
	imagepart="$imagedev""$ubVirtImageEFI"
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$imagepart" | tr -dc 'a-zA-Z0-9')
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	sudo -n mkfs.vfat -F 32 -n EFI "$imagepart" || _stop 1
	
	imagepart="$imagedev""$ubVirtImagePartition"
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$imagepart" | tr -dc 'a-zA-Z0-9')
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	#sudo -n mkfs.ext4 -e remount-ro -E lazy_itable_init=0,lazy_journal_init=0 -m 0 "$imagepart" || _stop 1
	sudo -n mkfs.btrfs --checksum xxhash -M -d single "$imagepart" || _stop 1
	
	imagepart="$imagedev""$ubVirtImageSwap"
	loopdevfs=$(sudo -n blkid -s TYPE -o value "$imagepart" | tr -dc 'a-zA-Z0-9')
	[[ "$loopdevfs" == "ext4" ]] && _stop 1
	sudo -n mkswap "$imagepart" || _stop 1
	
	#"$scriptAbsoluteLocation" _umountImage || _stop 1
	! "$scriptAbsoluteLocation" _closeLoop && _messagePlain_bad 'fail: _closeLoop' && _messageFAIL
	return 0
}
# WARNING: No production use. No use as-is. Hybrid/UEFI is default.
# WARNING: May necessitate 'update-grub' within 'qemu' or similar to remove incorrecly detected running kernel from menu.
_convertVMimage_sequence() {
	_messageNormal '_convertVMimage_sequence'
	
	_messagePlain_nominal '_convertVMimage_sequence: start'
	_start
	mkdir -p "$safeTmp"/rootfs
	
	local imagedev
	
	
	# ATTENTION: Override if necessary (ie. with 'ops.sh' from an existing image).
	export ubVirtImage_doNotOverride="true"
	export ubVirtPlatformOverride='x64-efi'
	export ubVirtImageBIOS=p1
	export ubVirtImageEFI=p2
	export ubVirtImageNTFS=
	export ubVirtImageRecovery=
	export ubVirtImageSwap=p3
	export ubVirtImageBoot=p4
	export ubVirtImagePartition=p5
	
	
	_messagePlain_nominal '_convertVMimage_sequence: copy: out'
	! "$scriptAbsoluteLocation" _openImage && _messagePlain_bad 'fail: _openImage' && _messageFAIL
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
	
	
	sudo -n rsync -ax "$globalVirtFS"/. "$safeTmp"/rootfs/.
	[[ "$?" != "0" ]] && _messageFAIL
	
	sudo -n rsync -ax "$globalVirtFS"/boot/. "$safeTmp"/rootfs/boot/.
	[[ "$?" != "0" ]] && _messageFAIL
	sudo -n rsync -ax "$globalVirtFS"/boot/efi/. "$safeTmp"/rootfs/boot/efi/.
	[[ "$?" != "0" ]] && _messageFAIL
	
	
	sudo -n umount "$globalVirtFS"/boot/efi > /dev/null 2>&1
	sudo -n umount "$globalVirtFS"/boot > /dev/null 2>&1
	! "$scriptAbsoluteLocation" _closeImage && _messagePlain_bad 'fail: _closeImage' && _messageFAIL
	
	
	rm -f "$scriptLocal"/vm.img
	_createVMimage
	export ubVirtImage_doNotOverride="true"
	
	
	_messagePlain_nominal '_convertVMimage_sequence: copy: in'
	! "$scriptAbsoluteLocation" _openImage && _messagePlain_bad 'fail: _openImage' && _messageFAIL
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
	
	
	sudo -n rsync -ax "$safeTmp"/rootfs/. "$globalVirtFS"/.
	[[ "$?" != "0" ]] && _messageFAIL
	
	sudo -n rsync -ax "$safeTmp"/rootfs/boot/. "$globalVirtFS"/boot/.
	[[ "$?" != "0" ]] && _messageFAIL
	sudo -n rsync -ax "$safeTmp"/rootfs/boot/efi/. "$globalVirtFS"/boot/efi/.
	[[ "$?" != "0" ]] && _messageFAIL
	
	
	sudo -n umount "$globalVirtFS"/boot/efi > /dev/null 2>&1
	sudo -n umount "$globalVirtFS"/boot > /dev/null 2>&1
	! "$scriptAbsoluteLocation" _closeImage && _messagePlain_bad 'fail: _closeImage' && _messageFAIL
	
	
	
	_createVMbootloader-bios
	_createVMbootloader-efi
	
	
	_messagePlain_nominal '_convertVMimage_sequence: stop'
	export safeToDeleteGit="true"
	if ! _safePath "$safeTmp"/rootfs
	then
		_stop 1
		exit 1
		return 1
	fi
	#sudo -n rm -rf "$safeTmp"/rootfs
	sudo -n chown -R "$USER":"$USER" "$safeTmp"/rootfs
	sudo -n chmod -R 700 "$safeTmp"/rootfs
	_safeRMR "$safeTmp"/rootfs
	_stop
}
_convertVMimage() {
	"$scriptAbsoluteLocation" _convertVMimage_sequence "$@"
}


# Creates a raw VM image. UEFI partitioning and formatting (expected possibility of eventual MSW dual-boot compatibility).
_createVMimage-efi() {
	false
}


# Creates a raw VM image. BIOS partitioning and formatting (legacy compatibility, possibly with some cloud providers).
_createVMimage-bios() {
	false
}





_createVMbootloader-bios() {
	_messageNormal '##### _createVMbootloader-bios'
	
	! "$scriptAbsoluteLocation" _openChRoot && _messagePlain_bad 'fail: _openChRoot' && _messageFAIL
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	_createVMfstab
	
	
	_messagePlain_nominal 'chroot: grub-install: bios'
	
	# WARNING: Apparently, any use of BIOS bootloader either needs at least a 'BIOS boot partition' to share with EFI, or needs a dedicated '/boot' for 'btrfs' compression.
	# https://bbs.archlinux.org/viewtopic.php?id=251059
	#  'btrfs' 'zstd compression' 'properly installing the bootloader to a dedicated partitioning designed and maintained for that purpose'
	# https://unix.stackexchange.com/questions/273329/can-i-install-grub2-on-a-flash-drive-to-boot-both-bios-and-uefi
	#  'precondition for this to work is that you use GPT partitioning and that you have an BIOS boot partition (1 MiB is enough).'
	# https://en.wikipedia.org/wiki/BIOS_boot_partition
	#_chroot grub2-install --modules=part_msdos --target=i386-pc "$imagedev"
	
	
	_messagePlain_probe_cmd _chroot grub-install --modules=part_msdos --target=i386-pc "$imagedev"
	_messagePlain_probe_cmd _chroot grub-install --force --modules=part_msdos --target=i386-pc "$imagedev""$ubVirtImageEFI"
	
	
	_messagePlain_nominal 'chroot: update-grub'
	_chroot update-grub
	
	_messagePlain_nominal 'chroot: update-initramfs'
	_chroot update-initramfs -u
	
	
	
	
	! "$scriptAbsoluteLocation" _closeChRoot && _messagePlain_bad 'fail: _closeChRoot' && _messageFAIL
	return 0
}

_createVMbootloader-efi() {
	_messageNormal '##### _createVMbootloader-efi'
	
	! "$scriptAbsoluteLocation" _openChRoot && _messagePlain_bad 'fail: _openChRoot' && _messageFAIL
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	_createVMfstab
	
	
	_messagePlain_nominal 'chroot: grub-install: efi'
	
	# https://unix.stackexchange.com/questions/273329/can-i-install-grub2-on-a-flash-drive-to-boot-both-bios-and-uefi
	#  'precondition for this to work is that you use GPT partitioning and that you have an BIOS boot partition (1 MiB is enough).'
	# https://en.wikipedia.org/wiki/BIOS_boot_partition
	# https://askubuntu.com/questions/705055/gpt-detected-please-create-a-bios-boot-partition
	#  'must be located at the start of a GPT disk, and have a "bios_grub" flag' 'Size: 1MB.'
	#_chroot grub2-install --modules=part_msdos --target=i386-pc "$imagedev"
	
	
	_messagePlain_probe_cmd _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian --recheck --no-nvram --removable "$imagedev"
	_messagePlain_probe_cmd _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=debian --recheck --no-nvram --removable "$imagedev""$ubVirtImageEFI"
	
	_messagePlain_probe_cmd _chroot grub-install --boot-directory=/boot --root-directory=/ --modules=part_msdos --target=x86_64-efi --efi-directory=/boot/efi --recheck "$imagedev"
	
	#sudo -n mkdir -p "$globalVirtFS"/boot/efi/EFI/BOOT/
	#sudo -n cp "$globalVirtFS"/boot/efi/EFI/debian/grubx64.efi "$globalVirtFS"/boot/efi/EFI/BOOT/bootx64.efi
	
	
	_messagePlain_nominal 'chroot: update-grub'
	_chroot update-grub
	
	_messagePlain_nominal 'chroot: update-initramfs'
	_chroot update-initramfs -u
	
	
	
	
	! "$scriptAbsoluteLocation" _closeChRoot && _messagePlain_bad 'fail: _closeChRoot' && _messageFAIL
	return 0
}








_createVMfstab() {
	_messageNormal 'os: globalVirtFS: write: fs: _createVMfstab'
	
	
	local imagedev
	imagedev=$(cat "$scriptLocal"/imagedev)
	
	[[ ! -e "$imagedev" ]] && _messageFAIL
	
	sudo -n mkdir -p "$globalVirtFS"/media/bootdisc
	sudo -n chmod 755 "$globalVirtFS"/media/bootdisc
	
	
	# https://gist.github.com/varqox/42e213b6b2dde2b636ef#edit-fstab-file
	
	#btrfs rescue zero-log /dev/sda5
	
	local ubVirtImagePartition_UUID
	ubVirtImagePartition_UUID=$(sudo -n blkid -s UUID -o value "$imagedev""$ubVirtImagePartition" | tr -dc 'a-zA-Z0-9\-')
	
	#echo 'UUID='"$ubVirtImagePartition_UUID"' / ext4 errors=remount-ro 0 1' | sudo -n tee "$globalVirtFS"/etc/fstab
	#echo 'UUID='"$ubVirtImagePartition_UUID"' / btrfs defaults,compress=zstd:1,notreelog 0 1' | sudo -n tee "$globalVirtFS"/etc/fstab
	echo 'UUID='"$ubVirtImagePartition_UUID"' / btrfs defaults,compress=zstd:1,notreelog,discard 0 1' | sudo -n tee "$globalVirtFS"/etc/fstab
	
	
	# initramfs-update, from chroot, may not enable hibernation/resume... may be device specific
	
	if [[ "$ubVirtImageSwap" != "" ]]
	then
		local ubVirtImageSwap_UUID
		ubVirtImageSwap_UUID=$(sudo -n blkid -s UUID -o value "$imagedev""$ubVirtImageSwap" | tr -dc 'a-zA-Z0-9\-')
	fi
	
	echo '#UUID='"$ubVirtImageSwap_UUID"' swap swap defaults 0 0' | sudo -n tee -a "$globalVirtFS"/etc/fstab
	
	
	if [[ "$ubVirtImageBoot" != "" ]]
	then
		local ubVirtImageBoot_UUID
		ubVirtImageBoot_UUID=$(sudo -n blkid -s UUID -o value "$imagedev""$ubVirtImageBoot" | tr -dc 'a-zA-Z0-9\-')
	fi
	
	echo 'UUID='"$ubVirtImageBoot_UUID"' /boot ext2 defaults 0 1' | sudo -n tee -a "$globalVirtFS"/etc/fstab
	
	
	if [[ "$ubVirtImageEFI" != "" ]]
	then
		local ubVirtImageEFI_UUID
		ubVirtImageEFI_UUID=$(sudo -n blkid -s UUID -o value "$imagedev""$ubVirtImageEFI" | tr -dc 'a-zA-Z0-9\-')
	fi
	
	echo 'UUID='"$ubVirtImageEFI_UUID"' /boot/efi vfat umask=0077 0 1' | sudo -n tee -a "$globalVirtFS"/etc/fstab
	
	
	if ! sudo -n cat "$globalVirtFS"/etc/fstab | grep 'uk4uPhB663kVcygT0q' | grep 'bootdisc' > /dev/null 2>&1
	then
		echo 'LABEL=uk4uPhB663kVcygT0q /media/bootdisc iso9660 ro,nofail 0 0' | sudo -n tee -a "$globalVirtFS"/etc/fstab
	fi
	
	return 0
}








_vm_convert_vdi() {
	_messagePlain_nominal '_vm_convert_vdi: convert: vdi'
	
	_override_bin_vbox
	
	# ATTENTION: Delete 'vm.vdi.uuid' to force generation of new uuid .
	local current_UUID
	current_UUID=$(head -n1 "$scriptLocal"/vm.vdi.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	if [[ $(echo "$current_UUID" | wc -c) != 37 ]]
	then
		current_UUID=$(_getUUID)
		rm -f "$scriptLocal"/vm.vdi.uuid > /dev/null 2>&1
		echo "$current_UUID" > "$scriptLocal"/vm.vdi.uuid
	fi
	
	
	rm -f "$scriptLocal"/vm.vdi > /dev/null 2>&1
	
	! [[ -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm.vdi ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm.vdi && return 1
	
	_messagePlain_nominal '_img_to_vdi: convertdd'
	if _userVBoxManage convertdd "$scriptLocal"/vm.img "$scriptLocal"/vm-c.vdi --format VDI
	then
		#_messagePlain_nominal '_img_to_vdi: closemedium'
		#_userVBoxManage closemedium "$scriptLocal"/vm-c.vdi
		_messagePlain_nominal '_img_to_vdi: mv vm-c.vdi vm.vdi'
		_moveconfirm "$scriptLocal"/vm-c.vdi "$scriptLocal"/vm.vdi
		_messagePlain_nominal '_img_to_vdi: setuuid'
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm.vdi "$current_UUID"
		#_messagePlain_request 'request: rm '"$scriptLocal"/vm.img
		_messagePlain_good 'End.'
		return 0
	else
		_messageFAIL
		_stop 1
	fi
}

_vm_convert_vmdk() {
	_messagePlain_nominal '_vm_convert_vmdk: convert: vmdk'
	
	_override_bin_vbox
	
	# ATTENTION: Delete 'vm.vmdk.uuid' to force generation of new uuid .
	local current_UUID
	current_UUID=$(head -n1 "$scriptLocal"/vm.vmdk.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	if [[ $(echo "$current_UUID" | wc -c) != 37 ]]
	then
		current_UUID=$(_getUUID)
		rm -f "$scriptLocal"/vm.vmdk.uuid > /dev/null 2>&1
		echo "$current_UUID" > "$scriptLocal"/vm.vmdk.uuid
	fi
	
	
	rm -f "$scriptLocal"/vm.vmdk > /dev/null 2>&1
	
	! [[ -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm.vmdk ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm.vmdk && return 1
	
	_messagePlain_nominal '_img_to_vmdk: convertdd'
	
	
	# https://stackoverflow.com/questions/454899/how-to-convert-flat-raw-disk-image-to-vmdk-for-virtualbox-or-vmplayer
	if _userVBoxManage convertdd "$scriptLocal"/vm.img "$scriptLocal"/vm-c.vmdk --format VMDK
	#if qemu-img convert -O vmdk "$scriptLocal"/vm.img "$scriptLocal"/vm-c.vmdk
	then
		#_messagePlain_nominal '_img_to_vmdk: closemedium'
		#_userVBoxManage closemedium "$scriptLocal"/vm-c.vmdk
		_messagePlain_nominal '_img_to_vmdk: mv vm-c.vmdk vm.vmdk'
		_moveconfirm "$scriptLocal"/vm-c.vmdk "$scriptLocal"/vm.vmdk
		_messagePlain_nominal '_img_to_vmdk: setuuid'
		
		
		#VBoxManage internalcommands sethduuid "$scriptLocal"/vm.vmdk "$current_UUID"
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm.vmdk "$current_UUID"
		
		
		#_messagePlain_request 'request: rm '"$scriptLocal"/vm.img
		_messagePlain_good 'End.'
		return 0
	else
		_messageFAIL
		_stop 1
	fi
}


_vm_convert_vhd() {
	_messagePlain_nominal '_vm_convert_vhd: convert: vhd'
	
	_override_bin_vbox
	
	# ATTENTION: Delete 'vm.vhd.uuid' to force generation of new uuid .
	local current_UUID
	current_UUID=$(head -n1 "$scriptLocal"/vm.vhd.uuid 2>/dev/null | tr -dc 'a-zA-Z0-9\-')
	
	if [[ $(echo "$current_UUID" | wc -c) != 37 ]]
	then
		current_UUID=$(_getUUID)
		rm -f "$scriptLocal"/vm.vhd.uuid > /dev/null 2>&1
		echo "$current_UUID" > "$scriptLocal"/vm.vhd.uuid
	fi
	
	
	rm -f "$scriptLocal"/vm.vhd > /dev/null 2>&1
	
	! [[ -e "$scriptLocal"/vm.img ]] && _messagePlain_bad 'fail: missing: in file' && return 1
	[[ -e "$scriptLocal"/vm.vhd ]] && _messagePlain_request 'request: rm '"$scriptLocal"/vm.vhd && return 1
	
	_messagePlain_nominal '_img_to_vhd: convertdd'
	if _userVBoxManage convertdd "$scriptLocal"/vm.img "$scriptLocal"/vm-c.vhd --format VHD
	then
		#_messagePlain_nominal '_img_to_vhd: closemedium'
		#_userVBoxManage closemedium "$scriptLocal"/vm-c.vhd
		_messagePlain_nominal '_img_to_vhd: mv vm-c.vhd vm.vhd'
		_moveconfirm "$scriptLocal"/vm-c.vhd "$scriptLocal"/vm.vhd
		_messagePlain_nominal '_img_to_vhd: setuuid'
		VBoxManage internalcommands sethduuid "$scriptLocal"/vm.vhd "$current_UUID"
		#_messagePlain_request 'request: rm '"$scriptLocal"/vm.img
		_messagePlain_good 'End.'
		return 0
	else
		_messageFAIL
		_stop 1
	fi
}






