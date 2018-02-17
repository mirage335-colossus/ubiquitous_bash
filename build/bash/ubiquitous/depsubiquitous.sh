_deps_git() {
	export enUb_git="true"
}

_deps_notLean() {
	_deps_git
	export enUb_notLean="true"
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
	export enUb_image="true"
}

_deps_virt() {
	_deps_notLean
	_deps_image
	export enUb_virt="true"
}

_deps_chroot() {
	_deps_virt
	export enUb_ChRoot="true"
}

_deps_qemu() {
	_deps_virt
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_virt
	export enUb_vbox="true"
}

_deps_docker() {
	_deps_virt
	export enUb_docker="true"
}

_deps_wine() {
	_deps_notLean
	export enUb_wine="true"
}

_deps_dosbox() {
	_deps_notLean
	export enUb_DosBox="true"
}

_deps_msw() {
	_deps_virt
	_deps_qemu
	_deps_vbox
	_deps_wine
	export enUb_msw="true"
}

_deps_fakehome() {
	_deps_notLean
	export enUb_fakehome="true"
}
 
