

# Suggested defaults. If your python code (not python itself, nor venv, etc, but filenames for files your python application uses, such as datasets, models, etc) insists on absolute paths, and you must use it under both UNIX/Linux and Cygwin/MSW, then it is probably only needed temporarily to generate static assets (ie. occasional experimental fine-tuning of the latest available AI models). In which case you can put into production under solely UNIX/Linux if necessary, and develop with Docker (ie. factory) instead.
# tldr; UNIX/Linux for python in production, Cygwin/MSW for python in development, as usual, and then you won't need abstractfs .
#
#_set_abstractfs_alwaysUNIXneverNative
#_set_abstractfs_disable




_prepare_python() {
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
        local ubcore_accessories_python
        local $ubcore_accessoriesFile_python_ubhome

        ubcore_accessoriesFile_python=$(cygpath -w "$scriptLib"/python_msw/lean.py)
        ubcore_accessories_python=$(cygpath -w "$scriptLib"/python_msw)
        ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLib"/python_msw)
        if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcore_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
        then
            ( _messagePlain_warn 'warn: missing: scriptLib/python_msw/...' >&2 ) > /dev/null
            
            ubcore_accessoriesFile_python=$(cygpath -w "$scriptLocal"/python_msw/lean.py)
            ubcore_accessories_python=$(cygpath -w "$scriptLocal"/python_msw)
            ubcore_accessoriesFile_python_ubhome=$(cygpath -w "$scriptLocal"/python_msw)
            if [[ ! -e "$ubcore_accessoriesFile_python" ]] || [[ ! -e "$ubcore_accessories_python" ]] || [[ ! -e "$ubcore_accessoriesFile_python_ubhome" ]]
            then
                ( _messagePlain_warn 'warn: missing: scriptLocal/python_msw/...' >&2 ) > /dev/null
            fi
        fi
        
        local currentUID=$(_uid)
        _setupUbiquitous_accessories_here-python_hook > "$scriptLocal"/python_msw/pythonrc."$currentUID"
        mv -f "$scriptLocal"/python_msw/pythonrc."$currentUID" "$scriptLocal"/python_msw/pythonrc
        
        export PYTHONSTARTUP=$(cygpath -w "$scriptLocal"/python_msw/pythonrc)




        # rebuild venv/conda/etc
        


        # write > "$dumbpath_file" ; mv -f

        
        true
    fi







    #set ACCELERATE="%VENV_DIR%\Scripts\accelerate.exe"



    #python -m venv

    #bash -i

    #bash --noprofile --norc -i

    #which pip
    python -m pip install --upgrade pip > /dev/null >&2
    pip install pyreadline > /dev/null >&2

    export scriptAbsoluteLocation_msw=$(cygpath -w "$scriptAbsoluteLocation")
    export scriptAbsoluteFolder_msw=$(cygpath -w "$scriptAbsoluteFolder")

    export scriptLocal_msw=$(cygpath -w "$scriptLocal")
    export scriptLib_msw=$(cygpath -w "$scriptLib")
    
    export bash_msw="$scriptAbsoluteFolder_msw"'\_bash.bat'
    export bin_msw="$scriptAbsoluteFolder_msw"'\_bin.bat'



    # lean.py ... is a template script from 'ubiquitous_bash' for lightweight manual changes
    #"$scriptLocal"/python_msw/lean.py   #automatically replaced with autogenerated lean.py
    #"$scriptLib"/python_msw/lean.py    #ATTTENTION: create persistent custom lean.py here
    # WARNING: May be untested.
    #python "$scriptLib_msw"'\python\lean.py' '_bin(["sleep", "90",], True, r"'"$bin_msw"'")'


    #python "$scriptAbsoluteFolder_msw"'\lean.py' '_bin(["sleep", "90",], True, r"'"$bin_msw"'")'
    python "$scriptAbsoluteFolder_msw"'\lean.py' '_bash(["-i"], True, r"'"$bash_msw"'")'

}
#alias python... pythonrc




_prepare_msw_python_procedure() {
    mkdir -p "$scriptLocal"

    mkdir -p "$scriptLocal"/python_msw

    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/python
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/venv
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/conda
    mkdir -p "$scriptAbsoluteFolder"/_bundle/morsels/accelerate

    local currentUID=$(_uid)
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

        export _PATH_pythonDir="$current_binaries_path"

        ( _messagePlain_probe_var PATH >&2 ) > /dev/null
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
set_msw_python_procedure() {
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
    current_binaries_path="$_pythonPip"
    _override_msw_path_python_procedure 

    unset PYTHONHOME
    export PYTHONSTARTUP=$(cygpath -w "$PYTHONSTARTUP")
    
    return 0
}

set_msw_python() {
    _set_msw_python_3_10 "$@"
}
_set_msw_python_3_10() {
    _override_msw_path_python_3_10 "$@"

    set_msw_python_procedure "$@"
}
