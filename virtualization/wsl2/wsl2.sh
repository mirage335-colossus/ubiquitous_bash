

_write_wslconfig() {
    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && return 1
    if _if_cygwin
    then
        _here_wsl_config "$1" > "$USERPROFILE"/.wslconfig
        return
    fi
}


