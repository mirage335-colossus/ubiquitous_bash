
# NOTICE
# ATTRIBUTION-AI: Modern terminate of subprocesses. ubChatGPT o3 GPT-5  2025-09-28



# List all descendants (children, grandchildren, ...) of a PID (one PID per line).
# The PID itself is NOT included.
_descendants_of_pid() {
    local rootPID="$1"
    local -a q=("$rootPID") out=()
    local cur ch
    while ((${#q[@]})); do
        cur="${q[0]}"; q=("${q[@]:1}")
        while read -r ch; do
            [[ -z "$ch" ]] && continue
            out+=("$ch")
            q+=("$ch")
        done < <(pgrep -P "$cur" 2>/dev/null || true)
    done
    ((${#out[@]})) && printf '%s\n' "${out[@]}" | sort -u
}

# Send a signal (default TERM) to descendants only (not the parent/wrapper).
_kill_descendants_only() {
    local rootPID="$1" sig="${2:-TERM}" lst
    lst="$(_descendants_of_pid "$rootPID")"
    if [[ -n "$lst" ]]; then
        # shellcheck disable=SC2086
        kill -s "$sig" $lst 2>/dev/null || true
        ! _if_cygwin && sudo -n kill -s "$sig" $lst 2>/dev/null || true
    fi
}


_terminate() {
    local processListFile
    processListFile="$tmpSelf"/.pidlist_$(_uid)
    local currentPID

    cat "$safeTmp"/.pid >> "$processListFile" 2> /dev/null

    # 1) descendants only (per-connection socats, etc.)
    while read -r currentPID; do
        _kill_descendants_only "$currentPID" TERM
    done < "$processListFile"

    # 2) Kill direct children (listener) so "$@" returns and _stop can run
    while read -r currentPID; do
        pkill -P "$currentPID" 2>/dev/null || true
        ! _if_cygwin && sudo -n pkill -P "$currentPID" 2>/dev/null || true
    done < "$processListFile"

    # 3) Grace period so wrappers can run _stop and clean $safeTmp
    while read -r currentPID; do
        for _i in 1 2 3 4 5; do
            ps --no-headers -p "$currentPID" &>/dev/null || break
            sleep 0.2
        done
        # 4) If still alive, ask wrapper to exit (triggers traps/_stop)
        ps --no-headers -p "$currentPID" &>/dev/null && kill "$currentPID" 2>/dev/null || true
    done < "$processListFile"

    # ... keep your existing backoff/wait code here if present ...

    if [[ "$ub_kill" == "true" ]]; then
        # 5) Last resort
        while read -r currentPID; do
            _kill_descendants_only "$currentPID" KILL
            pkill -KILL -P "$currentPID" 2>/dev/null || true
            kill -KILL "$currentPID" 2>/dev/null || true
            ! _if_cygwin && sudo -n kill -KILL "$currentPID" 2>/dev/null || true
        done < "$processListFile"
    fi

    rm "$processListFile"
}

_terminateMetaHostAll() {
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	
	local processListFile
	processListFile="$tmpSelf"/.pidlist_$(_uid)
	
	local currentPID
	
	cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
	
	while read -r currentPID
	do
		pkill -P "$currentPID"
		kill "$currentPID"
	done < "$processListFile"
	
	rm "$processListFile"
	
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 0.3
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 1
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 3
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 10
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	sleep 20
	! ls -d -1 ./.m_*/.pid > /dev/null 2>&1 && return 0
	
	return 1
}

_terminateAll() {
	"$scriptAbsoluteLocation" _terminateAll_sequence "$@"
}
_terminateAll_sequence() {
	_start
	_terminateAll_procedure "$@"
	_stop "$?"
}
_terminateAll_procedure() {
	_terminateMetaHostAll

    local processListFile
    processListFile="$tmpSelf"/.pidlist_$(_uid)
    local currentPID

    # snapshot of all known wrapper PIDs
    cat ./.s_*/.pid >> "$processListFile" 2> /dev/null
    cat ./.e_*/.pid >> "$processListFile" 2> /dev/null
    cat ./.m_*/.pid >> "$processListFile" 2> /dev/null
    cat ./w_*/.pid  >> "$processListFile" 2> /dev/null

    # 1) descendants only
    while read -r currentPID; do
        _kill_descendants_only "$currentPID" TERM
    done < "$processListFile"

    # 2) direct children (listeners)
    while read -r currentPID; do
        pkill -P "$currentPID" 2>/dev/null || true
        ! _if_cygwin && sudo -n pkill -P "$currentPID" 2>/dev/null || true
    done < "$processListFile"

    # 3) grace for _stop to clean $safeTmp
    while read -r currentPID; do
        for _i in 1 2 3 4 5; do
            ps --no-headers -p "$currentPID" &>/dev/null || break
            sleep 0.2
        done
        # 4) only if still around, nudge parent (runs traps)
        ps --no-headers -p "$currentPID" &>/dev/null && kill "$currentPID" 2>/dev/null || true
    done < "$processListFile"

    if [[ "$ub_kill" == "true" ]]; then
        while read -r currentPID; do
            _kill_descendants_only "$currentPID" KILL
            pkill -KILL -P "$currentPID" 2>/dev/null || true
            kill -KILL "$currentPID" 2>/dev/null || true
            ! _if_cygwin && sudo -n kill -KILL "$currentPID" 2>/dev/null || true
        done < "$processListFile"
    fi

    rm "$processListFile"
}

_killAll_procedure() {
	export ub_kill="true"
	_terminateAll_procedure
	export ub_kill=
}

_killAll() {
	export ub_kill="true"
	_terminateAll
	export ub_kill=
}
