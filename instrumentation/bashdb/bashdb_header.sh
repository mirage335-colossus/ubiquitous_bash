##### No production use. Does not work.

[[ "$bashDBabsoluteLocaton" == "" ]] && export bashDBabsoluteLocaton=$(_discoverResource bashdb-code/bashdb-trace)

! [[ "$bashDBabsoluteLocaton" == "" ]] && source "$bashDBabsoluteLocaton"
! [[ "$bashDBabsoluteLocaton" == "" ]] && _Dbg_debugger

