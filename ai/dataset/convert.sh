
#./ubiquitous_bash.sh _convert_bash ./_local/dataset/ubiquitous_bash



# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# ollama binary
#_convert_bash-backend() {
    # DANGER: CAUTION: Although this is apparently standard practice for the 'ollama' program, and '/clear', etc, are apparently not interpreted from the input pipe, reliable safe input handling may not be guaranteed
    #ollama run --verbose Llama-augment
#}
# ollama API (localhost)
_convert_bash-backend() {
    jq -Rs '{model:"Llama-augment", prompt:., stream: false}' | curl -fsS --max-time 120 -X POST -H "Content-Type: application/json" --data-binary @- http://localhost:11434/api/generate | jq -r '.response'
}
# openrouter API
#_convert_bash-backend() {
    ##provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    #jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
#}

# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# (ie. usually to change parallelization for high-latency APIs, providers, etc)
_convert_bash-dispatch() {
    echo 'quick brown fox' | _convert_bash-backend > /dev/null
    
    #-s 4096
    #-P $(nproc)
    find "$1" -maxdepth 1 -type f ! -iname '*.description.txt' ! -iname '*.prompt.txt' -print0 | xargs -0 -x -L 1 -P 1 bash -c '_convert_bash_procedure "$@"' _
}

_convert_bash_procedure() {
    local inputName
    inputName=$(basename "$1")

    _here_convert_bash-description > "$safeTmp"/"$inputName".tmp_input.txt

    echo '```bash' >> "$safeTmp"/"$inputName".tmp_input.txt
    cat "$1" >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '```' >> "$safeTmp"/"$inputName".tmp_input.txt

    _here_convert_bash-additive > "$1".prompt.txt

    ( _messagePlain_probe 'description: '"$1" >&2 ) > /dev/null

    local currentIteration=0
    local currentExitStatus=1
    while [[ "$currentExitStatus" != "0" ]] && ! [[ -s "$safeTmp"/"$inputName".tmp_output.txt ]] && [[ "$currentIteration" -lt 5 ]]
    do
        [[ "$currentIteration" -gt 0 ]] && ( _messagePlain_probe ' retry: '"$1" >&2 ) > /dev/null
        [[ "$currentIteration" -gt 0 ]] && sleep 7

        ( set -o pipefail ; cat "$safeTmp"/"$inputName".tmp_input.txt | _convert_bash-backend > "$safeTmp"/"$inputName".tmp_output.txt )
        currentExitStatus="$?"
        sleep 1

        currentIteration=$(( currentIteration + 1 ))
    done
    
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".prompt.txt

    rm -f "$safeTmp"/"$inputName".tmp_input.txt
    rm -f "$safeTmp"/"$inputName".tmp_output.txt
}
_convert_bash_procedure_procedure() {
    export -f _here_convert_bash-description

    export -f _convert_bash-backend
    export -f _here_convert_bash-additive
    export -f _convert_bash_procedure

	export -f "_messagePlain_nominal"
	export -f "_color_begin_nominal"
	export -f "_color_end"
	export -f "_getAbsoluteLocation"
	export -f "_realpath_L_s"
	export -f "_realpath_L"
	export -f "_compat_realpath_run"
	export -f "_compat_realpath"
	export -f "_messagePlain_probe_var"
	export -f "_color_begin_probe"
	export -f "_messagePlain_probe"
    
    _convert_bash-dispatch "$@"
    sleep 0.1

    ( _messagePlain_probe 'done: _convert_bash ...' >&2 ) > /dev/null
}
_convert_bash_sequence() {
    _start

    _convert_bash_procedure_procedure "$@"

    _stop
}
_convert_bash() {
    "$scriptAbsoluteLocation" _convert_bash_sequence "$@"
}



