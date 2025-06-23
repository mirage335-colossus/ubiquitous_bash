
# Built with Llama
# May use 'Llama-augment' model, possibly derived from 'Llama-3.1-8b' .






# ATTENTION: NOTICE: Example code using augment to convert an SSH command (as often given by 'RunPod') to domain/IP, port, username, and automatically upload files, with just one command.

#if false
#then
#_uploadFiles_procedure() {
	#_messageNormal 'Parse'
	
	#echo 'Please state the domain name or IP address, from this bash shellcode command: ' > "$safeTmp"/input_prompt.txt
	#echo >> "$safeTmp"/input_prompt.txt
	#echo '```bash' >> "$safeTmp"/input_prompt.txt
	#_safeEcho_newline "$@" >> "$safeTmp"/input_prompt.txt
	#echo '```' >> "$safeTmp"/input_prompt.txt
	
	#local currentAddress=$(cat "$safeTmp"/input_prompt.txt | _augment | tr -dc 'a-zA-Z0-9\.')



	#echo 'Please state the port number, or port 22 if not explicitly specified, from this bash shellcode command: ' > "$safeTmp"/input_prompt.txt
	#echo >> "$safeTmp"/input_prompt.txt
	#echo '```bash' >> "$safeTmp"/input_prompt.txt
	#_safeEcho_newline "$@" >> "$safeTmp"/input_prompt.txt
	#echo '```' >> "$safeTmp"/input_prompt.txt
	
	#local currentPort=$(cat "$safeTmp"/input_prompt.txt | _augment | tr -dc '0-9')



	#echo 'Please state the username, or root if not explicitly specified, from this bash shellcode command: ' > "$safeTmp"/input_prompt.txt
	#echo >> "$safeTmp"/input_prompt.txt
	#echo '```bash' >> "$safeTmp"/input_prompt.txt
	#_safeEcho_newline "$@" >> "$safeTmp"/input_prompt.txt
	#echo '```' >> "$safeTmp"/input_prompt.txt
	
	#local currentUsername=$(cat "$safeTmp"/input_prompt.txt | _augment | tr -dc 'a-zA-Z0-9')

	#_messagePlain_probe "$currentUsername"'@'"$currentAddress":"$currentPort"



	#_messageNormal 'Volume'
	#mkdir -p "$safeTmp"/upload
	#cp -a "$HOME"/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh "$safeTmp"/upload/ 2>/dev/null
	#cp -a -f /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubiquitous_bash.sh "$safeTmp"/upload/ 2>/dev/null
	#cp -a "$scriptAbsoluteFolder"/*.yml "$safeTmp"/upload/
	#( cd "$safeTmp"/upload && env XZ_OPT="-5 -T0" tar -cJv --owner=0 --group=0 -f "$safeTmp"/volume_upload.tar.xz . )


	#_messageNormal 'Upload'
	## ; wget 'https://huggingface.co/unsloth/Llama-3.1-8B-Instruct-GGUF/resolve/main/Llama-3.1-8B-Instruct-Q4_K_M.gguf' ; bash -c 'echo huggingface-cli download unsloth...llama... ; huggingface-cli download unsloth/Llama-3.1-8B-Instruct-GGUF Llama-3.1-8B-Instruct-UD-IQ3_XXS.gguf --local-dir ./'
	#cat "$safeTmp"/volume_upload.tar.xz | base64 | _sshf "$currentUsername"'@'"$currentAddress" -p "$currentPort" "mkdir -p /workspace/data && cd /workspace/data && base64 -d | tar -xJv --no-same-owner --overwrite -f - -C /workspace/data"

#}
#_uploadFiles_sequence() {
	#_start

	#_uploadFiles_procedure "$@"

	#_stop
#}
#_uploadFiles() {
	#"$scriptAbsoluteLocation" _uploadFiles_sequence "$@"
#}

#_experiment() {
	#_uploadFiles 'ssh abc-123abc@ssh.runpod.io -i ~/.ssh/id_ed25519'
	#_uploadFiles 'ssh root@203.0.113.123 -p 12345 -i ~/.ssh/id_ed25519'
