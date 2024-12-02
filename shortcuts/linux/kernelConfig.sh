
_kernelConfig_reject-comments() {
	#grep -v '^\#\|\#'
	
	# Preferred for Cygwin.
	grep -v '^#\|#'
}

_kernelConfig_request() {
	local current_kernelConfig_statement
	current_kernelConfig_statement=$(cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=' | tr -dc 'a-zA-Z0-9\=\_')
	
	_messagePlain_request 'hazard: '"$1"': '"$current_kernelConfig_statement"
}


_kernelConfig_require-yes() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 0
	return 1
}

_kernelConfig_require-module-or-yes() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=m' > /dev/null 2>&1 && return 0
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 0
	return 1
}

# DANGER: Currently assuming lack of an entry is equivalent to option set as '=n' with make menuconfig or similar.
_kernelConfig_require-no() {
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=m' > /dev/null 2>&1 && return 1
	cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "$1"'\=y' > /dev/null 2>&1 && return 1
	return 0
}


_kernelConfig_warn-y__() {
	_kernelConfig_require-yes "$1" && return 0
	_messagePlain_warn 'warn: not:    Y: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-y_m() {
	_kernelConfig_require-module-or-yes "$1" && return 0
	_messagePlain_warn 'warn: not:  M/Y: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-n__() {
	_kernelConfig_require-no "$1" && return 0
	_messagePlain_warn 'warn: not:    N: '"$1"
	export kernelConfig_warn='true'
	return 1
}

_kernelConfig_warn-any() {
	_kernelConfig_warn-y_m "$1"
	_kernelConfig_warn-n__ "$1"
}

_kernelConfig__bad-y__() {
	_kernelConfig_require-yes "$1" && return 0
	_messagePlain_bad 'bad: not:     Y: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig__bad-y_m() {
	_kernelConfig_require-module-or-yes "$1" && return 0
	_messagePlain_bad 'bad: not:   M/Y: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig__bad-n__() {
	_kernelConfig_require-no "$1" && return 0
	_messagePlain_bad 'bad: not:     N: '"$1"
	export kernelConfig_bad='true'
	return 1
}

_kernelConfig_require-tradeoff-legacy() {
	_messagePlain_nominal 'kernelConfig: tradeoff-legacy'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-legacy'\'' for specific use cases.'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-n__ LEGACY_VSYSCALL_EMULATE
}

# WARNING: May be untested .
# WARNING: May not identify drastically performance degrading features from harden-NOTcompatible .
# WARNING: Risk must be evaluated for specific use cases.
# WARNING: Insecure.
# Standalone simulators (eg. flight sim):
# * May have hard real-time frame latency limits within 10% of the fastest avaialble from a commercially avaialble CPU.
# * May be severely single-thread CPU constrained.
# * May have real-time workloads exactly matching those suffering half performance due to security mitigations.
# * May not require real-time security mitigations.
# Disabling hardening may as much as double performance for some workloads.
# https://www.phoronix.com/scan.php?page=article&item=linux-retpoline-benchmarks&num=2
# https://www.phoronix.com/scan.php?page=article&item=linux-416early-spectremelt&num=4
_kernelConfig_require-tradeoff-perform() {
	_messagePlain_nominal 'kernelConfig: tradeoff-perform'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-perform'\'' for specific use cases.'
	export kernelConfig_file="$1"

	_kernelConfig__bad-n__ CONFIG_RETPOLINE
	_kernelConfig__bad-n__ CONFIG_PAGE_TABLE_ISOLATION
	
	# May have been removed from upstream.
	#_kernelConfig__bad-n__ CONFIG_X86_SMAP
	
	_kernelConfig_warn-n__ CONFIG_X86_INTEL_TSX_MODE_OFF
	_kernelConfig_warn-n__ CONFIG_X86_INTEL_TSX_MODE_AUTO
	_kernelConfig__bad-y__ CONFIG_X86_INTEL_TSX_MODE_ON
	
	
	_kernelConfig__bad-n__ CONFIG_SLAB_FREELIST_HARDENED
	
	# Uncertain.
	_kernelConfig__bad-__n CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
	
	
	_kernelConfig__bad-__n CONFIG_RANDOMIZE_BASE
	_kernelConfig__bad-__n CONFIG_RANDOMIZE_MEMORY


	# Special.
	#_kernelConfig_warn-n__ CONFIG_HAVE_INTEL_TXT
	_kernelConfig_warn-n__ CONFIG_INTEL_TXT
	#_kernelConfig_warn-n__ CONFIG_IOMMU_DMA
	#_kernelConfig_warn-n__ CONFIG_INTEL_IOMMU
}

