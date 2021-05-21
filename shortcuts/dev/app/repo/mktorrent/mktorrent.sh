
#"$1" == src (file/dir)
#"$2" == dst (torrentName).torrent
#"$3" == CSV Tracker URL List (full announce URL list comma delimited) (' <url>[,<url>]* ')
#"$4" == CSV Web Seed URL List
# ./ubiquitous_bash.sh _mktorrent ./ubiquitous_bash.sh torrentName 'https://example.com/tracker,https://example1.com/tracker' 'https://example.com/ubiquitous_bash.sh,https://example1.com/ubiquitous_bash.sh'
_mktorrent_webseed() {
	if [[ "$1" == "" ]]
	then
		_messagePlain_request '"$1" == src (file/dir)'
		_messagePlain_request '"$2" == dst (torrentName).torrent'
		_messagePlain_request '"$3" == CSV Tracker URL List (full announce URL list comma delimited) ('\'' <url>[,<url>]* '\'')'
		_messagePlain_request '"$4" == CSV Web Seed URL List'
		return 1
	fi
	
	local currentSrc
	currentSrc="$1"
	local currentDst
	currentDst="$2"
	local currentTrackerCSV
	currentTrackerCSV="$3"
	local currentWebSeedCSV
	currentWebSeedCSV="$4"
	shift ; shift ; shift ; shift
	
	mktorrent -w "$currentWebSeedCSV" -a "$currentTrackerCSV" -d "$currentSrc" -n "$currentDst" "$@"
}
_mktorrent() {
	_mktorrent_webseed "$@"
}







_test_mktorrent() {
	# If not Debian, then simply accept these pacakges may not be available.
	[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	_wantGetDep mktorrent
	
	#_getDep mktorrent
}





