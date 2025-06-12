
# NOTICE: Installing 'codex' may be useful for cloud, container, etc, usage (eg. within a RunPod instance, within a Docker container, etc).)
# Also recommend 'Cline' VSCode extension .


_setup_codex_sequence-npm() {
    _start
    local functionEntryPWD
    functionEntryPWD="$PWD"

    cd "$safeTmp"
    

    # DUBIOUS .
    #sudo -n npm install -g @openai/codex@b73426c1c40187ca13c74c03912a681072c2884f

    # ATTRIBUTION-AI: devstral-small  2025-06-11
    #sudo -n npm install https://github.com/openai/codex/archive/b73426c1c40187ca13c74c03912a681072c2884f.tar.gz



    sudo -n npm install https://github.com/openai/codex/archive/8493285.tar.gz
    sudo -n npm install https://github.com/openai/codex/archive/b051edb7d3e04200b369af37ca45e210614cf281.tar.gz


    cd "$functionEntryPWD"
    _stop
}

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
}

# WARNING: May be untested.
# DUBIOUS .
_setup_codex_sequence-upstream() {
    _start
    local functionEntryPWD
    functionEntryPWD="$PWD"

    #cd "$safeTmp"
    mkdir -p "$HOME"/core/installations/codex_bin
    cd "$HOME"/core/installations/codex_bin

    # ATTRIBUTION-AI: ChatGPT o3  2025-06-11  (partially)

    for v in $(env | awk -F= '/^NVM_/ {print $1}'); do
        unset "$v"
    done

    export PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -vE '/\.nvm/' | paste -sd ':' -)"
    #export PATH="/usr/bin:${PATH}"

    export SHELL="/bin/bash"
    
    sudo -n /usr/bin/corepack enable                 # turn on pnpm via corepack (Node >=16.10)
    /usr/bin/corepack prepare pnpm@latest --activate

    export safeToDeleteGit="true"
    git clone https://github.com/openai/codex.git
    cd codex

    # fetch PR 996 and check it out locally
    git fetch origin pull/996/head:disable-sandbox
    git switch disable-sandbox      # or: git checkout -b disable-sandbox FETCH_HEAD

    yes | /usr/lib/node_modules/corepack/shims/pnpm setup

    export PNPM_HOME="$HOME""/.local/share/pnpm"
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac

    # install deps for the monorepo and build just the CLI package
    yes | /usr/lib/node_modules/corepack/shims/pnpm install
    /usr/lib/node_modules/corepack/shims/pnpm --dir ./codex-cli run build


    # expose the built CLI globally
    cd ./codex-cli
    /usr/lib/node_modules/corepack/shims/pnpm link --global

    mkdir -p "$HOME"/.bun/install/global
    [[ ! -e "$HOME"/.bun/install/global/package.json ]] && echo '{ "name": "bun-global", "private": true }' > "$HOME"/.bun/install/global/package.json

    cd "$functionEntryPWD"
    _stop
}
_setup_codex-upstream() {
    _setup_codex-npm "$@"
    "$scriptAbsoluteLocation" _setup_codex_sequence-upstream "$@"
}

