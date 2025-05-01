
# Unusual. Please keep these custom Docker containers to a minimum: essential factories (eg. fine-tuning) only, not application specific dependency containers (eg. databases). Use derivative 'fork' projects of ubiquitous_bash instead.


_here_dockerfile_runpod-pytorch-heavy() {

cat << 'CZXWXcRMTo8EmM8i4d'
#docker build -t runpod-pytorch-heavy .
# https://hub.docker.com/r/runpod/pytorch/tags
# https://www.runpod.io/console/deploy
# https://www.runpod.io/console/explore/runpod-torch-v240
# runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04
# runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
# runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
# runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# ###
# PASTE
# ###

# https://www.docker.com/blog/introduction-to-heredocs-in-dockerfiles/
COPY <<EOFSPECIAL /ubInstall.sh

#!/usr/bin/env bash
if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
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
fi
#clear

EOFSPECIAL
RUN chmod u+x /ubInstall.sh
RUN /ubInstall.sh




# https://huggingface.co/blog/mlabonne/sft-llama3
# https://huggingface.co/blog/mlabonne/merge-models

RUN python -m pip install --upgrade pip

# ATTRIBUTION-AI: ChatGPT o3 (high)  2025-04-29-...
# ATTRIBUTION-AI: Llama 3.1 Nemotron Utra 253b v1  2025-04-30-...


RUN apt-get update
RUN apt upgrade -y
RUN apt-get install sudo -y
RUN apt-get install python3.10 python3.10-dev python3.10-distutils -y
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN update-alternatives --config python3

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel



RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

RUN pip install "sympy>=1.13.3" "mpmath>=1.3"

# ATTENTION: Up/Down-grades torch , etc , to version 2.3.0 , as is apparently expected by  https://huggingface.co/blog/mlabonne/sft-llama3  .
RUN pip install torch==2.3.0 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 triton==2.3.0 --index-url https://download.pytorch.org/whl/cu121

RUN python -m pip install --upgrade pip



#RUN pip install unsloth_zoo==2025.3.12
#RUN pip install --no-deps unsloth_zoo==2025.3.12

#"unsloth @ git+https://github.com/unslothai/unsloth.git"
#RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"
RUN PIP_PREFER_BINARY=1 pip install --prefer-binary --no-build-isolation "unsloth[cu121-torch230]"
#RUN pip install "unsloth"

RUN pip install --no-deps "xformers<0.0.27" "trl<0.9.0" peft accelerate bitsandbytes
#RUN pip install torch torchvision torchaudio




WORKDIR /

# ###
# PASTE
# ###

#docker image inspect ...FROM... --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
ENTRYPOINT ["/opt/nvidia/nvidia_entrypoint.sh"]
CMD ["/start.sh"]
CZXWXcRMTo8EmM8i4d

}
__factoryCreate_sequence_runpod-pytorch-heavy() {
    _start

    # ATTRIBUTION-AI Llama 3.1 Nemotron Ultra 253b v1
    docker stop $(docker ps -aq --filter ancestor=runpod-pytorch-heavy 2>/dev/null) > /dev/null 2>&1
    #docker rm $(docker ps -aq --filter ancestor=runpod-pytorch-heavy 2>/dev/null) > /dev/null 2>&1

    _messagePlain_probe 'docker rmi --force'
    docker rmi --force runpod-pytorch-heavy > /dev/null 2>&1

    cd "$safeTmp"
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

    _stop
}
__factoryCreate_runpod-pytorch-heavy() {
    "$scriptAbsoluteLocation" __factoryCreate_sequence_runpod-pytorch-heavy "$@"
}


