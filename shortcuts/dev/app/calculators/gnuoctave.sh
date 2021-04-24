
# ATTENTION: WARNING: Only tested with Debian Stable. May require rewrite to accommodate other distro (ie. Gentoo).
_test_devgnuoctave_wantGetDep-octavePackage-debian() {
	# If not Debian, then simply accept these pacakges may not be available.
	! [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	! _typeShare_dir_wildcard 'octave/packages/'"$1" && ! _typeShare_dir_wildcard 'octave/packages/'octave-"$1" && _wantGetDep octave-"$1"
	#_wantGetDep octave-"$1"
	
	return 0
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
	
	
	
	
	
	# If not Debian, then simply accept these pacakges may not be available.
	! [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1 && return 0
	
	
	
	
	
	if ! _typeShare_dir_wildcard 'octave/packages/arduino' && ! _typeShare 'doc-base/octave-arduino-manual' && ! _typeShare 'info/arduino.info.gz' && ! _typeShare 'doc/octave-arduino/arduino.pdf.gz'
	then
		_wantGetDep octave-arduino
	fi
	
	
	_wantGetDep /usr/share/octave/site/m/bart/bart.m
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian bim
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/biosig/mexSLOAD.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian bsltl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian cgi
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian data-smoothing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian dataframe
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian dicom
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian divand
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian doctest
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian econometrics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian financial
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian fits
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian fpl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian fuzzy-logic-toolkit
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian ga-
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/gdf/gdf_reader.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian general
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian geometry
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian gsl
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian image
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian image-acquisition
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian instrument-control
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian interval
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian io-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian level-set
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian linear-algebra
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian lssa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian ltfat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian mapping
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian miscellaneous
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian missing-functions
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian mpi-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian msh-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian mvn-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian nan-
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian ncarray
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian netcdf
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/nlopt/nlopt_optimize.oct
	! _typeShare 'octave/site/m/nlopt/nlopt_optimize.m' && _wantGetDep octave-nlopt
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian nurbs
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian netcdf
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian octclip
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian octproj
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian openems
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian optics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian optim
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian optiminterp
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian parallel
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/pfstools/pfsread.oct
	! _typeShare 'octave/site/m/pfstools/pfs_read_xyz.m' && _wantGetDep octave-pfstools
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/api-v52/x86_64-pc-linux-gnu/plplot_octave.oct
	! _typeShare 'plplot_octave/mesh.m' && _wantGetDep octave-plplot
	
	_wantGetDep psychtoolbox-3/PsychBasic/PsychPortAudio.mex
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian quaternion
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian queueing
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian secs1d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian secs2d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian secs3d
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian signal
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian sockets
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian sparsersb
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian specfun
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian splines
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian statistics
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian stk
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian strings
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian struct
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian symbolic
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian tsa
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian vibes
	
	_wantGetDep x86_64-linux-gnu/octave/site/oct/x86_64-pc-linux-gnu/vlfeat/toolbox/vl_binsearch.mex
	! _typeShare 'octave/site/m/vlfeat/toolbox/misc/vl_binsearch.m' && _wantGetDep octave-vlfeat
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian vrml
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian zenity
	
	_test_devgnuoctave_wantGetDep-octavePackage-debian zeromq
	
	
	
	
	
	
	
	
	
	
	
	
	
	return 0
}
