export virtGuestUserDrop="ubvrtusr"
export virtGuestUser="$virtGuestUserDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestUser="root"

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$tmpSelf"/v_"$sessionid"
export instancedVirtFS="$instancedVirtDir"/fs
export instancedVirtTmp="$instancedVirtDir"/tmp

export virtGuestHomeDrop=/home/"$virtGuestUserDrop"
export virtGuestHome="$virtGuestHomeDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestHome=/root
###export virtGuestHomeRef="$virtGuestHome".ref

export instancedVirtHome="$instancedVirtFS""$virtGuestHome"
###export instancedVirtHomeRef="$instancedVirtHome".ref

export sharedHostProjectDirDefault=""
export sharedGuestProjectDirDefault="$virtGuestHome"/project

export sharedHostProjectDir="$sharedHostProjectDirDefault"
export sharedGuestProjectDir="$sharedGuestProjectDirDefault"

export instancedProjectDir="$instancedVirtHome"/project
export instancedDownloadsDir="$instancedVirtHome"/Downloads

export chrootDir="$globalVirtFS"
export vboxRaw="$scriptLocal"/vmvdiraw.vmdk

#Only globalFakeHome is persistent. All other default home directories are removed in some way by "_stop".
export globalFakeHome="$scriptLocal"/h
export instancedFakeHome="$tmpSelf"/h_"$sessionid"
export shortFakeHome="$shortTmp"/h

#Do not use directly as home directory. Append subdirectories.
export arbitraryFakeHome="$shortTmp"/a

#Default, override.
# WARNING: Do not disable.
export actualFakeHome="$instancedFakeHome"
export fakeHomeEditLib="false"
export keepFakeHome="true"

#Automatically assigns appropriate memory quantities to nested virtual machines.
_vars_vmMemoryAllocationDefault() {
	export vmMemoryAllocationDefault=96
	
	
	# Invalid.
	[[ "$hostMemoryQuantity" -lt "64000" ]] && return 1
	! [[ "$hostMemoryQuantity" -ge "64000" ]] && return 1
	
	
	# Embedded host typical.
	[[ "$hostMemoryQuantity" -lt "500000" ]] && export vmMemoryAllocationDefault=256 && return 1
	
	# Obsolete hardware or guest typical.
	[[ "$hostMemoryQuantity" -lt "1256000" ]] && export vmMemoryAllocationDefault=512 && return 0
	[[ "$hostMemoryQuantity" -lt "1768000" ]] && export vmMemoryAllocationDefault=1024 && return 0
	[[ "$hostMemoryQuantity" -lt "6000000" ]] && export vmMemoryAllocationDefault=1512 && return 0
	
	# Modern host typical.
	[[ "$hostMemoryQuantity" -lt "7000000" ]] && export vmMemoryAllocationDefault=2048 && return 0
	[[ "$hostMemoryQuantity" -lt "18000000" ]] && export vmMemoryAllocationDefault=2560 && return 0
	[[ "$hostMemoryQuantity" -lt "34000000" ]] && export vmMemoryAllocationDefault=3072 && return 0
	
	# Workstation typical.
	[[ "$hostMemoryQuantity" -lt "72000000" ]] && export vmMemoryAllocationDefault=4096 && return 0
	[[ "$hostMemoryQuantity" -lt "132000000" ]] && export vmMemoryAllocationDefault=4096 && return 0
	
	# Atypical host.
	export vmMemoryAllocationDefault=4096 && return 0
	
	return 1
}

#Machine allocation defaults.
_vars_vmMemoryAllocationDefault


# ATTENTION: Forces 'x64-efi' if 'Windows11' or similar is declared as 'vboxOStype'.
if [[ "$ubVirtPlatformOverride" == "" ]]
then
	[[ "$vboxOStype" == "Win"*"10"* ]] && export ubVirtPlatformOverride="x64-efi"
	[[ "$vboxOStype" == "Win"*"11"* ]] && export ubVirtPlatformOverride="x64-efi"
fi