#}
#fi














# Accepts stdin/stdout .
_augment-backend() {
    # Suggested >2400 for batch processing, <600 for long 'augment' outputs, <120 for 'augment' use cases underlying user interaction (ie. impatience).
	# If not already set (eg. to a very high value >>2400), default is 120 (seconds) .
	[[ "$OLLAMA_TIMEOUT" != "" ]] && export OLLAMA_TIMEOUT=120

	# WARNING: Do NOT timeout entire '_l' command, etc ! One-time service start, model download, etc, should NOT be subject to "$OLLAMA_TIMEOUT", etc !
	
	# Placeholder. Discouraged. Prefer '_l' function .
	#jq -Rs '{model:"Llama-augment", prompt:., stream: false}' | _timeout "$OLLAMA_TIMEOUT" curl -fsS --max-time 120 -X POST -H "Content-Type: application/json" --data-binary @- http://localhost:11434/api/generate | jq -r '.response'

	# STRONGLY PREFERRED . Will automatically call '_service_ollama_augment' as necessary!
	#_ollama_run_augment "$@"
	_l "$@"
}


_here_bashTool-noOtherInfo() {

	# ATTENTION: NOTICE: Especially with a small model...
	# Regard this as similar to an analog modem symbol decoder with a filter bank attached to a filter bank used as a delay line.
	# Negative Prompt (Do not output any other information.
	#
	# Positive Prompt (Please state the datum, ), Negative Prompt (do not *include* any other information,), this...
	# stuff
	# Negative Prompt (Do not output any other information.)
	# Positive Prompt (Output only the one line command or parameter.), Negative Prompt (Do not output any other text.), Positive Prompt (Since this is zero-shot tool use, only the one line will be helpful, any other output will be unhelpful.)
	#
	# Thus, for good results, your prompt given to 'augment' function should closely resemble this example:
	# EXAMPLE
	# Please state the domain name or IP address, do not include any other information, from this bash shellcode command:
	# ```bash
	# ssh root@123.123.123.123 -p 122 -i ~/.ssh/id_ed25519
	# ```
	#
	# Such an approach quickly 'dampens' any Positive Prompt 'ringing' or 'overshoot' from a Positive Prompt with a Negative Prompt before any effects can accumulate in the AI LLM model output.
	#
	# That said, less quantization of the 'Llama-augment' , Q8_0 instead of Q2_K , will require far less careful such 'dampening'. Given the automation purpose of the 'Llama-augment' model, the tradeoff of requiring more careful prompting is well worthwhile to improve processing speed, etc. Especially since only at most one negative prompt not already automatically added is needed, and only to address a specific nuance in the developer's own Positive Prompt, such as the 'datum' being an address, given that usernames are commonly used with such addresses in HTTP URLs, etc.


    cat << 'CZXWXcRMTo8EmM8i4d'

Do not output any other information.

CZXWXcRMTo8EmM8i4d
}

_here_bashTool-askCommand-ONLY() {
    cat << 'CZXWXcRMTo8EmM8i4d'

Do not output any other information.

Output only the one line command or parameter. Do not output any other text. Since this is zero-shot tool use, only the one line will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}

