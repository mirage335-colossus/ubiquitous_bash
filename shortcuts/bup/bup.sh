_test_bup() {
	! _wantDep bup && echo 'warn: no bup'
}

_bupNew() {
	export BUP_DIR="./.bup"
	
	[[ -e "$BUP_DIR" ]] && return 1
	bup init
}

_bupLog() {
	export BUP_DIR="./.bup"
	
	[[ ! -e "$BUP_DIR" ]] && return 1
	git --git-dir=./.bup log
}

_bupList() {
	export BUP_DIR="./.bup"
	
	if [[ "$1" == "" ]]
	then
		bup ls "HEAD"
		return
	fi
	[[ "$1" != "" ]] && bup ls "$@"
}

_bupStore() {
	export BUP_DIR="./.bup"
	
	if [[ "$1" == "" ]]
	then
		tar --exclude "$BUP_DIR" -cvf - . | bup split -n "HEAD" -vv
		return
	fi
	[[ "$1" != "" ]] && tar --exclude "$BUP_DIR" -cvf - . | bup split -n "$@" -vv
}

_bupRetrieve() {
	export BUP_DIR="./.bup"
	
	if [[ "$1" == "" ]]
	then
		bup join "HEAD" | tar -xf -
		return
	fi
	[[ "$1" != "" ]] && bup join "$@" | tar -xf -
}
