


# AI LLM use often does not require more than the basic understanding or allusion conveyed by documentation. Some loss of detail and less likely, accuracy, may be a very acceptable tradeoff.
#  Particularly, processing of quoting, escaping, etc, through JSON, through 'jq', etc, may be an absolutely unacceptable concern to avoid by filtering.
_ai_filter() {
    # Delete control characters, delete carriage returns (leaving UNIX only line endings), delete risky input characters.
    # Then, translate common but unnecessary unicode characters.
    # Last, delete all control characters outside the allowlist.
    LC_ALL=C tr -d '\000-\010\013\014\016-\037\177' | \
    LC_ALL=C tr -d '\r' | \
    LC_ALL=C tr '"<>()?:;[]{}\\*&'"'" '_' | LC_ALL=C tr '\042\047\050\051\077\072\073\133\135\173\175\134\052\046' '_' | \
    LC_ALL=C perl -CS -pe '
        s/[\x{2010}-\x{2015}\x{2212}]/-/g;                 # dashes/minus -> -
        s/\x{00D7}/x/g;                                    # multiplication sign -> x
        s/[\x{00A0}\x{2000}-\x{200A}\x{202F}\x{205F}\x{3000}]/ /g;   # wide/no-break spaces -> space
        s/[\x{200B}-\x{200D}\x{FEFF}]//g;                  # zero-width/BOM -> delete
        s/[\x{202A}-\x{202E}\x{2066}-\x{2069}]//g;         # bidi controls -> delete
        s/[\x{2028}\x{2029}]/\n/g;                         # line/para separators -> newline
        s/\x{2026}/.../g;                                  # ellipsis
        s/[\x{2022}\x{00B7}]/-/g;                          # bullets/dots -> -
    ' | \
    LC_ALL=C tr -c 'A-Za-z0-9 .,_+/\\\-=\n\t' '_' | LC_ALL=C tr -dc 'A-Za-z0-9 .,_+/\\\-=\n\t'
}




