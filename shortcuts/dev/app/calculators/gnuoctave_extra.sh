
_test_devgnuoctave_wantGetDep-octavePackage-internal() {
	if [[ "$1" == "symbolic" ]]
	then
		_wantGetDep 'python3/dist-packages/sympy/__init__.py'
		_wantGetDep 'python3/dist-packages/isympy.py'
		
		"$scriptAbsoluteLocation" _octave pkg list | grep symbolic > /dev/null && return 0
		
		_wantGetDep octave-symbolic
		"$scriptAbsoluteLocation" _octave pkg install -forge symbolic
		return 0
	fi
	
	
	return 1
}



_test_devgnuoctave_wantGetDep-octavePackage-debian-x64-special-debianBullseye() {
	! [[ -e /etc/issue ]] && return 1
	! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 1
	! [[ -e /etc/debian_version ]] && return 1
	! cat /etc/debian_version | head -c 2 | grep 11 > /dev/null 2>&1 && return 1
	
	
	if [[ "$1" == "symbolic" ]]
	then
		_test_devgnuoctave_wantGetDep-octavePackage-internal "$@"
		return
	fi
	
	return 1
}





# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_devgnuoctave_wantGetDep-octavePackage-debian-x64() {
	## If not Debian, then simply accept these pacakges may not be available.
	#[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	# If not x64, then simply accept these pacakges may not be available.
	local hostArch
	hostArch=$(uname -m)
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 0
	fi
	
	if _test_devgnuoctave_wantGetDep-octavePackage-debian-x64-special-debianBullseye "$@"
	then
		return 0
	fi
	
	local currentPackageSuffix
	currentPackageSuffix=$(echo "$1" | sed 's/-$//')
	
	! _typeShare_dir_wildcard 'octave/packages/'"$1" && ! _typeShare_dir_wildcard 'octave/packages/'"$1" && _wantGetDep octave-"$currentPackageSuffix"
	! _typeShare_dir_wildcard 'octave/packages/'"$1" && ! _typeShare_dir_wildcard 'octave/packages/'octave-"$1" && _wantGetDep octave-"$currentPackageSuffix"
	#_wantGetDep octave-"$1"
	
	return 0
}

_test_devgnuoctave-debian-x64() {
	local hostArch
	hostArch=$(uname -m)
	
	
	# If not Debian, then simply accept these pacakges may not be available.
	# Experimentally, some Debian-like distributions may be allowed to attempt to such more complete octave package installation.
	# \|Ubuntu
	[[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	# If not x64, then simply accept these pacakges may not be available.
	if [[ "$hostArch" != "x86_64" ]]
	then
		return 0
	fi
	
	
	
	
	if ! _typeShare_dir_wildcard 'octave/packages/arduino' && ! _typeShare 'doc-base/octave-arduino-manual' && ! _typeShare 'info/arduino.info.gz' && ! _typeShare 'doc/octave-arduino/arduino.pdf.gz'
	then
		_wantGetDep octave-arduino
	fi
	
	
	_wantGetDep /usr/share/octave/site/m/bart/bart.m
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 bim
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/biosig/mexSLOAD.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 bsltl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 cgi
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 data-smoothing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 dataframe
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 dicom
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 divand
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 doctest
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 econometrics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 financial
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fits
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fpl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 fuzzy-logic-toolkit
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ga-
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/gdf/gdf_reader.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 general
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 geometry
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 gsl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 image
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 image-acquisition
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 instrument-control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 interval
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 io-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 level-set
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 linear-algebra
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 lssa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ltfat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mapping
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 miscellaneous
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 missing-functions
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mpi-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 msh-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 mvn-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 nan-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 ncarray
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 netcdf
	
	if ! _typeDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt_optimize.oct' && ! _typeDep 'x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt/nlopt_optimize.oct'
	then
		_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt_optimize.oct
		_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt/nlopt_optimize.oct
	fi
	! _typeShare 'octave/site/m/nlopt/nlopt_optimize.m' && ! _typeShare '/usr/share/octave/site/m/nlopt_minimize.m' && _wantGetDep octave-nlopt
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 nurbs
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 netcdf
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 octclip
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 octproj
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 openems
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optim
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 optiminterp
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 parallel
	
	#_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/pfstools/pfsread.oct
	#! _typeShare 'octave/site/m/pfstools/pfs_read_xyz.m' && _wantGetDep octave-pfstools
	
	#_wantGetDep x86_64-linux-gnu/octave/site/oct/api-v52/x86_64-pc-linux-gnu/plplot_octave.oct
	#! _typeShare 'plplot_octave/mesh.m' && _wantGetDep octave-plplot
	
	_wantGetDep psychtoolbox-3/PsychBasic/PsychPortAudio.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 quaternion
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 queueing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs1d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs2d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 secs3d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 signal
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 sockets
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 sparsersb
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 specfun
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 splines
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 statistics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 stk
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 strings
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 struct
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 symbolic
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 tsa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 vibes
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/vlfeat/toolbox/vl_binsearch.mex
	! _typeShare 'octave/site/m/vlfeat/toolbox/misc/vl_binsearch.m' && _wantGetDep octave-vlfeat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 vrml
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 zenity
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 zeromq
	
	
	return 0
}

_test_devgnuoctave-extra() {
	local hostArch
	hostArch=$(uname -m)
	
	if [[ "$hostArch" != "x86_64" ]] && [[ -e /etc/issue ]] && ! cat /etc/issue | grep 'Ubuntu' > /dev/null 2>&1
	then
		_test_devgnuoctave_wantGetDep-octavePackage-internal symbolic
		_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 quaternion
		_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 vrml
		_test_devgnuoctave_wantGetDep-octavePackage-debian-x64 zeromq
	fi
	
	_test_devgnuoctave-debian-x64
}




