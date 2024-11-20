

# NOTICE
# https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=geda
# https://lazamar.co.uk/nix-versions/?package=geda&version=1.10.2&fullName=geda-1.10.2&keyName=geda&revision=9957cd48326fe8dbd52fdc50dd2502307f188b0d&channel=nixpkgs-unstable#instructions
#nix-env --query
#nix-env --uninstall geda
#export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA nixpkgs.geda
#export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA geda -f https://github.com/NixOS/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz
#nix-collect-garbage -d
#nix-env -iA geda -f https://github.com/NixOS/nixpkgs/archive/773a8314ef05364d856e46299722a9d849aacf8b.tar.gz
#nix-channel --update nixpkgs
#nix-store --realise /nix/store/a7gf7plqv6zj1zxplazzib02ank05hxj-geda-1.10.2.drv
#nix-store --verify --repair
#nix-store --delete /nix/store/a7gf7plqv6zj1zxplazzib02ank05hxj-geda-1.10.2.drv
#nix-store --gc
#nix-env --rollback
#nix-env --install
#sudo rm -rf /nix/var/nix/db/*
#sudo rm -rf /nix/var/nix/temproots/*
#sh <(curl -L https://nixos.org/nix/install) --repair

#export NIXPKGS_ALLOW_INSECURE=1

# ATTRIBUTION: ChatGPT-3.5 and ChatGPT4 2032-11-02 . ^

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


	#_nix_fetch_alternatives
	#_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c '[[ ! -e geda-gaf-1.10.2.tar.gz ]] && wget ftp.geda-project.org/geda-gaf/stable/v1.10/1.10.2/geda-gaf-1.10.2.tar.gz'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c '[[ ! -e geda-gaf-1.10.2.tar.gz ]] && wget https://web.archive.org/web/20230413214011/http://ftp.geda-project.org/geda-gaf/stable/v1.10/1.10.2/geda-gaf-1.10.2.tar.gz'
	#_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c '[[ ! -e geda-gaf-1.10.2.tar.gz ]] && wget https://web.archive.org/web/http://ftp.geda-project.org/geda-gaf/stable/v1.10/1.10.2/geda-gaf-1.10.2.tar.gz'
	#_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c '[[ ! -e geda-gaf-1.10.2.tar.gz ]] && wget https://github.com/soaringDistributions/ubDistBuild_bundle/raw/main/geda-gaf/geda-gaf-1.10.2.tar.gz'

	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-prefetch-url file://"$(~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getAbsoluteLocation ./geda-gaf-1.10.2.tar.gz)"'

	#_nix_update
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-channel --list'
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-channel --update'

	
	# CAUTION: May correctly fail, due to marked insecure, due to CVE-2024-6775 , or similar. Do NOT force.
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
	
	
	
	
	
	# ATTENTION: NOTICE: https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/applications/science/electronics/geda/default.nix
	# ATTENTION: NOTICE: CAUTION: MAJOR: SEVERE: WATCH ANALYSIS for potentially unfavorable changes. Regressions seem likely, python2 deprecation seems to be causing frequent repeated removals of possibly significant functionality. High risk.
	#  ATTENTION: Alternative frozen version commands documented for EMERGENCY use.
	# https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/applications/science/electronics/geda/default.nix
	#  CAUTION: Be wary if this file has changed recently.
	
	# ###
	# Seems to have removed xorn, python2.7 . May not have been tested through ubdist/WSL . May be accepted for now due to some apparently successful testing expected to match this specific version.
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA geda -f https://github.com/NixOS/nixpkgs/archive/773a8314ef05364d856e46299722a9d849aacf8b.tar.gz'
	
	# Seems to still have xorn, python2.7, etc . Should have the most functionality, and should match previously tested versions, both through ubdist/OS and ubdist/WSL .
	#_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA geda -f https://github.com/NixOS/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz'
	
	# Most recent version. May freeze until there is sufficient experience with newer versions.
	#_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'export NIXPKGS_ALLOW_INSECURE=1 ; nix-env -iA nixpkgs.geda'
	# ###
	
	
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

	_getMost_backend sudo -n cp -a "$currentDerivationPath_pcb"/share/pcb "$currentDerivationPath_gsch2pcb"/share/
	_getMost_backend sudo -n cp -a "$currentDerivationPath_pcb"/share/gEDA "$currentDerivationPath_gsch2pcb"/share/

	# ATTENTION: Unusual .
	# CAUTION: Seems unnecessary - maybe 'legacy' gnetlist no longer needs xorn or python ?
	_getMost_backend sudo -n sed -i 's/import errno, os, stat, tempfile$/& , sys/' "$currentDerivationPath_gsch2pcb"/lib/python2.7/site-packages/xorn/fileutils.py

	# DOCUMENTATION - interesting copilot suggestions that may or may not be relevant
	# --option allow-substitutes false --option allow-unsafe-native-code-during-evaluation true --option substituters 'https://cache.nixos.org https://hydra.iohk.io' --option trusted-public-keys 'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ='
	#export NIXPKGS_ALLOW_INSECURE=1 ; nix-env --option binary-caches "" -iA nixpkgs.geda nixpkgs.pcb --option keep-outputs true --option merge-outputs-by-path true
	
	
	[[ ! -e /home/"$currentUser"/.nix-profile/bin/gnetlist ]] && [[ -e /home/"$currentUser"/.nix-profile/bin/gnetlist-legacy ]] && sudo -n ln -s /home/"$currentUser"/.nix-profile/bin/gnetlist-legacy /home/"$currentUser"/.nix-profile/bin/gnetlist

	
	[[ "$current_getMost_backend_wasSet" == "false" ]] && unset _getMost_backend



	return 0
}

_get_from_nix() {
	_get_from_nix-user "$@"
}





