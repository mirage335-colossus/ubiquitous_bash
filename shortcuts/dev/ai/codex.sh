
# NOTICE: Installing 'codex' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .

_setup_codex-npm() {
    _mustGetSudo

    _get_npm



    # WARNING: Mainline version. DISCOURAGED, except to get dependencies needed by a frozen, and possibly more useful, version. Issues disabling sandbox .
    #  https://github.com/openai/codex/pull/996
    #  https://github.com/openai/codex/pull/1125
    #  https://github.com/openai/codex/issues/1254
    #  https://github.com/openai/codex/pull/374
    #@openai/codex
    #@openai/codex@latest
    sudo -n npm install -g @openai/codex

    # DUBIOUS .
    #sudo -n npm install -g @openai/codex@b73426c1c40187ca13c74c03912a681072c2884f

    # ATTRIBUTION-AI: devstral-small  2025-06-11
    #sudo -n npm install https://github.com/openai/codex/archive/b73426c1c40187ca13c74c03912a681072c2884f.tar.gz



    sudo -n npm install https://github.com/openai/codex/archive/8493285.tar.gz
}

# WARNING: May be untested.
# DUBIOUS .
#_setup_codex_sequence-upstream() {
    #_start
    #local functionEntryPWD
    #functionEntryPWD="$PWD"

    #cd "$safeTmp"

    ## ATTRIBUTION-AI: ChatGPT o3  2025-06-11
    #corepack enable                 # turn on pnpm via corepack (Node ≥16.10)
    #corepack prepare pnpm@latest --activate

    #export safeToDeleteGit="true"
    #git clone https://github.com/openai/codex.git
    #cd codex

    ## fetch PR 996 and check it out locally
    #git fetch origin pull/996/head:disable-sandbox
    #git switch disable-sandbox      # or: git checkout -b disable-sandbox FETCH_HEAD

    ## install deps for the monorepo and build just the CLI package
    #pnpm install
    #pnpm --filter codex-cli run build

    ## expose the built CLI globally
    #pnpm --filter codex-cli link --global   # 'codex' now in your PATH

    #cd "$functionEntryPWD"
    #_stop
#}
#_setup_codex-upstream() {
    #_setup_codex-npm "$@"
    #"$scriptAbsoluteLocation" _setup_codex_sequence-upstream "$@"
#}

_setup_codex() {
    _setup_codex-npm "$@"
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




# WARNING: Mainline versions of CLI Codex apparently do NOT disable the sandbox if '--approval-mode full-auto' parameter is given.
#export TMPDIR=/tmp ; export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything
#export TMPDIR=/tmp ; export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything --approval-mode full-auto
alias codexAuto='export TMPDIR=/tmp ; export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything --approval-mode full-auto'
alias codexForce='export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything'


if type -P codex > /dev/null 2>&1
then
    [[ -e /usr/local/bin/node ]] && alias codex=/usr/local/bin/node' '"$(type -P codex)"
    [[ -e /usr/bin/node ]] && alias codex=/usr/bin/node' '"$(type -P codex)"
fi


