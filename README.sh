#!/usr/bin/env bash

# Dependencies.
# May need 'ubiquitous_bash.sh" in "$PATH".
# GNU Octave, Qalculate - usually dependency of 'calculator' scripts
# recode - usually dependency of 'markup documentation' scripts
# wkhtmltopdf - may be necessary for accurate conversion from HTML to PDF

# NOTICE: README !
# 
# 
# 
# NOTICE: README !

# CAUTION: As a user, you should have been provided a virtual machine or cloud services to run this script - 'ubiquitous bash' provides functions to ease the use of either and both. An SELinux, AppArmor, unprivileged ChRoot, or similar context may be acceptable as well. Routinely modifying, sharing, and running code, may otherwise put both users and organizations at possibly unnecessary risk.


# Copyright and related rights only waived via CC0 if all specified conditions are met.
# *) EITHER, a single file directly output from 'scriptedIllustrator' (which is GPLv3 licensed), OR, not otherwise claimed under other any copyright license.
# *) Is a documentation script including this message which also predominantly creates or represents markup (eg. 'scriptedIllustrator.sh', 'scriptedIllustrator.html', 'scriptedIllustrator.mediawiki.txt').
# *) NOT part of a program to compress, embed, and assemble, functions and other code (waiver does NOT apply to 'tinyCompiler_scriptedIllustrator.sh' ).

# To the extent possible, related software (ie. 'tinyCompiler_scriptedIllustrator.sh' from 'scriptedIllustrator') remains otherwise copyrighted (ie. GPLv3 license).
# Specifically, please do not use 'scriptedIllustrator' code to distribute unpublished proprietary means of creating 'current_internal_CompressedFunctions' .
# Specifically, please do not misconstrue this copyright waiver to negate any copyright claimed when such a documentation script is part of another project or another copyright notice is present (ie. 'otherwise claimed').

# 'For the avoidance of doubt, any information that you choose to store within your own copy' ... 'remains yours' ... 'using' ... 'to publish content doesn't change whatever rights you may have to that content.'
# Although this project has no relation to TiddlyWiki, as stated above, vaguely similar copyright principles are expected to apply. - https://tiddlywiki.com/static/License.html

#__README_uk4uPhB663kVcygT0q_README__


_document_collect() {
# NOTICE: COLLECT

# Not necessary. Warnings about 'command not found' to 'stderr' will be ignored by script pipelines.
#! type -p 'recode' > /dev/null 2>&1 && recode() { false; }


currentByte=8

RECODE_markup_html_pre_begin=$(_safeEcho "$markup_html_pre_begin" | recode ascii..html)


export current_lorem_ipsum='Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'


# NOTICE: COLLECT
}



_document_main() {
#a
#b
# NOTICE: DOCUMENT
#__HEADER_uk4uPhB663kVcygT0q_HEADER__
_t ' '
_t 'Ubiquitous Bash (public domain, no copyright, CC0)
Multiplatform structured programming middleware.

_ DIRECTORIES _
*) Call script (recursively with new or imported session), files, and other programs from same directory as script location.
*) Safe removal of temporary directories. Process termination trapping - SIGTERM, SIGINT, etc.

_ MODULAR _
*) Create new software projects by &#39;fork&#39; script.
*) Hierarchical dependency declaration. Inclusion of either all or only desired functions and tests.
*) Override at runtime by &#39;_local/ops.sh&#39; and similar files.

_ OPERATING SYSTEM and VIRTUALIZATION _
*) Bootable OS, LiveISO, LiveUSB building and customization simultaneously through ChRoot, rsync, BIOS, UEFI, VirtualBox, Qemu, convertible to/from Docker.
*) Hibernation and/or persistent filesystems within LiveISO, LiveUSB, as native bootable alternative to virtualization provided &#39;save state&#39; or &#39;nonpersistence&#39;.

*) Application virtualization (and graphical applications) through several fallback backends (&#39;_userChRoot&#39;, &#39;_userVBox&#39;, &#39;_userQemu&#39;, &#39;_userDocker&#39;) .
*) Guest program to launch, translated fileparameters, and network filesystem mappings indicated by batch and shell scripts from &#39;hostToGuestISO&#39; temporary CDROM disc file.

*) Groups of virtual machines portability forced by &#39;_labVBox&#39; (notably useful with PFSense to simulate complete WAN network configuration at high fidelity).

*) Consistent apparent location of project directory through &#39;_abstractfs&#39; (notably used by &#39;arduinoUbiquitous&#39; to make firmware builds portable).
*) Home directory portability, and persistence or nonpersistence, forced by &#39;_fakeHome&#39; (notably used by &#39;webClient&#39; to force browser instances).