# WARNING: CAUTION: DANGER: Unlike most other 'ubiquitous_bash' functions, this does NOT provide full abstraction. Calling this with a pattern - dispatch, gibberish detection, etc, with dedicated "$safeTmp" files, is STRICTLY NECESSARY.
#
# WARNING: Calling the AI model once (writing to /dev/null) may be necessary to ensure (eg. ollama) inference server is ready.
#
# WARNING: Gibberish and offensive content detection are STRICTLY NECESSARY regardless of whether the model supposedly has a 'safety' layer. Processing very large amounts of content WILL result in some offensive gibberish.
#
# ATTENTION: WARNING: It is necessary to reuse a "$safeTmp" directory, as creating new instances can be prohibitively slow (especially, but not limited to MSWindows/Cygwin - UNIX/Linux can also be too slow in this situation).
#
#find "$1" -type f -name '*.sh' -print0 | xargs -0 -x -L 1 -P 1 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _semanticAssist_bash_procedure "$@"' _
#
_ai_backend_procedure() {
    local currentAImodel="$1"
    [[ "$currentAImodel" == "" ]] && currentAImodel="Nemotron-3-Nano-30B-A3B-256k-virtuoso"

    local currentAIprovider="$2"
    [[ "$currentAIprovider" == "" ]] && currentAIprovider="ollama"

    local askGibberish="$3"
    [[ "$askGibberish" == "" ]] && askGibberish="true"

    local askPolite="$4"
    [[ "$askPolite" == "" ]] && askPolite="true"


    
    local currentMaxTime="$5"
    [[ "$currentMaxTime" == "" ]] && currentMaxTime="120"

    local current_keepalive_time="$6"
    [[ "$current_keepalive_time" == "" ]] && current_keepalive_time="300"



    local current_sub_sessionid_ai_backend=$(_uid 28)
    local current_sub_safeTmp_ai_backend="$safeTmp"/ai_backend_"$current_sub_sessionid_ai_backend"
    if ! mkdir -p "$current_sub_safeTmp_ai_backend"
    then
        # Outputting an error message, even to stderr, may get redirected to the inference output, causing bad breakage, confusion, etc.
        #( _messageERROR 'FAIL: mkdir: $current_sub_safeTmp_ai_backend' >&2 )
        _stop 1
    fi

    cat > "$current_sub_safeTmp_ai_backend"/_input.txt
    cat "$current_sub_safeTmp_ai_backend"/_input.txt | _ai_filter > "$current_sub_safeTmp_ai_backend"/_safe_input.txt

    cat "$current_sub_safeTmp_ai_backend"/_input.txt | sha512sum | head -c 128 | tr 'A-Z' 'a-z' | tr -dc 'a-z0-9' > "$current_sub_safeTmp_ai_backend"/_input_hash.txt



    # WARNING: ATTENTION: NOTICE: TODO: Use 'inference_cache_dir' if set. Do not cache otherwise.
    # TODO: Inference cache .
    #export inference_cache_dir="$current_output_dir"/inference_cache/
    #
    # Only cache if response is <2k compressed base64 .
    # HASHHASHHASH.tmp -> compress response -> add newline -> append to raw flat file
    # find/retrieve relevant line using hash - grep, etc - then decompress and use the cached result
    #
    # input prompt is not cached - only output response is cached - hash is sufficient to 'compress' and identify the input prompt
    #
    # Appending to raw flat file will require file locking.
    # Due to the low stakes, if the lock file does not contain the calling sessionid, etc, writing the cache should simply be abandoned.
    #
    # newline is an important out-of-band indicator - grep should only search for the hash beginning on a new line... attempts to get the output to include hashes matching some input hashes... should not cause reading the wrong response from cache
    if [[ "$inference_cache_dir" != "" ]] && [[ -e "$inference_cache_dir"/inference_cache_sha512_xz.txt ]]
    then
        if grep -m1 '^'$(cat "$current_sub_safeTmp_ai_backend"/_input_hash.txt) "$inference_cache_dir"/inference_cache_sha512_xz.txt | tail -c +129 | base64 -d | xz -d -C sha256 > "$current_sub_safeTmp_ai_backend"/_output.txt 2>/dev/null
        then
            cat "$current_sub_safeTmp_ai_backend"/_output.txt
            _safeRMR "$current_sub_safeTmp_ai_backend"
            return 0
        else
            rm -f "$current_sub_safeTmp_ai_backend"/_output.txt
        fi
    fi



    # TODO: Inference call.

    # Fake testing inference call.
    echo "$RANDOM""$RANDOM""$RANDOM""$RANDOM""$RANDOM" > "$current_sub_safeTmp_ai_backend"/_output.txt

    #jq -Rs '{model:"Llama-3-augment", prompt:., stream: false}' | _ai_filter | curl -fsS --max-time 120 -X POST -H "Content-Type: application/json" --data-binary @- http://localhost:11434/api/generate | _ai_filter | jq -r '.response'

    ##provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    ##provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }
    ##provider: { "order": ["Fireworks"], "sort": "throughput" }
    #jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'

    #"$current_sub_safeTmp_ai_backend"/_output.txt

    # TODO: "$askGibberish"
    # TODO: "$askPolite"




    # WARNING: Locking mechanism need not be perfect. Occasionally missing the opportunity to write to cache is less important than minimizing loss of throughput.
    if [[ "$inference_cache_dir" != "" ]]
    then
        mkdir -p "$inference_cache_dir"

        local currentIteration=0
        while [[ "$currentIteration" -lt 1 ]] && ls -1 "$inference_cache_dir"/*.lock > /dev/null 2>&1
        do
            sleep 1
            currentIteration=$(( currentIteration + 1 ))
        done

        if [[ "$currentIteration" -ge 1 ]]
        then
            # Occasionally delete all locks, in case any are not getting deleted appropriately.
            [[ $(( "$RANDOM"%1000 )) == "0" ]] && rm -f "$inference_cache_dir"/*.lock
            cat "$current_sub_safeTmp_ai_backend"/_output.txt
            rm -f "$current_sub_safeTmp_ai_backend"/_output.txt
            _safeRMR "$current_sub_safeTmp_ai_backend"
            return 0
        fi

        echo "$current_sub_sessionid_ai_backend" > "$inference_cache_dir"/"$current_sub_sessionid_ai_backend".lock

        cp -f "$inference_cache_dir"/inference_cache_sha512_xz.txt "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt 2> /dev/null
        echo '' >> "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt
        cat "$current_sub_safeTmp_ai_backend"/_input_hash.txt >> "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt
        cat "$current_sub_safeTmp_ai_backend"/_output.txt | xz -z -e9 -C sha256 --threads=1 | head -c 32768 | base64 -w0 >> "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt
        echo '' >> "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt

        [[ -e "$inference_cache_dir"/"$current_sub_sessionid_ai_backend".lock ]] && mv -f "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt "$inference_cache_dir"/inference_cache_sha512_xz.txt
        rm -f "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt
        rm -f "$inference_cache_dir"/"$current_sub_sessionid_ai_backend".lock
    fi


    
    [[ "$inference_cache_dir" != "" ]] && rm -f "$inference_cache_dir"/inference_cache_sha512_xz.txt.tmp-"$current_sub_sessionid_ai_backend".txt
    [[ "$inference_cache_dir" != "" ]] && rm -f "$inference_cache_dir"/"$current_sub_sessionid_ai_backend".lock
    cat "$current_sub_safeTmp_ai_backend"/_output.txt
    _safeRMR "$current_sub_safeTmp_ai_backend"
    return 0
}






_vector_cloud_ai_procedure() {
    _safeEcho_newline "$1"
}

# WARNING: Intended for manual single-instance testing ONLY!
_vector_cloud_ai_sequence() {
    _start

    mkdir -p "$scriptLocal"/_vector_cloud_ai

    echo 'the quick brown fox jumps over the lazy dog' > "$scriptLocal"/_vector_cloud_ai/sample1.md

    echo 'lorem ipsum' > "$scriptLocal"/_vector_cloud_ai/sample2.md

    echo 'nothing to see here' > "$scriptLocal"/_vector_cloud_ai/sample3.md

    _messageNormal '_vector_cloud_ai: ls -R'
    ls -R "$scriptLocal"/_vector_cloud_ai


    _messageNormal '_vector_cloud_ai: dispatch'
    find "$scriptLocal"/_vector_cloud_ai -type f -name '*' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _vector_cloud_ai_procedure "$@"' _


    _messageNormal '_vector_cloud_ai: cat'
    cat "$scriptLocal"/_vector_cloud_ai/*


    _safeRMR "$scriptLocal"/_vector_cloud_ai

    _stop
}
_vector_cloud_ai() {
    "$scriptAbsoluteLocation" _vector_cloud_ai_sequence "$@"
}

_test_cloud_ai() {
    _wantGetDep curl
    _wantGetDep jq
    _wantGetDep perl

    _wantGetDep grep
    _wantGetDep tr
}
