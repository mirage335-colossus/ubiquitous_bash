#http://stackoverflow.com/questions/687948/timeout-a-command-in-bash-without-unnecessary-delay
_timeout() { ( set +b; sleep "$1" & "${@:2}" & wait -n; r=$?; kill -9 `jobs -p`; exit $r; ) } 


# --- Strict timeout: non-zero on timeout, prefer coreutils 'timeout' ---
_timeout_strict() {
  # Function required to actually return failure upon timeout
  # This enables proper retry on asset upload 
  # New function introduced so as to not affect earlier usages 
  _messagePlain_probe "_timeout_strict → $(printf '%q ' "$@")"
  if command -v timeout >/dev/null 2>&1; then
    # Expected exits:
    #  0: success
    #  124: command timeout
    #  125: timeout command failed 
    #  126/7: command could not run
    #  Other: command exit code 
    _messagePlain_probe "_timeout_strict: coreutils timeout path"
    timeout -k 5 "$@"; local rc=$?
    _messagePlain_probe "_timeout_strict: coreutils rc=$rc"
    return "$rc"
  fi

  _messagePlain_warn "==rmh== **** TEMP _timeout_strict() PATH ***"
  _messagePlain_probe "_timeout_strict: fallback path"
  # path not dynamically tested due to coreutils being present 
  (
    set +b
    local secs rc krc
    secs="$1"; shift
    _messagePlain_probe "_timeout_strict(fb): secs=$(printf '%q' "$secs") cmd=$(printf '%q ' "$@")"
    "$@" & local cmd=$!
    _messagePlain_probe "_timeout_strict(fb): cmd pid=$cmd"
    (
      sleep "$secs"
      # Process should have completed. If not, try to Term/Kill
      if kill -0 "$cmd" 2>/dev/null; then
        _messageWARN "_timeout_strict(fb): timeout fired → TERM pid $cmd"
        kill -TERM "$cmd" 2>/dev/null
        sleep 3
        if kill -0 "$cmd" 2>/dev/null; then
          _messageWARN "_timeout_strict(fb): escalation → KILL $cmd"
          kill -KILL "$cmd" 2>/dev/null
        fi
        exit 124      # value for subprocess - not exposed to function
      fi
      exit 0
    ) & local killer=$!
    _messagePlain_probe "_timeout_strict(fb): killer pid=$killer"

    wait "$cmd"; rc=$?
    _messagePlain_probe "_timeout_strict(fb): cmd exited rc=$rc"

    # learn what the timer did
    if kill -0 "$killer" 2>/dev/null; then
      _messagePlain_probe "_timeout_strict(fb): cancel timer pid=$killer"
      kill -TERM "$killer" 2>/dev/null
      wait "$killer" 2>/dev/null
      krc=0
    else
      wait "$killer"; krc=$?
    fi

    case "$krc" in
      124) _messageWARN "_timeout_strict(fb): timer exited 124 (timeout occurred)";;
      0)   _messagePlain_probe "_timeout_strict(fb): timer exited 0 (no timeout)";;
      *)   _messageWARN "_timeout_strict(fb): timer exited rc=$krc";;
    esac

    _messagePlain_probe "_timeout_strict(fb): returning rc=$rc"
    exit "$rc"
    # Expected return values
    #  0: success of command 
    #  143: TERMinated
    #  137: KILLed 
    #  Other: command value 
  )
}