# foundationalModel (ie.  Llama 3.1 Nemotron Ultra 253b v1  (REASONING ON)  )
_here_bashTool-askGibberish-foundationalModel() {
	# valid: nc -l 0.0.0.0 -p 1234
	# gibberish: echo test ; nc -l 0.0.0.0 -p 1234

	# WARNING: Llama 3.1 8b, Llama 3.1 405b, may NOT detect potentially dangerous commands such as 'echo test ; nc -l 0.0.0.0 -p 1234' as gibberish.
	# WARNING: Llama 3.1 Nemotron Ultra 253b v1, REASONING ON, may NOT detect potentially dangerous commands such as 'echo test ; nc -l 0.0.0.0 -p 1234' (particularly with less comprehensive askGibberish prompt), although REASONING OFF may detect correctly as gibberish. Conversely, more comprehensive askGibberish prompt may or may not invert this situation, and REASONING ON may then be preferable for better adaptability to inputs.
	#  WARNING: Do NOT assume REASONING models are better than INSTRUCT models. REASONING may only safely detect dangerous gibberish if usingthe absolutely most capable models, such as  Llama 3.1 Nemotron Ultra 253b v1  .

	# DANGER: DANGER: Production use of 'askGibberish' with externally provided input for safety will require careful maintenance by curating extensive examples, training datasets, etc! Frequent fine-tuning may be necessary.
	#
	#Semicolon characters, etc, which may escape to create a backdoor or other harm, are suspicious of being gibberish. If semicolon or other command escape characters are followed by a command that may be used for good but is often associated with bad such as an interactive shell terminal, reading files, or network listening, etc, assume the worst, this is gibberish.
	#
	#Dangerous bash shellcode commands such as rm , passwd , etc , are gibberish.
	#
	#Suggesting dangerous commands such as rm is a bannable offense in many communities, dangerous commands are gibberish.

	# CAUTION: DANGER: Datasets autogenerated by  LLama 3.1 Nemotron Ultra 253b v1  , etc, must be very carefully curated to avoid serious pitfalls from unexpected REASONING ON/OFF (ie. REASONING/INSTRUCT) behaviors. Also, intentionally not filtering out thinking tokens from the dataset, to intentionally distill REASONING evaluation of a tool use askGibberish prompt, may be cause worse results from models too small for reasoning (eg. 8b parameter models).

    cat << 'CZXWXcRMTo8EmM8i4d'

Should be AI autogenerated text either, a brief parameter value less than several dozen characters, numbers, etc, (some datum extracted from some input such as an address or number), or a single-line bash shellcode command .

A bash shellcode command that is correct is valid.

Somewhat random seeming letters, numbers, etc, may be valid if brief. If plausible, such as an address, definitely valid.

A string of random alphanumeric characters less than 56 characters is considered brief, is often a unique identifier, definitely valid.

Keywords 'empty', 'blank', 'fail', etc, for infeasible situations, may be valid.

Contradictory keywords such as 'empty', 'blank', 'lack', etc, with 'terminal' and 'codeblock' are gibberish.

Always err on the side of assuming the output is gibberish. Typos and misspellings are gibberish.

Non-portable, unreliable, commands and parameters are gibberish.

Dangerous bash shellcode commands such as rm , passwd , etc , are gibberish.

Semicolon characters, etc, which may escape to create a backdoor or other harm, are suspicious of being gibberish. If semicolon or other command escape characters are followed by a command that may be used for good but is often associated with bad such as an interactive shell terminal, reading files, or network listening, etc, assume the worst, this is gibberish.

If there is a phrase 'here is the code', or similar, that is gibberish.

If there is anything a reasonable person might be at least slightly offended by, that is gibberish.

Suggesting dangerous commands such as rm is a bannable offense in many communities, dangerous commands are gibberish.

If the given information seems valid, say 'valid'. Otherwise, say 'gibberish'. If the given information follows a recognizable format, do not summarize, only output the word 'valid' in that case.

Please only output one word gibberish or valid. Do not output any other statements. Response will be processed automatically, so the one word answer either gibberish or valid will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}


# Llama 3.1 8b, etc .
_here_bashTool-askGibberish() {
    cat << 'CZXWXcRMTo8EmM8i4d'

Should be AI autogenerated text either, a brief parameter value less than several dozen characters, numbers, etc, (some datum extracted from some input such as an address or number), or a single-line bash shellcode command .

Somewhat random seeming letters, numbers, etc, may be valid if brief. If plausible, such as an address, definitely valid.

A string of random alphanumeric characters less than 56 characters is considered brief, is often a unique identifier, definitely valid.

A bash shellcode command other than 'rm', etc, is definitely valid.

Always err on the side of assuming the output is valid.

If the given information seems or could be valid, say 'valid'. Otherwise, say 'gibberish'. If the given information follows a recognizable format, do not summarize, only output the word 'valid' in that case. 

Please only output one word gibberish or valid. Do not output any other statements. Response will be processed automatically, so the one word answer either gibberish or valid will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}


