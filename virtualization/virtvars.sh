export virtGuestUserDrop="ubvrtusr"
export virtGuestUser="$virtGuestUserDrop"
[[ "$HOST_USER_ID" == 0 ]] && export virtGuestUser="root"

export globalVirtDir="$scriptLocal"/v
export globalVirtFS="$globalVirtDir"/fs
export globalVirtTmp="$globalVirtDir"/tmp

export instancedVirtDir="$scriptAbsoluteFolder"/v_"$sessionid"
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

export globalFakeHome="$scriptLocal"/h
export instancedFakeHome="$scriptAbsoluteFolder"/h_"$sessionid"

#Automatically assigns appropriate memory quantities to nested virtual machines.
_vars_vmMemoryAllocationDefault() {
	export vmMemoryAllocationDefault=96
	
	[[ "$hostMemoryQuantity" -lt "500000" ]] && export vmMemoryAllocationDefault=256 && return 1
	[[ "$hostMemoryQuantity" -lt "800000" ]] && export vmMemoryAllocationDefault=512 && return 1
	#[[ "$hostMemoryQuantity" -lt "1500000" ]] && export vmMemoryAllocationDefault=512 && return 1
	#[[ "$hostMemoryQuantity" -lt "3000000" ]] && export vmMemoryAllocationDefault=896 && return 1
	[[ "$hostMemoryQuantity" -lt "6000000" ]] && export vmMemoryAllocationDefault=1256 && return 1
	#[[ "$hostMemoryQuantity" -lt "8000000" ]] && export vmMemoryAllocationDefault=1256 && return 1
	[[ "$hostMemoryQuantity" -lt "12000000" ]] && export vmMemoryAllocationDefault=1512 && return 1
	#[[ "$hostMemoryQuantity" -lt "16000000" ]] && export vmMemoryAllocationDefault=1512 && return 1
	
}

#Machine allocation defaults.
_vars_vmMemoryAllocationDefault