*) Legacy OS portability through &#39;_winehere&#39; and &#39;_dosbox&#39; .
*) MSW compatibility integrated by portable &#39;ubcp&#39; &#39;ubiquitous bash cygwin portable&#39; and &#39;anchor&#39; &#39;shortcut&#39; batch files simultaneously interpretable as bash script (due to interleaved &#39;comment&#39; characters).

*) Linux Kernel configuration review, tradeoffs, and recommendations (&#39;_kernelConfig_desktop&#39;, &#39;_kernelConfig_mobile&#39;, &#39;_kernelConfig_panel&#39;).
*) Hardware support (eg. &#39;Lenovo x220t&#39;, &#39;Huion h1060p&#39;, etc) .

_ INTER-PROCESS COMMUNICATION _
*) Multiple-input multiple-output directory pipes, triple buffers, and searchable 3D coordinate spaces, interfacing between programs through &#39;MetaEngine&#39; .

*) &#39;Broadcast&#39; software bus &#39;queue&#39; more similar to hardware bus (eg. &#39;CAN bus&#39;, &#39;UART&#39;, &#39;I2C&#39;, etc) emulating &#39;shared pair of wires&#39;.
 *) Pipes automatically recreated through &#39;_demand_broadcastPipe_aggregatorStatic&#39;, &#39;_aggregator_read&#39;, &#39;_aggregator_write&#39; .
 *) Triple buffers directory through &#39;_demand_broadcastPipe_page&#39;, &#39;_page_read&#39;, &#39;_page_write&#39; .
 *) Database IPC through &#39;_db_read&#39;, &#39;_db_write&#39; (may track Virtual Machine or other simulated hardware UART serial ports to connect through software IPC).
 *) Network adapters through &#39;_aggregatorStatic_socket_unix_server&#39;, &#39;_aggregatorStatic_socket_unix_client&#39;, &#39;_aggregatorStatic_socket_tcp_server&#39;, &#39;_aggregatorStatic_socket_tcp_client&#39;, &#39;_page_socket_tcp_server&#39;, &#39;_page_socket_tcp_client&#39;, &#39;_page_socket_unix_server&#39;, &#39;_page_socket_unix_client&#39; .

_ DEV _
*) Situational awareness command-line Bash and Python prompts after &#39;_setupUbiquitous&#39; .
*) Equation solver (&#39;c&#39;, &#39;_clc&#39;) added to Bash and Python prompts after &#39;_setupUbiquitous&#39; (&#39;Qalculate&#39; and &#39;GNU Octave&#39; backends).
*) Python to Bash and Bash to Python bindings with Ubiquitous Bash functions (eg. &#39; print(_getScriptAbsoluteFolder()) &#39; )
*) Build dependencies, compiling, and calling other build systems (eg. cmake).

_ REMOTE _
*) NAT public services and inbound SSH fallbacks. AutoSSH robust configuration, automatic restart, tested over multiple years.
*) SSH automatic multi-path and multi-hop.
*) VNC to existing (ie. &#39;_detect_x11&#39;) and new (ie. &#39;x11vnc&#39;) display sessions, through SSH commands without installed service.

*) Cloud - &#39;rclone&#39;, &#39;aws&#39;, &#39;gcloud&#39;, &#39;digitalocean&#39;, &#39;linode&#39;, etc (notably cloud services may efficiently build, test, and distribute software).


Much more functionality exists than listed here. At approximately ~1500 function declarations, ~20000 lines of shell script code, ~1MB (~1 million characters), years of intense development, and years of thorough testing, Ubiquitous Bash exists to resolve many very significant and substantial software issues.'
_t '


'
_page
_heading1 'Demonstrations'
_heading2 'Situational Awareness Command-Line Bash and Python Prompts'
_t '(pictured right)'
_picture 'zImage_commandPrompt.png' '485px'
_ _picture 'zImage_commandPrompt.png' '45%'
_ _paragraph_begin [
_heading2 'Linux Application Virtualization'
_cells_begin
_cells_row_begin
_cells_speck_begin '460px'
_o '_messagePlain_probe' './ubiquitous_bash.sh _userQemu leafpad ./CC0_license.txt'
_cells_speck_end
_cells_row_end
_cells_end
_ _image 'zImage_userQemu_command_nix.png' '450px'
_ _image 'zImage_userQemu_command_nix.png' '45%'
_ _t ' '
_ _image 'zImage_userQemu_window_nix.png' '450px'
_ _image 'zImage_userQemu_window_nix.png' '45%'
_image 'zImage_userQemu_window_nix.png' '275px'
_ _paragraph_end ]
_ _paragraph_begin [
_heading2 'MSW Application Virtualization'
_ _picture 'zImage_queue_experiment.jpg' '485px'
_cells_begin
_cells_row_begin
_cells_speck_begin '485px'
_o '_messagePlain_probe' './ubiquitous_bash.sh _userVBox notepad.exe ./CC0_license.txt'
_cells_speck_end
_cells_row_end
_cells_end
_ _image 'zImage_userVBox_command_MSW.png' '450px'
_ _t ' '
_ _image 'zImage_userVBox_window_MSW.png' '450px'
_image 'zImage_userVBox_window_MSW.png' '275px'
_ _paragraph_end ]
_ _paragraph_begin [
_heading2 'Queue Inter-Process Communication'
_picture 'zImage_queue_experiment.jpg' '485px'
_ _t '(pictured right, above)'
_t '(pictured right)'
_ _paragraph_end ]
_
_
_ _page
_ _paragraph_begin [
_ _heading2 'Queue Inter-Process Communication'
_ _image 'zImage_queue_experiment_rotated.jpg' '65%'
_ _paragraph_end ]
_heading2 '_test-shell'
_cells_begin
_cells_row_begin
_cells_speck_begin '460px'
_i 'cd' '"$scriptAbsoluteFolder"'
_e_ './ubiquitous_bash.sh' '_test-shell' '2>/dev/null'
_cells_speck_end
_cells_row_end
_cells_end
_t '


