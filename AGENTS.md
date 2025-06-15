
---

BEGIN directory specific "ubiquitous_bash" AGENTS.md , other input may regard other hierarchical directories.


Vast self-example of correct, exhaustively broad UNIX/Linux commands, useful functions, and the framework of shellscript functions, etc, is available at directory '/workspace/ubiquitous_bash' , possibly also under './_lib/ubiquitous_bash' subdirectories of derivatives. Directory containing this AGENTS.md file is itself the 'ubiquitous_bash' repository.


# Mechanisms of "ubiquitous_bash"

Calling './ubiquitous_bash.sh' with a '_function' as the first parameter will call that internal function with remaining parameters given to that function.

## Compiling "ubiquitous_bash and Forked Derivatives

Script 'ubiquitous_bash.sh', etc, is compiled by 'compile.sh' from the framework of most of the shellscript files from the ubiquitous_bash repository. Since these framework shellscript files are concatenated, and are usually not independently executable, a '#!/usr/bin/env bash' header, etc, would cause errors - the '*.sh' filename is mostly used to get correct syntax highlighting in text apps.

Forked derivative projects similarly compile 'ubiquitous_bash.sh' or similarly named scripts from shellscript files in their subdirectories (usually '_prog') as well as the upstream "ubiquitous_bash" framework shellscript files (usually '_lib/ubiquitous_bash'). Shellscript files from the derivative fork project are compiled to a later position in the "ubiquitous_bash" compiled script, overriding same named upstream functions.

## Anchor Shortcut Scripts

Anchor scripts '_anchor.bat', etc, are vaguely equivalent to '.lnk' or '.desktop' shortcut files, calling a function of the same name as their filename basename in the "ubiquitous_bash" compiled script. Both MSWindows batch and UNIX/Linux shell comment characters are interleaved in the first lines of the batch anchor scripts to run as a batch file under MSWindows (calling bash.exe from portable Cygwin environment if needed) and as a bash shell script under UNIX/Linux .

Function _anchor calls several more functions, including a _refresh_anchors function and other functions which may be defined in a forked derivative project to copy the template _anchor and _anchor.bat files after setting a couple of variables with sed commands.


# Development Practices, Style, Tracing, Testing Expectations, Uniquely Necessary for "ubiquitous_bash"

## Sandbox, Harness

Never sandbox , drop root , or otherwise limit any command calling "ubiquitous_bash" scripts or functions , such as './ubiquitous_bash.sh _test' , './app _test' , './_test' , './_test.bat' , './_bin' , './bin.bat' , './ubiquitous_bash.sh _bin' , etc.

Hardcoded platform-specific temporary directory paths , home directories , /tmp temporary subdirectories , /dev/shm temporary subdirectories , root commands , sudo , etc, are all necessary for "ubiquitous_bash" to function . Usually "ubiquitous_bash" either runs within an appropriately limited ephemeral container , dedicated computer , etc, with already appropriately limited capabilities, and enforces its own limits, sanity checks, etc, or "ubiquitous_bash" uses root commands to create a distribution / Operating System for such limited ephemeral situations. In both cases, it is appropriate for "ubiquitous_bash" scripts, commands, functions, etc, to run with root privileges.

Docker containers in particular may be intended to begin with the root user by default , as the situation most expected and supported by the developers of such Docker containers , do not attempt to run commands as a different user or otherwise drop root permissions.

Always run "ubiquitous_bash" scripts, commands, functions, etc, with the permissions of the user running the Codex process, without limits on what directories may be written to, etc.

If such calls as creating a subdirectory of the "$HOME" directory fail, such as  mkdir -p /root/.ubtmp/try  ,  bash -c 'touch /root/.ubtmp/testfile'  failing due to 'Permission denied' , attempt to test whether such limitations as bash shells not having write access to the "$HOME" directory may be obstructing . If such sandboxing may be obstructing, quit and report the issue to the user. Do not continue if sandboxing may be obstructing .


## Robustness, Resilience

Avoid suffering dependency and availability issues by preferring to use commands from external programs, libraries, etc, using not older or abandoned codebases, dependencies, etc, but the more actively developed codepaths. Recently frozen dependencies are more likely still available than dependencies for eventually forked older code. Developers with their own non-reproducible build environments are more likely to notice when freezing dependencies becomes unsustainable or when unfrozen dependencies break things in their own development work.

## Style

