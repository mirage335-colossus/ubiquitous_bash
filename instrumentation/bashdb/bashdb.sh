_test_bashdb() {
	_getDep ddd
	
	#if ! _discoverResource bashdb-code/bashdb.sh > /dev/null 2>&1
	#then
	#	echo
	#	echo 'bashdb required for debugging'
		#_stop 1
	#fi
	
	if ! type bashdb > /dev/null 2>&1
	then
		echo
		echo 'bashdb required for debugging'
	#_stop 1
	fi
}

