






_scribble_file() {

    # ... TODO - Optional user query, to output only chunks/files relevant to the user query.
    # using an already pre-processed dataset is still recommended for that
    # WARNING: $currentKnowledgebase_name , $current_output_dir ... must already have a prefix if a user query is involved, to prevent collision


    export scribbleInputFile="$1"
    local scribbleInputFolder=$(_getAbsoluteFolder "$scribbleInputFile")
    local scribbleInputName=$(basename "$scribbleInputFile")

    local scribbleOutputCommon=$(_getAbsoluteLocation "$current_activity_dir")

    local scribbleSubDir="${scribbleInputFolder#$scribbleOutputCommon}"

    local scribbleOutputFolder="$scribbleOutputCommon"/.scribbleAssist_bubble"$scribbleSubDir"
    local scribbleOutputFile="$scribbleOutputFolder"/"$scribbleInputName".scribbleAssist_bubble.txt

    export scribbleInputFile_moniker="$scribbleSubDir"/"$scribbleInputName"


    
    
    
    
    
    
    
    
    
    
    
    

    

    #$scribbleInputFile
    #"$safeTmp"/"$scribble_sessionid"
    # .../chunk001.txt , etc
    # .../bubbleHeader001.txt , etc
    #"$scribbleOutputFile"
    
    # WARNING: TODO: Unique sessionid, subdirectory of "$safeTmp", _safeRMR that subdirectory, etc.
    export scribble_file_sessionid=$(_uid 28)
    mkdir -p "$safeTmp"/"$scribble_file_sessionid"


    # split chunks, _scribble_chunk...

    

    _safeRMR "$safeTmp"/"$scribble_file_sessionid"








    # WARNING: Do NOT write anything to output file until everything is absolutely very definitely totally complete.

    # ... find other files/chunks/etc, compare recursively




    false
}




_vector_scribble_procedure() {

    _scribble_file "$@"

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


    # eg. "$scriptLocal"/_vector_scribble
    export currentKnowledgebase_dir=$(_getAbsoluteLocation "$scriptLocal"/_vector_scribble)
    export currentKnowledgebase_name=$(basename "$currentKnowledgebase_dir")

    export current_activity_dir=$(_getAbsoluteFolder "$scriptLocal"/_vector_scribble)

    # eg. "$scriptLocal"/.scribbleAssist_bubble/_vector_scribble
    export current_output_dir="$current_activity_dir"/.scribbleAssist_bubble/"$currentKnowledgebase_name"
    ! mkdir -p "$current_output_dir" && _messageError 'FAIL: mkdir: '"$current_output_dir"' ' && _stop 1



    
    # TODO: Inference cache variable with ai_backend will use if set.
    export inference_cache_dir="$current_output_dir"/inference_cache/




    ( echo '... _vector_scribble: ls -R' >&2 )
    ls -R "$scriptLocal"/_vector_scribble


    ( echo '... _vector_scribble: dispatch' >&2 )
    find "$scriptLocal"/_vector_scribble -type f -name '*' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _vector_scribble_procedure "$@"' _


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
