

# End user function .
_setup_wsl2_procedure() {
    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && return 1
    
    _messageNormal 'init: _setup_wsl2'
    
    _messagePlain_nominal 'setup: write: _write_msw_qt5ct'
    _write_msw_qt5ct

    _messagePlain_nominal 'setup: write: _write_msw_wslconfig'
    _write_wslconfig

    _messagePlain_nominal 'setup: wsl2'
    
    # https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10
    
    _messagePlain_probe dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    _messagePlain_probe dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    _messagePlain_probe wsl --set-default-version 2
    wsl --set-default-version 2
}
_setup_wsl2() {
    "$scriptAbsoluteLocation" _setup_wsl2_procedure "$@"
}
_setup_wsl() {
    _setup_wsl2 "$@"
}

# End user function .
_setup_vm-wsl2_sequence() {
    _start
    local functionEntryPWD
    functionEntryPWD="$PWD"

    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && _stop 1

    if [[ -e "$scriptLocal"/package_rootfs.tar.flx ]] && [[ ! -e "$scriptLocal"/package_rootfs.tar ]]
    then
        cat "$scriptLocal"/package_rootfs.tar.flx | lz4 -d -c > "$scriptLocal"/package_rootfs.tar
        rm -f "$scriptLocal"/package_rootfs.tar.flx
    fi

    [[ ! -e "$scriptLocal"/package_rootfs.tar ]] && _messagePlain_bad 'bad: missing: package_rootfs.tar' && _messageFAIL && _stop 1


    mkdir -p '/cygdrive/c/core/infrastructure/ubdist_wsl'
    _userMSW _messagePlain_probe wsl --import ubdist '/cygdrive/c/core/infrastructure/ubdist_wsl' "$scriptLocal"/package_rootfs.tar --version 2
    _userMSW wsl --import ubdist '/cygdrive/c/core/infrastructure/ubdist_wsl' "$scriptLocal"/package_rootfs.tar --version 2

    _messagePlain_probe wsl --set-default ubdist
    wsl --set-default ubdist

    #wsl --unregister ubdist

    cd "$functionEntryPWD"
    _stop
}
_setup_vm-wsl2() {
    "$scriptAbsoluteLocation" _setup_vm-wsl2_sequence "$@"
}
_setup_vm-wsl() {
    _setup_vm-wsl2 "$@"
}






