

# Suggested defaults. If your python code (not python itself, nor venv, etc, but filenames for files your python application uses, such as datasets, models, etc) insists on absolute paths, and you must use it under both UNIX/Linux and Cygwin/MSW, then it is probably only needed temporarily to generate static assets (ie. occasional experimental fine-tuning of the latest available AI models). In which case you can put into production under solely UNIX/Linux if necessary, and develop with Docker (ie. factory) instead.
# tldr; UNIX/Linux for python in production, Cygwin/MSW for python in development, as usual, and then you won't need abstractfs .
#
#_set_abstractfs_alwaysUNIXneverNative
#_set_abstractfs_disable




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
    export lib_dir_msw_python_wheels_msw=""
    unset lib_dir_msw_python_wheels_msw
    export lib_dir_msw_python_wheels_relevant=""
    unset lib_dir_msw_python_wheels_relevant
    return 1
}
_discover_procedure-msw_python() {
    export lib_dir_msw_python_wheels
    
    export lib_dir_msw_python_wheels="$scriptAbsoluteFolder"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLocal"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLib"/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi

    
    export lib_dir_msw_python_wheels="$scriptLib"/ubiquitous_bash/_lib/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi
    export lib_dir_msw_python_wheels="$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/.msw_python_wheels
    if [[ -e "$lib_dir_msw_python_wheels" ]]
    then
        . "$lib_dir_msw_python_wheels"/_msw_python_wheels.sh
        return 0
    fi

    export lib_dir_msw_python_wheels=""
    unset lib_dir_msw_python_wheels
}
_install_dependencies_msw_python_procedure-specific() {
    _discover-msw_python

    # Not all of these packages are necessary for dist/OS other than native MSWindows.
    local currentPackages_list=("pyreadline3" "colorama")
    local currentPackage

    if [[ "$nonet" != "true" ]]
    then
        _pip_upgrade() {
            local currentUpgrade="false"
            for currentPackage in "${currentPackages_list[@]}"
            do
                ! "$1"pip show "$currentPackage" > /dev/null 2>&1 && currentUpgrade="true"
                #! "$2"python -m pip show "$currentPackage" > /dev/null 2>&1 && currentUpgrade="true"
            done
            [[ "$currentUpgrade" == "false" ]] && return 0
            "$2"python -m pip install --upgrade pip > /dev/null >&2
        }
        _pip_upgrade "$1" "$2"
    fi


    if [[ "$nonet" != "true" ]]
    then

        if [[ "$lib_dir_msw_python_wheels" != "" ]]
        then
            # ATTRIBUTION-AI: ChatGPT o3  2025-04-19  (partially)
            _pip_download() {
                "$1"pip show "$3" > /dev/null 2>&1 && return 0
                #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

                #--python-version 3.1
                "$1"pip download "$3" --platform win_amd64,win32,win_arm64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
                
                #"$2"python -m pip download "$3" --platform win_amd64,win32,win_arm64 --only-binary=:all: --dest "$lib_dir_msw_python_wheels_relevant" > /dev/null >&2
            }

            for currentPackage in "${currentPackages_list[@]}"
            do
                _pip_download "$1" "$2" "$currentPackage"
            done
        fi
    fi


    if [[ "$lib_dir_msw_python_wheels_relevant" != "" ]]
    then
        _pip_install_nonet() {
            "$1"pip show "$3" > /dev/null 2>&1 && return 0
            #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

            "$1"pip install --no-index --find-links="$lib_dir_msw_python_wheels_relevant" "$3" > /dev/null >&2
            #"$2"python -m pip install --no-index --find-links="$lib_dir_msw_python_wheels_relevant" "$3" > /dev/null >&2
        }
        for currentPackage in "${currentPackages_list[@]}"
        do
            _pip_install_nonet "$1" "$2" "$currentPackage"
        done
    fi
    
    if [[ "$nonet" != "true" ]]
    then
        _pip_install() {
            "$1"pip show "$3" > /dev/null 2>&1 && return 0
            #"$2"python -m pip show "$3" > /dev/null 2>&1 && return 0

            "$1"pip install "$3" > /dev/null >&2
            #"$2"python -m pip install "$3" > /dev/null >&2
        }
        for currentPackage in "${currentPackages_list[@]}"
        do
            _pip_install "$1" "$2" "$currentPackage"
        done
    fi
}
_install_dependencies_msw_python_sequence-specific() {
    _messageNormal '     install: dependencies: '"$1" > /dev/null >&2
    _start

    "$1"
    if [[ ! -e "$_PATH_pythonDir" ]]
    then
        ( _messagePlain_warn 'warn: skip: missing: python: '"$1" >&2 ) > /dev/null
        _stop 1
    fi
    
    _install_dependencies_msw_python_procedure-specific

    _stop
}
_install_dependencies_msw_python() {
    _install_dependencies_msw_python_sequence-specific _set_msw_python_3_10
}


