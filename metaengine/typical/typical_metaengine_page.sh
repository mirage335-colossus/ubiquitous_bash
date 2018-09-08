# WARNING: Untested.
_me_page_read() {
	_buffer_me_processor_page_in_read "$@"
}

# WARNING: Untested.
_me_page_write() {
	_buffer_me_processor_page_out_write "$@"
}

_me_page_tick_read() {
	_buffer_me_processor_page_tick_default _me_page_read "$@"
}

_me_page_tick_write() {
	_buffer_me_processor_page_tick_default _me_page_write "$@"
}

# WARNING: High performance is not to be expected from bash implementation. C/OpenCL may be better suited.
_me_page_tick_advance() {
	_buffer_me_processor_page_tick_advance_default "$@"
}




_buffer_me_processor_page_tick() {
	local measureTickA
	local measureTickB
	local measureTickDifference
	
	measureTickA=$(cat "$bufferTick_file")
	
	while true
	do
		measureTickB=$(cat "$bufferTick_file")
		measureTickDifference=$(bc <<< "$measureTickB - $measureTickA")
		
		if [[ "$measureTickDifference" -ge "$bufferTick_count" ]]
		then
			"$@"
		fi
		
		sleep 0.005
	done
}

_buffer_me_processor_page_tick_default() {
	export bufferTick_file="$metaReg"/tick
	export bufferTick_count=1
	
	_buffer_me_processor_page_tick "$@"
	
	export bufferTick_file=
	export bufferTick_count=
}

_buffer_me_processor_page_tick_advance_default() {
	export bufferTick_file="$metaReg"/tick
	export bufferTick_count=1
	
	_buffer_me_processor_page_tick_advance "$@"
	
	export bufferTick_file=
	export bufferTick_count=
}

_buffer_me_processor_page_tick_advance() {
	! [[ -e "$bufferTick_file" ]] && _buffer_me_processor_page_tick_reset
	
	local bufferTick_current
	bufferTick_current=$(cat "$bufferTick_file"
	
	local bufferTick_next
	bufferTick_next=$(bc <<< "$bufferTick_current + 1")
	
	echo "$bufferTick_next" | _buffer_me_processor_page_tick_write
}

_buffer_me_processor_page_tick_reset() {
	echo 0 | _buffer_me_processor_page_tick_write
}

_buffer_me_processor_page_tick_write() {
	#! [[ -d "$metaReg" ]] && return 1
	
	cat > "$bufferTick_file".tmp
	mv "$bufferTick_file".tmp "$bufferTick_file"
	rm -f "$bufferTick_file".tmp > /dev/null 2>&1
}


"$metaReg"/tick

_buffer_me_processor_page_clock() {
	local measureDateA
	local measureDateB
	local measureDateDifference
	
	measureDateA=$(date +%s%N | cut -b1-13)
	
	while true
	do
		measureDateB=$(date +%s%N | cut -b1-13)
		measureDateDifference=$(bc <<< "$measureDateB - $measureDateA")
		
		if [[ "$measureDateDifference" -ge "$bufferClock_ms" ]]
		then
			"$@"
		fi
		
		[[ "$bufferClock_ms" -ge "3000" ]] && sleep 1
		[[ "$bufferClock_ms" -ge "300" ]] && sleep 0.1
		sleep 0.005
	done
}

_buffer_me_processor_page_clock_100fps() {
	export bufferClock_ms=10
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_90fps() {
	export bufferClock_ms=11
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_30fps() {
	export bufferClock_ms=33
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fps() {
	export bufferClock_ms=1000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fpm() {
	export bufferClock_ms=60000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}

_buffer_me_processor_page_clock_1fph() {
	export bufferClock_ms=360000
	_buffer_me_processor_page_clock "$@"
	export bufferClock_ms=
}




_buffer_me_processor_page_in_read() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointerRead
	
	bufferPointerRead=$(_buffer_me_processor_page_pointer_in_get_current)
	
	! [[ -e "$metaDir"/ai/"$bufferPointerRead" ]] && return 1
	
	cat "$metaDir"/ai/"$bufferPointerRead"
}


_buffer_me_processor_page_pointer_in_get_current() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	cat "$metaDir"/bi/pointer
}

_buffer_me_processor_page_pointer_out_get_previous() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bi/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 0 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 1 && return 0
}

_buffer_me_processor_page_pointer_out_get_next() {
	! [[ -e "$metaDir"/bi/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bi/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 1 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 0 && return 0
}





_buffer_me_processor_page_out_write() {
	_buffer_me_processor_page_pointer_out_advance
	
	local bufferPointerWrite
	bufferPointerNext=$(_buffer_me_processor_page_pointer_out_get_next)
	
	cat > "$metaDir"/ao/quicktmp_page"$bufferPointerWrite"
	mv "$metaDir"/ao/quicktmp_page"$bufferPointerWrite" "$metaDir"/ao/"$bufferPointerWrite"
	rm -f "$metaDir"/ao/quicktmp_page"$bufferPointerWrite" > /dev/null 2>&1
}

_buffer_me_processor_page_pointer_out_advance() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	! [[ -e "$metaDir"/bo/pointer ]] && _buffer_me_processor_page_pointer_out_reset
	
	local bufferPointerNext
	bufferPointerNext=$(_buffer_me_processor_page_pointer_out_get_next)
	
	echo "$bufferPointerNext" | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_get_current() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	cat "$metaDir"/bo/pointer
}

_buffer_me_processor_page_pointer_out_get_previous() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bo/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 0 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 1 && return 0
}

_buffer_me_processor_page_pointer_out_get_next() {
	! [[ -e "$metaDir"/bo/pointer ]] && return 1
	
	local bufferPointer
	
	bufferPointer=$(cat "$metaDir"/bo/pointer)
	
	[[ "$bufferPointer" == "0" ]] && echo 1 && return 0
	[[ "$bufferPointer" == "1" ]] && echo 2 && return 0
	[[ "$bufferPointer" == "2" ]] && echo 0 && return 0
}

#No production use.
_buffer_me_processor_page_reset() {
	_buffer_me_processor_page_pointer_reset
	
	rm -f "$metaDir"/ao/0 > /dev/null 2>&1
	rm -f "$metaDir"/ao/1 > /dev/null 2>&1
	rm -f "$metaDir"/ao/2 > /dev/null 2>&1
}

_buffer_me_processor_page_pointer_out_reset() {
	_buffer_me_processor_page_pointer_out_0
}

_buffer_me_processor_page_pointer_out_0() {
	echo 0 | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_1() {
	echo 1 | _buffer_me_processor_page_pointer_out_write
}

_buffer_me_processor_page_pointer_out_2() {
	echo 2 | _buffer_me_processor_page_pointer_out_write
}


_buffer_me_processor_page_pointer_out_write() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	cat > "$metaDir"/bo/quicktmp_pointer
	mv "$metaDir"/bo/quicktmp_pointer "$metaDir"/bo/pointer
	rm -f "$metaDir"/bo/quicktmp_pointer > /dev/null 2>&1
}


