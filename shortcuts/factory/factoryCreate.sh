
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
FROM runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

#https://huggingface.co/blog/mlabonne/sft-llama3
#https://huggingface.co/blog/mlabonne/merge-models

RUN python -m pip install --upgrade pip
RUN pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git"
RUN pip install --no-deps "xformers<0.0.27" "trl<0.9.0" peft accelerate bitsandbytes

WORKDIR /

#docker image inspect runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04 --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'
CMD ["/opt/nvidia/nvidia_entrypoint.sh"]
CZXWXcRMTo8EmM8i4d

}


__factoryCreate_sequence_runpod-pytorch-heavy() {
    _start

    cd "$safeTmp"
    _here_dockerfile_runpod-pytorch-heavy > Dockerfile
    docker build -t runpod-pytorch-heavy .

    _stop
}

__factoryCreate_runpod-pytorch-heavy() {
    "$scriptAbsoluteLocation" __factoryCreate_sequence_runpod-pytorch-heavy "$@"
}