# May become increasing tolerable and preferable for the vast majority of use cases.
# WARNING: Risk must be evaluated for specific use cases.
# WARNING: May BREAK some high-performance real-time applicatons (eg. flight sim, VR, AR).
# Standalone simulators (eg. flight sim):
# * May have hard real-time frame latency limits within 10% of the fastest avaialble from a commercially avaialble CPU.
# * May be severely single-thread CPU constrained.
# * May have real-time workloads exactly matching those suffering half performance due to security mitigations.
# * May not (or may) require real-time security mitigations.
# Disabling hardening may as much as double performance for some workloads.
# https://www.phoronix.com/scan.php?page=article&item=linux-retpoline-benchmarks&num=2
# https://www.phoronix.com/scan.php?page=article&item=linux-416early-spectremelt&num=4
# DANGER: Hardware performance is getting better, while software security issues are getting worse. Think of faster computer processors as security hardware.
_kernelConfig_require-tradeoff-harden() {
	_messagePlain_nominal 'kernelConfig: tradeoff-harden'
	_messagePlain_request 'Carefully evaluate '\''tradeoff-harden'\'' for specific use cases.'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CPU_MITIGATIONS
	_kernelConfig__bad-y__ MITIGATION_PAGE_TABLE_ISOLATION
	_kernelConfig__bad-y__ MITIGATION_RETPOLINE
	_kernelConfig__bad-y__ MITIGATION_RETHUNK
	_kernelConfig__bad-y__ MITIGATION_UNRET_ENTRY
	_kernelConfig__bad-y__ MITIGATION_CALL_DEPTH_TRACKING
	_kernelConfig__bad-y__ MITIGATION_IBPB_ENTRY
	_kernelConfig__bad-y__ MITIGATION_IBRS_ENTRY
	_kernelConfig__bad-y__ MITIGATION_SRSO
	_kernelConfig__bad-y__ MITIGATION_GDS
	_kernelConfig__bad-y__ MITIGATION_RFDS
	_kernelConfig__bad-y__ MITIGATION_SPECTRE_BHI
	_kernelConfig__bad-y__ MITIGATION_MDS
	_kernelConfig__bad-y__ MITIGATION_TAA
	_kernelConfig__bad-y__ MITIGATION_MMIO_STALE_DATA
	_kernelConfig__bad-y__ MITIGATION_L1TF
	_kernelConfig__bad-y__ MITIGATION_RETBLEED
	_kernelConfig__bad-y__ MITIGATION_SPECTRE_V1
	_kernelConfig__bad-y__ MITIGATION_SPECTRE_V2
	_kernelConfig__bad-y__ MITIGATION_SRBDS
	_kernelConfig__bad-y__ MITIGATION_SSB

	_kernelConfig__bad-y__ CPU_SRSO

	_kernelConfig__bad-y__ CONFIG_RETPOLINE
	_kernelConfig__bad-y__ CONFIG_PAGE_TABLE_ISOLATION
	
	_kernelConfig__bad-y__ CONFIG_RETHUNK
	_kernelConfig__bad-y__ CONFIG_CPU_UNRET_ENTRY
	_kernelConfig__bad-y__ CONFIG_CPU_IBPB_ENTRY
	_kernelConfig__bad-y__ CONFIG_CPU_IBRS_ENTRY
	_kernelConfig__bad-y__ CONFIG_SLS
	
	# May have been removed from upstream.
	#_kernelConfig__bad-y__ CONFIG_X86_SMAP
	
	_kernelConfig_warn-n__ CONFIG_X86_INTEL_TSX_MODE_ON
	_kernelConfig_warn-n__ CONFIG_X86_INTEL_TSX_MODE_AUTO
	_kernelConfig__bad-y__ CONFIG_X86_INTEL_TSX_MODE_OFF
	
	
	_kernelConfig_warn-y__ CONFIG_SLAB_FREELIST_HARDENED
	
	
	_kernelConfig__bad-y__ CONFIG_RANDOMIZE_BASE
	_kernelConfig__bad-y__ CONFIG_RANDOMIZE_MEMORY
	
	
	
	
	
	
	# Special.
	# VM guest should be tested.

	# https://wiki.gentoo.org/wiki/Trusted_Boot
	_kernelConfig__bad-y__ CONFIG_HAVE_INTEL_TXT
	_kernelConfig__bad-y__ CONFIG_INTEL_TXT
	_kernelConfig__bad-y__ CONFIG_IOMMU_DMA
	_kernelConfig__bad-y__ CONFIG_INTEL_IOMMU


	# https://www.qemu.org/docs/master/system/i386/sgx.html
	#grep sgx /proc/cpuinfo
	#dmesg | grep sgx
	# Apparently normal: ' sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback to the NUMA node 0. '

	# https://www.qemu.org/docs/master/system/i386/sgx.html
	#qemuArgs+=(-cpu host,+sgx-provisionkey -machine accel=kvm -object memory-backend-epc,id=mem1,size=64M,prealloc=on -M sgx-epc.0.memdev=mem1,sgx-epc.0.node=0 )
	#qemuArgs+=(-cpu host,-sgx-provisionkey,-sgx-tokenkey)

	_kernelConfig__bad-y__ CONFIG_X86_SGX
	_kernelConfig__bad-y__ CONFIG_X86_SGX_kVM
	_kernelConfig__bad-y__ CONFIG_INTEL_TDX_GUEST
	_kernelConfig__bad-y__ TDX_GUEST_DRIVER


	# https://libvirt.org/kbase/launch_security_sev.html
	#cat /sys/module/kvm_amd/parameters/sev
	#dmesg | grep -i sev

	# https://www.qemu.org/docs/master/system/i386/amd-memory-encryption.html
	#qemuArgs+=(-machine accel=kvm,confidential-guest-support=sev0 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1 )
	# #,policy=0x5


	# https://libvirt.org/kbase/launch_security_sev.html
	_kernelConfig__bad-y__ CONFIG_KVM_AMD_SEV
	_kernelConfig__bad-y__ AMD_MEM_ENCRYPT
	_kernelConfig__bad-y__ CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT

	_kernelConfig__bad-y__ KVM_SMM


	_kernelConfig__bad-y__ RANDOM_KMALLOC_CACHES
}
_kernelConfig_require-tradeoff-harden-compatible() {
	
	
	# https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings#sysctls
	
	# Worth considering whether indeed 'NOTcompatible' or actually usable as 'harden' .
	# Nevertheless, 'KASAN' is probably most important, and only reasonably efficient on kernel 6.6+, while only kernel 6.1-lts may be itself still 'compatible' (ie. not panicing on 'systemctl stop sddm') as of 2023-12-26 .
	
	# ###
	
	#x bad: not:    -1: CONFIG_PANIC_TIMEOUT 
	
	# bad: not:     Y: CONFIG_DEBUG_CREDENTIALS 
	#+ bad: not:     Y: CONFIG_DEBUG_NOTIFIERS 
	# bad: not:     Y: CONFIG_DEBUG_SG 
	#x bad: not:     Y: CONFIG_DEBUG_VIRTUAL 
	
	#+ bad: not:     Y: CONFIG_INIT_ON_FREE_DEFAULT_ON 
	#+ bad: not:     Y: CONFIG_ZERO_CALL_USED_REGS 
	
	# https://blogs.oracle.com/linux/post/improving-application-security-with-undefinedbehaviorsanitizer-ubsan-and-gcc
	#  'Adding UBSan instrumentation slows down programs by around 2 to 3x, which is a small price to pay for increased security.'
	#x bad: not:     Y: CONFIG_UBSAN 
	#x bad: not:     Y: CONFIG_UBSAN_TRAP 
	#x bad: not:     Y: CONFIG_UBSAN_BOUNDS 
	#x bad: not:     Y: CONFIG_UBSAN_SANITIZE_ALL 
	#x bad: not:     Y: CONFIG_UBSAN_LOCAL_BOUNDS 
	
	#+ bad: not:     N: CONFIG_DEVMEM 
	
	#+_kernelConfig__bad-n__ CONFIG_DEVPORT
	
	#+ bad: not:     N: CONFIG_PROC_KCORE 
	
	#+_kernelConfig__bad-n__ CONFIG_PROC_VMCORE
	
	#+ bad: not:     N: CONFIG_LEGACY_TIOCSTI 
	
	#+ bad: not:     N: CONFIG_LDISC_AUTOLOAD 
	
	#+ bad: not:     N: CONFIG_SECURITY_SELINUX_DEVELOP
	
	# ###
	
	#if ! cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "CONFIG_PANIC_TIMEOUT"'\=-1' > /dev/null 2>&1
	#then
		#_messagePlain_bad 'bad: not:    -1: '"CONFIG_PANIC_TIMEOUT"
		#export kernelConfig_bad='true'
	#fi
	
	_kernelConfig__bad-y__ CONFIG_BUG
	_kernelConfig__bad-y__ CONFIG_BUG_ON_DATA_CORRUPTION
	
	_kernelConfig__bad-y__ CONFIG_DEBUG_NOTIFIERS
	
	_kernelConfig__bad-y__ CONFIG_INIT_ON_FREE_DEFAULT_ON
	_kernelConfig__bad-y__ CONFIG_ZERO_CALL_USED_REGS
	
	_kernelConfig__bad-n__ CONFIG_DEVMEM
	_kernelConfig__bad-n__ CONFIG_DEVPORT
	
	_kernelConfig__bad-n__ CONFIG_PROC_KCORE
	_kernelConfig__bad-n__ CONFIG_PROC_VMCORE
	
	_kernelConfig__bad-n__ CONFIG_LEGACY_TIOCSTI
	_kernelConfig__bad-n__ CONFIG_LDISC_AUTOLOAD
	
	_kernelConfig__bad-n__ CONFIG_SECURITY_SELINUX_DEVELOP
	
	
	
	# WARNING: KFENCE is of DUBIOUS usefulness. Enable KASAN instead if possible!
	# https://thomasw.dev/post/kfence/
	#  'In theory, a buffer overflow exploit executed on a KFENCE object might be detected and miss its intended overwrite target as the vulnerable object is located in the KFENCE pool. This is in no way a defense - an attacker can trivially bypass KFENCE by simply executing a no-op allocation or depleting the KFENCE object pool first. Memory exploits often already require precisely setting up the heap to be successful, so this is a very minor obstacle to take care of.'
	# https://openbenchmarking.org/result/2104197-PTS-5900XAMD52
	#  Apparently negligible difference between 100ms and 500ms sample rates. Maybe ~7% .
	# https://www.kernel.org/doc/html/v5.15/dev-tools/kfence.html
	
	#CONFIG_KFENCE=y
	#CONFIG_KFENCE_SAMPLE_INTERVAL=39
	
	#CONFIG_KFENCE_NUM_OBJECTS=639
	
	#CONFIG_KFENCE_DEFERRABLE=y
	
	_kernelConfig__bad-y__ CONFIG_KFENCE
	if ! cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "CONFIG_KFENCE_SAMPLE_INTERVAL"'\=39' > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: not:    39: '"CONFIG_KFENCE_SAMPLE_INTERVAL"
		export kernelConfig_bad='true'
	fi
	if ! cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "CONFIG_KFENCE_NUM_OBJECTS"'\=639' > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: not:    639: '"CONFIG_KFENCE_NUM_OBJECTS"
		export kernelConfig_bad='true'
	fi
	
	#_kernelConfig_warn-any CONFIG_KFENCE_DEFERRABLE
	_kernelConfig_warn-y__ CONFIG_KFENCE_DEFERRABLE


	# DUBIOUS . Seems to require a userspace service setting scheduling attributes for processes, and not supported by default.
	# WARNING: Definitely much better to disable SMT .
	#_kernelConfig__bad-y__ CONFIG_SCHED_CORE
}

