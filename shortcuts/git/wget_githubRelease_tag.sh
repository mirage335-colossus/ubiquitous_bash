
# WARNING: No production use. Non-essential.
# May be used nearly interchangeably in place of 'wget_githubRelease_internal' as an alternative to 'releaseLabel' downloads within 'build.yml, 'zCustom.yml', 'zUpgrade.yml', etc, GitHub Actions workflow builds (ie. internally downloading the ingredient, beforeBoot, etc, disk image, specifically for the currentTag, rather than the latest matching the 'build' label). Not regarded as production use since non-concurrent use of the 'releaseLabel' download functions is considered the production functions, as these have commonality with the functions tested by end-users over the vagarities of internet connections, and are the first functions maintained with any workarounds, etc, as needed.
#  ATTENTION: This definition of 'no production use', is consistent with the use of that phrase throughout 'ubiquitous_bash'. Production use of these functions, can be tolerated, but is NOT guaranteed. Best practice when using such 'no production use' functions in production scripting, is to leave a commented out, but adequately tested, alternative use of a function that is guaranteed, to quickly change this back if needed.
#
# Downloads single files through GitHub API by unique tag (instead of label).
#
# Only necessary for 'analysis' - downloading currentTag log files, comparing to log files from tags of previous releases.

# CAUTION: NOT included in 'rotten' .
# May depend on functions from 'wget_githubRelease_internal.sh', NOT vice-versa .









#env currentRepository='mirage335-colossus/ubiquitous_bash' currentReleaseTag='build-13917942290-9999' ./ubiquitous_bash.sh _wget_githubRelease-fromTag-analysisReport-fetch 20 'ubcp-binReport-UNIX_Linux'
#env:
#  currentRepository: ${{ github.repository }}
#  currentReleaseTag: build-${{ github.run_id }}-9999
#  GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
_wget_githubRelease-fromTag-analysisReport-fetch() {
    local currentLimit
    currentLimit="$1"
    shift

    mkdir -p "$scriptLocal"/analysisTmp

    local current_reportFiles_list
    current_reportFiles_list=()

    current_reportFiles_list=( "$@" )

    local current_reportFile

    #for current_reportFile in "${current_reportFiles_list[@]}"; do
        #_wget_githubRelease-fromTag-fetchReport "$currentRepository" "$currentReleaseTag" "$current_reportFile" > "$scriptLocal"/analysisTmp/"$current_reportFile"
    #done

    ! _wget_githubRelease-releasesTags "$currentRepository" "$currentLimit" | tr -dc 'a-zA-Z0-9\-_.:\n' > "$scriptLocal"/analysisTmp/releasesTags && _messageFAIL
    
    for current_reportFile in "${current_reportFiles_list[@]}"; do
        for current_reviewReleaseTag in $(cat "$scriptLocal"/analysisTmp/releasesTags); do
            # Download the (eg. binReport) report file for this release
            _wget_githubRelease-fromTag-fetchReport "$currentRepository" "$current_reviewReleaseTag" "$current_reportFile" --no-fail > "$scriptLocal"/analysisTmp/"$current_reportFile"-"$current_reviewReleaseTag"
        done
    done

    if [[ "$currentReleaseTag" != "" ]]
    then
        _wget_githubRelease-fromTag-analysisReport-select "${current_reportFiles_list[@]}"
        return
    fi
    return 0
}

#./ubiquitous_bash.sh _wget_githubRelease-fromTag-analysisReport-select 'ubcp-binReport-UNIX_Linux'
#env:
#  currentReleaseTag: build-${{ github.run_id }}-9999
_wget_githubRelease-fromTag-analysisReport-select() {
    mkdir -p "$scriptLocal"/analysisTmp

    local current_reportFiles_list
    current_reportFiles_list=()

    current_reportFiles_list=( "$@" )

    local current_reportFile

    if [[ "$currentReleaseTag" == "" ]]
    then
        ( echo 'FAIL: missing: currentReleaseTag' >&2 ) > /dev/null
        _messageFAIL
    fi
    
    for current_reportFile in "${current_reportFiles_list[@]}"; do
        ( _messagePlain_probe cat "$scriptLocal"/analysisTmp/"$current_reportFile"-"$currentReleaseTag" > "$scriptLocal"/analysisTmp/"$current_reportFile" >&2 ) > /dev/null
        if ! cat "$scriptLocal"/analysisTmp/"$current_reportFile"-"$currentReleaseTag" > "$scriptLocal"/analysisTmp/"$current_reportFile"
        then
            _messageFAIL
        fi
    done
    return 0
}


