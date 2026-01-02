


#find ... file ... exec ...
#_set_scribble $(cat $(_getAbsoluteFolder "$1")/param_fromDir.scribble.txt) "$1"
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
    _set_scribble "$currentKnowledgebase_dir" "$1"

    ! mkdir -p "$currentOutputFolder"/"$currentInputName".chunks/ && _messageError 'FAIL: mkdir: $currentOutputFolder/$currentInputName".chunks/' && _stop 1

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









_scribble_dir() {


    _scribble_todo "$1"






    


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
