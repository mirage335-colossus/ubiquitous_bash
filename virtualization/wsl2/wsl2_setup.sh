

# End user function .
_setup_wsl2_procedure() {
    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && return 1
    
    _messageNormal 'init: _setup_wsl2'
    
    _messagePlain_nominal 'setup: write: _write_msw_WSLENV'
    _write_msw_WSLENV

    _messagePlain_nominal 'setup: write: _write_msw_wslconfig'
    _write_wslconfig "ub_ignore_kernel_wsl"

    _messagePlain_nominal 'setup: wsl2'
    
    # https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10
    
    _messagePlain_probe dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    _messagePlain_probe dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    _messagePlain_probe wsl --set-default-version 2
    wsl --set-default-version 2

    _messagePlain_probe wsl --update
    wsl --update

    sleep 45
    wsl --update

    sleep 5
    wsl --update

    sleep 5
    wsl --update
}
_setup_wsl2() {
    "$scriptAbsoluteLocation" _setup_wsl2_procedure "$@"
}
_setup_wsl() {
    _setup_wsl2 "$@"
}







