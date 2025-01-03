
# WARNING: Very conservative functions, for such extraordinary situations as directly streaming from a satellite connection to optical disc using an unreliable optical disc drive, equivalent to operating a laser cutter at sub-micron precision from space.
# NOTICE: EXAMPLE functions intended for reference only. Often appropriate to instead write a custom command with less conservative parameters.
# Usually these functions should be equally applicable to DVD and BD discs, preferably very high quality BD M-Discs. DVD-RAM may also be supported, but is not recommended. Magneto-Optical discs do not need such trickery. CD-ROM and other special legacy disc types will not be needed on any routine basis, not having any of particularly good capacity, durability, or longevity.


# WARNING: May be untested. Example.
# [[ "$1" == currentFile ]]
# [[ "$2" == currentSpeed ]] # (3 is safest)
# [[ "$3" == currentDrive ]]
_growisofs() {
	local currentFile
	currentFile="$1"
	[[ "$currentFile" == "" ]] && _messagePlain_warn 'warn: unspecified: currentFile... assuming urandom'
	#[[ "$currentFile" == "" ]] && _messageFAIL
	[[ "$currentFile" == "" ]] && currentFile=/dev/urandom
	
	local currentSpeed
	currentSpeed="$2"
	[[ "$currentSpeed" == "" ]] && currentSpeed=3
	
	local currentDrive
	currentDrive="$3"
	[[ "$currentDrive" == "" ]] && _messagePlain_bad 'fail: unspecified: currentDrive'
	[[ "$currentDrive" == "" ]] && _messageFAIL
	
	_messagePlain_request 'checksum commands: '
	local current_cksum_size
	current_cksum_size=$(wc -c "$currentFile" | cut -f1 -d\  | tr -dc '0-9')
	echo sudo -n dd if=\""$currentFile"\" bs=1M \| head --bytes=\""$current_cksum_size"\" \| env CMD_ENV=xpg4 cksum
	echo sudo -n dd if=\""$currentDrive"\" bs=1M \| head --bytes=\""$current_cksum_size"\" \| env CMD_ENV=xpg4 cksum
	
	_messagePlain_nominal '_growisofs: growisofs'
	
	# STRONGLY DISCOURAGED.
	# Hash or checksum during writing only verifies downloaded data, which is ONLY useful to diagnose whether the disc drive or download was the point of failure during real-time writing of download. Unlike Magneto-Optical discs, packet writing optical disc devices can suffer buffer underrun errors, necessitating hash of the disc itself anyway.
	# ONLY use case for hash/checksum of streamed data is real-time download, usually only desired either due to near identical download and disc writing speed, or due to creating the disc from a 'live' dist/OS with no persistent storage.
	#tee >(cksum >> /dev/stderr) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) )
	#tee >(openssl dgst -whirlpool -binary | xxd -p -c 256 >> "$scriptLocal"/hash-download.txt) ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) )
	
	# ATTENTION: Important command is just this. Writes data from cat "$currentFile" through pipe to /dev/stdin to "$currentDrive" at "$currentSpeed" . Fills remainder of disc with zeros.
	( cat "$currentFile" ; dd if=/dev/zero bs=2048 count=$(bc <<< '1000000000000 / 2048' ) ) | sudo -n growisofs -speed="$currentSpeed" -dvd-compat -Z "$currentDrive"=/dev/stdin -use-the-force-luke=notray -use-the-force-luke=spare:min -use-the-force-luke=bufsize:128m
}




