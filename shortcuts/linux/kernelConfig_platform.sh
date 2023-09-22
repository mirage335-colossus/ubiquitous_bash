
_test_kernelConfig() {
	#_getDep pahole
	_wantGetDep pahole
	
	_getDep lz4
	_getDep lz4c
}


_kernelConfig_request_build() {
	_messagePlain_request 'request: make menuconfig'
	
	_messagePlain_request 'request: make -j $(nproc)'
	
	# WARNING: Building debian kernel packages from Gentoo may be complex.
	#https://forums.gentoo.org/viewtopic-t-1096872-start-0.html
	#_messagePlain_request 'emerge dpkg fakeroot bc kmod cpio ; touch /var/lib/dpkg/status'
	
	_messagePlain_request 'request: make deb-pkg -j $(nproc)'
}


# NOTICE: Usually, 'desktop' will be preferable.
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
	
	_kernelConfig_require-investigation "$@"
	
	_kernelConfig_require-convenience "$@"
	
	_kernelConfig_require-special "$@"
	
	
	_kernelConfig_request_build
}

# NOTICE: Usually, 'desktop' will be preferable.
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
	
	_kernelConfig_require-investigation "$@"
	
	_kernelConfig_require-convenience "$@"
	
	_kernelConfig_require-special "$@"
	
	
	_kernelConfig_request_build
}

# NOTICE: Recommended! Most 'mobile' and 'panel' use cases will not benefit enough from power efficiency, reduced CPU cycles, or performance.
# WARNING: Security should be favored by tradeoff, as this may be shipped as the 'default' kernel (eg. for 'ubdist') .
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
	
	_kernelConfig_require-investigation "$@"
	
	_kernelConfig_require-convenience "$@"
	
	_kernelConfig_require-special "$@"
	
	
	_kernelConfig_request_build
}

# Forces 'kernelConfig_tradeoff_perform == false' .
_kernelConfig_server() {
	_messageNormal 'kernelConfig: server'

	export kernelConfig_tradeoff_perform='false'
	_kernelConfig_desktop "$@"
}

