
# Unusual. Please keep these custom Docker containers to a minimum: essential factories (eg. fine-tuning) only, not application specific dependency containers (eg. databases). Use derivative 'fork' projects of ubiquitous_bash instead.


# WARNING: May be WIP .
_here_dockerfile_runpod-pytorch-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t runpod-pytorch-heavy .
# https://hub.docker.com/r/runpod/pytorch/tags
# https://www.runpod.io/console/deploy
# https://www.runpod.io/console/explore/runpod-torch-v240
# runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04
# runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
# runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
# runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

RUN echo 'runpod-pytorch-heavy' > /info_factoryName.txt

CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

# https://huggingface.co/blog/mlabonne/sft-llama3
# https://huggingface.co/blog/mlabonne/merge-models

RUN python -m pip install --upgrade pip

# ATTRIBUTION-AI: ChatGPT o3 (high)  2025-04-29-...
# ATTRIBUTION-AI: Llama 3.1 Nemotron Utra 253b v1  2025-04-30-...

#RUN apt-get install python3.10 python3.10-dev python3.10-distutils -y
#RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
#RUN update-alternatives --config python3

#RUN curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
#RUN python -m pip install --upgrade pip
#RUN python -m pip install --upgrade pip setuptools wheel


#RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

#RUN pip install "sympy>=1.13.3" "mpmath>=1.3"

## ATTENTION: Up/Down-grades torch , etc , to version 2.3.0 , as is apparently expected by  https://huggingface.co/blog/mlabonne/sft-llama3  .
#RUN pip install torch==2.3.0 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 triton==2.3.0 --index-url https://download.pytorch.org/whl/cu121

#RUN python -m pip install --upgrade pip



#RUN pip install unsloth_zoo==2025.3.12
#RUN pip install --no-deps unsloth_zoo==2025.3.12

#"unsloth @ git+https://github.com/unslothai/unsloth.git"
#RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"
#RUN PIP_PREFER_BINARY=1 pip install --prefer-binary --no-build-isolation "unsloth[cu121-torch230]"
#RUN pip install "unsloth"

#RUN pip install --no-deps "xformers<0.0.27" "trl<0.9.0" peft accelerate bitsandbytes
#RUN pip install torch torchvision torchaudio

#RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

_here_dockerfile-libcudadev_stub "$@"
_here_dockerfile-llamacpp "$@"

#_here_dockerfile-unsloth "$@"

_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
CMD ["/start.sh"]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_runpod-pytorch-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=runpod-pytorch-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=runpod-pytorch-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force runpod-pytorch-heavy > /dev/null 2>&1

    cd "$safeTmp"

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    
    _messagePlain_probe 'docker build -t'
    _here_dockerfile_runpod-pytorch-heavy > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History
    

    # ATTENTION: Add to '~/_bashrc' or similar .
    #  Indeed '_bashrc' , NOT '.bashrc' .
    # ATTRIBUTION-AI ChatGPT o3 (high)  2025-04-30
    #
    ##docker buildx rm cloud-user-default
    ##docker buildx prune --builder cloud-user-default
    #
    #export DOCKER_USER="user"
    #DOCKER_RAW_NAME="$DOCKER_USER""/default"          # what you type
    #DOCKER_BUILDER_NAME="cloud-$(echo "$DOCKER_RAW_NAME" | tr '/:' '-')"
    #if docker buildx ls --format '{{.Name}}' | grep -qx "$DOCKER_BUILDER_NAME"; then
        #docker buildx use "$DOCKER_BUILDER_NAME"        # reuse
    #else
        #docker buildx create --driver cloud "$DOCKER_RAW_NAME" --use
    #fi


    #if [[ "$DOCKER_BUILDER_NAME" == "" ]]
    #then
        docker build -t runpod-pytorch-heavy .
        docker tag runpod-pytorch-heavy "$DOCKER_USER"/runpod-pytorch-heavy:latest
    #else
        #if [[ "$DOCKER_BUILDER_NAME" != "" ]]
        #then
            # https://docs.docker.com/build-cloud/usage/
            #docker buildx build --builder "$DOCKER_BUILDER_NAME" -t runpod-pytorch-heavy . --push
        #fi
    #fi

    #docker push user/runpod-pytorch-heavy:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_runpod-pytorch-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_runpod-pytorch-heavy "$@"
}








