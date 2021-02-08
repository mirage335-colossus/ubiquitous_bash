_compile_bash_queue() {
	export includeScriptList
	
	#includeScriptList+=( "queue"/undefined.sh )
}

_compile_bash_vars_queue() {
	export includeScriptList
	
	#[[ "$enUb_queue" == "true" ]] && 
	#[[ "$enUb_packet" == "true" ]] && 
	#[[ "$enUb_portal" == "true" ]] && 
	
	includeScriptList+=( "queue"/queue_vars.sh )
	includeScriptList+=( "queue"/queue_vars_default.sh )
	
	includeScriptList+=( "queue"/queue.sh )
	
	
	
	includeScriptList+=( "queue/tripleBuffer"/page_read.sh )
	includeScriptList+=( "queue/tripleBuffer"/page_read_single.sh )
	
	includeScriptList+=( "queue/tripleBuffer"/page_write.sh )
	includeScriptList+=( "queue/tripleBuffer"/page_write_single.sh )
	
	
	includeScriptList+=( "queue/tripleBuffer"/broadcastPipe_page_here.sh )
	includeScriptList+=( "queue/tripleBuffer"/broadcastPipe_page.sh )
	
	includeScriptList+=( "queue/tripleBuffer"/demand_broadcastPipe_page.sh )
	
	
	#[[ "$enUb_queue" == "true" ]] && includeScriptList+=( "queue/tripleBuffer"/benchmark_page.sh )
	includeScriptList+=( "queue/tripleBuffer"/benchmark_page.sh )
	
	
	includeScriptList+=( "queue/tripleBuffer"/test_broadcastPipe_page.sh )
	includeScriptList+=( "queue/tripleBuffer"/benchmark_broadcastPipe_page.sh )
	
	
	
	includeScriptList+=( "queue/aggregator"/fifo_aggregator.sh )
	
	includeScriptList+=( "queue/aggregator"/aggregator_read.sh )
	includeScriptList+=( "queue/aggregator"/aggregator_write.sh )
	
	includeScriptList+=( "queue/aggregator/static"/broadcastPipe_aggregatorStatic.sh )
	includeScriptList+=( "queue/aggregator/static"/demand_broadcastPipe_aggregatorStatic.sh )
	
	includeScriptList+=( "queue/aggregator/static"/test_broadcastPipe_aggregatorStatic.sh )
	includeScriptList+=( "queue/aggregator/static"/benchmark_broadcastPipe_aggregatorStatic.sh )
	
}
