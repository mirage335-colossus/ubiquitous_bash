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
_picture 'zImage_queue_experiment.jpg' '485px'
_heading2 'Queue Inter-Process Communication'
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
_t 'v3.111

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
	&#39;While bind mounts are dependent on the directory structure of the host machine, volumes are completely managed by Docker.&#39;'
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
current_internal_CompressedFunctions_bytes='11236'
current_internal_CompressedFunctions_cksum='921340258'
current_internal_CompressedFunctions='
/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4YruIHFdAC+ciKYksL89qRi90TdMvSwSEM6J8ipM2rR/Iqc/oYbShD5P+hKgz3ONSu7BhrUf8OSN4oZ8BL1e7m0JQ33pEQs007VTHA7nLczyIuWiilZSo+0zB132
DrV189uAlZ6oqD3MK7bjrSmuGreEaBOC+z5QkGUPIDVaXfJmDg73/A1Y9JqRKxtli7ZDurfX2t/Z3m6RV6ku3LwPHl2qt8/kbWEubRkY3Fl2VTTFWjQ8Z9qfpBK4YyV7fw3X3hcUmN6Fz+u2P8eCSl/fCnNX
HtvGeiwoJbZ3wje2iPvqVhHoy0BMVkEDcSqWo+znkV0BwqE45qLsZQ9IGG1CzglgciwcOU2fdsqKBFC5XA3WYFGg6uZ2q4mvn5jWR+FbeUz7YjupLAvLl7DE+daOBWzzyYeFrcMhDk1QeqOKpv41V0GTTqAm
Z7lRbPrhk3oRY/kBiQGZSfRuxTSmIc1zevrFy6JWcZkCJayU/wQ+XEKdvF51XHH+OYrSuhIxvk6G+Ce0sbTr3GBfVRQYdRpxeOs48xNaEfmBf6GZcWUMx5L3LA4cup19vL4O75JjKbnlJeYdoRCjtcPE7A8S
82KbKVXWm5n1ADflKsnTX3CVTSu7uS4pVXHlludUnC/0dCPIaO2WxpZTXETnBW0SD0f3HTs7UDEzwk7eMHnoe3xk/cdsh16yyG0jPOBLHEqULsotf/cimpgvkZlFxPNFKvrB2sVBDpjr393u8l5sSqQ9L5Vr
QgGi6nBnxhDESgC1fMuEusvr6Sli1rR/+c0ap1SksGpO2TEUmhLB2btBz2JAuC6RRnqPSeJB5e7Ye3lLZgz7qHahujxIhELZ6Ig37WMvcLn/BMoXxtrpqAx3WQEFwPU+GEqAYIYrxdEqdhn0qOFwGCgyeEJJ
gdbgce2tLB6OclmTEikMB54FjT+DGJNkD1VAUhIF5DIOg/X+y4q/5q7mW5hEC7RdTSf9mcV+Oawi/lqsYm3g9S1yYzuSK/RuKucAM/TnwoSnlzl1Vr5xXkXHd2Jda3oBn2a8AyfUk9PHx4wAAsnscajMZxtB
0SM8hSRtrMUZaMTWgVVNNN534belUX9DVn/9NcpJwEEbKZqjiiQuENKnAI8hoMFftqzO3SO/cU6L6fSFon+7iKD7yJ2uWhyBTq6bGE2nF0fbQA73A6ADL4WEU9q78blUdAfBiesXFG3bKxHFvZTRB8PWq8ve
NaLw5Dbvw0aClDGiYExLtHy9+wDyK/r6azYk4nx6ZfVEjg46NDDa8Zlb00GecEss4dY2gRhcqHyYyyWaf2zdg9H8gCvMB6/IbYh2GZQdF1Ti8R72L8LBOIoI/wCWG7pKZi59iKp+T9MOTLlXJdcGpeVfUQmO
1lw1tHMTSEDx9wHCSNdOiLtUTr1MYx1a33NWtL47NYfzKaQ0yHlWk05/vyhQYwNcAeLyHloRy+Dyiu62uG+QvWnvk8vcYrK1F9HDW5/lxpdITG/K6ZdQwB+matM5lopj8Vt7V0hxwOfkqNhPFgm5EyK29EYq
KQWcmO/X3YK0Egw51wOX5K5SQYN31LHfCaqf2Pc/HMT2OdkfWa6TLza2yAeRWkh8h/rguKEnBP3qd+5Qp7P4nektAd5ZnzUrlX4Tz7ppBh8ZA0OUMvtIDlOL7+SVxekThChLQsVU73xDwCyrCtDfClbTKC46
aMzabFrJ2VI3LlkXuLNjuSPDgSxCzYk7KDOyVA8FRpl5Pu5ZeUB2ZWCMQnrYcGgN6d7R5NnaO7QfWv69+MhPCHIEeE7TZ9EhQMBN/SUzakZbZNyX4mUK4d15iwxOAVwFtDr5fA6lScKlNVE8TM/HXmLmYNYh
m2Tz87nuoo4DPiDDHYEfeWgSeI2GFpZj/j9lxqh4oiaBZx9mQm8B2evG+WkPP5zl9Bpsd3RCBo0acvggGeZL5GzLYLwV5G7AGE7q6bMhjI6ZbezS+7Cr4S+Rz+pjLwm98zTEOmlZ9pq/kV0darbA9YLIek6s
VUqmWSMj7er+bGU3mQVOaFx4nyajpK2eJScPrA5ORSfoP7lNb9INsDVqTtAi+bVrI2oMQ++RbQi3avyKe/O4loN8hTRrLiJVgUd5+xMEOhzzjXb5x9rL5yRyT2Px5ddrESvBPpsGxisuzztjgT6jUli914TF
2kQ7UrkZlKjJ+l3sj0+2CnUJrEHeQvG377HVjbPMA6IKN4j/SEkc71rr7snAIHyT5CM8NHb0PHz2zPkJ6KvnTPHggSlqYh2bhvHXWEhvJbgPh5oa3He/x+/dBe4lB704F2UMpScbPMiJdy3esfslLyREMZQx
vNcPUX3AtcEuI6O6YT48Mb2MCPeqvSpLX7kIWP4EIJ2GOFdYLH7BmvSRzl389dB93bWuGcYoykgX34ssfwUfH9o+2O8dNHC8bWE9DGPAkB1AGCEQVUEENkS8dIDMfKyKZABrPJWl9AGgR/Y/+5ksgcnpN4gZ
NwVgpuHyoGeAlB2ITLKYGRgove5XUrX/bVWuQXY00xSZ8jHN7lxJdiNBrZ9hvhfk+EaJivde5//hl2CJKQAVL8YBNmBEReNgEEpUiaYgZcP9IBYNNh9Duv/My03HLttBXd9Q1SnA68D4xMkhsh5Uc2v/d/LY
Xz6n0MYQ6VT1EKoR+JgtABXgFz8tc/h/JHB4MD7fmxhOaZIfoQeVFjwf+JsDMWMPvNprotfktb1tWlBF10g+B0CqZc7Y3XXWUSP/CzP507nAmGlaw3JW0jcwNmAFZAUyP49952SpPpPuDOLXHhNM3S6K6m9S
5dXyuFFvfagXA5G0V9Vfc/ENowsFvL6L2nydfKBCvTIHxFylqSdtRuo0UX1Lgnb6a5dd653AUXY7djSwCyqw3+/1iAoxWZdDP353JM2FPgiphM3WxYKLZXk1ORc27mMSdGvn3lDWIabcLJmGT4zOJpMKBrCT
XGk/wo4huYM71tngAMD6gdGvJrLtn5tcTLNQRQR5vpPk/viGN1yNsjGw8+/Ph8bjdMHidSKdCkc+WAlXCkDtAKAyFAhDkwNuOEbIV5iDTTvCzUJWv+4mOfB8LNvMX4Cl/fSNvfP9NMhAuFFYUJnZ5frtwxD/
QvsDkyKN6nhi/pjYp/HZT/Nz5p48UAMyfOydFIXmDGg0uM5oLcUX/Tsbvq2dvfAZfS6lAZ291ly2UNDaX+ya4R3J++c+pbdU7fsb3UkT32QZDF1BV/HGwsdq1oj4SR14SaA7nUSe/Cfdhon7ovyixh/BskGy
Bq9rXWOsr5RdP+JcRiZdhqjfva98E5z1P3ynTnHgzFSbblAlSytQIJ55Q/WLCXjviRYSAjC2CEuKhO/07oJgdJsSXEUvXlo5oa9hgktCzBH+nEnZ0RPp1oDLK/zYodVeCviKpEcjA2WArr71q3ycDCrdNT0Q
yAeMCD5zKq2WdtCwTuqDs53cNsl/jqy1i2HbPexvNoONQuslUnllc3qTgv3/lmk2Z1uLXl7sryh4/gMqrfwjzhVxeKHuzBO1QDxdw2LkQnJsnxzBwCiuYKxgsmgLPDUpMzlamk3cs2NF0SX/ppDfEuER6QyO
UsbuHq32SrZp25+wMd4xv3MELi5bOXaDFuG9jrNMcCdKCllPnpuQ2eQS5EVkcElZneHcga4nogpfOlO+3jLXNqLSHxmkm/wobkRBlUU2A27FQDKk3McqP1eNKCTUQDNwdekC1e8Gx5fzJn72lS3fLw2IC7K7
UFTFoCR2JP502trLu29lyBdFRSPatPTh74MdMURMyl+m6x/zuWHodc6/foOO9l+9jXIXCvhYmL8I7vgcwHDvVucqNRK2RRvEOGmZ7FpAHaSCjAmIsFWRSrS/e5enc25iAuSczXY7K6F2P3jNtEdpB2A0GzN0
MtmPuC/B54WhrlGruulppRO2MZTMWij98yWc1y/QpkCWNqoptTDc0GtSZpwCTNUwhB97LGXZsYNNTbhcQeMZEGEn4Ivc4h/ru7YS26GGpGxsk87HvrO5HGZ7b3ax2pLs2SI4lLw5EFYFWVsFTVzQQNvHBVLj
o0y0T6FddaymLi8u9cyF9/7SxhdsraPEgn9Ux9e0e1ShqfjceYO4GeRS6UIHWVBw7r8o+08reQ0ODnWR3IZrfR5PoLN2xXtUwMjppiqVCP7AbzyC8y9MSfWxgJExx+OQbgxQvFPsX7amLk5LseHZ8jyQ2P/N
ZuOTZ5NsInxAdAuHG+WlfinbyPixwG0nI+NB3xdSt6T23QdvgtP9F/icYOlK0bCAHxY9EYAGNoO/Oxlq48iPpdfhA/qRoivxwcYku+vb0b+0hI0URFabRmbmoYUArtIK6t3JaYt4PrnzIJh2cXlQZm4n71YE
hFdsrLgVBV6StA5xy2geYXPZGICnp6dd9ERBzT9IxgAXrNAk5uJhqiXvsO+aH0XTkt1GY6qTAvYhlckh0wC5c5a52nf5AzskmoTrYUHpW2OBoDx/xasO9aJS/NAFvi/JhKecOt2oTY/ZAZkFbxCWTeA7nVc2
nqhbOf/lNmndDt8bEeQdowQLkl8oqy2NfE0nf9Lf8+7RiH9UIEOJYsLVrdybrUssudAl5RD74mAiNs+NFE3Se2umb6siJH+ZV6LMRdjlls7wwgB6OLE7vwGoEFaa7xG3LC8iPUtOIxfYvEwl7hARE+dPZxfz
mgTGMaMaORQO9+mdNx6dzDSEwc4p5HtxVvTd/njyihWQraAkBy1AV1TPSPhMICX31wEHsufiI3wh7ktcZUeH/fImhdCz0tk5UkJUhHfRXFmlpUH4UME0SZeEUot8vhO5jPzPBjyZur89lsxTQdbJ45sz3Fzb
RM916Lojz1wrPNlsbotZ0rWXNPgBpwxQqCyJfg9kk9bdpp5EoMRWHLc0OOhx2yw9cAect5wwBY1VOQr7nGpAlIzq4a7zsuB9b5On5XdyNBn+Te4aPtadMFPIHSrAaF0qE+Hk1Qr3YeX6dK4QIWWPlzLYLMQH
zcUTBw6/NeINCYKdNFlvilotYjQ8IJMq/JY1Fltp2YOHSQW8dkjvA+6tR2XPTW0KC/DUnVmCa7jEAd8QJfBlnXclrIiADJNTRkr3Dl53aLSUr3xHst4qc7CWxvNZE98S3krBqW83sA9P2TVI8RqIVODY3znh
QbJLId4Cwu3GndGKTe7MVk3VHq0ak7h+RxDveUf7u2epfdoBSwDL3DGTIfYTvzz7wBJjcZv8+Z6ngyY4wiiqmo8Y2/gfUXfBO5Pcz4X4u9rOCW+7NhhyzbpXmcM1N4GHrF0aA9vkhSbaZ+ktXW4PcUH5WLV5
2ANlT4QGY7OzRISPQg5zZ/7nug279/kPyVw67VpXqYPnxMfqfSVXXG/JFSIr9uKhQZTJvNDlLL3jbtAFEpKTvXDptgQv/kVSoqwxRPyS05liRWyyUAlt80knkDghaRVy8vPfRVrRncmItQH/k9fMTnp9i0aV
BodgjdHeDbPlFFWIBR2iQwQJzuzC0nnxYlrvyo35vMxYofGsp02cTS3nX5BOnP7ALvxFU9kFmvMu03OJMC04ISXxcwTkqal8oFL5BxI1qj5n0Gt3ffcLvDZ3xnDrkaWvasl4Iv3IBy4im3QvdvBiCXxYFBQa
hMepFrEACOi5HOmgm2J88OWlYT4Skckl6KGSNwSHmvbnlO8k20y5tN5qDuegjRM8pG+E3avwOLoYGn1F27TkLtSGjVu4H5/N2nPUMhyOw81dP+ZDo66e1ssIxQDdVArhby2mALE0sSV8lHkKMhACLEaJaEX1
DKf354w8NbgNn2tGKgzfwtSkG4Rbv8cWkzROTkfP3W3OJjQLC9YflxI0jfYx7gkhHegPOxXJ52H/UquIC6XBUtbgZvI82Nc0E3gIdDLTdowb7ihr27EHXgqjpJg8q62LCeiRGhF3cV+dLMxFSz/gT+eBGkmE
ws4ahpboJ5LG9Fhun4OGAXPryJ1anEIpYBmScissdPL0HbzllmHwE+XAVP+pkc/ZvwUplB2C00IXuln3k94qQ4mO4WeYuXYe6CrCKvFBRe/eMEAiS2rjsiM8SU5wrmnsZYyYOwGhiKWlRiiC1hjWphPGjMZ7
vROIalZ1GUm7TszzeaRP54L7FafSezh+vJcP0ukeMuuexKwrkAMe5ffAwcz6geMfacH9qny0kapqNNdb3/oyCR189eH5wpXMOmT2m9VFXgpNlRJJWhj9D4uFYMWb30bMLclHxBYHKZ7cUtcBPvRw/mUXLw1V
YxfJF0hlgmhvp6rDMfkNW0/QNPHgKCzpLTRYmE3x3cyF5al6zbxudRxrXTrwfc3tCHhso1541PxVHY9mkPYH+h/EmRbH0/KIP0d3vGs74/yQD38YYK5VuAj5N8dHjcY8NnCiihF6DMhWIfwBoxCLLl/cXjZ7
bZfrIDxCvwrn9F1Oj63fNc5UeSWG2RCi6kINH1hsUWNcLDZ49BzWRV4qK309BYu7u6x7NOVSlGjdR4Jsj4GCo4Q1Kp35ENAmImM3dr//cG3w6imPCoQv8Hz7zLHteLU9Q4R30d+zuxrf3AHlIYoxrRQN+IGr
8WJWftMeXx083YmLYg6OtXSGx6ZIXSs60jBXy1euLuNPRgxOISc9KtD08zS9/K4t8s5QaDzHQAySL2MRLa0B6NvnmiMjNuhgp+W1VPTtJJj9RgIqW1xLRyaBFP9s8+sYQg6s1QIxK6st7vmS8Hct9hVeGztV
ONMQHCKxZDfuYKSuNDgczAxtG54CF9TPURXFtycNuCX9WIjPk4skMBE2MW4vKdKnG5RKLUgvGSvRPTtN8VogbbVMVEeLOcgV11L3P2sjsSRg978HHuioip/rPbvrPV4X2sOidpDKhQP+reowri7lbW315F4W
mEf8dUqCBoPLA5UC+Wi4vtAKPsSxVYYAGTSRIhvcwtxzFahU3LkrXl6+rlg4iLQLSkUsBnM8Q2mAKmfvgTXg8NuqUSqKJRO+hcrlz7CBMYk4sNJWVMQRUpMThcfzQkORavqi6nSBjEENqzf+L7b6Dj7ulGbT
Ul3lwCiVI9pLCdX9JCU4PYjg4lRY9mKsXJN7dIHjfNPluDq9FO4ACvGv4QjByne32nK9hPJq7NOa4gvrkuc79bTEO9AvIOZUBb6VtKr/Io8Uf8zAh/Agu/qF+tOAZrZOg8DbVSddp5HHEQ7nstdUiiBAq3Q2
t/8p8jq1/C7LqNMRKDnjDaJVCHsMQ3N7sm3Z+ajDyfS5DUIb+apZeFS/ACEd7ZriijkuvGrLfF8hCzPzbUEnrNkNFuw9ve/4BGYBBC6sNhU0dnMMiQ7Bf2AciWDyg225bGPPLz0Ux6hAyV1eF5PpVI1awzEf
UyPbSY/hCy5LSGiu8mXkuexDpsjPb4Fz5xZVKzyeStRir3B7f4q8s6wHLC6KsVQwEvxRnaQe+lHbfwrL9QaBCCOLO4JN65ogPqoRnidoPV74wA+4YX7mZ85oNLg2neOVIFUq3iIXR3jRaIbwL6kbZaPJUlb4
+niIt4rydNt1ujQ1cSdl8getvjx6+1Vi7EK8TOaggxpZV6zlJJYnJ2lWaDqsm5vDbcnJGy76IPnI+mLipMtHmL/Y1wEgibCJA3w31fIxRIzqV8zODIXV8lVF5eX1kkg9TbwaCnXLNIy+jLDBOzqi0jNt/xC/
AoZJCqrICgDhGCGakJhJw8x4cXXpyxE89unxZ0plvJH6v42qqASOi1kqfJJdtKEiHwj/leY60DJNBUOjvwOHbCqsa8Qq5e1dGRwgEY0pLK8DOgkUbbQPCiWlH8hdvyVLKsxLJMp4ahpp4bKNOWjm+IWf9qWp
EgYsKqOJjO4vtfw6Wawo2+nGtPiFKppAqWNZprz3+xhpbuY55cT6ElbhiXbzjMyOXgnSB4MD/d62wT9xvcbC0G+yDO0ZkaKtfWGFj1soLFC7VkOEpzALp95vUHbdHfJj6+Tx/zP2mQLDaEyE+LPHg0lRa49S
3ZsTFEragW3CGoHURWJ9jO+biv9H2MiKqMO2+rYJNivNwpATtvxkEU9iybt3/2YVZyVsjVbUdLrtHleALYg4JKjSH4jK9ajItI8Hd+oXj0fnDuqtYzJgGVCigBxIaNwSM4kyPn/UhP9znjtPi1RubskSuGyi
po5ErUZJ8dy830c2VXugTFylooPaGwMPKU0UfjLukzkp9US6RzJOyrjJVPDypo0rXNbEhUHe1lxXYbPhQ3k4K92Ct0WtdChCkKiQfsXMCDdYT64WbsHdNcBC6ZggBDx6w3lio0XaNhNMQ5P8LBM8vUbTzmDc
8tyv1VtgXX7Oq8+EJ8/JuHb+vFp35DKG14ayxgowqK+sNBTH7Gh0K6YHo/Hz7nVnLybMrwvyabhcul5QQ+tb5OTTvWuTsNh7P48T5P9mKt2twtehUIZNzc2gf/XXeI4xdGyNy0tLp63E2FVkFQr8Pva/mPga
5TwWw7Augd2TXewYO+YuHAHh7iEOmulXPd/LjahC69Wd7q0v996FCv1YAaoSeXTmeSOvmG1DRXeET33AesU5T/fVfqFnwAN4JLcB8s+zAvEdffaPDpQ5NIlcZFwlRUuo573obZ/5wiA7jTXCkrocu3Dn2ipG
YQQ5Lmgjj6zUr29t/b3sJze/iUIJcdu5bI1rzxfeKNu6osUbc8Ay2f97howzBShLqJwlFyXoa6od8QDJHeJ5k5ZwvqfUQfhMPP9eLuzo7oa1REExg5RWDop2AUeZOQj6TxHWdNvFusZwmYPXVbLSF2PGtUyR
bEHn8ikLLwzPy2vEimy0CQ+0zgQpRH67zIqVCkI76ClPI4/4gL2KDwBaiZRhyJvoeQ4Rz+/7FFIhLAr8NZ7ECFMlnHJKaEfR9ozk6AAua3hUC/iWombXuodLv1W28Ewan2fBYR4tPZ2jEGNqOqqlCGT+3tXn
yT54Yj0NYqNG/qyDwKQVPArRVvRFwyDVma7FScap83iVJKxED1cinT89NdLxUyQHRvFTVrQkmcPSn/2NZujesMmAcBZYRkoTghAVNCVDnLUDAMcrOrE8GHr0AlYoQ4clBrJNpAKJeSDeR20bp915fZ43MRV2
THtkYYy1JlvLIRQx3ZfXdn6k9kN2JWrA9RVrzfLqiI1yvN3ySBSl4pfclZpmkUpUrE1en3Tx+LCIgIZJh3Hx5+VJVLcoA42bv/PH/W6WUsc4MVil4a+2t9EW226WflozD6vgvnl1XND6B7AeaOCSsf342nLe
P8evbSb8zphsAESndWmg9QCUVvH5Ta3ZSleHotRa4/Oxiiatim0sg5p1eNughqqYhv4tjMcvV79Kp911nmbEH2lIjVpRRXf7/yGR4nfw1GgMaF+hOOVYTZcNLUFDq5af/gdtH/hnNKsYye6Ojyv8vFGN24BV
n1tbeaHdyA6+94Ut6JX4SljvsA8J0ayai0AwQbC3A+huZqpS/VzMjwGjTR1NC/9jABLAf8QPM0wCKcGxpWOkZf5zTxa0IwonC8+5urnOgot5/ce77/c+gS1UvyyhHl0DNSQkIDQf8qYs+y6abTV/qYC+9yPo
UxOgdPEROs8/BAtmoUjk8H1b6cLaHAF8Ld6wWoPpUS8ulFWu2d54YMWsQ9uZPZlrjiz4yf7VFFuJQXgbGdgfSpqedCzDI6nhzGuyiAUl4bSDjPR2kY2e4wxAH6PdaW7Dh7PDxMvoJLUmwSCRWaSWvIp3ZWnU
tkAwn8smf21xK0O32z/ZZ9uQAFxB84r4Df5//HFlrriA9276rGb1PRrerRRy7Pw6o4TR9nKjzLmXX80flktS5JEYN/zRORxuhz+4d1iM41HpoULF878HEUR5WG4vea3YZi2zJryS/zHdoKBdV9IzBZQhDbH1
GSMXqKnfoL9pd8XcHdK82hHfFO1iL3xXvWdH+FvqR84BG3iYh7eyMKOgzLsnsZmjmF0vuffzKWVTMXSmzvBGXnBRHo3HhUoy3RAROXrSZOlBhRH/IUf2O7xV2dc/xFg6kfDkCVFDT2plGxFiL6UVkBJRubcb
/jvg2CTet9vev5I9hozlFDObBCoo+vqknlH3oLh1QvFMDVWOtTlUcwX7eIiSYP/7oCJtc0fwmbS3Lwej/OghxA/KzaS9gW656K5RdZCOj+79MS4zd0KFy1chRQTEggd59V1/hQ2gGrheG1PmuGzkjo22Mu5j
16PPDUNZ3PMr5CTPETuAGEntZqS+YYcoLBPJbl7IjT99Iv5rfxAjt4/T6IFYRTS2TeWoa6Ju3tsQFKj+0GawAWJpkJhhc6NYLbbWX5Qqqsw6cCvWIutZJ8+IYut1HgklQXDg//7OekXT2aLWiEn5P5r9UUv6
stvqGAIIIPkzc5kQ1eG+oDa5kfO14Wu7GS+5TuF+YLTY6oRoMRwIKnEWfQ4HJiZ9Qmixhq176Bfw1MbeovrBOfJv32aH5myHXVOIbCeOVHtP/iKopWIp5VZTdRYrkH02SC6O70ZKNFxyZaymBcRvP43Llggx
6LTPE5UoKYp67HZXwsmk6TMvdZdbLaDbJamI2VbzQH1P2vh7H7hHfRhgy3hnWYgD1mVTnwkUPLcSvU+nogeYhH/lRji07Id838mcLKK41ezvQQ+c0HxVZDIr8iAczD7enx2ZSOSH7wFLEsvXsEhnIxQc/8Ls
/RnAzPzWc2v93oiry6q6bRONnA9kepaq7/K4e71Dc93bfFJ5yhbufCp0SZynbvvlfR0dqNeubPdhZNcu+nosLhrhHc/wf66YQ90vgYufhf0HYKkqQJvybcjMO/0lymQCwf7LbgChPldeK4EsX6d0bob79iwa
a04tYWz5d+15lsKSCP9MMXcf/Tl9ciTcHSQYI4EfsAR6ZVG4odhdUaa6xhrA6gno6LRPAsErVq8VopY2ofYATmSfyk52cCcwCTO5hn7MUA6OzEciWFzMrLhDgFNUrarXGvZcG7MC0NZoUo+stFEb3Qa96VgY
d3AYO/uXjryasAkX11HmVN4PgbDAKuEGg+zmS6IyACtjQgtWuP2xl/iyfFcM8nj+T6rABncuSQwhUhzSpgRJHbYNzAsQ99q9Im3FtbrkOGHPbKEaZTgdogOA8T3jn+gsEq+TRaYbw8pkoRDmWk22/biOpbjJ
IF6yc76igvTEv8aU6LEP1z7zUqU5+oPnEDw+dLEAAAAAqaLKxO7KgysAAY1B75UGANEudiexxGf7AgAAAAAEWVo='
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


