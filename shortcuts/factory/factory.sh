
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

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

docker pull axolotlai/axolotl:main-latest

_messagePlain_request 'request: paste ->'
echo > ./._run-factory_axolotl
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_axolotl
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_axolotl
_request_paste_factory-show_finetune | tee -a ./._run-factory_axolotl
docker inspect --format='{{json .Config.Entrypoint}}' axolotlai/axolotl:main-latest | jq -r '.[]' | tee -a ./._run-factory_axolotl
#echo 'bash -i' >> ./._run-factory_axolotl
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect axolotlai/axolotl:main-latest --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_axolotl )
[[ ! -e ./._run-factory_axolotl ]] && dockerRunArgs=( )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name axolotl-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project --rm -it axolotlai/axolotl:main-latest "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name axolotl-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project --rm -it axolotlai/axolotl:main-latest "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}




_factory_runpod-official() {

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

[[ JUPYTER_PASSWORD == "" ]] && export JUPYTER_PASSWORD=$(openssl rand 768 | base64 | tr -dc 'a-zA-Z0-9' | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "24")

docker pull runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04

_messagePlain_request 'request: paste ->'
echo > ./._run-factory_runpod
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_runpod
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_runpod
_request_paste_factory-show_finetune | tee -a ./._run-factory_runpod
_messagePlain_request 'request: JUPYTER_PASSWORD: '"$JUPYTER_PASSWORD"
docker inspect --format='{{json .Config.Entrypoint}}' runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04 | jq -r '.[]' | tee -a ./._run-factory_runpod
#echo 'bash -i' >> ./._run-factory_runpod
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04 --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_runpod )
[[ ! -e ./._run-factory_runpod ]] && dockerRunArgs=( bash )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project --rm -it runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04 "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project --rm -it runpod/pytorch:2.2.0-py3.10-cuda12.1.1-devel-ubuntu22.04 "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}




_factory_runpod-heavy() {

! type _set_factory_dir > /dev/null 2>&1 && exit 1
_set_factory_dir



# ###
# PASTE
# ###

! docker images | tail -n+2 | grep '^runpod-pytorch-heavy' > /dev/null 2>&1 && exit

[[ JUPYTER_PASSWORD == "" ]] && export JUPYTER_PASSWORD=$(openssl rand 768 | base64 | tr -dc 'a-zA-Z0-9' | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "24")

docker pull runpod-pytorch-heavy

_messagePlain_request 'request: paste ->'
echo > ./._run-factory_runpod
_request_paste_factory-prepare_finetune | tee -a ./._run-factory_runpod
_request_paste_factory-install_ubiquitous_bash | tee -a ./._run-factory_runpod
_request_paste_factory-show_finetune | tee -a ./._run-factory_runpod
_messagePlain_request 'request: JUPYTER_PASSWORD: '"$JUPYTER_PASSWORD"
docker inspect --format='{{json .Config.Entrypoint}}' runpod-pytorch-heavy | jq -r '.[]' | tee -a ./._run-factory_runpod
#echo 'bash -i' >> ./._run-factory_runpod
_messagePlain_request 'request: <- paste'


# ###


! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

#docker image inspect runpod-pytorch-heavy --format '{{json .Config.Entrypoint}} {{json .Config.Cmd}}'

dockerRunArgs=( bash /workspace/project/._run-factory_runpod )
[[ ! -e ./._run-factory_runpod ]] && dockerRunArgs=( bash )

if _if_cygwin
then
#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_knowledgeDir":/knowledge -v "$factory_knowledge_distillDir":/knowledge_distill -v "$factory_projectDir":/workspace/project --rm -it runpod-pytorch-heavy "${dockerRunArgs[@]}"
fi
if ! _if_cygwin
then
# WARNING: May be untested.
docker run --shm-size=20g --name runpod-$(_uid 14) --gpus "all" -e "$JUPYTER_PASSWORD" -e HF_AKI_KEY="$HF_AKI_KEY" -v '/home/user/___quick':/q -v '/home/user/core':/core -v "/home/user"'/Downloads':/Downloads -v "$factory_outputDir":/output -v "$factory_modelDir":/model -v "$factory_datasetDir":/dataset -v "$factory_projectDir":/workspace/project --rm -it runpod-pytorch-heavy "${dockerRunArgs[@]}"
fi

# ###
# PASTE
# ###



}
_factory_runpod() {
    _factory_runpod-heavy
}



# https://hub.docker.com/u/langchain



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

if [[ -e /core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh ]]
then
/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
export profileScriptLocation="/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"
export profileScriptFolder="/core/infrastructure/ubiquitous_bash"
. "/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts
else
! [[ -e /ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /ubiquitous_bash.sh
chmod u+x /ubiquitous_bash.sh
/ubiquitous_bash.sh _setupUbiquitous_nonet
fi
#clear

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
