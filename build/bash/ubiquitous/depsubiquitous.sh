_init_deps() {
	export enUb_set="true"
	
	export enUb_dev=""
	export enUb_dev_heavy=""
	export enUb_dev_heavy_asciinema=""
	export enUb_dev_heavy_atom=""
	
	export enUb_generic=""

	export enUb_dev_buildOps=""

	export enUb_dev_ai=""
	
	export enUb_cloud_heavy=""
	
	export enUb_mount=""
	
	export enUb_machineinfo=""
	export enUb_git=""
	export enUb_bup=""
	export enUb_repo=""
	export enUb_search=""
	export enUb_cloud=""
	export enUb_cloud_self=""
	export enUb_cloud_build=""
	export enUb_notLean=""
	export enUb_github=""
	export enUb_distro=""
	export enUb_getMinimal=""
	export enUb_getMost_special_veracrypt=""
	export enUb_getMost_special_npm=""
	export enUb_build=""
	export enUb_buildBash=""
	export enUb_os_x11=""
	export enUb_proxy=""
	export enUb_proxy_special=""
	export enUb_serial=""
	export enUb_fw=""
	export enUb_clog=""
	export enUb_x11=""
	export enUb_researchEngine=""
	export enUb_ollama=""
	export enUb_ai_dataset=""
	export enUb_ai_semanticAssist=""
	export enUb_ai_knowledge=""
	export enUb_blockchain=""
	export enUb_java=""
	export enUb_image=""
	export enUb_disc=""
	export enUb_virt=""
	export enUb_virt_thick=""
	export enUb_virt_translation=""
	export enUb_ChRoot=""
	export enUb_bios=""
	export enUb_QEMU=""
	export enUb_vbox=""
	export enUb_docker=""
	export enUb_wine=""
	export enUb_DosBox=""
	export enUb_msw=""
	export enUb_fakehome=""
	export enUb_abstractfs=""
	export enUb_virt_python=""
	export enUb_buildBash=""
	export enUb_buildBashUbiquitous=""

	export enUb_virt_translation_gui=""

	export enUb_virt_dumbpath=""
	
	export enUb_command=""
	export enUb_synergy=""
	
	export enUb_hardware=""
	export enUb_measurement=""
	export enUb_enUb_x220t=""
	export enUb_enUb_w540=""
	export enUb_enUb_gpd=""
	export enUb_enUb_peripherial=""
	
	export enUb_user=""
	
	export enUb_channel=""
	
	export enUb_metaengine=""
	
	export enUb_stopwatch=""
	
	export enUb_linux=""
	
	export enUb_python=""
	export enUb_haskell=""
	
	export enUb_calculators=""

	export enUb_ai_shortcuts=""
	export enUb_ollama_shortcuts=""
	export enUb_ai_augment=""
	export enUb_factory_shortcuts=""
	export enUb_factory_shortcuts_ops=""

	export enUb_server=""
}

_deps_generic() {
	export enUb_generic="true"
}

_deps_dev() {
	_deps_generic
	
	export enUb_dev="true"
}

_deps_dev_heavy() {
	_deps_notLean
	export enUb_dev_heavy="true"
}

_deps_dev_heavy_asciinema() {
	_deps_notLean
	_deps_get_npm
	#export enUb_dev_heavy="true"
	export enUb_dev_heavy_asciinema="true"
}

_deps_dev_heavy_atom() {
	_deps_notLean
	export enUb_dev_heavy="true"
	export enUb_dev_heavy_atom="true"
}

_deps_dev_buildOps() {
	_deps_generic
	
	export enUb_dev_buildOps="true"
}

_deps_dev_ai() {
	export enUb_dev_ai="true"
}

