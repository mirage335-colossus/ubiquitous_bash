
# ATTENTION: You probably do NOT want to bother with this specialized build system.
#
# WARNING: No production use.
#
# Functions here or imported here are NOT intended for functionality, installation, or build procedures of end-user programs.
# Imports functions from an external file ONLY when relevant functions are called, and does NOT compile substantial code into 'ubiquitous_bash.sh' script files.
#
# Function import through "$scriptLib"/build-ops.sh or similar is usually only appropriate in certain situations:
# 1) Esoteric derivative standalone binary products (eg. direct translations from shellcode functions to microcontroller firmware preprocessor macro libraries, 'ubcp' Cygwin/MSW compatibility layer, etc), ONLY if including/(re)compiling with the larger script is NOT desired and NOT practical.
# 2) Fallback modernizing (ie. upgrading previous versions) certain binary products (eg. static binary executables, dist/OS disk images, etc), skipping a full rebuild either for drastically reduced build times or due to loss of external dependencies.
# 3) Staging procedures called during such fallbacks to integrate and build track record with new functionality (eg. new 'apt-get install' commands for dist/OS disk images) before adding to the compiled script shellcode.
_bin-build_import() {
    
    # Very rare.
    [[ -e "$scriptLib"/_build-esoteric-ops.sh ]] && . "$scriptLib"/_build-esoteric-ops.sh


    [[ -e "$scriptLib"/_build-fallback-ops.sh ]] && . "$scriptLib"/_build-fallback-ops.sh

    [[ -e "$scriptLib"/_build-staging-ops.sh ]] && . "$scriptLib"/_build-staging-ops.sh


    # Discouraged.
    [[ -e "$scriptLib"/_build-ops.sh ]] && . "$scriptLib"/_build-ops.sh


    

    #_safe_declare_uid
    #"$@"
    _bin "$@"

}