# WARNING: ATTENTION: Before moving to tradeoff-harden (compatible), ensure vboxdrv, vboxadd, nvidia, nvidia legacy, kernel modules can be loaded without issues, and also ensure significant performance penalty configuration options are oppositely documented in the tradeoff-perform function .
# WARNING: Disables out-of-tree modules . VirtualBox and NVIDIA drivers WILL NOT be permitted to load .
# NOTICE: The more severe performance costs of KASAN, UBSAN, etc, will, as kernel processing increasingly becomes still more of a minority of the work done by faster CPUs, and as more efficient kernels (ie. 6.6+) become more useful with fewer regressions, be migrated to 'harden' (ie. treated as 'compatible').
_kernelConfig_require-tradeoff-harden-NOTcompatible() {
	# https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings#sysctls
	
	
	# Apparently these are some typical differences from a stock distribution supplied kernel configuration .
	
	# ###
	
	# bad: not:     Y: CONFIG_PANIC_ON_OOPS 
	# bad: not:    -1: CONFIG_PANIC_TIMEOUT 
	# bad: not:     Y: CONFIG_KASAN 
	# bad: not:     Y: CONFIG_KASAN_INLINE 
	# bad: not:     Y: CONFIG_KASAN_VMALLOC 
	# bad: not:     Y: CONFIG_DEBUG_CREDENTIALS 
	# bad: not:     Y: CONFIG_DEBUG_NOTIFIERS 
	# bad: not:     Y: CONFIG_DEBUG_SG 
	# bad: not:     Y: CONFIG_DEBUG_VIRTUAL 
	# bad: not:     Y: CONFIG_INIT_ON_FREE_DEFAULT_ON 
	# bad: not:     Y: CONFIG_ZERO_CALL_USED_REGS 
	# bad: not:     Y: CONFIG_UBSAN 
	# bad: not:     Y: CONFIG_UBSAN_TRAP 
	# bad: not:     Y: CONFIG_UBSAN_BOUNDS 
	# bad: not:     Y: CONFIG_UBSAN_SANITIZE_ALL 
	# bad: not:     Y: CONFIG_UBSAN_LOCAL_BOUNDS 
	# bad: not:     N: CONFIG_DEVMEM 
	# bad: not:     Y: CONFIG_CFI_CLANG 
	# bad: not:     N: CONFIG_PROC_KCORE 
	# bad: not:     N: CONFIG_LEGACY_TIOCSTI 
	# bad: not:     Y: CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY 
	# bad: not:     N: CONFIG_LDISC_AUTOLOAD 
	# bad: not:     Y: CONFIG_GCC_PLUGINS 
	# bad: not:     Y: CONFIG_GCC_PLUGIN_LATENT_ENTROPY 
	# bad: not:     Y: CONFIG_GCC_PLUGIN_STRUCTLEAK 
	# bad: not:     Y: CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL 
	# bad: not:     Y: CONFIG_GCC_PLUGIN_STACKLEAK 
	# bad: not:     Y: CONFIG_GCC_PLUGIN_RANDSTRUCT 
	# bad: not:     N: CONFIG_SECURITY_SELINUX_DEVELOP
	
	# ###
	
	
	
	_kernelConfig__bad-y__ CONFIG_BUG
	_kernelConfig__bad-y__ CONFIG_BUG_ON_DATA_CORRUPTION
	
	_kernelConfig__bad-y__ CONFIG_PANIC_ON_OOPS
	if ! cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "CONFIG_PANIC_TIMEOUT"'\=-1' > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: not:    -1: '"CONFIG_PANIC_TIMEOUT"
		export kernelConfig_bad='true'
	fi
	
	
	
	_kernelConfig__bad-y__ CONFIG_KASAN
	_kernelConfig__bad-y__ CONFIG_KASAN_INLINE
	_kernelConfig__bad-y__ CONFIG_KASAN_VMALLOC
	
	
	# DUBIOUS. KASAN should catch everything KFENCE does, but apparently CONFIG_KASAN_VMALLOCKFENCE may rarely catch errors.
	#_kernelConfig__bad-y__ CONFIG_KFENCE
	
	
	
	
	_kernelConfig__bad-y__ CONFIG_SCHED_STACK_END_CHECK
	_kernelConfig__bad-y__ CONFIG_DEBUG_CREDENTIALS
	_kernelConfig__bad-y__ CONFIG_DEBUG_NOTIFIERS
	_kernelConfig__bad-y__ CONFIG_DEBUG_LIST
	_kernelConfig__bad-y__ CONFIG_DEBUG_SG
	_kernelConfig__bad-y__ CONFIG_DEBUG_VIRTUAL
	
	
	
	_kernelConfig__bad-y__ CONFIG_SLUB_DEBUG
	
	
	_kernelConfig__bad-y__ CONFIG_SLAB_FREELIST_RANDOM
	_kernelConfig__bad-y__ CONFIG_SLAB_FREELIST_HARDENED
	_kernelConfig__bad-y__ CONFIG_SHUFFLE_PAGE_ALLOCATOR
	
	
	_kernelConfig__bad-y__ CONFIG_INIT_ON_ALLOC_DEFAULT_ON
	_kernelConfig__bad-y__ CONFIG_INIT_ON_FREE_DEFAULT_ON
	
	_kernelConfig__bad-y__ CONFIG_ZERO_CALL_USED_REGS
	
	
	_kernelConfig__bad-y__ CONFIG_HARDENED_USERCOPY
	_kernelConfig__bad-n__ CONFIG_HARDENED_USERCOPY_FALLBACK
	_kernelConfig__bad-n__ CONFIG_HARDENED_USERCOPY_PAGESPAN
	
	
	_kernelConfig__bad-y__ CONFIG_UBSAN
	_kernelConfig__bad-y__ CONFIG_UBSAN_TRAP
	_kernelConfig__bad-y__ CONFIG_UBSAN_BOUNDS
	_kernelConfig__bad-y__ CONFIG_UBSAN_SANITIZE_ALL
	_kernelConfig__bad-n__ CONFIG_UBSAN_SHIFT
	_kernelConfig__bad-n__ CONFIG_UBSAN_DIV_ZERO
	_kernelConfig__bad-n__ CONFIG_UBSAN_UNREACHABLE
	_kernelConfig__bad-n__ CONFIG_UBSAN_BOOL
	_kernelConfig__bad-n__ CONFIG_UBSAN_ENUM
	_kernelConfig__bad-n__ CONFIG_UBSAN_ALIGNMENT
	# This is only available on Clang builds, and is likely already enabled if CONFIG_UBSAN_BOUNDS=y is set:
	_kernelConfig__bad-y__ CONFIG_UBSAN_LOCAL_BOUNDS
	
	
	
	_kernelConfig__bad-n__ CONFIG_DEVMEM
	#_kernelConfig__bad-y__ CONFIG_STRICT_DEVMEM
	#_kernelConfig__bad-y__ CONFIG_IO_STRICT_DEVMEM
	
	_kernelConfig__bad-n__ CONFIG_DEVPORT
	
	
	_kernelConfig__bad-y__ CONFIG_CFI_CLANG
	_kernelConfig__bad-n__ CONFIG_CFI_PERMISSIVE
	
	
	
	_kernelConfig__bad-y__ CONFIG_STACKPROTECTOR
	_kernelConfig__bad-y__ CONFIG_STACKPROTECTOR_STRONG
	
	
	_kernelConfig__bad-n__ CONFIG_DEVKMEM
	
	_kernelConfig__bad-n__ CONFIG_COMPAT_BRK
	_kernelConfig__bad-n__ CONFIG_PROC_KCORE
	_kernelConfig__bad-n__ CONFIG_ACPI_CUSTOM_METHOD
	
	_kernelConfig__bad-n__ CONFIG_PROC_VMCORE
	
	_kernelConfig__bad-n__ CONFIG_LEGACY_TIOCSTI
	
	
	
	_kernelConfig__bad-y__ CONFIG_SECURITY_LOCKDOWN_LSM
	_kernelConfig__bad-y__ CONFIG_SECURITY_LOCKDOWN_LSM_EARLY
	_kernelConfig__bad-y__ CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY
	
	
	
	_kernelConfig__bad-y__ CONFIG_SECURITY_DMESG_RESTRICT
	
	_kernelConfig__bad-y__ CONFIG_VMAP_STACK
	
	
	_kernelConfig__bad-n__ CONFIG_LDISC_AUTOLOAD
	
	
	
	# Enable GCC Plugins
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGINS

	# Gather additional entropy at boot time for systems that may not have appropriate entropy sources.
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGIN_LATENT_ENTROPY

	# Force all structures to be initialized before they are passed to other functions.
	# When building with GCC:
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGIN_STRUCTLEAK
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL

	# Wipe stack contents on syscall exit (reduces stale data lifetime in stack)
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGIN_STACKLEAK
	_kernelConfig__bad-n__ CONFIG_STACKLEAK_METRICS
	_kernelConfig__bad-n__ CONFIG_STACKLEAK_RUNTIME_DISABLE

	# Randomize the layout of system structures. This may have dramatic performance impact, so
	# use with caution or also use CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE=y
	_kernelConfig__bad-y__ CONFIG_GCC_PLUGIN_RANDSTRUCT
	_kernelConfig__bad-n__ CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
	
	
	
	
	_kernelConfig__bad-y__ CONFIG_SECURITY
	_kernelConfig__bad-y__ CONFIG_SECURITY_YAMA
	
	_kernelConfig__bad-y__ CONFIG_X86_64
	
	
	_kernelConfig__bad-n__ CONFIG_SECURITY_SELINUX_BOOTPARAM
	_kernelConfig__bad-n__ CONFIG_SECURITY_SELINUX_DEVELOP
	_kernelConfig__bad-n__ CONFIG_SECURITY_WRITABLE_HOOKS
	
	
	
	_kernelConfig_warn-n__ CONFIG_KEXEC
	_kernelConfig_warn-n__ CONFIG_HIBERNATION
	
	
	
	_kernelConfig__bad-y__ CONFIG_RESET_ATTACK_MITIGATION
	
	
	_kernelConfig_warn-y__ CONFIG_EFI_DISABLE_PCI_DMA


	# ATTENTION: In practice, the 'gather_data_sampling=force' command line parameter has been available, through optional  "$globalVirtFS"/etc/default/grub.d/01_hardening_ubdist.cfg  .
	_kernelConfig__bad-y__ CONFIG_GDS_FORCE_MITIGATION
	
	
	
	# WARNING: CAUTION: Now obviously this is really incompatible. Do NOT move this to any other function.
	_kernelConfig_warn-y__ CONFIG_MODULE_SIG_FORCE

	# WARNING: May be untested. Kernel default apparently 'Y'.
	_kernelConfig_warn-y__ MODULE_SIG_ALL
}

