#####Entry

# WARNING: Do not add code directly here without disabling checksum!
# WARNING: Checksum may only be disabled either by override of 'generic/minimalheader.sh' or by adding appropriate '.nck' file !

#"$scriptAbsoluteLocation" _setup


_main "$@"

[[ "$1" == '_'* ]] && type "$1" > /dev/null 2>&1 && "$@"

