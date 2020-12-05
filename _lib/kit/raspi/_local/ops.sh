#Enable search if "vm.img" and related files are missing.
export ubVirtImageLocal="true"


###

# ATTENTION: Override with 'ops', env, or similar.
# DANGER: NOT respected (and possibly not needed) by some virtualization backends.
# DANGER: Root image/device/partiton must be correct!
# WARNING: Implies 'true' "ubVirtImageLocal" .

# WARNING: Implies blank "ubVirtImagePartition" .
#export ubVirtImageIsRootPartition='true'

#export ubVirtImageIsDevice='true'
#export ubVirtImageOverride='/dev/disk/by-id/identifier-part2'

# ATTENTION: Device file pointing to full disk, including partition table, for full booting.
# Will take precedence over "ubVirtImageOverride" with virtualization backends capable of full booting.
# vbox , qemu
##export ubVirtDeviceOverride='/dev/disk/by-id/identifier'


# ATTENTION: Explicitly override platform. Not all backends support all platforms.
# chroot , qemu
# x64-bios , raspbian , x64-efi
export ubVirtPlatformOverride='raspbian'

###



###

# ATTENTION: Override with 'ops' or similar.
# WARNING: Do not override unnecessarily. Default rules are expected to accommodate typical requirements.

# WARNING: Only applies to imagedev (text) loopback device.
# x64 bios , raspbian , x64 efi (respectively)

#export ubVirtImagePartition='p1'

#export ubVirtImagePartition='p2'

#export ubVirtImagePartition='p3'
#export ubVirtImageEFI=p2



# ATTENTION: Unusual 'x64-efi' variation.
#export ubVirtImagePartition='p2'
#export ubVirtImageEFI='p1'

###


# _vboxGUI() {
# 	_workaround_VirtualBoxVM "$@"
# 	
# 	#VirtualBoxVM "$@"
# 	#VirtualBox "$@"
# 	#VBoxSDL "$@"
# }


# _set_instance_vbox_features_app() {
# 	VBoxManage modifyvm "$sessionid" --usbxhci on
# 	VBoxManage modifyvm "$sessionid" --rtcuseutc on
# 	
# 	VBoxManage modifyvm "$sessionid" --graphicscontroller vmsvga --accelerate2dvideo off --accelerate3d off
# 	#VBoxManage modifyvm "$sessionid" --graphicscontroller vmsvga --accelerate2dvideo off --accelerate3d on
# 	
# 	VBoxManage modifyvm "$sessionid" --paravirtprovider 'default'
# }


# _set_instance_vbox_features_app_post() {
# 	true
# 	
# 	# Optional. Test live ISO image produced by '_live' .
# 	if ! _messagePlain_probe_cmd VBoxManage storageattach "$sessionid" --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium "$scriptLocal"/vm-live.iso
# 	then
# 		_messagePlain_warn 'fail: vm-live'
# 	fi
# 	
# 	if ! _messagePlain_probe_cmd VBoxManage storageattach "$sessionid" --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium "$scriptLib"/super_grub2/super_grub2_disk_hybrid_2.04s1.iso
# 	then
# 		_messagePlain_warn 'fail: super_grub2'
# 	fi
# 	
# 	# Having attached and then detached the iso image, adds it to the 'media library' and creates the extra disk controller for conveinence, while preventing it from being booted by default.
# 	# Unfortunately, it seems VirtualBox ignores directives to attempt to boot hard disk before CD image. Possibly due to CD image being a hybrid USB/disk image as well.
# 	if ! _messagePlain_probe_cmd VBoxManage storageattach "$sessionid" --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium emptydrive
# 	then
# 		_messagePlain_warn 'fail: iso: emptydrive'
# 	fi
# }




# # ATTENTION: Override with 'ops' or similar.
# _integratedQemu_x64_display() {
# 	
# 	qemuArgs+=(-device virtio-vga,virgl=on -display gtk,gl=on)
# 	
# 	true
# }











