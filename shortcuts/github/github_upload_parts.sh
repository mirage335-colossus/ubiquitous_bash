


# "$1" == build-${{ github.run_id }}-${{ github.run_attempt }}
#shift
# "$@" == ./_local/package_image_beforeBoot.tar.flx.part*
_gh_release_upload_parts-multiple_sequence() {
    _messageNormal '_gh_release_upload_parts: '"$@"
    local currentTag="$1"
    shift

    local currentStream_max=12

    local currentStreamNum=0

    for currentFile in "$@"
    do
        let currentStreamNum++

        "$scriptAbsoluteLocation" _gh_release_upload_part-single_sequence "$currentTag" "$currentFile" &
        eval local currentStream_${currentStreamNum}_PID="$!"
        _messagePlain_probe_var currentStream_${currentStreamNum}_PID
        
        while [[ $(jobs | wc -l) -ge "$currentStream_max" ]]
        do
            echo
            jobs
            echo
            sleep 2
            true
        done
    done

    local currentStreamPause
    for currentStreamPause in $(seq "1" "$currentStreamNum")
	do
        _messagePlain_probe currentStream_${currentStreamPause}_PID= $(eval "echo \$currentStream_${currentStreamPause}_PID")
		if eval "[[ \$currentStream_${currentStreamPause}_PID != '' ]]"
        then
           _messagePlain_probe _pauseForProcess $(eval "echo \$currentStream_${currentStreamPause}_PID")
           _pauseForProcess $(eval "echo \$currentStream_${currentStreamPause}_PID")
        fi
	done

    while [[ $(jobs | wc -l) -ge 1 ]]
    do
        echo
        jobs
        echo
        sleep 2
        true
    done
    
    wait
}
_gh_release_upload_part-single_sequence() {
    _messageNormal '_gh_release_upload: '"$1"' '"$2"
    local currentTag="$1"
    local currentFile="$2"

    #local currentPID
    #"$scriptAbsoluteLocation" _stopwatch gh release upload "$currentTag" "$currentFile" &
    #currentPID="$!"

    #_pauseForProcess "$currentPID"
    #wait

    #while ! "$scriptAbsoluteLocation" _stopwatch _timeout 10 dd if="$currentFile" bs=1M status=progress > /dev/null
    #do
        #sleep 7
    #done
    #return 0

    # Maximum file size is 2GigaBytes .
    while ! "$scriptAbsoluteLocation" _stopwatch _timeout 600 gh release upload --clobber "$currentTag" "$currentFile"
    do
        sleep 7
    done
    return 0
}


