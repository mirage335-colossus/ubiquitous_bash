
# WARNING: No production use. (yet)
#
# Downloads single files through GitHub API by unique tag (instead of label).
#
# Only necessary for 'analysis' - downloading currentTag log files, comparing to log files from tags of previous releases.
# May eventually be expanded to support multi-part parallel prebuffered downloads to allow concurrency with 'build.yml', 'zCustom.yml', 'zUpgrade.yml', etc, GitHub Actions workflow builds (ie. internally downloading the ingredient, beforeBoot, etc, disk image, specifically for the currentTag, rather than the latest matching the 'build' label).

# CAUTION: NOT included in 'rotten' .
# May depend on functions from 'wget_githubRelease_internal.sh', NOT vice-versa .





#./ubiquitous_bash.sh _wget_githubRelease-fromTag-fetchReport 'soaringDistributions/ubDistBuild' 'build_upgrade-13945231768-9999' 'binReport'
#./ubiquitous_bash.sh _wget_githubRelease-fromTag-fetchReport 'soaringDistributions/ubDistBuild' 'build_upgrade-13945231768-9999' 'binReportX'
_wget_githubRelease-fromTag-fetchReport() {
    ( _messagePlain_nominal '\/\/\/\/\/ init: _wget_githubRelease-fromTag-fetchReport' >&2 ) > /dev/null
    
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
        #jq -r ".assets[] | select(.name == \"""$currentFile""\") | .browser_download_url"
        #jq -r ".assets | sort_by(.published_at) | reverse | .[] | select(.name == \"""$currentFile""\") | .browser_download_url"

        jq -r '.[] | select(.tag_name == "'"$currentTag"'") | .assets[] | select(.name == "'"$currentFile"'") | .browser_download_url'
        return
    fi
    if [[ "$api_address_type" == "tagName" ]]
    then
        #jq -r ".tag_name"
        
        # ATTRIBUTION-AI: ChatGPT 4.5-preview 2025-03-23
        jq -r '.[] | select(.tag_name == "'"$currentTag"'") | select(.assets[].name == "'"$currentFile"'") | .tag_name'
        return
    fi
    if [[ "$api_address_type" == "api_url" ]]
    then
        #jq -r ".assets[] | select(.name == \"""$currentFile""\") | .url"
        #jq -r ".assets | sort_by(.published_at) | reverse | .[] | select(.name == \"$currentFile\") | .url"
        
        #jq -r ".[] | select(.tag_name == \"$currentTag\") | .assets[] | select(.name == \"$currentFile\") | .url"
        jq -r '.[] | select(.tag_name == "'"$currentTag"'") | .assets[] | select(.name == "'"$currentFile"'") | .url'
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
    
    while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && [[ "$currentIteration" -le "3" ]]
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
        #curentTag=$(_wget_githubRelease-address_fromTag "$currentAbsoluteRepo" "$currentTag" "$currentFile")

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
    
    while ( [[ "$currentData_page" != "" ]] && [[ $(_safeEcho_newline "$currentData_page" | tr -dc 'a-zA-Z\[\]' | sed '/^$/d') != $(echo 'WwoKXQo=' | base64 -d | tr -dc 'a-zA-Z\[\]') ]] ) && [[ "$currentIteration" -le "3" ]]
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
    
    while ( [[ "$currentData_page" != "" ]] && [[ "$currentIteration" -le "3" ]] )
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















