#####Entry

#Traps
trap 'excode=$?; _stop $excode; trap - EXIT; echo $excode' EXIT HUP INT QUIT PIPE TERM		# reset
trap 'excode=$?; trap "" EXIT; _stop $excode; echo $excode' EXIT HUP INT QUIT PIPE TERM		# ignore 


#"$scriptAbsoluteLocation" _setup


_main "$@"

