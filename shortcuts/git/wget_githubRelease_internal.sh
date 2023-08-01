
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
		fi
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			currentURL=$(curl -6 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
		else
			currentURL=$(curl -6 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
		fi
	fi
}

_wget_githubRelease() {
	local currentURL=$(_wget_githubRelease_internal-URL "$@")
	_messagePlain_probe curl -L -o "$3" "$currentURL"
	curl -L -o "$3" "$currentURL"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
	return 0
}


_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}

_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}




