
#_bin-build_import

#export safeToDeleteGit='true'
#_safeRMR "$scriptLocal"/upgradeTmp

#export FORCE_AXEL=8
#_build_fallback_upgrade-ubcp-fetch "internal"
_build_fallback_upgrade-ubcp-fetch() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-fetch'

    local currentReleaseLabelTag="$1"
    #[[ "$currentReleaseLabelTag" == "" ]] && currentReleaseLabelTag="internal"
    [[ "$currentReleaseLabelTag" == "" ]] && currentReleaseLabelTag="spring"

    local current_wget_githubRelease_function="$2"
    [[ "$current_wget_githubRelease_function" == "" ]] && current_wget_githubRelease_function="_wget_githubRelease"

    mkdir -p "$scriptLocal"/upgradeTmp
    cd "$scriptLocal"/upgradeTmp
    
    rm -f "$scriptLocal"/upgradeTmp/missing-ubcp-binReport


    #rm -f "$scriptLocal"/upgradeTmp/lean_compressed.sh
    #rm -f "$scriptLocal"/upgradeTmp/missing-ubcp-binReport
    #rm -f "$scriptLocal"/upgradeTmp/missing-ubcp-packageReport
    #rm -f "$scriptLocal"/upgradeTmp/monolithic_compressed.sh
    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.7z
    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.log
    #rm -f "$scriptLocal"/upgradeTmp/rotten_compressed.sh
    #rm -f "$scriptLocal"/upgradeTmp/ubcore_compressed.sh
    rm -f "$scriptLocal"/upgradeTmp/ubcp-binReport
    rm -f "$scriptLocal"/upgradeTmp/ubcp-cygwin-portable-installer.log
    rm -f "$scriptLocal"/upgradeTmp/ubcp-packageReport
    #rm -f "$scriptLocal"/upgradeTmp/ubiquitous_bash_compressed.sh
    rm -f "$scriptLocal"/upgradeTmp/_custom_splice_opensslConfig.log
    rm -f "$scriptLocal"/upgradeTmp/_mitigate-ubcp.log
    rm -f "$scriptLocal"/upgradeTmp/_setupUbiquitous.log
    rm -f "$scriptLocal"/upgradeTmp/_test-lean.log


    # UNIX/Linux upgrade/build environment cannot run Cygwin/MSW commands. Some logs will be inherited from previous build.
    # Scribe info is recommended to state traceability to upgraded previous build.
    # Some logs, such as '_test-lean.log' could theoretically directly run through UNIX/Linux upgrade/build environment, however, that would only duplicate issues found in UNIX/Linux tests, neglecting the possibility of any Cygwin/MSW specific issues.
    #  If UNIX/Linux environment is used to create another '_test' log, this should be named '_test-lean-linux.log' or similar to clearly indicate Cygwin/MSW specific issues will NOT be represented in that log.
    # Better to inherit binReport and not tinker with the relevant Cygwin/MSW filesystem directories. Not usually necessary, and difficult to adequately generate such a report from UNIX/Linux.
    #  Alternatively, especially until sufficient confidence has been established by track record that the extract/compress and upgrade procedures are not damaging the Cygwin/MSW filesystem, a CI environment may use the Cygwin/MSW environment for the _report_setup_ubcp function.
    #   No need to delete or avoid creating these reports. If a CI environment uses a Cygwin/MSW environment, then obviously a separate ephemeral dist/OS will not include reports fetched or otherwise created from UNIX/Linux .
    cd "$scriptLocal"/upgradeTmp
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "ubcp-binReport" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "ubcp-cygwin-portable-installer.log" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "ubcp-packageReport" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "_custom_splice_opensslConfig.log" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "_mitigate-ubcp.log" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "_setupUbiquitous.log" && _messageFAIL
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "_test-lean.log" && _messageFAIL


    mkdir -p "$scriptLocal"/upgradeTmp/package_ubcp-core
    rm -f "$scriptLocal"/upgradeTmp/package_ubcp-core.7z

    cd "$scriptLocal"/upgradeTmp
    ! "$current_wget_githubRelease_function" "mirage335-colossus/ubiquitous_bash" "$currentReleaseLabelTag" "package_ubcp-core.7z" -O "$scriptLocal"/upgradeTmp/package_ubcp-core.7z && _messageFAIL

    return 0
}
_build_fallback_upgrade-ubcp-fetch-fromTag() {
    _build_fallback_upgrade-ubcp-fetch "$1" "_wget_githubRelease-fromTag"
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
    
    if [[ "$skimfast" != "false" ]]
    then
        7z -y a -t7z -m0=lzma2 -mmt=6 -mx=2 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./ubcp .//ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        return
    else
        7z -y a -t7z -m0=lzma2 -mmt=6 -mx=9 "$scriptLocal"/upgradeTmp/package_ubcp-core.7z ./ubcp ./ubiquitous_bash ./_bash.bat | tee "$scriptLocal"/upgradeTmp/package_ubcp-core.log
        return
    fi
}

_build_fallback_upgrade-ubcp-report-binReport() {
    _messageNormal 'init: _build_fallback_upgrade-ubcp-report-binReport'

    ##find "$scriptLocal"/upgradeTmp/package_ubcp-core/bin/ "$scriptLocal"/upgradeTmp/package_ubcp-core/usr/bin/ "$scriptLocal"/upgradeTmp/package_ubcp-core/sbin/ "$scriptLocal"/upgradeTmp/package_ubcp-core/usr/sbin/ | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-binReport > /dev/null

    # In practice, a binReport from UNIX/Linux regarding the contents of the 7z file, is drastically different from a binReport generated from within Cygwin/MSW. Best to just not tinker with the relevant files on the Cygwin/MSW filesystem. If a binReport is created from UNIX/Linux, the filename should clarify that unusual situation.
    #return 1

    # ATTRIBUTION-AI: ChatGPT o1 2025-01-30 'Think' ... partially
    (
    cd "$scriptLocal/upgradeTmp/package_ubcp-core/ubcp/cygwin" || exit 1

    # Only descend into these subdirs
    #find bin usr/bin sbin usr/sbin -type f -printf '/%P\n'
    find bin -type f -printf '/bin/%P\n'
    find usr/bin -type f -printf '/usr/bin/%P\n'
    find sbin -type f -printf '/sbin/%P\n'
    find usr/sbin -type f -printf '/usr/sbin/%P\n'
) | tee "$scriptLocal"/upgradeTmp/ubcp-binReport-UNIX_Linux > /dev/null

    (
    cd "$scriptLocal/upgradeTmp/package_ubcp-core/ubcp/cygwin" || exit 1

    # Only descend into these subdirs
    #find bin usr/bin sbin usr/sbin -type f -printf '/%P\n'
    find home/root -type f -printf '/bin/%P\n'
    find usr/bin -type f -printf '/usr/bin/%P\n'
    find sbin -type f -printf '/sbin/%P\n'
    find usr/sbin -type f -printf '/usr/sbin/%P\n'
) | tee "$scriptLocal"/upgradeTmp/ubcp-homeReport-UNIX_Linux > /dev/null
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
    ! _messagePlain_probe_cmd git reset --hard && _messagePlain_bad 'fail: upgrade-ubiquitous_bash: git reset --hard' && _messageFAIL

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

    #_build_fallback_upgrade-ubcp-report-binReport "$@"

    _build_fallback_upgrade-ubcp-compress "$@"

    _messageNormal 'end: DONE'

    cd "$functionEntryPWD"
    _stop
}

_build_fallback_upgrade-ubcp() {
    "$scriptAbsoluteLocation" _build_fallback_upgrade_sequence-ubcp-upgrade "$@"
}
