
#./ubiquitous_bash.sh _corpus_bash-write "./ubiquitous_bash.sh" ".sh" "ubiquitous_bash" 75 30 "./_local/dataset/ubiquitous_bash"



# Default chunk should be large enough to usually put at least two functions in a segment, but small enough such that a trailing run-on function does not add enough past the chunk size for the segment to either absolutely exceed a reasonable context window or convert to much to more of a needle-in-haystack problem.
#
# Chunk is minimum lines, since ending a segment before the next function is unhelpful.
#  Segments will be between the function declaration preceeding the 'cursor' to the next function declaration after already adding chunk to the 'cursor' position.
# More than ~150 lines, ~1k tokens, tends to compound whatever problem an AI LLM is otherwise given into a simultaneous needle-in-haystack problem.
#  Adequately large datasets may train an AI LLM during earlier epochs on simpler problems sufficiently to reduce the compounded sensitivity with needle-in-haystack problem.
#  c $(head -n 150 ./ubiquitous_bash.sh | wc -c) / 5
#  ~1000 (ie. 1k tokens)
_set_corpus() {
    export corpus_script=$(_getAbsoluteLocation "$1")
    [[ "$1" == "" ]] && corpus_script="$scriptAbsoluteLocation"
    [[ "$corpus_script" == "" ]] && corpus_script="$scriptAbsoluteLocation"

    export corpus_script_name=$(basename "$corpus_script")


    export corpus_script_extension="$2"
    [[ "$corpus_script_extension" == "" ]] && corpus_script_extension=".""${corpus_script_name##*.}"
    [[ "$corpus_script_extension" == "" ]] && corpus_script_extension=".txt"

    export corpus_script_name=$(basename -s ".""${corpus_script_name##*.}" "$corpus_script")


    export corpus_script_object="$3"
    local corpus_script_folder=$(_getAbsoluteFolder "$corpus_script")
    [[ "$corpus_script_object" == "" ]] && export corpus_script_object=$(basename "$corpus_script_folder")


    export corpus_chunk="$4"
    [[ "$corpus_chunk" == "" ]] && corpus_chunk=75
    corpus_chunk=$(( corpus_chunk - 1 ))


    export corpus_overlap="$5"
    [[ "$corpus_overlap" == "" ]] && corpus_overlap=30
}

_set_corpus_default() {
    [[ "$corpus_script" != "" ]] && [[ "$corpus_script_extension" != "" ]] && [[ "$corpus_script_name" != "" ]] && [[ "$corpus_script_object" != "" ]] && [[ "$corpus_chunk" != "" ]] && [[ "$corpus_overlap" != "" ]] && return 0
    _set_corpus "$@"
}


#./ubiquitous_bash.sh _corpus_bash "" "" "" 75 30
_corpus_bash() {
    "$scriptAbsoluteLocation" _corpus_bash_sequence "$@"
}
_corpus_bash_sequence() {
    _start

    local current_corpus_script="$1"
    local current_corpus_script_extension="$2"
    [[ "$current_corpus_script_extension" == "" ]] && current_corpus_script_extension=".sh"
    local current_corpus_object="$3"
    local current_corpus_chunk="$4"
    local current_corpus_overlap="$5"
    shift ; shift ; shift ; shift ; shift
    _set_corpus_default "$current_corpus_script" "$current_corpus_script_extension" "$current_corpus_object" "$current_corpus_chunk" "$current_corpus_overlap" "$@"
    mkdir -p "$safeTmp"/dataset/corpus/"$corpus_script_object"

    _dataset_from_lines() { _dataset_bash_from_lines "$@" ; }
    export -f _dataset_from_lines
    
    _dataset_from_lines_functionBegin() { _dataset_bash_from_lines_functionBegin "$@" ; }
    export -f _dataset_from_lines_functionBegin

    _dataset_from_lines_functionEnd() { _dataset_bash_from_lines_functionEnd "$@" ; }
    export -f _dataset_from_lines_functionEnd

    local corpusSegments=$(_corpus_procedure "$@")
    #"$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"

    #_corpus_procedure-read "$@"

    _stop
}

#./ubiquitous_bash.sh _corpus_bash-read "" "" "" 75 30
_corpus_bash-read() {
    "$scriptAbsoluteLocation" _corpus_bash_sequence-read "$@"
}
_corpus_bash_sequence-read() {
    _start

    local current_corpus_script="$1"
    local current_corpus_script_extension="$2"
    [[ "$current_corpus_script_extension" == "" ]] && current_corpus_script_extension=".sh"
    local current_corpus_object="$3"
    local current_corpus_chunk="$4"
    local current_corpus_overlap="$5"
    shift ; shift ; shift ; shift ; shift
    _set_corpus_default "$current_corpus_script" "$current_corpus_script_extension" "$current_corpus_object" "$current_corpus_chunk" "$current_corpus_overlap" "$@"
    mkdir -p "$safeTmp"/dataset/corpus/"$corpus_script_object"

    _dataset_from_lines() { _dataset_bash_from_lines "$@" ; }
    export -f _dataset_from_lines
    
    _dataset_from_lines_functionBegin() { _dataset_bash_from_lines_functionBegin "$@" ; }
    export -f _dataset_from_lines_functionBegin

    _dataset_from_lines_functionEnd() { _dataset_bash_from_lines_functionEnd "$@" ; }
    export -f _dataset_from_lines_functionEnd

    local corpusSegments=$(_corpus_procedure "$@")
    #"$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"
    
    _corpus_procedure-read "$corpusSegments"

    _stop
}

