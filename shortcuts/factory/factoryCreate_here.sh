
_here_dockerfile-ubiquitous() {
cat << 'CZXWXcRMTo8EmM8i4d'

# https://www.docker.com/blog/introduction-to-heredocs-in-dockerfiles/
COPY <<EOFSPECIAL /install_ub.sh
#!/usr/bin/env bash

# ###
# PASTE
# ###

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
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
RUN chmod u+x /install_ub.sh
RUN bash /install_ub.sh


# ###
# PASTE
# ###

RUN env DEBIAN_FRONTEND=noninteractive apt-get update
RUN env DEBIAN_FRONTEND=noninteractive apt upgrade -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install sudo -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install less -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install pv -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install socat -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install bc -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install xxd -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install php -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install jq -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install gh -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install aria2 -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install curl wget -y
#RUN env DEBIAN_FRONTEND=noninteractive apt-get install xz -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install xz-utils -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install tar bzip2 gzip -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install sed patch expect -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get install dos2unix -y

# nohup - _service_ollama , _service_ollama_augment
RUN env DEBIAN_FRONTEND=noninteractive apt-get install coreutils -y

# https://www.hostinger.com/tutorials/how-to-install-ollama
RUN apt install python3 python3-pip git -y

# install llama.cpp from unsloth
RUN apt-get install libcurl4-openssl-dev -y


RUN env DEBIAN_FRONTEND=noninteractive apt-get install sudo -y
RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud


# DISCOURAGED. Better to benefit from 'ubiquitous_bash' maintenance identifying the most recent ollama installation commands. 
#RUN curl -fsSL https://ollama.com/install.sh | sh
# DISCOURAGED. Does NOT install Llama-augment model.
RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama_sequence
RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _service_ollama
# PREFERRED. Normally robust, resilient, maintained, and adds the 'Llama-augment' model for automation, etc.
#RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama


RUN env DEBIAN_FRONTEND=noninteractive apt-get -y clean
#RUN env DEBIAN_FRONTEND=noninteractive apt-get remove --autoremove -y

# ###
# PASTE
# ###

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
RUN mkdir -p /opt
RUN ( cd /opt ; git clone https://github.com/ggml-org/llama.cpp )
RUN ( cd /opt/llama.cpp ; cmake -B build -DGGML_CUDA=ON )
#echo $( [[ $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) -le $(( $(nproc)/1 )) ]] && echo $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) || $(( $(nproc)/1 )) )
#RUN ( cd /opt/llama.cpp ; cmake --build build --config Release -j 3 )
RUN ( cd /opt/llama.cpp ; cmake --build build --config Release -j $( [[ $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) -le $(( $(nproc)/1 )) ]] && echo $(( $(taskset -p $$ | awk '{print $NF}' | tr -dc 'f' | wc -c)/1 )) || $(( $(nproc)/1 )) ) )


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
    cat << 'CZXWXcRMTo8EmM8i4d'

# Normally expected redundant. Copyleft license files are normally already preserved at several filesystem locations.
#python3 -m site
# /usr/local/lib/python*/dist-packages
#find /usr/local/lib/python*/dist-packages -iname '*.dist-info'
# /usr/lib/python3/dist-packages
# /usr/share/licenses
# /usr/share/doc
#
RUN mkdir -p /licenses
RUN pip install --no-cache-dir --quiet pip-licenses
RUN pip-licenses --with-license-file --format=markdown > /licenses/PYTHON_THIRD_PARTY.md

CZXWXcRMTo8EmM8i4d
}


_here_dockerfile-ubiquitous-licenses() {

    ! mkdir -p "$scriptLocal"/licenses && ( _messageError 'FAIL' >&2 ) > /dev/null && _stop 1

    [[ ! -e "$scriptLocal"/licenses/gpl-2.0.txt ]] && wget -qO "$scriptLocal"/licenses/gpl-2.0.txt 'https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt'
    [[ ! -e "$scriptLocal"/licenses/gpl-3.0.txt ]] && wget -qO "$scriptLocal"/licenses/gpl-3.0.txt 'https://www.gnu.org/licenses/gpl-3.0.txt'
    [[ ! -e "$scriptLocal"/licenses/agpl-3.0.txt ]] && wget -qO "$scriptLocal"/licenses/agpl-3.0.txt 'https://www.gnu.org/licenses/agpl-3.0.txt'



    echo
    echo 'RUN mkdir -p /licenses'
    echo

    echo 'COPY <<EOFSPECIAL /licenses/gpl-2.0.txt'
cat "$scriptLocal"/licenses/gpl-2.0.txt
echo 'EOFSPECIAL'

    echo 'COPY <<EOFSPECIAL /licenses/gpl-3.0.txt'
cat "$scriptLocal"/licenses/gpl-3.0.txt
echo 'EOFSPECIAL'

    echo 'COPY <<EOFSPECIAL /licenses/agpl-3.0.txt'
cat "$scriptLocal"/licenses/agpl-3.0.txt
echo 'EOFSPECIAL'

    echo

}

