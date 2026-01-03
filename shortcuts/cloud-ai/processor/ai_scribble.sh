


#find ... file ... exec ...
#_set_scribble $(cat $(_getAbsoluteFolder "$1")/scribble_param_fromDir.txt) $(cat $(_getAbsoluteFolder "$1")/scribble_param_fromFile.txt)
#
# $currentKnowledgebase_dir="$1"
# $currentKnowledgebase_name
# $current_activity_dir
# $current_output_dir
#
# $currentInputFile
# $currentInputFolder
# $currentInputName
# $currentOutputCommon="$current_activity_dir"
# $currentSubDir
# $currentOutputFolder
# $currentOutputFile
# $currentInputFile_moniker
#
# WARNING: Do NOT call _set_scribble with only second parameter, unless variables exported from calling with first parameter are already inherited.
#
# *.scribbleAssist_bubble.txt
# *.scribble_todo-chunk.txt
# *.scribble_todo-crossref.txt
# *.scribble_todo-annotate.txt
_set_scribble() {
    if [[ "$1" != "" ]]
    then
    
        local current_fromDir=$(_safeEcho_newline "$1" | _ai_filter)

        export currentKnowledgebase_dir=$(_getAbsoluteLocation "$current_fromDir")
        ! [[ -e "$currentKnowledgebase_dir" ]] && _messageError 'FAIL: missing: $currentKnowledgebase_dir' && _stop 1
        
        export currentKnowledgebase_name=$(basename "$currentKnowledgebase_dir")

        export current_activity_dir=$(_getAbsoluteFolder "$currentKnowledgebase_dir")

        # eg. "$scriptLocal"/.scribbleAssist_bubble/_vector_scribble
        export current_output_dir="$current_activity_dir"/.scribbleAssist_bubble/"$currentKnowledgebase_name"
        ! mkdir -p "$current_output_dir" && _messageError 'FAIL: mkdir: '"$current_output_dir"' ' && _stop 1


        # Inference cache variable with ai_backend will use if set.
        export inference_cache_dir="$current_output_dir"/inference_cache/

    fi

    if [[ "$2" != "" ]]
    then
        local current_fromFile=$(_safeEcho_newline "$2" | _ai_filter)

        export currentInputFile=$(_getAbsoluteLocation "$current_fromFile")
        ! [[ -e "$currentInputFile" ]] && _messageError 'FAIL: missing: $currentInputFile' && _stop 1

        export currentInputFolder=$(_getAbsoluteFolder "$currentInputFile")
        export currentInputName=$(basename "$currentInputFile")

        export currentOutputCommon=$(_getAbsoluteLocation "$current_activity_dir")

        export currentSubDir="${currentInputFolder#$currentOutputCommon}"

        export currentOutputFolder="$currentOutputCommon"/.scribbleAssist_bubble"$currentSubDir"
        ! mkdir -p "$currentOutputFolder" && _messageError 'FAIL: mkdir: '"$currentOutputFolder"' ' && _stop 1

        export currentOutputFile="$currentOutputFolder"/"$currentInputName".scribbleAssist_bubble.txt

        export currentInputFile_moniker="$currentSubDir"/"$currentInputName"
    fi

    true
}



_scribble_todo_out() {
    [[ "$1" == "" ]] && _messageError 'FAIL: _scribble_todo_out: empty: $1' && _stop 1

    _set_scribble "$currentKnowledgebase_dir" "$1"

    ! mkdir -p "$currentOutputFolder"/"$currentInputName".chunks/ && _messageError 'FAIL: mkdir: $currentOutputFolder/$currentInputName".chunks/' && _stop 1

    echo "$currentInputFile" | _ai_filter > "$currentOutputFolder"/"$currentInputName".scribble_param_fromFile.txt
    echo "$currentKnowledgebase_dir" | _ai_filter > "$currentOutputFolder"/"$currentInputName".scribble_param_fromDir.txt


    echo "$1" | _ai_filter > "$currentOutputFolder"/"$currentInputName".scribble_todo-chunk.txt

    echo "$1" | _ai_filter > "$currentOutputFolder"/"$currentInputName".scribble_todo-crossref.txt

    echo "$1" | _ai_filter > "$currentOutputFolder"/"$currentInputName".scribble_todo-annotate.txt
    
    ( printf '%s: %s: %s \n' "$currentOutputFolder" "$currentInputName" "todo" >&2 )
}