_deps_cloud_heavy() {
	_deps_notLean
	export enUb_cloud_heavy="true"
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

_deps_repo() {
	export enUb_repo="true"
}

_deps_search() {
	_deps_abstractfs
	
	_deps_git
	_deps_bup
	
	_deps_x11
	
	export enUb_search="true"
}

_deps_cloud() {
	_deps_repo
	_deps_proxy
	_deps_serial
	_deps_stopwatch
	
	_deps_fakehome
	
	export enUb_cloud="true"
}

_deps_cloud_self() {
	_deps_cloud
	export enUb_cloud_self="true"
}

_deps_cloud_build() {
	_deps_cloud
	export enUb_cloud_build="true"
}

_deps_notLean() {
	_deps_git
	_deps_bup
	_deps_repo
	export enUb_notLean="true"
}

_deps_github() {
	export enUb_github="true"
}

_deps_distro() {
	export enUb_distro="true"
}

_deps_getMinimal() {
	export enUb_getMinimal="true"
}

_deps_get_npm() {
	export enUb_getMost_special_npm="true"
}

_deps_getVeracrypt() {
	export enUb_getMost_special_veracrypt="true"
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

_deps_serial() {
	_deps_notLean
	
	export enUb_serial="true"
}

_deps_fw() {
	export enUb_fw="true"
}

_deps_clog() {
	export enUb_clog="true"
}

_deps_x11() {
	_deps_build
	_deps_notLean
	export enUb_x11="true"
}

_deps_ai() {
	_deps_notLean
	export enUb_researchEngine="true"
	export enUb_ollama="true"
}
_deps_ai_dataset() {
	_deps_ai
	_deps_ai_shortcuts
	export enUb_ai_dataset="true"
}
_deps_ai_semanticAssist() {
	_deps_ai_dataset
	export enUb_ai_semanticAssist="true"
}
_deps_ai_knowledge() {
	export enUb_ai_knowledge="true"
}

_deps_blockchain() {
	_deps_notLean
	_deps_x11
	export enUb_blockchain="true"
}

_deps_java() {
	export enUb_java="true"
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

_deps_disc() {
	export enUb_disc="true"
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

# Specifically intended to support shortcuts using file parameter translation.
_deps_virt_translation() {
	export enUb_virt_translation="true"
}

_deps_chroot() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_ChRoot="true"
}

_deps_bios() {
	_deps_notLean
	_deps_virt
	_deps_virt_thick
	export enUb_bios="true"
}

_deps_qemu() {
	_deps_notLean
	_deps_virt
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
	export enUb_QEMU="true"
}

_deps_vbox() {
	_deps_notLean
	_deps_virt
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
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
	#_deps_virt_thick
		_deps_distro
		_deps_build
		_deps_image
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

_deps_virtPython() {
	_deps_python
	export enUb_virt_python="true"
}

_deps_virt_translation_gui() {
	_deps_virt_translation
	
	export enUb_virt_translation_gui="true"
}

_deps_dumbpath() {
	export enUb_virt_dumbpath="true"
}

_deps_command() {
	_deps_os_x11
	_deps_proxy
	_deps_proxy_special
	_deps_serial
	
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

_deps_measurement() {
	_deps_hardware
	export enUb_measurement="true"
}

_deps_x220t() {
	_deps_notLean
	_deps_hardware
	export enUb_x220t="true"
}

_deps_w540() {
	_deps_notLean
	_deps_hardware
	export enUb_w540="true"
}

_deps_gpd() {
	_deps_notLean
	_deps_hardware
	export enUb_gpd="true"
}

_deps_peripherial() {
	_deps_notLean
	_deps_hardware
	export enUb_peripherial="true"
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

_deps_python() {
	_deps_generic
	
	export enUb_python="true"
}
_deps_haskell() {
	_deps_generic
	
	export enUb_haskell="true"
}

_deps_calculators() {
	_deps_generic
	
	export enUb_calculators="true"
}

_deps_ai_shortcuts() {
	_deps_generic

	_deps_ai
	
	export enUb_ai_shortcuts="true"
	export enUb_ollama_shortcuts="true"
}
_deps_ai_augment() {
	_deps_ai_shortcuts

	export enUb_ai_augment="true"
}

_deps_factory_shortcuts() {
	_deps_generic
	
	export enUb_factory_shortcuts="true"
}
_deps_factory_shortcuts_ops() {
	_deps_generic
	
	export enUb_factory_shortcuts_ops="true"
}

_deps_server() {
	_deps_generic

	_deps_fw

	_deps_factory_shortcuts
	_deps_factory_shortcuts_ops
	
	export enUb_server="true"
}

#placeholder, define under "queue/build"
# _deps_queue() {
# 	# Message queue - 'broadcastPipe' , etc , underlying functions , '_read_page' , etc .
# 	export enUb_queue="true"
# 	
# 	# Packet - any noise-tolerant 'format' .
# 	# RESERVED variable name - synonymous with 'enUb_queue' .
# 	#export enUb_packet="true"
# 	
# 	# Portal - a 'filter program' to make arrangements between embedded devices of various unique identities and/or devices (eg. 'xAxis400stepsMM' . )
# 	# RESERVED variable name - synonymous with 'enUb_queue' .
# 	#export enUb_portal="true"
# }

#placeholder, define under "metaengine/build"
#_deps_metaengine() {
#	_deps_notLean
#	
#	export enUb_metaengine="true"
#}

