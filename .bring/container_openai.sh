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
#~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull
if [[ ! -e ~/.ubcore/ubiquitous_bash ]]
then
    cd ~/core/infrastructure/ubiquitous_bash
    ./_setupUbiquitous.bat
fi
cd ~/.ubcore/ubiquitous_bash
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull
cd
#export profileScriptLocation="/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"
#export profileScriptFolder="/root/core/infrastructure/ubiquitous_bash"
#. "/root/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts


cd
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _setup_codex

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

# Very limited code examples From 'unminimize' .
# https://packages.ubuntu.com/plucky/unminimize
# https://changelogs.ubuntu.com/changelogs/pool/main/u/unminimize/unminimize_0.5/copyright
# https://web.archive.org/web/20250605191859/https://changelogs.ubuntu.com/changelogs/pool/main/u/unminimize/unminimize_0.5/copyright
# https://packages.ubuntu.com/noble/unminimize
# https://changelogs.ubuntu.com/changelogs/pool/main/u/unminimize/unminimize_0.2/copyright
# https://web.archive.org/web/20250605192023/https://changelogs.ubuntu.com/changelogs/pool/main/u/unminimize/unminimize_0.2/copyright
# Copyright: 2024, Utkarsh Gupta <utkarsh@canonical.com>
# License: GPL-2.0+

#apt-get update -y
rm -f /etc/dpkg/dpkg.cfg.d/excludes
if [[ "$(dpkg-divert --truename /usr/bin/man)" = "/usr/bin/man.REAL" ]]; then
    rm -f /usr/bin/man
    dpkg-divert --quiet --remove --rename /usr/bin/man
fi
#
apt-get update -y
apt-get install man-db manpages manpages-dev manpages-posix -y
#
_filter_noReinstall() {
    grep -v 'icon\|x11\|dbus\|font\|cups\|freetype\|bzr\|gtk\|polkit\|xrender\|openjdk\|mime\|tzdata\|xkb\|xtrans'
}
#
#dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | _filter_noReinstall | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y > /quicklog.tmp 2>&1
#tail /quicklog.tmp
#rm -f /quicklog.tmp
#dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print $2}' | sed 's|/[^/]*$||' | sort | uniq | xargs --no-run-if-empty dpkg -S | sed 's|, |\n|g;s|: [^:]*$||' | uniq | _filter_noReinstall | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y > /quicklog.tmp 2>&1
#tail /quicklog.tmp
#rm -f /quicklog.tmp
#
dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | _filter_noReinstall > packageList.tmp
dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print $2}' | sed 's|/[^/]*$||' | sort | uniq | xargs --no-run-if-empty dpkg -S | sed 's|, |\n|g;s|: [^:]*$||' | uniq | _filter_noReinstall >> packageList.tmp
cat packageList.tmp | uniq | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y > /quicklog.tmp 2>&1
tail /quicklog.tmp
rm -f /quicklog.tmp
rm -f packageList.tmp
#
#dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print " " $2}'
#
mandb -q


cd

~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_special
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMost


export devfast=true
export skimfast=true





unset ubiquitousBashID

uptime
echo ' request: _setup_codex ; _setup_ollama ; apt-get install ... _getMinimal_special comments... '
