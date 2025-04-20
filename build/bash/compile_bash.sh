#Default is to include all, or run a specified configuration. For this reason, it will be more typical to override this entire function, rather than append any additional code.
_compile_bash_deps() {
	[[ "$1" == "rotten" ]] && return 0
	[[ "$1" == "rotten"* ]] && return 0
	
	if [[ "$1" == "lean" ]]
	then
		_deps_dev_buildOps
		
		#_deps_git
		
		#_deps_virt_translation
		
		# Serial depends on '_getMost_backend', which explicitly requires only 'notLean' .
		#_deps_notLean
		#_deps_serial

		_deps_virtPython
		
		_deps_stopwatch
		
		_deps_queue
		
		return 0
	fi
	
	# Specifically intended to be imported into user profile.
	if [[ "$1" == "ubcore" ]]
	then
		_deps_dev_buildOps
		
		_deps_notLean
		_deps_os_x11
		
		_deps_serial

		_deps_fw
		
		_deps_git
		_deps_bup
		
		_deps_repo
		
		_deps_search
		
		# WARNING: Only known production use in this context is '_cloud_reset' , '_cloud_unhook' , and similar.
		_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_abstractfs

		_deps_virtPython
		
		_deps_virt_translation

		_deps_virt_translation_gui
		
		_deps_stopwatch
		
		_deps_github
		
		_deps_distro
		_deps_getMinimal
		_deps_getVeracrypt
		_deps_linux
		
		_deps_hardware
		_deps_measurement
		_deps_x220t
		_deps_w540
		_deps_gpd
		
		_deps_generic
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
		
		_deps_calculators
		
		#_deps_queue
		
		_deps_disc
		
		# _compile_bash_deps 'core'
		return 0
	fi
	
	if [[ "$1" == "cautossh" ]]
	then
		_deps_dev_buildOps
		
		_deps_os_x11
		_deps_proxy
		_deps_proxy_special

		_deps_serial

		_deps_fw
		
		_deps_clog
		
		_deps_channel
		
		_deps_git
		_deps_bup
		
		_deps_repo
		
		# WARNING: Although 'cloud' may be relevant to 'cautossh', not included for now, to avoid remotely pulling client software.
		# ATTENTION: Override with 'ops.sh', 'core.sh', or similar.
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build
		
		_deps_command
		_deps_synergy
		
		_deps_getVeracrypt
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		return 0
	fi
	
	if [[ "$1" == "processor" ]]
	then
		_deps_dev
		_deps_dev_buildOps
		
		_deps_generic
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
		
		_deps_calculators
		
		_deps_channel
		
		_deps_queue
		_deps_metaengine
		
		_deps_serial

		_deps_virtPython
		
		_deps_stopwatch
		
		return 0
	fi
	
	if [[ "$1" == "abstract" ]] || [[ "$1" == "abstractfs" ]]
	then
		_deps_dev
		_deps_dev_buildOps
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_abstractfs

		_deps_virtPython
		
		_deps_serial
		
		_deps_stopwatch
		
		return 0
	fi
	
	# Beware most uses of fakehome will benefit from full virtualization fallback.
	if [[ "$1" == "fakehome" ]]
	then
		_deps_dev
		_deps_dev_buildOps
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_fakehome
		_deps_abstractfs

		_deps_virtPython
		
		_deps_serial
		
		_deps_stopwatch
		
		return 0
	fi
	
	if [[ "$1" == "monolithic" ]]
	then
		_deps_dev_heavy
		#_deps_dev_heavy_atom
		_deps_dev
		_deps_dev_buildOps
		
		#_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
		_deps_x11
		_deps_image
		
		_deps_virt
		#_deps_virt_thick

		#_deps_virt_translation_gui
		
		#_deps_chroot
		#_deps_bios
		_deps_qemu
		_deps_vbox
		#_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs

		_deps_virtPython
		
		_deps_generic
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build

		_deps_github
		
		_deps_distro
		_deps_getMinimal
		_deps_getVeracrypt
		
		#_deps_blockchain
		
		#_deps_command
		#_deps_synergy
		
		#_deps_hardware
		#_deps_measurement
		#_deps_x220t
		#_deps_w540
		#_deps_gpd
		#_deps_peripherial
		
		#_deps_user
		
		#_deps_proxy
		#_deps_proxy_special
		_deps_serial

		_deps_fw
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		_deps_disc
		
		_deps_build
		
		#_deps_build_bash
		#_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	if [[ "$1" == "core" ]]
	then
		_deps_dev_heavy
		#_deps_dev_heavy_atom
		_deps_dev
		_deps_dev_buildOps
		
		#_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
		_deps_x11
		_deps_image
		
		_deps_virt
		_deps_virt_thick

		_deps_virt_translation_gui
		
		_deps_chroot
		_deps_bios
		_deps_qemu
		_deps_vbox
		#_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs

		_deps_virtPython
		
		_deps_generic
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
		
		_deps_calculators
		
		_deps_channel
		
		#_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		#_deps_cloud
		#_deps_cloud_self
		#_deps_cloud_build

		_deps_github
		
		_deps_distro
		_deps_getMinimal
		_deps_getVeracrypt
		
		#_deps_blockchain
		
		#_deps_command
		#_deps_synergy
		
		#_deps_hardware
		#_deps_measurement
		#_deps_x220t
		#_deps_w540
		#_deps_gpd
		#_deps_peripherial
		
		#_deps_user
		
		#_deps_proxy
		#_deps_proxy_special
		_deps_serial

		_deps_fw
		
		# WARNING: Linux *kernel* admin assistance *only*. NOT any other UNIX like features.
		# WARNING: Beware Linux shortcut specific dependency programs must not be required, or will break other operating systems!
		# ie. _test_linux must not require Linux-only binaries
		_deps_linux
		
		_deps_stopwatch
		
		_deps_disc
		
		_deps_build
		
		_deps_build_bash
		_deps_build_bash_ubiquitous
		
		return 0
	fi

	# In practice, 'core' now includes '_deps_ai' by default to support '_deps_ai_dataset' .
	if [[ "$1" == "core_ai" ]]
	then
		_deps_virtPython
		
		_deps_ai
		_deps_ai_shortcuts
		_compile_bash_deps 'core'

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
	fi
	
	if [[ "$1" == "" ]] || [[ "$1" == "ubiquitous_bash" ]] || [[ "$1" == "ubiquitous_bash.sh" ]] || [[ "$1" == "complete" ]]
	then
		_deps_dev_heavy
		#_deps_dev_heavy_atom
		_deps_dev
		_deps_dev_buildOps
		
		_deps_cloud_heavy
		
		
		
		_deps_mount
		
		_deps_notLean
		_deps_os_x11
		
		_deps_java
		
		
		_deps_x11
		_deps_image
		
		_deps_virt
		_deps_virt_thick

		_deps_virt_translation_gui
		
		_deps_chroot
		_deps_bios
		_deps_qemu
		_deps_vbox
		_deps_docker
		_deps_wine
		_deps_dosbox
		_deps_msw
		_deps_fakehome
		_deps_abstractfs

		_deps_virtPython
		
		_deps_generic
		
		_deps_python
		_deps_haskell
		
		_deps_ai
		_deps_ai_shortcuts

		#_deps_ai
		_deps_ai_dataset
		_deps_ai_semanticAssist
		_deps_ai_knowledge

		_deps_factory_shortcuts
		
		_deps_calculators
		
		_deps_channel
		
		_deps_queue
		_deps_metaengine
		
		_deps_git
		_deps_bup
		_deps_repo
		
		_deps_search
		
		_deps_cloud
		_deps_cloud_self
		_deps_cloud_build

		_deps_github
		
		_deps_distro
		_deps_getMinimal
		_deps_getVeracrypt
		
		_deps_blockchain
		
		_deps_command
		_deps_synergy
		
		_deps_hardware
		_deps_measurement
		_deps_x220t
		_deps_w540
		_deps_gpd
		_deps_peripherial
		
		_deps_user
		
		_deps_proxy
		_deps_proxy_special
		_deps_serial

		_deps_fw
		
		_deps_clog
		
		_deps_stopwatch
		
		_deps_linux
		
		_deps_disc
		
		_deps_build
		
		_deps_build_bash
		_deps_build_bash_ubiquitous
		
		return 0
	fi
	
	return 1
}

