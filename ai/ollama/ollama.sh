

# ATTENTION: NOTICE: WIP: AI models bring such efficient and effective natural language processing, reasoning, parsing, summarization, API/documentation understanding, and code generation, as to backport an essential yet unusually new capability to some of the oldest (ie. >20years old) computer CPUs (even without a GPU). ATTENTION: Unusually, all 'ai' functions (including those here), may be very interdependent on the 'shortcut' functions. This has two consequences:
# (1) CAUTION: No 'compile' of the script should include only the 'ai' functions without the 'shortcut' functions, this WILL cause potentially dangerous failures.
# (2) NOTICE: Please DO read all comments from both directories for both VERY significant TODO items, and possible obligations you may have to follow to actually use some specifically supported AI models.







_setup_ollama_model_augment_sequence() {
	# NOTICE: WARNING: Normally, any redistribution of a 'Llama', similar AI model, or other AI model, would be from an authoratative corporation, such as "Soaring Distributions LLC" .
	
	# DANGER: An 'augment' model, which may be included with 'ubdist' or other 'dist/OS' is intended SOLELY for developer use. As a public domain or some publicly available AI model licensing terms apparently allow, this model may be modified for better compliance with technical use cases (such as not disregarding the previous conversation when given repeated 'system' prompts), or for smaller model size (eg. through quantization, or use of a lower parameter count model).
	
	# DANGER DANGER: Any 'augment' model really should NOT be used for 'end user' services, including any any built-in help for any end-user program or machinery (excepting that it may or may NOT be reasonable to include with some non-commercial open-source software as a built-in help, wizard, etc, following usual expectations of community provided software). You should expect users WILL, at best, more easily 'jailbreak' such a model, and, due to the emphasis on technical usage (where reliability above 0.2% failure rates, unusual repetitive prompting, etc) as well as small model size, there may be both a complete absence of any safeguards as well as a (albeit not yet observed) possibility of introducing harmful subjects to otherwise harmless conversation.
	
	# YOU HAVE BEEN WARNED ! DEVELOPERS ONLY, NOT USERS !
	
	
	# Any distribution or any other activity regarding any 'augmentation' or other AI model is without any warranty of any kind. Superseding all other statements, there are no representations or warranties of any kind concerning the Work, express, implied, statutory or otherwise, including without limitation warranties of title, merchantability, fitness for a particular purpose, non infringement, or the absence of latent or other defects, accuracy, or the present or absence of errors, whether or not discoverable, all to the greatest extent permissible under applicable law.
	
	# SPECIFICALLY THIS STATEMENT DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED HEREUNDER.
	
	
	# NOTICE: Purpose of the 'augment' model is, above all other purposes, both:
	#  (1) To supervise and direct decisions and analysis by other AI models (such as from vision encoders, but also mathematical reasoning specific LLMs, computer activity and security logging LLMs, etc).
	#  (2) To assist and possibly supervise 'human-in-the-loop' decision making (eg. to sanity check human responses).
	
	
	# https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/tree/main
	# https://web.archive.org/web/20240831194035/https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/tree/main
	# Explicitly states 'License: llama3.1'. Readme file from repository does NOT contradict this.
	
	# https://www.llama.com/llama3_1/license/
	# https://huggingface.co/meta-llama/Meta-Llama-3.1-70B-Instruct/blob/main/LICENSE
	#  NOTICE: ATTENTION: This license has been preserved as 'LICENSE-Llama-3.1.txt', but this license does NOT apply to any 'ubiquitous_bash' code or any other work that is not either a work by Meta or strictly a derivative of a work by Meta (such as a modified AI model GGUF or safetensors file) !
	
	# https://www.llama.com/llama3_1/use-policy/
	
	
	# https://www.llama.com/llama3_1/license/
	#  'include “Llama” at the beginning of any such AI model name'
	# ATTENTION: Nevertheless, it is very possible a non-'Llama' model will eventually be used, especially as science and technology (eg. plasma recombination EUV physics) related datasets (eg. relevant Wikipedia articles) are increasingly gathered.
	
	
	# https://www.llama.com/llama3_2/license/
	# https://www.llama.com/llama3_2/use-policy/
	#  'or to enable functionality disabled by Meta'
	#   The functionality offered by 'Llama 3.2' (eg. multimodal functionality) is expected to exceed the purpose of an 'augment' model, but the reliabilility limitations imposed are expected prohibitive (especially regarding repeated 'system' prompts). Thus, it is expected that 'Llama 3.1' will be the last 'Llama' model used as an 'augment' model. This is NOT a concern, because it is expected that 'Llama 3.1' already reached a point of diminishing returns on what can be achieved by AI model training methods alone.
	#   Purposes other than as an 'augment' model, which is a text-only technical use case, and expected to require fine tuning (eg. on prompt/responses generated from the 'ubiquitous_bash' codebase), at that, are expected to achieve very adequate performance from 'stock' original 'Llama' models, or at least those fine-tuned for specific use cases (eg. needle-in-haystack, computer vision object recognition, robot motor control, etc).
	
	
	
	
	
	
	
	# ATTENTION: Default context size is low to ensure compatibility with low-RAM computers (LLM on CPU performance generally being acceptable).
	# STRONGLY RECOMMENDED to greatly increase the context length (6144) if at all possible (>32GB RAM) or to decrease if necessary (eg. 8GB RAM) .
	
	#/clear
	#/set parameter num_thread 768
	#/set parameter num_gpu 0
	
	# 4GB (presumed)
	#/set parameter num_ctx 512

	# 8GB (presumed)
	#/set parameter num_ctx 2048

	#/set parameter num_ctx 4096

	# 16GB (presumed)
	#/set parameter num_ctx 8192

	#/set parameter num_ctx 16384

	# 32GB
	#/set parameter num_ctx 32768

	# 68.5GiB (presumed)
	#/set parameter num_ctx 131072
	
	
	
	
	
	
	
	
	
	local functionEntryPWD="$PWD"
	_start
	
	
	cd "$safeTmp"
	
	
	
	
	
	
	# TODO: Replace with model fine-tuned by additional relevant codebases and scientific knowledge.
	
	# TODO: TODO: Intentionally overfit smaller parameter models by reinforcing prompt/response for specific knowledge (eg. plasma recombiation light emission physics) and reasoning (eg. robot motor control).
	
	
	# TODO: There may or may not be more track record with this slightly different model, using Q4-K-M quantization.
	# https://huggingface.co/grimjim/Llama-3.1-8B-Instruct-abliterated_via_adapter-GGUF
	
	# TODO: Consider alternative quantization, especially IQ2-M, IQ4-XS. Beware Q4-K-M may have some community testing of important edge cases already.
	# https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/tree/main
	
	echo 'FROM ./llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf
PARAMETER num_ctx 6144' > Llama-augment.Modelfile
	
	#wget 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
	aria2c --log=- --log-level=info -x "3" -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
	[[ ! -e 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' ]] && aria2c --log=- --log-level=info -x "3" -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' --disable-ipv6=true
	
	
	_service_ollama
	
	ollama create Llama-augment -f Llama-augment.Modelfile
	
	rm -f llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf
	rm -f Llama-augment.Modelfile
	
	_ollama_stop_augment
	
	
	cd "$functionEntryPWD"
	_stop
}
_setup_ollama_sequence() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_start
	
	echo 'setup: ollama: https://ollama.com/install.sh'

	cd "$safeTmp"

	local currentExitStatus="1"
	
	# DANGER: This upstream script, as with many, has been known to use 'rm' recursively without the safety checks of '_safeRMR' .
	# CAUTION: This upstream script may not catch error conditions upon failure, which may increase the size of dist/OS images built after such failures.
	curl -fsSL https://ollama.com/install.sh | sh
	currentExitStatus="$?"

	cd "$functionEntryPWD"
	_stop "$currentExitStatus"
}
_setup_ollama() {
	#_wantGetDep sudo
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)
	
	if ! _if_cygwin
	then
		"$scriptAbsoluteLocation" _setup_ollama_sequence "$@"
	fi
	
	type -p ollama > /dev/null 2>&1 && "$scriptAbsoluteLocation" _setup_ollama_model_augment_sequence
}

