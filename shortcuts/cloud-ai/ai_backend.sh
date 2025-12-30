


# AI LLM use often does not require more than the basic understanding or allusion conveyed by documentation. Some loss of detail and less likely, accuracy, may be a very acceptable tradeoff.
#  Particularly, processing of quoting, escaping, etc, through JSON, through 'jq', etc, may be an absolutely unacceptable concern to avoid by filtering.
_ai_filter() {
    # Delete control characters, delete carriage returns (leaving UNIX only line endings), delete risky input characters.
    # Then, translate common but unnecessary unicode characters.
    # Last, delete all control characters outside the allowlist.
    LC_ALL=C tr -d '\000-\010\013\014\016-\037\177' | \
    LC_ALL=C tr -d '\r' | \
    LC_ALL=C tr '"<>()?:;[]{}\\*&'"'" '_' | LC_ALL=C tr '\042\047\050\051\077\072\073\133\135\173\175\134\052\046' '_' | \
    perl -CS -pe '
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
_ai_backend() {
    local currentAImodel="$1"
    #default... Nemotron-3-Nano-30B-A3B-256k-virtuoso

    local currentAIprovider="$2"
    #if ... OPENROUTER_API_KEY ...
    #default... ollama


    
    local currentMaxTime="$3"

    local current_keepalive_time="$4"



    #jq -Rs '{model:"Llama-3-augment", prompt:., stream: false}' | _ai_filter | curl -fsS --max-time 120 -X POST -H "Content-Type: application/json" --data-binary @- http://localhost:11434/api/generate | _ai_filter | jq -r '.response'

    ##provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    ##provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }
    ##provider: { "order": ["Fireworks"], "sort": "throughput" }
    #jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'

    false
}






_vector_cloud_ai_sequence() {
    _start

    mkdir -p "$scriptLocal"/_vector_cloud_ai

    echo 'the quick brown fox jumps over the lazy dog' > "$scriptLocal"/_vector_cloud_ai/sample.md






    _safeRMR "$scriptLocal"/_vector_cloud_ai

    _stop
}
_vector_cloud_ai() {
    "$scriptAbsoluteLocation" _vector_cloud_ai_sequence "$@"
}





_test_cloud_ai() {
    _wantDep curl
    _wantDep jq
    _wantDep perl

    _wantDep grep
    _wantDep tr
}
