
# https://github.com/nodesource/distributions?tab=readme-ov-file#debian-versions
#codex
#claude
_get_npm() {
    _mustGetSudo

    if _if_cygwin
    then
        ! type npm > /dev/null 2>&1 && echo 'request: https://github.com/coreybutler/nvm-windows/releases' && exit 1

        type npm > /dev/null 2>&1
        return
    fi

    ##sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y curl
    _getDep curl

    #sudo -n curl -fsSL https://deb.nodesource.com/setup_23.x -o /nodesource_setup.sh
    #sudo -n bash /nodesource_setup.sh
    sudo -n curl -fsSL https://deb.nodesource.com/setup_23.x -o - | sudo -n bash

    sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs


    #sudo -n npm install -g @openai/codex
    ##npm install -g @anthropic-ai/claude-code
    #sudo -n npm install -g @anthropic-ai/claude-code

    ! type npm > /dev/null 2>&1 && exit 1
    return 0
}