'
_page
_heading1 'Examples'
_heading2 'DIRECTORIES, MODULAR'
_heading3 'BOM_designer'
_t 'Hierarchical text-based Bill-of-Materials. Finds all all files with extensions &#39;.lbom.csv&#39;, &#39;.lbom.txt&#39;, &#39;*.lbom&#39; . Compiles a consolidated list.'
_heading3 'gEDA_designer'
_t 'Designer. Extensively automates integration and manufacturing specification files (eg. PDF, CAD model, &#39;gerber&#39;, PCB photolithography masks, etc).'
_heading3 'scriptedIllustrator'
_t 'From shell script to interleaved self-modifying shell script and markup of &#39;html&#39;, &#39;pdf&#39;, &#39;mediawiki&#39;, &#39;markdown&#39;, etc.
https://github.com/mirage335/scriptedIllustrator'
_ _heading3 'extendedInterface'
_ _t 'Physical and Virtual Reality specification (eg. &#39;commonControlScheme&#39;, &#39;referenceImplementations&#39; keybinds). Containment (eg. &#39;JoystickGremlin&#39;, &#39;VoiceAttack&#39;) and interface standardization for relevant MSW applications, likely to increasingly rely on "Ubiquitous Bash" functions.'
_heading2 'OPERATING SYSTEM and VIRTUALIZATION'
_heading3 'arduinoUbiquitous'
_t 'Both &#39;_abstractfs&#39; and &#39;_fakeHome&#39; contain &#39;Arduino&#39;, related programs, and libraries, to create firmware projects with portability comparable to "makefile" or "cmake" projects. External debug tool interfaces (eg. &#39;gdb&#39;, &#39;ddd&#39;) are also integrated.
https://github.com/mirage335/arduinoUbiquitous'
_heading3 'webClient'
_t 'Forces browser profile portability and multi-instance through &#39;_fakeHome&#39;.
https://github.com/mirage335/webClient'
_heading3 'freecad-assembly2'
_t 'FreeCAD assembly2 and a2plus module portability through &#39;_fakeHome&#39;.
https://github.com/mirage335/freecad-assembly2'
_heading3 'kit-raspi'
_t 'RasPi and x64 bootable OS, LiveISO, LiveUSB building and customization mostly through &#39;_chroot&#39;, &#39;cp -a&#39;, &#39;rsync&#39; .
https://github.com/mirage335/ubiquitous_bash/tree/master/_lib/kit/raspi'
_heading2 'INTER-PROCESS COMMUNICATION'
_heading3 'metaBus'
_t 'Reference implementation illustrating connecting multiple programs through &#39;MetaEngine&#39; .
https://github.com/mirage335/metaBus'
_heading2 'DEV'
_heading3 'pcb-ioAutorouter'
_t 'Compiles and contains installation of &#39;pcb&#39; with patch for &#39;autorouter&#39; compatibility.'
_heading2 'REMOTE'
_heading3 'CoreAutoSSH'
_t 'Remote logical network configuration . Automatic SSH multi-path and multi-hop.
https://github.com/mirage335/CoreAutoSSH'
_t '


'
_page
_heading1 'Usage'
_paragraph_begin
_o _messagePlain_probe_noindent './ubiquitous_bash.sh
./ubiquitous_bash.sh _test
./ubiquitous_bash.sh _setup'
_paragraph_end
_paragraph_begin
_t 'Projects using Ubiquitous Bash as a git submodule can be created by &#39;fork&#39; script. Examples of common modifications to such projects are available at &#39;_lib/kit&#39; directory. Project name, and developer name, must be set by editing &#39;fork&#39; script appropriately.'
_o _messagePlain_probe_noindent '# Move &#39;fork&#39; to a different directory and edit appropriately.
./fork'
_paragraph_end
_heading2 'Python'
_paragraph_begin
_o _messagePlain_probe_noindent './ubiquitous_bash.sh _python

