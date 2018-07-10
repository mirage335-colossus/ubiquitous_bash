_mustcarry() {
	grep "$1" "$2" > /dev/null 2>&1 && return 0
	
	echo "$1" >> "$2"
	return
}