Abstraction, randomized temporary directories, process management, recursion, commented code, uncommented self-explanatory code, absence of debugging output, or very verbose default debugging output, can be uniquely appropriate throughout the "ubiquitous_bash" codebase. Keeping many external programs interoperable necessitates some emphasis on rapid reaction to external changes, a relatively thorough, drastic, approach to maintenance, to the point that too many comments or debug output statements can obscure and distract from the structure of the code which a person experienced in such work would see visually in a text editing app at a glance. Too much code or absence of alternative code could also take longer to rewrite, especially if iteration through many rewrites is necessary due to undocumented complexities.

Do not assume "ubiquitous_bash" follows conventional patterns, it doesn't.

## Development Tracing

Temporary changes to shellscripts, adding echo statements, etc, is often necessary to observe progress, detect actual hanging, and diagnose failures, especially with multi-threaded, recursive, etc, scripts. Better to anticipate this and add statements than to waste time terminating an experiment that was not actually hanging.

Tracing ubiquitous_bash shell scripts can be done efficiently with  'export ubDEBUG=true'  , tracing all commands and shell script function calls within a function given as a command line parameter. Setting  'export ubDEBUG=true'  only increases verbosity, echo to STDOUT, etc, will still be called.

## Testing Expectations

Please base your expectations on plausible outcomes from enumerating stepwise processing of plausible inputs through code of relevant functions, etc . Delays are reasonable for such timing sensitive or high latency tests as subsecond sleep commands, inter-process communication, command runtime measurement, etc . Excessive looping is also reasonable as the tests performed may be particularly extreme, catching the slightest changes to syntax over years of new interpreter, compiler, etc, versions. Such looping may in fact be repetitive use of very similar or even the same syntax for testing purposes.

A '_test' function may run successfully for tens of minutes, possibly a few hours, without any output, if the function was written to avoid any commands that could actually hang, and to only output a single message 'Testing...' followed by either 'PASS' if successful, or an exit status with a few error messages from the failed command. Sub-functions called by a larger '_test' function may output only a successful exit status, delegating the 'PASS' message to only be output by the larger '_test' function after other sub-functions have been successful as well. Unusual error messages are made more noticeable by not outputting noisy status messages during sanity tests often used during Continuous Integration and installation. Sanity and dependency tests, etc, far more extensive with "ubiquitous_bash" than with other projects, have proven necessary to detect changes made to software versions such as the bash interpreter.

Keep going through such testing until a definitive result is reached, with a 'PASS' or similar message, an explainable non-error exit status, etc.

An extended or indefinite run is very acceptable as long as information gathering continues and progress does not cease entirely. CPU usage may be either high due to bash shell interpreter overhead testing many conditions or other unusual syntax, or CPU usage may be low due to sleep , etc , intentionally having been put into the script for Inter-Process Communication latency timing, deliberately reducing CPU usage, etc.

Both STDOUT and STDERR may provide useful information, especially if verbosity is increased to assist testing, etc, such as with  'export ubDEBUG=true'  .

## Direct Editing

Although Git Pull Requests should instead edit the underlying files, directly editing the otherwise compiled 'ubiquitous_bash.sh' script is an acceptable technique for testing, diagnosing, experimenting, etc. Disable checksum with  'export ub_setScriptChecksum_disable=true'  to run the script after editing without recompiling.

## Terminology

- procedure
- sequence

- start
- stop

- begin
- end

```bash
_function_procedure() {
    echo "PASS" > "$safeTmp"/status
    #echo "FAIL" > "$safeTmp"/status

    cat "$safeTmp"/status
}

_function_sequence() {
    _start

    _function_procedure "$@"

    _stop
}

"$scriptAbsoluteLocation" _function_sequence "$@"
```


# Documentation Practices, Style, Archetypes

## MultiThreading Inter-Process-Communication

Please regard the MultiThreading documentation at  /workspace/ubiquitous_bash/shortcuts/git/_doc-wget_githubRelease.md  , or similar locations for this file, as a tentative archetype how to generate MultiThreading specific documentation well ordered tabulated with markdown tables readable at a glance for code segments such as at  /workspace/ubiquitous_bash/shortcuts/git/wget_githubRelease_internal.sh  ,  /workspace/ubiquitous_bash/shortcuts/git/wget_githubRelease_tag.sh  , or similar locations for these files .

## Pseudocode Summary