print(_getScriptAbsoluteFolder())
_bin("_getAbsoluteFolder .")
_bin("_getAbsoluteLocation .")

_clc(&#39;1 + 2&#39;)
_qalculate(&#39;1 + 2&#39;)
_octave(&#39;1 + 2&#39;)
print(_octave_solve(&#39;(y == x * 2, x)&#39; ))

_bash( &#39;-i&#39; )
_python
exit()
exit
exit()'
_paragraph_end
_t '


'
_heading2 'Support'
_paragraph_begin
_t 'Ubiquitous Bash is supported on an *urgent basis*, nominally *immediate*, due to long established dependability and uses. Any support request will be attended to ASAP. Please do not hesitate to contact maintainer "mirage335" by any means.

Bug reports, feature requests, forks, and especially pull requests, are highly welcome. Please keep in mind "defense in depth" and explicit tests are preferred measures to ensure against regressions. Ubiquitous Bash GitHub repository is monitored frequently if not in real time.'
_paragraph_end
_t '


'
_page
_heading1 'Design'
_paragraph_begin
_t 'Entry points for developers are described here. To understand Ubiquitous Bash, often it will be necessary to search for these bits of shell code in &#39;ubiquitous_bash.sh&#39; or other related files.'
_o _messagePlain_probe_noindent '_findFunction() {
	find . -not -path "./_local/*" -name &#39;*.sh&#39; -type f -size -3000k -exec grep -n "$@" &#39;{}&#39; /dev/null \;
}'
_paragraph_end
_heading2 'DIRECTORIES'
_paragraph_begin
_t 'Script absolute &#39;location&#39;, script absolute &#39;folder&#39;, unique "sessionid", will be set, and temporary directories created, as specified by structure/globalvars.sh .'
_o _messagePlain_probe_noindent 'export sessionid=$(_uid)
export scriptAbsoluteLocation=$(_getScriptAbsoluteLocation)
export scriptAbsoluteFolder=$(_getScriptAbsoluteFolder)
[[ "$tmpSelf" == "" ]] && export tmpSelf="$scriptAbsoluteFolder"
export safeTmp="$tmpSelf""$tmpPrefix"/w_"$sessionid"'
_paragraph_end
_paragraph_begin
_t 'New "sessionid" is commonly obtained to separate temporary directories. Temporary directories are created by &#39;_start&#39;, removed by &#39;_stop&#39;. Process termination signal (eg. SIGTERM, SIGINT) calls &#39;_stop&#39;.'
_o _messagePlain_probe_noindent '_userFakeHome_procedure() {
	export actualFakeHome="$instancedFakeHome"
	export fakeHomeEditLib="false"
	_fakeHome "$@"
}

_userFakeHome_sequence() {
	_start
	
	_userFakeHome_procedure "$@"
	
	_stop $?
}

_userFakeHome() {
	"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"
}

"$scriptAbsoluteLocation" _userFakeHome /bin/true || _stop 1'
_paragraph_end
_heading2 'MODULAR'
_paragraph_begin
_t 'After &#39;fork&#39; script has created a new project, new code may be added to the usual files in the &#39;_prog&#39; directory among other places. These and other desired shell script fragments are &#39;compiled&#39; .
Typical program entry point is usually &#39;_main()&#39; defined through &#39;_prog/program.sh&#39; file.'
_o _messagePlain_probe_noindent './compile.sh'
_paragraph_end
_paragraph_begin
_t 'Another possibility is to edit &#39;lean.sh&#39; directly. Such is strictly monolithic and inconvenient to upgrade, not recommended for most software projects which tend to become quite large rather quickly.'
_o _messagePlain_probe_noindent 'export ub_setScriptChecksum_disable=&#39;true&#39;
#...
#####Entry
#...
_main "$@"'
_paragraph_end
_paragraph_begin
_t 'Any function name with &#39;_&#39; as first character, can be called externally as first parameter to script.'
_o _messagePlain_probe_noindent './ubiquitous_bash.sh _echo echo'
_t '&#39;Complete&#39; &#39;Ubiquitous Bash&#39; &#39;_test&#39; will test (and install for some &#39;Linux&#39; &#39;distributions&#39; ie. &#39;Debian&#39;) such complicated dependencies as &#39;VirtualBox&#39; and &#39;Docker&#39;.'
_o _messagePlain_probe_noindent './ubiquitous_bash.sh _test
./ubiquitous_bash.sh _setup'
_paragraph_end
_t '


'
_page
_heading1 'Version'
_t 'v3.113

Semantic versioning is applied. Major version numbers (v2.x) indicate a compatible API. Minor numbers indicate the current feature set has been tested for usability. Any git commits not tagged with a version number may be technically considered unstable development code. New functions present in git commits may be experimental.

In most user environments, the latest git repository code will provide the strongest reliability guarantees. Extra safety checks are occasionally added as possible edge cases are discovered.'
_t '


'
_heading1 'Conventions'
_t '*) Assign ports in ranges 55000-65499 and 50025-53999 to specialized internal servers with opsauto procedures.
*) Strictly single use ports are by default assigned in range 54000-54999 .'
_t '


'
_page
_heading1 'Safety'
_t '
*) DANGER: Do NOT &#39;open&#39; &#39;loopback&#39; backends (eg. _openImage, _openChRoot, _openVBoxRaw ) as read/write (ie. &#39;edit&#39; instead of &#39;user&#39;) if reboot has occurred while open. Wrong &#39;loopback&#39; &#39;device&#39; may be overwritten. All &#39;loopback&#39; backends are intended ONLY for developers or for building &#39;operating system images&#39;. End-user activity should never cause a call to a loopback device, even indirectly.
 *) Nevertheless, significant safety checks are in place to reduce risk of data loss in any way other than &#39;loopback&#39; &#39;device&#39; conflict. If the specific data referenced by a &#39;loopback&#39; &#39;device&#39; is time-consuming to recreate, consider &#39;_bupStore&#39; as &#39;version control&#39; &#39;backup&#39;.

*) VirtualBox raw image backend is complicated, possibly fallible, and may not be compatible with MSW hosts. End-users should instead use a file converted to &#39;VDI&#39;, with a copy of the &#39;raw&#39; file for Qemu as a fallback if necessary.

