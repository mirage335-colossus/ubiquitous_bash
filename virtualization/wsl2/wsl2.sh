

_write_wslconfig() {
    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && return 1
    if _if_cygwin
    then
        [[ -e /cygdrive/c/Windows/System32 ]] && _here_wsl_config "$1" > /cygdrive/c/Windows/System32/config/systemprofile/.wslconfig
        [[ -e /cygdrive/c/Windows/ServiceProfiles/LocalService ]] && _here_wsl_config "$1" > /cygdrive/c/Windows/ServiceProfiles/LocalService/.wslconfig
        _here_wsl_config "$1" > "$USERPROFILE"/.wslconfig
        return
    fi
}


