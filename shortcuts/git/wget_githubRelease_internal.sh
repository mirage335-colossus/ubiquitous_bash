
# Refactored from code which was very robust with fast ISP, however often failed with slower ISP, as explained by ChatGPT due to AWS S3 temporary link expiration.
# See "_ref/wget_githubRelease_internal-OBSOLETE.sh" for original code, which due to the more iterative development process at the time, may be more reliable in untested cases.

# WARNING: May be untested.

# WARNING: CAUTION: Many functions rely on emitting to standard output . Experiment/diagnose by copying code to override with 'ops.sh' . CAUTION: Be very careful enabling or using diagnostic output to stderr, as stderr may also be redirected by calling functions, terminal may not be present, etc.
#( echo x >&2 ) > /dev/null
#_messagePlain_probe_var page >&2 | cat /dev/null
#_messagePlain_probe_safe "currentAPI_URL= ""$currentAPI_URL" >&2 | cat /dev/null
# WARNING: Limit stderr pollution for log (including CI logs) and terminal readability , using 'tail' .
#( cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | tail -n 10
#( set -o pipefail ; false | cat ubiquitous_bash.sh >&2 ) 2> >(tail -n 10 >&2) | cat > /dev/null
#( set -o pipefail ; false 2> >(tail -n 10 >&2) | cat > /dev/null )

# DANGER: Use _messagePlain_probe_safe , _safeEcho , _safeEcho_newline , etc .

# CAUTION: ATTENTION: Uncommented lines add to ALL 'compiled' bash shell scripts - INCLUDING rotten_compressed.sh !
# Thus, it may be preferable to keep example code as a separate line commented at the beginning of that line, rather than a comment character nearer end of line.



#_get_vmImg_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_beforeBoot_ubDistBuild_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar xv --overwrite
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_image_beforeBoot.tar.flx" | _get_extract_ubDistBuild-tar --extract ./vm.img --to-stdout | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist_beforeBoot.txt"


#_get_vmImg_ubDistBuild-live_sequence
#export MANDATORY_HASH="true"
# write file
#_wget_githubRelease_join "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso"
#currentHash_bytes=$(_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt" | head -n 14 | tail -n 1 | sed 's/^.*count=$(bc <<< '"'"'//' | cut -f1 -d\  )
# write packetDisc (eg. '/dev/sr0', '/dev/dvd'*, '/dev/cdrom'*)
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n growisofs -speed=3 -dvd-compat -Z "$3"=/dev/stdin -use-the-force-luke=notray -use-the-force-luke=spare:min -use-the-force-luke=bufsize:128m
# write disk (eg. '/dev/sda')
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "vm-live.iso" | tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n dd of="$3" bs=1M status=progress
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"


#_get_vmImg_ubDistBuild-rootfs_sequence
#export MANDATORY_HASH="true"
#_wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "package_rootfs.tar.flx" | lz4 -d -c > ./package_rootfs.tar
#
#export MANDATORY_HASH=
#unset MANDATORY_HASH
#_wget_githubRelease-stdout "soaringDistributions/ubDistBuild" "$releaseLabel" "_hash-ubdist.txt"



#! "$scriptAbsoluteLocation" _wget_githubRelease_join "owner/repo" "internal" "file.ext"
#! _wget_githubRelease "owner/repo" "" "file.ext"


#_wget_githubRelease_join "soaringDistributions/Llama-augment_bundle" "" "llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf"



#_wget_githubRelease-stdout
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join
#export MANDATORY_HASH="true"
#export MANDATORY_HASH=""

#_wget_githubRelease_join-stdout
#export MANDATORY_HASH="true"


#export FORCE_WGET="true"
#export FORCE_AXEL="4"
#export GH_TOKEN="..."

#type -p gh > /dev/null 2>&1


#_wget_githubRelease_internal

#curl --no-progress-meter
#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10

## Use variables to construct the gh release download command
#local currentIteration
#currentIteration=0
#while ! [[ -e "$current_fileOut" ]] && [[ "$currentIteration" -lt 3 ]]
#do
	##gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@"
	#gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10
	#! [[ -e "$current_fileOut" ]] && sleep 7
	#let currentIteration=currentIteration+1
#done
#[[ -e "$current_fileOut" ]]
#return "$?"





[[ "$githubRelease_retriesMax" == "" ]] && export githubRelease_retriesMax=25
[[ "$githubRelease_retriesWait" == "" ]] && export githubRelease_retriesWait=18





_if_gh() {
	if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]]
	then
		( _messagePlain_probe '_if_gh: gh' >&2 ) > /dev/null
		return 0
	fi
	( _messagePlain_probe '_if_gh: NOT gh' >&2 ) > /dev/null
	return 1
}


