



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
    _if_cygwin && return 0

    if ! _if_cygwin
    then
        _getDep 'xclip'

        _getDep 'tclsh'
        _getDep 'wish'

        _getDep Xephyr

        _wantGetDep dbus-run-session
        _wantGetDep startplasma-x11

        return
    fi
    return 1
}