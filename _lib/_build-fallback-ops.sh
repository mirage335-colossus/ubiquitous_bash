
#_bin-build_import

_build_fallback_upgrade-ubcp-fetch() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-fetch'

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.7z

    cd "$scriptLocal"/upgradeTmp
    ! _wget_githubRelease "mirage335-colossus" "internal" "package_ubcp-core.7z" -O "$scriptLocal"/package_ubcp-core.7z && _messageFAIL
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
    
    if [[ "$skimfast" != "false" ]]
    then
        7z -y a -t7z -m0=lzma2 -mmt=6 -mx=1 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./core/infrastructure/ubcp ./core/infrastructure/ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        return
    else
        7z -y a -t7z -m0=lzma2 -mmt=6 -mx=9 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./core/infrastructure/ubcp ./core/infrastructure/ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        return
    fi
}

_build_fallback_upgrade-ubcp-upgrade() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-upgrade'

    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    cd "$scriptLocal"/upgradeTmp/package_ubcp-core


    # TODO: URGENT: Upgrade 'ubiquitous_bash' .
    #cd "$scriptLocal"/upgradeTmp/package_ubcp-core/core/infrastructure/ubcp
}

_build_fallback_upgrade_sequence-ubcp-upgrade() {
    _start
    #mkdir -p "$safeTmp"
    local functionEntryPWD="$PWD"
    cd "$scriptAbsoluteFolder"

    _messageNormal 'begin: _build_fallback_upgrade_sequence-ubcp-upgrade'

    _build_fallback_upgrade-ubcp-fetch

    _build_fallback_upgrade-ubcp-extract

    _build_fallback_upgrade-ubcp-upgrade

    _build_fallback_upgrade-ubcp-compress

    _messageNormal 'end: DONE'

    cd "$functionEntryPWD"
    _stop
}

_build_fallback_upgrade-ubcp() {
    "$scriptAbsoluteLocation" _build_fallback_upgrade_sequence-ubcp-upgrade "$@"
}
