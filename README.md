Top-level subystem integration framework. Ultimate workaround kit.

Multiplatform structured programming and application virtualization middleware. Architecturally, a suite of functions following a UNIX-like philosophy, compilable to a single dedicated monolithic kernel for completely portable (meta)applications. Emphasis on mitigating lock-in.

For new applications and shell feature extension, provides directory containment, network resource allocation, script self-function access/recursion/overloading/instancing, interprocess communication, process/pid/daemon management, unit testing, dependency checking, and build/compile automation. For existing applications, provides application virtualization "swiss army knife" features, including fileparameter translation, through multiple virtualization platforms.

"While bind mounts are dependent on the directory structure of the host machine, volumes are completely managed by Docker."
- https://docs.docker.com/engine/admin/volumes/volumes/

# Blockchain

Continued integration of Ethereum, other blockchain related applications, and command shortcuts, into the Ubiquitous Bash framework, is expected to improve scalability and portability, especially when integrating these resources with other applications. A single software package, portable as a single directory of files, without full virtualization, could integrate functionality from Ethereum, Bitcoin, other blockchains such as IOTA, and miners, as well as applications like GPG, Bittorrent, and Tor, along with clients to services like AWS, GitHub, DropBox, and generic SSH. One use case may be to include isolating different proof-of-work, or reputation schemes, to temporary, private, or reputation based currencies to be recorded in bulk as large balance transfers to Ethereum. Scalability could thereby improve to integrate Ethereum functionality with real-time applications, embedded hardware, and industrial systems such as 3D printers.

Besides blockchain applications themselves, database and development environments are a relevant high priority. Graceful degradation from maximum-performance C objects (or similar) to a self-contained SQL server, to version controlled storage, and beyond, is needed to integrate information from diverse sources. Especially, this may be helpful to analyze simulated test cases of real network software interactions. Complete inspection and tracing of source code, from hardware upwards, is needed to create and assert absolutely optimized solutions more quickly.

# USAGE

https://rawgit.com/mirage335/ubiquitous_bash/master/USAGE.html

Please see "USAGE.html" TiddlyWiki file for extensive command, API, and hiearchial documenatation.

Projects incorporating the ubiquitous bash middleware should, as a best practice, import as a git submodule, then overload functions as required. Consider using the "fork" script to automatically create new projects, or see "USAGE.html" for details.

# Support

Immediate attention will be given to any support request. Please do not hesitate to contact maintainer mirage335 by any means.

Bug reports, feature requests, forks, and especially pull requests, are highly welcome. Please keep in mind "defense in depth" and explicit tests are preferred measures to ensure against regressions. Ubiquitous Bash GitHub repository is monitored in real time.

# Version
v3.101

Semantic versioning is applied. Major version numbers (v2.x) indicate a compatible API. Minor numbers indicate the current feature set has been tested for usability. Any git commits not tagged with a version number may be technically considered unstable development code. New functions present in git commits may be experimental.

In most user environments, the latest git repository code will provide the strongest reliability guarantees. Extra safety checks are occasionally added as possible edge cases are discovered.

# Conventions
* Assign ports in ranges 55000-65499 and 50025-53999 to specialized internal servers with opsauto procedures.
* Strictly single use ports are by default assigned in range 54000-54999 .

# Included Works
* MAKEDEV . Obtained from Debian Stretch. For all details, see _presentation/MAKEDEV .
* GoSu . See https://github.com/tianon/gosu . Binaries and signatures may be included in repository. License, GPLv3 . License text at https://www.gnu.org/licenses/gpl-3.0.en.html .
* Firefox .

* geth
* parity
* ethminer

# Safety
* WARNING: Do NOT export specimen directories as part of Eclipse projects. ONLY export project files, and reference specimen directories relative to the workspace path variable. Symlinks to temporary and scope directories may not be intended for the recursive copy that would result. New users do not need to worry about this until they know what it means.

# Likely Problems
* Atom packages are not necessarily safe for portable operation. At least "Command Toolbar" makes reference to absolute file paths. Atom packages installed with "apm", as would be done for git submodules, also make reference to absolute file paths. Atom cannot be relied upon as a general purpose project specific IDE.
	For "Command Toolbar, a workaround is to delete, and manually edit, "_lib/app/atom/home/.atom/command-toolbar.json" .

# Credit
* Thanks to "rocky" for workaround to bashdb/emacs issue - https://github.com/realgud/realgud/issues/205#issuecomment-354851601 .

# Future Work
* Demonstrate backgrounding in _main as a means to launch multiple daemonized services under control of a single script instance.

* Portable Cygwin installation for MSW hosts.

* Self-contained SAMBA server would provide useful virtualization compatibility guarantees if tightly integrated. QEMU seems to already include a solution using similar methods.

* Self-contained SSH server (not requiring full virtualization images) would allow full self-testing of SSH procedures.

* Merge HostedXen, and other related virtualization methods into ubiquitous bash.
* Support shutdown hooks through init daemons other than systemd.
* Service/cron installation hooks.

