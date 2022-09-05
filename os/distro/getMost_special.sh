
_get_from_nix-user() {
	local currentUser
	currentUser="$1"
	[[ "$currentUser" == "" ]] && currentUser="user"
	
	
	#_custom_installDeb /root/core/installations/Wire.deb
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -i -c 'nix-env -iA nixpkgs.wire-desktop'
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/wire-desktop.desktop
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/user/.nix-profile/share/icons /home/user/.local/share/
	
	_getMost_backend sudo -n -u "$currentUser" /bin/bash -i -c 'nix-env -iA nixpkgs.geda'
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/geda-gschem.desktop
	_getMost_backend sudo -n -u "$currentUser" xdg-desktop-menu install /home/user/.nix-profile/share/applications/geda-gattrib.desktop
	_getMost_backend sudo -n -u "$currentUser" cp -a /home/user/.nix-profile/share/icons /home/user/.local/share/
}

_get_from_nix() {
	_get_from_nix-user "$@"
}