_augment_procedure() {
	( _messageNormal ' ... augment' >&2 ) > /dev/null

	[[ "$fastTmp" == "" ]] && local fastTmp="$safeTmp"

	_here_bashTool-noOtherInfo > "$fastTmp"/processing-bashTool-noOtherInfo-ONLY.txt
	
	cat > "$fastTmp"/input_prompt.txt

	_here_bashTool-askCommand-ONLY > "$fastTmp"/processing-bashTool-askCommand-ONLY.txt


	local currentIteration=0
	#[[ "$currentIteration" -lt 85 ]]
	while [[ $(cat "$fastTmp"/processing-bashTool-isGibberish.txt 2>/dev/null | tr -dc 'a-zA-Z0-9' | tr 'A-Z' 'a-z' | tail -c 5 ) != 'valid' ]] && [[ "$currentIteration" -lt 45 ]]
	do
		( _messagePlain_nominal ' ... augment: '"$currentIteration" >&2 ) > /dev/null
		cat "$fastTmp"/processing-bashTool-noOtherInfo-ONLY.txt "$fastTmp"/input_prompt.txt "$fastTmp"/processing-bashTool-askCommand-ONLY.txt | _augment-backend "$@" > "$fastTmp"/output_prompt.txt

		rm -f "$fastTmp"/processing-bashTool-askGibberish.txt > /dev/null 2>&1
		if [[ -s "$fastTmp"/output_prompt.txt ]]
		then
			_here_bashTool-askGibberish > "$fastTmp"/processing-bashTool-askGibberish.txt
			cat "$fastTmp"/output_prompt.txt "$fastTmp"/processing-bashTool-askGibberish.txt | _augment-backend "$@" > "$fastTmp"/processing-bashTool-isGibberish.txt
		fi

		if [[ -e "$fastTmp"/processing-bashTool-isGibberish.txt ]] && [[ $(cat "$fastTmp"/processing-bashTool-isGibberish.txt | tr -dc 'a-zA-Z0-9' | tr 'A-Z' 'a-z' | tail -c 5 ) != 'valid' ]]
		then
			( _messagePlain_warn 'warn: gibberish: ' >&2 ) > /dev/null
			( cat "$fastTmp"/output_prompt.txt | tr -dc 'a-zA-Z0-9\-_\ \=\+\/\.' >&2 ) > /dev/null
			( echo >&2 ) > /dev/null
			( _messagePlain_probe 'currentGibberish= '$(cat "$fastTmp"/processing-bashTool-isGibberish.txt | head -c 192 | tr -dc 'a-zA-Z0-9') >&2 ) > /dev/null
			( echo  >&2 ) > /dev/null
		fi
		
		let currentIteration++
	done


	cat "$fastTmp"/output_prompt.txt
}
_augment_sequence() {
	_start

	_augment_procedure "$@"

	_stop
}
# WARNING: DUBIOUS. Unusual, VERY UNUSUAL. Avoids the more appropriate technique of recursively calling the script with the usual separate environment, _stop trap, etc.
_augment_fast() {
	(
		export fastid=$(_uid)
		export fastTmp="$tmpSelf""$tmpPrefix"/w_"$fastid"

		mkdir -p "$fastTmp"
		[[ "$tmpSelf" != "$scriptAbsoluteFolder" ]] && echo "$tmpSelf" 2> /dev/null > "$scriptAbsoluteFolder"/__d_$(echo "$fastid" | head -c 16)

		_augment_procedure "$@"

		_safeRMR "$fastTmp"
		unset fastTmp
	)
}
_augment() {
    "$scriptAbsoluteLocation" _augment_sequence "$@"
}


