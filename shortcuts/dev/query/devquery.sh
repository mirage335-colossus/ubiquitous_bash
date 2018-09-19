#Simulated client/server discussion testing.

# ATTENTION: Overload with "core.sh" or similar.
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
	export queryType="server"
	"$ub_queryserver" "$@"
}
_qs() {
	_queryServer "$@"
}

_queryClient() {
	export queryType="client"
	"$ub_queryclient" "$@"
}
_qc() {
	_queryClient "$@"
}

# ATTENTION: Overload with "core.sh" or similar.
_query() {
	_prepare_query
	
	( cd "$qc" ; _queryClient _bin cat | ( cd "$qs" ; _queryServer _bin cat | ( cd "$ub_queryserverdir" ; _queryClient _bin cat )))
}
