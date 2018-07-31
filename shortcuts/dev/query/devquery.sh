#Simulated client/server discussion testing.

_prepare_query_prog() {
	true
}

_prepare_query() {
	export ub_queryclientdir="$queryTmp"/client
	export qc="$ub_queryclientdir"
	
	export ub_queryclient="$ub_queryclientdir"/script
	export qce="$ub_queryclient"
	
	export ub_queryserverdir="$queryTmp"/server
	export qs="$ub_queryserverdir"
	
	export ub_queryserver="$ub_queryserverdir"/script
	export qse="$ub_queryserver"
	
	mkdir -p "$ub_queryclientdir"
	mkdir -p "$ub_queryserverdir"
	
	! [[ -e "$ub_queryclient" ]] && cp "$scriptAbsoluteLocation" "$ub_queryclient"
	! [[ -e "$ub_queryserver" ]] && cp "$scriptAbsoluteLocation" "$ub_queryserver"
	
	_prepare_query_prog "$@"
}

_queryServer() {
	_prepare_query
	"$ub_queryserver" "$@"
}
_qs() {
	_queryServer "$@"
}

_queryClient() {
	_prepare_query
	"$ub_queryclient" "$@"
}
_qc() {
	_queryClient "$@"
}

#Example only. Overload with "core.sh" or similar.
_query() {
	( cd "$qc" ; _queryClient _bin cat | ( cd "$qs" ; _queryServer _bin cat | ( cd "$ub_queryserverdir" ; _queryClient _bin cat )))
}