_scribble_todo() {
    _set_scribble "$1"

    ( _safeEcho_newline '... _scribble_todo: dispatch: '"$currentKnowledgebase_dir" >&2 )

    find "$currentKnowledgebase_dir" -type f \( -iname '*.txt' -o -iname '*.md' \) -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_todo_out "$@"' _


    
}


_scribble_chunk_out() {
    [[ "$1" == "" ]] && _messageError 'FAIL: _scribble_chunk_out: empty: $1' && _stop 1
    
    local current_param_paramDir=$(_getAbsoluteFolder "$1")
    local current_param_paramName=$(basename -s ".scribble_todo-chunk.txt" "$1")

    local current_param_file=$(cat "$current_param_paramDir"/"$current_param_paramName".scribble_param_fromFile.txt)

    _set_scribble "$currentKnowledgebase_dir" "$current_param_file"

    ! mkdir -p "$currentOutputFolder"/"$currentInputName".chunks/ && _messageError 'FAIL: mkdir: $currentOutputFolder/$currentInputName".chunks/' && _stop 1


    _scribble_split "$current_param_file" "$currentInputFile_moniker" "$currentOutputFolder"/"$currentInputName".chunks/

    rm -f "$current_param_paramDir"/"$current_param_paramName".scribble_todo-chunk.txt
}

_scribble_chunk() {
    _set_scribble "$1"

    ( _safeEcho_newline '... _scribble_chunk: dispatch: '"$current_output_dir" >&2 )

    find "$current_output_dir" -type f -iname '*.scribble_todo-chunk.txt' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_chunk_out "$@"' _
}



_scribble_crossref_crawl() {
    local current_crossref_chunk_file=$(_getAbsoluteLocation "$1")
    local current_crossref_chunk_folder=$(_getAbsoluteFolder "$current_crossref_chunk_file")
    local current_crossref_file=$(basename -s ".chunks" "$current_crossref_chunk_folder")
    export current_crossref_moniker="${current_crossref_file#$currentOutputCommon}"

    local current_crossref_chunk_file_corresponding_small=$(_safeEcho_newline "$current_crossref_chunk_file" | sed -e 's/chunk_large_/chunk_small_/g')

    # Ignore crossref to self.
    [[ "$current_small_chunk_file" == "$current_crossref_chunk_file_corresponding_small" ]] && return 0

    # TODO: Actual inference cross-ref requesting relevance to "$current_small_chunk_file" of "$current_crossref_chunk_file" .
    echo "$current_crossref_moniker" > "$current_small_chunk_file"."$current_crossref_moniker".scribble_crossref.txt
}


_scribble_crossref_crossref() {
    export current_small_chunk_file="$1"
    find "$current_output_dir" -type f -iname 'chunk_large_*.txt' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_crossref_crawl "$@"' _
}


_scribble_crossref_out() {
    [[ "$1" == "" ]] && _messageError 'FAIL: _scribble_crossref_out: empty: $1' && _stop 1
    
    local current_param_paramDir=$(_getAbsoluteFolder "$1")
    local current_param_paramName=$(basename -s ".scribble_todo-crossref.txt" "$1")

    local current_param_file=$(cat "$current_param_paramDir"/"$current_param_paramName".scribble_param_fromFile.txt)

    _set_scribble "$currentKnowledgebase_dir" "$current_param_file"

    ! mkdir -p "$currentOutputFolder"/"$currentInputName".chunks/ && _messageError 'FAIL: mkdir: $currentOutputFolder/$currentInputName".chunks/' && _stop 1

    # TODO: WIP!
    find "$currentOutputFolder"/"$currentInputName".chunks -type f -iname 'chunk_small_*.txt' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_crossref_crossref "$@"' _

    # TODO: *Generatively* summarize all cross-reference results into single cross-ref file.

    rm -f "$current_param_paramDir"/"$current_param_paramName".scribble_todo-crossref.txt
}

_scribble_crossref() {
    _set_scribble "$1"

    ( _safeEcho_newline '... _scribble_crossref: dispatch: '"$current_output_dir" >&2 )

    find "$current_output_dir" -type f -iname '*.scribble_todo-crossref.txt' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_crossref_out "$@"' _
}