#./ubiquitous_bash.sh _corpus_bash-write "./ubiquitous_bash.sh" ".sh" "ubiquitous_bash" 75 30 "./_local/dataset/ubiquitous_bash"
_corpus_bash-write() {
    "$scriptAbsoluteLocation" _corpus_bash_sequence-write "$@"
}
_corpus_bash_sequence-write() {
    _start

    local current_corpus_script="$1"
    local current_corpus_script_extension="$2"
    [[ "$current_corpus_script_extension" == "" ]] && current_corpus_script_extension=".sh"
    local current_corpus_object="$3"
    local current_corpus_chunk="$4"
    local current_corpus_overlap="$5"
    shift ; shift ; shift ; shift ; shift
    _set_corpus_default "$current_corpus_script" "$current_corpus_script_extension" "$current_corpus_object" "$current_corpus_chunk" "$current_corpus_overlap" "$@"
    mkdir -p "$safeTmp"/dataset/corpus/"$corpus_script_object"

    local current_out_dir="$6"
    [[ "$current_out_dir" == "" ]] && current_out_dir="$scriptLocal"/dataset/"$corpus_script_object"
    mkdir -p "$current_out_dir"

    _dataset_from_lines() { _dataset_bash_from_lines "$@" ; }
    export -f _dataset_from_lines
    
    _dataset_from_lines_functionBegin() { _dataset_bash_from_lines_functionBegin "$@" ; }
    export -f _dataset_from_lines_functionBegin

    _dataset_from_lines_functionEnd() { _dataset_bash_from_lines_functionEnd "$@" ; }
    export -f _dataset_from_lines_functionEnd

    local corpusSegments=$(_corpus_procedure "$@")
    #"$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"
    
    #_corpus_procedure-read "$corpusSegments"


    if [[ "$current_out_dir" == "" ]] || [[ "$corpus_script_name" == "" ]] || [[ "$corpus_script_extension" == "" ]]
    then
        ( _messageError 'FAIL' >&2 ) > /dev/null
        _stop 1
        exit 1
    fi
    rm -f "$current_out_dir"/"$corpus_script_name".*"$corpus_script_extension"

    if [[ -e "$current_out_dir"/"$corpus_script_name"."1""$corpus_script_extension" ]]
    then
        ( _messagePlain_bad 'FAIL: exists: '"$current_out_dir"/"$corpus_script_name"."1""$corpus_script_extension" >&2 ) > /dev/null
        ( _messageError 'FAIL' >&2 ) > /dev/null
        ( _messagePlain_request 'request: delete existing dataset' >&2 ) > /dev/null
        _stop 1
    fi

    mv -f "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name".*"$corpus_script_extension" "$current_out_dir"/

    _stop
}


_corpus_procedure() {
    _dataset_from_lines

    local current_chunkBegin=1
    local current_chunkEnd
    current_chunkEnd=$(( current_chunkBegin + corpus_chunk ))

    local current_segmentBegin=1
    local current_segmentEnd

    local current_segment_iteration=0
    while [[ "$current_chunkBegin" -lt "$current_dataset_totalLines" ]]
    do
        (( current_segment_iteration++ ))

        current_chunkBegin=$(( current_chunkBegin - corpus_overlap ))
        [[ "$current_chunkBegin" -lt "$current_segmentBegin" ]] && current_chunkBegin=$(( current_segmentBegin + 1 ))
        
        current_chunkEnd=$(( current_chunkBegin + corpus_chunk ))
        
        current_segmentBegin=$(_dataset_from_lines_functionBegin "$current_chunkBegin")
        current_segmentEnd=$(_dataset_from_lines_functionEnd "$current_chunkEnd")
        [[ "$current_segmentBegin" -gt "$current_segmentEnd" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && _stop 1

        echo "#===== Segment $current_segment_iteration: ""$corpus_script_object"": ""lines $current_segmentBegin to $current_segmentEnd =====" > "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_segment_iteration""$corpus_script_extension"
        sed -n "${current_segmentBegin},${current_segmentEnd}p" "$corpus_script" >> "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_segment_iteration""$corpus_script_extension"

        current_chunkBegin=$(( current_segmentEnd + 1 ))
    done

    echo "$current_segment_iteration"

    return 0
}

# "$1" == current_segment_iteration
# "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"
_corpus_procedure-read() {
    local current_segment_iteration="$1"
    [[ "$current_segment_iteration" == "" ]] && current_segment_iteration=0

    current_file_iteration=1
    while [[ "$current_file_iteration" -le "$current_segment_iteration" ]]
    do
        if [[ ! -e "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension" ]]
        then
            ( _messagePlain_bad 'FAIL: missing: '"$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension" >&2 ) > /dev/null
            ( _messageError 'FAIL' >&2 ) > /dev/null
            _stop 1
        fi
        cat "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"
        rm -f "$safeTmp"/dataset/corpus/"$corpus_script_object"/"$corpus_script_name"."$current_file_iteration""$corpus_script_extension"
        (( current_file_iteration++ ))
    done
}

