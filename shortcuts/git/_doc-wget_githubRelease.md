


summary (possbily improved, possibly added to with AI generated content)





# Files

```
./shortcuts/git/_doc-wget_githubRelease.md
```

```
./shortcuts/git/wget_githubRelease_internal.sh
./shortcuts/git/wget_githubRelease_tag.sh
```









# Prompt - Call Graph







# Functions - Internal

```bash
_wget_githubRelease-stdout
_wget_githubRelease
_wget_githubRelease_internal
_wget_githubRelease_join

```



# Functions - Tag







# Explanation

join ... is what does the parallel downloading of multi-part files...
...




# Call Graph

    |___ 




# Inter-Process-Communication

Similar to call graph, but specific to the Inter-Process-Communication .

Looking to enumerate flag variables, files used for IPC, etc.





# Pseudocode Summary 

Summary semi-pseudocode for code segments is intended not for developing rewrites or new features but only to hastily remind experienced maintenance programmers of the most complex, confusing, logic of the code.

Usually regarding:
- Insufficiently or non-obvious usage documentation.
- Backend selection.
- Backend configuration (set, prepare, etc).
- Intended flow.
- Syntax.

Please generate very abbreviated, abridged, minimal semi-pseudocode, enumerating only:
- Standalone Action Functions (invoked by script or end-user to independently achieve an entire purpose such as produce an asset)
- Produced Assets (download file, fine tuned model, etc)
- Backend Configuration
- Backend Selection
- Important Conditions and Loops
- Overrides (alternative functions calling binary program, functions with same name as binary function, changes to PATH variable, etc)

Please separately briefly chronicle significant, substantial, and serious, deficiencies, for each enumerated category, in this summary semi-pseudocode.

Most importantly, exclaim any seriously misleading functional incongruities between the summary semi-pseudocode and the actual code segment! Especially ensure plausible exit status, outputs, etc, from plausible stepwise processing of plausible inputs to each semi-pseudocode function matches plausible exit status, outputs, etc, for each semi-pseudocode function.

