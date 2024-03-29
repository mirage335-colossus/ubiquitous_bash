

_octave_terse() {
	_safe_declare_uid
	
	if [[ "$1" != "" ]]
	then
		_safeEcho_newline "$@" | octave --quiet --silent --no-window-system --no-gui 2>/dev/null | _octave_filter-messages
		return
	fi
	
	octave --quiet --silent --no-window-system --no-gui 2>/dev/null | _octave_filter-messages
	return
}

_octave() {
	if [[ "$1" != "" ]]
	then
		_safe_declare_uid
		_octave_terse "$@"
		return
	fi
	
	_safe_declare_uid
	octave --quiet --silent --no-window-system --no-gui "$@"
	return
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _octave_pipe
_octave_pipe() {
	_safe_declare_uid
	
	_octave_terse "$@"
	#octave --quiet --silent --no-window-system --no-gui "$@" 2>/dev/null | _octave_filter-messages
}

# ATTENTION: EXAMPLE: _octave_script 'octave_script.m'
# echo 'solve(x == y * 2, y)' > octave_script.m
_octave_script() {
	local currentFile="$1"
	shift
	
	_safe_declare_uid
	
	cat "$currentFile" | _octave_terse "$@"
	
	#octave --quiet --silent --no-window-system --no-gui "$@" 2>/dev/null | _octave_filter-messages
}











_octave_filter-messages() {
	grep -v 'Symbolic pkg .*: Python communication link active, SymPy v' | grep -v '_____' | grep -v '^$' | sed 's/^ans = //' | sed 's/^(sym) //'
	#cat
}






# solve '( y  == x * 2, x)'

_octave_solve() {
	_safeEcho_newline solve"$@" | _octave_pipe
}
_octave_nsolve() {
	_safeEcho_newline nsolve"$@" | _octave_pipe
}

if type -p octave > /dev/null 2>&1
then
	_solve() {
		_octave_solve "$@"
	}
	solve() {
		_octave_solve "$@"
	}
	nsolve() {
		_octave_nsolve "$@"
	}

	# WARNING: Mostly intended as apparent MSW/Cygwin workaround. May cause incorrectly written equations with inappropriate non-numeric output to pass regression tests.
	_clc() {
		# https://www.cyberciti.biz/faq/linux-unix-bash-check-interactive-shell/
		if [ -z "$PS1" ]
		then
			_octave "$@" | tr -dc '0-9.'
			return
		fi
		
		_octave "$@"
	}
	clc() {
		_octave "$@"
	}
	c() {
		_octave "$@"
	}
	
	_num() {
		_clc "$@" | tr -dc '0-9.'
	}
fi






_test_devgnuoctave() {
	_wantGetDep octave
	_wantGetDep octave-cli
	
	
	_wantGetDep octave-config
	_wantGetDep mkoctfile
	



	###_wantGetDep 'x86_64-linux-gnu/liboctave.so'
	###_wantGetDep 'x86_64-linux-gnu/liboctinterp.so'
	
	
	###_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/OutputSBML.mex'
	###_wantGetDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/libsbml5/TranslateSBML.mex'
	
	_wantGetDep 'x86_64-linux-gnu/qt5/plugins/cantor/backends/cantor_octavebackend.so'
	


	
	#if ! _wantGetDep dh_octave_check
	#then
		#! _typeShare 'dh-octave/install-pkg.m' && _wantGetDep dh-octave/install-pkg.m
	#fi
	
	
	
	_tryExec '_test_devgnuoctave-extra'
	
	
	
	return 0
}
