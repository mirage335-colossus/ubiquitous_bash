

_set_msw_qt5ct() {
    [[ "$QT_QPA_PLATFORMTHEME" != "qt5ct" ]] && export QT_QPA_PLATFORMTHEME=qt5ct
    if [[ "$WSLENV" != "QT_QPA_PLATFORMTHEME" ]] && [[ "$WSLENV" != "QT_QPA_PLATFORMTHEME"* ]] && [[ "$WSLENV" != *"QT_QPA_PLATFORMTHEME" ]] && [[ "$WSLENV" != *"QT_QPA_PLATFORMTHEME"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="QT_QPA_PLATFORMTHEME"
        else
            export WSLENV="$WSLENV:QT_QPA_PLATFORMTHEME"
        fi
    fi
    return 0
}

# wsl printenv | grep QT_QPA_PLATFORMTHEME
# ATTENTION: Will also unset QT_QPA_PLATFORMTHEME if appropriate (and for this reason absolutely should be hooked by 'Linux' shells).
# Strongly recommend writing the ' export QT_QPA_PLATFORMTHEME=qt5ct ' or equivalent statement to ' /etc/environment.d/ub_wsl2_qt5ct.sh ' , '/etc/environment.d/90ub_wsl2_qt5ct.conf' , or similarly effective non-login non-interactive shell startup script.
#  Unfortunately, '/etc/environment.d' is usually ignored by (eg. Debian) Linux distributions, to the point that variables declared by files provided by installed packages are not exported to any apparent environment.
#  Alternatives attempted include:
#  /etc/security/pam_env.conf
#  ~/.bashrc
#  ~/.bash_profile
#  ~/.profile
_set_qt5ct() {
    if [[ "$DISPLAY" == ":0" ]]
    then
        export QT_QPA_PLATFORMTHEME=qt5ct
    else
        export QT_QPA_PLATFORMTHEME=
        unset QT_QPA_PLATFORMTHEME
    fi
    
    _write_wsl_qt5ct_conf "$@"

    return 0
}


_set_msw_lang() {
    [[ "$LANG" != "C" ]] && export LANG=C
    if [[ "$WSLENV" != "LANG" ]] && [[ "$WSLENV" != "LANG"* ]] && [[ "$WSLENV" != *"LANG" ]] && [[ "$WSLENV" != *"LANG"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="LANG"
        else
            export WSLENV="$WSLENV:LANG"
        fi
    fi
    return 0
}

_set_lang-forWSL() {
    [[ "$LANG" != "C" ]] && export LANG="C"
    return 0
}


_set_discreteGPU-forWSL() {
    [[ "$MESA_D3D12_DEFAULT_ADAPTER_NAME" != "" ]] && return 0
    
    # https://github.com/microsoft/wslg/wiki/GPU-selection-in-WSLg
    if type -p glxinfo > /dev/null 2>&1
    then
        glxinfo -B | grep -i intel > /dev/null 2>&1 && export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
        return
    fi
}

_set_msw_ghToken() {
    if [[ "$WSLENV" != "GH_TOKEN" ]] && [[ "$WSLENV" != "GH_TOKEN"* ]] && [[ "$WSLENV" != *"GH_TOKEN" ]] && [[ "$WSLENV" != *"GH_TOKEN"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="GH_TOKEN"
        else
            export WSLENV="$WSLENV:GH_TOKEN"
        fi
    fi
    return 0
}

_set_msw_apiToken() {
    if [[ "$WSLENV" != "OPENAI_API_KEY" ]] && [[ "$WSLENV" != "OPENAI_API_KEY"* ]] && [[ "$WSLENV" != *"OPENAI_API_KEY" ]] && [[ "$WSLENV" != *"OPENAI_API_KEY"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="OPENAI_API_KEY"
        else
            export WSLENV="$WSLENV:OPENAI_API_KEY"
        fi
    fi
    if [[ "$WSLENV" != "OPENROUTER_API_KEY" ]] && [[ "$WSLENV" != "OPENROUTER_API_KEY"* ]] && [[ "$WSLENV" != *"OPENROUTER_API_KEY" ]] && [[ "$WSLENV" != *"OPENROUTER_API_KEY"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="OPENROUTER_API_KEY"
        else
            export WSLENV="$WSLENV:OPENROUTER_API_KEY"
        fi
    fi
    if [[ "$WSLENV" != "HF_AKI_KEY" ]] && [[ "$WSLENV" != "HF_AKI_KEY"* ]] && [[ "$WSLENV" != *"HF_AKI_KEY" ]] && [[ "$WSLENV" != *"HF_AKI_KEY"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="HF_AKI_KEY"
        else
            export WSLENV="$WSLENV:HF_AKI_KEY"
        fi
    fi
    if [[ "$WSLENV" != "HF_TOKEN" ]] && [[ "$WSLENV" != "HF_TOKEN"* ]] && [[ "$WSLENV" != *"HF_TOKEN" ]] && [[ "$WSLENV" != *"HF_TOKEN"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="HF_TOKEN"
        else
            export WSLENV="$WSLENV:HF_TOKEN"
        fi
    fi
    if [[ "$WSLENV" != "PUBLIC_KEY" ]] && [[ "$WSLENV" != "PUBLIC_KEY"* ]] && [[ "$WSLENV" != *"PUBLIC_KEY" ]] && [[ "$WSLENV" != *"PUBLIC_KEY"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="PUBLIC_KEY"
        else
            export WSLENV="$WSLENV:PUBLIC_KEY"
        fi
    fi
    if [[ "$WSLENV" != "JUPYTER_PASSWORD" ]] && [[ "$WSLENV" != "JUPYTER_PASSWORD"* ]] && [[ "$WSLENV" != *"JUPYTER_PASSWORD" ]] && [[ "$WSLENV" != *"JUPYTER_PASSWORD"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="JUPYTER_PASSWORD"
        else
            export WSLENV="$WSLENV:JUPYTER_PASSWORD"
        fi
    fi
    if [[ "$WSLENV" != "ai_safety" ]] && [[ "$WSLENV" != "ai_safety"* ]] && [[ "$WSLENV" != *"ai_safety" ]] && [[ "$WSLENV" != *"ai_safety"* ]]
    then
        if [[ "$WSLENV" == "" ]]
        then
            export WSLENV="ai_safety"
        else
            export WSLENV="$WSLENV:ai_safety"
        fi
    fi
    return 0
}


_set_msw_wsl() {
    ! _if_cygwin && return 1

    _set_msw_lang
    _set_msw_qt5ct

    _set_msw_ghToken
    _set_msw_apiToken

    return 0
}

_set_wsl() {
    ! uname -a | grep -i 'microsoft' > /dev/null 2>&1 && return 1
    ! uname -a | grep -i 'WSL2' > /dev/null 2>&1 && return 1

    _set_lang-forWSL
    _set_qt5ct

    [[ "$LIBVA_DRIVER_NAME" != "d3d12" ]] && export LIBVA_DRIVER_NAME=d3d12

    _set_discreteGPU-forWSL

    return 0
}



! _set_msw_wsl && _set_wsl