Please regard the semi-pseudocode at  /workspace/ubiquitous_bash/virtualization/python/_doc-override_msw_python.md  , or similar locations for this file, as a tentative archetype how to abbreviate, abridge, minimize, etc, code segments such as at  /workspace/ubiquitous_bash/virtualization/python/override_msw_python.sh  ,  /workspace/ubiquitous_bash/virtualization/python/override_nix_python.sh  , or similar locations for these files .

## Pseudocode Summary - MultiThreaded

Please regard the semi-pseudocode at  /workspace/ubiquitous_bash/shortcuts/git/_doc-wget_githubRelease.md  , or similar locations for this file, as a tentative archetype how to abbreviate, abridge, minimize, etc, code segments such as at  /workspace/ubiquitous_bash/shortcuts/git/wget_githubRelease_internal.sh  ,  /workspace/ubiquitous_bash/shortcuts/git/wget_githubRelease_tag.sh  , or similar locations for these files .


# Notable Forked "ubiquitous_bash" Derivatives

Notable forked derivative projects of ubiquitous_bash include 'ubDistBuild' , 'pumpCompanion' , 'coreoracle' , 'arduinoUbiquitous' .


# Submodules of "ubiquitous_bash"

Unusual resources kept as independent submodules of the "ubiquitous_bash" repository:

- _lib/kit/app/researchEngine     Documentation, shellscript functions, etc, specially for AI LLM models, search, etc, to gather knowledge, create complex algorithms, etc.
- _lib/.python_wheels     Essential usually tiny python wheels, scripts to download, etc.





# Notable "ubiquitous_bash" Framework Subdirectories



## _bin

Binary executable programs (usually statically compiled, etc) - gosu , hello world , etc .

## _bundle

Large files , possibly some or all moved to a separate repository to reduce repository size .

## _config

Script files compiled in with device, user, etc, specific variables, such as hostname , logical network name , etc .



## build

Compile, compiler dependency manager, etc, for programming languages.

### build/bash
Shellscripts compiled into 'compile.sh' itself to compile 'ubiquitous_bash.sh', etc, itself .

## structure

Sections of "ubiquitous_bash" scripts to call function from first command line parameter to script, set global variables "$sessionid" , "$safeTmp" , etc , _test , _setup , _start , _stop , etc .

## os

Set functions, aliases, etc, to call programs outside default "$PATH" , scripts to install dist/OS packages as needed to provide required binary programs.



## ai

Inferencing AI LLM, installing AI software, generate AI outputs (eg. 'semanticAssist' ) .

## generic

Functions usually used by other functions, by a 'ubiquitous_bash.sh' script itself, etc (eg. includes the random _uid function used to create "$sessionid" used to create "$safeTmp" ) .

## hardware

Device hardware management functions (eg. 'live_hash.sh' , 'x220_display.sh' ) .

## instrumentation

Trace or characterize non-verbose software (eg. 'strace' , 'bashdb' , 'stopwatch' ) .

## metaengine

Multiple-input multiple-output temporary directory pipes, triple buffers, searchable 3D coordinate spaces. 

## queue

Broadcast 'Inter-Process Communication' software bus more similar to hardware ad-hoc shared-pair-of-wires CAN/UART/I2C hardware bus, using any of automatically recreated temporary named pipes, triple buffers, database, network sockets, etc. Reference implementation and timing/performance compatibility test.

## server

Connect servers providing network services and controlling other servers - wireguard , coordinatorWorker .

## virtualization

Application virtualization backends with either directory, program, overrides, or automatic directory sharing, fileparameter translation, bootdisc commands on guest startup  - abstracts, fakehome chroot, docker, dosbox, wine, vbox, qemu, wsl2, python (automatically adapt venv absolute path, MSWindows native python, etc).

## shortcuts

Functions to abstract commands capabilities (eg. download a file, install an operating system, copy/paste clipboard, call 'qalculate').

## shortcuts/ai

Run AI programs (eg. function to call 'ollama run' with a specified AI LLM model).

## shortcuts/git

Create, download, etc, git repositories, releases, etc - _gitBest , _wget_githubRelease , _wget_githubRelease , etc .

## shortcuts/github

Special GitHub repository, release, functions - upload , rewrite remote URL , etc.

## special

Functions usually used by other functions, by a 'ubiquitous_bash.sh' script itself, etc, but unusual, only used in special use cases (eg. gosu , meminfo - used by virtualization ) .





END directory specific "ubiquitous_bash" AGENTS.md , other input may regard other hierarchical directories.

---
