
_here_dockerfile-ubiquitous() {

# DANGER: ONLY in Docker container in CI environment !
if [[ "$CI" != "" ]] && ( [[ ! -e "$safeTmp"/repo/ubiquitous_bash ]] && [[ -e "$safeTmp" ]] )
then
    _messagePlain_bad "$safeTmp"/repo >&2
    _messageError 'FAIL' >&2
    _stop 1
fi
#if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
if [[ "$CI" != "" ]] && [[ -e "$safeTmp"/repo/ubiquitous_bash ]]
then

#local currentDirectory=$(realpath --relative-to="$PWD" "$scriptAbsoluteFolder")
local currentDirectory=$(realpath --relative-to="$PWD" "$safeTmp"/repo/ubiquitous_bash)

cat << CZXWXcRMTo8EmM8i4d

RUN rm -rf /workspace/ubiquitous_bash ;\ 
mkdir -p /workspace
COPY $currentDirectory /workspace/ubiquitous_bash

CZXWXcRMTo8EmM8i4d

fi

cat << 'CZXWXcRMTo8EmM8i4d'

# https://www.docker.com/blog/introduction-to-heredocs-in-dockerfiles/
COPY <<EOFSPECIAL /install_ub.sh
#!/usr/bin/env bash

# ###
# PASTE
# ###

#[[ -e /.dockerenv ]] && 
git config --global --add safe.directory '*' > /dev/null 2>&1

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
mkdir -p ~/.ubcore && cp -a /workspace/ubiquitous_bash ~/.ubcore/
( cd /workspace/ubiquitous_bash ; /workspace/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull ; git submodule update ; true )
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
export profileScriptLocation="/workspace/ubiquitous_bash/ubiquitous_bash.sh"
export profileScriptFolder="/workspace/ubiquitous_bash"
. "/workspace/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts
else
mkdir -p /workspace
! [[ -e /workspace/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash.sh
rmdir /workspace/ubiquitous_bash > /dev/null 2>&1
/workspace/ubiquitous_bash.sh _gitBest clone --depth 1 --recursive git@github.com:mirage335-colossus/ubiquitous_bash.git
mv -f ./ubiquitous_bash /workspace/ubiquitous_bash
[[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]] && mkdir -p ~/.ubcore && cp -a /workspace/ubiquitous_bash ~/.ubcore/
mkdir -p /workspace/ubiquitous_bash
! [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash/ubiquitous_bash.sh
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
( cd ~/.ubcore/ubiquitous_bash ; ~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull ; git submodule update ; true )
fi
#clear

# ###
# PASTE
# ###

EOFSPECIAL
RUN chmod u+x /install_ub.sh ;\ 
bash /install_ub.sh


# ###
# PASTE
# ###

# nohup - _service_ollama , _service_ollama_augment
#... coreutils
#
#env DEBIAN_FRONTEND=noninteractive apt-get install xz -y ;\ 
#
# https://www.hostinger.com/tutorials/how-to-install-ollama
#... python3 python3-pip git
# install llama.cpp from unsloth
#... libcurl4-openssl-dev
# possible nvidia_nemo dependency
#... ffmpeg
RUN env DEBIAN_FRONTEND=noninteractive apt-get update ;\ 
env DEBIAN_FRONTEND=noninteractive apt upgrade -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install sudo -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install less -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install pv -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install socat -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install bc -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install xxd -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install php -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install jq -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install gh -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install aria2 -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install curl wget -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install xz-utils -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install tar bzip2 gzip -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install sed patch expect -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install dos2unix -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install coreutils -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt install python3 python3-pip git -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install libcurl4-openssl-dev -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install ffmpeg -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install asciinema -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install gifsicle imagemagick apngasm ffmpeg -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install gifsicle imagemagick apngasm ffmpeg -y webp


# ATTRIBUTION-AI: ChatGPT o3  2025-06-05
RUN ( [ -n "$(dpkg-divert --list /usr/bin/man | tr -dc '[:alnum:]')" ] && rm -f /usr/bin/man && dpkg-divert --remove --rename /usr/bin/man ) ;\ 
rm -f /etc/dpkg/dpkg.cfg.d/excludes ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get install man-db manpages manpages-dev manpages-posix -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get --reinstall install -y $(dpkg-query -W -f='${Package} ') ;\ 
mandb -q


RUN env DEBIAN_FRONTEND=noninteractive apt-get install sudo -y ;\ 
/workspace/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud


# DISCOURAGED. Better to benefit from 'ubiquitous_bash' maintenance identifying the most recent ollama installation commands. 
#RUN curl -fsSL https://ollama.com/install.sh | sh
# DISCOURAGED. Does NOT install Llama-augment model.
RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama_sequence ;\ 
/workspace/ubiquitous_bash/ubiquitous_bash.sh _service_ollama
# PREFERRED. Normally robust, resilient, maintained, and adds the 'Llama-augment' model for automation, etc.
#RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama


# https://blog.runpod.io/how-to-achieve-true-ssh-on-runpod/
RUN apt-get install ssh -y
#RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
#RUN echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config


RUN env DEBIAN_FRONTEND=noninteractive apt-get remove linux-image-* linux-headers-* -y ;\ 
env DEBIAN_FRONTEND=noninteractive apt-get -y clean
#RUN env DEBIAN_FRONTEND=noninteractive apt-get remove --autoremove -y

RUN echo 'net.core.bpf_jit_harden=1' | sudo -n tee /etc/sysctl.d/99-nvidia-workaround-bpf_jit_harden.conf
#RUN sysctl -p /etc/sysctl.d/99-nvidia-workaround-bpf_jit_harden.conf

#codex
#claude
#RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y curl ;\ 
#curl -fsSL https://deb.nodesource.com/setup_23.x -o /nodesource_setup.sh ;\ 
#bash /nodesource_setup.sh ;\ 
#env DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs ;\ 
#npm install -g @openai/codex ;\ 
#npm install -g @anthropic-ai/claude-code
RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_codex ;\ 
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_asciinema_convert


# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d
}





_here_dockerfile-libcudadev_stub() {
cat << 'CZXWXcRMTo8EmM8i4d'

COPY <<EOFSPECIAL /install_libcudadev_stub.sh
#!/usr/bin/env bash

# ###
# PASTE
# ###


# ### NOTICE: Uninstall .
#rm -f /usr/lib/x86_64-linux-gnu/nvidia/current/libcuda.so*


echo ' install: libcudadev_stub'

# Forces upgrade.
#rm -f /opt/libcudadev_stub-stubOnly/libcuda*.so*

if ls -1 /opt/libcudadev_stub-stubOnly/libcuda*.so*
then
    exit 0
fi


_prepare_install_libcudadev_stub-stubOnly() {
    
    mkdir -p /opt/libcudadev_stub-stubOnly
    cd /opt/libcudadev_stub-stubOnly

    # find . -type f
    #rm -f ./libcuda1_535.216.01-1~deb12u1_amd64.deb
    #rm -f ./usr/lib/x86_64-linux-gnu/nvidia/current/libcuda.so.535.216.01
    rm -f ./usr/share/bug/libcuda1/control
    rm -f ./usr/share/bug/libcuda1/script
    rm -f ./usr/share/doc/libcuda1/changelog.Debian.gz
    rm -f ./usr/share/doc/libcuda1/changelog.gz
    #rm -f ./usr/share/doc/libcuda1/copyright
    rm -f ./usr/share/lintian/overrides/libcuda1

    # find . -type l
    #rm -f ./usr/lib/x86_64-linux-gnu/nvidia/current/libcuda.so
    #rm -f ./usr/lib/x86_64-linux-gnu/nvidia/current/libcuda.so.1

    # find . -type d
    rmdir ./usr > /dev/null 2>&1
    rmdir ./usr/lib > /dev/null 2>&1
    rmdir ./usr/lib/x86_64-linux-gnu > /dev/null 2>&1
    rmdir ./usr/lib/x86_64-linux-gnu/nvidia > /dev/null 2>&1
    rmdir ./usr/lib/x86_64-linux-gnu/nvidia/current > /dev/null 2>&1
    rmdir ./usr/share > /dev/null 2>&1
    rmdir ./usr/share/bug > /dev/null 2>&1
    rmdir ./usr/share/bug/libcuda1 > /dev/null 2>&1
    rmdir ./usr/share/doc > /dev/null 2>&1
    rmdir ./usr/share/doc/libcuda1 > /dev/null 2>&1
    rmdir ./usr/share/lintian > /dev/null 2>&1
    rmdir ./usr/share/lintian/overrides > /dev/null 2>&1

}
_rm_install_libcudadev_stub-stubOnly() {
    rm -f /opt/libcudadev_stub-stubOnly/*.deb
    rm -f /opt/libcudadev_stub-stubOnly/usr/share/doc/libcuda1/copyright
    rm -f /opt/libcudadev_stub-stubOnly/usr/lib/x86_64-linux-gnu/nvidia/current/libcuda*.so*
    _prepare_install_libcudadev_stub-stubOnly "\$@"
}

_rm_install_libcudadev_stub-stubOnly

# https://packages.debian.org/search?keywords=libcuda1&searchon=names&suite=all&section=all
#wget 'http://ftp.nl.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/libcuda1_535.216.01-1~deb12u1_amd64.deb'
#wget 'http://ftp.nl.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/libcuda1_535.216.03-2~bpo12+1_amd64.deb'
wget 'http://ftp.nl.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/libcuda1_535.247.01-1~deb12u1_amd64.deb'


if [[ $(sha256sum *.deb | cut -f1 -d' ' | tr -dc 'a-fA-F0-9') != 'b295098ac989f41481216a25d952d431052d83f7cbf39e6cfa45e5cdf43df5cb' ]]
then
    rm -f ./*.deb
    rm -f /opt/libcudadev_stub-stubOnly/*.deb
    _rm_install_libcudadev_stub-stubOnly
    echo ' FAIL: DANGER: HASH MISMATCH ! '
    exit 1
fi

dpkg-deb -x ./*.deb .

mkdir -p /usr/lib/x86_64-linux-gnu/nvidia/current/

cp -f /opt/libcudadev_stub-stubOnly/usr/lib/x86_64-linux-gnu/nvidia/current/libcuda*.so* /usr/lib/x86_64-linux-gnu/nvidia/current/
chmod 644 /usr/lib/x86_64-linux-gnu/nvidia/current/libcuda*.so*

mkdir -p /usr/share/doc/libcuda1/
cp -f /opt/libcudadev_stub-stubOnly/usr/share/doc/libcuda1/copyright /usr/share/doc/libcuda1/


#rm ...
#_rm_install_libcudadev_stub-stubOnly
_prepare_install_libcudadev_stub-stubOnly

ldconfig

# ###
# PASTE
# ###

EOFSPECIAL
RUN chmod u+x /install_libcudadev_stub.sh ;\ 
bash /install_libcudadev_stub.sh

CZXWXcRMTo8EmM8i4d
}


# WARNING: May require NVIDIA CUDA toolkit (ie. maybe begin with FROM Docker image with CUDA toolkit installed).
_here_dockerfile-llamacpp() {
# Expects _here_dockerfile-ubiquitous .
cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

RUN env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y coreutils


# https://github.com/ggml-org/llama.cpp/blob/master/docs/install.md

# https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md
#echo $( [[ $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) -le $(( $(nproc)/1 )) ]] && echo $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) || $(( $(nproc)/1 )) )
#RUN ( cd /opt/llama.cpp ; cmake --build build --config Release -j 3 )
#RUN ( cd /opt/llama.cpp ; cmake --build build --config Release -j $( [[ $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) -le $(( $(nproc)/1 )) ]] && echo $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) || $(( $(nproc)/1 )) ) )
RUN mkdir -p /opt ;\ 
( cd /opt ; git clone https://github.com/ggml-org/llama.cpp ) ;\ 
( cd /opt/llama.cpp ; cmake -B build -DGGML_CUDA=ON ) ;\ 
( cd /opt/llama.cpp ; cmake --build build --config Release -j $( nproc ) )


# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d
}


_here_dockerfile-unsloth() {
# Expects _here_dockerfile-ubiquitous .
cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

RUN env DEBIAN_FRONTEND=noninteractive apt-get update -y

# install llama.cpp from unsloth
RUN env DEBIAN_FRONTEND=noninteractive apt-get install libcurl4-openssl-dev -y


# https://github.com/unslothai/unsloth   (2025-05-07)
#  'Python 3.12'
RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath
RUN env DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install libcurl4-openssl-dev -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install python3.12 -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install python3.12-dev -y
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
RUN update-alternatives --config python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
RUN update-alternatives --config python
RUN curl -sS https://bootstrap.pypa.io/get-pip.py -o - | python3
RUN python3 -m pip install --upgrade pip
RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath
#
#RUN pip install "unsloth"
#RUN pip install --upgrade --force-reinstall --no-cache-dir unsloth unsloth_zoo

# https://github.com/unslothai/unsloth/releases
RUN pip install --upgrade --force-reinstall "unsloth==2025.4.7" unsloth_zoo

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d
}





_here_dockerfile-ubiquitous-documentation() {
    #cat << 'CZXWXcRMTo8EmM8i4d'

# Normally expected redundant. Copyleft license files are normally already preserved at several filesystem locations.

#python3 -m site
# /usr/local/lib/python*/dist-packages
#find /usr/local/lib/python*/dist-packages -iname '*.dist-info'
# /usr/lib/python3/dist-packages
# /usr/share/licenses
# /usr/share/doc
#
#--ignore-packages broken_pkg
#pip-licenses --with-license-file --format=markdown > /licenses/PYTHON_THIRD_PARTY.md
#
#RUN mkdir -p /licenses ;\ 
#pip install -U --no-cache-dir --quiet pip-licenses ;\ 
#pip-licenses --user --with-license-file --format=markdown > /licenses/PYTHON_THIRD_PARTY.md

#CZXWXcRMTo8EmM8i4d




# ATTRIBUTION-AI: codex  model: codex-mini-latest  provider: openai  approval: full-auto  2025-05-31

echo 'COPY <<EOFSPECIAL /install_licenses.py'
cat << 'CZXWXcRMTo8EmM8i4d'
import json, subprocess, glob, os
# 1) get the pip-managed packages
pkgs = json.loads(subprocess.run(
    ['pip','list','--format=json'],
    capture_output=True, text=True
).stdout)
# 2) print a Markdown table header
print('| Name | Version | License | License file |')
print('| ---- | ------- | ------- | ------------ |')
# 3) for each, run `pip show`, parse License+Location, glob for LICENSE*
for pkg in pkgs:
    name, ver = pkg['name'], pkg['version']
    info = subprocess.run(['pip','show', name],
                            capture_output=True, text=True).stdout.splitlines()
    meta = dict(line.split(':',1) for line in info if ':' in line)
    lic = meta.get('License','UNKNOWN').strip()
    loc = meta.get('Location','').strip()
    # look for a LICENSE* file under the package's directory
    pattern = os.path.join(loc, name.replace('-','_')+'*', 'LICEN[CS]E*')
    matches = glob.glob(pattern)
    lic_fp = matches[0] if matches else 'N/A'
    print(f'| {name} | {ver} | {lic} | {lic_fp} |')
CZXWXcRMTo8EmM8i4d
echo 'EOFSPECIAL'

echo 'RUN mkdir -p /licenses ;\ '
echo 'python3 /install_licenses.py > /licenses/PYTHON_THIRD_PARTY.md'

}


_here_dockerfile-ubiquitous-licenses() {
    
    # https://packages.debian.org/bookworm/base-files


    #! mkdir -p "$scriptLocal"/licenses && ( _messageError 'FAIL' >&2 ) > /dev/null && _stop 1

    ##https://web.archive.org/web/20250531033557/https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
    ##https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/LICENSES/preferred/GPL-2.0
    ##/usr/share/common-licenses/GPL-2
    #[[ ! -e "$scriptLocal"/licenses/gpl-2.0.txt ]] && wget --timeout 9 --tries 9 -qO "$scriptLocal"/licenses/gpl-2.0.txt 'https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt'
    #[[ ! -e "$scriptLocal"/licenses/gpl-3.0.txt ]] && wget --timeout 3 --tries 3 -qO "$scriptLocal"/licenses/gpl-3.0.txt 'https://www.gnu.org/licenses/gpl-3.0.txt'
    #[[ ! -e "$scriptLocal"/licenses/agpl-3.0.txt ]] && wget --timeout 3 --tries 3 -qO "$scriptLocal"/licenses/agpl-3.0.txt 'https://www.gnu.org/licenses/agpl-3.0.txt'



    ##echo
    ##echo 'RUN mkdir -p /licenses'
    ##echo

    ##echo 'COPY <<EOFSPECIAL /licenses/gpl-2.0.txt'
##cat "$scriptLocal"/licenses/gpl-2.0.txt
##echo 'EOFSPECIAL'

    ##echo 'COPY <<EOFSPECIAL /licenses/gpl-3.0.txt'
##cat "$scriptLocal"/licenses/gpl-3.0.txt
##echo 'EOFSPECIAL'

    ##echo 'COPY <<EOFSPECIAL /licenses/agpl-3.0.txt'
##cat "$scriptLocal"/licenses/agpl-3.0.txt
##echo 'EOFSPECIAL'

    ##echo


    #echo
    #echo 'RUN mkdir -p /licenses'
    #echo 'COPY <<EOFSPECIAL /licenses/gpl-2.0__gpl-3.0__agpl-3.0.txt'
#cat "$scriptLocal"/licenses/gpl-2.0.txt
#echo
#echo
#echo '------------------------------'
#echo
#echo
#cat "$scriptLocal"/licenses/gpl-3.0.txt
#echo
##echo
#echo '------------------------------'
#echo
#echo
#cat "$scriptLocal"/licenses/agpl-3.0.txt
#echo
#echo 'EOFSPECIAL'

    cat << 'CZXWXcRMTo8EmM8i4d'

RUN env DEBIAN_FRONTEND=noninteractive apt-get install --install-recommends -y base-files ;\ 
mkdir -p /licenses ;\ 
ln -sf /usr/share/common-licenses /licenses/common-licenses



CZXWXcRMTo8EmM8i4d

}

