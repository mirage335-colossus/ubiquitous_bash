_test_channel_fifo() {
	_getDep mkfifo
	
	#if ! dd if=$("$scriptAbsoluteLocation" _channel_host_fifo cat /dev/zero) of=/dev/null bs=1M count=10 iflag=fullblock > /dev/null 2>&1
	if ! dd if=$("$scriptAbsoluteLocation" _channel_host_fifo cat /dev/zero) of=/dev/null bs=10000000 count=10 > /dev/null 2>&1
	then
		echo 'fail: channel: fifo'
		_stop 1
	fi
}

_test_channel() {
	_tryExec "_test_channel_fifo"
}

_set_channel() {
	export channelTmp="$scriptAbsoluteFolder""$tmpPrefix"/.c_"$sessionid"
}

_prepare_channel() {
	mkdir -p "$channelTmp"
}

_stop_channel_allow() {
	export channelStop="true"
}
_stop_channel_prohibit() {
	export channelStop="false"
}

_rm_instance_channel() {
	[[ "$channelStop" != "true" ]] && return 0
	export channelStop="false"
	
	if [[ "$channelTmp" != "" ]] && [[ "$channelTmp" == *"$sessionid"* ]] && [[ -e "$channelTmp" ]]
	then
		_safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 0.1 && _safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 0.3 && _safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 1 && _safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 3 && _safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 3 && _safeRMR "$channelTmp"
		[[ -e "$channelTmp" ]] && sleep 3 && _safeRMR "$channelTmp"
	fi
}

_channel_fifo_example() {
	cat /dev/urandom | base64
}

_channel_fifo_sequence() {
	_stop_channel_allow
	
	"$@" 2>/dev/null > "$commandFIFO"
	
	_rm_instance_channel
}

_channel_host_fifo_sequence() {
	_stop_channel_prohibit
	_set_channel
	_prepare_channel
	
	export commandFIFO="$channelTmp"/cmdfifo
	mkfifo "$commandFIFO"
	
	echo "$commandFIFO"
	
	
	#nohup "$scriptAbsoluteLocation" --embed _channel_fifo_sequence "$@" >/dev/null 2>&1 &
	"$scriptAbsoluteLocation" --embed _channel_fifo_sequence "$@" >/dev/null 2>&1 &
	#disown -h $!
	disown -a -h -r
	disown -a -r
}

# example: dd if=$(./ubiquitous_bash.sh _channel_host_fifo _channel_fifo_example) of=/dev/null
# example: dd if=$(./ubiquitous_bash.sh _channel_host_fifo cat /dev/zero) of=/dev/null bs=1M count=10000 iflag=fullblock
_channel_host_fifo() {
	"$scriptAbsoluteLocation" _channel_host_fifo_sequence "$@"
}

