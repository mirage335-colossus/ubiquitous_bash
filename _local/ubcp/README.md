
MSW compatibility layer for ubiquitous_bash , using a derivative of https://vegardit.github.io/cygwin-portable-installer/ .

Run the installer 'ubcp-cygwin-portable-installer.cmd' on a MSW host, or copy an existing installation to this directory. Then rename 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" .

If a global/user installation is desired, install to 'C:\core\infrastructure\ubcp\' . This will also require renaming the 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" , in that directory.



_
Copying the contents of "overlay" to the 'ubcp' installation directory is recommended. Among other possible corrections, this will disable clearing the command prompt screen after script completion, useful for testing.

_

File '_test.bat' is an early multi-platform '_anchor' script, which is compatible with both MSW and UNIX hosts. Behavior will be incompatible and possibly simplified under MSW hosts.




_

# Known Issues

* Cygwin startup may take an indeterminate amount of time - typically 3 seconds, perhaps 10 seconds under some documented conditions, or indefinitely if an active directory may be made.

* Bash scripts under MSW platforms may be regarded as a reference implementation for reimplementation under another at least equally portable statically compiled programming language - 'c', 'go', or similar. Such a reimplementation should nonetheless use a bash script for their build system.


# Reference
https://stackoverflow.com/questions/28410852/startup-is-really-slow-for-all-cygwin-applications
http://grumpyapache.blogspot.com/2013/05/slow-startup-of-cygwin-bash.html
https://sourceware.org/legacy-ml/cygwin/2015-02/msg00245/slowtty.dbx
http://cygwin.1069669.n5.nabble.com/slow-startup-after-upgrade-td115053.html

https://codeburst.io/why-golang-is-great-for-portable-apps-94cf1236f481