_scribble_annotate_out() {
    [[ "$1" == "" ]] && _messageError 'FAIL: _scribble_annotate_out: empty: $1' && _stop 1
    
    local current_param_paramDir=$(_getAbsoluteFolder "$1")
    local current_param_paramName=$(basename -s ".scribble_todo-annotate.txt" "$1")

    local current_param_file=$(cat "$current_param_paramDir"/"$current_param_paramName".scribble_param_fromFile.txt)

    _set_scribble "$currentKnowledgebase_dir" "$current_param_file"

    ! mkdir -p "$currentOutputFolder"/"$currentInputName".chunks/ && _messageError 'FAIL: mkdir: $currentOutputFolder/$currentInputName".chunks/' && _stop 1

    # TODO: *Generatively* create annotation file corresponding to small chunks. Concatenate or generatively include information from cross-reference files.

    rm -f "$current_param_paramDir"/"$current_param_paramName".scribble_todo-annotate.txt
}

_scribble_annotate() {
    _set_scribble "$1"

    ( _safeEcho_newline '... _scribble_annotate: dispatch: '"$current_output_dir" >&2 )

    find "$current_output_dir" -type f -iname '*.scribble_todo-annotate.txt' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _scribble_annotate_out "$@"' _
}







_scribble_dir() {


    _scribble_todo "$1"

    _scribble_chunk "$1"

    _scribble_crossref "$1"

    _scribble_annotate "$1"

    _scribble_cat "$1"
    


    #( echo '... _vector_scribble: dispatch' >&2 )
    #find "$scriptLocal"/_vector_scribble -type f -name '*' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _vector_scribble_procedure "$@"' _





    # write TODO files




    # (parallel) chunk everything
    #find ... .todo.txt ... exec ...
    #_set_scribble $(cat $(_getAbsoluteFolder "$1")/param_fromDir.scribble.txt)




    # (parallel) all huge chunk files get corresponding crossref files




    # (parallel) all small chunk files get corresponding annotation crossref files





    # cat everything to single flat file


}






_vector_scribble_procedure() {

    # eg. "$scriptLocal"/_vector_scribble
    local current_vector_dir=$(_getAbsoluteLocation "$1")

    _scribble_dir "$current_vector_dir"

}

# WARNING: Intended for manual single-instance testing ONLY!
_vector_scribble_sequence() {
    _start


    mkdir -p "$scriptLocal"/_vector_scribble
    mkdir -p "$scriptLocal"/_vector_scribble/subdir
    echo 'the quick brown fox jumps over the lazy dog' > "$scriptLocal"/_vector_scribble/subdir/sample1.md
    echo 'lorem ipsum' > "$scriptLocal"/_vector_scribble/subdir/sample2.md
    echo 'nothing to see here' > "$scriptLocal"/_vector_scribble/subdir/sample3.md
    [[ ! -e "$scriptLocal"/_vector_scribble ]] && _messageError 'FAIL: missing: "$scriptLocal"/_vector_scribble' && _stop 1

    
    
    _vector_scribble_procedure "$scriptLocal"/_vector_scribble


    ( echo '... _vector_scribble: ls -Ra "$scriptLocal"/_vector_scribble' >&2 )
    ls -Ra "$scriptLocal"/_vector_scribble


    ( echo '... _vector_scribble: ls -Ra .scribbleAssist_bubble/_vector_scribble' >&2 )
    ls -Ra "$scriptLocal"/.scribbleAssist_bubble/_vector_scribble


    ( echo '... _vector_scribble: cat' >&2 )
    find "$scriptLocal"/_vector_scribble/* -type f -name '*' -exec cat {} \;



    _safeRMR "$scriptLocal"/_vector_scribble
    _safeRMR "$scriptLocal"/.scribbleAssist_bubble/_vector_scribble
    rmdir "$scriptLocal"/.scribbleAssist_bubble 2> /dev/null

    _stop
}
_vector_scribble() {
    "$scriptAbsoluteLocation" _vector_scribble_sequence "$@"
}

_test_scribble() {

    _wantGetDep sed
    
    _test_cloud_ai "$@"

}
