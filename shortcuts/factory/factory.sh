
# ATTENTION: Indentation, commenting, etc, is intended to allow copy/paste to scratch text files for copy/paste to terminal.

#. shortcuts/factory/factory.sh ; _factory_axolotl

# ATTRIBUTION-AI: AI LLMs, may have suggested some parameters for some commands.

_set_factory_dir() {



# ###
# PASTE
# ###

! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

factory_projectDir=$(_getAbsoluteLocation .)
#if [[ "$factory_projectDir" != '/cygdrive/c/q/p/zFactory/Llama-tech' ]] && [[ "$factory_projectDir" != "$HOME"/project/zFactory/Llama-tech ]]
#then
#_messagePlain_warn 'unexpected: factory_projectDir: '"$factory_projectDir"
#_messagePlain_request 'request: Ctrl+C , close terminal, etc, NOW, if this is not what you intended !'
#sleep 45
#echo 'DANGER: proceeding! '
#fi
[[ "$factory_projectDir" == '/cygdrive'* ]] && factory_projectDir=$(cygpath -w "$factory_projectDir")

factory_modelDir="$factory_projectDir"/model
[[ -e ./_local/model ]] && factory_modelDir="$factory_projectDir"/_local/model
factory_outputDir="$factory_projectDir"/output
[[ -e ./_local/output ]] && factory_outputDir="$factory_projectDir"/_local/output

factory_datasetDir='/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/dataset'
[[ -e ./dataset ]] && factory_datasetDir="$factory_projectDir"/dataset
[[ -e ./_local/dataset ]] && factory_datasetDir="$factory_projectDir"/_local/dataset

factory_knowledgeDir='/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/knowledge'
[[ -e ./knowledge ]] && factory_knowledgeDir="$factory_projectDir"/knowledge
[[ -e ./_local/knowledge ]] && factory_knowledgeDir="$factory_projectDir"/_local/knowledge

factory_knowledge_distillDir='/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/knowledge_distill'
[[ -e ./knowledge_distill ]] && factory_knowledge_distillDir="$factory_projectDir"/knowledge_distill
[[ -e ./_local/knowledge_distill ]] && factory_knowledge_distillDir="$factory_projectDir"/_local/knowledge_distill

# ###
# PASTE
# ###



}



_factory_axolotl() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

dockerName='axolotlai/axolotl:main-latest'

docker pull "$dockerName"

entrypoint=$(docker inspect -f '{{join .Config.Entrypoint " "}}' "$dockerName")
cmd=$(docker inspect -f '{{join .Config.Cmd " "}}' "$dockerName")
workdir=$(docker inspect -f '{{.Config.WorkingDir}}' "$dockerName")
_messagePlain_request 'request: paste ->'
echo > ./._run-factory_axolotl
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_axolotl
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_axolotl
_request_paste_factory-show_finetune | tee -a ./._run-factory_axolotl
#docker inspect --format='{{json .Config.Entrypoint}}' "$dockerName" | jq -r '.[]' | tee -a ./._run-factory_axolotl
mkdir -p "$workdir" | tee -a ./._run-factory_axolotl
echo '[ -n '"$workdir"' ] && cd '"$workdir" | tee -a ./._run-factory_axolotl
#echo "exec ${entrypoint} ${cmd}" | tee -a ./._run-factory_axolotl
echo "exec ${entrypoint}" | tee -a ./._run-factory_axolotl
#echo 'bash -i' >> ./._run-factory_axolotl
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect "$dockerName" --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_axolotl )
[[ ! -e ./._run-factory_axolotl ]] && dockerRunArgs=( )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name axolotl-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\q\p\zCore\infrastructure\ubiquitous_bash':/workspace/ubiquitous_bash:ro -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name axolotl-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v "$HOME"/core/infrastructure/ubiquitous_bash:/workspace/ubiquitous_bash:ro -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}




_factory_runpod-official() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

# https://hub.docker.com/r/runpod/pytorch/tags
# https://www.runpod.io/console/deploy
# https://www.runpod.io/console/explore/runpod-torch-v240
# runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04
# runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
# runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
# runpod/pytorch:2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04
dockerName='runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04'

[[ JUPYTER_PASSWORD == "" ]] && export JUPYTER_PASSWORD=$(openssl rand 768 | base64 | tr -dc 'a-zA-Z0-9' | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "24")

docker pull "$dockerName"

