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