_here_dockerfile_runpod-pytorch-unsloth() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t runpod-pytorch-unsloth .
# https://hub.docker.com/r/runpod/pytorch/tags
# https://www.runpod.io/console/deploy
# https://www.runpod.io/console/explore/runpod-torch-v240
# runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04
# runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
# runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
# runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

RUN echo 'runpod-pytorch-unsloth' > /info_factoryName.txt
RUN echo '# Please read researchEngine documentation for (hopefully) stabilized examples .' >> /info_factoryMOTD.txt
RUN echo 'ubiquitous_bash=~/.ubcore/ubiquitous_bash ; vim -R "'"\$ubiquitous_bash"'"/_lib/kit/app/researchEngine/_dev/README-FACTORY-unsloth.md' >> /info_factoryMOTD.txt
RUN chmod 755 /info_factoryMOTD.txt

CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

# https://huggingface.co/blog/mlabonne/sft-llama3
# https://huggingface.co/blog/mlabonne/merge-models

RUN python -m pip install --upgrade pip

# ATTRIBUTION-AI: ChatGPT o3 (high)  2025-04-29-...
# ATTRIBUTION-AI: Llama 3.1 Nemotron Utra 253b v1  2025-04-30-...

#RUN apt-get install python3.10 python3.10-dev python3.10-distutils -y
#RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
#RUN update-alternatives --config python3

#RUN curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
#RUN python -m pip install --upgrade pip
#RUN python -m pip install --upgrade pip setuptools wheel


#RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

#RUN pip install "sympy>=1.13.3" "mpmath>=1.3"

## ATTENTION: Up/Down-grades torch , etc , to version 2.3.0 , as is apparently expected by  https://huggingface.co/blog/mlabonne/sft-llama3  .
#RUN pip install torch==2.3.0 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 triton==2.3.0 --index-url https://download.pytorch.org/whl/cu121

#RUN python -m pip install --upgrade pip



#RUN pip install unsloth_zoo==2025.3.12
#RUN pip install --no-deps unsloth_zoo==2025.3.12

#"unsloth @ git+https://github.com/unslothai/unsloth.git"
#RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"
#RUN PIP_PREFER_BINARY=1 pip install --prefer-binary --no-build-isolation "unsloth[cu121-torch230]"
#RUN pip install "unsloth"

#RUN pip install --no-deps "xformers<0.0.27" "trl<0.9.0" peft accelerate bitsandbytes
#RUN pip install torch torchvision torchaudio

#RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

_here_dockerfile-libcudadev_stub "$@"
_here_dockerfile-llamacpp "$@"

_here_dockerfile-unsloth "$@"

