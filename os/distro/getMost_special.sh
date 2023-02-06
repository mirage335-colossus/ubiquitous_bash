
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
	
	
	#_custom_installDeb /root/core/installations/Wire.deb
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-env -iA nixpkgs.wire-desktop'
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/wire-desktop.desktop
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/user/.nix-profile/share/icons /home/user/.local/share/
	
	sleep 3
	
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -l -c 'nix-env -iA nixpkgs.geda'
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/geda-gschem.desktop
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/geda-gattrib.desktop
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/user/.nix-profile/share/icons /home/user/.local/share/
	
	[[ "$current_getMost_backend_wasSet" == "false" ]] && unset _getMost_backend
	
	return 0
}

_get_from_nix() {
	_get_from_nix-user "$@"
}





