
_get_from_nix-user() {
	local currentUser
	currentUser="$1"
	[[ "$currentUser" == "" ]] && currentUser="user"
	
	
	local current_getMost_backend_wasSet
	current_getMost_backend_wasSet=true
	
	if ! type _getMost_backend > /dev/null 2>&1
	then
		_getMost_backend() {
			"$@"
		}
		export -f _getMost_backend
		
		current_getMost_backend_wasSet="false"
	fi
	
	# . "$HOME"/.nix-profile/etc/profile.d/nix.sh



	#_nix_update
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-channel --list'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-channel --update'

	
	#_custom_installDeb /root/core/installations/Wire.deb
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-env -iA nixpkgs.wire-desktop'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'xdg-desktop-menu install "$HOME"/.nix-profile/share/applications/wire-desktop.desktop'
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/"$currentUser"/.nix-profile/share/icons /home/"$currentUser"/.local/share/
	
	sleep 3
	
	#nix-env --uninstall geda
	#export NIXPKGS_ALLOW_INSECURE=1
	# Note: For `nix shell`, `nix build`, `nix develop` or any other Nix 2.4+ (Flake) command, `--impure` must be passed in order to read this environment variable.
	
	# WARNING: ERROR from gschem when installed by nix as of 2023-08-11 .
	
#(process:109925): Gtk-WARNING **: 17:53:57.226: Locale not supported by C library.
        #Using the fallback 'C' locale.
#Backtrace:
           #1 (apply-smob/1 #<catch-closure 7f7085b29340>)
           #0 (apply-smob/1 #<catch-closure 7f7085b39740>)

#ERROR: In procedure apply-smob/1:
#In procedure setlocale: Invalid argument

	# ATTENTION: NOTICE: ERROR from gschem has RESOLUTION .
	#  export LANG=C
	#  https://bbs.archlinux.org/viewtopic.php?id=23505

	#nix-env --uninstall geda
	#nix-env --uninstall pcb
	
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA nixpkgs.geda'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'xdg-desktop-menu install "$HOME"/.nix-profile/share/applications/geda-gschem.desktop'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'xdg-desktop-menu install "$HOME"/.nix-profile/share/applications/geda-gattrib.desktop'
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/"$currentUser"/.nix-profile/share/icons /home/"$currentUser"/.local/share/

	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA nixpkgs.pcb'

	# Necessary, do NOT remove. Necessary for 'gsch2pcb' , 'gnetlist' , etc, since installation as a dependency does not make the necessary binaries available to the usual predictable PATH .
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA nixpkgs.python2'


	# Workaround to make macros needed from 'pcb' package available to such programs as 'gsch2pcb' from the 'geda' package .
	#sed 's/.*\/\(.*\)\/bin\/pcb.*/\1/')
	local currentDerivationPath_pcb
	currentDerivationPath_pcb=$(_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'readlink -f "$(type -p pcb)"')
	currentDerivationPath_pcb=$(echo "$currentDerivationPath_pcb" | sed 's/\(.*\)\/bin\/pcb.*/\1/')

	local currentDerivationPath_gsch2pcb
	currentDerivationPath_gsch2pcb=$(_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'readlink -f "$(type -p gsch2pcb)"')
	currentDerivationPath_gsch2pcb=$(echo "$currentDerivationPath_gsch2pcb" | sed 's/\(.*\)\/bin\/gsch2pcb.*/\1/')

	_getMost_backend cp -a "$currentDerivationPath_pcb"/share/pcb "$currentDerivationPath_gsch2pcb"/share/
	_getMost_backend cp -a "$currentDerivationPath_pcb"/share/gEDA "$currentDerivationPath_gsch2pcb"/share/

	# ATTENTION: Unusual .
	_getMost_backend sed -i 's/import errno, os, stat, tempfile$/& , sys/' "$currentDerivationPath_gsch2pcb"/lib/python2.7/site-packages/xorn/fileutils.py

	# DOCUMENTATION - interesting copilot suggestions that may or may not be relevant
	# --option allow-substitutes false --option allow-unsafe-native-code-during-evaluation true --option substituters 'https://cache.nixos.org https://hydra.iohk.io' --option trusted-public-keys 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ='
	#export NIXPKGS_ALLOW_INSECURE=1 ; nix-env --option binary-caches "" -iA nixpkgs.geda nixpkgs.pcb --option keep-outputs true --option merge-outputs-by-path true

	
	[[ "$current_getMost_backend_wasSet" == "false" ]] && unset _getMost_backend



	return 0
}

_get_from_nix() {
	_get_from_nix-user "$@"
}





