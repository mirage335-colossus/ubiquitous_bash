
_test_haskell() {
	#if [[ -e /etc/issue ]] && cat /etc/issue | grep 'Debian' > /dev/null 2>&1
	#then
		#_wantGetDep '/usr/share/doc/haskell-platform/README.Debian'
	#fi

	_wantGetDep alex
	_wantGetDep cabal
	_wantGetDep happy
	_wantGetDep HsColour
	_wantGetDep hscolour

	_wantGetDep ghc
	_wantGetDep ghci
	! type -p 'ghc' > /dev/null 2>&1 && echo 'warn: missing: ghc'
	! type -p 'ghci' > /dev/null 2>&1 && echo 'warn: missing: ghci'
}
