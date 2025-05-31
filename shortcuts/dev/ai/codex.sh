
# NOTICE: Installing 'codex' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .
_setup_codex() {
    _mustGetSudo

    _get_npm

    
    sudo -n npm install -g @openai/codex
}







