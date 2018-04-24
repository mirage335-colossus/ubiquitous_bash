_setup_command_commands() {
	find . -type f,s -name '_synergy' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
}
