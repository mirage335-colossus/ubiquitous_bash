 

Ubiquitous Bash (public domain, no copyright, CC0)
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


Much more functionality exists than listed here. At approximately ~1500 function declarations, ~20000 lines of shell script code, ~1MB (~1 million characters), years of intense development, and years of thorough testing, Ubiquitous Bash exists to resolve many very significant and substantial software issues.




 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Demonstrations _

__ Situational Awareness Command-Line Bash and Python Prompts __

(pictured right)
 '_picture' 'zImage_commandPrompt.png' '485px'

__ Linux Application Virtualization __
 '_cells_begin'
 '_cells_row_begin'
 '_cells_speck_begin' '460px'
[0;37;100m[0;34m ./ubiquitous_bash.sh _userQemu leafpad ./CC0_license.txt [0m[0m
 '_cells_speck_end'
 '_cells_row_end'
 '_cells_end'
 '_image' 'zImage_userQemu_window_nix.png' '275px'

__ MSW Application Virtualization __
 '_cells_begin'
 '_cells_row_begin'
 '_cells_speck_begin' '485px'
[0;37;100m[0;34m ./ubiquitous_bash.sh _userVBox notepad.exe ./CC0_license.txt [0m[0m
 '_cells_speck_end'
 '_cells_row_end'
 '_cells_end'
 '_image' 'zImage_userVBox_window_MSW.png' '275px'

__ Queue Inter-Process Communication __
 '_picture' 'zImage_queue_experiment.jpg' '485px'

(pictured right)

__ _test-shell __
 '_cells_begin'
 '_cells_row_begin'
 '_cells_speck_begin' '460px'
[0;34m  './ubiquitous_bash.sh' '_test-shell' '2>/dev/null' [0m
[0;37;100m# [1;32;46m Sanity... [0m[0m
[0;37;100m# [1;32;46m PASS [0m[0m
[0;37;100m# [1;32;46m Permissions... [0m[0m
[0;37;100m# [1;32;46m PASS [0m[0m
[0;37;100m# [1;32;46m Argument length... [0m[0m
[0;37;100m# [1;32;46m PASS [0m[0m
[0;37;100m# [1;32;46m Absolute pathfinding... [0m[0m
[0;37;100m# [1;32;46m PASS [0m[0m
 '_cells_speck_end'
 '_cells_row_end'
 '_cells_end'

__ VM - Create and Multiplatform __

Virtualization commands (at least &#39;_userVBox&#39;, &#39;_editVBox) may be usable from both GNU/Linux and Cygwin/MSW hosts. Cygwin/MSW hosts should be sufficient for end-user applications under narrow conditions, though such functionality may be more robust and complete from GNU/Linux hosts. Developers using MSW (ie. for VR software reasons) are strongly encouraged to use GNU/Linux guest with nested virtualization as a GNU/Linux host and workstation. At least VMWare Workstation installed at a MSW host can provide nested virtualization compatible with a guest installation of VirtualBox.
[0;37;100m[0;34m export vmSize=24576 [0m[0m
[0;37;100m[0;34m _createRawImage [0m[0m
[0;37;100m[0;34m _img_to_vdi [0m[0m
[0;37;100m[0;34m _userVBox [0m[0m

 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Examples _

__ DIRECTORIES, MODULAR __

___ BOM_designer ___

Hierarchical text-based Bill-of-Materials. Finds all all files with extensions &#39;.lbom.csv&#39;, &#39;.lbom.txt&#39;, &#39;*.lbom&#39; . Compiles a consolidated list.

___ gEDA_designer ___

Designer. Extensively automates integration and manufacturing specification files (eg. PDF, CAD model, &#39;gerber&#39;, PCB photolithography masks, etc).

___ scriptedIllustrator ___

From shell script to interleaved self-modifying shell script and markup of &#39;html&#39;, &#39;pdf&#39;, &#39;mediawiki&#39;, &#39;markdown&#39;, etc.
https://github.com/mirage335/scriptedIllustrator

__ OPERATING SYSTEM and VIRTUALIZATION __

___ arduinoUbiquitous ___

Both &#39;_abstractfs&#39; and &#39;_fakeHome&#39; contain &#39;Arduino&#39;, related programs, and libraries, to create firmware projects with portability comparable to "makefile" or "cmake" projects. External debug tool interfaces (eg. &#39;gdb&#39;, &#39;ddd&#39;) are also integrated.
https://github.com/mirage335/arduinoUbiquitous

___ webClient ___

Forces browser profile portability and multi-instance through &#39;_fakeHome&#39;.
https://github.com/mirage335/webClient

___ freecad-assembly2 ___

FreeCAD assembly2 and a2plus module portability through &#39;_fakeHome&#39;.
https://github.com/mirage335/freecad-assembly2

___ kit-raspi ___

RasPi and x64 bootable OS, LiveISO, LiveUSB building and customization mostly through &#39;_chroot&#39;, &#39;cp -a&#39;, &#39;rsync&#39; .
https://github.com/mirage335/ubiquitous_bash/tree/master/_lib/kit/raspi

__ INTER-PROCESS COMMUNICATION __

___ metaBus ___

Reference implementation illustrating connecting multiple programs through &#39;MetaEngine&#39; .
https://github.com/mirage335/metaBus

__ DEV __

___ pcb-ioAutorouter ___

Compiles and contains installation of &#39;pcb&#39; with patch for &#39;autorouter&#39; compatibility.

__ REMOTE __

___ CoreAutoSSH ___

Remote logical network configuration . Automatic SSH multi-path and multi-hop.
https://github.com/mirage335/CoreAutoSSH




 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Usage _

[0;37;100m[0;34m./ubiquitous_bash.sh[0m
[0;37;100m./ubiquitous_bash.sh _test[0m
[0;37;100m./ubiquitous_bash.sh _setup [0m[0m



Projects using Ubiquitous Bash as a git submodule can be created by &#39;fork&#39; script. Examples of common modifications to such projects are available at &#39;_lib/kit&#39; directory. Project name, and developer name, must be set by editing &#39;fork&#39; script appropriately.
[0;37;100m[0;34m# Move &#39;fork&#39; to a different directory and edit appropriately.[0m
[0;37;100m./fork [0m[0m


__ Python __

[0;37;100m[0;34m./ubiquitous_bash.sh _python[0m

[0;37;100mprint(_getScriptAbsoluteFolder())[0m
[0;37;100m_bin("_getAbsoluteFolder .")[0m
[0;37;100m_bin("_getAbsoluteLocation .")[0m

[0;37;100m_clc(&#39;1 + 2&#39;)[0m
[0;37;100m_qalculate(&#39;1 + 2&#39;)[0m
[0;37;100m_octave(&#39;1 + 2&#39;)[0m
[0;37;100mprint(_octave_solve(&#39;(y == x * 2, x)&#39; ))[0m

[0;37;100m_bash( &#39;-i&#39; )[0m
[0;37;100m_python[0m
[0;37;100mexit()[0m
[0;37;100mexit[0m
[0;37;100mexit() [0m[0m





__ Support __

Ubiquitous Bash is supported on an *urgent basis*, nominally *immediate*, due to long established dependability and uses. Any support request will be attended to ASAP. Please do not hesitate to contact maintainer "mirage335" by any means.

Bug reports, feature requests, forks, and especially pull requests, are highly welcome. Please keep in mind "defense in depth" and explicit tests are preferred measures to ensure against regressions. Ubiquitous Bash GitHub repository is monitored frequently if not in real time.





 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Design _


Entry points for developers are described here. To understand Ubiquitous Bash, often it will be necessary to search for these bits of shell code in &#39;ubiquitous_bash.sh&#39; or other related files.
[0;37;100m[0;34m_findFunction() {[0m
[0;37;100mfind . -not -path "./_local/*" -name &#39;*.sh&#39; -type f -size -3000k -exec grep -n "$@" &#39;{}&#39; /dev/null \;[0m
[0;37;100m} [0m[0m


__ DIRECTORIES __


Script absolute &#39;location&#39;, script absolute &#39;folder&#39;, unique "sessionid", will be set, and temporary directories created, as specified by structure/globalvars.sh .
[0;37;100m[0;34mexport sessionid=$(_uid)[0m
[0;37;100mexport scriptAbsoluteLocation=$(_getScriptAbsoluteLocation)[0m
[0;37;100mexport scriptAbsoluteFolder=$(_getScriptAbsoluteFolder)[0m
[0;37;100m[[ "$tmpSelf" == "" ]] && export tmpSelf="$scriptAbsoluteFolder"[0m
[0;37;100mexport safeTmp="$tmpSelf""$tmpPrefix"/w_"$sessionid" [0m[0m



New "sessionid" is commonly obtained to separate temporary directories. Temporary directories are created by &#39;_start&#39;, removed by &#39;_stop&#39;. Process termination signal (eg. SIGTERM, SIGINT) calls &#39;_stop&#39;.
[0;37;100m[0;34m_userFakeHome_procedure() {[0m
[0;37;100mexport actualFakeHome="$instancedFakeHome"[0m
[0;37;100mexport fakeHomeEditLib="false"[0m
[0;37;100m_fakeHome "$@"[0m
[0;37;100m}[0m

[0;37;100m_userFakeHome_sequence() {[0m
[0;37;100m_start[0m

[0;37;100m_userFakeHome_procedure "$@"[0m

[0;37;100m_stop $?[0m
[0;37;100m}[0m

[0;37;100m_userFakeHome() {[0m
[0;37;100m"$scriptAbsoluteLocation" _userFakeHome_sequence "$@"[0m
[0;37;100m}[0m

[0;37;100m"$scriptAbsoluteLocation" _userFakeHome /bin/true || _stop 1 [0m[0m


__ MODULAR __


After &#39;fork&#39; script has created a new project, new code may be added to the usual files in the &#39;_prog&#39; directory among other places. These and other desired shell script fragments are &#39;compiled&#39; .
Typical program entry point is usually &#39;_main()&#39; defined through &#39;_prog/program.sh&#39; file.
[0;37;100m[0;34m./compile.sh [0m[0m



Another possibility is to edit &#39;lean.sh&#39; directly. Such is strictly monolithic and inconvenient to upgrade, not recommended for most software projects which tend to become quite large rather quickly.
[0;37;100m[0;34mexport ub_setScriptChecksum_disable=&#39;true&#39;[0m
[0;37;100m#...[0m
[0;37;100m#####Entry[0m
[0;37;100m#...[0m
[0;37;100m_main "$@" [0m[0m



Any function name with &#39;_&#39; as first character, can be called externally as first parameter to script.
[0;37;100m[0;34m./ubiquitous_bash.sh _echo echo [0m[0m

&#39;Complete&#39; &#39;Ubiquitous Bash&#39; &#39;_test&#39; will test (and install for some &#39;Linux&#39; &#39;distributions&#39; ie. &#39;Debian&#39;) such complicated dependencies as &#39;VirtualBox&#39; and &#39;Docker&#39;.
[0;37;100m[0;34m./ubiquitous_bash.sh _test[0m
[0;37;100m./ubiquitous_bash.sh _setup [0m[0m





 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Version _
v3.113

Semantic versioning is applied. Major version numbers (v2.x) indicate a compatible API. Minor numbers indicate the current feature set has been tested for usability. Any git commits not tagged with a version number may be technically considered unstable development code. New functions present in git commits may be experimental.

In most user environments, the latest git repository code will provide the strongest reliability guarantees. Extra safety checks are occasionally added as possible edge cases are discovered.




_ Conventions _

*) Assign ports in ranges 55000-65499 and 50025-53999 to specialized internal servers with opsauto procedures.
*) Strictly single use ports are by default assigned in range 54000-54999 .




 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Safety _

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
	For "Command Toolbar, a workaround is to delete, and manually edit, "_lib/app/atom/home/.atom/command-toolbar.json" .




 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Future Work _

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




 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Known Issues _

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
	find: &#39;.../ubiquitous_bash/w_.../.ssh/.../w_...&#39;: No such file or directory

 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Reference _


https://developer.apple.com/library/content/documentation/Darwin/Conceptual/index.html
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
	&#39; cmd /c "full path to your batch file" &#39;





 '_page'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak


_ Credit _


*) Thanks to "rocky" for workaround to bashdb/emacs issue - https://github.com/realgud/realgud/issues/205#issuecomment-354851601 .





_ Included Works _


*) MAKEDEV . Obtained from Debian Stretch. For all details, see _presentation/MAKEDEV .
*) GoSu . See https://github.com/tianon/gosu . Binaries and signatures may be included in repository. License, GPLv3 . License text at https://www.gnu.org/licenses/gpl-3.0.en.html .
*) Firefox .

*) geth
*) parity
*) ethminer





_ Bundle _


Larger files (eg. emacs configuration, blockchain) are not included with &#39;ubiquitous bash&#39; directly, or as a submodule. If needed, &#39;clone&#39; to &#39;_bundle&#39; directory (which is ignored).
git clone --depth 1 --recursive git@github.com:mirage335/ubiquitous_bash_bundle.git _bundle





_ Copyright _


All content in this folder not owned by other authors is intended to be public domain. Other copyright notices may be provided as templates. See license.txt for details.