#env currentRepository='mirage335-colossus/ubiquitous_bash' currentReleaseTag='build-13917942290-9999' ./ubiquitous_bash.sh _wget_githubRelease-fromTag-analysisReport-analysis 65 'ubcp-binReport-UNIX_Linux'
#env:
#  currentReleaseTag: build-${{ github.run_id }}-9999
_wget_githubRelease-fromTag-analysisReport-analysis() {
    local currentLimit
    currentLimit="$1"
    shift

    mkdir -p "$scriptLocal"/analysisTmp

    local current_reportFiles_list
    current_reportFiles_list=()

    current_reportFiles_list=( "$@" )

    local current_reportFile
    
    for current_reportFile in "${current_reportFiles_list[@]}"; do
        rm -f "$scriptLocal"/analysisTmp/missing-"$current_reportFile"
        for current_reviewReleaseTag in $(cat "$scriptLocal"/analysisTmp/releasesTags); do
            # Compare the list of binaries, etc, in this release to the current release
            if [ "$current_reviewReleaseTag" != "$currentReleaseTag" ]; then
                echo | tee -a "$scriptLocal"/analysisTmp/missing-"$current_reportFile"
                echo 'Items (ie. '"$current_reportFile"') in '"$current_reviewReleaseTag"' but not in currentRelease '"$currentReleaseTag"':' | tee -a "$scriptLocal"/analysisTmp/missing-"$current_reportFile"
                #| tee -a "$scriptLocal"/analysisTmp/missing-"$current_reportFile"
                comm -23 <(sort "$scriptLocal"/analysisTmp/"$current_reportFile"-"$current_reviewReleaseTag") <(sort "$scriptLocal"/analysisTmp/"$current_reportFile") > "$scriptLocal"/analysisTmp/missing-"$current_reportFile".tmp
                cat "$scriptLocal"/analysisTmp/missing-"$current_reportFile".tmp | head -n "$currentLimit"
                cat "$scriptLocal"/analysisTmp/missing-"$current_reportFile".tmp >> "$scriptLocal"/analysisTmp/missing-"$current_reportFile"
                rm -f "$scriptLocal"/analysisTmp/missing-"$current_reportFile".tmp
            fi
        done
    done
    return 0
}

_safeRMR-analysisTmp() {
    [[ -e "$scriptLocal"/analysisTmp ]] && _safeRMR "$scriptLocal"/analysisTmp
}

#env currentRepository='mirage335-colossus/ubiquitous_bash' currentReleaseTag='build-13917942290-9999' ./ubiquitous_bash.sh _wget_githubRelease-fromTag-analysisReport 'ubcp-binReport-UNIX_Linux'
#env:
#  currentRepository: ${{ github.repository }}
#  currentReleaseTag: build-${{ github.run_id }}-9999
#  GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
# No production use.
_wget_githubRelease-fromTag-analysisReport() {
    _wget_githubRelease-fromTag-analysisReport-fetch 20 "$@"
    _wget_githubRelease-fromTag-analysisReport-select "$@"
    _wget_githubRelease-fromTag-analysisReport-analysis 65 "$@"
    _safeRMR-analysisTmp
}








