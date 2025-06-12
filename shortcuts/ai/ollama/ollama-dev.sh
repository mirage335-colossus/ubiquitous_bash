
# Developer,  technician, etc, assistant AI model . If you are tempted to use the '_l' , 'l', alias on the command-line, as possibly more thorough alternative to 'man' manual pages, this is expected usually what you want instead. Small enough model to run locally, emphasizing development related knowledge and logic, yet able to run reasonably using ~16GB VRAM, possibly CPU, etc. However, owing to the disk space requirements, not usually included with a dist/OS by default, as only intensive development workstations should really need this.







_setup_ollama_model_dev_sequence() {
    _start

    cd "$safeTmp"

    # Suggested <6144 token context window (ie. 'num_ctx') . May be unreliable (at the limits of what fits in 16GB VRAM, limiting context window, etc).
    
    ollama pull hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS
    echo FROM hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS > Modelfile
    echo PARAMETER num_gpu 41 >> Modelfile
    echo PARAMETER num_ctx 6144 >> Modelfile

    cat << 'CZXWXcRMTo8EmM8i4d' >> Modelfile
	LICENSE """Apache 2.0 License
https://huggingface.co/mistralai/Devstral-Small-2505
Apache 2.0 License

https://huggingface.co/bartowski/mistralai_Devstral-Small-2505-GGUF
License: apache-2.0
"""
CZXWXcRMTo8EmM8i4d

    ollama create hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41
    
    #ollama run hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41 describe this image ./download.png

    _stop
}

_ollama_run_dev() {
	# https://huggingface.co/mistralai/Devstral-Small-2505
    #  'Apache 2.0 License'

    # https://huggingface.co/bartowski/mistralai_Devstral-Small-2505-GGUF
    #  'License: apache-2.0'
    

	! _service_ollama_augment && return 1

	if [[ "$OLLAMA_HOST" != "" ]] && ! type -P ollama > /dev/null 2>&1
	then
		local current_api_timeout="$OLLAMA_TIMEOUT"
		[[ "$current_api_timeout" == "" ]] && current_api_timeout=7200
		#jq -Rs '{model:"hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41", prompt:., stream: false}' | _timeout "$current_api_timeout" curl -fsS --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -r '.response'
		#jq -Rs '{model:"hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
		if [[ "$*" == "" ]]
		then
			jq -Rs '{model:"hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
			return
		else
			_safeEcho_newline "$@" | jq -Rs '{model:"hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41", prompt:., stream: true}' | _timeout "$current_api_timeout" curl -fsS --no-buffer --max-time "$current_api_timeout" -X POST -H "Content-Type: application/json" --data-binary @- http://"$OLLAMA_HOST"/api/generate | jq -rj --unbuffered 'if .done? then "\n" elif .response? then .response else empty end'
			return
		fi
	fi

	if ! ollama show hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41 --modelfile > /dev/null 2>&1
	then
		"$scriptAbsoluteLocation" _setup_ollama_model_dev_sequence > /dev/null 2>&1
	fi
	
	# Suggested >7200 for batch processing, <1800 for long 'augment' outputs, <<360 or <120 for 'augment' use cases underlying user interaction (ie. impatience).
    # In practice, this is NOT an augment model, and should only be used either strictly interactively (stream and interrupt), or strictly for agentic development, tool use, etc (ie. Cline VSCode extension, etc) .
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
			
			_timeout "$OLLAMA_TIMEOUT" ollama run hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41 "$@"
		)
		return
	fi

	ollama run hf.co/bartowski/mistralai_Devstral-Small-2505-GGUF:IQ4_XS-g41 "$@"
}
# 'l'... 'LLM', 'language', 'Llama', etc .
_d() {
	_ollama_run_dev "$@"
}
alias d=_d


