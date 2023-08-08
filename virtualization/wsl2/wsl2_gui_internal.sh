



_set_msw_qt5ct() {
    ! _if_cygwin && return 1

    export QT_QPA_PLATFORMTHEME=qt5ct
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
    ! uname -a | grep -i 'microsoft' > /dev/null 2>&1 && return 1
    ! uname -a | grep -i 'WSL2' > /dev/null 2>&1 && return 1

    if [[ "$DISPLAY" != ":0" ]]
    then
        export QT_QPA_PLATFORMTHEME=
        unset QT_QPA_PLATFORMTHEME
    fi
    
    _write_wsl_qt5ct_conf "$@"


    export QT_QPA_PLATFORMTHEME=qt5ct

    return 0
}


# WARNING: Experimental. Installer use only. May cause issues with applications running natively from the MSW side.
_write_msw_qt5ct() {
    _messagePlain_request 'request: if the value of system variable WSLENV is important to you, the previous value is noted here'
    _messagePlain_probe_var WSLENV
    
    setx QT_QPA_PLATFORMTHEME qt5ct /m
    setx WSLENV QT_QPA_PLATFORMTHEME /m
}


_wsl_desktop() {
    (
        _messageNormal "init: _wsl_desktop"

        export QT_QPA_PLATFORMTHEME=
        unset QT_QPA_PLATFORMTHEME
        _set_qt5ct

        
        # https://stackoverflow.com/questions/12153552/how-high-do-x11-display-numbers-go
        # https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
        _messagePlain_nominal 'Searching for unused X11 display.'
        local xephyrDisplay
        local xephyrDisplayValid
        xephyrDisplayValid="false"
        for (( xephyrDisplay = 20 ; xephyrDisplay <= 60 ; xephyrDisplay++ ))
        do
            ! [[ -e /tmp/.X"$xephyrDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$xephyrDisplay" ]] && xephyrDisplayValid="true" && _messagePlain_good 'found: unused X11 display= '"$xephyrDisplay" && break
        done

        _messagePlain_nominal 'Xephyr.'
        local xephyrResolution
        xephyrResolution="1600x1200"
        [[ "$1" != "" ]] && xephyrResolution="$1"
        if type -p dbus-run-session > /dev/null 2>&1 && type -p startplasma-x11 > /dev/null 2>&1
        then
            ( Xephyr -screen "$xephyrResolution" :"$xephyrDisplay" & ( export DISPLAY=:"$xephyrDisplay" ; "$HOME"/core/installations/xclipsync/xclipsync & dbus-run-session startplasma-x11 2>/dev/null ) )
            return 0
        fi
        _messagePlain_bad 'bad: missing: GUI'
        _messageFAIL

        return 0
    )
}
ldesk() {
    _wsl_desktop "$@"
}








_test_wsl2_internal() {
    _getDep 'xclip'

    _getDep 'tclsh'
    _getDep 'wish'

    _getDep Xephyr

    _wantGetDep dbus-run-session
    _wantGetDep startplasma-x11
}