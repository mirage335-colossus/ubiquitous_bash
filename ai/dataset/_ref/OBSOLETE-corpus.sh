

# Default chunk should be large enough to usually put at least two functions in a segment, but small enough such that a trailing run-on function does not add enough past the chunk size for the segment to either absolutely exceed a reasonable context window or convert to much to more of a needle-in-haystack problem.
#
# Chunk is minimum lines, since ending a segment before the next function is unhelpful.
#  Segments will be between the function declaration preceeding the 'cursor' to the next function declaration after already adding chunk to the 'cursor' position.
# More than ~150 lines, ~1k tokens, tends to compound whatever problem an AI LLM is otherwise given into a simultaneous needle-in-haystack problem.
#  Adequately large datasets may train an AI LLM during earlier epochs on simpler problems sufficiently to reduce the compounded sensitivity with needle-in-haystack problem.
#  c $(head -n 150 ./ubiquitous_bash.sh | wc -c) / 5
#  ~1000 (ie. 1k tokens)
_set_corpus() {
    export corpus_script="$1"
    [[ "$corpus_script" == "" ]] && corpus_script="$scriptAbsoluteLocation"

    export corpus_chunk="$2"
    [[ "$corpus_chunk" == "" ]] && corpus_chunk=75
    corpus_chunk=$(( corpus_chunk - 1 ))

    export corpus_overlap="$3"
    [[ "$corpus_overlap" == "" ]] && corpus_overlap=30
}

_set_corpus_default() {
    [[ "$corpus_script" != "" ]] && [[ "$corpus_chunk" != "" ]] && [[ "$corpus_overlap" != "" ]] && return 0
    _set_corpus "$1" "" ""
}


_corpus_bash() {
    _set_corpus_default "$1"


    _dataset_from_lines() { _dataset_bash_from_lines "$@" ; }
    export -f _dataset_from_lines
    
    _dataset_from_lines_functionBegin() { _dataset_bash_from_lines_functionBegin "$@" ; }
    export -f _dataset_from_lines_functionBegin

    _dataset_from_lines_functionEnd() { _dataset_bash_from_lines_functionEnd "$@" ; }
    export -f _dataset_from_lines_functionEnd

    _corpus "$@"
}


_corpus() {
    _dataset_from_lines


    # ATTRIBUTION-AI: ChatGPT o1-pro  2025-03-31
    #local step=$(( corpus_chunk - corpus_overlap ))
    #(( step < 1 )) && step=1  # avoid infinite loops if corpus_overlap >= corpus_chunk

    #local start_line=1
    #local segment_index=1

    #while (( start_line <= current_dataset_totalLines )); do
        ## Nominal end (unadjusted) for this chunk
        #local raw_end=$(( start_line + corpus_chunk - 1 ))
        #if (( raw_end > current_dataset_totalLines )); then
            #raw_end="$current_dataset_totalLines"
        #fi

        ## Snap start_line to the beginning of whichever function encloses it
        #local adj_start
        #adj_start="$(_dataset_from_lines_functionBegin "$start_line")"

        ## Snap the end so we don't chop a subsequent function in half
        #local adj_end
        #adj_end="$(_dataset_from_lines_functionEnd "$raw_end")"

        ## If we somehow “backed up” so far that start passes end, we must stop
        #if (( adj_start > adj_end )); then
            #break
        #fi

        #echo "===== Segment $segment_index: lines $adj_start to $adj_end ====="
        #sed -n "${adj_start},${adj_end}p" "$corpus_script"

        ## Shift start_line forward by “step”, but anchor at least after adj_end
        ## to avoid re‐processing the same lines infinitely.
        #local next_start=$(( adj_end - corpus_overlap + 1 ))
        #(( next_start < adj_start )) && next_start=$(( adj_end + 1 ))

        #start_line=$(( next_start + corpus_overlap ))
        #(( start_line < adj_end + 1 )) && start_line=$(( adj_end + 1 ))

        #(( segment_index++ ))
    #done



    # ATTRIBUTION-AI: ChatGPT o3-mini  2025-03-31
    #while (( start_line <= current_dataset_totalLines )); do
        ## Determine the nominal (raw) end of the current chunk.
        #local raw_end=$(( start_line + corpus_chunk - 1 ))
        #if (( raw_end > current_dataset_totalLines )); then
            #raw_end="$current_dataset_totalLines"
        #fi

        ## Snap the start_line to the beginning of the function that encloses it.
        #local adj_start
        #adj_start="$(_dataset_from_lines_functionBegin "$start_line")"

        ## Snap the end so we don’t break a function in half.
        #local adj_end
        #adj_end="$(_dataset_from_lines_functionEnd "$raw_end")"

        ## If (due to our adjustments) the boundaries become inconsistent, exit the loop.
        #if (( adj_start > adj_end )); then
            #break
        #fi

        #echo "#===== Segment $segment_index: lines $adj_start to $adj_end ====="
        #sed -n "${adj_start},${adj_end}p" "$corpus_script"

        ## Compute the candidate start for the next segment (with overlap).
        #local proposed_start=$(( adj_end - corpus_overlap + 1 ))

        ## Guarantee forward progress: if the candidate start does not exceed the current start_line,
        ## force the new segment to start after the current segment’s end.
        #if (( proposed_start <= start_line )); then
            #echo "Warning: No progress detected (proposed_start=$proposed_start, current start_line=$start_line). Forcing new start_line to be after adj_end."
            #proposed_start=$(( adj_end + 1 ))
        #fi

        ## Optionally check that we never start before the first line.
        #(( proposed_start < 1 )) && proposed_start=1

        #start_line=$proposed_start
        #(( segment_index++ ))
    #done


    local current_chunkBegin=1
    local current_chunkEnd
    current_chunkEnd=$(( current_chunkBegin + corpus_chunk ))

    local current_segmentBegin=1
    local current_segmentEnd

    local current_segment_iteration=1
    while [[ "$current_chunkBegin" -lt "$current_dataset_totalLines" ]]
    do
        current_chunkBegin=$(( current_chunkBegin - corpus_overlap ))
        [[ "$current_chunkBegin" -lt "$current_segmentBegin" ]] && current_chunkBegin=$(( current_segmentBegin + 1 ))
        
        current_chunkEnd=$(( current_chunkBegin + corpus_chunk ))
        
        current_segmentBegin=$(_dataset_from_lines_functionBegin "$current_chunkBegin")
        current_segmentEnd=$(_dataset_from_lines_functionEnd "$current_chunkEnd")
        [[ "$current_segmentBegin" -gt "$current_segmentEnd" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && _stop 1

        echo "#===== Segment $current_segment_iteration: lines $current_segmentBegin to $current_segmentEnd ====="
        sed -n "${current_segmentBegin},${current_segmentEnd}p" "$corpus_script"

        current_chunkBegin=$(( current_segmentEnd + 1 ))

        (( current_segment_iteration++ ))
    done

}


