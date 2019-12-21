# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_panel() {
	_messageNormal 'kernelConfig: panel'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	
	_messagePlain_request 'request: make menuconfig'
	
	_messagePlain_request 'request: make -j $(nproc)'
	_messagePlain_request 'request: make deb-pkg -j $(nproc)'
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_mobile() {
	_messageNormal 'kernelConfig: mobile'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=300
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='true'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	
	_messagePlain_request 'request: make menuconfig'
	
	_messagePlain_request 'request: make -j $(nproc)'
	_messagePlain_request 'request: make deb-pkg -j $(nproc)'
}

# ATTENTION: As desired, ignore, or override with 'ops.sh' or similar.
_kernelConfig_desktop() {
	_messageNormal 'kernelConfig: desktop'
	
	[[ "$kernelConfig_tradeoff_perform" == "" ]] && export kernelConfig_tradeoff_perform='false'
	[[ "$kernelConfig_frequency" == "" ]] && export kernelConfig_frequency=1000
	[[ "$kernelConfig_tickless" == "" ]] && export kernelConfig_tickless='false'
	
	_kernelConfig_require-tradeoff "$@"
	
	_kernelConfig_require-virtualization-accessory "$@"
	
	_kernelConfig_require-virtualbox "$@"
	
	_kernelConfig_require-boot "$@"
	
	_kernelConfig_require-arch-x64 "$@"
	
	_kernelConfig_require-accessory "$@"
	
	_kernelConfig_require-build "$@"
	
	_kernelConfig_require-latency "$@"
	
	_kernelConfig_require-memory "$@"
	
	_kernelConfig_require-integration "$@"
	
	
	_messagePlain_request 'request: make menuconfig'
	
	_messagePlain_request 'request: make -j $(nproc)'
	_messagePlain_request 'request: make deb-pkg -j $(nproc)'
}

