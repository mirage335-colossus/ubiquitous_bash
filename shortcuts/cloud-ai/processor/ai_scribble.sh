


_scribble() {
    # eg. /stuff
    local currentKnowledgebase_dir=$(_getAbsoluteLocation "$1")
    local currentKnowledgebase_name=$(basename "$currentKnowledgebase_dir")

    local current_activity_dir=$(_getAbsoluteFolder "$1")

    # eg. /.scribbleAssist_bubble/stuff
    local current_output_dir="$current_activity_dir"/.scribbleAssist_bubble/"$currentKnowledgebase_name"
    ! mkdir -p "$current_output_dir" && _messageError 'FAIL: mkdir: '"$current_output_dir"' ' && _stop 1





}





_vector_scribble_procedure() {
    
    ( printf '%s: %s: ' "$sessionid" "$1" >&2 )
    
}

# WARNING: Intended for manual single-instance testing ONLY!
_vector_scribble_sequence() {
    _start

    mkdir -p "$scriptLocal"/_vector_scribble

    echo 'the quick brown fox jumps over the lazy dog' > "$scriptLocal"/_vector_scribble/sample1.md

    echo 'lorem ipsum' > "$scriptLocal"/_vector_scribble/sample2.md

    echo 'nothing to see here' > "$scriptLocal"/_vector_scribble/sample3.md

    ( echo '... _vector_scribble: ls -R' >&2 )
    ls -R "$scriptLocal"/_vector_scribble


    ( echo '... _vector_scribble: dispatch' >&2 )
    find "$scriptLocal"/_vector_scribble -type f -name '*' -print0 | xargs -0 -x -L 1 -P 2 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _vector_scribble_procedure "$@"' _


    ( echo '... _vector_scribble: cat' >&2 )
    cat "$scriptLocal"/_vector_scribble/*


    _safeRMR "$scriptLocal"/_vector_scribble

    _stop
}
_vector_scribble() {
    "$scriptAbsoluteLocation" _vector_scribble_sequence "$@"
}

_test_scribble() {
    
    _test_cloud_ai "$@"

}