_prepare_msw_python() {
    _prepare_msw_python_3_10
}
_prepare_msw_python_3_10() {
    _set_msw_python_3_10

    _prepare_msw_python_procedure

    local dumbpath_file="$scriptLocal"/"$dumbpath_prefix"dumbpath.var

    local dumbpath_contents=""
    dumbpath_contents=$(cat "$dumbpath_file" 2> /dev/null)
    
    if [[ "$dumbpath_contents" != "$dumbpath_file" ]]
    then
        # Complain if 'morsels' are not present and must be downloaded - _download_morsels defined in _prog/core.sh or similar ... _messageFAIL





        # write python hook ; mv -f
        
        local ubcore_accessoriesFile_python
        local ubcoreDir_accessories_python
        local ubcore_accessoriesFile_python_ubhome

        ubcore_accessoriesFile_python=$(cygpath -w "$scriptLib"/python_msw/lean.py)
        ubcoreDir_accessories_python=$(cygpath -w "$scriptLib"/python_msw)
        ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLib"/python_msw/lean.py)
        if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcoreDir_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
        then
            ( _messagePlain_warn 'warn: missing: scriptLib/python_msw/...' >&2 ) > /dev/null
            
            ubcore_accessoriesFile_python=$(cygpath -w "$scriptLocal"/python_msw/lean.py)
            ubcoreDir_accessories_python=$(cygpath -w "$scriptLocal"/python_msw)
            ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLocal"/python_msw/lean.py)
            if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcoreDir_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
            then
                ( _messagePlain_warn 'warn: missing: scriptLocal/python_msw/...' >&2 ) > /dev/null
            fi
        fi

        local ubcore_ubcorerc_pythonrc="lean"
        
        local currentUID=$(_uid)
        _setupUbiquitous_accessories_here-python_hook > "$scriptLocal"/python_msw/pythonrc."$currentUID"
        mv -f "$scriptLocal"/python_msw/pythonrc."$currentUID" "$scriptLocal"/python_msw/pythonrc
        
        export _PYTHONSTARTUP=$(cygpath -w "$scriptLocal"/python_msw/pythonrc)
        export PYTHONSTARTUP="$_PYTHONSTARTUP"



        # rebuild venv/conda/etc
        


        # write > "$dumbpath_file" ; mv -f

        
        true
    fi







    #set ACCELERATE="%VENV_DIR%\Scripts\accelerate.exe"



    #python -m venv

    #bash -i

    #bash --noprofile --norc -i

    #which pip



    _install_dependencies_msw_python_procedure-specific "" ""



    


    # ATTENTION: Dropping to an interactive shell in the midst of a bash function which provides standard output to another bash function
    #
    # ie. don't expect guaranteed sanity doing something like this in either bash or python
    # echo $( echo result ; bash -i ) | tee > ./logfile.txt
    #
    # ALWAYS call interactively unless 'stdout' will be consumed. Functions, scripts, commands, get an interactive terminal to talk to, except very simple functions.
    #
    # ie. _fineTune_model  <->  Interactive Shell
    # ie. _vector_model  <->  Interactive Shell
    # ie. _inferenceModel | grep 'stuff' > description.txt  <->  Interactive Shell
    # ie. result=$(_inferenceModel | grep 'correct')  <->  Non-Interactive
    #
    # Unfortunately, bash function calls from python do not enjoy the '$() > /dev/null 2>&1' syntactic convenience.
    # Python calls to '_bin()' , '_bash()' , etc, must explicitly declare or implicitly default sanely whether interactive or non-interactive captured output.
    



    # lean.py ... is a template script from 'ubiquitous_bash' for lightweight manual changes
    #"$scriptLocal"/python_msw/lean.py   #automatically replaced with autogenerated lean.py
    #"$scriptLib"/python_msw/lean.py    #ATTTENTION: create persistent custom lean.py here
    # WARNING: May be untested.
    #python "$scriptLib_msw"'\python\lean.py' '_bin(["sleep", "90",], True, r"'"$scriptCall_bin_msw"'")'

    #python "$scriptAbsoluteFolder_msw"'\lean.py' '_bash(["-i"], True, r"'"$scriptCall_bash_msw"'")'

    python "$scriptAbsoluteFolder_msw"'\lean.py' '_bin(["_demo_msw_python",], True, r"'"$scriptCall_bin_msw"'", interactive=True)'

    #python -i "$scriptAbsoluteFolder_msw"'\lean.py' '_python()'
}
#alias python... pythonrc




