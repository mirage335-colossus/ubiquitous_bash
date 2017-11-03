_test_dosbox() {
	_checkDep dosbox
}

_prepare_dosbox() {
	mkdir -p "$scriptLocal"/_dosbox
	
	mkdir -p "$instancedVirtDir"
	mkdir -p "$instancedVirtFS"
	mkdir -p "$instancedVirtTmp"
	
	_here_dosbox_base_conf > "$instancedVirtDir"/dosbox.conf
	
}

_dosbox_sequence() {
	_start
	
	_prepare_dosbox
	
	echo -e -n 'mount c ' >> "$instancedVirtDir"/dosbox.conf
	echo "$scriptLocal"/_dosbox >> "$instancedVirtDir"/dosbox.conf
	echo 'c:' >> "$instancedVirtDir"/dosbox.conf
	
	export sharedGuestProjectDir='X:'
	_virtUser "$@"
	
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		echo -e -n 'mount x ' >> "$instancedVirtDir"/dosbox.conf
		echo "$sharedHostProjectDir" >> "$instancedVirtDir"/dosbox.conf
		echo 'x:' >> "$instancedVirtDir"/dosbox.conf
	fi
	
	#Alternatively, "-c" could be used with dosbox, but this seems not to work well with multiple parameters.
	#Note "DOS" will not like paths not conforming to 8.3 .
	echo "${processedArgs[@]}" >> "$instancedVirtDir"/dosbox.conf
	
	dosbox -conf "$instancedVirtDir"/dosbox.conf
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_dosbox() {
	"$scriptAbsoluteLocation" _dosbox_sequence "$@"
}
