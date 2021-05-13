



# Interactive.
_qalculate() {
	qalc "$@"
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _qalculate_pipe
_qalculate_pipe() {
	qalc "$@"
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
_solve() {
	_qalculate_solve "$@"
}
solve() {
	_qalculate_solve() "$@"
}
nsolve() {
	_safeEcho_newline solve"$@" | _qalculate_pipe
}






_test_devqalculate() {
	_wantGetDep qalculate-gtk
	_wantGetDep qalculate
	
	! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && _wantGetDep gnuplot-data
	! _typeShare 'texmf/tex/latex/gnuplot/gnuplot.cfg' && echo 'warn: missing: gnuplot-data'
	
	#_wantGetDep gnuplot-data
	#_wantGetDep gnuplot-x11
	_wantGetDep gnuplot-qt
	
	_wantGetDep gnuplot
	
	! _typeDep qalculate-gtk && echo 'warn: missing: qalculate-gtk'
	
	return 0
}


