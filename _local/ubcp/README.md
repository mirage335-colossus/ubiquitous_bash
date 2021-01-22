
MSW compatibility layer for ubiquitous_bash , using a derivative of https://vegardit.github.io/cygwin-portable-installer/ .

Run the installer 'ubcp-cygwin-portable-installer.cmd' on a MSW host, or copy an existing installation to this directory. Then rename 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" .

If a global/user installation is desired, install to 'C:\core\infrastructure\ubcp\' . This will also require renaming the 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" , in that directory.





_
Copying the contents of "overlay" to the 'ubcp' installation directory is recommended. Among other possible corrections, this will disable clearing the command prompt screen after script completion, useful for testing.




_

Recommend commands...

```
_bin _mitigate-ubcp
_bin _package-cygwinOnly

_bin _setup_ubcp
```


# Alternatives

Why not Windows Subsystem for Linux (WSL)?

Maybe someday?

* WSL intended for developers, or end user applications?
* Native WSL and MSW applications launching programs of the other OS 'subsystem'?
* VirtualBox/QEMU management of other 'Virtual Machines' from WSL script?
* GPU/OpenCL acceleration?
* IPC between WSL and native MSW applications?
* Configuration and dependencies?
* Inevitable differences between WSL installations?
* File parameter translation?
* Limitations of WSL 'flavor' of 'network' , '9p' , or perhaps emulated 'ext4' file system for symlinks, FIFO, etc?
* Continued availability?
* Stability of API/ABI for all of the above?

Today.

* Same executable 'anchor' file silently interpertable as both 'batch' and 'bash' scripts, and 'Cygwin Portable'.
* No dependencies beyond the script's own directory, unless specifically desired and tested.
* Automatic override to native MSW programs instead of UNIX/Cygwin programs, when available.
* Native VirtualBox/QEMU is feasible to start and manage new Virtual Machines with most usual '_userVBox' and '_userQemu' features.


# Known Issues

* MSW network drive (or at least _userVBox implementation of it, _userQemu is known to be more compatible) may lack several necessary features - symlinks, correct permissions , etc . To workaround, create a 'package' '.tar.gz' file, and extract to a 'local' copy. Such a package may be created under MSW with the command '_bin _package-cygwinOnly' - which itself uses 'ubcp' . Additionally, mitigation of symlinks may allow somewhat better, though nevertheless imperfect, support for MSW network drive.

* Cygwin startup may take an indeterminate amount of time - typically 3 seconds, perhaps 10 seconds under some documented conditions, or possibly indefinitely if an active directory query may be made. This may cause problems for MSW S3/S5 subscribers, due to the apparent need for 'Azure Active Directory'. Due to apparent lack of '/etc/passwd' and similar files, the portable cygwin installation may not be able to accommodate these users.

* Interactive programs making frequent calls to shell scripts may perform orders of magnitude faster if they make these calls directly from *within* the cygwin environment, rather than launching the cygwin startup sequence with every call.

* Bash scripts under MSW platform may be regarded as a reference implementation for reimplementation (if needed for performance reasons) under another at least equally portable statically compiled programming language - 'c', 'go', or similar. Such a reimplementation should nonetheless use a bash script for its build system, and should provide equivalents for all relevant variables (eg. "$scriptAbsoluteFolder", "$scriptAbsoluteLocation", "$binaryAbsoluteFolder", "$binaryAbsoluteLocation") .



# Reference
https://stackoverflow.com/questions/28410852/startup-is-really-slow-for-all-cygwin-applications
http://grumpyapache.blogspot.com/2013/05/slow-startup-of-cygwin-bash.html
https://sourceware.org/legacy-ml/cygwin/2015-02/msg00245/slowtty.dbx
http://cygwin.1069669.n5.nabble.com/slow-startup-after-upgrade-td115053.html

https://codeburst.io/why-golang-is-great-for-portable-apps-94cf1236f481

https://docs.microsoft.com/en-us/windows/deployment/windows-10-enterprise-e3-overview
