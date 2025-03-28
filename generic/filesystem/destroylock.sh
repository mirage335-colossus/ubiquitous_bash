
# Suggested for files used as Inter-Process Communication (IPC) or similar indicators (eg. temporary download files recently in progress).
# Works around files that may not be deleted by 'rm -f' when expected (ie. due to Cygwin/MSW file locking).
# ATTRIBUTION-AI: OpRt_.deepseek/deepseek-r1-distill-llama-70b  2025-03-27  (partial)
_destroy_lock() {
    # Fraction of   2GB part file  divided by  1MB/s optical-disc write speed   .
    local currentLockWait="1250"

    local current_anyFilesExists
    local currentFile
    
    
    local currentIteration=0
    for ((currentIteration=0; currentIteration<"$currentLockWait"; currentIteration++))
    do
        rm -f "$@" > /dev/null 2>&1

        current_anyFilesExists="false"
        for currentFile in "$@"
        do
            [[ -e "$currentFile" ]] && current_anyFilesExists="true"
        done

        if [[ "$current_anyFilesExists" == "false" ]]
        then
            return 0
            break
        fi

        # DANGER: Does NOT use _safeEcho . Do NOT use with external input!
        ( echo "STACK_FAIL STACK_FAIL STACK_FAIL: software: wait: rm: exists: file: ""$@" >&2 ) > /dev/null
        sleep 1
    done

    [[ "$currentIteration" != "0" ]] && sleep 7
    return 1
}


