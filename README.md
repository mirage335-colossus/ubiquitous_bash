
Multiplatform structured programming and application virtualization middleware. Architecturally, a dedicated monolithic kernel for (meta)applications.

For new applications and shell feature extension, provides directory containment, network resource allocation, script self-function access/recursion/overloading/instancing, interprocess communication, process/pid/daemon management, unit testing, dependency checking, and build/compile automation. For existing applications, provides application virtualization features, including fileparameter translation, through multiple virtualization platforms.

# USAGE

https://rawgit.com/mirage335/ubiquitous_bash/master/USAGE.html

Please see "USAGE.html" TiddlyWiki file for extensive command, API, and hiearchial documenatation.

Projects incorporating the ubiquitous bash middleware should, as a best practice, import as a git submodule, then overload functions as required. Consider using the "fork" script to automatically create new projects, or see "USAGE.html" for details.

# Support

Immediate attention will be given to any support request. Please do not hesitate to contact maintainer mirage335 by any means.

Bug reports, feature requests, forks, and especially pull requests, are highly welcome. Ubiquitous Bash GitHub repository is monitored in real time.

# Version
v2.1

Semantic versioning is applied. Major version numbers (v2.x) indicate a compatible API. Minor numbers indicate the current feature set has been tested for usability. Any git commits not tagged with a version number may be technically considered unstable development code. New functions present in git commits may be experimental.

In most user environments, the latest git repository code will provide the strongest reliability guarantees. Extra safety checks are occasionally added as possible edge cases are discovered.

# Future Work
* Merge IQEmu, Wine Bottle, Portable DoxBox, HostedXen, VirtualBox, and other related virtualization methods into ubiquitous bash.
* Support shutdown hooks through init daemons other than systemd.
* Service/cron installation hooks.


# WARNING

* Obviously, safeRMR is not foolproof. Use this function to guard against systematic errors, not carelessness.
* Test any modifications to safeRMR in a safe place.
* A few commands and internal functions, eg. "type" and "_timeout", are used to ensure consistent behavior across platforms.
* Interdependencies between functions within the ubiquitous_bash library may not be documented. Test lean configurations in a safe place.

* ChRoot based virtualization by itself does not provide any security guarantees, especially under Linux hosts. Destruction of host filesystem is possible, especially for any guest filesystem that has been bind mounted.
* RasPi image must be closed properly (if opened by chroot) before flashing. Doing so will re-enable platform specific "/etc/ld.so.preload" configuration.

* Launching "user" ChRoot as root user has not yet been extensively tested.

* Do NOT add empty functions anywhere, as this will cause the script to crash before doing anything. At least include a do-nothing command (ie. /bin/true).

# Copyright
All content in this folder not owned by other authors is intended to be public domain. Other copyright notices may be provided as templates. See license.txt for details.

# Reference
[1] https://developer.apple.com/library/content/documentation/Darwin/Conceptual/index.html
https://en.wikipedia.org/wiki/Software_architecture
https://en.wikipedia.org/wiki/Middleware
