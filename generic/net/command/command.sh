_setup_command_commands() {
	_find_setupCommands -name '_synergy' -exec "$scriptAbsoluteLocation" _setupCommand '{}' \;
}