#_wget_githubRelease-URL "owner/repo" "" "file.ext"
#_wget_githubRelease-URL "owner/repo" "latest" "file.ext"
#_wget_githubRelease-URL "owner/repo" "internal" "file.ext"
_wget_githubRelease-URL() {
	( _messagePlain_nominal '\/\/\/\/\/ init: _wget_githubRelease-URL' >&2 ) > /dev/null
	if _if_gh
	then
		( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-gh "$@"
		return
	else
		( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null
		_wget_githubRelease-URL-curl "$@"
		return
	fi
}
#_wget_githubRelease-URL "owner/repo" "file.ext"
_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}

_jq_github_browser_download_url() {
	( _messagePlain_probe 'init: _jq_github_browser_download_url' >&2 ) > /dev/null
	local currentReleaseLabel="$2"
	local currentFile="$3"
	
	# 'latest'
	if [[ "$currentReleaseLabel" == "latest" ]] || [[ "$currentReleaseLabel" == "" ]]
	then
		#jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" 
		jq -r ".assets[] | select(.name == \"""$currentFile""\") | .browser_download_url"
		return
	# eg. 'internal', 'build', etc
	else
		#jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1
		jq -r "sort_by(.published_at) | reverse | .[] | select(.name == \"""$currentReleaseLabel""\") | .assets[] | select(.name == \"""$currentFile""\") | .browser_download_url"
		return
	fi
}
_curl_githubAPI_releases_page() {
	( _messagePlain_nominal '\/\/\/ init: _curl_githubAPI_releases_page' >&2 ) > /dev/null
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

	local currentPageNum="$4"
	[[ "$currentPageNum" == "" ]] && currentPageNum="1"
	_messagePlain_probe_var page >&2 | cat /dev/null
	
	local currentAPI_URL
	currentAPI_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases?per_page=100&page=""$currentPageNum"
	[[ "$currentReleaseLabel" == "latest" ]] && currentAPI_URL="https://api.github.com/repos/""$currentAbsoluteRepo""/releases""/latest"
	_messagePlain_probe_safe "currentAPI_URL= ""$currentAPI_URL" >&2 | cat /dev/null

	local current_curl_args
	current_curl_args=()
	[[ "$GH_TOKEN" != "" ]] && current_curl_args+=( -H "Authorization: Bearer $GH_TOKEN" )
	current_curl_args+=( -S )
	current_curl_args+=( -s )

	local currentPage
	currentPage=""

	local currentExitStatus_ipv4=0
	local currentExitStatus_ipv6=0

	( _messagePlain_probe '_curl_githubAPI_releases_page: IPv6' >&2 ) > /dev/null
	currentPage=$(curl -6 "${current_curl_args[@]}" "$currentAPI_URL")
	currentExitStatus_ipv6="$?"
	( _messagePlain_probe '_curl_githubAPI_releases_page: IPv4' >&2 ) > /dev/null
	[[ "$currentPage" == "" ]] && currentPage=$(curl -4 "${current_curl_args[@]}" "$currentAPI_URL")
	currentExitStatus_ipv4="$?"
	
	_safeEcho_newline "$currentPage"

	if [[ "$currentExitStatus_ipv6" != "0" ]] && [[ "$currentExitStatus_ipv4" != "0" ]]
	then
		( _messagePlain_bad 'bad: FAIL: _curl_githubAPI_releases_page' >&2 ) > /dev/null
		[[ "$currentExitStatus_ipv4" != "1" ]] && [[ "$currentExitStatus_ipv4" != "0" ]] && return "$currentExitStatus_ipv4"
		[[ "$currentExitStatus_ipv6" != "1" ]] && [[ "$currentExitStatus_ipv6" != "0" ]] && return "$currentExitStatus_ipv6"
		return "$currentExitStatus_ipv4"
	fi

	[[ "$currentPage" == "" ]] && return 1
	return 0
}
_wget_githubRelease_procedure-URL-curl() {
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1


	if [[ "$currentReleaseLabel" == "latest" ]]
	then
		(set -o pipefail ; _curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" | _jq_github_browser_download_url "" "$currentReleaseLabel" "$currentFile")
		return
	else
		local currentData
		currentData=""
		
		local currentData_page
		currentData_page="doNotMatch"
		
		local currentIteration
		currentIteration=1

		local currentExitStatus_tmp=0
		local currentExitStatus=0
		
		while ( [[ "$currentData_page" != "" ]] && [[ "$currentData_page" != *$(echo 'WwoKXQo=' | base64 -d)* ]] ) && [[ "$currentIteration" -le "3" ]]
		do
			currentData_page=$(_curl_githubAPI_releases_page "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" "$currentIteration")
			currentExitStatus_tmp="$?"
			[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
			currentData="$currentURL"'
'"$currentData_page"

            ( _messagePlain_probe "_wget_githubRelease-URL-curl: ""$currentIteration" >&2 ) > /dev/null
            #( _safeEcho_newline "$currentData" | _jq_github_browser_download_url "" "$currentReleaseLabel" "$currentFile" | head -n 1 >&2 ) > /dev/null
            [[ "$currentIteration" -ge 4 ]] && ( _safeEcho_newline "$currentData_page" >&2 ) > /dev/null

			let currentIteration=currentIteration+1
		done

		( set -o pipefail ; _safeEcho_newline "$currentData" | _jq_github_browser_download_url "" "$currentReleaseLabel" "$currentFile" | head -n 1 )
		currentExitStatus_tmp="$?"
		[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: _curl_githubAPI_releases_page: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
		[[ "$currentExitStatus_tmp" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: pipefail: _jq_github_browser_download_url: currentExitStatus_tmp' >&2 ) > /dev/null && return "$currentExitStatus_tmp"
		[[ "$currentData" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: empty: currentData' >&2 ) > /dev/null && return 1
		[[ "$(_safeEcho_newline "$currentData" | _jq_github_browser_download_url "" "$currentReleaseLabel" "$currentFile" | head -n 1 | wc -c )" -le 0 ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: empty: _safeEcho_newline | _jq_github_browser_download_url' >&2 ) > /dev/null  && return 1
		return 0
	fi
}
_wget_githubRelease-URL-curl() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal '\/\/\/\/ init: _wget_githubRelease-URL-curl' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-curl "$@" >&2 ) > /dev/null

	local currentURL
	currentURL=""

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentURL" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentURL=""

		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL-curl: _wget_githubRelease_procedure-URL-curl: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-URL-curl >&2 ) > /dev/null
		currentURL=$(_wget_githubRelease_procedure-URL-curl "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentURL"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-curl: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}

_wget_githubRelease-URL-gh-awk() {
	( _messagePlain_probe 'init: _wget_githubRelease-URL-gh-awk' >&2 ) > /dev/null
    local currentReleaseLabel="$2"
    
    # WARNING: Use of comples 'awk' scripts historically has seemed less resilient, less portable, less reliable.
    # ATTRIBUTION-AI: ChatGPT o1 2025-01-22 .
    awk -v label="$currentReleaseLabel" '
    # For each line where the first column equals the label we are looking for...
    $1 == label {
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
_wget_githubRelease_procedure-URL-gh() {
	( _messagePlain_nominal '\/\/\/\/ init: _wget_githubRelease-URL-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null
    ! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentReleaseLabel="$2"
	local currentFile="$3"

	[[ "$currentAbsoluteRepo" == "" ]] && return 1
	[[ "$currentReleaseLabel" == "" ]] && currentReleaseLabel="latest"
	[[ "$currentFile" == "" ]] && return 1

    local currentTag

	local currentExitStatus=0
	local currentExitStatus_tmp=0

    local currentIteration
    currentIteration=1

    while [[ "$currentTag" == "" ]] && [[ "$currentIteration" -le 3 ]]
    do
        #currentTag=$(gh release list -L 100 -R "$currentAbsoluteRepo" | sed 's/Latest//' | grep '^'"$currentReleaseLabel" | awk '{ print $2 }' | head -n 1)
        
        currentTag=$(set -o pipefail ; gh release list -L $(( $currentIteration * 100 )) -R "$currentAbsoluteRepo" | _wget_githubRelease-URL-gh-awk "" "$currentReleaseLabel" "" | head -n 1)    # or pick whichever match you want
        currentExitStatus_tmp="$?"
		[[ "$currentIteration" == "1" ]] && currentExitStatus="$currentExitStatus_tmp"
		
        let currentIteration++
    done

    #echo "$currentTag"
    _safeEcho_newline "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTag""/""$currentFile"

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: pipefail: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
    [[ "$currentTag" == "" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: empty: currentTag' >&2 ) > /dev/null && return 1

    return 0
}
_wget_githubRelease-URL-gh() {
	# Similar retry logic for all similar functions: _wget_githubRelease-URL-curl, _wget_githubRelease-URL-gh .
	( _messagePlain_nominal '\/\/\/\/ init: _wget_githubRelease-URL-gh' >&2 ) > /dev/null
	( _messagePlain_probe_safe _wget_githubRelease-URL-gh "$@" >&2 ) > /dev/null

	local currentURL
	currentURL=""

	local currentExitStatus=1

	local currentIteration=0

	while ( [[ "$currentURL" == "" ]] || [[ "$currentExitStatus" != "0" ]] ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		currentURL=""

		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _wget_githubRelease-URL-gh: _wget_githubRelease_procedure-URL-gh: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe _wget_githubRelease_procedure-URL-gh >&2 ) > /dev/null
		currentURL=$(_wget_githubRelease_procedure-URL-gh "$@")
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	_safeEcho_newline "$currentURL"

	[[ "$currentIteration" -ge "$githubRelease_retriesMax" ]] && ( _messagePlain_bad 'bad: FAIL: _wget_githubRelease-URL-gh: maxRetries' >&2 ) > /dev/null && return 1

	return 0
}





# _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_download() {
	( _messagePlain_nominal '\/\/\/\/\/ init: _gh_downloadURL' >&2 ) > /dev/null
	
	! _if_gh && return 1
	
	local currentAbsoluteRepo="$1"
	local currentTagName="$2"
	local currentFile="$3"

	local currentOutParameter="$4"
	local currentOutFile="$5"

	shift
	shift
	shift
	[[ "$currentOutParameter" != "-O" ]] && currentOutFile="$currentFile"
	#[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFile"

	#[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && currentOutFile="$currentFile"
	[[ "$currentOutParameter" == "-O" ]] && [[ "$currentOutFile" == "" ]] && _messagePlain_bad 'bad: fail: unexpected: unspecified: currentOutFile' && return 1

	[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile" > /dev/null 2>&1

	local currentExitStatus=1

	local currentIteration
	currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _gh_download: gh release download: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		( _messagePlain_probe_safe gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" "$@" >&2 ) > /dev/null
		( set -o pipefail ; gh release download --clobber "$currentTagName" -R "$currentAbsoluteRepo" -p "$currentFile" "$@" 2> >(tail -n 10 >&2) )
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	done
	
	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_download: gh release download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	[[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}
#_gh_downloadURL "https://github.com/""$currentAbsoluteRepo""/releases/download/""$currentTagName""/""$currentFile" "$currentOutFile"
# Requires "$GH_TOKEN" .
_gh_downloadURL() {
	( _messagePlain_nominal '\/\/\/\/\/ init: _gh_downloadURL' >&2 ) > /dev/null
	
	! _if_gh && return 1

	# ATTRIBUTION-AI: ChatGPT GPT-4 2023-11-04 ... refactored 2025-01-22 ... .

	local currentURL="$1"
	local currentOutParameter="$2"
	local currentOutFileParameter="$3"

	[[ "$currentURL" == "" ]] && return 1

	# Use `sed` to extract the parts of the URL
	local currentAbsoluteRepo=$(echo "$currentURL" | sed -n 's|https://github.com/\([^/]*\)/\([^/]*\)/.*|\1/\2|p')
	[[ "$?" != "0" ]] && return 1
	local currentTagName$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/\([^/]*\)/.*|\1|p')
	[[ "$?" != "0" ]] && return 1
	local currentFile=$(echo "$currentURL" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/[^/]*/\(.*\)|\1|p')
	[[ "$?" != "0" ]] && return 1

	currentOutFile="$currentFile"

	shift
	[[ "$currentOutParameter" == "-O" ]] && currentOutFile="$currentOutFileParameter" && shift && shift

	local currentExitStatus=1
	#currentExitStatus=1

	local currentIteration
	currentIteration=0
	# && ( [[ "$currentIteration" != "0" ]] && sleep "$githubRelease_retriesWait" )
	#while ( [[ "$currentExitStatus" != "0" ]] || ( ! [[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] ) ) && [[ "$currentIteration" -lt "$githubRelease_retriesMax" ]]
	#do
		if [[ "$currentIteration" != "0" ]]
		then 
			( _messagePlain_warn 'warn: BAD: RETRY: _gh_downloadURL: _gh_download: currentIteration != 0' >&2 ) > /dev/null
			sleep "$githubRelease_retriesWait"
		fi

		#[[ "$currentOutFile" != "-" ]] && rm -f "$currentOutFile"
		( _messagePlain_probe_safe _gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@" >&2 ) > /dev/null
		_gh_download "$currentAbsoluteRepo" "$currentTagName" "$currentFile" -O "$currentOutFile" "$@"
		currentExitStatus="$?"

		let currentIteration=currentIteration+1
	#done

	[[ "$currentExitStatus" != "0" ]] && ( _messagePlain_bad 'bad: FAIL: _gh_downloadURL: _gh_download: currentExitStatus' >&2 ) > /dev/null && return "$currentExitStatus"
	[[ -e "$currentOutFile" ]] && [[ "$currentOutFile" != "-" ]] && ( _messagePlain_bad 'bad: FAIL: missing: currentOutFile' >&2 ) > /dev/null && return 1

	return 0
}





















# ###
# ATTENTION: TODO: Replace old code.




_aria2c_bin_githubRelease() {
	#--retry-on-http-error=400,429,500,502,503,504 
	aria2c --timeout=180 --max-tries=25 --retry-wait=15 "$@"
}





_wget_githubRelease() {
	local currentURL=$(_wget_githubRelease-URL "$@")
	if [[ "$GH_TOKEN" == "" ]]
	then
		_messagePlain_probe curl -L -o "$3" "$currentURL" >&2
		curl -L -o "$3" "$currentURL"
	else
		if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]] && [[ "$FORCE_WGET" != "true" ]]
		then
			_messagePlain_probe _gh_downloadURL "$currentURL" -O "$3" >&2
			_gh_downloadURL "$currentURL" -O "$3"
		else
			# Broken. Must use 'gh' instead.
			_messagePlain_probe curl -H "Authorization: Bearer "'$GH_TOKEN' -L -o "$3" "$currentURL" >&2
			_messagePlain_warn 'warn: DUBIOUS: GH_TOKEN with wget/curl is definitively limited to public repositories at best and may or may not have no effect whatsoever'
			curl -H "Authorization: Bearer $GH_TOKEN" -L -o "$3" "$currentURL"
		fi
	fi
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
	return 0
}

_wget_githubRelease-stdout() {
	local currentURL=$(_wget_githubRelease-URL "$@")
	if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]] && [[ "$FORCE_WGET" != "true" ]]
	then
		_messagePlain_probe _gh_downloadURL "$currentURL" -O - >&2
		_gh_downloadURL "$currentURL" -O -
		return
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			_messagePlain_probe curl -L -o - "$currentURL" >&2
			curl -L -o - "$currentURL"
		else
			# Broken. Must use 'gh' instead.
			_messagePlain_probe curl -H "Authorization: Bearer "'$GH_TOKEN' -L -o - "$currentURL" >&2
			_messagePlain_warn 'warn: DUBIOUS: GH_TOKEN with wget/curl is definitively limited to public repositories at best and may or may not have no effect whatsoever'
			curl -H "Authorization: Bearer $GH_TOKEN" -L -o - "$currentURL"
		fi
		return
	fi
}


_wget_githubRelease_join-stdout() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$scriptAbsoluteFolder"
	
	local currentURL
	local currentURL_array

	local currentIteration
	currentIteration=0
	for currentIteration in $(seq -f "%02g" 0 50)
	do
		currentURL=$(_wget_githubRelease-URL "$1" "$2" "$3"".part""$currentIteration")
		[[ "$currentURL" == "" ]] && break
		[[ "$currentURL" != "" ]] && currentURL_array+=( "$currentURL" )
	done

	# https://unix.stackexchange.com/questions/412868/bash-reverse-an-array
	local currentValue
	for currentValue in "${currentURL_array[@]}"
	do
		currentURL_array_reversed=("$currentValue" "${currentURL_array_reversed[@]}")
	done
	
	# DANGER: Requires   ' "$MANDATORY_HASH" == true '   to indicate use of a hash obtained more securely to check download integrity. Do NOT set 'MANDATORY_HASH' explicitly, safe functions which already include appropriate checks for integrity will set this safety flag automatically.
	# CAUTION: Do NOT use unless reasonable to degrade network traffic collision backoff algorithms. Unusual defaults, very aggressive, intended for load-balanced multi-WAN with at least 3 WANs .
	if [[ "$FORCE_AXEL" != "" ]] && ( [[ "$MANDATORY_HASH" == "true" ]] )
	then
		#local currentAxelTmpFile
		#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
		export currentAxelTmpFileRelative=.m_axelTmp_$(_uid 14)
		export currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

		#local currentAxelPID

		local currentForceAxel
		currentForceAxel="$FORCE_AXEL"

		( [[ "$currentForceAxel" == "true" ]] || [[ "$currentForceAxel" == "" ]] ) && currentForceAxel="48"
		[[ "$currentForceAxel" -lt 2 ]] && currentForceAxel="2"

		currentForceAxel=$(bc <<< "$currentForceAxel""*0.5" | cut -f1 -d\. )
		[[ "$currentForceAxel" -lt 2 ]] && currentForceAxel="2"

		#_messagePlain_probe axel -a -n "$FORCE_AXEL" -o "$currentAxelTmpFile" "${currentURL_array_reversed[@]}" >&2
		#axel -a -n "$FORCE_AXEL" -o "$currentAxelTmpFile" "${currentURL_array_reversed[@]}" >&2 &
		#currentAxelPID="$!"


		local current_usable_ipv4
		current_usable_ipv4="false"
		#if _timeout 8 _aria2c_bin_githubRelease --async-dns=false -o "$currentAxelTmpFile" --disable-ipv6 --allow-overwrite=true --auto-file-renaming=false --file-allocation=none --timeout=6 "${currentURL_array_reversed[0]}" >&2
		#then
			#current_usable_ipv4="true"
		#fi
		if [[ "$GH_TOKEN" == "" ]]
		then
			if _timeout 5 wget -4 -O - "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv4="true"
			fi
		else
			if _timeout 5 wget -4 -O - --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv4="true"
			fi
		fi

		local current_usable_ipv6
		current_usable_ipv6="false"
		if [[ "$GH_TOKEN" == "" ]]
		then
			if _timeout 5 wget -6 -O - "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv6="true"
			fi
		else
			if _timeout 5 wget -6 -O - --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv6="true"
			fi
		fi

		local currentPID_1
		local currentPID_2
		currentIteration=0
		local currentIterationNext1
		let currentIterationNext1=currentIteration+1
		rm -f "$currentAxelTmpFile"
		rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
		while [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]] || [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp2 ]]
		do
			#rm -f "$currentAxelTmpFile"
			rm -f "$currentAxelTmpFile".aria2
			rm -f "$currentAxelTmpFile".tmp
			rm -f "$currentAxelTmpFile".tmp.st
			rm -f "$currentAxelTmpFile".tmp.aria2
			rm -f "$currentAxelTmpFile".tmp1
			rm -f "$currentAxelTmpFile".tmp1.st
			rm -f "$currentAxelTmpFile".tmp1.aria2
			#rm -f "$currentAxelTmpFile".tmp2
			#rm -f "$currentAxelTmpFile".tmp2.st
			#rm -f "$currentAxelTmpFile".tmp2.aria2
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1

			# https://github.com/aria2/aria2/issues/1108

			if [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]]
			then
				# Download preferring from IPv6 address .
				if [[ "$current_usable_ipv6" == "true" ]]
				then
					if [[ "$GH_TOKEN" == "" ]]
					then
						#--file-allocation=falloc
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					else
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIteration]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					fi
				else
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true "${currentURL_array_reversed[$currentIteration]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					else
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIteration]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					fi
				fi
			fi
			
			
			# CAUTION: ATTENTION: Very important. Simultaneous reading and writing is *very* important for writing directly to slow media (ie. BD-R) .
			#  NOTICE: Wirting directly to slow BD-R is essential for burning a Live disc from having booted a Live disc.
			#   DANGER: Critical for rapid recovery back to recent upstream 'ubdist/OS' ! Do NOT unnecessarily degrade this capability!
			#  Also theoretically helpful with especially fast network connections.
			#if [[ "$currentIteration" != "0" ]]
			if [[ -e "$currentAxelTmpFile".tmp2 ]]
			then
				# ATTENTION: Staggered.
				#sleep 10 > /dev/null 2>&1
				wait "$currentPID_2" >&2
				#wait >&2

				sleep 0.2 > /dev/null 2>&1
				if [[ -e "$currentAxelTmpFile".tmp2 ]]
				then
					_messagePlain_probe dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
					
					# ### dd if="$currentAxelTmpFile".tmp2 bs=5M status=progress >> "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress
					#cat "$currentAxelTmpFile".tmp2
					
					du -sh "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
					
					#cat "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
				fi
			else
				if [[ "$currentIteration" == "0" ]]
				then
					# ATTENTION: Staggered.
					#sleep 6 > /dev/null 2>&1
					true
				fi
			fi
			rm -f "$currentAxelTmpFile".tmp2
			rm -f "$currentAxelTmpFile".tmp2.st
			rm -f "$currentAxelTmpFile".tmp2.aria2
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			
			


			if [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]]
			then
				# Download preferring from IPv4 address.
				#--disable-ipv6
				if [[ "$current_usable_ipv4" == "true" ]]
				then
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					else
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					fi
				else
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					else
						_messagePlain_probe _aria2c_bin_githubRelease -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						_aria2c_bin_githubRelease --log=- --log-level=info -x "$currentForceAxel" --async-dns=false -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					fi
				fi
			fi
			

			# ATTENTION: NOT staggered.
			#wait "$currentPID_1" >&2
			#wait "$currentPID_2" >&2
			#wait >&2
			
			if [[ "$currentIteration" == "0" ]]
			then
				wait "$currentPID_1" >&2
				sleep 6 > /dev/null 2>&1
				[[ "$currentPID_2" == "" ]] && sleep 35 > /dev/null 2>&1
				[[ "$currentPID_2" != "" ]] && wait "$currentPID_2" >&2
				wait >&2
			fi

			wait "$currentPID_1" >&2
			sleep 0.2 > /dev/null 2>&1
			if [[ -e "$currentAxelTmpFile".tmp1 ]]
			then
				_messagePlain_probe dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
				
				if [[ ! -e "$currentAxelTmpFile" ]]
				then
					# ### mv -f "$currentAxelTmpFile".tmp1 "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
					
					du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
				else
					# ATTENTION: Staggered.
					#dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress >> "$currentAxelTmpFile" &
				
					# ATTENTION: NOT staggered.
					# ### dd if="$currentAxelTmpFile".tmp1 bs=5M status=progress >> "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
					#cat "$currentAxelTmpFile".tmp1
					
					du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
					
					#cat "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
				fi
			fi

			let currentIteration=currentIteration+2
			let currentIterationNext1=currentIteration+1
		done
		

		#for currentValue in "${currentURL_array_reversed[@]}"
		#do
			#rm -f "$currentAxelTmpFile".tmp
			
			
			##_messagePlain_probe axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			##axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#if [[ "$GH_TOKEN" == "" ]]
			#then
				#_messagePlain_probe axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
				#axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#else
				#_messagePlain_probe axel -a -n "$currentForceAxel" -H '"Authorization: Bearer $GH_TOKEN"' -o "$currentAxelTmpFile".tmp "$currentValue" >&2
				#axel -a -n "$currentForceAxel" -H "Authorization: Bearer $GH_TOKEN" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#fi
			
			
			#_messagePlain_probe dd if="$currentAxelTmpFile".tmp bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
			#dd if="$currentAxelTmpFile".tmp bs=1M status=progress >> "$currentAxelTmpFile"
			#let currentIteration=currentIteration+1
		#done

		#while [[ "$currentIteration" -le 16 ]] && [[ ! -e "$currentAxelTmpFile" ]]
		#do
			#sleep 2 > /dev/null 2>&1
			#let currentIteration="$currentIteration"+1
		#done

		#if [[ -e "$currentAxelTmpFile" ]]
		#then
			#tail --pid="$currentAxelPID" -c 100000000000 -f "$currentAxelTmpFile"
			#wait "$currentAxelPID"
		#else
			#_messagePlain_bad 'missing: "$currentAxelTmpFile"' >&2
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#sleep 3
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#sleep 3
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#kill -KILL "$currentAxelPID" > /dev/null 2>&1
			#return 1
		#fi

		if ! [[ -e "$currentAxelTmpFile" ]]
		then
			true
			# ### return 1
		fi

		# ### cat "$currentAxelTmpFile"

		rm -f "$currentAxelTmpFile"
		rm -f "$currentAxelTmpFile".aria2
		rm -f "$currentAxelTmpFile".tmp
		rm -f "$currentAxelTmpFile".tmp.st
		rm -f "$currentAxelTmpFile".tmp.aria2
		rm -f "$currentAxelTmpFile".tmp1
		rm -f "$currentAxelTmpFile".tmp1.st
		rm -f "$currentAxelTmpFile".tmp1.aria2
		rm -f "$currentAxelTmpFile".tmp2
		rm -f "$currentAxelTmpFile".tmp2.st
		rm -f "$currentAxelTmpFile".tmp2.aria2
		rm -f "$currentAxelTmpFile".tmp3
		rm -f "$currentAxelTmpFile".tmp3.st
		rm -f "$currentAxelTmpFile".tmp3.aria2
		rm -f "$currentAxelTmpFile".tmp4
		rm -f "$currentAxelTmpFile".tmp4.st
		rm -f "$currentAxelTmpFile".tmp4.aria2
			
		rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
		
		return 0
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			_messagePlain_probe curl -L "${currentURL_array_reversed[@]}" >&2
			curl -L "${currentURL_array_reversed[@]}"
		elif type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]] && [[ "$FORCE_WGET" != "true" ]]
		then
			
			if [[ $(cat /proc/meminfo | grep MemTotal | tr -cd '[[:digit:]]') -gt 16379210 ]] && [[ "$FORCE_LOWTMP" != "true" ]]
			then
				
				
				
				
				# ATTENTION: Follows structure based on functionality for 'aria2c' .
				
				#local currentAxelTmpFile
				#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
				export currentAxelTmpFileRelative=.m_axelTmp_$(_uid 14)
				export currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
				
				local currentPID_1
				local currentPID_2
				local currentPID_3
				local currentPID_4
				local currentIteration
				currentIteration=0
				local currentIterationNext1
				let currentIterationNext1=currentIteration+1
				local currentIterationNext2
				let currentIterationNext2=currentIteration+2
				local currentIterationNext3
				let currentIterationNext3=currentIteration+3
				rm -f "$currentAxelTmpFile"
				rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				while [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]] || [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp2 ]] || [[ "${currentURL_array_reversed[$currentIterationNext2]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp3 ]] || [[ "${currentURL_array_reversed[$currentIterationNext3]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp4 ]]
				do
					#rm -f "$currentAxelTmpFile"
					rm -f "$currentAxelTmpFile".aria2 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp.st > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp.aria2 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp1 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp1.st > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp1.aria2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
					
					#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1

					# https://github.com/aria2/aria2/issues/1108

					if [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]]
					then
						_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFileRelative".tmp1 >&2
						#"$scriptAbsoluteLocation"
						_gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFileRelative".tmp1 >&2 &
						currentPID_1="$!"
					fi
					
					
					# CAUTION: ATTENTION: Very important. Simultaneous reading and writing is *very* important for writing directly to slow media (ie. BD-R) .
					#  NOTICE: Wirting directly to slow BD-R is essential for burning a Live disc from having booted a Live disc.
					#   DANGER: Critical for rapid recovery back to recent upstream 'ubdist/OS' ! Do NOT unnecessarily degrade this capability!
					#  Also theoretically helpful with especially fast network connections.
					#if [[ "$currentIteration" != "0" ]]
					if [[ -e "$currentAxelTmpFile".tmp2 ]]
					then
						# ATTENTION: Staggered.
						#sleep 10 > /dev/null 2>&1
						wait "$currentPID_2" >&2
						[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
						#wait >&2

						sleep 0.2 > /dev/null 2>&1
						if [[ -e "$currentAxelTmpFile".tmp2 ]]
						then
							_messagePlain_probe dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
							
							# ### dd if="$currentAxelTmpFile".tmp2 bs=5M status=progress >> "$currentAxelTmpFile"
							dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress
							#cat "$currentAxelTmpFile".tmp2
							
							du -sh "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
							
							#cat "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
						fi
					else
						if [[ "$currentIteration" == "0" ]]
						then
							# ATTENTION: Staggered.
							#sleep 6 > /dev/null 2>&1
							true
						fi
					fi
					rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
					
					if [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]]
					then
						_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext1]}" -O "$currentAxelTmpFileRelative".tmp2 >&2
						#"$scriptAbsoluteLocation" 
						_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext1]}" -O "$currentAxelTmpFileRelative".tmp2 >&2 &
						currentPID_2="$!"
					fi
					
					
					
					if [[ -e "$currentAxelTmpFile".tmp3 ]]
					then
						# ATTENTION: Staggered.
						#sleep 10 > /dev/null 2>&1
						wait "$currentPID_3" >&2
						[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
						#wait >&2

						sleep 0.2 > /dev/null 2>&1
						if [[ -e "$currentAxelTmpFile".tmp3 ]]
						then
							_messagePlain_probe dd if="$currentAxelTmpFile".tmp3 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
							
							# ### dd if="$currentAxelTmpFile".tmp3 bs=5M status=progress >> "$currentAxelTmpFile"
							dd if="$currentAxelTmpFile".tmp3 bs=1M status=progress
							#cat "$currentAxelTmpFile".tmp3
							
							du -sh "$currentAxelTmpFile".tmp3 >> "$currentAxelTmpFile"
							
							#cat "$currentAxelTmpFile".tmp3 >> "$currentAxelTmpFile"
						fi
					else
						if [[ "$currentIteration" == "0" ]]
						then
							# ATTENTION: Staggered.
							#sleep 6 > /dev/null 2>&1
							true
						fi
					fi
					rm -f "$currentAxelTmpFile".tmp3 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp3.st > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp3.aria2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
					
					if [[ "${currentURL_array_reversed[$currentIterationNext2]}" != "" ]]
					then
						_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext2]}" -O "$currentAxelTmpFileRelative".tmp3 >&2
						#"$scriptAbsoluteLocation" 
						_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext2]}" -O "$currentAxelTmpFileRelative".tmp3 >&2 &
						currentPID_3="$!"
					fi
					
					
					
					if [[ -e "$currentAxelTmpFile".tmp4 ]]
					then
						# ATTENTION: Staggered.
						#sleep 10 > /dev/null 2>&1
						wait "$currentPID_4" >&2
						[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
						#wait >&2

						sleep 0.2 > /dev/null 2>&1
						if [[ -e "$currentAxelTmpFile".tmp4 ]]
						then
							_messagePlain_probe dd if="$currentAxelTmpFile".tmp4 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
							
							# ### dd if="$currentAxelTmpFile".tmp4 bs=5M status=progress >> "$currentAxelTmpFile"
							dd if="$currentAxelTmpFile".tmp4 bs=1M status=progress
							#cat "$currentAxelTmpFile".tmp4
							
							du -sh "$currentAxelTmpFile".tmp4 >> "$currentAxelTmpFile"
							
							#cat "$currentAxelTmpFile".tmp4 >> "$currentAxelTmpFile"
						fi
					else
						if [[ "$currentIteration" == "0" ]]
						then
							# ATTENTION: Staggered.
							#sleep 6 > /dev/null 2>&1
							true
						fi
					fi
					rm -f "$currentAxelTmpFile".tmp4 > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp4.st > /dev/null 2>&1
					rm -f "$currentAxelTmpFile".tmp4.aria2 > /dev/null 2>&1
					#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
					
					if [[ "${currentURL_array_reversed[$currentIterationNext3]}" != "" ]]
					then
						_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext3]}" -O "$currentAxelTmpFileRelative".tmp4 >&2
						#"$scriptAbsoluteLocation" 
						_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext3]}" -O "$currentAxelTmpFileRelative".tmp4 >&2 &
						currentPID_4="$!"
					fi
					
					

					# ATTENTION: NOT staggered.
					#wait "$currentPID_1" >&2
					#[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
					#wait "$currentPID_2" >&2
					#[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
					#wait "$currentPID_3" >&2
					#[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
					#wait "$currentPID_4" >&2
					#[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
					#wait >&2
					
					if [[ "$currentIteration" == "0" ]]
					then
						# CAUTION: Workaround for DUMMY , ONLY . Will NOT, by design, accept files that are both >1part and <4parts .
						#  This is to confidently reject failures to acquire part4 during the initial multiple connections.
						#sleep 7
						sleep 90
						if ( [[ ! -e "$currentAxelTmpFileRelative".tmp1 ]] || [[ ! -e "$currentAxelTmpFileRelative".tmp2 ]] || [[ ! -e "$currentAxelTmpFileRelative".tmp3 ]] || [[ ! -e "$currentAxelTmpFileRelative".tmp4 ]] ) && ! ( [[ -e "$currentAxelTmpFileRelative".tmp1 ]] && ( [[ ! -e "$currentAxelTmpFileRelative".tmp2 ]] || [[ ! -e "$currentAxelTmpFileRelative".tmp3 ]] || [[ ! -e "$currentAxelTmpFileRelative".tmp4 ]] ) )
						then
							_messageFAIL >&2
							_messageFAIL
							_stop 1
							return 1
						fi
						wait "$currentPID_1" >&2
						[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
						sleep 6 > /dev/null 2>&1
						[[ "$currentPID_2" == "" ]] && sleep 35 > /dev/null 2>&1
						[[ "$currentPID_2" != "" ]] && wait "$currentPID_2" >&2
						[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
						[[ "$currentPID_3" != "" ]] && wait "$currentPID_3" >&2
						[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
						[[ "$currentPID_4" != "" ]] && wait "$currentPID_4" >&2
						[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
						wait >&2
					fi

					wait "$currentPID_1" >&2
					[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
					sleep 0.2 > /dev/null 2>&1
					if [[ -e "$currentAxelTmpFile".tmp1 ]]
					then
						_messagePlain_probe dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
						
						if [[ ! -e "$currentAxelTmpFile" ]]
						then
							# ### mv -f "$currentAxelTmpFile".tmp1 "$currentAxelTmpFile"
							dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
							
							du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
						else
							# ATTENTION: Staggered.
							#dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress >> "$currentAxelTmpFile" &
						
							# ATTENTION: NOT staggered.
							# ### dd if="$currentAxelTmpFile".tmp1 bs=5M status=progress >> "$currentAxelTmpFile"
							dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
							#cat "$currentAxelTmpFile".tmp1
							
							du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
							
							#cat "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
						fi
					fi

					let currentIteration=currentIteration+4
					let currentIterationNext1=currentIteration+1
					let currentIterationNext2=currentIteration+2
					let currentIterationNext3=currentIteration+3
				done

				if ! [[ -e "$currentAxelTmpFile" ]]
				then
					true
					# ### return 1
				fi

				# ### cat "$currentAxelTmpFile"

				rm -f "$currentAxelTmpFile"
				rm -f "$currentAxelTmpFile".aria2
				rm -f "$currentAxelTmpFile".tmp
				rm -f "$currentAxelTmpFile".tmp.st
				rm -f "$currentAxelTmpFile".tmp.aria2
				rm -f "$currentAxelTmpFile".tmp1
				rm -f "$currentAxelTmpFile".tmp1.st
				rm -f "$currentAxelTmpFile".tmp1.aria2
				rm -f "$currentAxelTmpFile".tmp2
				rm -f "$currentAxelTmpFile".tmp2.st
				rm -f "$currentAxelTmpFile".tmp2.aria2
				rm -f "$currentAxelTmpFile".tmp3
				rm -f "$currentAxelTmpFile".tmp3.st
				rm -f "$currentAxelTmpFile".tmp3.aria2
				rm -f "$currentAxelTmpFile".tmp4
				rm -f "$currentAxelTmpFile".tmp4.st
				rm -f "$currentAxelTmpFile".tmp4.aria2
				
				rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				
				
				
			else
				#local currentAxelTmpFile
				#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
				export currentAxelTmpFileRelative=.m_axelTmp_$(_uid 14)
				export currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
				
				local currentPID_1
				
				local currentIteration
				currentIteration=0
				
				while [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]]
				do
					#_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O - >&2
					##"$scriptAbsoluteLocation"
					#_gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O - | dd bs=1M status=progress
					
					
					
					_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFile".tmp1 >&2
					#"$scriptAbsoluteLocation"
					_gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFile".tmp1 >&2 &
					currentPID_1="$!"
					
					sleep 6 > /dev/null 2>&1
					
					wait "$currentPID_1" >&2
					[[ "$currentPID_1" != "" ]] && wait "$currentPID_1" >&2
					[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
					wait >&2
					
					
					
					dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
					rm -f "$currentAxelTmpFile".tmp1
					
					
					let currentIteration=currentIteration+1
				done
				
				
				rm -f "$currentAxelTmpFile"
				rm -f "$currentAxelTmpFile".aria2
				rm -f "$currentAxelTmpFile".tmp1
				rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			fi
			
			
			
			
		else
			_messagePlain_probe curl -H '"Authorization: Bearer $GH_TOKEN"' -L "${currentURL_array_reversed[@]}" >&2
			curl -H "Authorization: Bearer $GH_TOKEN" -L "${currentURL_array_reversed[@]}"
		fi
		return
	fi


	cd "$functionEntryPWD"
}

_wget_githubRelease_join() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_messagePlain_probe _wget_githubRelease_join-stdout "$@" '>' "$3" >&2
	if [[ "$FORCE_AXEL" != "" ]]
	then
		_wget_githubRelease_join-stdout "$@" > "$3"
	else
		_wget_githubRelease_join-stdout "$@" > "$3"
	fi

	cd "$functionEntryPWD"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1

	cd "$functionEntryPWD"
	return 0
}


_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}




















_vector_wget_githubRelease-URL-gh() {
    local currentReleaseLabel="build"
    
    [[ $(
cat <<'CZXWXcRMTo8EmM8i4d' | _wget_githubRelease-URL-gh-awk "" "$currentReleaseLabel" ""
TITLE  TYPE    TAG NAME             PUBLISHED        
build  Latest  build-1002-1  about 1 days ago
build          build-1001-1  about 2 days ago
CZXWXcRMTo8EmM8i4d
) == "build-1002-1
build-1001-1" ]] || ( _messagePlain_bad 'fail: bad: _wget_githubRelease-URL-gh-awk' && _messageFAIL )

	return 0
}













