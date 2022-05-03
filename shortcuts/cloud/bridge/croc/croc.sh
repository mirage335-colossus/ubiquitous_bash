
# WARNING: Infinite loop risk, do not call '_wantGetDep croc' within this function.
_test_croc_upstream() {
	! _wantSudo && return 1
	
	echo
	curl https://getcroc.schollz.com | bash
	echo
}


# https://github.com/schollz/croc
_test_croc() {
	! _test_cloud_updateInterval '-croc' && return 0
	rm -f "$HOME"/.ubcore/.retest-cloud'-croc' > /dev/null 2>&1
	touch "$HOME"/.ubcore/.retest-cloud'-croc'
	date +%s > "$HOME"/.ubcore/.retest-cloud'-croc'
	
	if [[ "$nonet" != "true" ]] && ! _if_cygwin
	then
		_messagePlain_request 'ignore: upstream progress ->'
		
		_test_croc_upstream "$@"
		#_test_croc_upstream_beta "$@"
		
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	_wantSudo && _wantGetDep croc
	
	! _typeDep croc && echo 'warn: missing: croc'
	
	return 0
}

_mustHaveCroc() {
	# https://github.com/schollz/croc
	if ! type croc > /dev/null 2>&1
	then
		_test_croc_upstream > /dev/null 2>&1
	fi
	
	! type croc > /dev/null 2>&1 && _stop 1
	return 0
}

# WARNING: No production use. Prefer '_mustHaveCroc' .
_croc() {
	_mustHaveCroc
	
	croc "$@"
}

