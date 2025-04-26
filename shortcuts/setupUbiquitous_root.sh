

_install_certs() {
    _messageNormal 'install: certs'
    if _if_cygwin
    then
        # Editing the Cygwin root filesystem itself, root permissions granted within Cygwin environment itself are effective.
        sudo() {
            [[ "$1" == "-n" ]] && shift
            "$@"
        }
    fi

    #"$HOME"/core/data/certs/
    #/usr/local/share/ca-certificates/
    #/etc/pki/ca-trust/source/anchors/

    #update-ca-certificates
    #update-ca-trust

    _install_certs_cp_procedure() {
        _messagePlain_nominal '_install_certs: install: '"$2"
        [[ -e "$2" ]] && sudo -n cp -f "$1"/*.crt "$2"
    }
    _install_certs_cp() {
        [[ -e /cygdrive/c/core ]] && mkdir -p /cygdrive/c/core/data/certs/
        _install_certs_cp_procedure "$1" /cygdrive/c/core/data/certs/

        mkdir -p "$HOME"/core/data/certs/
        _install_certs_cp_procedure "$1" "$HOME"/core/data/certs/

        _install_certs_cp_procedure "$1" /usr/local/share/ca-certificates/

        _if_cygwin && _install_certs_cp_procedure "$1" /etc/pki/ca-trust/source/anchors/

        return 0
    }
    _install_certs_write() {
        if [[ -e "$scriptAbsoluteFolder"/_lib/kit/app/researchEngine/kit/certs ]]
        then
            _install_certs_cp "$scriptAbsoluteFolder"/_lib/kit/app/researchEngine/kit/certs
            return
        fi
        if [[ -e "$scriptAbsoluteFolder"/_lib/ubiquitous_bash/_lib/kit/app/researchEngine/kit/certs ]]
        then
            _install_certs_cp "$scriptAbsoluteFolder"/_lib/ubiquitous_bash/_lib/kit/app/researchEngine/kit/certs
            return
        fi
        if [[ -e "$scriptAbsoluteFolder"/_lib/ubDistBuild/_lib/ubiquitous_bash/_lib/kit/app/researchEngine/kit/certs ]]
        then
            _install_certs_cp "$scriptAbsoluteFolder"/_lib/ubDistBuild/_lib/ubiquitous_bash/_lib/kit/app/researchEngine/kit/certs
            return
        fi
        return 1
    }


    _if_cygwin && sudo -n rm -f /etc/pki/tls/certs/*.0

    _install_certs_write

    local currentExitStatus="1"
    ! _if_cygwin && sudo -n update-ca-certificates
    [[ "$?" == "0" ]] && currentExitStatus="0"
    _if_cygwin && sudo -n update-ca-trust
    [[ "$?" == "0" ]] && currentExitStatus="0"

    return "$currentExitStatus"
}






