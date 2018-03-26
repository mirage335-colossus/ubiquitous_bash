_setup_command_commands() {
	find . -name '_synergy' -exec "$scriptAbsoluteLocation" _setupCommand {} \;
}
