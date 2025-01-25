
# WARNING: May be untested.
# WARNING: Known flaws, issues, etc.
# WARNING: OBSOLETE .
# WARNING: Buffered method is not expected to correctly download fewer than the buffer and prebuffer number of parts.
_wget_githubRelease_join-stdout() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease_join-stdout' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_join-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	if [[ "$currentOutParameter" == "-O" ]]
	then
		if [[ "$currentOutFile" != "-" ]]
		then
			( _messagePlain_bad 'bad: fail: unexpected: currentOutFile: NOT stdout' >&2 ) > /dev/null
			echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


    _set_wget_githubRelease "$@"


    local currentPart
    local currentSkip
    local currentStream
	local currentStream_wait
	local currentBusyStatus

	# CAUTION: Any greater than 50 is not expected to serve any purpose, may exhaust expected API rate limits, may greatly delay download, and may disrupt subsequent API requests. Any less than 50 may fall below the ~100GB capacity that is both expected necessary for some complete toolchains and at the limit of ~100GB archival quality optical disc .
	local maxCurrentPart=50


    local currentExitStatus=1



    (( [[ "$FORCE_BUFFER" == "true" ]] && [[ "$FORCE_DIRECT" == "true" ]] ) || ( [[ "$FORCE_BUFFER" == "false" ]] && [[ "$FORCE_DIRECT" == "false" ]] )) && ( _messagePlain_bad 'bad: fail: FORCE_BUFFER , FORCE_DIRECT: conflict' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
    ``
    [[ "$FORCE_AXEL" != "" ]] && [[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1

    [[ "$FORCE_AXEL" != "" ]] && ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null



    _if_buffer() {
        if ( [[ "$FORCE_BUFFER" == "true" ]] || [[ "$FORCE_DIRECT" == "false" ]] ) || [[ "$FORCE_BUFFER" == "" ]]
        then
            true
            return
        else
            false
            return
        fi
        true
        return
    }


    
    # WARNING: FORCE_DIRECT="true" , "FORCE_BUFFER="false" very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
    if ! _if_buffer
    then
        #export FORCE_DIRECT="true"

        _set_wget_githubRelease-detect "$@"
        currentSkip="skip"

        currentStream="noBuf"
        #local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	    #local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

        currentPart=""
        for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
        do
            if [[ "$currentSkip" == "skip" ]]
            then
                currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart")
                #[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
                #[[ "$?" != "0" ]] && currentSkip="skip"
                [[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null
            fi
            
            [[ "$currentSkip" == "skip" ]] && continue

            
            if [[ "$currentExitStatus" == "0" ]] || [[ "$currentSkip" != "skip" ]]
            then
                _set_wget_githubRelease "$@"
                currentSkip="download"
            fi


            _wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart" -O - "$@"
            currentExitStatus="$?"
            #[[ "$currentExitStatus" != "0" ]] && break
        done

        return "$currentExitStatus"
    fi





	# ### ATTENTION: _if_buffer (IMPLICIT)

	# NOTICE: Parallel downloads may, if necessary, be adapted to first cache a list of addresses (ie. URLs) to download. API rate limits could then have as much time as possible to recover before subsequent commands (eg. analysis of builds). Such a cache must be filled with addresses BEFORE the download loop.





	local currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"

	currentStream="$currentStream_min"


	currentPart="$maxCurrentPart"

	
	

	_set_wget_githubRelease-detect "$@"
	currentSkip="skip"

	local tmpBufferSlot

	local preBufferSlot=1
	local preBuffer_max=2
	local bufferSlot="$currentStream_min"
	for currentPart in $(seq -f "%02g" 0 "$currentPart" | sort -r)
	do
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_join-stdout: LOOP' >&2 ) > /dev/null
		_messagePlain_probe_var currentPart
		

		# SKIP .
		# Fallback method of successfully downloading a file fundamentally has no criteria to begin prebuffering, buffering during cat/dd, etc, other than successfully downloading a file. Theoretical alternatives are to either: (1) download each part file to a separate slot, then cat/dd each slot, risking out-of-order cat/dd if any files complete downloading out-of-order, OR (2) download multiple part files ahead, resulting in that many slot files ahead getting the valid part file, as well as incurring the same out-of-order risks, at best.
		# Fundamentally, smart management of this issue requires either (1) rapid testing of which files actually exist upstream, such as using an API call, (2) slow timeout to still somewhat less reliably determine which files actually exist upstream, or (3) storage capacity and algorithms to download all files iteratively establishing statistical confidence in which files failed to download due to nonexistence upstream rather than very chaotic variations in contentious network performance.
		# NOTICE: Prebuffering in a constrained environment thus fundamentally requires the skip function to indeed skip downloading files that do not exist upstream.
		if [[ "$currentSkip" == "skip" ]]
		then
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: SKIP' >&2 ) > /dev/null
		_messagePlain_probe_var currentPart
			currentSkip=$(_wget_githubRelease-skip-URL-curl "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".$(printf "%02g" "$currentPart"))
			#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
			#[[ "$?" != "0" ]] && currentSkip="skip"
			[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-URL-curl' >&2 ) > /dev/null
		fi
		
		[[ "$currentSkip" == "skip" ]] && continue # ###

		if [[ "$currentExitStatus" == "0" ]] || [[ "$currentSkip" != "skip" ]]
		then
			_set_wget_githubRelease "$@"
			currentSkip="download"
		fi


		# DOWNLOAD preBuffer.
		if [[ "$preBufferSlot" != "false" ]]
		then
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: DOWNLOAD prebuffer' >&2 ) > /dev/null
		_messagePlain_probe_var preBufferSlot
			currentStream=pre_"$preBufferSlot"
			
			currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
			rm -f "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1
			"$scriptAbsoluteLocation" _wget_githubRelease_procedure-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part$(printf "%02g" "$currentPart") &
			echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid
			

			let preBufferSlot++
			[[ "$preBufferSlot" -gt "$preBuffer_max" ]] && preBufferSlot="false"
			continue # ###
		fi
		
		
		

		# FULL preBuffer .
		currentStream=pre_"1"
		if ( [[ "$preBufferSlot" -gt "$preBuffer_max" ]] || [[ "$preBufferSlot" == "false" ]] ) && ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 )
		then
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: FULL prebuffer' >&2 ) > /dev/null
			
			# DOWNLOAD buffer .
			if [[ "$bufferSlot" -le "$currentStream_max" ]] && [[ "$currentSkip" != "skip" ]]
			then
			( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/ init: _wget_githubRelease_join-stdout: LOOP: DOWNLOAD buffer' >&2 ) > /dev/null
			_messagePlain_probe_var bufferSlot
				currentStream="$BufferSlot"

				currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
				rm -f "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1
				"$scriptAbsoluteLocation" _wget_githubRelease_procedure-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part$(printf "%02g" "$currentPart") &
				echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid

				# Staggered.
				sleep 6 > /dev/null 2>&1

				let bufferSlot++
				continue # ###
			fi
			[[ "$bufferSlot" -gt "$currentStream_max" ]] && bufferSlot="$currentStream_min"

			# CAT and DELETE prebuffer .
			for ((tmpBufferSlot="1"; tmpBufferSlot<="$preBuffer_max"; tmpBufferSlot++))
			do
			( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/ init: _wget_githubRelease_join-stdout: LOOP: CAT and DELETE prebuffer' >&2 ) > /dev/null
			_messagePlain_probe_var tmpBufferSlot
				currentStream=pre_"$tmpBufferSlot"
				while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 ) && ! ( [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] )
				do
					[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) && exit 1

					if [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]]
					then
						#status=progress
						dd if="$currentAxelTmpFile" bs=1M
						#cat "$currentAxelTmpFile"
						rm -f "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1

						_set_wget_githubRelease "$@"
						currentSkip="download"
					fi

					sleep 3 > /dev/null
				done

				[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" == "skip" ]] && preBufferSlot="1" && continue # ###
			done

		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: DONE prebuffer' >&2 ) > /dev/null
		fi
		# DONE preBuffer .



		currentStream="$bufferSlot"


		# CAT and DELETE slot .
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: CAT and DELETE slot' >&2 ) > /dev/null
		_messagePlain_probe_var bufferSlot
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 ) && ! ( [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] )
		do
			[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && ( _messageError 'FAIL' >&2 ) && exit 1

			if [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]]
			then
				#status=progress
				dd if="$currentAxelTmpFile" bs=1M
				#cat "$currentAxelTmpFile"
				rm -f "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1
			fi

			sleep 3 > /dev/null
		done


		# DOWNLOAD slot .
		( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/ init: _wget_githubRelease_join-stdout: LOOP: DOWNLOAD slot' >&2 ) > /dev/null
		_messagePlain_probe_var bufferSlot
		currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1
		"$scriptAbsoluteLocation" _wget_githubRelease_procedure-stdout "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part$(printf "%02g" "$currentPart") &
		echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid


		let bufferSlot++
		[[ "$bufferSlot" -gt "$currentStream_max" ]] && bufferSlot="$currentStream_min"
	done



}