_prepare_msw_python_procedure() {
    local currentUID=$(_uid)

    if [[ ! -e "$_PATH_pythonDir"/python3 ]] && [[ $(find "$_PATH_pythonDir" -maxdepth 1 -iname 'python3' -type f -print -quit 2>/dev/null | tr -dc 'a-zA-Z0-9') == "" ]]
    then
        echo '#!/usr/bin/env bash
        python "$@"' > "$_PATH_pythonDir"/python3."$currentUID"
        chmod u+x "$_PATH_pythonDir"/python3."$currentUID"
        mv -f "$_PATH_pythonDir"/python3."$currentUID" "$_PATH_pythonDir"/python3
        chmod u+x "$_PATH_pythonDir"/python3
    fi
    

    mkdir -p "$scriptLocal"

    mkdir -p "$scriptLocal"/python_msw

    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/python
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/venv
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/conda
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/accelerate

    if [[ ! -e "$scriptLocal"/python_msw/lean.py ]] || diff --unified=3 "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/python_msw/lean.py > /dev/null
    then
        cp -f "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/python_msw/lean.py."$currentUID" > /dev/null 2>&1
        mv -f "$scriptLocal"/python_msw/lean.py."$currentUID" "$scriptLocal"/python_msw/lean.py
        if [[ ! -e "$scriptLocal"/python_msw/lean.py ]]
        then
            cp -f "$scriptLib"/ubiquitous_bash/lean.py "$scriptLocal"/python_msw/lean.py."$currentUID"
            mv -f "$scriptLocal"/python_msw/lean.py."$currentUID" "$scriptLocal"/python_msw/lean.py
        fi
    fi
    [[ ! -e "$scriptLocal"/python_msw/lean.py ]] && ( _messagePlain_warn 'warn: missing: scriptLocal/python_msw/lean.py' >&2 ) > /dev/null

    return 0
}