_test_ollama() {
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)

	if ! type -p ollama > /dev/null 2>&1
	then
		_setup_ollama
	fi
	
	
	if ! _if_cygwin
	then
		! type -p ollama > /dev/null 2>&1 && _messageFAIL && _stop 1
	else
		! type -p ollama > /dev/null 2>&1 && echo 'warn: acepted: cygwin: missing: ollama'
		# Accepted. Do NOT return with error status (ie. do NOT 'return 1') .
	fi
	
	return 0
}

_vector_ollama_procedure() {
	! _ollama_run_augment "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ." | grep true > /dev/null && echo 'fail: _vector_ollama' && _messageFAIL && _stop 1
	_ollama_run_augment "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ." | grep false > /dev/null && echo 'fail: _vector_ollama' && _messageFAIL && _stop 1
	
	! _ollama_run_augment "Please output the word false . Any other output accompanying the word false is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word false will be very helpful whereas any output other than the word false will be unhelpful . Please output the word false ." | grep false > /dev/null && echo 'fail: _vector_ollama' && _messageFAIL && _stop 1
	_ollama_run_augment "Please output the word false . Any other output accompanying the word false is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word false will be very helpful whereas any output other than the word false will be unhelpful . Please output the word false ." | grep true > /dev/null && echo 'fail: _vector_ollama' && _messageFAIL && _stop 1

	return 0
}
_vector_ollama() {
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)

	_service_ollama
	
	if _if_cygwin && ! type -p ollama > /dev/null 2>&1
	then
		echo 'warn: accepted: cygwin: missing: ollama'
	elif type -p ollama > /dev/null 2>&1
	then
		if [[ "$hostMemoryQuantity" -lt 28000000 ]]
		then
			_messagePlain_nominal '_vector_ollama: begin: low RAM detected'
			local currentExitStatus
			currentExitStatus="1"
			
			_ollama_set_sequence-augment-lowRAM

			"$scriptAbsoluteLocation" _vector_ollama_procedure
			currentExitStatus="$?"

			_ollama_set_sequence-augment-normal

			[[ "$currentExitStatus" != "0" ]] && _messageFAIL && _stop 1
			_messagePlain_nominal '_vector_ollama: end: low RAM detected'
		else
			_vector_ollama_procedure
		fi
	fi

	_ollama_stop_augment

	return 0
}





