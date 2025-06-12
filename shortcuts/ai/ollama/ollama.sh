




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

	if [[ "$OLLAMA_HOST" != "" ]] && ! type -P ollama > /dev/null 2>&1
	then
		local current_api_timeout="$OLLAMA_TIMEOUT"
		[[ "$current_api_timeout" == "" ]] && current_api_timeout=7200
		#jq -Rs '{model:"Llama-augment", prompt:., stream: false}' | _timeout "$current_api_timeout" curl -fsS --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -r '.response'
		#jq -Rs '{model:"Llama-augment", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
		if [[ "$*" == "" ]]
		then
			jq -Rs '{model:"Llama-augment", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
			return
		else
			_safeEcho_newline "$@" | jq -Rs '{model:"Llama-augment", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
			return
		fi
	fi

	if ! ollama show Llama-augment > /dev/null 2>&1
	then
		"$scriptAbsoluteLocation" _setup_ollama_model_augment_sequence > /dev/null 2>&1
	fi
	
	# Suggested >2400 for batch processing, <600 for long 'augment' outputs, <120 for 'augment' use cases underlying user interaction (ie. impatience).
	if [[ "$OLLAMA_TIMEOUT" != "" ]]
	then
		(
			# ATTRIBUTION-AI: ChatGPT o3  2025-06-03  (suggested OLLAMA_LOAD_TIMEOUT ... ChatGPT may have automatically included some web search results )
			# DUBIOUS .
			# https://pkg.go.dev/github.com/ollama/ollama/envconfig?utm_source=chatgpt.com
			# https://github.com/ollama/ollama/blob/v0.9.0/envconfig/config.go#L120
			# https://github.com/ollama/ollama/issues/6678
			# https://github.com/ollama/ollama/issues/5081
			export OLLAMA_LOAD_TIMEOUT="$OLLAMA_TIMEOUT"s
			
			_timeout "$OLLAMA_TIMEOUT" ollama run Llama-augment "$@"
		)
		return
	fi

	ollama run Llama-augment "$@"
}
# 'l'... 'LLM', 'language', 'Llama', etc .
_l() {
	_ollama_run_augment "$@"
}
alias l=_l














