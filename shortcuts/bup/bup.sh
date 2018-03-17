_test_bup() {
	! _wantDep bup && echo 'warn: no bup'
}

_bupNew() {
	export BUP_DIR="./.bup"
	
	[[ -e "$BUP_DIR" ]] && return 1
	bup init
}

_bupList() {
	export BUP_DIR="./.bup"
	bup ls HEAD
}

_bupStore() {
	export BUP_DIR="./.bup"
	
	export BUP_DESTINATION="HEAD"
	[[ "$1" != "" ]] && export BUP_DESTINATION="$1"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	tar --exclude "$BUP_DIR" -cvf - . | bup split -n "$BUP_DESTINATION" -vv
}

_bupRetrieve() {
	export BUP_DIR="./.bup"
	
	export BUP_SOURCE="HEAD"
	[[ "$1" != "" ]] && export BUP_SOURCE="$1"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	bup join "$BUP_SOURCE" | tar -xf -
}
