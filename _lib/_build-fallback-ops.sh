
#_bin-build_import

#export safeToDeleteGit='true'
#_safeRMR "$scriptLocal"/upgradeTmp

#export FORCE_AXEL=8
#_build_fallback_upgrade-ubcp-fetch "internal"
_build_fallback_upgrade-ubcp-fetch() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-fetch'

    local currentReleaseLabel="$1"
    #[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="internal"
    [[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="spring"

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.7z

    cd "$scriptLocal"/upgradeTmp
    ! _wget_githubRelease "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabel" "package_ubcp-core.7z" -O "$scriptLocal"/upgradeTmp/package_ubcp-core.7z && _messageFAIL
    return 0
}

_build_fallback_upgrade-ubcp-extract() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-extract'

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    cd "$scriptLocal"/upgradeTmp/package_ubcp-core

    7za -y x "$scriptLocal"/upgradeTmp/package_ubcp-core.7z
}

_build_fallback_upgrade-ubcp-compress() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-compress'
    
    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    cd "$scriptLocal"/upgradeTmp/package_ubcp-core

    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.7z
    
    #if [[ "$skimfast" != "false" ]]
    #then
        #7z -y a -t7z -m0=lzma2 -mmt=6 -mx=2 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./ubcp .//ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        #return
    #else
        7z -y a -t7z -m0=lzma2 -mmt=6 -mx=9 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./ubcp ./ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        return
    #fi
}

_build_fallback_upgrade-ubcp-upgrade-ubiquitous_bash() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-upgrade-ubiquitous_bash'

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    cd "$scriptLocal"/upgradeTmp/package_ubcp-core


    #mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root
    #cd "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root


    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash
    cd "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash

    _messagePlain_nominal '@@@@@@@@@@ _gitMad'
    ! _messagePlain_probe_cmd _gitMad && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: _gitMad' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git checkout'
    ! _messagePlain_probe_cmd git checkout "master" && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: git checkout' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git reset --hard'
    ! _messagePlain_probe_cmd git reset --hard && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: git checkout' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git pull'
    ! _messagePlain_probe_cmd _gitBest pull && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: git pull' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git submodule update --init --depth 1 --recursive'
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: submodule update --init --depth 1 --recursive' && _messageFAIL


    _messagePlain_nominal '@@@@@@@@@@ cp'

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/bin/

    # Normally, symlink, no need to replace.
    #! _messagePlain_probe_cmd cp -a "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash/ubiquitous_bash.sh "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/bin/ && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: cp' && _messageFAIL
    #! _messagePlain_probe_cmd chmod 755 "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/bin/ubiquitous_bash.sh && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: chmod' && _messageFAIL


    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash

    ! _messagePlain_probe_cmd cp -f -a "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash/ubiquitous_bash.sh "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: cp' && _messageFAIL
    ! _messagePlain_probe_cmd chmod 755 "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash/ubiquitous_bash.sh && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: chmod' && _messageFAIL
    
    ! _messagePlain_probe_cmd cp -f -a "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash/ubcore.sh "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: cp' && _messageFAIL
    ! _messagePlain_probe_cmd chmod 755 "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash/ubcore.sh && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: chmod' && _messageFAIL
    
    ! _messagePlain_probe_cmd cp -f -a "$scriptLocal"/upgradeTmp/package_ubcp-core/ubcp/cygwin/home/root/.ubcore/ubiquitous_bash/lean.sh "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: cp' && _messageFAIL
    ! _messagePlain_probe_cmd chmod 755 "$scriptLocal"/upgradeTmp/package_ubcp-core/ubiquitous_bash/lean.sh && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: chmod' && _messageFAIL

    return 0
}

_build_fallback_upgrade-ubcp-rm() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-rm'

    export safeToDeleteGit='true'

    cd "$scriptLocal"
    _safeRMR "$scriptLocal"/upgradeTmp
    ! [[ -e "$scriptLocal"/upgradeTmp ]]
}

_build_fallback_upgrade_sequence-ubcp-upgrade() {
    _start
    #mkdir -p "$safeTmp"
    local functionEntryPWD="$PWD"
    cd "$scriptAbsoluteFolder"

    _messageNormal 'begin: _build_fallback_upgrade_sequence-ubcp-upgrade'

    _build_fallback_upgrade-ubcp-fetch "$@"

    _build_fallback_upgrade-ubcp-extract "$@"

    _build_fallback_upgrade-ubcp-upgrade-ubiquitous_bash "$@"

    _build_fallback_upgrade-ubcp-compress "$@"

    _messageNormal 'end: DONE'

    cd "$functionEntryPWD"
    _stop
}

_build_fallback_upgrade-ubcp() {
    "$scriptAbsoluteLocation" _build_fallback_upgrade_sequence-ubcp-upgrade "$@"
}
