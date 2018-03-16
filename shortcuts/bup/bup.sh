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
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	tar -exclude ./.bup -cvf - . | bup split -n HEAD -vv
}

_bupRetrieve() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	bup join HEAD | tar -tf -
}