_vars_compile_bash() {
	export configDir="$scriptAbsoluteFolder"/_config
	
	export progDir="$scriptAbsoluteFolder"/_prog
	export progScript="$scriptAbsoluteFolder"/ubiquitous_bash.sh
	[[ "$1" != "" ]] && export progScript="$scriptAbsoluteFolder"/"$1"
	
	_vars_compile_bash_prog "$@"
}

_compile_bash_header() {
	export includeScriptList
	
	includeScriptList+=( "generic"/minimalheader.sh )
	includeScriptList+=( "generic"/ubiquitousheader.sh )
	
	includeScriptList+=( "os/override"/override.sh )
	includeScriptList+=( "os/override"/override_prog.sh )
	
	includeScriptList+=( "os/override"/override_cygwin.sh )
	includeScriptList+=( "os/override"/override_wsl.sh )

	includeScriptList+=( "special"/ingredients.sh )
}

_compile_bash_header_program() {
	export includeScriptList
	
	includeScriptList+=( progheader.sh )
}

_compile_bash_essential_utilities() {
	export includeScriptList
	
	#####Essential Utilities
	includeScriptList+=( "labels"/utilitiesLabel.sh )
	includeScriptList+=( "generic/filesystem"/absolutepaths.sh )
	includeScriptList+=( "generic/filesystem"/safedelete.sh )
	includeScriptList+=( "generic/filesystem"/destroylock.sh )
	includeScriptList+=( "generic/filesystem"/moveconfirm.sh )
	includeScriptList+=( "generic/filesystem"/allLogic.sh )
	includeScriptList+=( "generic/process"/timeout.sh )
	includeScriptList+=( "generic/process"/terminate.sh )
	includeScriptList+=( "generic"/condition.sh )
	includeScriptList+=( "generic"/uid.sh )
	includeScriptList+=( "generic/filesystem/permissions"/checkpermissions.sh )
	includeScriptList+=( "generic"/findInfrastructure.sh )
	includeScriptList+=( "generic"/gather.sh )
	
	includeScriptList+=( "generic/process"/priority.sh )
	
	includeScriptList+=( "generic/filesystem"/internal.sh )
	
	includeScriptList+=( "generic"/messaging.sh )
	
	includeScriptList+=( "generic"/config/mustcarry.sh )
	
	[[ "$enUb_buildBash" == "true" ]] && includeScriptList+=( "build/bash"/include_bash.sh )
	[[ "$enUb_buildBash" == "true" ]] && includeScriptList+=( "build/bash"/include_bash_prog.sh )
}