# ATTENTION: Override with 'ops.sh' or similar.
_kernelConfig_require-tradeoff() {
	_kernelConfig_require-tradeoff-legacy "$@"
	
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	
	if [[ "$kernelConfig_tradeoff_perform" == 'true' ]]
	then
		_kernelConfig_require-tradeoff-perform "$@"
	else
		_kernelConfig_require-tradeoff-harden "$@"
	fi
	
	[[ "$kernelConfig_tradeoff_compatible" == "" ]] && [[ "$kernelConfig_tradeoff_perform" == 'true' ]] && export kernelConfig_tradeoff_compatible='true'
	[[ "$kernelConfig_tradeoff_compatible" == "" ]] && export kernelConfig_tradeoff_compatible='false'
	
	if [[ "$kernelConfig_tradeoff_compatible" != 'true' ]]
	then
		_kernelConfig_require-tradeoff-harden-NOTcompatible "$@"
	else
		_kernelConfig_require-tradeoff-harden-compatible "$@"
	fi
	
	return
}

# Based on kernel config documentation and Debian default config.
_kernelConfig_require-virtualization-accessory() {
	_messagePlain_nominal 'kernelConfig: virtualization-accessory'
	export kernelConfig_file="$1"
	
	_kernelConfig_warn-y_m CONFIG_KVM
	_kernelConfig_warn-y_m CONFIG_KVM_INTEL
	_kernelConfig_warn-y_m CONFIG_KVM_AMD
	
	_kernelConfig_warn-y__ CONFIG_KVM_AMD_SEV
	
	_kernelConfig_warn-y_m CONFIG_VHOST_NET
	_kernelConfig_warn-y_m CONFIG_VHOST_SCSI
	_kernelConfig_warn-y_m CONFIG_VHOST_VSOCK
	
	_kernelConfig__bad-y_m DRM_VMWGFX
	
	_kernelConfig__bad-n__ CONFIG_VBOXGUEST
	_kernelConfig__bad-n__ CONFIG_DRM_VBOXVIDEO
	
	_kernelConfig_warn-y__ VIRTIO_MENU
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI_LEGACY
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI_LIB
	_kernelConfig_warn-y__ CONFIG_VIRTIO_PCI_LIB_LEGACY
	_kernelConfig__bad-y_m CONFIG_VIRTIO_BALLOON
	_kernelConfig__bad-y_m CONFIG_VIRTIO_INPUT
	_kernelConfig__bad-y_m CONFIG_VIRTIO_MMIO
	_kernelConfig_warn-y__ CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES
	
	_kernelConfig_warn-y_m CONFIG_DRM_VIRTIO_GPU
	
	# Uncertain. Apparently new feature.
	_kernelConfig_warn-y_m CONFIG_VIRTIO_FS
	
	_kernelConfig_warn-y_m CONFIG_HYPERV
	_kernelConfig_warn-y_m CONFIG_HYPERV_UTILS
	_kernelConfig_warn-y_m CONFIG_HYPERV_BALLOON
	
	_kernelConfig_warn-y__ CONFIG_XEN_BALLOON
	_kernelConfig_warn-y__ CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
	_kernelConfig_warn-y__ CONFIG_XEN_SCRUB_PAGES_DEFAULT
	_kernelConfig__bad-y_m CONFIG_XEN_DEV_EVTCHN
	_kernelConfig_warn-y__ CONFIG_XEN_BACKEND
	_kernelConfig__bad-y_m CONFIG_XENFS
	_kernelConfig_warn-y__ CONFIG_XEN_COMPAT_XENFS
	_kernelConfig_warn-y__ CONFIG_XEN_SYS_HYPERVISOR
	_kernelConfig__bad-y_m CONFIG_XEN_SYS_HYPERVISOR
	_kernelConfig__bad-y_m CONFIG_XEN_GRANT_DEV_ALLOC
	_kernelConfig__bad-y_m CONFIG_XEN_PCIDEV_BACKEND
	_kernelConfig__bad-y_m CONFIG_XEN_SCSI_BACKEND
	_kernelConfig__bad-y_m CONFIG_XEN_ACPI_PROCESSOR
	_kernelConfig_warn-y__ CONFIG_XEN_MCE_LOG
	_kernelConfig_warn-y__ CONFIG_XEN_SYMS
	
	_kernelConfig_warn-y__ CONFIG_DRM_XEN
	
	# Uncertain.
	#_kernelConfig_warn-n__ CONFIG_XEN_SELFBALLOONING
	#_kernelConfig_warn-n__ CONFIG_IOMMU_DEFAULT_PASSTHROUGH
	#_kernelConfig_warn-n__ CONFIG_INTEL_IOMMU_DEFAULT_ON


	# TODO: Evaluate.
	_kernelConfig_warn-y__ KVM_HYPERV
}

