
#./ubiquitous_bash.sh _convert_bash ./_local/dataset/ubiquitous_bash



# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# ollama binary
#_convert_bash-backend() {
    # DANGER: CAUTION: Although this is apparently standard practice for the 'ollama' program, and '/clear', etc, are apparently not interpreted from the input pipe, reliable safe input handling may not be guaranteed
    #ollama run --verbose Llama-3-augment
#}
# ollama API (localhost)
_convert_bash-backend() {
    jq -Rs '{model:"Llama-3-augment", prompt:., stream: false}' | curl -fsS --max-time 120 -X POST -H "Content-Type: application/json" --data-binary @- http://localhost:11434/api/generate | jq -r '.response'
}
# openrouter API
#_convert_bash-backend() {
    ##provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    ##provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }
    ##provider: { "order": ["Fireworks"], "sort": "throughput" }
    #jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
#}

# ATTENTION: Override with 'ops.sh' or similar if appropriate.
_convert_bash-backend-lowLatency() {
    _convert_bash-backend "$@"
}

# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# (ie. usually to change parallelization for high-latency APIs, providers, etc)
_convert_bash-dispatch() {
    [[ "$1" == "" ]] && return 1
    [[ ! -e "$1" ]] && return 1
    echo 'quick brown fox' | _convert_bash-backend > /dev/null
    
    #-s 4096
    #-P $(nproc)
    find "$1" -maxdepth 1 -type f ! -iname '*.prompt.txt' ! -iname '*.response.txt' ! -iname '*.continue_prompt.txt' ! -iname '*.continue_response.txt' ! -iname '*.description.txt' -print0 | xargs -0 -x -L 1 -P 1 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _convert_bash_procedure "$@"' _
}


# "$1" == original file
# "$2" == backend function (optional)
# "$safeTmp"/"$inputName".tmp_input.txt
# "$safeTmp"/"$inputName".tmp_output.txt
_convert_loop() {
    rm -f "$safeTmp"/"$inputName".tmp_output.txt

    local currentBackendFunction="$2"
    [[ "$currentBackendFunction" == "" ]] && currentBackendFunction="_convert_bash-backend"

    local currentIteration=0
    local currentExitStatus=1
    while [[ "$currentExitStatus" != "0" ]] && ! [[ -s "$safeTmp"/"$inputName".tmp_output.txt ]] && [[ "$currentIteration" -lt 5 ]]
    do
        [[ "$currentIteration" -gt 0 ]] && ( _messagePlain_probe ' retry: '"$1" >&2 ) > /dev/null
        [[ "$currentIteration" -gt 0 ]] && sleep 7
        [[ "$currentIteration" -gt 1 ]] && sleep 90

        ( set -o pipefail ; cat "$safeTmp"/"$inputName".tmp_input.txt | "$currentBackendFunction" >> "$safeTmp"/"$inputName".tmp_output.txt )
        currentExitStatus="$?"
        sleep 1

        currentIteration=$(( currentIteration + 1 ))
    done
}


