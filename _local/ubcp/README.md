
MSW compatibility layer for ubiquitous_bash , using a derivative of https://vegardit.github.io/cygwin-portable-installer/ .

Run the installer 'ubcp-cygwin-portable-installer.cmd' on a MSW host, or copy an existing installation to this directory. Then rename 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" .

If a global/user installation is desired, install to 'C:\core\infrastructure\ubcp\' . This will also require renaming the 'ubcp_rename-to-enable.cmd" to "ubcp.cmd" , in that directory.



_
Copying the contents of "overlay" to the 'ubcp' installation directory is recommended. Among other possible corrections, this will disable clearing the command prompt screen after script completion, useful for testing.

_

File '_test.bat' is an early multi-platform '_anchor' script, which is compatible with both MSW and UNIX hosts. Behavior will be incompatible and possibly simplified under MSW hosts.

