# WARNING: In practice, at least some of 'queue' may be considered 'lean' functionality, to be included regardless of whether '_deps_queue' has been called through 'compile.sh' .
_deps_queue() {
	#_deps_notLean
	#_deps_dev
	
	# Message queue - 'broadcastPipe' , etc , underlying functions , '_read_page' , etc .
	export enUb_queue="true"
	
	# Packet - any noise-tolerant 'format' .
	# RESERVED variable name - synonymous with 'enUb_queue' .
	#export enUb_packet="true"
	
	# Portal - a 'filter program' to make arrangements between embedded devices of various unique identities and/or devices (eg. 'xAxis400stepsMM' . )
	# RESERVED variable name - synonymous with 'enUb_queue' .
	#export enUb_portal="true"
}