# UNIX/Linux of course has no need for such overrides, having normal Python installations in directories in PATH and no distinction between native/MSW and Cygwin/MSW binaries .
_override_msw_path_python_procedure() {
		local path_entry entry IFS=':'
		local new_path=""
		for entry in $PATH ; do
			# Skip adding if this entry matches current_binaries_path exactly
			[ "$entry" = "$current_binaries_path" ] && continue
			
			# Append current entry to the new_path
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:${entry}"
			fi
		done

		# Finally, explicitly prepend the git path
		export PATH="${current_binaries_path}:${new_path}"

        [[ "$1" == "" ]] && export _PATH_pythonDir="$current_binaries_path"

        [[ "$1" != "" ]] && ( _messagePlain_probe_var PATH >&2 ) > /dev/null

        return 0
}
_detect_msw_path_python() {
        current_binaries_path="$1"

        ! [[ -d "$current_binaries_path" ]] && ( _messagePlain_warn 'warn: missing: python: '"$1" >&2 ) && return 1

        ( _messagePlain_good 'success: found: python: '"$1" >&2 ) > /dev/null
}
_detect_msw_path_python-localappdata() {
        current_binaries_path=$(cygpath -u "$LOCALAPPDATA")
        current_binaries_path="$current_binaries_path"/"$1"

        ! [[ -d "$current_binaries_path" ]] && ( _messagePlain_warn 'warn: missing: python: '"$1" >&2 ) && return 1

        ( _messagePlain_good 'success: found: python: '"$1" >&2 ) > /dev/null
}
_override_msw_path_python_3_10() {
    _messagePlain_nominal 'override: '${FUNCNAME[0]}

    local current_binaries_path=""

    _detect_msw_path_python "$scriptLib"/msw/python-3.10.11-embed-amd64
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python "$scriptLocal"/msw/python-3.10.11-embed-amd64
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python-localappdata "Programs/Python/python-3.10.11-embed-amd64"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0

    _detect_msw_path_python-localappdata "Programs/Python/Python310"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python_procedure && return 0


    ( _messagePlain_bad 'FAIL: missing: python: '${FUNCNAME[0]} >&2 ) > /dev/null
    ( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' >&2 ) > /dev/null
    #( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-embed-amd64.zip' >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$scriptLib"/msw/ >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$scriptLocal"/msw/ >&2 ) > /dev/null
    #( _messagePlain_request 'request: extract: '"$LOCALAPPDATA"'Programs/Python' >&2 ) > /dev/null
    _messageFAIL >&2
}

# CAUTION: Called by _setupUbiquitous_accessories_here-python_hook .
_set_msw_python_procedure() {
    # WARNING: Invalid variables for 'python...embed' .
    export _pythonLib=$(find "$_PATH_pythonDir" -name 'Lib' -type d -print -quit)
    export _pythonSitePackages=$(find "$_PATH_pythonDir" -name 'site-packages' -type d -print -quit)
    export _pythonPip_file=$(find "$_PATH_pythonDir" -name 'pip3.exe' -type f -print -quit)
    export _pythonPip=$([[ "$_pythonPip_file" != "" ]] && _getAbsoluteFolder "$_pythonPip_file")
    export _pythonPipInstaller_file=$(find "$_PATH_pythonDir" -name 'get-pip.py' -type f -print -quit)

    # DUBIOUS
    export _transformersCache="$scriptLocal"/transformers-cache


    #export _python=$(find "$_PATH_pythonDir" -name 'python.exe' -type f -print -quit)

    #export _accelerate=$(find "$_PATH_pythonDir" -name 'accelerate.exe' -type f -print -quit)


    [[ ! -e "$_pythonLib" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonSitePackages" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonPip_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    [[ ! -e "$_pythonPip" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2
    #[[ ! -e "$_pythonPipInstaller_file" ]] && ( _messagePlain_bad 'bad: missing: $_pythonLib' >&2 ) > /dev/null && _messageFAIL >&2

    local current_binaries_path
    current_binaries_path="$_PATH_pythonDir"
    _override_msw_path_python_procedure "_PATH_pythonDir"

    current_binaries_path="$_pythonPip"
    _override_msw_path_python_procedure "pip"

    unset PYTHONHOME
    export PYTHONSTARTUP="$_PYTHONSTARTUP"
    
    return 0
}

set_msw_python() {
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