_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
CMD ["/start.sh"]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_runpod-pytorch-unsloth() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=runpod-pytorch-unsloth 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=runpod-pytorch-unsloth 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force runpod-pytorch-unsloth > /dev/null 2>&1

    cd "$safeTmp"

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    
    _messagePlain_probe 'docker build -t'
    _here_dockerfile_runpod-pytorch-unsloth > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History
    

    # ATTENTION: Add to '~/_bashrc' or similar .
    #  Indeed '_bashrc' , NOT '.bashrc' .
    # ATTRIBUTION-AI ChatGPT o3 (high)  2025-04-30
    #
    ##docker buildx rm cloud-user-default
    ##docker buildx prune --builder cloud-user-default
    #
    #export DOCKER_USER="user"
    #DOCKER_RAW_NAME="$DOCKER_USER""/default"          # what you type
    #DOCKER_BUILDER_NAME="cloud-$(echo "$DOCKER_RAW_NAME" | tr '/:' '-')"
    #if docker buildx ls --format '{{.Name}}' | grep -qx "$DOCKER_BUILDER_NAME"; then
        #docker buildx use "$DOCKER_BUILDER_NAME"        # reuse
    #else
        #docker buildx create --driver cloud "$DOCKER_RAW_NAME" --use
    #fi


    #if [[ "$DOCKER_BUILDER_NAME" == "" ]]
    #then
        docker build -t runpod-pytorch-unsloth .
        docker tag runpod-pytorch-unsloth "$DOCKER_USER"/runpod-pytorch-unsloth:latest
    #else
        #if [[ "$DOCKER_BUILDER_NAME" != "" ]]
        #then
            # https://docs.docker.com/build-cloud/usage/
            #docker buildx build --builder "$DOCKER_BUILDER_NAME" -t runpod-pytorch-unsloth . --push
        #fi
    #fi

    #docker push user/runpod-pytorch-unsloth:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_runpod-pytorch-unsloth() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_runpod-pytorch-unsloth "$@"
}


















_here_dockerfile_runpod-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t runpod-heavy .
# https://hub.docker.com/r/runpod/base/tags?name=cpu
# https://www.runpod.io/console/deploy
# https://www.runpod.io/console/explore/runpod-ubuntu
# runpod/base:0.5.1-cpu
FROM runpod/base:0.6.2-cpu

RUN echo 'runpod-heavy' > /info_factoryName.txt



# ATTRIBUTION-AI: ChatGPT 4o  2025-05-06

RUN apt-get update -y
RUN apt install wget -y

RUN mkdir -p -m 755 /etc/apt/keyrings

RUN wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
RUN chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN apt update
RUN apt install gh



CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

# https://huggingface.co/blog/mlabonne/sft-llama3
# https://huggingface.co/blog/mlabonne/merge-models

#RUN python -m pip install --upgrade pip


# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

#_here_dockerfile-libcudadev_stub "$@"

# DUBIOUS.
#_here_dockerfile-llamacpp "$@"

# DUBIOUS.
#_here_dockerfile-unsloth "$@"

# No Python, etc, added .
#_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT [""]
CMD ["/start.sh"]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_runpod-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=runpod-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=runpod-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force runpod-heavy > /dev/null 2>&1

    cd "$safeTmp"

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    _messagePlain_probe 'docker build -t'
    _here_dockerfile_runpod-heavy > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History

    docker build -t runpod-heavy .
    docker tag runpod-heavy "$DOCKER_USER"/runpod-heavy:latest

    #docker push user/runpod-heavy:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_runpod-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_runpod-heavy "$@"
}
























_here_dockerfile_axolotl-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t axolotl-heavy .
FROM axolotlai/axolotl:main-latest

RUN echo 'axolotl-heavy' > /info_factoryName.txt
RUN echo '# Please read researchEngine documentation for (hopefully) stabilized examples .' >> /info_factoryMOTD.txt
RUN echo 'ubiquitous_bash=~/.ubcore/ubiquitous_bash ; vim -R "'"\$ubiquitous_bash"'"/_lib/kit/app/researchEngine/_dev/README-FACTORY-axolotl.md' >> /info_factoryMOTD.txt
RUN chmod 755 /info_factoryMOTD.txt

CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###


RUN python -m pip install --upgrade pip

#RUN apt-get install python3.10 python3.10-dev python3.10-distutils -y
#RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
#RUN update-alternatives --config python3

#RUN curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
#RUN python -m pip install --upgrade pip
#RUN python -m pip install --upgrade pip setuptools wheel


#RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

#RUN pip install "sympy>=1.13.3" "mpmath>=1.3"

## ATTENTION: Up/Down-grades torch , etc , to version 2.3.0 , as is apparently expected by  https://huggingface.co/blog/mlabonne/sft-llama3  .
#RUN pip install torch==2.3.0 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 triton==2.3.0 --index-url https://download.pytorch.org/whl/cu121