```bash
_msw_python() {
    #export dependencies_msw_python=( "pyreadline3" )
    #export packages_msw_python=( "huggingface_hub[cli]" )
	_prepare_msw_python
	#python "$scriptLib_msw"'\python\lean.py' '_bin(["sleep", "90",], True, r"'"$scriptCall_bin_msw"'")'
	python "$scriptAbsoluteFolder_msw"'\lean.py' '_bin(["_demo_msw_python",], True, r"'"$scriptCall_bin_msw"'", interactive=True)'
}
_msw_python_bash() {
    #export dependencies_msw_python=( "pyreadline3" )
    #export packages_msw_python=( "huggingface_hub[cli]" )
	_prepare_msw_python
    _bash
}
_msw_python_bin() {
    #export dependencies_msw_python=( "pyreadline3" )
    #export packages_msw_python=( "huggingface_hub[cli]" )
    _prepare_msw_python
    _bin "$@"
}

_test_msw_python() {
    #export dependencies_msw_python=( "pyreadline3" )
    #export packages_msw_python=( "huggingface_hub[cli]" )
    _prepare_msw_python
}

# EXAMPLE. Override or implement alternative with 'core.sh', 'ops.sh', or similar.
_prepare_msw_python() {
    _prepare_msw_python_3
}
_prepare_msw_python_3() {
    _prepare_msw_python_3_10
}

# EXAMPLE. Override or implement alternative (discouraged) with 'core.sh', 'ops.sh', or similar, if necessary.
_prepare_msw_python_3_10() {
    _set_msw_python_3_10

	_write_python_hook_local() {
		ubcore_accessoriesFile_python=$(cygpath -w "$scriptLib"/python_msw/lean.py)
		ubcoreDir_accessories_python=$(cygpath -w "$scriptLib"/python_msw)
		ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLib"/python_msw/lean.py)
		if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcoreDir_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
        then
			# ... "$scriptLocal"
		fi

		_setupUbiquitous_accessories_here-python_hook > "$scriptLocal"/python_msw/pythonrc

		export _PYTHONSTARTUP=$(cygpath -w "$scriptLocal"/python_msw/pythonrc)
        export PYTHONSTARTUP="$_PYTHONSTARTUP"
	}
    unset _PYTHONSTARTUP
    local current_done__prepare_msw_python_procedure="false"

	_lock_prepare_python_msw() {
		#wait
		while [[ $(cat "$scriptLocal"/python_msw.lock 2> /dev/null | head -c "$currentUID_length") != "$currentUID" ]]
		do
			sleep7
		done
	}
    _lock_prepare_python_msw

    local dumbpath_file="$scriptLocal"/"$dumbpath_prefix"dumbpath.var
    local dumbpath_contents=$(cat "$dumbpath_file" 2> /dev/null)
	if [[ "$dumbpath_contents" != "$dumbpath_file" ]]
	then
        _safeRMR "$scriptLocal"/python_msw
		_prepare_msw_python_procedure
        current_done__prepare_msw_python_procedure="true"
		_write_python_hook_local

		mkdir -p "$scriptLocal"/python_msw/venv
        ! cd "$scriptLocal"/python_msw/venv && _stop 1
		python3 -m venv default_venv > /dev/null >&2
		source default_venv/Scripts/activate_msw > /dev/null >&2

		_set_msw_python_procedure

		_install_dependencies_msw_python_procedure-specific "" ""

		_morsels_msw_pip_python_3_10

		echo "$dumbpath_file" > "$dumbpath_file"
    fi

	[[ "$current_done__prepare_msw_python_procedure" == "false" ]] && _prepare_msw_python_procedure
	current_done__prepare_msw_python_procedure="true"
	[[ "$_PYTHONSTARTUP" == "" ]] && _write_python_hook_local


	
    ! cd "$scriptLocal"/python_msw/venv && _stop 1
	source default_venv/Scripts/activate_msw > /dev/null >&2

	_set_msw_python_procedure
	_install_dependencies_msw_python_procedure-specific "" ""


	rm -f "$scriptLocal"/python_msw.lock
}

_morsels_msw_pip_python_3_10() {
    #export packages_msw_python=( "huggingface_hub[cli]" )
    local currentPackages_indicator_list=( "huggingface_hub[cli]" "${packages_msw_python[@]}" )
    local currentPackages_list=( "huggingface_hub[cli]" )

    for currentPackage in "${currentPackages_indicator_list[@]}"
    do
        ! pip show "$currentPackage" > /dev/null 2>&1 && currentWork="true"
    done
    [[ "$currentWork" == "false" ]] && return 0

	python -m pip install --upgrade pip > /dev/null >&2

	for currentPackage in "${currentPackages_list[@]}"
    do
		[[ "$nonet" != "true" ]] && [[ "$nonet_available" != "true" ]] && pip download "$currentPackage" --platform win_amd64 --only-binary=:all: --dest "$(cygpath -w "$scriptAbsoluteFolder"/_bundle/morsels/pip)" > /dev/null >&2
        
        pip install --no-index --find-links="$(cygpath -w "$scriptAbsoluteFolder"/_bundle/morsels/pip)" "$currentPackage" > /dev/null >&2
	done
}


_discover-msw_python() {
    _discover_procedure-msw_python "$@"
	if [[ "$lib_dir_msw_python_wheels" != "" ]]
    then
		export lib_dir_msw_python_wheels_msw=$(cygpath -w "$lib_dir_msw_python_wheels")
        if [[ "$_PATH_pythonDir" != "" ]]
        then
            export lib_dir_msw_python_wheels_relevant="$lib_dir_msw_python_wheels_msw"
        else
            export lib_dir_msw_python_wheels_relevant="$lib_dir_msw_python_wheels"
        fi
        return 0
	fi
}
_discover_procedure-msw_python() {
	#lib_dir_msw_python_wheels=
		#"$scriptAbsoluteFolder"/.python_wheels/msw
		#lib_dir_msw_python_wheels="$scriptLocal"/.python_wheels/msw
		#"$scriptLib"/.python_wheels/msw
		#
		#"$scriptLib"/ubiquitous_bash/_lib/.python_wheels/msw
		#"$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/.python_wheels/msw
	. "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
}
_install_dependencies_msw_python_procedure-specific() {
	_discover-msw_python

	local currentPackages_list=( "pyreadline3" "colorama" "${dependencies_msw_python[@]}" )


	"$2"python -m pip install --upgrade pip > /dev/null >&2

	
	for currentPackage in "${currentPackages_list[@]}"
	do
		"$1"pip download "$currentPackage" --platform win_amd64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
	done

	
	for currentPackage in "${currentPackages_list[@]}"
	do
		"$1"pip install --no-index --find-links="$lib_dir_msw_python_wheels_relevant" "$currentPackage" > /dev/null >&2
	done

	for currentPackage in "${currentPackages_list[@]}"
	do
		"$1"pip install "$currentPackage" > /dev/null >&2
	done
}
_install_dependencies_msw_python_sequence-specific() {
	_start

	"$1"
	_install_dependencies_msw_python_procedure-specific

	_stop
}
_install_dependencies_msw_python() {
    "$scriptAbsoluteLocation" _install_dependencies_msw_python_sequence-specific _set_msw_python_3_10
}

_prepare_msw_python_procedure() {
	echo '#!/usr/bin/env bash python "$@"' > "$_PATH_pythonDir"/python3

	mkdir -p "$scriptLocal"
    mkdir -p "$scriptLocal"/python_msw
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/pip
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/venv

	cp -f "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/python_msw/lean.py
	cp -f "$scriptLib"/ubiquitous_bash/lean.py "$scriptLocal"/python_msw/lean.py

	_install_dependencies_msw_python_procedure-specific "" ""
}

_override_msw_path_python_procedure() {
	export PATH="${current_binaries_path}:${new_path}"
	[[ "$1" == "" ]] && export _PATH_pythonDir="$current_binaries_path"
}
_detect_msw_path_python() {
	current_binaries_path="$1"
	! [[ -d "$current_binaries_path" ]] return 1
	return 0
}
_detect_msw_path_python-localappdata() {
	current_binaries_path=$(cygpath -u "$LOCALAPPDATA")
	current_binaries_path="$current_binaries_path"/"$1"
	! [[ -d "$current_binaries_path" ]] && return 1
	return 0
}
_override_msw_path_python_3_10() {
	local current_binaries_path=""

	#if
	#_detect_msw_path_python
		#"$scriptLib"/msw/python-3.10.11-embed-amd64
		#"$scriptLocal"/msw/python-3.10.11-embed-amd64
		#"Programs/Python/python-3.10.11-embed-amd64"
		#"Programs/Python/Python310"
	#[[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

	( _messagePlain_bad 'FAIL: missing: python: '${FUNCNAME[0]} >&2 ) > /dev/null
	( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' >&2 ) > /dev/null
	_messageFAIL >&2
}
_set_msw_python_procedure() {
    # WARNING: Invalid variables for 'python...embed' .
    export _pythonLib=$(find "$_PATH_pythonDir" -iname 'Lib' -type d -print -quit)
    export _pythonSitePackages=$(find "$_PATH_pythonDir" -iname 'site-packages' -type d -print -quit)
    export _pythonPip_file=$(find "$_PATH_pythonDir" -iname 'pip3.exe' -type f -print -quit)
    export _pythonPip=$([[ "$_pythonPip_file" != "" ]] && _getAbsoluteFolder "$_pythonPip_file")
    export _pythonPipInstaller_file=$(find "$_PATH_pythonDir" -iname 'get-pip.py' -type f -print -quit)

    # DUBIOUS
    export _transformersCache="$scriptLocal"/transformers-cache

	[[ ! -e "$_pythonLib" ]] && _messageFAIL

    local current_binaries_path

	current_binaries_path="$_PATH_pythonDir"
    _override_msw_path_python_procedure "_PATH_pythonDir"

    current_binaries_path="$_pythonPip"
    _override_msw_path_python_procedure "pip"

	local VIRTUAL_ENV_unix
    [[ "$VIRTUAL_ENV" != "" ]] && VIRTUAL_ENV_unix=$(cygpath -u "$VIRTUAL_ENV")
    VIRTUAL_ENV_unix="$VIRTUAL_ENV_unix"/Scripts
    if [[ -e "$VIRTUAL_ENV_unix" ]]
	then
		export _pythonLib=$(find "$VIRTUAL_ENV_unix"/.. -iname 'Lib' -type d -print -quit)

		#...

		[[ ! -e "$_pythonLib" ]] && _messageFAIL

        current_binaries_path="$VIRTUAL_ENV_unix"
        _override_msw_path_python_procedure "VIRTUAL_ENV"

        current_binaries_path="$_pythonPip"
        _override_msw_path_python_procedure "VIRTUAL_ENV_pip"
	fi

    unset PYTHONHOME
    export PYTHONSTARTUP="$_PYTHONSTARTUP"
    
    return 0
}

_set_msw_python() {
    _set_msw_python_3_10 "$@"
}
_set_msw_python_3_10() {
    _override_msw_path_python_3_10 "$@"

    _set_msw_python_procedure "$@"
}

_demo_msw_python() {
    _messagePlain_nominal 'demo: '${FUNCNAME[0]} > /dev/null >&2
    sleep 0.6
    "$@"
    _bash
}

```


