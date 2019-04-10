A subset of the ubiquitous bash functionality is offered by the CoreAutoSSH project, which also includes additional documentation.

# Configuration
Configuration of ubiquitous bash SSH functionality can be done through an "ops" file alone.

# Virtual Display
A "Headless Ghost" device is recommended for machines which cannot be attached to real displays for VNC sessions. Performance may be vastly improved, even if all drivers are open source. At least one Intel system is known to have this requirement.

Alternatively, Xorg may be configured by an "xorg.cfg" file, with the xserver-xorg-video-dummy driver installed.

Neither of these workarounds are required if nonpersistent desktops are used. However, these may suffer performance degradation with a few (usually low-power) systems.

# WARNING
Example "ops" provided here is an unconfigured example documenting only available functionality. For a complete, configured, example, compliant to an informal standard suitable for high-fidelity simulation, see the "CoreAutoSSH" project.


# Reference
* https://github.com/mirage335/CoreAutoSSH
* https://lxtreme.nl/blog/headless-x11/