*) Cloud backends may still be experimental if workable at all.

*) Docker backends have not proven fundamentally or frequently useful, and thus may not be recently tested for interoperability (eg. with VirtualBox, UEFI, LiveISO, LiveUSB etc).





*) Obviously, safeRMR is not foolproof. Use this function to guard against systematic errors, not carelessness.
*) Test any modifications to safeRMR in a safe place.
*) A few commands and internal functions, eg. "type" and "_timeout", are used to ensure consistent behavior across platforms.
*) Interdependencies between functions within the ubiquitous_bash library may not be documented. Test lean configurations in a safe place.

*) ChRoot based virtualization by itself does not provide any security guarantees, especially under Linux hosts. Destruction of host filesystem is possible, especially for any guest filesystem that has been bind mounted.
*) RasPi image must be closed properly (if opened by chroot) before flashing. Doing so will re-enable platform specific "/etc/ld.so.preload" configuration.
*) Images opened in docker must be closed properly to be bootable.

*) Launching "user" ChRoot as root user has not yet been extensively tested.

*) Shared resource locking (eg. disk images for ChRoot, QEMU, VBox) is handled globally. Do NOT attempt to launch a virtual machine with one backend while still open in another. Likewise, separate virtual machines should be handled as separate projects.

*) Do NOT add empty functions anywhere, as this will cause the script to crash before doing anything. At least include a do-nothing command (ie. /bin/true).

*) Each project using ubiquitous_bash should incorporate it statically. Dynamic system-wide linking with other projects is STRONGLY discouraged. However, projects based upon ubiquitous_bash might be suitable for system-wide installation if designed with this in mind.

*) Anchors pointing at non-existent functions may cause themselves to be executed by the "ubiquitous_bash.sh" script they point to - resulting in an endless loop. However, the worst case scenario is generally limited to user log file spam.





*) WARNING: Do NOT export specimen directories as part of Eclipse projects. ONLY export project files, and reference specimen directories relative to the workspace path variable. Symlinks to temporary and scope directories may not be intended for the recursive copy that would result. New users do not need to worry about this until they know what it means.





*) Atom packages are not necessarily safe for portable operation. At least "Command Toolbar" makes reference to absolute file paths. Atom packages installed with "apm", as would be done for git submodules, also make reference to absolute file paths. Atom cannot be relied upon as a general purpose project specific IDE.
	For "Command Toolbar, a workaround is to delete, and manually edit, "_lib/app/atom/home/.atom/command-toolbar.json" .'
_t '


'
_page
_heading1 'Future Work'
_t '
*) Voice commands using Pocket Sphinx and limited vocabulary. Specifically NOT a &#39;digital assistant&#39;.
*) Voice feedback.

*) Replace all use of &#39;losetup&#39; with &#39;dmsetup&#39; uniquely named &#39;dm-linear&#39; &#39;devices&#39;, after &#39; blockdev --getsz &#39;, as with &#39;packetDrive&#39; .



*) Demonstrate ability to preserve less dependable SSDs (ie. typical SD Cards) by automatically detecting usable &#39;/dev/shm&#39; as "$metaDir" (derived from "$metaTmp") location.