_convert_bash_procedure() {
    local inputName
    inputName=$(basename "$1")



    # ### Creates "$1".prompt.txt .
    ( _messagePlain_nominal '.prompt.txt: '"$1" >&2 ) > /dev/null
    rm -f "$1".prompt.txt > /dev/null 2>&1

    # Prompt header (boilerplate, please generate code from description).
    _here_convert_bash_promptResponse-boilerplate_promptHeader >> "$1".prompt.txt

    # Prompt description (to generate code from).
    rm -f "$safeTmp"/"$inputName".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName".tmp_output.txt > /dev/null 2>&1
    _here_convert_bash_promptResponse-askDescription > "$safeTmp"/"$inputName".tmp_input.txt
    echo '```bash' >> "$safeTmp"/"$inputName".tmp_input.txt
    cat "$1" >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '```' >> "$safeTmp"/"$inputName".tmp_input.txt
    _convert_loop "$1"
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".prompt.txt



    # ### Creates "$1".response.txt .
    ( _messagePlain_nominal '.response.txt: '"$1" >&2 ) > /dev/null
    rm -f "$1".response.txt > /dev/null 2>&1
    
    # Response header.
    rm -f "$safeTmp"/"$inputName".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName".tmp_output.txt > /dev/null 2>&1
    cat "$1".prompt.txt > "$safeTmp"/"$inputName".tmp_input.txt
    echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '```bash' >> "$safeTmp"/"$inputName".tmp_input.txt
    cat "$1" > "$safeTmp"/"$inputName".tmp_input.txt
    echo '```' >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    _here_convert_bash_promptResponse-ask_responseHeader >> "$safeTmp"/"$inputName".tmp_input.txt
    _convert_loop "$1" "_convert_bash-backend-lowLatency"
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".response.txt

    # Response (ie. original code as example to generate from explanation).
    #echo '' >> "$1".response.txt
    echo '```bash' >> "$1".response.txt
    cat "$1" >> "$1".response.txt
    echo '```' >> "$1".response.txt
    #echo '' >> "$1".response.txt

    # Response footer.
    rm -f "$safeTmp"/"$inputName".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName".tmp_output.txt > /dev/null 2>&1
    cat "$1".prompt.txt > "$safeTmp"/"$inputName".tmp_input.txt
    echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '```bash' >> "$safeTmp"/"$inputName".tmp_input.txt
    cat "$1" > "$safeTmp"/"$inputName".tmp_input.txt
    echo '```' >> "$safeTmp"/"$inputName".tmp_input.txt
    echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    _here_convert_bash_promptResponse-ask_responseFooter >> "$safeTmp"/"$inputName".tmp_input.txt
    _convert_loop "$1" "_convert_bash-backend-lowLatency"
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".response.txt



    # ### Creates "$1".continue_prompt.txt .
    ( _messagePlain_nominal '.continue_prompt.txt: '"$1" >&2 ) > /dev/null
    rm -f "$1".continue_prompt.txt > /dev/null 2>&1

    # Continue Prompt header (boilerplate, continue the shellcode).
    _here_convert_bash_continuePromptResponse-boilerplate_promptHeader >> "$1".continue_prompt.txt

    # Continue Prompt (shellcode to continue)
    #echo >> "$1".continue_prompt.txt
    echo '```bash' >> "$1".continue_prompt.txt
    cat "$1" >> "$1".continue_prompt.txt
    echo '```' >> "$1".continue_prompt.txt
    #echo >> "$1".continue_prompt.txt



    # ### Creates "$1".continue_response.txt .
    ( _messagePlain_nominal '.continue_response.txt: '"$1" >&2 ) > /dev/null
    rm -f "$1".continue_response.txt > /dev/null 2>&1

    # Continue Response header.
    rm -f "$safeTmp"/"$inputName".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName".tmp_output.txt > /dev/null 2>&1
    cat "$1".continue_prompt.txt > "$safeTmp"/"$inputName".tmp_input.txt
    #echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    _here_convert_bash_continuePromptResponse-ask_responseHeader >> "$safeTmp"/"$inputName".tmp_input.txt
    _convert_loop "$1" "_convert_bash-backend-lowLatency"
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".continue_response.txt

    # Continue Response (segment of original code as example of continuing previous code)
    #echo >> "$1".continue_response.txt
    echo '```bash' >> "$1".continue_response.txt
    cat "$1" >> "$1".continue_response.txt
    echo '```' >> "$1".continue_response.txt
    #echo >> "$1".continue_response.txt

    # Continue Response footer.
    rm -f "$safeTmp"/"$inputName".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName".tmp_output.txt > /dev/null 2>&1
    cat "$1".continue_prompt.txt > "$safeTmp"/"$inputName".tmp_input.txt
    #echo '' >> "$safeTmp"/"$inputName".tmp_input.txt
    _here_convert_bash_continuePromptResponse-ask_responseFooter >> "$safeTmp"/"$inputName".tmp_input.txt
    _convert_loop "$1" "_convert_bash-backend-lowLatency"
    cat "$safeTmp"/"$inputName".tmp_output.txt >> "$1".continue_response.txt



    rm -f "$safeTmp"/"$inputName".tmp_input.txt
    rm -f "$safeTmp"/"$inputName".tmp_output.txt
}
_convert_bash_procedure_procedure() {
    #export -f _convert_bash-backend
    #export -f _convert_bash-backend-lowLatency
    #export -f _convert_loop

    #export -f _here_convert_bash_promptResponse-askDescription
    #export -f _here_convert_bash_promptResponse-boilerplate_promptHeader
    #export -f _here_convert_bash_promptResponse-ask_responseHeader
    #export -f _here_convert_bash_promptResponse-ask_responseFooter
    #export -f _here_convert_bash_continuePromptResponse-boilerplate_promptHeader
    #export -f _here_convert_bash_continuePromptResponse-ask_responseHeader
    #export -f _here_convert_bash_continuePromptResponse-ask_responseFooter

    #export -f _convert_bash_procedure

	#export -f "_messagePlain_nominal"
	#export -f "_color_begin_nominal"
	#export -f "_color_end"
	#export -f "_getAbsoluteLocation"
	#export -f "_realpath_L_s"
    #export -f "_realpath_L"
	#export -f "_compat_realpath_run"
	#export -f "_compat_realpath"
	#export -f "_messagePlain_probe_var"
	#export -f "_color_begin_probe"
	#export -f "_messagePlain_probe"

    local currentDirectory="$1"
    [[ "$currentDirectory" == "" ]] && currentDirectory="$scriptLocal"/dataset/"$objectName"

    
    _convert_bash-dispatch "$currentDirectory"
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



