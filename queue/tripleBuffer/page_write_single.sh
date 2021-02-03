# "$1" == outputBufferDir
# "$2" == outputFilesPrefix
# "$3" == maxTime (approximately how many milliseconds new data should be allowed to 'remain' in the buffer before writing out a new tick)
# DANGER: Any changes may unexpectedly break '_broadcastPipe' ! Takes standard input from 'script' run by 'find' 'exec' .
_page_write_single() {
	local currentTmpUID
	currentTmpUID=$(_uid)
	cat 2>/dev/null >> "$1"/t_"$currentTmpUID"
	
	if ! [[ -s "$1"/t_"$currentTmpUID" ]] || ! mv -n "$1"/t_"$currentTmpUID" "$1"/temp 2>/dev/null
	then
		rm -f "$1"/t_"$currentTmpUID" > /dev/null 2>&1
		return 1
	fi
	
	local currentTick
	currentTick=
	[[ -e "$1"/"$2"tick ]] && currentTick=$(head -c 1 "$1"/"$2"tick)
	( [[ "$currentTick" == '0' ]] || [[ "$currentTick" == '1' ]] || [[ "$currentTick" == '2' ]] ) && let currentTick="$currentTick"+1
	[[ "$currentTick" != '0' ]] && [[ "$currentTick" != '1' ]] && [[ "$currentTick" != '2' ]] && [[ "$currentTick" != '3' ]] && currentTick='0'
	[[ "$currentTick" -ge '3' ]] && currentTick=0
	
	mv "$1"/temp "$1"/"$2""$currentTick"
	echo -n "$currentTick" > "$1"/"$2"tick-temp
	mv "$1"/"$2"tick-temp "$1"/"$2"tick
	
	
	#rm -f "$1"/temp > /dev/null 2>&1
	#rm -f "$1"/"$2"tick-temp > /dev/null 2>&1
	return 0
}
