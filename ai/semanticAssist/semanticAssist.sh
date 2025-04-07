



_semanticAssist_bash-backend() {
   export ai_safety="guard"
   
   _convert_bash-backend "$@"
}

_semanticAssist_bash-backend-lowLatency() {
    export ai_safety="guard"

    _convert_bash-backend-lowLatency "$@"
}

# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# CAUTION: DANGER: Keywords generation is more prone to gibberish, special choice of AI LLM model may be required to detect. See documentation for the '_here_semanticAssist-askGibberish' prompt.
_semanticAssist_bash-backend-lowLatency-special() {
    export ai_safety="guard"

    _convert_bash-backend-lowLatency "$@"

    ##provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    #jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'

    ###provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }
    ##jq -Rs '{ model: "meta-llama/llama-4-scout", provider: { "sort": "latency" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}

# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# (ie. usually to change parallelization for high-latency APIs, providers, etc)
_semanticAssist-dispatch() {
    [[ "$1" == "" ]] && return 1
    [[ ! -e "$1" ]] && return 1
    echo 'quick brown fox' | _semanticAssist_bash-backend > /dev/null
    
    #-s 4096
    #-P $(nproc)
    find "$1" -maxdepth 1 -type f -name '*.sh' -print0 | xargs -0 -x -L 1 -P 1 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _semanticAssist_bash_procedure "$@"' _
}


# "$1" == original file
# "$2" == backend function (optional)
# "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
# "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt
_semanticAssist_loop() {
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt

    local currentBackendFunction="$2"
    [[ "$currentBackendFunction" == "" ]] && currentBackendFunction="_semanticAssist_bash-backend"

    local currentIteration=0
    local currentExitStatus=1
    while [[ "$currentExitStatus" != "0" ]] && ! [[ -s "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt ]] && [[ "$currentIteration" -lt 5 ]]
    do
        [[ "$currentIteration" -gt 0 ]] && ( _messagePlain_probe ' retry: '"$1" >&2 ) > /dev/null
        [[ "$currentIteration" -gt 0 ]] && sleep 7
        [[ "$currentIteration" -gt 1 ]] && sleep 90

        ( set -o pipefail ; cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt | "$currentBackendFunction" >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt )
        currentExitStatus="$?"
        sleep 1

        currentIteration=$(( currentIteration + 1 ))
    done
}


_semanticAssist_procedure_procedure() {
    local currentDirectory="$1"
    [[ "$currentDirectory" == "" ]] && currentDirectory="$scriptLocal"/knowledge/"$objectName"

    
    _semanticAssist-dispatch "$currentDirectory"
    sleep 0.1

    ( _messagePlain_probe 'done: _semanticAssist ...' >&2 ) > /dev/null
}
_semanticAssist_sequence() {
    _start

    _semanticAssist_procedure_procedure "$@"

    _stop
}
_semanticAssist() {
    "$scriptAbsoluteLocation" _semanticAssist_sequence "$@"
}















