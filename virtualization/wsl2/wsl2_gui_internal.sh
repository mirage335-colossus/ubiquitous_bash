


_wsl_desktop-waitUp_wmctrl() {
    while [[ $(wmctrl -d 2>/dev/null | wc -l) -lt 1 ]]
    do
        sleep 0.2
    done
}
_wsl_desktop-waitDown_wmctrl() {
    while [[ $(wmctrl -d 2>/dev/null | wc -l) -gt 1 ]]
    do
        sleep 0.4
    done
}
_wsl_desktop() {
    local functionEntryPWD
    functionEntryPWD="$PWD"

    (
        _messageNormal "init: _wsl_desktop"
        if [[ "$PWD" == "/mnt/"?"/WINDOWS/system32" ]] || [[ "$PWD" == "/mnt/"?"/Windows/system32" ]] || [[ "$PWD" == "/mnt/"?"/windows/system32" ]]
        then
            _messagePlain_probe 'reject: /mnt/'?'/WINDOWS/system32'
            _messagePlain_probe_cmd cd
        fi

        export QT_QPA_PLATFORMTHEME=
        unset QT_QPA_PLATFORMTHEME
        #_set_qt5ct

        
        # nix-shell --run "locale -a" -p bash
        #  C   C.utf8   POSIX
        export LANG="C"

        
        # https://stackoverflow.com/questions/12153552/how-high-do-x11-display-numbers-go
        # https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
        _messagePlain_nominal 'Searching for unused X11 display.'
        local xephyrDisplay
        local xephyrDisplayValid
        xephyrDisplayValid="false"
        
        if [[ "$2" == *"panel.sh" ]] || [[ "$2" == *"panel"*".sh" ]] || [[ "$2" == *"panel"*".bat" ]]
        then
            for (( xephyrDisplay = 53 ; xephyrDisplay <= 79 ; xephyrDisplay++ ))
            do
                ! [[ -e /tmp/.X"$xephyrDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$xephyrDisplay" ]] && xephyrDisplayValid="true" && _messagePlain_good 'found: unused X11 display= '"$xephyrDisplay" && break
            done
        else
            # RESERVED - 53-79 (or greater) for PanelBoard
            for (( xephyrDisplay = 13 ; xephyrDisplay <= 52 ; xephyrDisplay++ ))
            do
                ! [[ -e /tmp/.X"$xephyrDisplay"-lock ]] && ! [[ -e /tmp/.X11-unix/X"$xephyrDisplay" ]] && xephyrDisplayValid="true" && _messagePlain_good 'found: unused X11 display= '"$xephyrDisplay" && break
            done
        fi

        _messagePlain_nominal 'Xephyr.'
        local xephyrResolution
        xephyrResolution="1600x1200"
        [[ "$1" == *"x"* ]] && xephyrResolution="$1"
        shift
        if type -p dbus-launch > /dev/null 2>&1 && type -p dbus-run-session > /dev/null 2>&1 && type -p startplasma-x11 > /dev/null 2>&1
        then
            export -f _wsl_desktop-waitUp_wmctrl
            export -f _wsl_desktop-waitDown_wmctrl
            export -f _set_qt5ct
            
            #if [[ "$descriptiveSelf" != ""]]
            #then
                #export currentPlasmaSession="$HOME"/.ubtmp/plasmaSession-"$descriptiveSelf"
            #else
                #export currentPlasmaSession="$HOME"/.ubtmp/plasmaSession-"$sessionid"
            #fi

            #_set_qt5ct
            #"$@"
            
            (
                Xephyr -screen "$xephyrResolution" :"$xephyrDisplay" &#disown -h $!
                disown
                disown -a -h -r
                disown -a -r
                (

                    export DISPLAY=:"$xephyrDisplay"
                    export QT_QPA_PLATFORMTHEME=
                    unset QT_QPA_PLATFORMTHEME
                    export LANG="C"

                    export DESKTOP_SESSION=plasma

                    export $(dbus-launch)

                    #echo '#!/usr/bin/env sh' | tee "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'export DBUS_SESSION_BUS_ADDRESS="'$DBUS_SESSION_BUS_ADDRESS'"' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'export DBUS_SESSION_BUS_PID="'$DBUS_SESSION_BUS_PID'"' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'export DBUS_SESSION_BUS_WINDOWID="'$DBUS_SESSION_BUS_WINDOWID'"' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'export QT_QPA_PLATFORMTHEME= ; unset QT_QPA_PLATFORMTHEME ; export LANG="C"' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'export DESKTOP_SESSION=plasma' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    ##echo 'bash "'"$scriptAbsoluteLocation"'"'' _wsl_desktop-waitUp_wmctrl ; sleep 3 ; export LANG="C"' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    ##dbus-run-session
                    #_safeEcho_newline ' '"$@"' &' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    ##echo 'disown -h $!' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'disown' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'disown -a -h -r' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'disown -a -r' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    ##echo 'bash "'"$scriptAbsoluteLocation"'"''_wsl_desktop-waitDown_wmctrl' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    ##echo 'currentStopJobs=$(jobs -p -r 2> /dev/null) ; [[ "$displayStopJobs" != "" ]] && kill $displayStopJobs > /dev/null 2>&1' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #echo 'rm -f "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh' | tee -a "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh > /dev/null
                    #chmod u+x "$HOME"/.config/plasma-workspace/env/tmp_wsl_desktop.sh

                    "$HOME"/core/installations/xclipsync/xclipsync &
                    disown
                    disown -a -h -r
                    disown -a -r

                    #dbus-run-session 
                    exec startplasma-x11 &


                    sleep 0.1
                    _wsl_desktop-waitUp_wmctrl
                    #sleep 3

                    exec "$@" &

                    echo '---------------------------------------------'
                    wait
                    echo '+++++++++++++++++++++++++++++++++++++++++++++'
                    
                    export LANG="C"
                    
                    #_wsl_desktop-waitDown_wmctrl ; currentStopJobs=$(jobs -p -r 2> /dev/null) ; [[ "$displayStopJobs" != "" ]] && kill $displayStopJobs > /dev/null 2>&1

                )

                wait
            )
            #_wsl_desktop-waitDown_wmctrl ; currentStopJobs=$(jobs -p -r 2> /dev/null) ; [[ "$displayStopJobs" != "" ]] && kill $displayStopJobs > /dev/null 2>&1
            return 0
            cd "$functionEntryPWD"
        fi
        _messagePlain_bad 'bad: missing: GUI'
        _messageFAIL
        _stop 1
        return 1
    )

    cd "$functionEntryPWD"
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