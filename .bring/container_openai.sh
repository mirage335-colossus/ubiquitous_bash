#!/usr/bin/env bash

# https://github.com/openai/codex-universal

# Beware this script may only be given 5-10 minutes to run .


git config --global checkout.workers -1
#apt-get update -y
#apt-get install -y apt-transport-https ca-certificates curl gnupg git wget


# Suggested by ChatGPT o3  2025-06-05 . DUBIOUS
#mkdir -p /usr/libexec
#ln -sf /usr/lib/policykit-1/polkitd /usr/libexec/polkitd
#
#echo "policykit-1 hold" | dpkg --set-selections
#apt-get -o Dpkg::Options::="--force-confdef" \
             #-o Dpkg::Options::="--force-confold" \
             #upgrade -y
#
#add-apt-repository ppa:ubuntu-security-proposed/policykit-1
#apt-get update && apt-get upgrade -y policykit-1
#
#yes | unminimize


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
#export profileScriptLocation="/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"
#export profileScriptFolder="/root/core/infrastructure/ubiquitous_bash"
#. "/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts


cd
~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _setup_codex

if false
then
# ###
cd
curl -fsSL https://ollama.com/install.sh | sh
sudo -n -u ollama ollama serve &
#
#wget 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
#aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
#[[ ! -e 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' --disable-ipv6=true
~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _wget_githubRelease_join "soaringDistributions/Llama-augment_bundle" "" "llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf"
#
echo 'FROM ./llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf
PARAMETER num_ctx 6144
' > Llama-augment.Modelfile
~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _here_license-Llama-augment >> Llama-augment.Modelfile
#
ollama create Llama-augment -f Llama-augment.Modelfile
rm -f Llama-augment.Modelfile
rm -f llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf
# ###
fi


cd

~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_special
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMost


export devfast=true
export skimfast=true





unset ubiquitousBashID

