
# WARNING: Infinite loop risk, do not call '_wantGetDep nix-env' within this function.
_test_nix-env_upstream() {
	! _wantSudo && return 1
	
	# https://ariya.io/2020/05/nix-package-manager-on-ubuntu-or-debian
	#  'Note that if you use WSL 1'
	#   'sandbox = false'
	#     WSL is NOT expected fully compatible with Ubiquitous Bash . MS commitment to WSL end-user usability, or so much as WSL having any better functionality than Cygwin, Qemu, VirtualBox, etc, is not obvious.
	# https://github.com/microsoft/WSL/issues/6301
	
	# https://ariya.io/2020/05/nix-package-manager-on-ubuntu-or-debian
	echo
	sh <(curl -L https://nixos.org/nix/install) --no-daemon
	echo
}




# ATTENTION: Override with 'core.sh', 'ops', or similar!
# Software which specifically may rely upon a recent feature of cloud services software (eg. aws, gcloud) should force this to instead always return 'true' .
_test_nixenv_updateInterval() {
	! find "$HOME"/.ubcore/.retest-"$1" -type f -mtime -9 2>/dev/null | grep '.retest-' > /dev/null 2>&1
	
	#return 0
	return
}

_test_nix-env_sequence() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	_start
	
	_mustHave_nixos
	
	cd "$safeTmp"
	
	# https://ariya.io/2016/06/isolated-development-environment-using-nix
	cat << 'CZXWXcRMTo8EmM8i4d' > ./default.nix
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    hello
  ];
}
CZXWXcRMTo8EmM8i4d
	
	! nix-shell --run hello | grep -i 'hello' > /dev/null && echo 'fail: nix-shell: hello' && _stop 1
	! nix-shell --run true && echo 'fail: nix-shell: true' && _stop 1
	nix-shell --run false && echo 'fail: nix-shell: false' && _stop 1
	[[ $(nix-shell --run 'type hello' | tr -dc 'a-zA-Z0-9/ ') == $(type hello | tr -dc 'a-zA-Z0-9/ ') ]] && echo 'fail: nix-shell: type: hello' && _stop 1
	[[ $(nix-shell --run 'type -P true' | tr -dc 'a-zA-Z0-9/ ') == $(type -P true | tr -dc 'a-zA-Z0-9/ ') ]] && echo 'fail: nix-shell: type: true' && _stop 1
	[[ $(nix-shell --run 'type -P false' | tr -dc 'a-zA-Z0-9/ ') == $(type -P false | tr -dc 'a-zA-Z0-9/ ') ]] && echo 'fail: nix-shell: type: false' && _stop 1
	
	cd "$functionEntryPWD"
	_stop
}

_test_nix-env() {
	! _test_nixenv_updateInterval 'nixenv' && return 0
	rm -f "$HOME"/.ubcore/.retest-'nixenv' > /dev/null 2>&1
	
	if [[ "$nonet" != "true" ]] && ! _if_cygwin
	then
		_messagePlain_request 'ignore: upstream progress ->'
		
		_test_nix-env_upstream "$@"
		#_test_nix-env_upstream_beta "$@"
		
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	_mustHave_nixos
	
	_wantSudo && _wantGetDep nix-env
	
	
	! _typeDep nix-env && echo 'fail: missing: nix-env' && _messageFAIL
	
	! _typeDep nix-shell && echo 'fail: missing: nix-shell' && _messageFAIL
	
	
	if ! "$scriptAbsoluteLocation" _test_nix-env_sequence "$@"
	then
		_messageFAIL
		_stop 1
		return 1
	fi
	#! nix-shell true && echo 'fail: nix-shell: true' && _messageFAIL
	#! nix-shell false && echo 'fail: nix-shell: false' && _messageFAIL
	
	
	
	touch "$HOME"/.ubcore/.retest-'nixenv'
	date +%s > "$HOME"/.ubcore/.retest-'nixenv'
	
	return 0
}

_mustHave_nixos() {
	#_setupUbiquitous_accessories_here-nixenv-bashrc
	[[ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME"/.nix-profile/etc/profile.d/nix.sh
	
	if ! type nix-env > /dev/null 2>&1
	then
		_test_nix-env_upstream > /dev/null 2>&1
	fi
	
	! type nix-env > /dev/null 2>&1 && _stop 1
	
	return 0
}

# WARNING: No production use. Prefer '_mustHave_nixos' .
_nix-env() {
	_mustHave_nixos
	
	nix-env "$@"
}


_nix-shell() {
	_mustHave_nixos
	
	# https://forum.holochain.org/t/how-to-load-your-bash-profile-into-nix-shell/2070
	nix-shell --command '. ~/.bashrc; return'
}

