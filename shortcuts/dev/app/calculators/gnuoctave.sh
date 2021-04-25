


_octave() {
	octave --quiet --silent --no-window-system --no-gui "$@" | _octave_filter-messages
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _octave_pipe
_octave_pipe() {
	octave --quiet --silent --no-window-system --no-gui "$@" | _octave_filter-messages
}

# ATTENTION: EXAMPLE: _octave_script 'qalculate.m'
# echo 'solve(x == y * 2, y)' > qalculate_script.m
_octave_script() {
	octave --quiet --silent --no-window-system --no-gui "$@" | _octave_filter-messages
}











_octave_filter-messages() {
	grep -v 'Symbolic pkg .*1: Python communication link active, SymPy v'
	#cat
}











_test_devgnuoctave() {
	_wantGetDep octave
	_wantGetDep octave-cli
	
	
	_wantGetDep octave-config
	_wantGetDep mkoctfile
	
	_wantGetDep 'x86_64-linux-gnu/liboctave.so'
	_wantGetDep 'x86_64-linux-gnu/liboctinterp.so'
	
	
	_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/OutputSBML.mex'
	_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/TranslateSBML.mex'
	
	_wantGetDep 'x86_64-linux-gnu/qt5/plugins/cantor/backends/cantor_octavebackend.so'
	
	
	#if ! _wantGetDep dh_octave_check
	#then
		#! _typeShare 'dh-octave/install-pkg.m' && _wantGetDep dh-octave/install-pkg.m
	#fi
	
	
	
	_tryExec '_test_devgnuoctave-debian-x64'
	
	
	
	return 0
}
