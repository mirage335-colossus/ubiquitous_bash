



_qalculate_terse() {
	_safe_declare_uid
	
	# https://stackoverflow.com/questions/17998978/removing-colors-from-output
	#sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	
	# https://stackoverflow.com/questions/4233159/grep-regex-whitespace-behavior
	#grep -v '^\s*$'
	
	if [[ "$1" != "" ]]
	then
		#_safeEcho_newline "$@" | qalc -t | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
		
		# Preferred for Cygwin .
		_safeEcho_newline "$@" | qalc -t | grep -v '^> ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
		return
	fi
	
	#qalc -t "$@" | grep -v '^>\ ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	
	# Preferred for Cygwin .
	qalc -t "$@" | grep -v '^> ' | grep -v '^$' | sed 's/^  //' | grep -v '^\s*$' | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
	return
}

# Interactive.
_qalculate() {
	_safe_declare_uid
	
	mkdir -p "$HOME"/.config/qalculate
	
	if [[ "$1" != "" ]]
	then
		_safe_declare_uid
		_qalculate_terse "$@"
		return
	fi
	
	_safe_declare_uid
	qalc "$@"
	return
}

# ATTENTION: EXAMPLE: echo 'solve(x == y * 2, y)' | _qalculate_pipe
_qalculate_pipe() {
	_safe_declare_uid
	
	_qalculate_terse "$@"
}

# ATTENTION: _qalculate_script 'qalculate_script.m'
# echo 'solve(x == y * 2, y)' > qalculate_script.m
_qalculate_script() {
	local currentFile="$1"
	shift
	
	_safe_declare_uid
	
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

	# WARNING: Mostly intended as apparent MSW/Cygwin workaround. May cause incorrectly written equations with inappropriate non-numeric output to pass regression tests (ie. same wrong output may still be wrong output).
	_clc() {
		# https://www.cyberciti.biz/faq/linux-unix-bash-check-interactive-shell/
		if [ -z "$PS1" ]
		then
			_qalculate "$@" | tr -dc 'E0-9.\n'
			return
		fi
		
		_qalculate "$@"
	}
	clc() {
		_qalculate "$@"
	}
	c() {
		_qalculate "$@"
	}
	
	_num() {
		_clc "$@" | tr -dc 'E0-9.\n'
	}
fi




_test_devqalculate() {
	# Debian Bullseye (stable) apparently does not include 'qualculate-gtk'.
	# GUI may be installed from binaries provided elsewhere, although the '_qalculate' , '_clc' , and 'c' , functions do not require this.
	# https://qalculate.github.io/downloads.html
	if [[ -e /etc/debian_version ]] && cat /etc/debian_version | head -c 2 | grep 11 > /dev/null 2>&1
	then
		! _typeDep qalculate-gtk && sudo -n apt-get install --install-recommends -y qalculate-gtk
	else
		_wantGetDep qalculate-gtk
		#_wantGetDep qalculate
	fi
	
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
	
	
	if [[ $(qalc -v | cut -f1 -d\. | tr -dc '0-9') -le "3" ]]
	then
		echo 'warn: bad: unacceptable qalc version!'
	fi
	
	return 0
}