_setup_codex() {
    _setup_codex-upstream "$@"
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
#export TMPDIR=/tmp ; 
#export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything
#export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything --approval-mode full-auto
#alias codexAuto='export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything --approval-mode full-auto'
#alias codexForce='export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 ; codex --dangerously-auto-approve-everything'
alias codexAuto='CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 codex --dangerously-auto-approve-everything --approval-mode full-auto'
alias codexForce='CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 codex --dangerously-auto-approve-everything'




# ATTENTION: Override with 'ops.sh' , '_bashrc' , or similar, ONLY if uniquely necessary for a very unusual situation.
#  ATTENTION: NOTICE: Otherwise, CLI Codex issues really should be very urgently reported as issues to both 'codex' and 'ubiquitous_bash' projects .
# Assumes the usable upstream mainline 'node' and 'codex' installations are installed '/usr/bin' or similar, with conflicting (eg. not recent) or custom (eg. disable sandbox) versions installed under "$HOME" or similar.
_codexBin-usr_local_bin_node() {
    local currentDisableSandbox
    currentDisableSandbox="false"

    # Calling 'codexAuto' from Cygwin to WSL2 codex would not necessarily apply the environment variable. Infer always disabling sandbox implied with command line parameter .
    local currentArg
    for currentArg in "$@"
    do
        [[ "$currentArg" == "--dangerously-auto-approve-everything" ]] && currentDisableSandbox="true"
    done

    if ( [[ "$currentDisableSandbox" != "false" ]] || [[ -v CODEX_UNSAFE_ALLOW_NO_SANDBOX ]] ) && ( ( [[ ! -e /.dockerenv ]] && ! [[ -e /info_factoryName.txt ]] ) || grep 'ubDistBuild' /info-github > /dev/null 2>&1 || _if_cygwin )
    then
        #_messagePlain_warn
        #_messageError
        _messageError ' CAUTION: DANGER: Native codexAuto, codexForce, etc, may cause IRREPARABLE dist/OS BREAKAGE, filesystem DELETION , or network HARM ! ' >&2
        echo 'Ctrl+c repeatedly to cancel!' >&2
        echo 'wait: 5seconds: Ctrl+c repeatedly to cancel NOW!!!' >&2
        sleep 4
    fi

    #[[ "$currentDisableSandbox" == "true" ]] && export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1
    

    local currentExitStatus

    if [[ -e "$HOME"/.local/share/pnpm/codex ]]
    then
        export PNPM_HOME="$HOME""/.local/share/pnpm"
        case ":$PATH:" in
            *":$PNPM_HOME:"*) ;;
            *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        if [[ "$currentDisableSandbox" == "true" ]] || [[ "$CODEX_UNSAFE_ALLOW_NO_SANDBOX" == "1" ]]
        then
            CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 "$HOME"/.local/share/pnpm/codex "$@"
            currentExitStatus="$?"
            unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
            return "$currentExitStatus"
        #else
            #"$HOME"/.local/share/pnpm/codex "$@"
            #currentExitStatus="$?"
            #unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
            #return "$currentExitStatus"
        fi
    fi
    if [[ "$currentDisableSandbox" == "true" ]] || [[ "$CODEX_UNSAFE_ALLOW_NO_SANDBOX" == "1" ]]
    then
        #CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/local/bin/node "$(type -P codex)" "$@"
        #CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/local/bin/node /usr/local/bin/codex "$@"
        CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/local/bin/node '/usr/lib/node_modules/@openai/codex/bin/codex.js' "$@"
        currentExitStatus="$?"
        unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
        return "$currentExitStatus"
    else
        #/usr/local/bin/node "$(type -P codex)" "$@"
        #/usr/local/bin/node /usr/local/bin/codex "$@"
        /usr/local/bin/node '/usr/local/lib/node_modules/@openai/codex/bin/codex.js' "$@"
        currentExitStatus="$?"
        unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
        return "$currentExitStatus"
    fi
}
_codexBin-usr_bin_node() {
    local currentDisableSandbox
    currentDisableSandbox="false"

    # Calling 'codexAuto' from Cygwin to WSL2 codex would not necessarily apply the environment variable. Infer always disabling sandbox implied with command line parameter .
    local currentArg
    for currentArg in "$@"
    do
        [[ "$currentArg" == "--dangerously-auto-approve-everything" ]] && currentDisableSandbox="true"
    done

    if ( [[ "$currentDisableSandbox" != "false" ]] || [[ -v CODEX_UNSAFE_ALLOW_NO_SANDBOX ]] ) && ( ( [[ ! -e /.dockerenv ]] && ! [[ -e /info_factoryName.txt ]] ) || grep 'ubDistBuild' /info-github > /dev/null 2>&1 || _if_cygwin )
    then
        #_messagePlain_warn
        #_messageError
        _messageError ' CAUTION: DANGER: Native codexAuto, codexForce, etc, may cause IRREPARABLE dist/OS BREAKAGE, filesystem DELETION , or network HARM ! ' >&2
        echo 'Ctrl+c repeatedly to cancel!' >&2
        echo 'wait: 5seconds: Ctrl+c repeatedly to cancel NOW!!!' >&2
        sleep 4
    fi

    #[[ "$currentDisableSandbox" == "true" ]] && export CODEX_UNSAFE_ALLOW_NO_SANDBOX=1
    

    local currentExitStatus

    if [[ -e "$HOME"/.local/share/pnpm/codex ]]
    then
        export PNPM_HOME="$HOME""/.local/share/pnpm"
        case ":$PATH:" in
            *":$PNPM_HOME:"*) ;;
            *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        if [[ "$currentDisableSandbox" == "true" ]] || [[ "$CODEX_UNSAFE_ALLOW_NO_SANDBOX" == "1" ]]
        then
            CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 "$HOME"/.local/share/pnpm/codex "$@"
            currentExitStatus="$?"
            unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
            return "$currentExitStatus"
        #else
            #"$HOME"/.local/share/pnpm/codex "$@"
            #currentExitStatus="$?"
            #unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
            #return "$currentExitStatus"
        fi
    fi
    if [[ "$currentDisableSandbox" == "true" ]] || [[ "$CODEX_UNSAFE_ALLOW_NO_SANDBOX" == "1" ]]
    then
        #CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/bin/node "$(type -P codex)" "$@"
        #CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/bin/node /usr/bin/codex "$@"
        CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 /usr/bin/node '/usr/lib/node_modules/@openai/codex/bin/codex.js' "$@"
        currentExitStatus="$?"
        unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
        return "$currentExitStatus"
    else
        #/usr/bin/node "$(type -P codex)" "$@"
        #/usr/bin/node /usr/bin/codex "$@"
        /usr/bin/node '/usr/lib/node_modules/@openai/codex/bin/codex.js' "$@"
        currentExitStatus="$?"
        unset CODEX_UNSAFE_ALLOW_NO_SANDBOX
        return "$currentExitStatus"
    fi
}


if type -P codex > /dev/null 2>&1
then
    [[ -e /usr/local/bin/node ]] && alias codex=_codexBin-usr_local_bin_node
    [[ -e /usr/bin/node ]] && alias codex=_codexBin-usr_bin_node
fi


