# ATTENTION: EXAMPLE

#_demand_broadcastPipe_page ./zzzInputBufferDir ./zzzOutputBufferDir '100'
#_terminate_broadcastPipe_page ./zzzInputBufferDir


# UNIX/MSW(/Cygwin) Compatible. Demand for service may be placed once or repeatedly on either UNIX/MSW host/guest across network drive.
#./lean.sh _demand_broadcastPipe_page ./zzzInputBufferDir ./zzzOutputBufferDir '100'
#./lean.sh _page_read ./zzzOutputBufferDir 'out-'
#echo "$RANDOM" | ./lean.sh _page_write_single ./zzzInputBufferDir/ 'diag-'









