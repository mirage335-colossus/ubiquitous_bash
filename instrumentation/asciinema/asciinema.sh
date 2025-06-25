




_setup_asciinema_convert() {
    _mustGetSudo

    _get_npm

    if _if_cygwin
    then
        # MSW user permissions seems sufficient to call npm .
        sudo() {
            [[ "$1" == "-n" ]] && shift
            "$@"
        }
    fi

    sudo -n npm install -g asciicast2gif

    if ! _if_cygwin
    then
        #pip3 install --break-system-packages term2md
        #sudo -n pip3 install --break-system-packages term2md
        true
    fi

    if _if_cygwin
    then
        ##pip3 install --quiet --no-input --no-build-isolation -U term2md
        #pip3 install --no-input --no-build-isolation -U term2md
        true
    fi


    _getDep perl

    _getDep sed


    return 0
}

#_asciinema_record 'command' [./rec.log]
#./ubiquitous_bash.sh _asciinema_record "/home/root/'a b'/ubiquitous_bash.sh _scope ." "record.txt"
#./ubiquitous_bash.sh _asciinema_record '/home/root/"a b"/ubiquitous_bash.sh _scope .' "record.txt"
#./ubiquitous_bash.sh _asciinema_record "bash" "record.txt"
#./ubiquitous_bash.sh _asciinema_record 'echo "$PATH"' "record.txt"
#./ubiquitous_bash.sh _asciinema_record 'echo "$safeTmp"' "record.txt"
_asciinema_record() {
    local current_record_file
    current_record_file="$2"
    if ( [[ -d "$current_record_file" ]] || { [[ -L "$current_record_file" ]] && [[ -d "$(readlink -f "$current_record_file")" ]]; } )
    then
        current_record_file="$current_record_file"/rec_$(date +%Y-%m-%d.%H).log
        [[ -e "$current_record_file"/_local ]] && current_record_file="$current_record_file"/_local/rec_$(date +%Y-%m-%d.%H).log
    fi
    if [[ "$current_record_file" == "" ]]
    then
        current_record_file=./rec_$(date +%Y-%m-%d.%H).log
    fi

    rm -f "$current_record_file" > /dev/null 2>&1

    # DUBIOUS - cannot directly inherit Cygwin/MSW environment, functions, session, "$safeTmp", etc. May be usable with '.embed.sh' or similar.
    # Otherwise maybe the best asciinema backend for Cygwin/MSW .
    # https://github.com/asciinema/asciinema/issues/467
    if _if_cygwin && wsl -d ubdist true > /dev/null 2>&1 && ! wsl -d ubdist false > /dev/null 2>&1 && [[ force_asciinema_disable_wsl2 != "true" ]]
    then
        local current_bin_cmd_wsl
        current_bin_cmd_wsl=$(type -P cmd 2>/dev/null)
        current_bin_cmd_wsl=$(cygpath --mixed "$current_bin_cmd_wsl")
        current_bin_cmd_wsl=$(wsl -d ubdist wslpath "$current_bin_cmd_wsl")

        local current_bin_bash_wsl
        current_bin_bash_wsl=$(cygpath --mixed /bin/bash)
        #current_bin_bash_wsl=$(wsl -d ubdist wslpath "$current_bin_bash_wsl")



        # ### Backend: WSL2 .

        #./ubiquitous_bash.sh _asciinema_record "/home/root/'a b'/ubiquitous_bash.sh _scope ." "record.txt"
        #_messagePlain_probe_safe wsl -d ubdist asciinema rec --command "$current_bin_cmd_wsl"' /C '"$current_bin_bash_wsl"' -c "'"$1"'"' "$current_record_file"
        #wsl -d ubdist asciinema rec --command "$current_bin_cmd_wsl"' /C '"$current_bin_bash_wsl"' -c "'"$1"'"' "$current_record_file"
        #return
        
        #./ubiquitous_bash.sh _asciinema_record 'echo "$PATH"' "record.txt"
        #./ubiquitous_bash.sh _asciinema_record '/home/root/"a b"/ubiquitous_bash.sh _scope .' "record.txt"
        _messagePlain_probe_safe wsl -d ubdist asciinema rec --command "$current_bin_cmd_wsl"' /C '"$current_bin_bash_wsl"' -c '"'""$1""'" "$current_record_file"
        wsl -d ubdist asciinema rec --command "$current_bin_cmd_wsl"' /C '"$current_bin_bash_wsl"' -c '"'""$1""'" "$current_record_file"
        return


        
    fi

    # https://github.com/asciinema/asciinema/issues/467
    if _if_cygwin && type PowerSession > /dev/null 2>&1 && [[ force_asciinema_disable_native != "true" ]]
    then
        #PowerSession rec --command 'bash ./ubiquitous_bash.sh _scope .' "$current_record_file"

        # Discouraged. Tends to record the 'clear' command, etc, causing inconvenience.
        #wsl asciinema rec -c '~/.ubcore/ubiquitous_bash/ubcore.sh _powershell C:\_bash'

        # CAUTION: Native MSW calling bash directly through cmd/powershell directly is STRONGLY DISCOURAGED.
        # Do NOT use such tricks for Python, etc. Do NOT rely on such tricks for necessary functionality. Instrumentation ONLY.
        local current_bin_bash=$(cygpath -w /bin/bash | sed 's/\\/\\\\/g')


        local current_bin_powershell
        #current_bin_powershell=$(_discover_powershell)
        #current_bin_powershell=$(type -P powershell)
        #current_bin_powershell=$(cygpath -w "$current_bin_powershell")
        current_bin_powershell="powershell"

        ##_powershell -Command "$current_bin_bash"" -c '"'bash ./ubiquitous_bash.sh _scope .'"'"
        ##PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"" -c '"' ./ubiquitous_bash.sh _scope . '"'" "$current_record_file"
        #PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"" -c '"''"$1"''"'" "$current_record_file"
        #return

        local current_bin_cmd
        current_bin_cmd="cmd"
        #"$current_bin_cmd" /C "$current_bin_bash" '-c' 'bash ./ubiquitous_bash.sh _scope .'
        #PowerSession rec --command  "$current_bin_cmd"' /C '"$current_bin_bash"" '-c' ""'"'./ubiquitous_bash.sh _scope .'"'" "$current_record_file"
        #PowerSession rec --command  "$current_bin_cmd"' /C '"$current_bin_bash"" '-c' ""'"''"$1"''"'" "$current_record_file"
        #return



        #PowerSession rec --command "cmd /C C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe /home/root/'a b'/ubiquitous_bash.sh _scope ." record.txt

        #PowerSession rec --command "powershell -Command C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe /home/root/'a b'/ubiquitous_bash.sh _scope ." record.txt
        #PowerSession rec --command "$current_bin_powershell -Command $current_bin_bash $1" "$current_record_file"



        # ### Backend: Native/MSWindows - cmd .

        #./ubiquitous_bash.sh _asciinema_record "/home/root/'a b'/ubiquitous_bash.sh _scope ." "record.txt"
        #_messagePlain_probe_safe PowerSession rec --command "$current_bin_cmd"' /C '"$current_bin_bash"' -c "'"$1"'"' "$current_record_file"
        #PowerSession rec --command "$current_bin_cmd"' /C '"$current_bin_bash"' -c "'"$1"'"' "$current_record_file"
        #return

        #./ubiquitous_bash.sh _asciinema_record '/home/root/"a b"/ubiquitous_bash.sh _scope .' "record.txt"
        #./ubiquitous_bash.sh _asciinema_record 'echo "$safeTmp"' "record.txt"
        _messagePlain_probe_safe PowerSession rec --command "$current_bin_cmd"' /C '"$current_bin_bash"' -c '"'""$1""'" "$current_record_file"
        PowerSession rec --command "$current_bin_cmd"' /C '"$current_bin_bash"' -c '"'""$1""'" "$current_record_file"
        return



        #_messagePlain_probe_safe PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"' -c "'"$1"'"' "$current_record_file"
        #PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"' -c "'"$1"'"' "$current_record_file"
        #_messagePlain_probe_safe PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"' -c '"'""$1""'" "$current_record_file"
        #PowerSession rec --command "$current_bin_powershell"' -Command '"$current_bin_bash"' -c '"'""$1""'" "$current_record_file"



        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" ''"/home/root/'a b'/ubiquitous_bash.sh _scope ."' record.txt
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" '"\"/home/root/'a b'/ubiquitous_bash.sh _scope .\"" record.txt
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" ''"\"echo x\""' record.txt
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" "\"echo x\""' record.txt
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" "'"'echo x'"'"' record.txt
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" "\"'"echo x"'\""' record.txt



        # Backend: Native/MSWindows - powershell .

        #./ubiquitous_bash.sh _asciinema_record '/home/root/"a b"/ubiquitous_bash.sh _scope .' "record.txt"
        ##
        ##
        #
        #./ubiquitous_bash.sh _asciinema_record "/home/root/'a b'/ubiquitous_bash.sh _scope ." "record.txt"
        #_messagePlain_probe_safe PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" "\"'"$1"'\""' "$current_record_file"
        #PowerSession rec --command powershell' -Command "C:\\core\\infrastructure\\ubcp\\cygwin\\bin\\bash.exe" "-c" "\"'"$1"'\""' "$current_record_file"
        #return



    fi

    asciinema rec --command "$1" "$current_record_file"
}
_record() {
    _asciinema_record "$@"
}



_asciinema_markdown() {
    # ATTRIBUTION-AI: ChatGPT o3-pro , OpenAI codex-mini  2025-06-18  (partially)

    echo

    #asciinema cat "$1" | perl -pe 's/\x07//g && s/^[^\r]*\r//' | term2md


    if _if_cygwin
    then
        wsl -d ubdist asciinema cat "$@" | perl -pe 's/\x07//g && s/^[^\r]*\r//' | ansifilter --html | sed 's/background-color:#000000;//g' | sed -n '/<pre>/,/<\/pre>/p'
        return
    fi

    asciinema cat "$@" | perl -pe 's/\x07//g && s/^[^\r]*\r//' | ansifilter --html | sed 's/background-color:#000000;//g' | sed -n '/<pre>/,/<\/pre>/p'
}
_markdown() {
    _asciinema_markdown "$@"
}









