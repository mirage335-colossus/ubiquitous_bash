_me_fifo() {
	_buffer_me_processor_fifo
}

_me_snippet_reset() {
	_buffer_me_processor_snippet_reset
}

_me_snippet_write() {
	_buffer_me_processor_snippet_write
}

_me_snippet_read() {
	_buffer_me_processor_snippet_read
}

_me_snippet_read_wait() {
	_buffer_me_processor_snippet_read_wait
}

_me_confidence_full() {
	_buffer_me_processor_confidence_full
}

_me_confidence_none() {
	_buffer_me_processor_confidence_none
}

_buffer_me_processor_fifo() {
	_buffer_me_processor_fifo_rm
	
	#[[ -d "$metaDir"/ai ]] && mkfifo "$metaDir"/ai/fifo
	#[[ -d "$metaDir"/bi ]] && mkfifo "$metaDir"/bi/fifo
	
	[[ -d "$metaDir"/ao ]] && mkfifo "$metaDir"/ao/fifo
	#[[ -d "$metaDir"/bo ]] && mkfifo "$metaDir"/bo/fifo
}

_buffer_me_processor_fifo_rm() {
	rm -f "$metaDir"/ao/fifo > /dev/null 2>&1
	#rm -f "$metaDir"/bo/fifo > /dev/null 2>&1
}

_buffer_me_processor_snippet_reset() {
	echo | _buffer_me_processor_snippet_assign
}

_buffer_me_processor_snippet_write() {
	! [[ -d "$metaDir"/ao ]] && return 1
	
	cat > "$metaDir"/ao/quicktmp_snippet
	mv -n "$metaDir"/ao/quicktmp_snippet "$metaDir"/ao/snippet
	rm -f "$metaDir"/ao/quicktmp_snippet > /dev/null 2>&1
}

_buffer_me_processor_snippet_check_binary() {
	! [[ -e "$metaDir"/bi/confidence ]] && return 1
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	local snippetConfidence
	snippetConfidence=$(cat "$metaDir"/bi/confidence)
	
	#cat "$metaDir"/bi/confidence
	
	[[ "$snippetConfidence" == "1" ]] && return 0
	return 1
}

_buffer_me_processor_snippet_check() {
	! [[ -e "$metaDir"/bi/confidence ]] && return 1
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	local snippetConfidence
	snippetConfidence=$(cat "$metaDir"/bi/confidence)
	
	cat "$metaDir"/bi/confidence
	
	[[ "$snippetConfidence" == "1" ]] && return 0
	return 1
}

_buffer_me_processor_snippet_read() {
	! [[ -d "$metaDir"/ai ]] && return 1
	! [[ -d "$metaDir"/bi ]] && return 1
	
	! [[ -e "$metaDir"/ai/snippet ]] && return 1
	
	cat "$metaDir"/ai/snippet
}

_buffer_me_processor_snippet_read_wait() {
	! [[ -d "$metaDir"/ai ]] && return 1
	! [[ -d "$metaDir"/bi ]] && return 1
	
	while ! _buffer_me_processor_snippet_check_binary
	do
		sleep 0.3
	done
	
	cat "$metaDir"/ai/snippet
}

_buffer_me_processor_confidence_reset() {
	_buffer_me_processor_confidence_none
}

_buffer_me_processor_confidence_none() {
	echo 0 | _buffer_me_processor_confidence_write
}

#Typically signals snippet processor task complete.
_buffer_me_processor_confidence_full() {
	echo 1 | _buffer_me_processor_confidence_write
}

_buffer_me_processor_confidence_write() {
	! [[ -d "$metaDir"/bo ]] && return 1
	
	cat > "$metaDir"/bo/quicktmp_confidence
	mv "$metaDir"/bo/quicktmp_confidence "$metaDir"/bo/confidence
	rm -f "$metaDir"/bo/quicktmp_confidence > /dev/null 2>&1
}