#./ubiquitous_bash.sh _wget_githubRelease-fromTag-fetchReport 'soaringDistributions/ubDistBuild' 'build_upgrade-13945231768-9999' 'binReport'
#./ubiquitous_bash.sh _wget_githubRelease-fromTag-fetchReport 'soaringDistributions/ubDistBuild' 'build_upgrade-13945231768-9999' 'binReportX'
#"$GH_TOKEN"
_wget_githubRelease-fromTag-fetchReport() {
    ( _messagePlain_nominal '\/\/\/\/\/ init: _wget_githubRelease-fromTag-fetchReport' >&2 ) > /dev/null

    if [[ "$GH_TOKEN" == "" ]]
    then
        ( _messagePlain_bad 'bad: FAIL: GH_TOKEN not set' >&2 ) > /dev/null
        return 1
    fi
    
    local currentAbsoluteRepo="$1"
    local currentTag="$2"
    local currentFile="$3"
    local currentFailParam="$4"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"
    shift ; shift ; shift ; shift

    local current

    # ATTRIBUTION-AI: 2025-03-23
    #_set_curl_github_retry
    #curl "$currentFailParam" "${curl_retries_args[@]}" -s -S -L -H "Authorization: token $GH_TOKEN" -H "Accept: application/octet-stream" "$(curl "$currentFailParam" "${curl_retries_args[@]}" -s -S -H "Authorization: token $GH_TOKEN" "https://api.github.com/repos/""$currentAbsoluteRepo""/releases/tags/""$currentTag"  | jq -r '.assets[] | select(.name=="'"$currentFile"'") | .url')" -o -


    export githubRelease_retriesMax=2
	export githubRelease_retriesWait=4
    _set_curl_github_retry
	
    local currentExitStatus=0

    #local currentSkip
    #currentSkip=$(_wget_githubRelease-skip-URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$currentFailParam")
    #currentExitStatus="$?"
    #[[ "$currentExitStatus" != "0" ]] && [[ "$currentFailParam" != "--no-fail" ]] && return "$currentExitStatus"
    #[[ "$currentSkip" == "skip" ]] && [[ "$currentFailParam" == "--no-fail" ]] && return 0
    #[[ "$currentSkip" != 'download' ]] && [[ "$currentFailParam" != "--no-fail" ]] && return 1

    #curl "$currentFailParam" "${curl_retries_args[@]}" -s -S -L -H "Authorization: token $GH_TOKEN" -H "Accept: application/octet-stream" "$(_wget_githubRelease-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$currentFailParam")" -o -
    #currentExitStatus="$?"

    local current_API_URL
    current_API_URL=$(_wget_githubRelease-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$currentFailParam")
    currentExitStatus="$?"
    [[ "$currentExitStatus" != "0" ]] && [[ "$currentFailParam" != "--no-fail" ]] && return "$currentExitStatus"
    [[ "$current_API_URL" == "" ]] && [[ "$currentFailParam" == "--no-fail" ]] && return 0
    [[ "$current_API_URL" == '' ]] && [[ "$currentFailParam" != "--no-fail" ]] && return 1

    curl "$currentFailParam" "${curl_retries_args[@]}" -s -S -L -H "Authorization: token $GH_TOKEN" -H "Accept: application/octet-stream" "$current_API_URL" -o -
    
    _set_wget_githubRelease
    unset curl_retries_args
    
    return "$currentExitStatus"
}







#"$api_address_type" == "tagName" || "$api_address_type" == "url"
# ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
# ATTRIBUTION-AI: Many-Chat 2025-03-23
_jq_github_browser_download_address_fromTag() {
	( _messagePlain_probe 'init: _jq_github_browser_download_address_fromTag' >&2 ) > /dev/null
	#local currentReleaseLabel="$2"
    local currentTag="$2"
	local currentFile="$3"
	

    if [[ "$api_address_type" == "" ]] || [[ "$api_address_type" == "url" ]]
    then
        #jq -r ".assets[] | select(.name == "'"$currentFile"'") | .browser_download_url"
        #jq -r ".assets | sort_by(.published_at) | reverse | .[] | select(.name == "'"$currentFile"'") | .browser_download_url"

        #jq -r '.[] | select(.tag_name == "'"$currentTag"'") | .assets[] | select(.name == "'"$currentFile"'") | .browser_download_url'
        jq --arg shellFile "$currentFile" --arg shellTag "$currentTag" -r '.[] | select(.tag_name == $shellTag) | .assets[] | select(.name == $shellFile) | .browser_download_url'
        
        return
    fi
    if [[ "$api_address_type" == "tagName" ]]
    then
        #jq -r ".tag_name"
        
        # ATTRIBUTION-AI: ChatGPT 4.5-preview 2025-03-23
        #jq -r '.[] | select(.tag_name == "'"$currentTag"'") | select(.assets[].name == "'"$currentFile"'") | .tag_name'
        jq --arg shellFile "$currentFile" --arg shellTag "$currentTag" -r '.[] | select(.tag_name == $shellTag) | select(.assets[].name == $shellFile) | .tag_name'

        return
    fi
    if [[ "$api_address_type" == "api_url" ]]
    then
        #jq -r ".assets[] | select(.name == "'"$currentFile"'") | .url"
        #jq -r ".assets | sort_by(.published_at) | reverse | .[] | select(.name == \"$currentFile\") | .url"
        
        #jq -r ".[] | select(.tag_name == \"$currentTag\") | .assets[] | select(.name == \"$currentFile\") | .url"
        #jq -r '.[] | select(.tag_name == "'"$currentTag"'") | .assets[] | select(.name == "'"$currentFile"'") | .url'
        jq --arg shellFile "$currentFile" --arg shellTag "$currentTag" -r '.[] | select(.tag_name == $shellTag) | .assets[] | select(.name == $shellFile) | .url'

        return
    fi
}










#./ubiquitous_bash.sh _wget_githubRelease-API_URL_fromTag-curl 'soaringDistributions/ubDistBuild' 'build_upgrade-13945231768-9999' 'binReport' --fail | head

_wget_githubRelease_procedure-address_fromTag-curl() {
	local currentAbsoluteRepo="$1"
    local currentTag="$2"
    local currentFile="$3"
    local currentFailParam="$4"
    [[ "$currentFailParam" != "--no-fail" ]] && currentFailParam="--fail"

	#local currentReleaseLabel="$2"
	#local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	#[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0


    local currentData
    currentData=""
    
    local currentData_page
    currentData_page="doNotMatch"
    
    local currentIteration
    currentIteration=1
    
    # ATTRIBUTION-AI: Many-Chat 2025-03-23
    # Alternative detection of empty array, as suggested by AI LLM .
    #[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
    while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
    do
        #currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile")
        #_set_curl_github_retry
        currentData_page=$(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "doNotMatch" "$currentFile" "$currentIteration" "$currentFailParam" "${curl_retries_args[@]}")
        unset curl_retries_args
        currentExitStatus_tmp="$?"
        [[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
        currentData="$currentData"'
'"$currentData_page"

        ( _messagePlain_probe "_wget_githubRelease_procedure-address_fromTag-curl: ""$currentIteration" >&2 ) > /dev/null
        [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

        let currentIteration=currentIteration+1
    done

    #( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
    ( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_address_fromTag "" "$currentTag" "$currentFile" | head -n 1 )
    currentExitStatus_tmp="$?"

    [[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address_fromTag-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address_fromTag-curl: pipefail: _jq_github_browser_download_address_fromTag: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
    [[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-address_fromTag-curl: empty: currentData' >&2 ) > /dev/null && return 1
    
    return 0
}
_wget_githubRelease-address_fromTag-backend-curl() {
	local currentAddress
	currentAddress=""

	local currentExitStatus=1

	local currentIteration=0

    #export githubRelease_retriesMax=2
	#export githubRelease_retriesWait=4
	#[[ "$currentAddress" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentAddress=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL_fromTag-curl: _wget_githubRelease_procedure-address_fromTag-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-address_fromTag-curl >&2 ) > /dev/null
		currentAddress=$(_wget_githubRelease_procedure-address_fromTag-curl "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
    #_set_wget_githubRelease
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL_fromTag-curl: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-address_fromTag-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-address_fromTag-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL_fromTag-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="tagName"

    _wget_githubRelease-address_fromTag-backend-curl "$@"
    return
}
_wget_githubRelease-URL_fromTag-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-URL_fromTag-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL_fromTag-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

	currentAddress=$(_wget_githubRelease-address_fromTag-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL_fromTag-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}
_wget_githubRelease-address_fromTag() {
	local currentTag="$2"
    
    ( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-address_fromTag' >&2 ) > /dev/null
	if _if_gh
	then
		##( _messagePlain_probe_safe _wget_githubRelease-address_fromTag-gh "$@" >&2 ) > /dev/null
		##_wget_githubRelease-address_fromTag-gh "$@"
        _safeEcho_newline "$currentTag"
		return
	else
		#( _messagePlain_probe_safe _wget_githubRelease-address_fromTag-curl "$@" >&2 ) > /dev/null
		#_wget_githubRelease-address_fromTag-curl "$@"
        _safeEcho_newline "$currentTag"
		return
	fi
}

# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-URL_fromTag-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-URL_fromTag-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-URL_fromTag-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="url"

	local currentAddress

	local currentExitStatus=1

	currentAddress=$(_wget_githubRelease-address_fromTag-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL_fromTag-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-URL_fromTag-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-URL_fromTag-curl() {
	_wget_githubRelease-skip-URL_fromTag-curl "$@"
}

# WARNING: May be untested.
_wget_githubRelease-API_URL_fromTag-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-API_URL_fromTag-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-API_URL_fromTag-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

	currentAddress=$(_wget_githubRelease-address_fromTag-backend-curl "$@")
	currentExitStatus="$?"
	
	_safeEcho_newline "$currentAddress"

	[[ "$currentAddress" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-API_URL_fromTag-curl: empty: currentAddress' >&2 ) > /dev/null && return 1

    return "$currentExitStatus"
}

# WARNING: May be untested.
# Calling functions MUST attempt download unless skip function conclusively determines BOTH that releaseLabel exists in upstream repo, AND file does NOT exist upstream. Functions may use such skip to skip high-numbered part files that do not exist.
_wget_githubRelease-skip-API_URL_fromTag-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-skip-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-skip-API_URL_fromTag-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-skip-API_URL_fromTag-curl "$@" >&2 ) > /dev/null

    # ATTENTION: WARNING: Unusually, api_address_type , is a monolithic variable NEVER exported . Keep local, and do NOT use for any other purpose.
    local api_address_type="api_url"

	local currentAddress

	local currentExitStatus=1

	currentAddress=$(_wget_githubRelease-address_fromTag-backend-curl "$@")
	currentExitStatus="$?"
	
	( _safeEcho_newline "$currentAddress" >&2 ) > /dev/null
	[[ "$currentExitStatus" != "0" ]] && return "$currentExitStatus"

	if [[ "$currentAddress" == "" ]]
	then
		echo skip
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL_fromTag-curl: empty: currentAddress: PRESUME skip' >&2 ) > /dev/null
		return 0
	fi

	if [[ "$currentAddress" != "" ]]
	then
		echo download
		( _messagePlain_good 'good: _wget_githubRelease-skip-API_URL_fromTag-curl: found: currentAddress: PRESUME download' >&2 ) > /dev/null
		return 0
	fi

	return 1
}
_wget_githubRelease-detect-API_URL_fromTag-curl() {
	_wget_githubRelease-skip-API_URL_fromTag-curl "$@"
}















#_wget_githubRelease-fromTag-stdout

#_wget_githubRelease-fromTag



_wget_githubRelease-fromTag-stdout() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease-fromTag-stdout' >&2 ) > /dev/null
	local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
	
	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	[[ "$FORCE_DIRECT" == "true" ]] && _wget_githubRelease-fromTag_procedure-stdout "$@"

	# ATTENTION: /dev/null assures that stdout is not corrupted by any unexpected output that should have been sent to stderr
	[[ "$FORCE_DIRECT" != "true" ]] && _wget_githubRelease-fromTag_procedure-stdout "$@" > /dev/null

	if ! [[ -e "$currentAxelTmpFile".PASS ]]
	then
		currentExitStatus=$(cat "$currentAxelTmpFile".FAIL)
		( [[ "$currentExitStatus" == "" ]] || [[ "$currentExitStatus" = "0" ]] || [[ "$currentExitStatus" = "0"* ]] ) && currentExitStatus=1
		rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
		rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
		rm -f "$currentAxelTmpFile" > /dev/null 2>&1
		return "$currentExitStatus"
		#return 1
	fi
	[[ "$FORCE_DIRECT" != "true" ]] && cat "$currentAxelTmpFile"
	rm -f "$currentAxelTmpFile" > /dev/null 2>&1
	rm -f "$currentAxelTmpFile".PASS > /dev/null 2>&1
	rm -f "$currentAxelTmpFile".FAIL > /dev/null 2>&1
	return 0
}
_wget_githubRelease-fromTag_procedure-stdout() {
	( _messagePlain_probe_safe _wget_githubRelease-fromTag_procedure-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseTag="$2"
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

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	# WARNING: Very strongly discouraged. Any retry/continue of any interruption will nevertheless unavoidably result in a corrupted output stream.
	if [[ "$FORCE_DIRECT" == "true" ]]
	then
		_wget_githubRelease-fromTag_procedure "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" -O - "$@"
		currentExitStatus="$?"
		if [[ "$currentExitStatus" != "0" ]]
		then
			echo > "$currentAxelTmpFile".FAIL
			return "$currentExitStatus"
		fi
		echo > "$currentAxelTmpFile".PASS
		return 0
	fi

	_wget_githubRelease-fromTag_procedure "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" -O "$currentAxelTmpFile" "$@"
	currentExitStatus="$?"
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
		return "$currentExitStatus"
	fi
	echo > "$currentAxelTmpFile".PASS
	return 0
}



























#! "$scriptAbsoluteLocation" _wget_githubRelease-fromTag_join "owner/repo" "tag_name" "file.ext" -O "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext" -O "file.ext"
# ATTENTION: WARNING: Warn messages correspond to inability to assuredly, effectively, use GH_TOKEN .
_wget_githubRelease-fromTag() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease-fromTag' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-fromTag "$@" >&2 ) > /dev/null

	_wget_githubRelease-fromTag_procedure "$@"
}
_wget_githubRelease-fromTag_procedure() {
    # Should be very similar to '_wget_githubRelease_procedure' , but we will already have the tag , and in the case of curl/axel, we will need to generate the API_URL, in the case of 'gh' we will simply proceed to download.
    #
	# ATTENTION: Distinction nominally between '_wget_githubRelease' and '_wget_githubRelease_procedure' should only be necessary if a while loop retries the procedure .
	# ATTENTION: Potentially more specialized logic within download procedures should remain delegated with the responsibility to attempt retries , for now.
	# NOTICE: Several functions should already have retry logic: '_gh_download' , '_gh_downloadURL' , '_wget_githubRelease-address' , '_wget_githubRelease_procedure-curl' , '_wget_githubRelease-URL-curl' , etc .
	#( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ \/\/\/\/ init: _wget_githubRelease_procedure' >&2 ) > /dev/null
	#( _messagePlain_probe_safe _wget_githubRelease_procedure "$@" >&2 ) > /dev/null

    local currentAbsoluteRepo="$1"
	#local currentReleaseLabel="$2"
    local currentTag="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1

    local currentExitStatus=1

    # Discouraged .
    if [[ "$FORCE_WGET" == "true" ]]
    then
        _warn_githubRelease_FORCE_WGET
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL=$(_wget_githubRelease-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL=$(_wget_githubRelease-URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")

		_wget_githubRelease_loop-curl
        return "$?"
    fi

	# Discouraged . Benefits of multi-part-per-file downloading are less essential given that files are split into <2GB chunks.
	if [[ "$FORCE_AXEL" != "" ]] # && [[ "$MANDATORY_HASH" == "true" ]]
    then
        ( _messagePlain_warn 'warn: WARNING: FORCE_AXEL not empty' >&2 ; echo 'FORCE_AXEL may have similar effects to FORCE_WGET and should not be necessary.' >&2  ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL=$(_wget_githubRelease-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL=$(_wget_githubRelease-URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")

		[[ "$FORCE_DIRECT" == "true" ]] && ( _messagePlain_bad 'bad: fail: FORCE_AXEL==true is NOT compatible with FORCE_DIRECT==true' >&2 ) > /dev/null && return 1

		_wget_githubRelease_loop-axel
        return "$?"
    fi

    if _if_gh
    then
        #_wget_githubRelease-address_fromTag-gh
        #local currentTag
        #currentTag=$(_wget_githubRelease-address_fromTag "$currentAbsoluteRepo" "$currentTag" "$currentFile")

        ( _messagePlain_probe _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@" >&2 ) > /dev/null
        _gh_download "$currentAbsoluteRepo" "$currentTag" "$currentFile" "$@"
        currentExitStatus="$?"

        [[ "$currentExitStatus" != "0" ]] && _bad_fail_githubRelease_currentExitStatus && return "$currentExitStatus"
        [[ ! -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && _bad_fail_githubRelease_missing && return 1
        return 0
    fi

    if ! _if_gh
    then
        ( _messagePlain_warn 'warn: WARNING: FALLBACK: wget/curl' >&2 ) > /dev/null
        #local currentURL=$(_wget_githubRelease-URL-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		local currentURL
		[[ "$GH_TOKEN" != "" ]] && currentURL=$(_wget_githubRelease-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")
		[[ "$GH_TOKEN" == "" ]] && currentURL=$(_wget_githubRelease-URL_fromTag-curl "$currentAbsoluteRepo" "$currentTag" "$currentFile")

		_wget_githubRelease_loop-curl
        return "$?"
    fi
    
    return 1
}

































_wget_githubRelease-fromTag_join() {
    local currentAbsoluteRepo="$1"
	local currentReleaseTag="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && ( _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' >&2 ) > /dev/null && return 1

	if [[ "$currentOutParameter" == "-O" ]]
	then
		shift
		shift
	fi

	[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1


	# ATTENTION
	currentFile=$(basename "$currentFile")




	( _messagePlain_probe_safe _wget_githubRelease-fromTag_join "$@" >&2 ) > /dev/null

	_messagePlain_probe_safe _wget_githubRelease-fromTag_join-stdout "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" "$@" '>' "$currentOutFile" >&2
	_wget_githubRelease-fromTag_join-stdout "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" "$@" > "$currentOutFile"

	[[ ! -e "$currentOutFile" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1

	return 0
}




_wget_githubRelease-fromTag_join-stdout() {
	"$scriptAbsoluteLocation" _wget_githubRelease-fromTag_join_sequence-stdout "$@"
}
_wget_githubRelease-fromTag_join_sequence-stdout() {
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/\/ init: _wget_githubRelease-fromTag_join-stdout' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-fromTag_join-stdout "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseTag="$2"
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
			#echo "1" > "$currentAxelTmpFile".FAIL
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

	[[ "$FORCE_PARALLEL" == "1" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
	[[ "$FORCE_PARALLEL" == "0" ]] && ( _messagePlain_bad 'bad: fail: FORCE_PARALLEL: sanity' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
    
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
				# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
				#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
				[[ "$GH_TOKEN" != "" ]] && currentSkip=$(_wget_githubRelease-skip-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
				[[ "$GH_TOKEN" == "" ]] && currentSkip=$(_wget_githubRelease-skip-URL_fromTag-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
                #[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
                #[[ "$?" != "0" ]] && currentSkip="skip"
                [[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL_fromTag-curl' >&2 ) > /dev/null
            fi
            
            [[ "$currentSkip" == "skip" ]] && continue

            
            if [[ "$currentExitStatus" == "0" ]] || [[ "$currentSkip" != "skip" ]]
            then
                _set_wget_githubRelease "$@"
                currentSkip="download"
            fi


            _wget_githubRelease-fromTag_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile".part"$currentPart" -O - "$@"
            currentExitStatus="$?"
            #[[ "$currentExitStatus" != "0" ]] && break
        done

        return "$currentExitStatus"
    fi





	# ### ATTENTION: _if_buffer (IMPLICIT)

	# NOTICE: Parallel downloads may, if necessary, be adapted to first cache a list of addresses (ie. URLs) to download. API rate limits could then have as much time as possible to recover before subsequent commands (eg. analysis of builds). Such a cache must be filled with addresses BEFORE the download loop.


	export currentAxelTmpFileUID="$(_uid 14)"
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


	currentPart=""
	for currentPart in $(seq -f "%02g" 0 "$maxCurrentPart" | sort -r)
	do
		if [[ "$currentSkip" == "skip" ]]
		then
			# ATTENTION: EXPERIMENT
			# ATTENTION: Could expect to use the 'API_URL' function in both cases, since we are not using the resulting URL except to 'skip'/'download' .
			#currentSkip=$(_wget_githubRelease-skip-API_URL-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
			##currentSkip=$([[ "$currentPart" -gt "17" ]] && echo 'skip' ; true)
			[[ "$GH_TOKEN" != "" ]] && currentSkip=$(_wget_githubRelease-skip-API_URL_fromTag-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
			[[ "$GH_TOKEN" == "" ]] && currentSkip=$(_wget_githubRelease-skip-URL_fromTag-curl "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part"$currentPart")
			
			#[[ "$?" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-skip-API_URL-curl' >&2 ) > /dev/null && ( _messageError 'FAIL' >&2 ) > /dev/null && exit 1
			#[[ "$?" != "0" ]] && currentSkip="skip"
			[[ "$?" != "0" ]] && ( _messagePlain_warn 'bad: FAIL: _wget_githubRelease-skip-API_URL_fromTag-curl' >&2 ) > /dev/null
		fi
		
		[[ "$currentSkip" == "skip" ]] && continue

		#[[ "$currentExitStatus" == "0" ]] || 
		if [[ "$currentSkip" != "skip" ]]
		then
			_set_wget_githubRelease "$@"
			currentSkip="download"
			break
		fi
	done

	export currentSkipPart="$currentPart"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))

	"$scriptAbsoluteLocation" _wget_githubRelease-fromTag_join_sequence-parallel "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" &


	# Prebuffer .
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  preBUFFER: WAIT  ...  currentPart='"$currentPart" >&2 ) > /dev/null
	if [[ "$currentPart" -ge "01" ]] && [[ "$currentStream_max" -ge "2" ]]
	then
		#currentStream="2"
		for currentStream in $(seq "$currentStream_min" "$currentStream_max" | sort -r)
		do
			( _messagePlain_probe 'prebuffer: currentStream= '"$currentStream" >&2 ) > /dev/null
			while ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
			do
				sleep 3
			done
		done
	fi
	currentStream="$currentStream_min"


	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  outputLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Stream must have written PASS/FAIL file .
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: WAIT: PASS/FAIL ... currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
		do
			sleep 1
		done
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: OUTPUT  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# ATTENTION: EXPERIMENT
		#status=none
		dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
		#cat "$scriptAbsoluteFolder"/$(_axelTmp)
		#dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M | pv --rate-limit 100M 2>/dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  outputLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	true
}
_wget_githubRelease-fromTag_join_sequence-parallel() {
	local currentAbsoluteRepo="$1"
	local currentReleaseTag="$2"
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
			#echo "1" > "$currentAxelTmpFile".FAIL
			return 1
		fi
		shift 
		shift
	fi


	#export currentAxelTmpFileUID="$(_uid 14)"
	_axelTmp() {
		echo .m_axelTmp_"$currentStream"_"$currentAxelTmpFileUID"
	}
	#local currentAxelTmpFile
	#currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)

	# Due to parallelism , only API rate limits, NOT download speeds, are a concern with larger number of retries. 
	_set_wget_githubRelease "$@"
	#_set_wget_githubRelease-detect "$@"
	#_set_wget_githubRelease-detect-parallel "$@"
	local currentSkip="skip"
	
	local currentStream_min=1
	local currentStream_max=3
	[[ "$FORCE_PARALLEL" != "" ]] && currentStream_max="$FORCE_PARALLEL"
	[[ "$currentStream_max" -gt "$currentSkipPart" ]] && currentStream_max=$(( "$currentSkipPart" + 1 ))
	
	currentStream="$currentStream_min"
	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
	do
	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  downloadLOOP  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	#( _messagePlain_probe_var currentPart >&2 ) > /dev/null
	#( _messagePlain_probe_var currentStream >&2 ) > /dev/null

		# Slot in use. Downloaded  "$scriptAbsoluteFolder"/$(_axelTmp)  file will be DELETED after use by calling process.
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BUSY  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: detect skip  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && _set_wget_githubRelease "$@" && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELETE  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DELAY: stagger, Inter-Process Communication, _stop  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		# Staggered Delay.
		[[ "$currentPart" == "$currentSkipPart" ]] && sleep 2
		[[ "$currentPart" != "$currentSkipPart" ]] && sleep 6
		# Inter-Process Communication Delay.
		# Prevents new download from starting before previous download process has done  rm -f "$currentAxelTmpFile"*  .
		#  Beware that  rm  is inevitable or at least desirable - called by _stop() through trap, etc.
		sleep 7
		
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: DOWNLOAD  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		export currentAxelTmpFile="$scriptAbsoluteFolder"/$(_axelTmp)
		"$scriptAbsoluteLocation" _wget_githubRelease-fromTag_procedure-join "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile".part$(printf "%02g" "$currentPart") &
		echo "$!" > "$scriptAbsoluteFolder"/$(_axelTmp).pid

		# Stream must have written either in-progress download or PASS/FAIL file .
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
		while ! ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  downloadLOOP: WAIT: BEGIN  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 0.6
		done

		let currentStream=currentStream+1
		[[ "$currentStream" -gt "$currentStream_max" ]] && currentStream="$currentStream_min"
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: DELETE' >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
		while ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		do
		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: WAIT: BUSY  ...  currentStream='"$currentStream" >&2 ) > /dev/null
			sleep 1
		done

		( _messagePlain_nominal '\/\/\/\/\/ \/\/\/  download: DELETE ...  currentStream='"$currentStream" >&2 ) > /dev/null
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp).PASS > /dev/null 2>&1
		rm -f "$scriptAbsoluteFolder"/$(_axelTmp).FAIL > /dev/null 2>&1
	done

	( _messagePlain_nominal '\/\/\/\/\/ \/\/\/\/  download: WAIT PID  ...  currentPart='"$currentPart"' currentStream='"$currentStream" >&2 ) > /dev/null
	for currentStream in $(seq "$currentStream_min" "$currentStream_max")
	do
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).pid ]] && _pauseForProcess $(cat "$scriptAbsoluteFolder"/$(_axelTmp).pid) > /dev/null
	done
	wait >&2

	true
}
_wget_githubRelease-fromTag_procedure-join() {
	( _messagePlain_probe_safe _wget_githubRelease-fromTag_procedure-join "$@" >&2 ) > /dev/null

	local currentAbsoluteRepo="$1"
	local currentReleaseTag="$2"
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

	#local currentAxelTmpFileRelative=.m_axelTmp_"$currentStream"_$(_uid 14)
	#local currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

	local currentExitStatus

	echo -n > "$currentAxelTmpFile".busy

	# ATTENTION: EXPERIMENT
	_wget_githubRelease-fromTag_procedure "$currentAbsoluteRepo" "$currentReleaseTag" "$currentFile" -O "$currentAxelTmpFile" "$@"
    #dd if=/dev/zero bs=1M count=1500 > "$currentAxelTmpFile"
	#echo "$currentFile" >> "$currentAxelTmpFile"
    #dd if=/dev/urandom bs=1M count=1500 | pv --rate-limit 300M 2>/dev/null > "$currentAxelTmpFile"
	currentExitStatus="$?"

	# Inter-Process Communication Delay
	# Essentially a 'minimum download time' .
	sleep 7

	[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo -n > "$currentAxelTmpFile"
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
	fi

    while [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
    do
        sleep 1
    done

    [[ "$currentAxelTmpFile" != "" ]] && rm -f "$currentAxelTmpFile".*

    #unset currentAxelTmpFile

    [[ "$currentExitStatus" == "0" ]] && return 0
    return "$currentExitStatus"
}


































































































































#./ubiquitous_bash.sh _wget_githubRelease-releasesTags soaringDistributions/ubDistBuild 20
#./ubiquitous_bash.sh _wget_githubRelease_procedure-releasesTags-curl soaringDistributions/ubDistBuild 20
#./ubiquitous_bash.sh _wget_githubRelease_procedure-releasesTags-gh soaringDistributions/ubDistBuild 20
_wget_githubRelease_procedure-releasesTags-curl() {
	local currentAbsoluteRepo="$1"
    local currentQuantity="$2"
    [[ "$currentQuantity" == "0" ]] && currentQuantity=20

	#local currentReleaseLabel="$2"
	#local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	#[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	#[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0


    local currentData
    currentData=""
    
    local currentData_page
    currentData_page="doNotMatch"
    
    local currentIteration
    currentIteration=1
    
    # ATTRIBUTION-AI: Many-Chat 2025-03-23
    # Alternative detection of empty array, as suggested by AI LLM .
    #[[ $(jq 'length' <<< "$currentData_page") -gt 0 ]]
    while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) )
    do
        #currentData_page=$(_curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
        # ATTENTION: FORCE curl retry , since we will not be doing prebuffering (or downloading any files) directly with 'releasesTags' .
        _set_curl_github_retry
        currentData_page=$(_curl_githubAPI_releases_page "$currentAbsoluteRepo" "doNotMatch" "doNotMatch" "$currentIteration" "$currentFailParam" "${curl_retries_args[@]}")
        unset curl_retries_args
        currentExitStatus_tmp="$?"
        [[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
        currentData="$currentData"'
'"$currentData_page"
        
        ( _messagePlain_probe "_wget_githubRelease_procedure-releasesTags-curl: ""$currentIteration" >&2 ) > /dev/null
        [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

        let currentIteration=currentIteration+1
    done

    #( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_releasesTags "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
    ( set -o pipefail ; _safeEcho_newline "$currentData" | jq -r 'sort_by(.published_at) | reverse | .[].tag_name' | tr -dc 'a-zA-Z0-9\-_.:\n' | sed '/^$/d' | head -n "$currentQuantity" )
    currentExitStatus_tmp="$?"

    [[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-curl: pipefail: jq: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
    [[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-curl: empty: currentData' >&2 ) > /dev/null && return 1
    
    return 0
}
_wget_githubRelease-releasesTags-backend-curl() {
	local currentReleasesTags
	currentReleasesTags=""

	local currentExitStatus=1

	local currentIteration=0

	#export githubRelease_retriesMax=2
	#export githubRelease_retriesWait=4
	#[[ "$currentReleasesTags" == "" ]] || 
	while ( [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentReleasesTags=""

		if [[ "$currentIteration" != "0" ]]
		then
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL-curl: _wget_githubRelease_procedure-releasesTags-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-releasesTags-curl >&2 ) > /dev/null
		currentReleasesTags=$(_wget_githubRelease_procedure-releasesTags-curl "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
    #_set_wget_githubRelease
	
	_safeEcho_newline "$currentReleasesTags"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}
_wget_githubRelease-releasesTags-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-releasesTags-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-releasesTags-curl "$@" >&2 ) > /dev/null

    _wget_githubRelease-releasesTags-backend-curl "$@"
    return
}

_wget_githubRelease_procedure-releasesTags-gh-awk() {
	awk '
        # Skip a header line if it appears first:
        NR == 1 && $1 == "TITLE" && $2 == "TYPE" {
            # Just move on to the next line and do nothing else
            next
        }

        {
            # If the second column is one of the known “types,” shift fields left so
            # the *real* tag moves into $2. Repeat until no more known types remain.
            while ($2 == "Latest" || $2 == "draft" || $2 == "pre-release" || $2 == "prerelease") {
            for (i=2; i<NF; i++) {
                $i = $(i+1)
            }
            NF--
            }
            # At this point, $2 is guaranteed to be the actual tag.
            print $2
		}
		'
}
# Requires "$GH_TOKEN" .
_wget_githubRelease_procedure-releasesTags-gh() {
	( _messagePlain_nominal "$currentStream"'\/\/\/ init: _wget_githubRelease_procedure-releasesTags-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease_procedure-releasesTags-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
    local currentQuantity="$2"
    [[ "$currentQuantity" == "0" ]] && currentQuantity=20
    
	#local currentReleaseLabel="$2"
	#local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	#[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	#[[ "$currentFile" == "" ]] && return 1


	local currentExitStatus_tmp=0
	local currentExitStatus=0


    local currentData
    currentData=""
    
    local currentData_page
    currentData_page="doNotMatch"
    
    local currentIteration
    currentIteration=1
    
    while ( [[ "$currentData_page" != "" ]] && ( [[ "$currentIteration" -le "1" ]] || ( [[ "$GH_TOKEN" != "" ]] && [[ "$currentIteration" -le "3" ]] ) ) )
    do
        currentData_page=$(set -o pipefail ; gh release list -L $(( $currentIteration * 100 )) -R "$currentAbsoluteRepo" | _wget_githubRelease_procedure-releasesTags-gh-awk | tr -dc 'a-zA-Z0-9\-_.:\n' | tail -n +$(( $currentIteration * 100 - 100 + 1 )))
        currentExitStatus_tmp="$?"
        [[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
        currentData="$currentData"'
'"$currentData_page"

        ( _messagePlain_probe "_wget_githubRelease_procedure-releasesTags-gh: ""$currentIteration" >&2 ) > /dev/null
        [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

        let currentIteration=currentIteration+1
    done

    #( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_releasesTags "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
    #( set -o pipefail ; _safeEcho_newline "$currentData" | jq -r 'sort_by(.published_at) | reverse | .[].tag_name' | head -n "$currentQuantity" | tr -dc 'a-zA-Z0-9\-_.:\n' )
    ( set -o pipefail ; _safeEcho_newline "$currentData" | tr -dc 'a-zA-Z0-9\-_.:\n' | sed '/^$/d' | head -n "$currentQuantity" )
    currentExitStatus_tmp="$?"

    [[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-gh: gh: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-gh: pipefail: head: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
    [[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease_procedure-releasesTags-gh: empty: currentData' >&2 ) > /dev/null && return 1

    return 0
}
_wget_githubRelease-releasesTags-gh() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-releasesTags-gh .
	( _messagePlain_nominal "$currentStream"'\/\/\/\/ init: _wget_githubRelease-releasesTags-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-releasesTags-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1

	local currentTag
	currentTag=""

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentTag" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentTag=""

		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-releasesTags-gh: _wget_githubRelease_procedure-releasesTags-gh: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-releasesTags-gh >&2 ) > /dev/null
		currentTag=$(_wget_githubRelease_procedure-releasesTags-gh "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentTag"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-releasesTags-gh: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}

_wget_githubRelease-releasesTags() {
	( _messagePlain_nominal "$currentStream"'\/\/\/\/\/ init: _wget_githubRelease-releasesTags' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-releasesTags-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-releasesTags-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-releasesTags-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-releasesTags-curl "$@"
		return
	fi
}















