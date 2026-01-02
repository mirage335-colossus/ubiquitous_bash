
# ATTENTION: Override with 'ops.sh' or similar ONLY if appropriate. Default chunk sizes should be increasingly very well chosen and tested.
# NOTICE:
# Small non-overlapping chunk size should be at least 2x smaller than smallest plausible RAG retrieval chunks.
#  These chunks are not given to RAG directly, rather annotations are put at regular intervals, so these intervals must be short enough to always include one annotation block in every chunk any downstream RAG system retrieves.
#  The disadvantage of too small of small chunks is higher inference cost.
# Quote chunk size should be the size of or slightly larger than typical RAG retrieval chunks. Extending to the adjacent small chunks is of no consequence, since either only the small chunk will be explained, or as usual some overlapping explanation will be tolerable. Annotations are not necessarily explicitly stated specific to only the adjacent text, so in some situations it may be acceptable to write annotations to small chunks based solely on quote chunk content.
# Large chunk size, including overlap, should be at least 3x larger than most complete documentation subheadings, code functions, etc. Nevertheless, large chunk size before the overlap can be quite small to better position the boundaries of the chunk around the small chunk.
# Huge chunks should be larger than usual entire documents, source code files, etc.
# WARNING: Large chunk 'head' overlap should be large enough to get both small chunk and any 'title', 'subtitle', 'function name', etc, but also small enough to remain in minimally accurate 'horizon' and context-window of specialized or resource constrained AI inference (ie. preferably <12k tokens, >8k tokens).
# WARNING: You are advised NOT to tinker without both very extensive experience and very diverse testing.
#
# DANGER: Use of 'head', 'tail', etc, instead of 'dd' skip is very intentional, due to track record using these safely under relevant operating systems, etc (ie. Cygwin/MSWindows, NTFS, etc).
# Using 'dd' instead must be *very* extensively tested before being considered safe, to ensure data is always processed with minimal opportunity for operating system, utilities, etc, bugs, etc.
_scribble_split() {
    ! type _ai_filter > /dev/null 2>&1 && exit 1


    local currentInputFile="$1"
    local currentMoniker="$2"
    local current_sub_safeTmp="$3"
    [[ ! -e "$current_sub_safeTmp" ]] && _messageError 'FAIL missing: current_sub_safeTmp' && _stop 1


    local currentChunk=1
    local current_small_begin="0"
    local current_small_end
    local current_quote_begin
    local current_quote_end
    local current_large_begin
    local current_large_end
    local current_huge_begin
    local current_huge_end
    #
    local current_small_begin_adjust
    local current_small_end_adjust
    #
    local current_small_Chunk_charSize=2000
    #
    local current_quote_Chunk_charSize=6000
    #
    # WARNING: Small initial size with large overlap for the large chunk is very intentional - to gather appropriate preceding context for better understanding of the small chunk.
    local current_large_Chunk_charSize="$current_small_Chunk_charSize"
    local current_large_Chunk_charOverlapHead=25000
    local current_large_Chunk_charOverlapTail=10000
    #
    local current_huge_Chunk_charSize=125000
    local current_huge_Chunk_charOverlapHead=50000
    local current_huge_Chunk_charOverlapTail=25000
    #
    local chunk_adjust_allowance=300
    #
    # Iterate through range of lines. Write sets of chunk files of all sizes for each smallest size chunk.
    # Larger chunks will not be used directly, descriptions, summaries, etc, of the surrounding code functionality, documented information, will be generated.
    
    LC_ALL=C cat "$currentInputFile" | _ai_filter > "$current_sub_safeTmp"/safe_input.txt
    _safeEcho_newline "$currentMoniker" | _ai_filter > "$current_sub_safeTmp"/safe_moniker.txt

    local currentFileSize=$(LC_ALL=C wc -c < "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C tr -dc '0-9')
    [[ $(echo -n "$currentFileSize" | LC_ALL=C wc -c | LC_ALL=C tr -dc '0-9') -gt 9 ]] && _messageError 'FAIL: input file greater than 1GB' && _stop 1

    while [[ $(( ( "$currentChunk" - 1 ) * "$current_small_Chunk_charSize" )) -lt "$currentFileSize" ]]
    do
        current_small_begin=$(( ( "$currentChunk" - 1 ) * "$current_small_Chunk_charSize" ))
        current_small_end=$(( "$current_small_begin" + "$current_small_Chunk_charSize" ))
        [[ "$current_small_end" -gt "$currentFileSize" ]] && current_small_end="$currentFileSize"
        current_small_begin_adjust="$chunk_adjust_allowance"
        current_small_end_adjust="$chunk_adjust_allowance"

        current_large_begin=$(( "$current_small_begin" - "$current_large_Chunk_charOverlapHead" ))
        [[ "$current_large_begin" -lt 0 ]] && current_large_begin="0"
        current_large_end=$(( "$current_large_begin" + "$current_large_Chunk_charSize" + "$current_large_Chunk_charOverlapHead" + "$current_large_Chunk_charOverlapTail" ))
        [[ "$current_large_end" -gt "$currentFileSize" ]] && current_large_end="$currentFileSize"
        
        current_huge_begin=$(( "$current_small_begin" - "$current_huge_Chunk_charOverlapHead" ))
        [[ "$current_huge_begin" -lt 0 ]] && current_huge_begin="0"
        current_huge_end=$(( "$current_huge_begin" + "$current_huge_Chunk_charSize" + "$current_huge_Chunk_charOverlapHead" + "$current_huge_Chunk_charOverlapTail" ))
        [[ "$current_huge_end" -gt "$currentFileSize" ]] && current_huge_end="$currentFileSize"



        # Adjust small chunk begin boundary up deterministically to nearest newline, space, period, within a "$chunk_adjust_allowance" char allowance. Adjust small chunk end boundary up to the nearest convenient boundary. Do not adjust the top boundary for the first chunk, nor the bottom boundary for the last chunk. All file contents must be included in chunks.

        #echo 'quick brown fox' | perl -0777 -ne 'print rindex($_, "\n"), "\n"'

        # If not last chunk, adjust end boundary to nearest convenient boundary, which will be next (deterministically adjusted) chunk begin.
        if ! [[ "$current_small_end" -ge "$currentFileSize" ]]
        then
            current_small_end_adjust=$(LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_small_end" | LC_ALL=C tail -c "$chunk_adjust_allowance" | perl -0777 -ne 'print rindex($_, "\n"), "\n"' | LC_ALL=C tr -dc '0-9\-')
            [[ "$current_small_end_adjust" != "-1" ]] && current_small_end=$(( "$current_small_end" - ( "$chunk_adjust_allowance" - "$current_small_end_adjust" ) ))
        fi

        # If not first chunk, adjust begin boundary to nearest convenient boundary, which will have been previous (deterministically adjusted) chunk end.
        if ! [[ "$current_small_begin" -eq "0" ]]
        then
            current_small_begin_adjust=$(LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_small_begin" | LC_ALL=C tail -c "$chunk_adjust_allowance" | perl -0777 -ne 'print rindex($_, "\n"), "\n"' | LC_ALL=C tr -dc '0-9\-')
            [[ "$current_small_begin_adjust" != "-1" ]] && current_small_begin=$(( "$current_small_begin" - ( "$chunk_adjust_allowance" - "$current_small_begin_adjust" ) ))
        fi
        


        current_quote_begin="$current_small_begin"
        current_quote_end=$(( "$current_quote_begin" + "$current_quote_Chunk_charSize" ))
        [[ "$current_quote_end" -gt "$currentFileSize" ]] && current_quote_end="$currentFileSize"


        LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_small_end" | LC_ALL=C tail -c $(( "$current_small_end" - "$current_small_begin" )) > "$current_sub_safeTmp"/chunk_small_"$(printf '%06d' "$currentChunk")".txt

        LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_quote_end" | LC_ALL=C tail -c $(( "$current_quote_end" - "$current_quote_begin" )) > "$current_sub_safeTmp"/chunk_quote_"$(printf '%06d' "$currentChunk")".txt

        LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_large_end" | LC_ALL=C tail -c $(( "$current_large_end" - "$current_large_begin" )) > "$current_sub_safeTmp"/chunk_large_"$(printf '%06d' "$currentChunk")".txt

        LC_ALL=C cat "$current_sub_safeTmp"/safe_input.txt | LC_ALL=C head -c "$current_huge_end" | LC_ALL=C tail -c $(( "$current_huge_end" - "$current_huge_begin" )) > "$current_sub_safeTmp"/chunk_huge_"$(printf '%06d' "$currentChunk")".txt

        let currentChunk=currentChunk+1
    done

    return 0
}






_vector_scribble_split_sequence() {
    _start

    export scribble_split_sessionid=$(_uid)
    mkdir -p "$safeTmp"/_vector_scribble_split_"$scribble_split_sessionid"


    _scribble_split "$scriptAbsoluteLocation" "/ubiquitous_bash.sh" "$safeTmp"/_vector_scribble_split_"$scribble_split_sessionid"

    cat "$scriptAbsoluteLocation" | _ai_filter | sha256sum >&2
    cat "$safeTmp"/_vector_scribble_split_"$scribble_split_sessionid"/chunk_small_*.txt | sha256sum >&2

    cat "$safeTmp"/_vector_scribble_split_"$scribble_split_sessionid"/chunk_small_*.txt > "$scriptAbsoluteFolder"/chunk_assembled.txt
    cat "$scriptAbsoluteLocation" | _ai_filter > "$scriptAbsoluteFolder"/original_filtered.txt


    _safeRMR "$safeTmp"/_vector_scribble_split_"$scribble_split_sessionid"
    _stop
}
_vector_scribble_split() {
    "$scriptAbsoluteLocation" _vector_scribble_split_sequence "$@"
}

