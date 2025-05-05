




# TODO: TODO: Reference implementation of alternative, easily scriptable Text-User-Interface (TUI) for 'ollama', for more convenient GUI wrapper design,etc.
# https://huggingface.co/blog/llama2#how-to-prompt-llama-2
#<s>[INST] <<SYS>>
#{{ system_prompt }}
#<</SYS>>
#
#{{ user_msg_1 }} [/INST] {{ model_answer_1 }} </s><s>[INST] {{ user_msg_2 }} [/INST]




# https://github.com/ollama/ollama/issues/6286
_ollama_set_sequence-augment-normal() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_start
	cd "$safeTmp"

	ollama show Llama-augment --modelfile | sed 's/PARAMETER num_ctx [0-9]*/PARAMETER num_ctx 6144/' > ./Llama-augment-tmp.Modelfile
	sleep 9
	ollama create Llama-augment --file ./Llama-augment-tmp.Modelfile
	sleep 9

	cd "$functionEntryPWD"
	_stop
}
_ollama_set-augment-normal() {
	"$scriptAbsoluteLocation" _ollama_set_sequence-augment-normal "$@"
}
# Temporarily reduce RAM/VRAM requirement for constrained CI .
_ollama_set_sequence-augment-lowRAM() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_start
	cd "$safeTmp"

	#512
	ollama show Llama-augment --modelfile | sed 's/PARAMETER num_ctx [0-9]*/PARAMETER num_ctx 640/' > ./Llama-augment-tmp.Modelfile
	sleep 9
	ollama create Llama-augment --file ./Llama-augment-tmp.Modelfile
	sleep 9


	cd "$functionEntryPWD"
	_stop
}
_ollama_set-augment-lowRAM() {
	"$scriptAbsoluteLocation" _ollama_set_sequence-augment-lowRAM "$@"
}


# Very unusual. Ensures service is available, if normal systemd service is not.
# WARNING: Should NOT run standalone service if systemd service is available. Thus, it is important to check if the service is already available (as would normally always be the case when booted with systemd available).
# Mostly, this is used to workaround very unusual dist/OS build and custom situations (ie. ChRoot, GitHub Actions, etc).
# CAUTION: This leaves a background process running, which must continue running (ie. not hangup) while other programs use it, and which must terminate upon shutdown , _closeChRoot , etc .
_service_ollama_augment() {
	if _if_cygwin && ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
	then
		return 1
	fi

	_if_cygwin && return 0

	_mustGetSudo
	if ! sudo -n -u ollama bash -c 'type -p ollama'
	then
		#echo 'warn: _service_ollama: missing: ollama'
		return 1
	fi
	
	if ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
	then
		# ATTENTION: This is basically how to not cause interactive bash shell issues starting a background service at Docker container runtime.
		# WARNING: May not be adequately tested.
		echo | sudo -n -u ollama nohup ollama serve </dev/null >>/var/log/ollama.log 2>&1 &
		while ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
		do
			sleep 1
		done
		stty echo
		stty sane
		stty echo
		
		#sudo -n -u ollama ollama serve &
		#while ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
		#do
			#echo "wait: ollama: service"
			#sleep 1
		#done
		sleep 3
	fi
	
	
	if ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
	then
		#echo 'fail: _service_ollama: ollama: 127.0.0.1:11434'
		return 1
	fi

	return 0
}

_ollama_stop_augment() {
	ollama stop Llama-augment
}

_ollama_run_augment() {
	# NOTICE: ATTENTION: Additional documenation about the 'augment' model may be present at comments around the '_setup_ollama_model_augment_sequence' and similar functions .
	
	# DANGER DANGER: Any 'augment' model really should NOT be used for 'end user' services, including any any built-in help for any end-user program or machinery (excepting that it may or may NOT be reasonable to include with some non-commercial open-source software as a built-in help, wizard, etc, following usual expectations of community provided software). You should expect users WILL, at best, more easily 'jailbreak' such a model, and, due to the emphasis on technical usage (where reliability above 0.2% failure rates, unusual repetitive prompting, etc) as well as small model size, there may be both a complete absence of any safeguards as well as a (albeit not yet observed) possibility of introducing harmful subjects to otherwise harmless conversation.
	
	# YOU HAVE BEEN WARNED ! DEVELOPERS ONLY, NOT USERS !
	
	# https://www.llama.com/llama3_1/license/
	#  'include “Llama” at the beginning of any such AI model name'
	# ATTENTION: Nevertheless, it is very possible a non-'Llama' model will eventually be used, especially as science and technology (eg. plasma recombination EUV physics) related datasets (eg. relevant Wikipedia articles) are increasingly gathered.
	
	# https://www.llama.com/llama3_1/use-policy/

	! _service_ollama_augment && return 1
	
	
	ollama run Llama-augment "$@"
}
# 'l'... 'LLM', 'language', 'Llama', etc .
_l() {
	_ollama_run_augment "$@"
}
alias l=_l