# https://wiki.gentoo.org/wiki/VirtualBox
_kernelConfig_require-virtualbox() {
	_messagePlain_nominal 'kernelConfig: virtualbox'
	export kernelConfig_file="$1"
	
	#_kernelConfig__bad-y__ CONFIG_X86_SYSFB
	_kernelConfig__bad-y__ CONFIG_SYSFB
	
	_kernelConfig__bad-y__ CONFIG_ATA
	_kernelConfig__bad-y__ CONFIG_SATA_AHCI
	_kernelConfig__bad-y__ CONFIG_ATA_SFF
	_kernelConfig__bad-y__ CONFIG_ATA_BMDMA
	_kernelConfig__bad-y__ CONFIG_ATA_PIIX
	
	_kernelConfig__bad-y__ CONFIG_NETDEVICES
	_kernelConfig__bad-y__ CONFIG_ETHERNET
	_kernelConfig__bad-y__ CONFIG_NET_VENDOR_INTEL
	_kernelConfig__bad-y__ CONFIG_E1000
	
	_kernelConfig__bad-y__ CONFIG_INPUT_KEYBOARD
	_kernelConfig__bad-y__ CONFIG_KEYBOARD_ATKBD
	_kernelConfig__bad-y__ CONFIG_INPUT_MOUSE
	_kernelConfig__bad-y__ CONFIG_MOUSE_PS2
	
	_kernelConfig__bad-y__ CONFIG_DRM
	_kernelConfig__bad-y__ CONFIG_DRM_FBDEV_EMULATION
	_kernelConfig__bad-y__ CONFIG_DRM_VIRTIO_GPU
	
	_kernelConfig__bad-y__ CONFIG_FB
	_kernelConfig__bad-y__ CONFIG_FIRMWARE_EDID
	_kernelConfig__bad-y__ CONFIG_FB_SIMPLE
	
	_kernelConfig__bad-y__ CONFIG_FRAMEBUFFER_CONSOLE
	_kernelConfig__bad-y__ CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
	
	_kernelConfig__bad-y__ CONFIG_SOUND
	_kernelConfig__bad-y__ CONFIG_SND
	_kernelConfig__bad-y__ CONFIG_SND_PCI
	_kernelConfig__bad-y__ CONFIG_SND_INTEL8X0
	
	_kernelConfig__bad-y__ CONFIG_USB
	_kernelConfig__bad-y__ CONFIG_USB_SUPPORT
	_kernelConfig__bad-y__ CONFIG_USB_XHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_EHCI_HCD
}


# https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#Activating_required_options
_kernelConfig_require-boot() {
	_messagePlain_nominal 'kernelConfig: boot'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_FW_LOADER
	#_kernelConfig__bad-y__ CONFIG_FIRMWARE_IN_KERNEL
	
	_kernelConfig__bad-y__ CONFIG_DEVTMPFS
	_kernelConfig__bad-y__ CONFIG_DEVTMPFS_MOUNT
	_kernelConfig__bad-y__ CONFIG_BLK_DEV_SD
	
	
	_kernelConfig__bad-y__ CONFIG_EXT4_FS
	_kernelConfig__bad-y__ CONFIG_EXT4_FS_POSIX_ACL
	_kernelConfig__bad-y__ CONFIG_EXT4_FS_SECURITY
	#_kernelConfig__bad-y__ CONFIG_EXT4_ENCRYPTION
	
	if ! _kernelConfig_warn-y__ CONFIG_EXT4_USE_FOR_EXT2 > /dev/null 2>&1
	then
		_kernelConfig__bad-y__ CONFIG_EXT2_FS
		_kernelConfig__bad-y__ CONFIG_EXT3_FS
		_kernelConfig__bad-y__ CONFIG_EXT3_FS_POSIX_ACL
		_kernelConfig__bad-y__ CONFIG_EXT3_FS_SECURITY
	else
		_kernelConfig_warn-y__ CONFIG_EXT4_USE_FOR_EXT2
	fi
	
	_kernelConfig__bad-y__ CONFIG_BTRFS_FS
	
	_kernelConfig__bad-y__ CONFIG_MSDOS_FS
	_kernelConfig__bad-y__ CONFIG_VFAT_FS
	
	# Precautionary to assure reasonable behavior with any LiveCD/LiveUSB filesystem arrangements that may be used in the future.
	# Module has probably been entirely adequate in the past for LiveCD/LiveUSB as well as mounting such filesystems later.
	_kernelConfig__bad-y__ CONFIG_OVERLAY_FS
	_kernelConfig__bad-y__ CONFIG_ISO9660_FS
	_kernelConfig__bad-y__ CONFIG_UDF_FS
	
	# https://www.kernel.org/doc/html/latest/cdrom/packet-writing.html
	# 'packet support in the block device section'
	# 'pktcdvd driver makes the disc appear as a regular block device with a 2KB block size'
	# Although the module is apparently 'deprecated', it is available with Linux kernel 5.10 , and thus should remain usable at least through ~2026 .
	# https://wiki.archlinux.org/title/Optical_disc_drive
	# Many 'optical discs' apparently can be used directly as block devices by such programs as 'gparted' and 'dd'.
	_kernelConfig__bad-y_m CONFIG_CDROM_PKTCDVD
	
	_kernelConfig__bad-y__ CONFIG_PROC_FS
	_kernelConfig__bad-y__ CONFIG_TMPFS
	
	_kernelConfig__bad-y__ CONFIG_PPP
	_kernelConfig__bad-y__ CONFIG_PPP_ASYNC
	_kernelConfig__bad-y__ CONFIG_PPP_SYNC_TTY
	
	_kernelConfig__bad-y__ CONFIG_SMP
	
	# https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide
	# 'Support for Host-side USB'
	_kernelConfig__bad-y__ CONFIG_USB_SUPPORT
	_kernelConfig__bad-y__ CONFIG_USB_XHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_EHCI_HCD
	_kernelConfig__bad-y__ CONFIG_USB_OHCI_HCD
	
	_kernelConfig__bad-y__ USB_OHCI_HCD_PCI
	
	_kernelConfig__bad-y__ USB_UHCI_HCD
	
	_kernelConfig__bad-y__ CONFIG_HID
	_kernelConfig__bad-y__ CONFIG_HID_GENERIC
	_kernelConfig__bad-y__ CONFIG_HID_BATTERY_STRENGTH
	_kernelConfig__bad-y__ CONFIG_USB_HID
	
	_kernelConfig__bad-y__ CONFIG_PARTITION_ADVANCED
	_kernelConfig__bad-y__ CONFIG_EFI_PARTITION
	
	_kernelConfig__bad-y__ CONFIG_EFI
	_kernelConfig__bad-y__ CONFIG_EFI_STUB
	_kernelConfig__bad-y__ CONFIG_EFI_MIXED
	
	# Seems 'EFI_VARS' has disappeared from recent kernel versions.
	#_kernelConfig__bad-y__ CONFIG_EFI_VARS
	_kernelConfig__bad-y__ CONFIG_EFIVAR_FS
}


