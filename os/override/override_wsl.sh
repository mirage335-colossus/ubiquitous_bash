
# Discouraged. Few file paths, some setup, etc, may be different. Otherwise, WSL should not be treated differently.
_if_wsl() {
    uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
}

if [[ "$WSL_DISTRO_NAME" != "" ]] && _if_wsl
then
    
    # WARNING: CAUTION: Adding some native MSWindows programs from MSWindows path (eg. python) may cause conflicts with native WSL/Linux equivalent programs, etc.
    
    # NOTICE: Native ubdist/OS, WSL/Linux, etc, equivalent, is 'xdg-open', etc .
    #! type explorer > /dev/null 2>&1 && [[ -e /mnt/c/Windows/System32/explorer.exe ]] && explorer() { /mnt/c/Windows/System32/explorer.exe "$@"; }
    ! type explorer > /dev/null 2>&1 && [[ -e /mnt/c/Windows/explorer.exe ]] && explorer() { /mnt/c/Windows/explorer.exe "$@"; }
    #! type explorer > /dev/null 2>&1 && [[ -e /mnt/d/Windows/System32/explorer.exe ]] && explorer() { /mnt/d/Windows/System32/explorer.exe "$@"; }
    ! type explorer > /dev/null 2>&1 && [[ -e /mnt/d/Windows/explorer.exe ]] && explorer() { /mnt/d/Windows/explorer.exe "$@"; }
fi