*) Self-contained SAMBA server would provide useful virtualization compatibility guarantees if tightly integrated. QEMU seems to already include a solution using similar methods.

*) Self-contained SSH server (not requiring full virtualization images) would allow full self-testing of SSH procedures.

*) Merge HostedXen, and other related virtualization methods into ubiquitous bash.
*) Support shutdown hooks through init daemons other than systemd.
*) Service/cron installation hooks.

*) Support Xen (xl) as a virtualization backend.
*) Support LXC as a virtualization backend.

*) Integrate AppImage build scripts.

*) Investigate Kubernetes integration - https://kubernetes.io .
*) Investigate HyperKit relevance - https://github.com/moby/hyperkit .
*) Investigate RancherVM relevance - https://github.com/rancher/vm .
*) Investigate LXD relevance - https://www.ubuntu.com/containers/lxd .

*) Document FireJail and AppImage examples.

*) Set up host architecture specific hello binary compilation and switching.

*) Add type check to open/close functions (if not already present), preventing, among other things, collisions between virtualization platforms.

*) Self-hosted snippet manager. Possibly as &#39;Konsole&#39; shortcuts.

*) Graphical DRAKON and/or Blockly/SigBlockly examples.

*) Nested userChRoot in userChRoot . Beware, this bizarre scenario might cause guest corruption, a mess of mounts, or worse.

*) Hard and soft cpu, memory, swap, I/O, and storage limits on all subprocesses independent of full virtualization.

*) Automatically adjust limits and priorities based on system latency impacts correlated to program operation.

*) Demonstrate backgrounding in _main as a means to launch multiple daemonized services under control of a single script instance.



*) MSW(/Cygwin) may benefit from reimplementations as simple &#39;C&#39; programs, due to apparently relatively high CPU usage caused by "bash" script loops under Cygwin. However, due to the absolute portability of &#39;reference&#39; "bash" implementation, expense of any rewrites, and very limited functionality needed by MSW, such should only be done in an unlikely extreme abundance of resources and/or extreme necessity.

*) MSW(/Cygwin) &#39;tripleBuffer&#39; "bash" implementation may benefit from a simple &#39;C&#39; program to create/read/write(/delete) files as shared memory files. A precompiled binary may be usable.

*) Dynamically reading/writing from/to multiple pipes/TCP/sockets (new pipes added/removed without resetting existing pipes) may be possible for a binary C program with multiple threads. Such a binary program must nevertheless be built by &#39;Ubiquitous Bash&#39;, provided with &#39;Ubiquitous Bash&#39; ( _bin/ ) , and architecture overridden by &#39;Ubiquitous Bash&#39; (ie. precompiled binaries for &#39;-amd64&#39; , &#39;-armel&#39; , etc , must be aliased by a single shell script function ).

*) Reference packetization implementation.

*) Reference peripheral identification implementation.

*) Simple one-input-multiple-output shared memory &#39;tripleBuffer&#39; channel to &#39;publish&#39; high performance data streams (eg. VR compositor frames) by most recent page.
'
_t '


'
_page
_heading1 'Known Issues'
_t '
*) Typical TCP/IP and related software cannot be configured for resilience under packet corruption, heavy packet loss, multi-second latency, or address/ap roaming. SSH in particular may fail erratically due to packet corruption. A proxy handling these issues through named pipes and tcpwrappers may not be possible, nor may it be feasible to workaround such SSH failures. Best to upload "$scriptAbsoluteLocation" and call entire function at server side with only one remote SSH command.
https://stackoverflow.com/questions/28643392/bash-scripting-permanent-pipe

*) Some ChRoot mounting functions are in fact generic, and should be renamed as such after audit.
*) Nested virtualization needs further testing and documentation, especially beyond QEMU.
*) ChRoot close function might have a path to exit true while mounts are still active.

*) KWrite under ChRoot may lock up the mounts, preventing _closeChRoot from working. Error messages suggest PulseAudio is not working normally. Nevertheless, cleanup seems to take place through the systemd hook upon shutdown.
*) LeafPad sometimes fails to launch from Docker container, apparently due to X11 issues. Not a problem for all graphical applications apparently (eg. &#39;xmessage&#39;).

*) BashDB is given a "frame 0" command to show large file source code window in emacs "realgud".

*) Order of termination does not strictly seem to preserve parent scripts with uncooperative children, when "_daemonAction" is used to terminate all daemon processes. This has the effect of allowing uncooperative children to interfere with logging and stop processes the parent may need to implement in non-&#39;emergency&#39; situations.

*) SSH over Tor through "_proxyTor_direct" has not been tested as is under MSW/Cygwin hosts. With the adoption of socat instead of netcat, this should be straightforward.

