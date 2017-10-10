As shell glue for massive scale projects, or as a framework for single-purpose scripts, ubiquitous_bash is the quickest path to a robust solution, every time.

Comprehensive multi-threading, instancing, portability, extensibility, and recursion can be achieved with a smaller percentage of 'extra' developer cycles than required to properly test a barely working string of hardcoded dependencies supporting none of these properties. Do not be tempted, take a moment to sort your requirements into fundamental operators.

* Session - start/stop, unique id, create/delete temporary resources.
* Extension - find executable's own location, find neighboring executables, import.
* Arithmetic - add, subtract, multiply, divide.
* Filtering - band-pass, band-stop, low-pass, high-pass, gain, feedback, multi-order.
* Data - Create/Read/Update/Delete (CRUD).
* Processing - Turing Completeness

Recursive calling of the script itself is supported. Absolute path to script, and the directory it resides in, are available for calling related scripts. All temporary files use strongly unique session IDs. Direct command-line access to any internal function is supported for rapid unit testing - "./ubiquitous_bash.sh _setup" .

Intended to be included in other projects as a "git submodule", then compiled into a monolithic script with end-developer definitions for program functions, specifically _main(). Default script execution typically starts near the end of the file, with a call to _main(). Proper use of compiler scripts will result in a completely 'statically linked' executable script file.

# Version
v2.1

# WARNING

* Obviously, safeRMR is not foolproof. Use this function to guard against systematic errors, not carelessness.
* Test any modifications to safeRMR in a safe place.
* A few commands and internal functions, eg. "type" and "_timeout", are used to ensure consistent behavior across platforms.
* Interdependencies between functions within the ubiquitous_bash library may not be documented. Test lean configurations in a safe place.

* ChRoot based virtualization by itself does not provide any security guarantees, especially under Linux hosts. Destruction of host filesystem is possible, especially for any guest filesystem that has been bind mounted.
* RasPi image must be closed properly (if opened by chroot) before flashing. Doing so will re-enable platform specific "/etc/ld.so.preload" configuration.

* Launching ChRoot as root user has not yet been extensively tested.

# Copyright
All content in this folder not owned by other authors is intended to be public domain. Other copyright notices may be provided as templates. See license.txt for details.
