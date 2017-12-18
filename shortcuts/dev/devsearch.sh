#https://stackoverflow.com/questions/15432156/display-filename-before-matching-line-grep
_grepFileLine() {
	grep -n "$@" /dev/null
}

_findFunction() {
	# -name '*.sh'
	find . -type f -size -10000k -exec grep -n "$@" {} /dev/null \;
}
