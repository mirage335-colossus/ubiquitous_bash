
_wget_githubRelease_internal-URL() {
	curl -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"internal\") | .assets[] | select(.name == \""$2"\") | .browser_download_url" | sort -n -r | head -n 1
}

_wget_githubRelease_internal() {
	local currentURL=$(_wget_githubRelease_internal-URL "$@")
	_messagePlain_probe curl -L -o "$2" "$currentURL"
	curl -L -o "$2" "$currentURL"
	[[ ! -e "$2" ]] && _messagePlain_bad 'missing: '"$1"' '"$2" && return 1
	return 0
}