# Pseudocode Summary - (MultiThreaded)

Summary semi-pseudocode for code segments is intended not for developing rewrites or new features but only to hastily remind experienced maintenance programmers of the most complex, confusing, logic of the code.

Usually regarding, for multi-threaded code:
- Action functions where processing begins.
- Produced assets.
- Inter-Process-Communication mechanisms which may necessarily be non-deterministic.
- Loop conditions.
- Concurrency collisions.
- Operating-System latency margins.
- Inappropriate esoteric resource locking (eg. backgrounded process grabbing tty).

Please generate very abbreviated, abridged, minimal semi-pseudocode, enumerating only:
- Standalone Action Functions (invoked by script or end-user to independently achieve an entire purpose such as produce an asset)
- Produced Assets (download file, fine tuned model, etc)
- Inter-Process-Communication Files, Pipes, etc (existence/absence of produced asset files, PID files, lock files, *.busy , *.PASS , *.FAIL , etc)
- Inter-Process-Communication Conditions and Loops

Please separately briefly chronicle significant, substantial, and serious, deficiencies, for each enumerated category, in this summary semi-pseudocode.

Most importantly, exclaim any seriously misleading functional incongruities between the summary semi-pseudocode and the actual code segment! Especially ensure plausible exit status, outputs, etc, from plausible stepwise processing of plausible inputs to each semi-pseudocode function matches plausible exit status, outputs, etc, for each semi-pseudocode function.

```bash

( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv6="$?"
( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv4="$?"

outputLOOP:
while WAIT && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp)
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).busy

downloadLOOP:
while WAIT && ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL

_wget_githubRelease_procedure-join:
echo -n > "$currentAxelTmpFile".busy
_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
if [[ "$currentExitStatus" != "0" ]]
then
	echo -n > "$currentAxelTmpFile"
	echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
fi
while WAIT && [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
[[ "$currentAxelTmpFile" != "" ]] && _destroy_lock "$currentAxelTmpFile".*

```




# Scrap

export FORCE_AXEL="3"
export FORCE_PARALLEL="5"

./ubiquitous_bash.sh _get_ingredientVM "spring"

./ubiquitous_bash.sh _wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "spring" "package_image.tar.flx" > _local/temp