_compile_bash_utilities() {
	export includeScriptList
	
	#####Utilities
	includeScriptList+=( "special"/mustberoot.sh )
	includeScriptList+=( "special"/mustgetsudo.sh )
	
	includeScriptList+=( "special"/uuid.sh )
	
	
	includeScriptList+=( "generic/filesystem"/getext.sh )
	
	includeScriptList+=( "generic/filesystem"/finddir.sh )
	
	includeScriptList+=( "generic/filesystem"/discoverresource.sh )
	
	includeScriptList+=( "generic/filesystem"/relink.sh )
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/bindmountmanager.sh )
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/waitumount.sh )
	
	[[ "$enUb_mount" == "true" ]] && includeScriptList+=( "generic/filesystem/mounts"/mountchecks.sh )
	
	[[ "$enUb_channel" == "true" ]] && includeScriptList+=( "generic/process/"channel.sh )
	
	includeScriptList+=( "generic/process"/waitforprocess.sh )
	
	includeScriptList+=( "generic/process"/daemon.sh )
	
	includeScriptList+=( "generic/process"/remotesig.sh )
	
	includeScriptList+=( "generic/process"/embed_here.sh )
	includeScriptList+=( "generic/process"/embed.sh )
	
	includeScriptList+=( "generic/net"/fetch.sh )
	
	includeScriptList+=( "generic/net"/findport.sh )
	
	includeScriptList+=( "generic/net"/waitport.sh )
	
	[[ "$enUb_proxy_special" == "true" ]] && includeScriptList+=( "generic/net/proxy/tor"/tor.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/here_ssh.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/ssh.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/autossh.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_vncserver_operations.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_vncviewer_operations.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/vnc"/vnc_x11vnc_operations.sh )
	( [[ "$enUb_proxy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "generic/net/proxy/vnc"/vnchost.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/here_proxyrouter.sh )
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/proxyrouter"/proxyrouter.sh )

	[[ "$enUb_serial" == "true" ]] && includeScriptList+=( "generic/serial"/forwardPort.sh )
	[[ "$enUb_serial" == "true" ]] && includeScriptList+=( "generic/serial"/forwardPort-service.sh )
	[[ "$enUb_serial" == "true" ]] && includeScriptList+=( "generic/serial"/terminal.sh )
	
	[[ "$enUb_fw" == "true" ]] && includeScriptList+=( "generic/net/fw"/fw.sh )
	[[ "$enUb_fw" == "true" ]] && includeScriptList+=( "generic/net/fw"/hosts.sh )
	
	[[ "$enUb_clog" == "true" ]] && includeScriptList+=( "generic/net/clog"/clog.sh )
	
	includeScriptList+=( "generic"/showCommand.sh )
	includeScriptList+=( "generic"/validaterequest.sh )
	
	includeScriptList+=( "generic"/preserveLog.sh )
	
	[[ "$enUb_os_x11" == "true" ]] && includeScriptList+=( "os/unix/x11"/findx11.sh )
	
	includeScriptList+=( "os"/getDep.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/distro/debian"/getDep_debian.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/distro/ubuntu"/getDep_ubuntu.sh )
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/distro"/getMost.sh )
	
	[[ "$enUb_getMinimal" == "true" ]] && includeScriptList+=( "os/distro"/getMinimal.sh )
	
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] ) && includeScriptList+=( "os/distro"/getMost_special.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] ) && includeScriptList+=( "os/distro"/getMinimal_special.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] ) && includeScriptList+=( "os/distro/unix/openssl"/splice_openssl.sh )
	
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] ) && includeScriptList+=( "os/distro"/getMost_special_zWorkarounds.sh )
	
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] || [[ "$enUb_getMost_special_veracrypt" == "true" ]] ) && includeScriptList+=( "os/distro"/getMost_special_veracrypt.sh )
	
	
	
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_getMinimal" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_distro" == "true" ]] ) && includeScriptList+=( "os"/nixos.sh )
	
	
	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/distro/cygwin"/getMost_cygwin.sh )


	
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/unix/systemd"/here_systemd.sh )
	[[ "$enUb_notLean" == "true" ]] && includeScriptList+=( "os/unix/systemd"/hook_systemd.sh )
	
	
	
	[[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "instrumentation"/bashdb/bashdb.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_stopwatch" == "true" ]] ) && includeScriptList+=( "instrumentation"/profiling/stopwatch.sh )
	
	[[ "$enUb_generic" == "true" ]] && includeScriptList+=( "generic"/generic.sh )
}

# Specifically intended to support Eclipse as necessary for building existing software .
# Java is regarded as something similar to, but not, an unusual virtualization backend, due to its perhaps rare combination of portability, ongoing incompatible versions, lack of root or kernelspace requirements, typical operating system wide installation, and overall complexity.
# Multiple 'jre' and 'jdk' packages or script contained versions may be able to, or required, to satisfy related dependencies.
# WARNING: This is intended to provide for java *applications*, NOT necessarily browser java 'applets'.
# WARNING: Do NOT deprecate java versions for 'security' reasons - this is intended ONLY to support applications which already normally require user or root permissions.
_compile_bash_utilities_java() {
	[[ "$enUb_java" == "true" ]] && includeScriptList+=( "special/java"/java.sh )
#	[[ "$enUb_java" == "true" ]] && includeScriptList+=( "special/java"/javac.sh )
}

_compile_bash_utilities_python() {
	[[ "$enUb_python" == "true" ]] && includeScriptList+=( "build/python"/python.sh )
}
_compile_bash_utilities_haskell() {
	[[ "$enUb_haskell" == "true" ]] && includeScriptList+=( "build/haskell"/haskell.sh )
}

_compile_bash_utilities_virtualization() {
	export includeScriptList
	
	# ATTENTION: Although the only known requirement for gosu is virtualization, it may be necessary wherever sudo is not sufficient to drop privileges.
	[[ "$enUb_virt_thick" == "true" ]] && includeScriptList+=( "special/gosu"/gosu.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtenv.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/findInfrastructure_virt.sh )
	
	# Any script managing MSW from UNIX may need basic file parameter translation without needing complete remapping. Example: "_vncviewer_operations" .
	( [[ "$enUb_virt" == "true" ]] || [[ "$enUb_proxy" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] ) && includeScriptList+=( "virtualization"/osTranslation.sh )
	( [[ "$enUb_virt" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] ) && includeScriptList+=( "virtualization"/localPathTranslation.sh )
	
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs_appdir_specific.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfs_appdir.sh )
	[[ "$enUb_abstractfs" == "true" ]] && includeScriptList+=( "virtualization/abstractfs"/abstractfsvars.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomemake.sh )
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehome.sh )
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomeuser.sh )
	includeScriptList+=( "virtualization/fakehome"/fakehomereset.sh )

	[[ "$enUb_virt_python" == "true" ]] && includeScriptList+=( "virtualization/python"/override_msw_python.sh )
	[[ "$enUb_virt_python" == "true" ]] && includeScriptList+=( "virtualization/python"/override_cygwin_python.sh )
	[[ "$enUb_virt_python" == "true" ]] && includeScriptList+=( "virtualization/python"/override_nix_python.sh )
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/mountimage.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/createImage.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/here_bootdisc.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/bootdisc.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/userpersistenthome.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "virtualization/image"/transferimage.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/testchroot.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/procchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/mountchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/enterchroot.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/mountchrootuser.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/userchroot.sh )
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/dropchroot.sh )
	
	[[ "$enUb_ChRoot" == "true" ]] && includeScriptList+=( "virtualization/chroot"/ubdistchroot.sh )
	
	[[ "$enUb_bios" == "true" ]] && includeScriptList+=( "virtualization/bios"/createvm.sh )
	[[ "$enUb_bios" == "true" ]] && includeScriptList+=( "virtualization/bios"/live.sh )
	
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-raspi-raspi.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-x64-raspi.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu-x64-x64.sh )
	[[ "$enUb_QEMU" == "true" ]] && includeScriptList+=( "virtualization/qemu"/qemu.sh )
	
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxtest.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxmount.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxlab.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxuser.sh )
	
	[[ "$enUb_DosBox" == "true" ]] && includeScriptList+=( "virtualization/dosbox"/here_dosbox.sh )
	[[ "$enUb_DosBox" == "true" ]] && includeScriptList+=( "virtualization/dosbox"/dosbox.sh )
	
	[[ "$enUb_wine" == "true" ]] && includeScriptList+=( "virtualization/wine"/wine.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/here_docker.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockerdrop.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockertest.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockerchecks.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockeruser.sh )


	if ( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_image" == "true" ]] || [[ "$enUb_docker" == "true" ]] || [[ "$enUb_virt" == "true" ]] || [[ "$enUb_virt_thick" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] || [[ "$enUb_virt_translation_gui" == "true" ]] )
	then
		includeScriptList+=( "virtualization/wsl2"/wsl2.sh )
		includeScriptList+=( "virtualization/wsl2"/wsl2_setup.sh )
		
		includeScriptList+=( "virtualization/wsl2"/here_wsl2.sh )
		includeScriptList+=( "virtualization/wsl2"/wsl2_internal.sh )

		includeScriptList+=( "virtualization/wsl2"/here_wsl2_gui.sh )
	fi

	( [[ "$enUb_virt_translation_gui" == "true" ]] ) && includeScriptList+=( "virtualization/wsl2"/wsl2_gui_internal.sh )
}