_kernelConfig_require-arch-x64() {
	_messagePlain_nominal 'kernelConfig: arch-x64'
	export kernelConfig_file="$1"
	
	# CRITICAL! Expected to accommodate modern CPUs.
	_messagePlain_request 'request: -march=sandybridge -mtune=skylake'
	_messagePlain_request 'export KCFLAGS="-O2 -march=sandybridge -mtune=skylake -pipe"'
	_messagePlain_request 'export KCPPFLAGS="-O2 -march=sandybridge -mtune=skylake -pipe"'
	
	_kernelConfig_warn-n__ CONFIG_GENERIC_CPU
# 	
	_kernelConfig_request MCORE2
	
	_kernelConfig_warn-y__ CONFIG_X86_MCE
	_kernelConfig_warn-y__ CONFIG_X86_MCE_INTEL
	_kernelConfig_warn-y__ CONFIG_X86_MCE_AMD
	
	# Uncertain. May or may not improve performance.
	# Seems missing in newer kernel 'menuconfig' .
	#_kernelConfig_warn-y__ CONFIG_INTEL_RDT
	
	# Maintenance may be easier with this enabled.
	_kernelConfig_warn-y__ CONFIG_EFIVAR_FS
	
	# Presumably mixing entropy may be preferable.
	_kernelConfig__bad-n__ CONFIG_RANDOM_TRUST_CPU
	
	
	# If possible, it may be desirable to check clocksource defaults.
	
	_kernelConfig__bad-y__ X86_TSC
	
	_kernelConfig_warn-y__ HPET
	_kernelConfig_warn-y__ HPET_EMULATE_RTC
	_kernelConfig_warn-y__ HPET_MMAP
	_kernelConfig_warn-y__ HPET_MMAP_DEFAULT
	_kernelConfig_warn-y__ HPET_TIMER
	
	
	_kernelConfig__bad-y__ CONFIG_IA32_EMULATION
	_kernelConfig_warn-n__ IA32_AOUT
	_kernelConfig__bad-y__ CONFIG_X86_X32_ABI
	
	_kernelConfig__bad-y__ CONFIG_BINFMT_ELF
	_kernelConfig__bad-y_m CONFIG_BINFMT_MISC
	
	# May not have been optional under older kernel configurations.
	_kernelConfig__bad-y__ CONFIG_BINFMT_SCRIPT
}

_kernelConfig_require-accessory() {
	_messagePlain_nominal 'kernelConfig: accessory'
	export kernelConfig_file="$1"
	
	# May be critical to 'ss' tool functionality typically expected by Ubiquitous Bash.
	_kernelConfig_warn-y_m CONFIG_PACKET_DIAG
	_kernelConfig_warn-y_m CONFIG_UNIX_DIAG
	_kernelConfig_warn-y_m CONFIG_INET_DIAG
	_kernelConfig_warn-y_m CONFIG_NETLINK_DIAG
	
	# Essential for a wide variety of platforms.
	_kernelConfig_warn-y_m CONFIG_MOUSE_PS2_TRACKPOINT
	
	# Common and useful GPU features.
	_kernelConfig_warn-y_m CONFIG_DRM_RADEON
	_kernelConfig_warn-y_m CONFIG_DRM_AMDGPU
	_kernelConfig_warn-y_m CONFIG_DRM_I915
	_kernelConfig_warn-y_m CONFIG_DRM_NOUVEAU
	
	# Rarely appropriate and reportedly 'dangerous'.
	#_kernelConfig_warn-y_m CONFIG_DRM_VIA
	
	# Uncertain.
	#_kernelConfig_warn-y__ CONFIG_IRQ_REMAP
	
	# TODO: Accessory features which may become interesting.
	#ACPI_HMAT
	#PCIE_BW
	#ACRN_GUEST
	#XILINX SDFEC
}

