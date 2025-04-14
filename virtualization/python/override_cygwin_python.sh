

# Suggested defaults. If your python application insists on absolute paths, and you must use it under both Linux/UNIX and Cygwin/MSW, then it is probably only needed temporarily to generate static assets (ie. occasional experimental fine-tuning of the latest available AI models). In which case you can put into production under solely Linux/UNIX if necessary, and develop with Docker (ie. factory) instead.
#
#_set_abstractfs_alwaysUNIXneverNative
#_set_abstractfs_disable


# UNIX/Linux of course has no need for such overrides, having normal Python installations in directories in PATH and no distinction between native/MSW and Cygwin/MSW binaries .
_override_msw_path_python() {
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
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python && return 0

    _detect_msw_path_python "$scriptLocal"/msw/python-3.10.11-embed-amd64
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python && return 0

    _detect_msw_path_python-localappdata "Programs/Python/python-3.10.11-embed-amd64"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python && return 0

    _detect_msw_path_python-localappdata "Programs/Python/Python310"
    [[ "$?" == "0" ]] && [[ -d "$current_binaries_path" ]] && _override_msw_path_python && return 0


    ( _messagePlain_bad 'FAIL: missing: python: '${FUNCNAME[0]} >&2 ) > /dev/null
    ( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' >&2 ) > /dev/null
    ( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-embed-amd64.zip' >&2 ) > /dev/null
    _messageFAIL >&2
}


_set_msw_python_3_10() {
    _override_msw_path_python_3_10


    # Set variables...

    # Set location of ?morsels?...

    # Rebuild venv/conda if path has changed (similar to but avoiding abstractfs).
    # different file from project.afs ... maybe dumbpath.var

    
    #set ACCELERATE="%VENV_DIR%\Scripts\accelerate.exe"



    python -m venv

    #bash -i
}
#alias python... pythonrc