entrypoint=$(docker inspect -f '{{join .Config.Entrypoint " "}}' "$dockerName")
cmd=$(docker inspect -f '{{join .Config.Cmd " "}}' "$dockerName")
workdir=$(docker inspect -f '{{.Config.WorkingDir}}' "$dockerName")
_messagePlain_request 'request: paste ->'
echo > ./._run-factory_runpod
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_runpod
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_runpod
_request_paste_factory-show_finetune | tee -a ./._run-factory_runpod
_messagePlain_request 'request: JUPYTER_PASSWORD: '"$JUPYTER_PASSWORD"
#docker inspect --format='{{json .Config.Entrypoint}}' "$dockerName" | jq -r '.[]' | tee -a ./._run-factory_runpod
mkdir -p "$workdir" | tee -a ./._run-factory_runpod
echo '[ -n '"$workdir"' ] && cd '"$workdir" | tee -a ./._run-factory_runpod
#echo "exec ${entrypoint} ${cmd}" | tee -a ./._run-factory_runpod
echo "exec ${entrypoint}" | tee -a ./._run-factory_runpod
#echo 'bash -i' >> ./._run-factory_runpod
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect "$dockerName" --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_runpod )
[[ ! -e ./._run-factory_runpod ]] && dockerRunArgs=( bash )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\q\p\zCore\infrastructure\ubiquitous_bash':/workspace/ubiquitous_bash:ro -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v "$HOME"/core/infrastructure/ubiquitous_bash:/workspace/ubiquitous_bash:ro -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}




_factory_runpod-heavy() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

dockerName='runpod-pytorch-heavy'
#docker pull ghcr.io/mirage335-colossus/"$dockerName":latest

