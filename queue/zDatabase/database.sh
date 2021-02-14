
# Create Read Update Delete
# "$scriptLocal"/ops-ubdb.sh


_ubdb_get() {
	true
	# TODO: Iterate through "$@" array. Use env/declare/etc to output the usual 'name=value' .
}

_ubdb_enumerate() {
	true
	# TODO: 'env' or 'declare' stuff, etc
}



_ubdb_set() {
	true
	# TODO: Read in a list of variables. Call 'enumerate' (or similar) to write to a temporary (unique name) file. Move file when possible (up to a few seconds of waiting).
		# If collision, retry, maybe recursively. Re-read both input variable list and current variable list.
	
	# Create - Any variable set in the input list will be enumerated and written out.
	
	# Read - Other function.
	
	# Update - New list is read in after old list. Only the new values will be enumerated.
	
	# Delete - Any variable set blank is simply removed. May be able to do this with 'grep -v' .
	
}


_ubdb_rm() {
	true
	
	# TODO: Delete database file.
}