#RUN python -m pip install --upgrade pip



# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

_here_dockerfile-libcudadev_stub "$@"
_here_dockerfile-llamacpp "$@"

# DUBIOUS.
#_here_dockerfile-unsloth "$@"

_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
#CMD ["/start.sh"]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_axolotl-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=axolotl-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=axolotl-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force axolotl-heavy > /dev/null 2>&1

    cd "$safeTmp"

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    
    _messagePlain_probe 'docker build -t'
    _here_dockerfile_axolotl-heavy > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History
    
    docker build -t axolotl-heavy .
    docker tag axolotl-heavy "$DOCKER_USER"/axolotl-heavy:latest

    #docker push user/axolotl-heavy:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_axolotl-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_axolotl-heavy "$@"
}






















# https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/llama_nemotron.html

# https://github.com/dominodatalab/nvidia-nemotron-finetuning

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nemo
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nemo/tags

_here_dockerfile_nvidia_nemo-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t nvidia_nemo-heavy .
FROM nvcr.io/nvidia/nemo:25.04
#nvcr.io/nvidia/nemo:dev
#nvcr.io/nvidia/nemo:25.04
#nvcr.io/nvidia/nemo:24.01.framework


RUN echo 'nvidia_nemo-heavy' > /info_factoryName.txt ;\ 
echo '# Please read researchEngine documentation for (hopefully) stabilized examples .' >> /info_factoryMOTD.txt ;\ 
echo 'ubiquitous_bash=~/.ubcore/ubiquitous_bash ; vim -R "'"\$ubiquitous_bash"'"/_lib/kit/app/researchEngine/_dev/README-FACTORY-nvidia_nemo.md' >> /info_factoryMOTD.txt ;\ 
chmod 755 /info_factoryMOTD.txt

CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###


RUN python -m pip install --upgrade pip

#RUN pip3 install --upgrade git+https://github.com/huggingface/transformers.git


# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

# ATTENTION: TODO: Desirable if not already present !
#_here_dockerfile-libcudadev_stub "$@"
#_here_dockerfile-llamacpp "$@"

# DUBIOUS.
#_here_dockerfile-unsloth "$@"

_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
#CMD ["/start.sh"]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_nvidia_nemo-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=nvidia_nemo-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=nvidia_nemo-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force nvidia_nemo-heavy > /dev/null 2>&1

    cd "$safeTmp"

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    
    _messagePlain_probe 'docker build -t'
    _here_dockerfile_nvidia_nemo-heavy > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History
    
    docker build -t nvidia_nemo-heavy .
    docker tag nvidia_nemo-heavy "$DOCKER_USER"/nvidia_nemo-heavy:latest

    #docker push user/nvidia_nemo-heavy:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_nvidia_nemo-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_nvidia_nemo-heavy "$@"
}





















_here_dockerfile_openai-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t openai-heavy .

# https://github.com/openai/codex-universal
FROM ghcr.io/openai/codex-universal

RUN echo 'openai-heavy' > /info_factoryName.txt
##RUN echo '# Please read researchEngine documentation for (hopefully) stabilized examples .' >> /info_factoryMOTD.txt
##RUN echo 'ubiquitous_bash=~/.ubcore/ubiquitous_bash ; vim -R "'"\$ubiquitous_bash"'"/_lib/kit/app/researchEngine/_dev/README-FACTORY-openai.md' >> /info_factoryMOTD.txt
#RUN echo ' request: _setup_ollama ; apt-get install ... _getMinimal_special comments... ' >> /info_factoryMOTD.txt
#RUN chmod 755 /info_factoryMOTD.txt

CZXWXcRMTo8EmM8i4d

_here_dockerfile-ubiquitous "$@"

