
# NOTICE: Installing 'codex' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .
_setup_codex() {
    _mustGetSudo

    _get_npm

    #@openai/codex
    #@openai/codex@latest
    sudo -n npm install -g @openai/codex
}


# ATTENTION: Full WebUI Codex may need 'ubDEBUG=true' to better diagnose and continue testing.
# WARNING: CLI Codex may NOT work well with 'ubDEBUG=true'.
# codex ... ubiquitous_bash ... debug
#
#export devfast=true
#export skimfast=true
#
#export ub_setScriptChecksum_disable='true'
##export ubDEBUG=true


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
#alias codexNative=$(type -P codex 2>/dev/null)





alias codexAuto='codex --approval-mode full-auto'


if type -P codex > /dev/null 2>&1
then
    [[ -e /usr/local/bin/node ]] && alias codex=/usr/local/bin/node' '"$(type -P codex)"
    [[ -e /usr/bin/node ]] && alias codex=/usr/bin/node' '"$(type -P codex)"
fi


