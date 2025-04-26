

# ATTENTION: EXAMPLE. Override or implement alternative with 'core.sh', 'ops.sh', or similar.
# ATTENTION: Also create "$scriptLib"/python/lean.py .
_special_packages() {
    #export dependencies_nix_python=( "readline" )
    #export packages_nix_python=( "huggingface_hub[cli]" )

    #export dependencies_msw_python=( "pyreadline3" )
    #export packages_msw_python=( "huggingface_hub[cli]" )
        
    #export dependencies_cyg_python=( "readline" )
    #export packages_cyg_python=( "huggingface_hub[cli]" )

    true
}
_special_python() {
    _special_packages

    if _if_cygwin
    then
        _msw_python "$@"
        return
    fi

    _nix_python "$@"
    return
}
# ATTENTION: Call from '_test_prog' with 'core.sh' or similar.
# _setup calls _test calls _test_prog
_test_special_python() {
    _special_packages

    if _if_cygwin
    then
        _test_msw_python "$@"
        return
    fi

    _test_nix_python "$@"
    return
}