echo 'ARG CACHEBUST=1'
echo 'RUN echo CACHEBUST... '$(_uid)' > /dev/null'
echo 'RUN ( cd ~/.ubcore/ubiquitous_bash ; ./ubiquitous_bash.sh _gitBest pull )'
if _if_cygwin
then
    echo 'COPY [ "\\ubiquitous_bash.sh", "/root/.ubcore/ubiquitous_bash/ubiquitous_bash.sh" ]'
else
    echo 'COPY [ "/ubiquitous_bash.sh", "~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh" ]'
fi

cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

#RUN python -m pip install --upgrade pip

RUN ~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_special

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d

_here_dockerfile-libcudadev_stub "$@"
#_here_dockerfile-llamacpp "$@"

_here_dockerfile-ubiquitous-documentation "$@"

_here_dockerfile-ubiquitous-licenses "$@"


cat << 'CZXWXcRMTo8EmM8i4d'

WORKDIR /

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD [""]

CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_openai-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=openai-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=openai-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force openai-heavy > /dev/null 2>&1

    cd "$safeTmp"
    cp "$scriptAbsoluteFolder"/ubiquitous_bash.sh "$safeTmp"/ubiquitous_bash.sh

    if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #mkdir -p "$safeTmp"/repo/"$objectName"
        #cp -a "$scriptAbsoluteFolder"/.git "$safeTmp"/repo/"$objectName"/
        #( cd "$safeTmp"/repo/"$objectName" ; "$scriptAbsoluteLocation" _gitBest reset --hard ; git submodule update --init --recursive ; find .git -iname 'config' -exec sed -i '/extraheader = AUTHORIZATION:/d' {} \; )
        ( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        export safeToDeleteGit="true"
    fi


    
    _messagePlain_probe 'docker build -t'
    _here_dockerfile_openai-heavy > Dockerfile

    # WARNING: CAUTION: DANGER: Docker is yet another third-party service dependency. Do NOT regard Docker's repository as archival preservation, and do NOT rely on Docker itself for archival preservation. Also, it is not clear whether a Docker 'image' based on 'Dockerfile' can be directly preserved without environment dependencies or unintentional updates, at best a root filesystem may be possible to obtain from a Docker 'image'.
    # https://en.wikipedia.org/w/index.php?title=Docker,_Inc.&oldid=1285260999#History
    # https://en.wikipedia.org/w/index.php?title=Docker_(software)&oldid=1286977923#History
    

    # ATTENTION: Add to '~/_bashrc' or similar .
    #  Indeed '_bashrc' , NOT '.bashrc' .
    # ATTRIBUTION-AI ChatGPT o3 (high)  2025-04-30
    #
    ##docker buildx rm cloud-user-default
    ##docker buildx prune --builder cloud-user-default
    #
    #export DOCKER_USER="user"
    #DOCKER_RAW_NAME="$DOCKER_USER""/default"          # what you type
    #DOCKER_BUILDER_NAME="cloud-$(echo "$DOCKER_RAW_NAME" | tr '/:' '-')"
    #if docker buildx ls --format '{{.Name}}' | grep -qx "$DOCKER_BUILDER_NAME"; then
        #docker buildx use "$DOCKER_BUILDER_NAME"        # reuse
    #else
        #docker buildx create --driver cloud "$DOCKER_RAW_NAME" --use
    #fi


    #if [[ "$DOCKER_BUILDER_NAME" == "" ]]
    #then
        docker build --debug -t openai-heavy .
        docker tag openai-heavy "$DOCKER_USER"/openai-heavy:latest
    #else
        #if [[ "$DOCKER_BUILDER_NAME" != "" ]]
        #then
            # https://docs.docker.com/build-cloud/usage/
            #docker buildx build --builder "$DOCKER_BUILDER_NAME" -t openai-heavy . --push
        #fi
    #fi

    #docker push user/openai-heavy:latest

    #export safeToDeleteGit="true"
    _safeRMR "$safeTmp"/repo

    cd "$functionEntryPWD"
    _stop
}
__factoryCreate_openai-heavy() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    "$scriptAbsoluteLocation" __factoryCreate_sequence_openai-heavy "$@"
}








