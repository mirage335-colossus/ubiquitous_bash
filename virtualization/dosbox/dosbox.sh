_prepare_dosbox() {
	mkdir "$scriptLocal"/_dosbox
	
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
	
	_virtUser "$@"
	
	if [[ "$sharedHostProjectDir" != "" ]]
	then
		echo -e -n 'mount x ' >> "$instancedVirtDir"/dosbox.conf
		echo "$sharedHostProjectDir" >> "$instancedVirtDir"/dosbox.conf
	fi
	
	dosbox -conf "$instancedVirtDir"/dosbox.conf -c "${processedArgs[@]}"
	
	_safeRMR "$instancedVirtDir" || _stop 1
	
	_stop
}

_dosbox() {
	"$scriptAbsoluteLocation" _dosbox "$@"
}
