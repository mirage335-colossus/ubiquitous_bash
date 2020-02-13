_init_deps() {
	export enUb_set="true"
	
	export enUb_machineinfo=""
	export enUb_git=""
	export enUb_bup=""
	export enUb_notLean=""
	export enUb_build=""
	export enUb_os_x11=""
	export enUb_proxy=""
	export enUb_proxy_special=""
	export enUb_x11=""
	export enUb_blockchain=""
	export enUb_image=""
	export enUb_virt=""
	export enUb_ChRoot=""
	export enUb_QEMU=""
	export enUb_vbox=""
	export enUb_docker=""
	export enUb_wine=""
	export enUb_DosBox=""
	export enUb_msw=""
	export enUb_fakehome=""
	export enUb_abstractfs=""
	export enUb_buildBash=""
	export enUb_buildBashUbiquitous=""
	
	export enUb_command=""
	export enUb_synergy=""
	
	export enUb_hardware=""
	export enUb_enUb_x220t=""
	
	export enUb_user=""
	
	export enUb_metaengine=""
	
	export enUb_stopwatch=""
}

_deps_dev() {
	export enUb_dev="true"
}

_deps_dev_heavy() {
	_deps_notLean
	export enUb_dev_heavy="true"
}

_deps_mount() {
	_deps_notLean
	export enUb_mount="true"
}

_deps_machineinfo() {
	export enUb_machineinfo="true"
}

_deps_git() {
	export enUb_git="true"
}

_deps_bup() {
	export enUb_bup="true"
}

_deps_notLean() {
	_deps_git
	_deps_bup
	export enUb_notLean="true"
}

_deps_distro() {
	export enUb_distro="true"
}

_deps_build() {
	export enUb_build="true"
}

#Note that '_build_bash' does not incur '_build', expected to require only scripted concatenation.
_deps_build_bash() {
	export enUb_buildBash="true"
}

_deps_build_bash_ubiquitous() {
	_deps_build_bash
	export enUb_buildBashUbiquitous="true"
}

_deps_os_x11() {
	export enUb_os_x11="true"
}

_deps_proxy() {
	export enUb_proxy="true"
}

_deps_proxy_special() {
	_deps_proxy
	export enUb_proxy_special="true"
}

_deps_x11() {
	_deps_build
	_deps_notLean
	export enUb_x11="true"
}

_deps_blockchain() {
	_deps_notLean
	_deps_x11
	export enUb_blockchain="true"
}

_deps_image() {
	_deps_notLean
	_deps_machineinfo
	
	# DANGER: Required for safety mechanisms which may also be used by some other virtualization backends!
	# _deps_image
	# _deps_chroot
	# _deps_vbox
	# _deps_qemu
	export enUb_image="true"
}

_deps_virt_thick() {
	_deps_distro
	_deps_build
	_deps_notLean
	_deps_image
	export enUb_virt_thick="true"
}

_deps_virt() {
	_deps_machineinfo
	
	# WARNING: Includes 'findInfrastructure_virt' which may be a dependency of multiple virtualization backends.
	# _deps_image
	# _deps_chroot
	# _deps_vbox
	# _deps_qemu
	# _deps_docker
	export enUb_virt="true"
}

_deps_chroot() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_ChRoot="true"
}

_deps_qemu() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_vbox="true"
}

_deps_docker() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_docker="true"
}

_deps_wine() {
	_deps_notLean
	_deps_virt
	export enUb_wine="true"
}

_deps_dosbox() {
	_deps_notLean
	_deps_virt
	export enUb_DosBox="true"
}

_deps_msw() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	_deps_qemu
	_deps_vbox
	_deps_wine
	export enUb_msw="true"
}

_deps_fakehome() {
	_deps_notLean
	_deps_virt
	export enUb_fakehome="true"
}

_deps_abstractfs() {
	_deps_git
	_deps_bup
	_deps_virt
	export enUb_abstractfs="true"
}

_deps_command() {
	_deps_os_x11
	_deps_proxy
	_deps_proxy_special
	
	export enUb_command="true"
}

_deps_synergy() {
	_deps_command
	export enUb_synergy="true"
}

_deps_hardware() {
	_deps_notLean
	export enUb_hardware="true"
}

_deps_x220t() {
	_deps_notLean
	_deps_hardware
	export enUb_x220t="true"
}

_deps_user() {
	_deps_notLean
	export enUb_user="true"
}

_deps_channel() {
	export enUb_channel="true"
}

_deps_stopwatch() {
	export enUb_stopwatch="true"
}

# WARNING: Specifically refers to 'Linux', the kernel, and things specific to it, NOT any other UNIX like features.
# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
# ie. _test_linux must not require Linux-only binaries
_deps_linux() {
	export enUb_linux="true"
}

#placeholder, define under "metaengine/build"
#_deps_metaengine() {
#	_deps_notLean
#	
#	export enUb_metaengine="true"
#}

