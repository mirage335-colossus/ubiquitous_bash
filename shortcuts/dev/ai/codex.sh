
# NOTICE: Installing 'codex' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .
_setup_codex() {
    _mustGetSudo

    _get_npm

    #@openai/codex
    #@openai/codex@latest
    sudo -n npm install -g @openai/codex
}


# https://github.com/openai/codex/issues/1189
#codex --approval-mode full-auto --provider openrouter --model openai/codex-mini
#
#unset OPENAI_API_KEY
#unset OPENROUTER_API_KEY
#export OPENAI_BASE_URL="https://openrouter.ai/api/v1"
#export OPENAI_API_KEY="sk-***-21"
#codex --model openai/o4-mini
#codex --model openai/codex-mini


#--model codex-mini-latest
#--model o3

#alias codex='wsl -d ubdist codex'





alias codexAuto='codex --approval-mode full-auto'


