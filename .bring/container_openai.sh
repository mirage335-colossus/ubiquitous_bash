#!/usr/bin/env bash

# https://github.com/openai/codex-universal

# Beware this script may only be given 5-10 minutes to run .


git config --global checkout.workers -1
#apt-get update -y
#apt-get install -y apt-transport-https ca-certificates curl gnupg git wget



(
    apt-get update -y
    sleep 0.3


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
        sleep 0.3
    fi
    #
    #apt-get update -y
    apt-get install man-db manpages manpages-dev manpages-posix -y
    sleep 0.3
    #
    _filter_noReinstall() {
        grep -v 'icon\|x11\|dbus\|font\|cups\|freetype\|bzr\|gtk\|polkit\|xrender\|openjdk\|mime\|tzdata\|xkb\|xtrans' | grep -v 'perl\|gcc\|g++\|dpkg\|cpp\|bind9\|binutils\|clang\|yasm\|llvm\|glib\|java\|ruby\|gettext\|iputils\|inotify\|icu-devtools\|keybox\|libc-\|\libcurl\|libedit\|libffi\|libgdb\|libpam\|libpng\|libpcre\|libpq\|libpsl\|libxau\|xext\|libxft\|libxss\|lsb-release\|make\|moreutils\|curses\|protobuf\|rpcsvc\|software-properties-common\|common\|sgml\|tcl\|tk\|debconf\|debianutils\|e2fsprogs\|hostname\|helpers\|libpam\|login\|logsave\|sensible\|sysv\|dconf\|libcap2\|libcrypt\|libmysql\|rake\|ninja-build\|xdmcp\|udev\|libsystemd\|libstemmer\|libfm4\|libpango\|libmpfr6\|libmaxmind\|libtdl\|lliberc\|libldap2\|libipt\|libidn\|libgmp\|libgif\|libgdk\|pixbuf\|liggcl\|libfribidi\|libdb\|libdatrie\|libcbor\|libcairo\|libc6\|libasound\|libarchive\|libapt\|iso-codes\|libstdc\|distro-info-data\|ca-certificates' | grep -v 'xml\|swig\|tzlocal\|python3-yaml\|python3-wadlib\|python3-software-properties\|python3-psutil\|python3-patiencediff\|python3-oathlib\|python3-lazr\|launchpad\|python3-httplib2\|python-gi\|libtasn\|libsensors\|libpython3-stdlib\|libfm4\|python3-pygments\|build-essential' | grep -v 'pthread\|zlib1g\|lzma\|ccache\|pkgconf\|pkg-resources\|dirmngr'
    }
    #
    #dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | _filter_noReinstall | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y > /quicklog.tmp 2>&1
    #tail /quicklog.tmp
    #rm -f /quicklog.tmp
    #dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print $2}' | sed 's|/[^/]*$||' | sort | uniq | xargs --no-run-if-empty dpkg -S | sed 's|, |\n|g;s|: [^:]*$||' | uniq | _filter_noReinstall | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y > /quicklog.tmp 2>&1
    #tail /quicklog.tmp
    #rm -f /quicklog.tmp
    #
    # ATTENTION: Reinstall documentation.
    echo > packageList.tmp
    #dpkg -S /usr/share/man/ |sed 's|, |\n|g;s|: [^:]*$||' | _filter_noReinstall > packageList.tmp
    sleep 0.3
    #dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print $2}' | sed 's|/[^/]*$||' | sort | uniq | xargs --no-run-if-empty dpkg -S | sed 's|, |\n|g;s|: [^:]*$||' | uniq | _filter_noReinstall >> packageList.tmp
    sleep 0.3
    cat packageList.tmp | uniq | DEBIAN_FRONTEND=noninteractive xargs --no-run-if-empty apt-get install --reinstall -y
    sleep 0.3
    #
    #dpkg --verify --verify-format rpm | awk '$2 ~ /\/usr\/share\/doc/ {print " " $2}'
    #
    mandb -q
    rm -f packageList.tmp




    unset _aptGetInstall || true
    #unalias _aptGetInstall 2>/dev/null || true
    _aptGetInstall() {
        env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
    }

    _aptGetInstall procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime netcat-openbsd axel util-linux gawk libncurses-dev gh crudini bsdutils findutils p7zip p7zip-full unzip zip lbzip2 dnsutils bind9-dnsutils lz4 mawk patch tar gzip bzip2 sed pv iputils-ping zstd zlib1g coreutils openssl xz-utils libreadline8 libreadline-dev mkisofs genisoimage dos2unix lsof jq xxd sloccount dosfstools git-filter-repo qalc apt-utils | tail

    #_aptGetInstall procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime netcat-openbsd axel unionfs-fuse util-linux screen gawk libelf-dev libncurses-dev gh crudini bsdutils findutils p7zip p7zip-full unzip zip lbzip2 jp2a dnsutils bind9-dnsutils lz4 mawk libelf-dev elfutils patch tar gzip bzip2 librecode0 udftools sed cpio pv expect wipe iputils-ping btrfs-progs btrfs-compsize zstd zlib1g coreutils openssl growisofs e2fsprogs xz-utils libreadline8 libreadline-dev mkisofs genisoimage wodim dos2unix fuse-overlayfs xorriso squashfs-tools mtools lsof aptitude jq xxd sloccount dosfstools apt-utils git-filter-repo qalc apt-transport-https tcl tk | tail

    #_aptGetInstall procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime vim man-db gnulib libtool libtool-bin intltool libgts-dev netcat-openbsd iperf axel unionfs-fuse debootstrap util-linux screen gawk build-essential flex libelf-dev libncurses-dev autoconf libudev-dev dwarves pahole cmake gh libusb-dev libusb-1.0 setserial libffi-dev libusb-1.0-0 libusb-1.0-0-dev libusb-1.0-doc pkg-config crudini bsdutils findutils v4l-utils libevent-dev libjpeg-dev libbsd-dev libusb-1.0 gdb libbabeltrace1 libc6-dbg libsource-highlight-common libsource-highlight4v5 initramfs-tools dmidecode p7zip p7zip-full unzip zip lbzip2 jp2a dnsutils bind9-dnsutils live-boot mktorrent gdisk lz4 mawk nano bison libelf-dev elfutils patch tar gzip bzip2 librecode0 sed texinfo udftools wondershaper sysbench libssl-dev cpio pv expect libfuse2 wipe iputils-ping btrfs-progs btrfs-compsize zstd zlib1g nilfs-tools coreutils sg3-utils kpartx openssl growisofs udev cryptsetup parted e2fsprogs xz-utils libreadline8 libreadline-dev mkisofs genisoimage wodim eject hdparm sdparm php cifs-utils debhelper nsis dos2unix fuse-overlayfs xorriso squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools squashfs-tools squashfs-tools-ng fdisk lsof usbutils aptitude recode libpotrace0 libwmf-bin w3m par2 yubikey-manager qrencode tasksel jq xxd sloccount dosfstools apt-utils git-filter-repo qalc apt-transport-https tcl tk libgdl-3-5 libgdl-3-common | tail
) &
sleep 1




# ### _getCore_ub
if [[ ! -e ~/core/infrastructure/ubiquitous_bash ]]
then
    mkdir -p ~/core/infrastructure
    cd ~/core/infrastructure
    git clone --depth 1 --recursive https://github.com/mirage335-colossus/ubiquitous_bash.git
fi
cd ~/core/infrastructure/ubiquitous_bash
#~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull

[[ ! -e /workspace/ubiquitous_bash ]] && cp -a ~/core/infrastructure/ubiquitous_bash /workspace/ubiquitous_bash


# Certificates installation by '_setupUbiquitous' may otherwise cause dpkg lock multi-threading/concurrency collision.
sleep 1
wait


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




sleep 1
wait





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




#sleep 1
#wait





cd

#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_special
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud
#~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMost



export devfast=true
export skimfast=true

export ub_setScriptChecksum_disable='true'
export ubDEBUG=true



unset ubiquitousBashID || true

uptime
echo ' request: _setup_codex ; _setup_ollama ; apt-get install ... _getMinimal_special comments... '