# WARNING: Shortcuts must NOT cause _stop/exit failures in _test/_setup procedures!
_compile_bash_shortcuts() {
	export includeScriptList
	
	
	#####Shortcuts
	includeScriptList+=( "labels"/shortcutsLabel.sh )
	
	includeScriptList+=( "shortcuts/prompt"/visualPrompt.sh )
	
	
	[[ "$enUb_researchEngine" == "true" ]] && includeScriptList+=( "ai"/researchEngine.sh )
	
	[[ "$enUb_ollama" == "true" ]] && includeScriptList+=( "ai/ollama"/ollama.sh )
	
	( ( [[ "$enUb_dev_heavy" == "true" ]] ) || [[ "$enUb_ollama_shortcuts" == "true" ]] ) && includeScriptList+=( "shortcuts/ai/ollama"/ollama.sh )

	[[ "$enUb_factory_shortcuts" ]] && includeScriptList+=( "shortcuts/factory"/factoryCreate.sh )
	[[ "$enUb_factory_shortcuts" ]] && includeScriptList+=( "shortcuts/factory"/factory.sh )
	

	[[ "$enUb_ai_dataset" == "true" ]] && includeScriptList+=( "ai/dataset"/format.sh )
	( [[ "$enUb_ai_dataset" == "true" ]] || [[ "$enUb_ai_shortcuts" == "true" ]] ) && includeScriptList+=( "ai/dataset"/format-special.sh )

	[[ "$enUb_ai_dataset" == "true" ]] && includeScriptList+=( "ai/dataset"/here_convert.sh )
	[[ "$enUb_ai_dataset" == "true" ]] && includeScriptList+=( "ai/dataset"/convert.sh )

	[[ "$enUb_ai_dataset" == "true" ]] && includeScriptList+=( "ai/dataset"/corpus_bash.sh )
	[[ "$enUb_ai_dataset" == "true" ]] && includeScriptList+=( "ai/dataset"/corpus.sh )

	[[ "$enUb_ai_semanticAssist" == "true" ]] && includeScriptList+=( "ai/semanticAssist"/here_semanticAssist.sh )
	[[ "$enUb_ai_semanticAssist" == "true" ]] && includeScriptList+=( "ai/semanticAssist"/distill_semanticAssist.sh )
	[[ "$enUb_ai_semanticAssist" == "true" ]] && includeScriptList+=( "ai/semanticAssist"/semanticAssist_bash.sh )
	[[ "$enUb_ai_semanticAssist" == "true" ]] && includeScriptList+=( "ai/semanticAssist"/semanticAssist.sh )

	[[ "$enUb_ai_knowledge" == "true" ]] && includeScriptList+=( "ai"/knowledge.sh )
	
	#[[ "$enUb_dev_heavy" == "true" ]] && 
	includeScriptList+=( "shortcuts/dev"/devsearch.sh )
	
	
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/gnuoctave.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/gnuoctave_extra.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/qalculate.sh )
	( ( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] ) || [[ "$enUb_calculators" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/calculators"/scriptedIllustrator_terminal.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devemacs.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && [[ "$enUb_dev_heavy_atom" == "true" ]] && includeScriptList+=( "shortcuts/dev/app"/devatom.sh )
	
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_java.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_env.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_bin_.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_app.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_example_export.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse_example.sh )
	[[ "$enUb_fakehome" == "true" ]] && [[ "$enUb_abstractfs" == "true" ]] && [[ "$enUb_dev_heavy" == "true" ]] && includeScriptList+=( "shortcuts/dev/app/eclipse"/deveclipse.sh )
	
	includeScriptList+=( "shortcuts/dev/query"/devquery.sh )
	
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope.sh )
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope_here.sh )
	
	# WARNING: Some apps may have specific dependencies (eg. fakeHome, abstractfs, eclipse, atom).
	[[ "$enUb_dev" == "true" ]] && includeScriptList+=( "shortcuts/dev/scope"/devscope_app.sh )

	( [[ "$enUb_github" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/github"/github_removeHTTPS.sh )
	( [[ "$enUb_github" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/github"/github_upload_parts.sh )
	
	( [[ "$enUb_repo" == "true" ]] && [[ "$enUb_git" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/git.sh )
	( [[ "$enUb_repo" == "true" ]] && [[ "$enUb_git" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/gitBare.sh )

	includeScriptList+=( "shortcuts/git"/gitMad.sh )

	includeScriptList+=( "shortcuts/git"/gitBest.sh )
	includeScriptList+=( "shortcuts/git"/wget_githubRelease_internal.sh )
	( [[ "$enUb_github" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/wget_githubRelease_tag.sh )

	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_github" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts"/remoteShortcuts.sh )


	( [[ "$enUb_github" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/git"/gitCompendium.sh )
	
	[[ "$enUb_bup" == "true" ]] && includeScriptList+=( "shortcuts/bup"/bup.sh )
	
	
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/repo/mktorrent"/mktorrent.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_image" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/repo/disk"/dd.sh )
	( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_image" == "true" ]] || [[ "$enUb_repo" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/repo/disc"/growisofs.sh )
	
	
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_search" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/search"/search.sh )
	( [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_search" == "true" ]] ) && includeScriptList+=( "shortcuts/dev/app/search/recoll"/recoll.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/screenScraper"/screenScraper-nix.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/screenScraper"/screenScraper-msw.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self/ubVirt"/ubVirt_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/phpvirtualbox_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/virtualbox_self.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/self"/libvirt_self.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/aws/aws.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/gcloud/gcloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/ibm/ibm.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/oracle/oracle.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service"/azure/azure.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service/vps"/digitalocean/digitalocean.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/service/vps"/linode/linode.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/storage"/aws/aws_s3_compatible.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/storage"/blackblaze/blackblaze.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/croc/croc.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/apacheLibcloud/apacheLibcloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/nubo/nubo.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/rclone/rclone.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/paramiko/paramiko.sh )
	
	includeScriptList+=( "shortcuts/cloud/bridge"/rclone/rclone_limited.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud/bridge"/terraform/terraform.sh )
	
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud"/cloud.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud"/cloud_abstraction.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/docker/docker_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/cloudNativeBuildpack/cloudNativeBuildpack_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/vagrant/vagrant_build.sh )
	
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/_custom/debian/debian_build.sh )
	( [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] ) && includeScriptList+=( "shortcuts/cloud-build"/_custom/gentoo/gentoo_build.sh )
	
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/here_mkboot.sh )
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/mkboot"/mkboot.sh )
	
	[[ "$enUb_notLean" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro"/distro.sh )
	
	[[ "$enUb_QEMU" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/debian"/createDebian.sh )
	[[ "$enUb_image" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/raspbian"/createRaspbian.sh )
	
	[[ "$enUb_msw" == "true" ]] && [[ "$enUb_distro" == "true" ]] && includeScriptList+=( "shortcuts/distro/msw"/msw.sh )
	
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11"/testx11.sh )
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11"/xinput.sh )
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11/clipboard"/x11ClipboardImage.sh )
	
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11"/xscale.sh )
	
	[[ "$enUb_x11" == "true" ]] && includeScriptList+=( "shortcuts/x11/desktop/kde4x"/kde4x.sh )
	
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "shortcuts/vbox"/vboxconvert.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerassets.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerdelete.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercreate.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerconvert.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockerportation.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercontainer.sh )
	
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "shortcuts/docker"/dockercontainer.sh )
	
	[[ "$enUb_image" == "true" ]] && includeScriptList+=( "shortcuts/image"/gparted.sh )
	( [[ "$enUb_image" == "true" ]] || [[ "$enUb_disc" == "true" ]] ) && includeScriptList+=( "shortcuts/image"/packetDrive.sh )
	
	( [[ "$enUb_image" == "true" ]] || [[ "$enUb_disc" == "true" ]] ) && includeScriptList+=( "shortcuts/image/disc"/pattern_recovery.sh )
	
	
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig_here.sh )
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig.sh )
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/kernelConfig_platform.sh )
	
	[[ "$enUb_linux" == "true" ]] && includeScriptList+=( "shortcuts/linux"/bfq.sh )
}

_compile_bash_shortcuts_setup() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts"/importShortcuts.sh )
	
	includeScriptList+=( "shortcuts"/setupUbiquitous_accessories_here.sh )
	includeScriptList+=( "shortcuts"/setupUbiquitous_accessories.sh )
	
	includeScriptList+=( "shortcuts"/setupUbiquitous_here.sh )
	includeScriptList+=( "shortcuts"/setupUbiquitous.sh )
}

_compile_bash_shortcuts_os() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts/os/unix/nice"/renice.sh )
	includeScriptList+=( "shortcuts/os/unix/systemd"/systemd_cleanup.sh )
}

_compile_bash_bundled() {
	export includeScriptList
	
	
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain"/blockchain.sh )
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain/ethereum"/ethereum.sh )
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "shortcuts/blockchain/ethereum"/ethereum.sh )
	
	[[ "$enUb_blockchain" == "true" ]] && includeScriptList+=( "blockchain/ethereum"/ethereum_parity.sh )
}

_compile_bash_command() {
	[[ "$enUb_command" == "true" ]] && includeScriptList+=( "generic/net/command"/command.sh )
	
	[[ "$enUb_command" == "true" ]] && [[ "$enUb_synergy" == "true" ]] && includeScriptList+=( "generic/net/command/synergy"/here_synergy.sh )
	[[ "$enUb_command" == "true" ]] && [[ "$enUb_synergy" == "true" ]] && includeScriptList+=( "generic/net/command/synergy"/synergy.sh )
}

_compile_bash_user() {
	true
}

_compile_bash_hardware() {
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_x220t" == "true" ]] && includeScriptList+=( "hardware/x220t"/x220_display.sh )
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_w540" == "true" ]] && includeScriptList+=( "hardware/w540"/w540_display.sh )
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_w540" == "true" ]] && includeScriptList+=( "hardware/w540"/w540_fan.sh )
	
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_peripherial" == "true" ]] && includeScriptList+=( "hardware/peripherial/h1060p"/h1060p.sh )
	
	[[ "$enUb_hardware" == "true" ]] && [[ "$enUb_gpd" == "true" ]] && includeScriptList+=( "hardware/gpdWinMini2024_8840U"/gpdWinMini2024_8840U_fan.sh )

	( [[ "$enUb_hardware" == "true" ]] || [[ "$enUb_measurement" == "true" ]] ) && includeScriptList+=( "hardware/measurement"/live_hash.sh )
}

_compile_bash_vars_basic() {
	export includeScriptList
	
	
	#####Basic Variable Management
	includeScriptList+=( "labels"/basicvarLabel.sh )
}

_compile_bash_vars_global() {
	export includeScriptList
	
	includeScriptList+=( "structure"/resetvars.sh )
	
	#Optional, rarely used, intended for overload.
	includeScriptList+=( "structure"/prefixvars.sh )

	#Specialized global variables.
	# No production use (not used by ubiquitous_bash itself). Mostly specific to python virtualization, but could be used for any 'ubiquitous_bash' derivative project which must rebuild (eg. venv, etc) if absolute paths are changed.
	( [[ "$enUb_virt_dumbpath" == "true" ]] || [[ "$enUb_virt_python" == "true" ]] ) && includeScriptList+=( "virtualization/dumbpath"/dumbpath_vars.sh )
	
	#####Global variables.
	includeScriptList+=( "structure"/globalvars.sh )
}

_compile_bash_vars_spec() {
	export includeScriptList
	
	
	[[ "$enUb_machineinfo" == "true" ]] && includeScriptList+=( "special/machineinfo"/machinevars.sh )
	
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/virtvars.sh )
	[[ "$enUb_virt" == "true" ]] && includeScriptList+=( "virtualization"/image/imagevars.sh )
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/sshvars.sh )

	if ( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_image" == "true" ]] || [[ "$enUb_docker" == "true" ]] || [[ "$enUb_virt" == "true" ]] || [[ "$enUb_virt_thick" == "true" ]] || [[ "$enUb_virt_translation" == "true" ]] || [[ "$enUb_virt_translation_gui" == "true" ]] )
	then
		includeScriptList+=( "virtualization"/wsl2vars.sh )
	fi
	
	
	includeScriptList+=( "structure"/specglobalvars.sh )
}

_compile_bash_vars_shortcuts() {
	export includeScriptList
	
	includeScriptList+=( "shortcuts/git"/gitVars.sh )
}

_compile_bash_vars_virtualization() {
	export includeScriptList
	
	
	[[ "$enUb_fakehome" == "true" ]] && includeScriptList+=( "virtualization/fakehome"/fakehomevars.sh )
	[[ "$enUb_vbox" == "true" ]] && includeScriptList+=( "virtualization/vbox"/vboxvars.sh )
	[[ "$enUb_docker" == "true" ]] && includeScriptList+=( "virtualization/docker"/dockervars.sh )
}

_compile_bash_vars_bundled() {
	export includeScriptList
	
	
	[[ "$enUb_proxy" == "true" ]] && includeScriptList+=( "generic/net/proxy/ssh"/sshvars.sh )
}

_compile_bash_buildin() {
	export includeScriptList
	
	[[ "$enUb_build" == "true" ]] && includeScriptList+=( "generic/hello"/hello.sh )
	
	# ATTENTION: Running while X11 session is idle is a common requirement for a daemon.
	[[ "$enUb_build" == "true" ]] && [[ "$enUb_x11" == "true" ]] && includeScriptList+=( "generic/process"/idle.sh )
	
	[[ "$enUb_build" == "true" ]] && includeScriptList+=( "structure"/build.sh )
}

_compile_bash_environment() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/localfs.sh )
	
	includeScriptList+=( "structure"/localenv.sh )
	includeScriptList+=( "structure"/localenv_prog.sh )
}

_compile_bash_installation() {
	export includeScriptList
	
	includeScriptList+=( "structure"/installation.sh )
	includeScriptList+=( "structure"/installation_prog.sh )
}

_compile_bash_program() {
	export includeScriptList
	
	
	includeScriptList+=( core.sh )
	
	includeScriptList+=( "structure"/program.sh )
}

_compile_bash_config() {
	export includeScriptList
	
	
	#####Hardcoded
	includeScriptList+=( "_config"/netvars.sh )
}

_compile_bash_selfHost() {
	export includeScriptList
	
	
	#####Generate/Compile
	#if ( [[ "$enUb_buildBashUbiquitous" == "true" ]] || [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_dev" == "true" ]] || [[ "$enUb_dev_heavy" == "true" ]] || [[ "$enUb_cloud_heavy" == "true" ]] || [[ "$enUb_cloud" == "true" ]] || [[ "$enUb_cloud_self" == "true" ]] || [[ "$enUb_cloud_build" == "true" ]] || [[ "$enUb_metaengine" == "true" ]] || [[ "$enUb_calculators" == "true" ]] )
	#then
		# '_setupUbiquitous', '_setupUbiquitous_accessories_here-python'
		includeScriptList+=( "build/python"/python_lean_here.sh )
		includeScriptList+=( "build/python"/python_lean_here_prog.sh )
	#fi
	
	
	includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitous.sh )
	#[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash/ubiquitous"/discoverubiquitous.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash/ubiquitous"/depsubiquitous.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( deps.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/generate_bash.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/generate_bash_prog.sh )
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/compile_bash.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "build/bash"/compile_bash_prog.sh )
}

_compile_bash_overrides() {
	export includeScriptList
	
	[[ "$enUb_dev_buildOps" == "true" ]] && includeScriptList+=( "build/zSpecial"/build-ops.sh )
	
	includeScriptList+=( "structure"/overrides.sh )
}

_compile_bash_overrides_disable() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/overrides_disable.sh )
}

_compile_bash_entry() {
	export includeScriptList
	
	
	includeScriptList+=( "structure"/entry.sh )
}

_compile_bash_extension() {
	export includeScriptList
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "queue/__build"/deps_queue.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "queue/__build"/compile_queue.sh )
	
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/__build"/deps_meta.sh )
	[[ "$enUb_buildBashUbiquitous" == "true" ]] && includeScriptList+=( "metaengine/__build"/compile_meta.sh )
}

#placehoder, define under "queue/build"
#_compile_bash_queue() {
#	true
#}

#placeholder, define under "queue/build"
#_compile_bash_vars_queue() {
#	true
#}

#placehoder, define under "metaengine/build"
#_compile_bash_metaengine() {
#	true
#}

#placeholder, define under "metaengine/build"
#_compile_bash_vars_metaengine() {
#	true
#}

#Ubiquitous Bash compile script. Override with "ops", "_config", or "_prog" directives through "compile_bash_prog.sh" to compile other work products through similar scripting.
# "$1" == configuration
# "$2" == output filename
# DANGER
#Especially, be careful to explicitly check all prerequsites for _safeRMR are in place.
# DANGER
# Intended only for manual use, or within a memory cached function terminated by "exit". Launching through "$scriptAbsoluteLocation" is not adequate protection if the original script itself can reach modified code!
# However, launching through "$scriptAbsoluteLocation" can be used to run a command within the new version fo the script. Use this capability only with full understanding of this notification. 
# WARNING
#Beware lean configurations may not have been properly tested, and are of course intended for developer use. Their purpose is to disable irrelevant dependency checking in "_test" procedures. Rigorous test procedures covering all intended functionality should always be included in downstream projects. Pull requests welcome.
_compile_bash() {
	_findUbiquitous
	_vars_compile_bash "$2"
	
	#####
	
	_compile_bash_deps "$1"
	_compile_bash_deps_prog "$1"
	
	#####
	
	rm "$progScript" >/dev/null 2>&1
	
	export includeScriptList
	
	if [[ "$1" != "rotten" ]] && [[ "$1" != "rotten"* ]]
	then
		_compile_bash_header
		_compile_bash_header_prog
		_compile_bash_header_program
		_compile_bash_header_program_prog
		
		_compile_bash_essential_utilities
		_compile_bash_essential_utilities_prog
		_compile_bash_utilities
		_compile_bash_utilities_prog
		_compile_bash_utilities_java
		_compile_bash_utilities_python
		_compile_bash_utilities_haskell
		_compile_bash_utilities_virtualization
		_compile_bash_utilities_virtualization_prog
		
		_compile_bash_shortcuts
		_compile_bash_shortcuts_prog
		_compile_bash_shortcuts_setup
		_compile_bash_shortcuts_setup_prog
		
		_compile_bash_shortcuts_os
		
		_compile_bash_bundled
		_compile_bash_bundled_prog
		
		_compile_bash_command
		
		_compile_bash_user
		
		_compile_bash_hardware
		
		
		_tryExec _compile_bash_queue
		
		_tryExec _compile_bash_metaengine
		
		
		_compile_bash_vars_basic
		_compile_bash_vars_basic_prog
		_compile_bash_vars_global
		_compile_bash_vars_global_prog
		_compile_bash_vars_spec
		_compile_bash_vars_spec_prog
		
		_compile_bash_vars_shortcuts
		_compile_bash_vars_shortcuts_prog
		
		_compile_bash_vars_virtualization
		_compile_bash_vars_virtualization_prog
		_compile_bash_vars_bundled
		_compile_bash_vars_bundled_prog
		
		
		_tryExec _compile_bash_vars_queue
		
		_tryExec _compile_bash_vars_metaengine
		
		
		_compile_bash_buildin
		_compile_bash_buildin_prog
		
		
		_compile_bash_environment
		_compile_bash_environment_prog
		
		_compile_bash_installation
		_compile_bash_installation_prog
		
		_compile_bash_program
		_compile_bash_program_prog
		
		
		_compile_bash_config
		_compile_bash_config_prog
		
		_compile_bash_extension
		_compile_bash_selfHost
		_compile_bash_selfHost_prog
		
		
		_compile_bash_overrides
		_compile_bash_overrides_prog
		
		_compile_bash_entry
		_compile_bash_entry_prog
	else
		includeScriptList+=( "generic"/rottenheader.sh )
		#includeScriptList+=( "generic"/minimalheader.sh )
		#includeScriptList+=( "generic"/ubiquitousheader.sh )

		includeScriptList+=( "special"/ingredients.sh )
		
		#includeScriptList+=( "os/override"/override.sh )
		#includeScriptList+=( "os/override"/override_prog.sh )
		
		#includeScriptList+=( "os/override"/override_cygwin.sh )
		#includeScriptList+=( "os/override"/override_wsl.sh )
		
		
		
		#####Essential Utilities
		includeScriptList+=( "labels"/utilitiesLabel.sh )
		includeScriptList+=( "generic/filesystem"/absolutepaths.sh )
		includeScriptList+=( "generic/filesystem"/safedelete.sh )
		includeScriptList+=( "generic/filesystem"/destroylock.sh )
		includeScriptList+=( "generic/filesystem"/moveconfirm.sh )
		includeScriptList+=( "generic/filesystem"/allLogic.sh )
		includeScriptList+=( "generic/process"/timeout.sh )
		#includeScriptList+=( "generic/process"/terminate.sh )
		includeScriptList+=( "generic"/condition.sh )
		includeScriptList+=( "generic"/uid.sh )
		includeScriptList+=( "generic/filesystem/permissions"/checkpermissions.sh )
		#includeScriptList+=( "generic"/findInfrastructure.sh )
		includeScriptList+=( "generic"/gather.sh )
		
		#includeScriptList+=( "generic/filesystem"/internal.sh )
		
		#includeScriptList+=( "generic"/messaging.sh )
		
		includeScriptList+=( "generic"/config/mustcarry.sh )
		
		
		
		
		
		
		
		#####Utilities
		includeScriptList+=( "special"/mustberoot.sh )
		includeScriptList+=( "special"/mustgetsudo.sh )
		
		includeScriptList+=( "special"/uuid.sh )
		
		includeScriptList+=( "generic/process"/embed_here.sh )
		includeScriptList+=( "generic/process"/embed.sh )
		
		includeScriptList+=( "generic/net"/fetch.sh )
		
		includeScriptList+=( "generic"/showCommand.sh )
		includeScriptList+=( "generic"/validaterequest.sh )
		
		includeScriptList+=( "generic"/preserveLog.sh )
		
		
		#( [[ "$enUb_notLean" == "true" ]] || [[ "$enUb_stopwatch" == "true" ]] ) && 
			includeScriptList+=( "instrumentation"/profiling/stopwatch.sh )
		
		
		
		
		#####Shortcuts
		includeScriptList+=( "labels"/shortcutsLabel.sh )
		
		includeScriptList+=( "shortcuts"/importShortcuts.sh )
		
		includeScriptList+=( "shortcuts/prompt"/visualPrompt.sh )
		
		
		includeScriptList+=( "shortcuts"/git/wget_githubRelease_internal.sh )
		
		
		
		
		#####Basic Variable Management
		includeScriptList+=( "labels"/basicvarLabel.sh )
		
		
		includeScriptList+=( "structure"/resetvars.sh )
	
		#Optional, rarely used, intended for overload.
		includeScriptList+=( "structure"/prefixvars.sh )
		
		#####Global variables.
		includeScriptList+=( "structure"/globalvars.sh )
		
		
		includeScriptList+=( "structure"/specglobalvars.sh )
		
		
		includeScriptList+=( "shortcuts/git"/gitVars.sh )
		
		
		
		includeScriptList+=( "structure"/localfs.sh )
		
		includeScriptList+=( "structure"/localenv.sh )
		includeScriptList+=( "structure"/localenv_prog.sh )
		
		
		if [[ "$1" == "rotten_test" ]] || [[ "$1" == "rotten_test"* ]]
		then
			includeScriptList+=( "structure"/installation.sh )
			includeScriptList+=( "structure"/installation_prog.sh )
		fi
		
		if [[ "$1" == "rotten_test-extendedInterface" ]] || [[ "$1" == "rotten"*"-extendedInterface"* ]] || [[ "$1" == "rotten_test-"*"-MSW" ]] || [[ "$1" == "rotten_test-"*"-MSW"* ]]
		then
			# ATTENTION: May split anchor functions to 'setupUbiquitous-anchor.sh' .
			includeScriptList+=( "shortcuts"/setupUbiquitous.sh )
			#_compile_bash_shortcuts_setup
			
			includeScriptList+=( "structure"/program.sh )
			_compile_bash_program
			_compile_bash_program_prog
		fi
		
		
		#####Hardcoded
		#includeScriptList+=( "_config"/netvars.sh )
		
		
		
		includeScriptList+=( "structure"/overrides.sh )
		
		includeScriptList+=( "structure"/overrides_disable.sh )
		
		
		
		includeScriptList+=( "structure"/entry.sh )
	fi
	
	
	
	
	
	_includeScripts "${includeScriptList[@]}"
	
	chmod u+x "$progScript"
	
	
	_tryExecFull _ub_cksum_special_derivativeScripts_write "$progScript"
	
	#if "$progScript" _test > ./compile.log 2>&1
	#then
	#	rm compile.log
	#else
	#	exit 1
	#fi
	
	#"$progScript" _package
	
	# DANGER Do NOT remove.
	exit 0
}