*) An error has been thrown to standard error upon shutdown in some rare cases. Preventative measures are now believed to be effective, however, as the error is intermittent, bug reports are encouraged. Without sufficiently concise and relevant information, this may not be resolvable.
	realpath: .../ubiquitous_bash/w_.../.ssh/.../cautossh: No such file or directory
	find: &#39;.../ubiquitous_bash/w_.../.ssh/.../w_...&#39;: No such file or directory'
_page
_heading1 'Reference'
_paragraph_begin
_t 'https://developer.apple.com/library/content/documentation/Darwin/Conceptual/index.html
https://en.wikipedia.org/wiki/Software_architecture
https://en.wikipedia.org/wiki/Middleware

https://bugs.eclipse.org/bugs/show_bug.cgi?id=122945
https://superuser.com/questions/163957/is-eclipse-installation-portable

https://www.suse.com/support/kb/doc/?id=7007602
https://en.wikipedia.org/wiki/CPU_shielding
https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/cpu-partitioning/irqbalanced
https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/cpu-partitioning/cpusets

https://en.wikipedia.org/wiki/Scene_graph

https://github.com/PipelineAI/pipeline

https://wiki.bash-hackers.org/scripting/obsolete




https://novnc.com/info.html
https://novnc.com/screenshots.html
https://docs.unrealengine.com/en-US/InteractiveExperiences/UMG/UserGuide/WidgetTypeReference/WebBrowser/index.html
https://www.highfidelity.com/blog/vnc-in-vr-synchronized-virtual-desktops-49bc4fc428e7


https://github.com/shellinabox/shellinabox

https://uploadvr.com/virtc-virtual-desktop/


https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-web-client-admin
https://www.youtube.com/watch?v=NYEyyVDsapw


https://en.wikipedia.org/wiki/HashiCorp

https://en.wikipedia.org/wiki/Terraform_(software)
https://www.terraform.io/docs/language/index.html

https://en.wikipedia.org/wiki/Vagrant_(software)

https://learn.hashicorp.com/tutorials/packer/docker-get-started-provision





https://wiki.debian.org/Vagrant
	&#39;Libvirt is a good provider for Vagrant because it&#39;s faster than VirtualBox and it&#39;s in the main repository.&#39;


https://unix.stackexchange.com/questions/297792/how-complex-can-a-program-be-written-in-pure-bash


https://docs.docker.com/engine/admin/volumes/volumes/
	&#39;While bind mounts are dependent on the directory structure of the host machine, volumes are completely managed by Docker.&#39;


https://winaero.com/pin-a-batch-file-to-the-start-menu-or-taskbar-in-windows-10/
	&#39; cmd /c "full path to your batch file" &#39;'
_paragraph_end
_t '


'
_page
_heading1 'Credit'
_paragraph_begin
_t '*) Thanks to "rocky" for workaround to bashdb/emacs issue - https://github.com/realgud/realgud/issues/205#issuecomment-354851601 .'
_paragraph_end
_t '


'
_heading1 'Included Works'
_paragraph_begin
_t '*) MAKEDEV . Obtained from Debian Stretch. For all details, see _presentation/MAKEDEV .
*) GoSu . See https://github.com/tianon/gosu . Binaries and signatures may be included in repository. License, GPLv3 . License text at https://www.gnu.org/licenses/gpl-3.0.en.html .
*) Firefox .

*) geth
*) parity
*) ethminer'
_paragraph_end
_t '


'
_heading1 'Bundle'
_paragraph_begin
_t 'Larger files (eg. emacs configuration, blockchain) are not included with &#39;ubiquitous bash&#39; directly, or as a submodule. If needed, &#39;clone&#39; to &#39;_bundle&#39; directory (which is ignored).
git clone --depth 1 --recursive git@github.com:mirage335/ubiquitous_bash_bundle.git _bundle'
_paragraph_end
_t '


'
_heading1 'Copyright'
_paragraph_begin
_t 'All content in this folder not owned by other authors is intended to be public domain. Other copyright notices may be provided as templates. See license.txt for details.'
_paragraph_end
_t '


'
#__FOOTER_uk4uPhB663kVcygT0q_FOOTER__
# NOTICE: DOCUMENT
#y
#z
echo -e '\n\n'
}



# NOTICE: Overrides - new functions .


# NOTICE: Overrides - new functions .


#####Functions. Some may be from 'ubiquitous bash' .
#_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions
current_internal_CompressedFunctions_bytes="12399"
current_internal_CompressedFunctions_cksum="368845939"
current_internal_CompressedFunctions="
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"
! echo "$current_internal_CompressedFunctions" | base64 -d | xz -d > /dev/null && exit 1
source <( echo "$current_internal_CompressedFunctions" | base64 -d | xz -d )
unset current_internal_CompressedFunctions ; unset current_internal_CompressedFunctions_cksum ; unset current_internal_CompressedFunctions_bytes
# https://github.com/mirage335/scriptedIllustrator
#_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions_uk4uPhB663kVcygT0q_compressedFunctions
! _tiny_criticalDep && exit 1

