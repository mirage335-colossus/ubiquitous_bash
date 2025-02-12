
# WARNING: Infinite loop risk, do not call '_wantGetDep croc' within this function.
_test_croc_upstream() {
	! _wantSudo && return 1
	
	echo
	#curl https://getcroc.schollz.com | bash
	curl -fsSL 'https://getcroc.schollz.com' | bash
	echo
}
_test_croc_upstream_static-sequence() {
	_start

	_mustGetSudo

	cd "$safeTmp"

	type croc > /dev/null 2>&1 && return 0
	
	# TODO: MAINTENANCE .
	curl -L 'https://github.com/schollz/croc/releases/download/v10.2.1/croc_v10.2.1_Linux-64bit.tar.gz' -o croc_v10.2.1_Linux-64bit.tar.gz

	tar xf croc_v10.2.1_Linux-64bit.tar.gz

	sudo -n mkdir -p /usr/local/bin
	sudo -n mv -f croc /usr/local/bin/croc
	sudo -n chmod 755 /usr/local/bin/croc

	sudo -n mkdir -p /usr/local/share/doc/croc
	sudo -n mv -f LICENSE /usr/local/share/doc/croc/LICENSE

	_stop
}
_test_croc_upstream_verbose() {
	_messagePlain_request 'ignore: upstream progress ->'
	
	curl -fsSL 'https://getcroc.schollz.com' | head -n 30

	_test_croc_upstream "$@"
	#_test_croc_upstream_beta "$@"

	! _typeDep croc && _test_croc_upstream_static-sequence
	
	_messagePlain_request 'ignore: <- upstream progress'
}

# https://github.com/schollz/croc
_test_croc() {
	! _test_cloud_updateInterval '-croc' && return 0
	rm -f "$HOME"/.ubcore/.retest-cloud'-croc' > /dev/null 2>&1
	touch "$HOME"/.ubcore/.retest-cloud'-croc'
	date +%s > "$HOME"/.ubcore/.retest-cloud'-croc'
	
	if [[ "$nonet" != "true" ]] && ! _if_cygwin
	then
		_test_croc_upstream_verbose
	fi
	
	#_wantSudo && _wantGetDep croc
	
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