_user_ollama() {
	#_mustGetSudo
	local currentUser_temp
	[[ "$currentUser_researchEngine" != "" ]] && currentUser_temp="$currentUser_researchEngine"
	[[ "$currentUser_temp" == "" ]] && currentUser_temp="$currentUser"
	[[ "$currentUser_temp" == "" ]] && [[ "$USER" != "root" ]] && currentUser_temp="$USER"
	[[ "$currentUser_temp" == "" ]] && currentUser_temp="user"

	echo "$currentUser_temp"
	return 0
}


# Very unusual. Ensures service is available, if normal systemd service is not.
# WARNING: Should NOT run standalone service if systemd service is available. Thus, it is important to check if the service is already available (as would normally always be the case when booted with systemd available).
# Mostly, this is used to workaround very unusual dist/OS build and custom situations (ie. ChRoot, GitHub Actions, etc).
# CAUTION: This leaves a background process running, which must continue running (ie. not hangup) while other programs use it, and which must terminate upon shutdown , _closeChRoot , etc .
_service_ollama() {
	if ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
	then
		ollama serve &
		while ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
		do
			echo "wait: ollama: service"
			sleep 1
		done
		sleep 45
	fi
	
	
	if ! wget --timeout=1 --tries=3 127.0.0.1:11434 > /dev/null -q -O - > /dev/null
	then
		echo 'fail: _service_ollama: ollama: 127.0.0.1:11434'
		return 1
	fi
}


