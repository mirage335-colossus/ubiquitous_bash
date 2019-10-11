#Disable search if "vm.img" and related files are missing.
export ubVirtImageLocal="true"

# DANGER: Intended for ChRoot with ad-hoc installations to physical hardware. NOT respected by other virtualization backends.
#export ubVirtImageOverride='/dev/disk/by-id/ata-id-id'

# DANGER: REQUIRES image/device including ONLY root partition!
# DANGER: Intended for ChRoot. NOT respected (and possibly not needed) by other virtualization backends.
#export ubVirtImageIsRootPartition='true'

