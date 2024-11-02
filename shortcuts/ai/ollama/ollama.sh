




# TODO: TODO: Reference implementation of alternative, easily scriptable Text-User-Interface (TUI) for 'ollama', for more convenient GUI wrapper design,etc.
# https://huggingface.co/blog/llama2#how-to-prompt-llama-2
#<s>[INST] <<SYS>>
#{{ system_prompt }}
#<</SYS>>
#
#{{ user_msg_1 }} [/INST] {{ model_answer_1 }} </s><s>[INST] {{ user_msg_2 }} [/INST]





_ollama_run_augment() {
	# NOTICE: ATTENTION: Additional documenation about the 'augment' model may be present at comments around the '_setup_ollama_model_augment_sequence' and similar functions .
	
	# DANGER DANGER: Any 'augment' model really should NOT be used for 'end user' services, including any any built-in help for any end-user program or machinery (excepting that it may or may NOT be reasonable to include with some non-commercial open-source software as a built-in help, wizard, etc, following usual expectations of community provided software). You should expect users WILL, at best, more easily 'jailbreak' such a model, and, due to the emphasis on technical usage (where reliability above 0.2% failure rates, unusual repetitive prompting, etc) as well as small model size, there may be both a complete absence of any safeguards as well as a (albeit not yet observed) possibility of introducing harmful subjects to otherwise harmless conversation.
	
	# YOU HAVE BEEN WARNED ! DEVELOPERS ONLY, NOT USERS !
	
	# https://www.llama.com/llama3_1/license/
	#  'include “Llama” at the beginning of any such AI model name'
	# ATTENTION: Nevertheless, it is very possible a non-'Llama' model will eventually be used, especially as science and technology (eg. plasma recombination EUV physics) related datasets (eg. relevant Wikipedia articles) are increasingly gathered.
	
	# https://www.llama.com/llama3_1/use-policy/
	
	ollama run Llama-augment "$@"
}
# 'l'... 'LLM', 'language', 'Llama', etc .
_l() {
	_ollama_run_augment "$@"
}
alias l=_l














