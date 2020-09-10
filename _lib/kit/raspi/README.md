# Usage

Requires specific files to be installed in specific locations. See "_doc" for brief specifications.

Typically intended for embedded computers, such as raspi .

Support for x64, and even x64 specific features, may be included.

Despite the name "raspi", this kit is designed to, but not guaranteed to be tested to, modify standard bootable x64 images as well. Rather, "raspi" is the original primarily supported device.


# Special

EFI OS may require the 'default' 'bootloader' file, such as 'EFI/ubuntu/grubx64.efi' to be copied to 'EFI/BOOT/bootx64.efi' , to allow booting by other computers (including virtual machines).

https://askubuntu.com/questions/380447/uefi-boot-fails-when-cloning-image-to-new-machine


# Exceptions

Not all files in this kit need be copied.

* "README.md"
	Describes kit, not any resulting project.

* "_doc"
	Syntax highlighted documentation. Retain in submodule.



