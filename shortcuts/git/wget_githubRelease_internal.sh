
_wget_githubRelease-URL() {
	local currentURL
	if [[ "$2" != "" ]]
	then
		if [[ "$GH_TOKEN" == "" ]]
		then
			currentURL=$(curl -6 -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		else
			currentURL=$(curl -6 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		fi
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			currentURL=$(curl -6 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		else
			currentURL=$(curl -6 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		fi
	fi
}

_wget_githubRelease() {
	local currentURL=$(_wget_githubRelease_internal-URL "$@")
	_messagePlain_probe curl -L -o "$3" "$currentURL" >&2
	curl -L -o "$3" "$currentURL"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
	return 0
}

_wget_githubRelease-stdout() {
	local currentURL=$(_wget_githubRelease_internal-URL "$@")
	_messagePlain_probe curl -L -o - "$currentURL" >&2
	curl -L -o - "$currentURL"
}


_wget_githubRelease_join-stdout() {
	local currentURL
	local currentURL_array
	local currentIteration

	currentIteration=0
	for currentIteration in $(seq -f "%02g" 0 32)
	do
		currentURL=$(_wget_githubRelease-URL "$1" "$2" "$3"".part""$currentIteration")
		[[ "$currentURL" == "" ]] && break
		[[ "$currentURL" != "" ]] && currentURL_array+=( "$currentURL" )
	done
	
	_messagePlain_probe curl -L "${currentURL_array[@]}" >&2

	curl -L "${currentURL_array[@]}"
}

_wget_githubRelease_join() {
	_messagePlain_probe _wget_githubRelease_join-stdout "$@" '>' "$3" >&2
	_wget_githubRelease_join-stdout "$@" > "$3"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
	return 0
}


_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}

_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}




