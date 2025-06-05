#!/usr/bin/env bash

# https://github.com/openai/codex-universal

# Beware this script may only be given 5-10 minutes to run .


git config --global checkout.workers -1
#apt-get update -y
#apt-get install -y apt-transport-https ca-certificates curl gnupg git wget


# ### _getCore_ub
if [[ ! -e ~/core/infrastructure/ubiquitous_bash ]]
then
    mkdir -p ~/core/infrastructure
    cd ~/core/infrastructure
    git clone --depth 1 --recursive https://github.com/mirage335-colossus/ubiquitous_bash.git
fi
cd ~/core/infrastructure/ubiquitous_bash
~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull
if [[ ! -e ~/.ubcore/ubiquitous_bash ]]
then
    cd ~/core/infrastructure/ubiquitous_bash
    ./_setupUbiquitous.bat
fi
cd ~/.ubcore/ubiquitous_bash
~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull
cd


cd
~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _setup_codex






cd

~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_special
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMost



















export devfast=true
export skimfast=true













unset ubiquitousBashID

