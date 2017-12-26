_here_mkboot_grubcfg() {
	
	cat << 'CZXWXcRMTo8EmM8i4d'
set default="0"
set timeout="1"

menuentry "Buildroot" {
    insmod gzio
    insmod part_msdos
    insmod ext2
CZXWXcRMTo8EmM8i4d

	local linuxImageName
	linuxImageName=$(ls "$chrootDir"/boot | grep vmlinuz | tail -n 1)
	local linuxInitRamFS
	linuxInitRamFS=$(ls "$chrootDir"/boot | grep initrd | tail -n 1)
	
	echo "linux (hd0,msdos1)/boot/""$linuxImageName"" root=/dev/sda1 rw console=tty0 console=ttyS0"
	echo "initrd /boot/""$linuxInitRamFS"

	cat << 'CZXWXcRMTo8EmM8i4d'
}
CZXWXcRMTo8EmM8i4d

}
