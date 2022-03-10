



_qalculate_terse() {
	# https://stackoverflow.com/questions/17998978/removing-colors-from-output
	#sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	
	# https://stackoverflow.com/questions/4233159/grep-regex-whitespace-behavior
	#grep -v '^\s*$'
	
	if [[ "$1" != "" ]]
	then
		_safeEcho_newline "$@" | qalc -t | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
		return
	fi
	
	qalc -t "$@" | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	return
}

# Interactive.
_qalculate() {
	if [[ "$1" != "" ]]
	then
		_qalculate_terse "$@"
		return
	fi
	
	qalc "$@"
	return
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _qalculate_pipe
_qalculate_pipe() {
	_qalculate_terse "$@"
}

# ATTENTION: _qalculate_script 'qalculate_script.m'
# echo 'solve(x == y * 2, y)' > qalculate_script.m
_qalculate_script() {
	local currentFile="$1"
	shift
	
	cat "$currentFile" | _qalculate_pipe "$@"
}










_qalculate_solve() {
	_safeEcho_newline solve"$@" | _qalculate_pipe
}
_qalculate_nsolve() {
	_safeEcho_newline solve"$@" | _qalculate_pipe
}

if type -p qalc > /dev/null 2>&1
then
	_solve() {
		_qalculate_solve "$@"
	}
	solve() {
		_qalculate_solve "$@"
	}
	nsolve() {
		_qalculate_solve "$@"
	}

	_clc() {
		_qalculate "$@"
	}
	clc() {
		_qalculate "$@"
	}
	c() {
		_qalculate "$@"
	}
fi




_test_devqalculate() {
	_wantGetDep qalculate-gtk
	#_wantGetDep qalculate
	
	_wantGetDep qalc
	
	if ! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && ! _typeShare 'texmf/tex/gnuplot.cfg'
	then
		! _wantGetDep 'texmf/tex/latex/gnuplot/gnuplot.cfg' && ! _wantGetDep 'texmf/tex/gnuplot.cfg' && ! _wantGetDep gnuplot-data
	fi
	
	
	! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && ! _typeShare 'texmf/tex/gnuplot.cfg' && echo 'warn: missing: gnuplot-data'
	
	#_wantGetDep gnuplot-data
	#_wantGetDep gnuplot-x11
	_wantGetDep gnuplot-qt
	
	_wantGetDep gnuplot
	
	! _typeDep qalculate-gtk && echo 'warn: missing: qalculate-gtk'
	
	return 0
}


