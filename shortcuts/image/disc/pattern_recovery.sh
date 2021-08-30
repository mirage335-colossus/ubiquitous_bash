



# Intended to number sectors at regular intervals in unpartitioned space, especially to simplify realignment of corrupted partitioned optical disc.
# Do NOT write to filesystems.
# Prefer 1/2^5MiB (0.03125MiB) (2^15byte) (32768byte) intervals .
#  Good compressibility, one number per 16 2048b sectors, one number per 64 512b sectors, at least one number per 34816b=17*2048b track, thirty-two numbers per MiB .
#_pattern_recovery_write /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_write() {
	local currentBlockSize
	currentBlockSize="$3"
	[[ "$currentBlockSize" == "" ]] && currentBlockSize=32768
	
	local currentSequenceFillBytes
	let currentSequenceFillBytes=currentBlockSize-16
	
	local currentTotal
	currentTotal="$2"
	[[ "$currentTotal" == "" ]] && currentTotal=1000000000001111
	
	seq --separator="$(local currentIteration; while [[ "$currentIteration" -lt "$currentSequenceFillBytes" ]]; do echo -n 20 ; let currentIteration=currentIteration+1; done | xxd -r -p)" --equal-width 0 1 1000000000001111 | tr -d '\n' | dd of="$1" count="$currentTotal" bs=1M iflag=fullblock oflag=direct conv=fdatasync status=progress
	sudo -n dd if="$1" bs="$currentBlockSize" skip=0 count=1 2>/dev/null | head --bytes=16
	echo
	sudo -n dd if="$1" bs="$currentBlockSize" skip=1 count=1 2>/dev/null | head --bytes=16
	echo
	echo
	
	_pattern_recovery_last "$1" "$2" "$3"
}
#_pattern_recovery_skip /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0 18000
_pattern_recovery_skip() {
	local currentBlockSize
	currentBlockSize="$3"
	[[ "$currentBlockSize" == "" ]] && currentBlockSize=32768
	
	sudo -n dd if="$1" bs="$currentBlockSize" skip="$2" count=1 2>/dev/null | head --bytes=16
	echo
}
#_pattern_recovery_last /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_last() {
	local currentBlockSize
	currentBlockSize="$3"
	[[ "$currentBlockSize" == "" ]] && currentBlockSize=32768
	
	local currentLastByte
	currentLastByte=$(! sudo -n blockdev --getsize64 "$1" 2>/dev/null)
	[[ "$currentLastByte" == "" ]] && return 0
	
	local currentLastBlock
	
	
	currentLastBlock=$(bc <<< "$currentLastByte / $currentBlockSize")
	echo "$currentLastBlock"'= '
	sudo -n dd if="$1" bs="$currentBlockSize" skip="$currentLastBlock" count=1 2>/dev/null | head --bytes=16
	echo
	echo 'wc -c $(... '"$currentLastBlock"')= '$(sudo -n dd if="$1" bs="$currentBlockSize" skip="$currentLastBlock" count=1 2>/dev/null | wc -c)
	echo
	
	currentLastBlock=$(bc <<< "$currentLastByte / $currentBlockSize - 1")
	echo "$currentLastBlock"'= '
	sudo -n dd if="$1" bs="$currentBlockSize" skip="$currentLastBlock" count=1 2>/dev/null | head --bytes=16
	echo
	echo 'wc -c $(... '"$currentLastBlock"')= '$(sudo -n dd if="$1" bs="$currentBlockSize" skip="$currentLastBlock" count=1 2>/dev/null | wc -c)
	echo
}


#_pattern_recovery_write-32768 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_write-32768() {
	_pattern_recovery_write "$1" "$2" 32768
}
#_pattern_recovery_skip-32768 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0 18000
_pattern_recovery_skip-32768() {
	_pattern_recovery_skip "$1" "$2" 32768
}
#_pattern_recovery_last-32768 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_last-32768() {
	_pattern_recovery_last "$1" "$2" 32768
}


# CAUTION: Strongly discouraged!
#_pattern_recovery_write-65536 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_write-65536() {
	_pattern_recovery_write "$1" "$2" 65536
}
#_pattern_recovery_skip-65536 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0 9000
_pattern_recovery_skip-65536() {
	_pattern_recovery_skip "$1" "$2" 65536
}
#_pattern_recovery_last-65536 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
_pattern_recovery_last-65536() {
	_pattern_recovery_last "$1" "$2" 65536
}









# CAUTION: Strongly discouraged!
# No production use.
# While this works, it may not be very efficient, possibly due to the apparent 'entire track' writing behavior of at least some optical discs - with 65536 being close to the size of a track this will rewrite much of the entire disc. Usually it is desirable to fill the disc completely anyway for compressibility.
#_pattern_recovery_write_sparse_65536 /dev/disk/by-id/usb-FUJITSU_MC?3?30??-?_????????????-0\:0
# _pattern_recovery_write_sparse_65536() {
# 	local currentNumber
# 	local currentLimit
# 	local currentBlockPosition
# 	currentLimit=1000000000001111
# 	#currentLimit=0000000000000100
# 	seq --equal-width 0 1 "$currentLimit" | while read -r currentNumber
# 	do
# 		currentBlockPosition="$currentNumber" #65536
# 		currentBlockPosition=$(bc <<< "$currentNumber * 4096") #bs=16
# 		if ! echo -n "$currentNumber" | sudo -n dd of="$1" bs=16 seek="$currentBlockPosition" 2>/dev/null
# 		then
# 			break
# 		fi
# 		[[ $(bc <<< "$currentNumber % 50") == 0 ]] && echo "$currentNumber" 2>&1
# 	done
# 	echo
# 	sudo -n dd if="$1" bs=65536 skip=0 count=1 2>/dev/null | head --bytes=16
# 	echo
# 	sudo -n dd if="$1" bs=65536 skip=1 count=1 2>/dev/null | head --bytes=16
# 	echo
# }



# WARNING: Must equal 65536 .
#seq --separator="$(for n in {1..65520}; do echo -n 20 ; done | xxd -r -p)" --equal-width 0 1 0000000000000001 | tr -d '\n' | head --bytes="-16" | wc -c



