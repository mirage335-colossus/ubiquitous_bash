_setup_command_commands() {
	_find_setupCommands -name '_synergy' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
	
	_find_setupCommands -name '_cloud_shell' -exec "$scriptAbsoluteLocation" _setupCommand_meta '{}' \;
	_find_setupCommands -name '_cloud_hook' -exec "$scriptAbsoluteLocation" _setupCommand_meta '{}' \;
	
	# WARNING: No production use. Not expected to be necessary in practice.
	#_find_setupCommands -name '_cloud_unhook' -exec "$scriptAbsoluteLocation" _setupCommand_meta '{}' \;
	
	
	if declare -f _cloud_unhook > /dev/null 2>&1 && declare -f _messageNormal > /dev/null 2>&1
	then
		mkdir -p "$HOME"/bin
		! [[ -e "$HOME"/bin ]] && return 1
		echo '#!/usr/bin/env bash' > "$HOME"/bin/_cloud_unhook."$sessionid"
		declare -f _messageNormal >> "$HOME"/bin/_cloud_unhook."$sessionid"
		declare -f _cloud_unhook >> "$HOME"/bin/_cloud_unhook."$sessionid"
		echo '_cloud_unhook' >> "$HOME"/bin/_cloud_unhook."$sessionid"
		chmod u+x "$HOME"/bin/_cloud_unhook."$sessionid"
		mv "$HOME"/bin/_cloud_unhook."$sessionid" "$HOME"/bin/_cloud_unhook
		chmod u+x "$HOME"/bin/_cloud_unhook
	fi
}
