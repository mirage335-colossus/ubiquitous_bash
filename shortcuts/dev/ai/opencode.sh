
# NOTICE: Installing 'opencode' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .



_setup_opencode_sequence() {
    _start

    cd "$safeTmp"
    local functionEntryPWD
    functionEntryPWD="$PWD"
    local currentExitStatus

    rm -f "$HOME"/.opencode/bin/opencode
    rm -f "$HOME"/bin/opencode

    if _if_cygwin
    then
        wget https://github.com/sst/opencode/releases/latest/download/opencode-windows-x64.zip -O ./opencode-windows-x64.zip

        unzip ./opencode-windows-x64.zip -d ./opencode-windows-x64

        mkdir -p "$HOME"/bin
        rm -f "$HOME"/bin/opencode.exe
        mv -f ./opencode-windows-x64/opencode.exe "$HOME"/bin/
        currentExitStatus="$?"
    fi

    if ! _if_cygwin
    then
        if uname -m | grep 'x86_64' > /dev/null 2>&1 && ( cat /etc/debian_version | head -c 2 | grep 12 > /dev/null 2>&1 || cat /etc/debian_version | head -c 2 | grep 12 > /dev/null 2>&1 || ( [[ -e /etc/issue ]] && ( cat /etc/issue | grep 'Ubuntu' | grep '24.04' > /dev/null 2>&1 ) ) )
        then
            wget https://github.com/sst/opencode/releases/latest/download/opencode-linux-x64.tar.gz -O ./opencode-linux-x64.tar.gz
            tar -xvzf ./opencode-linux-x64.tar.gz

            mkdir -p "$HOME"/bin
            rm -f "$HOME"/bin/opencode
            mv -f ./opencode-linux-x64/opencode "$HOME"/bin/
            currentExitStatus="$?"
        else
            # Not expected to do more than effectively put the binary in PATH .
            curl -fsSL https://opencode.ai/install | bash
            currentExitStatus="$?"
        fi
    fi
    
    cd "$functionEntryPWD"
    _stop "$currentExitStatus"
}


# ATTENTION: May benefit form 'ubDEBUG=true' for AI to better diagnose and continue testing.

#export devfast=true
#export skimfast=true
#
#export ub_setScriptChecksum_disable='true'
##export ubDEBUG=true

#alias opencodeUnix='wsl -d ubdist opencode'

_setup_opencode() {
    [[ ! -e "$HOME"/.config/opencode/opencode.json ]] && _here_opencode | tee "$HOME"/.config/opencode/opencode.json > /dev/null

    "$scriptAbsoluteLocation" _setup_opencode_sequence "$@"
}

#alias opencodeAuto
#alaias opencodeForce






