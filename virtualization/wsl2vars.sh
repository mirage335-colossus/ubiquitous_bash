

_set_msw_qt5ct() {
    [[ "$QT_QPA_PLATFORMTHEME" != "qt5ct" ]] && export QT_QPA_PLATFORMTHEME=qt5ct
    if [[ "$WSLENV" != "QT_QPA_PLATFORMTHEME" ]] && [[ "$WSLENV" != "QT_QPA_PLATFORMTHEME"* ]] && [[ "$WSLENV" != *"QT_QPA_PLATFORMTHEME" ]] && [[ "$WSLENV" != *"QT_QPA_PLATFORMTHEME"* ]]
    then
        export WSLENV="$WSLENV:QT_QPA_PLATFORMTHEME"
    fi
    return 0
}

# wsl printenv | grep QT_QPA_PLATFORMTHEME
# ATTENTION: Will also unset QT_QPA_PLATFORMTHEME if appropriate (and for this reason absolutely should be hooked by 'Linux' shells).
# Strongly recommend writing the ' export QT_QPA_PLATFORMTHEME=qt5ct ' or equivalent statement to ' /etc/environment.d/ub_wsl2_qt5ct.sh ' , '/etc/environment.d/90ub_wsl2_qt5ct.conf' , or similarly effective non-login non-interactive shell startup script.
#  Unfortunately, '/etc/environment.d' is usually ignored by (eg. Debian) Linux distributions, to the point that variables declared by files provided by installed packages are not exported to any apparent environment.
#  Alternatives attempted include:
#  /etc/security/pam_env.conf
#  ~/.bashrc
#  ~/.bash_profile
#  ~/.profile
_set_qt5ct() {
    if [[ "$DISPLAY" != ":0" ]]
    then
        export QT_QPA_PLATFORMTHEME=
        unset QT_QPA_PLATFORMTHEME
    fi
    
    _write_wsl_qt5ct_conf "$@"


    export QT_QPA_PLATFORMTHEME=qt5ct

    return 0
}


_set_msw_lang() {
    [[ "$LANG" != "C" ]] && export LANG=C
    if [[ "$WSLENV" != "LANG" ]] && [[ "$WSLENV" != "LANG"* ]] && [[ "$WSLENV" != *"LANG" ]] && [[ "$WSLENV" != *"LANG"* ]]
    then
        export WSLENV="$WSLENV:LANG"
    fi
    return 0
}

_set_lang-forWSL() {
    [[ "$LANG" != "C" ]] && export LANG="C"
    return 0
}





_set_msw_wsl() {
    ! _if_cygwin && return 1

    _set_msw_lang
    _set_msw_qt5ct

    return 0
}

_set_wsl() {
    ! uname -a | grep -i 'microsoft' > /dev/null 2>&1 && return 1
    ! uname -a | grep -i 'WSL2' > /dev/null 2>&1 && return 1

    _set_lang-forWSL
    _set_qt5ct

    return 0
}



! _set_msw_wsl && _set_wsl