* ChRoot alternative to "/etc/skel" copying, involving bind or union mounts to /home/user .

* Support Xen (xl) as a virtualization backend.
* Support LXC as a virtualization backend.

* Integrate AppImage build scripts.

* Investigate Kubernetes integration - https://kubernetes.io .
* Investigate HyperKit relevance - https://github.com/moby/hyperkit .
* Investigate RancherVM relevance - https://github.com/rancher/vm .
* Investigate LXD relevance - https://www.ubuntu.com/containers/lxd .

* Document FireJail and AppImage examples.

* Set up host architecture specific hello binary compilation and switching.

* Add type check to open/close functions, preventing, among other things, colisions between virtualization platforms.

* Self-hosted debugger and snippet manager.
* Graphical DRAKON and/or Blockly/SigBlockly examples.

* Nested userChRoot in userChRoot . Beware, this bizarre scenario might cause guest corruption, a mess of mounts, or worse.

* Hard and soft cpu, memory, swap, I/O, and storage limits on all subprocesses independent of full virtualization.
* Automatically adjust limits and priorities based on system latency impacts correlated to program operation.

* Voice commands using Pocket Sphinx and limited vocabulary. Specifically NOT a 'digital assistant'.
* Voice feedback.

# Known Issues

* Typical TCP/IP and related software cannot be configured for resilience under packet corruption, heavy packet loss, multi-second latency, or address/ap roaming. A proxy handling these issues through named pipes and tcpwrappers
https://stackoverflow.com/questions/28643392/bash-scripting-permanent-pipe

* Some ChRoot mounting functions are in fact generic, and should be renamed as such after audit.
* Nested virtualization needs further testing and documentation, especially beyond the QEMU.
* ChRoot close function might have a path to exit true while mounts are still active.

* KWrite under ChRoot may lock up the mounts, preventing _closeChRoot from working. Error messages suggest PulseAudio is not working normally. Nevertheless, cleanup seems to take place through the systemd hook upon shutdown.
* LeafPad sometimes fails to launch from Docker container, apparently due to X11 issues.

* BashDB is given a "frame 0" command to show large file source code window in emacs "realgud".

* Order of termination does not strictly seem to preserve parent scripts with uncooperative children, when "_daemonAction" is used to terminate all daemon processes. This has the effect of allowing uncooperative children to interfere with logging and stop processes the parent may need to implement in non-emergency situations.

* SSH over Tor through "_proxyTor_direct" has not been tested as is under MSW/Cygwin hosts. With the adoption of socat instead of netcat, this should be straightforward.

* An error has been thrown to standard error upon shutdown in some rare cases. Preventative measures are now believed to be operational, however, as the error is intermittent, bug reports are encouraged.
	realpath: .../ubiquitous_bash/w_.../.ssh/.../cautossh: No such file or directory
	find: ‘.../ubiquitous_bash/w_.../.ssh/.../w_...’: No such file or directory

# API Plan

* Currently, "gatewayName" default is 'gw-"$netName"' . This will change to 'gw-"$netName"-"$netName"' as already updated in "netvars.sh" and "ops" example files for CoreAutoSSH usage. The new format allows automatic selection of correct default gateway for autossh, while ensuring uniqueness if the configuration text is reused elsewhere.


# WARNING

* Obviously, safeRMR is not foolproof. Use this function to guard against systematic errors, not carelessness.
* Test any modifications to safeRMR in a safe place.
* A few commands and internal functions, eg. "type" and "_timeout", are used to ensure consistent behavior across platforms.
* Interdependencies between functions within the ubiquitous_bash library may not be documented. Test lean configurations in a safe place.

* ChRoot based virtualization by itself does not provide any security guarantees, especially under Linux hosts. Destruction of host filesystem is possible, especially for any guest filesystem that has been bind mounted.
* RasPi image must be closed properly (if opened by chroot) before flashing. Doing so will re-enable platform specific "/etc/ld.so.preload" configuration.
* Images opened in docker must be closed properly to be bootable.

* Launching "user" ChRoot as root user has not yet been extensively tested.

* Shared resource locking (eg. disk images for ChRoot, QEMU, VBox) is handled globally. Do NOT attempt to launch a virtual machine with one backend while still open in another. Likewise, separate virtual machines should be handled as separate projects.

* Do NOT add empty functions anywhere, as this will cause the script to crash before doing anything. At least include a do-nothing command (ie. /bin/true).

* Each project using ubiquitous_bash should incorporate it statically. Dynamic system-wide linking with other projects is STRONGLY discouraged. However, projects based upon ubiquitous_bash might be suitable for system-wide installation if designed with this in mind.

* Anchors pointing at non-existent functions may cause themselves to be executed by the "ubiquitous_bash.sh" script they point to - resulting in an endless loop. However, the worst case scenario is generally limited to user log file spam.

# Copyright
All content in this folder not owned by other authors is intended to be public domain. Other copyright notices may be provided as templates. See license.txt for details.

# Reference
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

