
# WARNING: Virtual Machine MSW11 compatibility may also require registry changes to 'HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig' (reg file available from VBoxGuestAdditions disc image), modified installation disc (replacing 'appraiserres.dll' with copy from MSW10 disc image), etc. MSW11 installers and upgrades may still refuse.
# https://blogs.oracle.com/virtualization/post/install-microsoft-windows-11-on-virtualbox
# https://www.xda-developers.com/install-windows-11-unsupported-pc/

# WARNING: Virtual Machine MSW11 (and MS10) graphics driver compatibility may require installing some drivers.
# https://www.reddit.com/r/kvm/comments/8h15b1/windows_10_guest_best_video_driver/
# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
# https://www.windowscentral.com/how-convert-mbr-disk-gpt-move-bios-uefi-windows-10


export ubVirtPlatformOverride="x64-efi"

export vboxOStype=Windows11_64
[[ "$vboxOStype" == "Win"*"10"* ]] && export ubVirtPlatformOverride="x64-efi"
[[ "$vboxOStype" == "Win"*"11"* ]] && export ubVirtPlatformOverride="x64-efi"

#export ubVirtPlatformOverride="x64-bios"



export vmSize=15064

#export vmMemoryAllocation=4096

export vboxCPUsAllowManyCores=true


#export vboxCPUsAllowManyThreads=true

_vboxGUI() {
	_workaround_VirtualBoxVM "$@"
	
	#VirtualBoxVM "$@"
	#VirtualBox "$@"
	#VBoxSDL "$@"
}

_set_instance_vbox_features_app() {
	#true
	if ! VBoxManage modifyvm "$sessionid" --usbxhci on
		then
		return 1
	fi
	
	if ! _messagePlain_probe_cmd VBoxManage modifyvm "$sessionid" --paravirtprovider 'hyperv'
	then
		return 1
	fi
}



