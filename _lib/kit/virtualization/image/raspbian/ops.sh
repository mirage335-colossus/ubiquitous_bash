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

###