# Special Global Variables
_tiny_set_strings


#####Import ( 'ubiquitous bash' ) .
# WARNING: Do NOT invoke complicated 'ubiquitous bash' functions directly (ie. call "ubiquitous_bash.sh" as a binary from PATH instead) .
# WARNING: If '--call' parameter is changed, 'trap' conflict may occur in some functions (ie. ( '_test_default' ) .
# Keeps "$scriptAbsoluteLocation" pointing to this script file (not 'ubiquitous_bash.sh' ), intentionally.
# Import of 'ubiquitous_bash.sh' intended ONLY to provide most recent 'message' and similar functions.
#_messagePlain_probe() { return; }
! type -p "ubiquitous_bash.sh" > /dev/null 2>&1 && exit 1
[[ "$ubiquitousBashID" != "uk4uPhB663kVcygT0q" ]] && exit 1
current_script_path=$(type -p "ubiquitous_bash.sh")
[[ ! -e "$current_script_path" ]] && exit 1
! ls -l "$current_script_path" 2>/dev/null | grep 'ubiquitous_bash.sh$' > /dev/null 2>&1 && exit 1
export importScriptLocation=$(_getScriptAbsoluteLocation)
export importScriptFolder=$(_getScriptAbsoluteFolder)
. "$current_script_path" --call
unset current_script_path
#_messagePlain_probe "$scriptAbsoluteLocation"
#exit 0



#a
#b
#c
#__HEADER-scriptCode_uk4uPhB663kVcygT0q_HEADER-scriptCode__
#1
#2
#3



#8
#9
#0
#__FOOTER-scriptCode_uk4uPhB663kVcygT0q_FOOTER-scriptCode__
#x
#y
#z

# NOTICE: Overrides ( 'ops.sh' equivalent ).

_default() {
	local current_deleteScriptLocal
	current_deleteScriptLocal="false"
	[[ ! -e "$scriptLocal" ]] && current_deleteScriptLocal="true"
	
	"$scriptAbsoluteLocation" DOCUMENT > "$scriptAbsoluteLocation".out.txt
	
	_scribble_markdown "$@"
	_scribble_html "$@"
	_scribble_pdf "$@"
	
	
	local currentScriptBasename
	currentScriptBasename=$(basename "$scriptAbsoluteLocation" | sed 's/\.[^.]*$//')
	
	
	rm -f "$currentScriptBasename"_small.pdf > /dev/null 2>&1
	
	# https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file
	#gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$scriptAbsoluteFolder"/"$currentScriptBasename"_small.pdf "$scriptAbsoluteFolder"/"$currentScriptBasename".pdf
	
	# https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file
	#convert -density 150x150 -quality 45 -compress jpeg "$scriptAbsoluteFolder"/"$currentScriptBasename".pdf "$scriptAbsoluteFolder"/"$currentScriptBasename"_small.pdf
	
	
	# https://stackoverflow.com/questions/48411255/how-to-modify-jpeg-compression-in-pdf-files-using-ghostscript
	gs  -dNOPAUSE -dQUIET -dBATCH  -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dUseFlateCompression=true -sOutputFile="$currentScriptBasename"_small.pdf -c "<< /GrayImageDict << /Blend 1 /VSamples [2 1 1 2] /QFactor 4.0 /HSamples [2 1 1 2] >> /ColorACSImageDict << /Blend 1 /VSamples [2 1 1 2] /QFactor 4.0 /HSamples [2 1 1 2] >> >> setdistillerparams " -f "$scriptAbsoluteFolder"/"$currentScriptBasename".pdf
	
	
	rm -f "$currentScriptBasename".pdf
	mv "$currentScriptBasename"_small.pdf "$currentScriptBasename".pdf
	
	[[ ! -e "$currentScriptBasename".pdf ]] && _messagePlain_bad 'bad: fail: pdf'
	
	
	"$scriptAbsoluteFolder"/"$currentScriptBasename".html _test
	
	[[ "$current_deleteScriptLocal" == "true" ]] && rmdir "$scriptLocal" > /dev/null 2>&1
}

# NOTICE: Overrides ( 'ops.sh' equivalent ).


_test() {
	"$scriptAbsoluteLocation" _test_default "$@"
}

if ! [[ "$1" == '_'* ]] && [[ "$1" == 'DOCUMENT' ]]
then
	_document_collect
	_document_main
fi

! [[ "$1" == '_'* ]] && [[ "$1" == 'DOCUMENT' ]] && exit 0
if [[ "$1" == '_'* ]]
then
	"$@"
	exit "$?"
fi



_default "$@"






exit 0
# Append base64 encoded attachment file here.
__ATTACHMENT_uk4uPhB663kVcygT0q_ATTACHMENT__