_kernelConfig_require-build() {
	_messagePlain_nominal 'kernelConfig: build'
	export kernelConfig_file="$1"
	
	# May cause failure if set incorrectly.
	if ! cat "$kernelConfig_file" | grep 'CONFIG_SYSTEM_TRUSTED_KEYS\=\"\"' > /dev/null 2>&1 && ! cat "$kernelConfig_file" | grep -v 'CONFIG_SYSTEM_TRUSTED_KEYS' > /dev/null 2>&1
	then
		#_messagePlain_bad 'bad: not:    Y: '"$1"
		 _messagePlain_bad 'bad: not:    _: 'CONFIG_SYSTEM_TRUSTED_KEYS
	fi
	
	# May cause failure if set incorrectly.
	#! _kernelConfig__bad-n__ CONFIG_SYSTEM_TRUSTED_KEYRING
	#! _kernelConfig__bad-n__ CONFIG_SYSTEM_TRUSTED_KEYRING && _messagePlain_request ' request: ''scripts/config --set-str SYSTEM_TRUSTED_KEYS ""'
	
	
	# May require a version of 'pahole' not available from Debian Stable.
	_kernelConfig__bad-n__ CONFIG_DEBUG_INFO_BTF
	
	#_messagePlain_request ' request: ''scripts/config --set-str SYSTEM_TRUSTED_KEYS ""'
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
# ATTENTION: Dependency of '_kernelConfig_require-latency' .
_kernelConfig_require-latency_frequency() {
	# High HZ rate (ie. HZ 1000) may be preferable for machines directly rendering simulator/VR graphics.
	# Theoretically graphics VSYNC might prefer HZ 300 or similar, as a multiple of common graphics refresh rates.
	# 25,~29.97,30,60=300 60,72=360 60,75=300 60,80=240 32,36,64,72=576
	# Theoretically, a setting of 250 may be beneficial for virtualization where the host kernel may be 1000 .
	# Typically values: 250,300,1000 .
	# https://passthroughpo.st/config_hz-how-does-it-affect-kvm/
	# https://github.com/vmprof/vmprof-python/issues/163
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	
	
	if ! cat "$kernelConfig_file" | grep 'HZ='"$kernelConfig_frequency" > /dev/null 2>&1
	then
		#_messagePlain_bad  'bad: not:     Y: '"$1"
		#_messagePlain_warn 'warn: not:    Y: '"$1"
		 _messagePlain_bad 'bad: not:   '"$kernelConfig_frequency"': 'HZ
	fi
	_kernelConfig__bad-y__ HZ_"$kernelConfig_frequency"
}

_kernelConfig_require-latency() {
	_messagePlain_nominal 'kernelConfig: latency'
	export kernelConfig_file="$1"
	
	# Uncertain. Default off per Debian config.
	_kernelConfig_warn-n__ CONFIG_X86_GENERIC
	
	# CRITICAL!
	# https://www.reddit.com/r/linux_gaming/comments/mp2eqv/if_you_dont_like_schedutil_and_what_its_doing/
	#  'Ondemand is similar'
	_kernelConfig_warn-y__ CPU_FREQ_DEFAULT_GOV_ONDEMAND
	_kernelConfig__bad-y__ CONFIG_CPU_FREQ_GOV_ONDEMAND
	_kernelConfig__bad-y__ CPU_FREQ_DEFAULT_GOV_SCHEDUTIL
	_kernelConfig__bad-y__ CONFIG_CPU_FREQ_GOV_SCHEDUTIL

	# WARNING: May be untested.
	#X86_AMD_PSTATE_DEFAULT_MODE
	if ! cat "$kernelConfig_file" | _kernelConfig_reject-comments | grep "X86_AMD_PSTATE_DEFAULT_MODE"'\=3' > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: not:      3: '"X86_AMD_PSTATE_DEFAULT_MODE"
		export kernelConfig_bad='true'
	fi
	
	# CRITICAL!
	# CONFIG_PREEMPT is significantly more stable and compatible with third party (eg. VirtualBox) modules.
	# CONFIG_PREEMPT_RT is significantly less likely to incurr noticeable worst-case latency.
	# Lack of both CONFIG_PREEMPT and CONFIG_PREEMPT_RT may incurr noticeable worst-case latency.
	_kernelConfig_request CONFIG_PREEMPT
	_kernelConfig_request CONFIG_PREEMPT_RT
	if ! _kernelConfig__bad-y__ CONFIG_PREEMPT_RT > /dev/null 2>&1 && ! _kernelConfig__bad-y__ CONFIG_PREEMPT > /dev/null 2>&1 
	then
		_kernelConfig__bad-y__ CONFIG_PREEMPT
		_kernelConfig__bad-y__ CONFIG_PREEMPT_RT
	fi
	
	_kernelConfig_require-latency_frequency "$@"
	
	# Dynamic/Tickless kernel *might* be the cause of irregular display updates on some platforms.
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	if [[ "$kernelConfig_tickless" == 'true' ]]
	then
		#_kernelConfig__bad-n__ CONFIG_HZ_PERIODIC
		#_kernelConfig__bad-y__ CONFIG_NO_HZ
		#_kernelConfig__bad-y__ CONFIG_NO_HZ_COMMON
		#_kernelConfig__bad-y__ CONFIG_NO_HZ_FULL
		_kernelConfig__bad-y__ CONFIG_NO_HZ_IDLE
		#_kernelConfig__bad-y__ CONFIG_RCU_FAST_NO_HZ
	else
		_kernelConfig__bad-y__ CONFIG_HZ_PERIODIC
		_kernelConfig__bad-n__ CONFIG_NO_HZ
		_kernelConfig__bad-n__ CONFIG_NO_HZ_COMMON
		_kernelConfig__bad-n__ CONFIG_NO_HZ_FULL
		_kernelConfig__bad-n__ CONFIG_NO_HZ_IDLE
		_kernelConfig__bad-n__ CONFIG_RCU_FAST_NO_HZ
		
		_kernelConfig__bad-y__ CPU_IDLE_GOV_MENU
	fi
	
	# Essential.
	_kernelConfig__bad-y__ CONFIG_LATENCYTOP
	
	
	# CRITICAL!
	_kernelConfig__bad-y__ CONFIG_CGROUP_SCHED
	_kernelConfig__bad-y__ FAIR_GROUP_SCHED
	_kernelConfig__bad-y__ CONFIG_CFS_BANDWIDTH
	
	# CRITICAL!
	# Expected to protect single-thread interactive applications from competing multi-thread workloads.
	_kernelConfig__bad-y__ CONFIG_SCHED_AUTOGROUP
	
	
	
	
	# Newer information suggests BFQ may have worst case latency issues.
	# https://bugzilla.redhat.com/show_bug.cgi?id=1851783
	## CRITICAL!
	## Default cannot be set currently.
	#_messagePlain_request 'request: Set '\''bfq'\'' as default IO scheduler (strongly recommended).'
	##_kernelConfig__bad-y__ DEFAULT_IOSCHED
	##_kernelConfig__bad-y__ DEFAULT_BFQ
	
	## CRITICAL!
	## Expected to protect interactive applications from background IO.
	## https://www.youtube.com/watch?v=ANfqNiJVoVE
	#_kernelConfig__bad-y__ CONFIG_IOSCHED_BFQ
	#_kernelConfig__bad-y__ CONFIG_BFQ_GROUP_IOSCHED
	
	
	
	
	
	# Uncertain.
	# https://forum.manjaro.org/t/please-enable-writeback-throttling-by-default-linux-4-10/18135/22
	#_kernelConfig__bad-y__ BLK_WBT
	#_kernelConfig__bad-y__ BLK_WBT_MQ
	#_kernelConfig__bad-y__ BLK_WBT_SQ
	
	
	# https://lwn.net/Articles/789304/
	_kernelConfig__bad-y__ CONFIG_SPARSEMEM
	
	
	_kernelConfig__bad-n__ CONFIG_REFCOUNT_FULL
	_kernelConfig__bad-n__ CONFIG_DEBUG_NOTIFIERS
	_kernelConfig_warn-n__ CONFIG_FTRACE
	
	_kernelConfig__bad-y__ CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
	
	# CRITICAL!
	# Lightweight kernel compression theoretically may significantly accelerate startup from slow disks.
	_kernelConfig__bad-y__ CONFIG_KERNEL_LZ4

	# TODO
	#PCP_BATCH_SCALE_MAX
	
}

_kernelConfig_require-memory() {
	_messagePlain_nominal 'kernelConfig: memory'
	export kernelConfig_file="$1"
	
	# Uncertain.
	# https://fa.linux.kernel.narkive.com/CNnVwDlb/hack-bench-regression-with-config-slub-cpu-partial-disabled-info-only
	_kernelConfig_warn-y__ CONFIG_SLUB_CPU_PARTIAL
	
	# Uncertain.
	_kernelConfig_warn-y__ CONFIG_TRANSPARENT_HUGEPAGE
	#_kernelConfig_warn-y__ CONFIG_CLEANCACHE
	_kernelConfig_warn-y__ CONFIG_FRONTSWAP
	_kernelConfig_warn-y__ CONFIG_ZSWAP
	
	
	_kernelConfig__bad-y__ CONFIG_COMPACTION
	_kernelConfig_warn-y__ CONFIG_BALLOON_COMPACTION
	
	# Uncertain.
	_kernelConfig_warn-y__ CONFIG_MEMORY_FAILURE
	
	# CRITICAL!
	_kernelConfig_warn-y__ CONFIG_KSM
}

_kernelConfig_require-integration() {
	_messagePlain_nominal 'kernelConfig: integration'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y_m CONFIG_FUSE_FS
	_kernelConfig__bad-y_m CONFIG_CUSE
	_kernelConfig__bad-y__ CONFIG_OVERLAY_FS
	_kernelConfig__bad-y__ CONFIG_ISO9660_FS
	_kernelConfig__bad-y__ CONFIG_UDF_FS
	_kernelConfig__bad-y_m CONFIG_NTFS_FS
	_kernelConfig_request CONFIG_NTFS_RW
	_kernelConfig__bad-y__ CONFIG_MSDOS_FS
	_kernelConfig__bad-y__ CONFIG_VFAT_FS
	_kernelConfig__bad-y__ CONFIG_MSDOS_PARTITION
	
	
	_kernelConfig__bad-y__ CONFIG_BTRFS_FS
	_kernelConfig__bad-y_m CONFIG_NILFS2_FS
	
	# TODO: LiveCD UnionFS or similar boot requirements.
	
	# Gentoo specific. Start with "gentoo-sources" if possible.
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_UDEV
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_PORTAGE
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_INIT_SCRIPT
	_kernelConfig_warn-y__ CONFIG_GENTOO_LINUX_INIT_SYSTEMD
}

# Recommended by docker ebuild during installation under Gentoo.
_kernelConfig_require-investigation_docker() {
	_messagePlain_nominal 'kernelConfig: investigation: docker'
	export kernelConfig_file="$1"
	
	# Apparently, 'CONFIG_MEMCG_SWAP_ENABLED' missing from recent 'menuconfig' .
	#_kernelConfig_warn-y__ CONFIG_MEMCG_SWAP_ENABLED
	#_kernelConfig_warn-y__ CONFIG_MEMCG_SWAP
	_kernelConfig_warn-y__ CONFIG_MEMCG
	
	_kernelConfig_warn-y__ CONFIG_CGROUP_HUGETLB
	_kernelConfig_warn-y__ CONFIG_RT_GROUP_SCHED
	
	true
}


# ATTENTION: Insufficiently investigated stuff to think about. Unknown consequences.
_kernelConfig_require-investigation() {
	_messagePlain_nominal 'kernelConfig: investigation'
	export kernelConfig_file="$1"
	
	_kernelConfig_warn-any ACPI_HMAT
	
	# Apparently, 'PCIE_BW' missing from recent 'menuconfig' .
	#_kernelConfig_warn-any PCIE_BW
	
	_kernelConfig_warn-any CONFIG_UCLAMP_TASK
	
	_kernelConfig_warn-any CPU_IDLE_GOV_TEO
	
	_kernelConfig_warn-any LOCK_EVENT_COUNTS
	
	
	_kernelConfig_require-investigation_docker "$@"
	_kernelConfig_require-investigation_prog "$@"
	true
}


_kernelConfig_require-investigation_prog() {
	_messagePlain_nominal 'kernelConfig: investigation: prog'
	export kernelConfig_file="$1"
	
	true
}



_kernelConfig_require-convenience() {
	_messagePlain_nominal 'kernelConfig: convenience'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_IKCONFIG
	_kernelConfig__bad-y__ CONFIG_IKCONFIG_PROC
	
	true
}

_kernelConfig_require-special() {
	_messagePlain_nominal 'kernelConfig: special'
	export kernelConfig_file="$1"
	
	_kernelConfig__bad-y__ CONFIG_CRYPTO_JITTERENTROPY
	
	#/dev/hwrng
	_kernelConfig__bad-y__ CONFIG_HW_RANDOM
	_kernelConfig__bad-y__ CONFIG_HW_RANDOM_INTEL
	_kernelConfig__bad-y__ CONFIG_HW_RANDOM_AMD
	_kernelConfig__bad-y__ CONFIG_HW_RANDOM_VIA
	_kernelConfig__bad-y_m HW_RANDOM_VIRTIO
	_kernelConfig__bad-y__ CONFIG_HW_RANDOM_TPM


	# Somewhat unusually, without known loss of performance.
	# Discovered during 'make oldconfig' of 'Linux 6.12.1' from then existing 'mainline' config file.
	_kernelConfig__bad-y__ X86_FRED

	_kernelConfig__bad-y__ SLAB_BUCKETS
	
	

	# TODO: Disabled presently (because this feature is in development and does not yet work), but seems like something to enable eventually.
	# _kernelConfig__bad-y__ KVM_SW_PROTECTED_VM

	
	# Usually a bad idea, since BTRFS filesystem compression, etc, should take care of this better.
	_kernelConfig__bad-n__ MODULE_COMPRESS

	# TODO: Expected unhelpful, but worth considering.
	#ZSWAP_SHRINKER_DEFAULT_ON


	# Unusual tradeoff. Theoretically may cause issues for Gentoo doing fsck on read-only root (due to not necessarily having initramfs).
	_kernelConfig__bad-y__ BLK_DEV_WRITE_MOUNTED
	_kernelConfig_warn-n__ BLK_DEV_WRITE_MOUNTED

	# If there is no compatibility issue, then the more compressible zswap allocator seems more useful.
	#_kernelConfig__warn-y__ ZSWAP_ZPOOL_DEFAULT_ZSMALLOC 


	# DANGER
	# If you honestly believe Meta cares about end-user security...
	# https://studio.youtube.com/video/MeUvSg9zQYc/edit
	# https://studio.youtube.com/video/kXrLujzPm_4/edit
	# There is just NO GOOD REASON to use or support Meta hardware. At all.
	_kernelConfig__bad-n__ NET_VENDOR_META


	# Requires compiling binaries to support this. Future Debian security updates may use this.
	_kernelConfig__bad-n__ X86_USER_SHADOW_STACK



	_kernelConfig__bad-y_m USB_GADGET

	# ATTENTION: Only drivers that are highly likely to cripple the 'out-of-box-experience' to the point of being unable to perform gParted, revert, basic web browsing, etc, for relatively useful laptops/tablets/etc .
	# Essential drivers (eg. iGPU, or at least basic 'VGA', keyboard, USB, etc) are normally included already Debian's default kernel config, if that is used as a starting point.
	# WARNING: Delegating which drivers to enable to upstream default Debian (or other distro) config files may be better for reliability, etc.
	_kernelConfig_warn-y_m ATH12K #WiFi7
	_kernelConfig_warn-y_m MT7996E #WiFi7 Concurrent Tri-Band
	RTW88_8822BU #WiFi USB
	RTW88_8822CU
	RTW88_8723DU
	RTW88_8821CE
	RTW88_8821CU
	RTW89_8851BE
	RTW89_8852AE
	RTW89_8852BE



	true
}

