# Prefer local build .
if [[ $(docker images -q "$dockerName" | tr -dc 'a-zA-Z0-9') == "" ]]
then
    # Fallback to something from Docker Hub .
    [[ $(docker images -q "mirage335-colossus/ubiquitous_bash/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335-colossus/ubiquitous_bash/""$dockerName"
    [[ $(docker images -q "mirage335-colossus/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335-colossus/""$dockerName"
    [[ $(docker images -q "mirage335/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335/""$dockerName"

    # Prefer something from GHCR .
    [[ $(docker images -q "ghcr.io/mirage335-colossus/ubiquitous_bash/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335-colossus/ubiquitous_bash/""$dockerName"
    [[ $(docker images -q "ghcr.io/mirage335-colossus/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335-colossus/""$dockerName"
    [[ $(docker images -q "ghcr.io/mirage335/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335/""$dockerName"
fi

if ! docker images | tail -n+2 | grep '^'"$dockerName" > /dev/null 2>&1
then
    _messagePlain_bad 'bad: FAIL: missing: '"$dockerName"
    _messagePlain_request 'request: 'docker pull ghcr.io/mirage335-colossus/"$dockerName":latest
    _messageError 'FAIL'
    return 1
fi

[[ JUPYTER_PASSWORD == "" ]] && export JUPYTER_PASSWORD=$(openssl rand 768 | base64 | tr -dc 'a-zA-Z0-9' | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "24")

#docker pull "$dockerName"

entrypoint=$(docker inspect -f '{{join .Config.Entrypoint " "}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
cmd=$(docker inspect -f '{{join .Config.Cmd " "}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
workdir=$(docker inspect -f '{{.Config.WorkingDir}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
_messagePlain_request 'request: paste ->'
echo > ./._run-factory_runpod
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_runpod
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_runpod
_request_paste_factory-show_finetune | tee -a ./._run-factory_runpod
_messagePlain_request 'request: JUPYTER_PASSWORD: '"$JUPYTER_PASSWORD"
#docker inspect --format='{{json .Config.Entrypoint}}' "$dockerName" | jq -r '.[]' | tee -a ./._run-factory_runpod
mkdir -p "$workdir" | tee -a ./._run-factory_runpod
echo '[ -n '"$workdir"' ] && cd '"$workdir" | tee -a ./._run-factory_runpod
#echo "exec ${entrypoint} ${cmd}" | tee -a ./._run-factory_runpod
echo "exec ${entrypoint}" | tee -a ./._run-factory_runpod
#echo 'bash -i' >> ./._run-factory_runpod
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect "$dockerName" --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_runpod )
[[ ! -e ./._run-factory_runpod ]] && dockerRunArgs=( bash )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\q\p\zCore\infrastructure\ubiquitous_bash':/workspace/ubiquitous_bash:ro -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v "$HOME"/core/infrastructure/ubiquitous_bash:/workspace/ubiquitous_bash:ro -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}
_factory_runpod() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    #_factory_runpod-heavy "$@"
    _factory_runpod-official "$@"
}



# https://hub.docker.com/u/langchain










_factory_runpod-unsloth() {
if [[ "$recursionGuard_factory_ops" == "" ]]
then
_factory_ops_recursion "$@"
return
fi

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

dockerName='runpod-pytorch-unsloth'
#docker pull ghcr.io/mirage335-colossus/"$dockerName":latest

# Prefer local build .
if [[ $(docker images -q "$dockerName" | tr -dc 'a-zA-Z0-9') == "" ]]
then
    # Fallback to something from Docker Hub .
    [[ $(docker images -q "mirage335-colossus/ubiquitous_bash/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335-colossus/ubiquitous_bash/""$dockerName"
    [[ $(docker images -q "mirage335-colossus/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335-colossus/""$dockerName"
    [[ $(docker images -q "mirage335/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="mirage335/""$dockerName"

    # Prefer something from GHCR .
    [[ $(docker images -q "ghcr.io/mirage335-colossus/ubiquitous_bash/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335-colossus/ubiquitous_bash/""$dockerName"
    [[ $(docker images -q "ghcr.io/mirage335-colossus/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335-colossus/""$dockerName"
    [[ $(docker images -q "ghcr.io/mirage335/""$dockerName" | tr -dc 'a-zA-Z0-9') != "" ]] && dockerName="ghcr.io/mirage335/""$dockerName"
fi

if ! docker images | tail -n+2 | grep '^'"$dockerName" > /dev/null 2>&1
then
    _messagePlain_bad 'bad: FAIL: missing: '"$dockerName"
    _messagePlain_request 'request: 'docker pull ghcr.io/mirage335-colossus/"$dockerName":latest
    _messageError 'FAIL'
    return 1
fi

[[ JUPYTER_PASSWORD == "" ]] && export JUPYTER_PASSWORD=$(openssl rand 768 | base64 | tr -dc 'a-zA-Z0-9' | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "24")

#docker pull "$dockerName"

entrypoint=$(docker inspect -f '{{join .Config.Entrypoint " "}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
cmd=$(docker inspect -f '{{join .Config.Cmd " "}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
workdir=$(docker inspect -f '{{.Config.WorkingDir}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04)
_messagePlain_request 'request: paste ->'
echo > ./._run-factory_runpod
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_runpod
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_runpod
_request_paste_factory-show_finetune | tee -a ./._run-factory_runpod
_messagePlain_request 'request: JUPYTER_PASSWORD: '"$JUPYTER_PASSWORD"
#docker inspect --format='{{json .Config.Entrypoint}}' "$dockerName" | jq -r '.[]' | tee -a ./._run-factory_runpod
mkdir -p "$workdir" | tee -a ./._run-factory_runpod
echo '[ -n '"$workdir"' ] && cd '"$workdir" | tee -a ./._run-factory_runpod
#echo "exec ${entrypoint} ${cmd}" | tee -a ./._run-factory_runpod
echo "exec ${entrypoint}" | tee -a ./._run-factory_runpod
#echo 'bash -i' >> ./._run-factory_runpod
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect "$dockerName" --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_runpod )
[[ ! -e ./._run-factory_runpod ]] && dockerRunArgs=( bash )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\q\p\zCore\infrastructure\ubiquitous_bash':/workspace/ubiquitous_bash:ro -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v "$HOME"/core/infrastructure/ubiquitous_bash:/workspace/ubiquitous_bash:ro -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project -v "$factory_projectDir"/cache_pip:/workspace/cache_pip --rm -it "$dockerName" "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}
_factory_unsloth() {
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _factory_ops_recursion "$@"
        return
    fi

    _factory_runpod-unsloth "$@"
}













_request_paste_factory-prepare_finetune() {
cat << 'CZXWXcRMTo8EmM8i4d'

# ###
# PASTE
# ###

#pip3 install packaging ninja
#pip3 install -e '.[flash-attn,deepspeed]'
sleep 1

# ###

#export NCCL_DEBUG=INFO
#export NCCL_DEBUG_SUBSYS=ALL
#export TORCH_DISTRIBUTED_DEBUG=INFO
#export TORCHELASTIC_ERROR_FILE=/PATH/TO/torcherror.log

# ###
false << 'doNotMatch'

CZXWXcRMTo8EmM8i4d
}
_request_paste_factory-install_ubiquitous_bash() {
cat << 'CZXWXcRMTo8EmM8i4d'

doNotMatch
# ###

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
( cd /workspace/ubiquitous_bash ; _gitBest pull ; git submodule update )
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
( cd ~/.ubcore/ubiquitous_bash ; _gitBest pull ; git submodule update )
fi
#clear

# ATTENTION: Not enabled by default, slow to download. Call '_setup_ollama' manually .
#
# DISCOURAGED. Better to benefit from 'ubiquitous_bash' maintenance identifying the most recent ollama installation commands. 
#curl -fsSL https://ollama.com/install.sh | sh
# DISCOURAGED. Does NOT install Llama-augment model.
#/workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama_sequence
# PREFERRED. Normally robust, resilient, maintained, and adds the 'Llama-augment' model for automation, etc.
#/workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama

# ###
false << 'doNotMatch'

CZXWXcRMTo8EmM8i4d
}
_request_paste_factory-show_finetune() {
cat << 'CZXWXcRMTo8EmM8i4d'

doNotMatch
# ###

find /model -maxdepth 1 | head -n 65
find /output -maxdepth 1 | head
find /dataset -maxdepth 1 | head -n 65
find /knowledge -maxdepth 1 | head -n 65
find /knowledge_distill -maxdepth 1 | head -n 65
find /workspace/project -maxdepth 1 | head -n 65

nvidia-smi

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d
}
