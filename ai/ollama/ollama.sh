

# ATTENTION: NOTICE: WIP: AI models bring such efficient and effective natural language processing, reasoning, parsing, summarization, API/documentation understanding, and code generation, as to backport an essential yet unusually new capability to some of the oldest (ie. >20years old) computer CPUs (even without a GPU). ATTENTION: Unusually, all 'ai' functions (including those here), may be very interdependent on the 'shortcut' functions. This has two consequences:
# (1) CAUTION: No 'compile' of the script should include only the 'ai' functions without the 'shortcut' functions, this WILL cause potentially dangerous failures.
# (2) NOTICE: Please DO read all comments from both directories for both VERY significant TODO items, and possible obligations you may have to follow to actually use some specifically supported AI models.



_here_license-Llama-augment() {
	cat << 'CZXWXcRMTo8EmM8i4d'
	LICENSE """Built with Llama
Llama 3.1 is licensed under the Llama 3.1 Community License, Copyright © Meta Platforms, Inc. All Rights Reserved.

License and terms of use are inherited from the 'Meta' corporation's llama3_1 license and use policy.
https://www.llama.com/llama3_1/license/
https://www.llama.com/llama3_1/use-policy/

Copies of these license and use policies, to the extent required and/or appropriate, are included in appropriate subdirectories of a proper recursive download of any git repository used to distribute this project. 


DANGER!

Please beware this 'augment' model is intended for embedded use by developers, and is NOT intended as-is for end-users (except possibly for non-commercial open-source projects), especially not as any built-in help. Features may be removed, overfitting to specific answers may be deliberately reinforced, and CONVERSATION MAY DEVIATE FROM SAFE DESPITE HARMLESS PROMPTS.

If you are in a workplace or public relations setting, you are recommended to avoid providing interactive or visible outputs from an 'augment' model unless you can safely evaluate that the model provides the most reasonable safety for your use case.

PLEASE BE AWARE the 'Meta' corporation's use policy DOES NOT ALLOW you to "FAIL TO APPROPRIATELY DISCLOSE to end users any known dangers of your AI system".

Purpose of this model, above all other purposes, is both:
(1) To supervise and direct decisions and analysis by other AI models (such as from vision encoders, but also mathematical reasoning specific LLMs, computer activity and security logging LLMs, etc).
(2) To assist and possibly supervise 'human-in-the-loop' decision making (eg. to sanity check human responses).
This model's ability to continue conversation with awareness of previous context after repeating the rules of the conversation through a system prompt, has been enhanced. Consequently, this model's ability to keep a CONVERSATION positive and SAFE may ONLY be ENHANCED BETTER THAN OTHER MODELS if REPEATED SYSTEM PROMPTING and LLAMA GUARD are used.
https://ollama.com/library/llama-guard3


DISCLAIMER

All statements and disclaimers apply as written from the files: 'ubiquitous_bash/ai/ollama/ollama.sh'
'ubiquitous_bash/shortcuts/ai/ollama/ollama.sh'

In particular, any 'augment' model provided is with a extensive DISCLAIMER regarding ANY AND ALL LIABILITY for any and all use, distribution, copying, etc. Anyone using, distributing, copying, etc, any 'augment' model provided under, through, including, referencing, etc, this or any similar disclaimer, whether aware of this disclaimer or not, is intended to also be, similarly, to the extent possible, DISCLAIMING ANY AND ALL LIABILITY.

Nothing in this text is intended to allow for any legal liability to anyone for any and all use, distribution, copying, etc.




LLAMA 3.1 COMMUNITY LICENSE AGREEMENT
Llama 3.1 Version Release Date: July 23, 2024

“Agreement” means the terms and conditions for use, reproduction, distribution and modification of the
Llama Materials set forth herein.

“Documentation” means the specifications, manuals and documentation accompanying Llama 3.1
distributed by Meta at https://llama.meta.com/doc/overview.

“Licensee” or “you” means you, or your employer or any other person or entity (if you are entering into
this Agreement on such person or entity’s behalf), of the age required under applicable laws, rules or
regulations to provide legal consent and that has legal authority to bind your employer or such other
person or entity if you are entering in this Agreement on their behalf.

“Llama 3.1” means the foundational large language models and software and algorithms, including
machine-learning model code, trained model weights, inference-enabling code, training-enabling code,
fine-tuning enabling code and other elements of the foregoing distributed by Meta at
https://llama.meta.com/llama-downloads.

“Llama Materials” means, collectively, Meta’s proprietary Llama 3.1 and Documentation (and any
portion thereof) made available under this Agreement.

“Meta” or “we” means Meta Platforms Ireland Limited (if you are located in or, if you are an entity, your
principal place of business is in the EEA or Switzerland) and Meta Platforms, Inc. (if you are located
outside of the EEA or Switzerland).

By clicking “I Accept” below or by using or distributing any portion or element of the Llama Materials,
you agree to be bound by this Agreement.

1. License Rights and Redistribution.

  a. Grant of Rights. You are granted a non-exclusive, worldwide, non-transferable and royalty-free
limited license under Meta’s intellectual property or other rights owned by Meta embodied in the Llama
Materials to use, reproduce, distribute, copy, create derivative works of, and make modifications to the
Llama Materials.

  b. Redistribution and Use.

      i. If you distribute or make available the Llama Materials (or any derivative works
thereof), or a product or service (including another AI model) that contains any of them, you shall (A)
provide a copy of this Agreement with any such Llama Materials; and (B) prominently display “Built with
Llama” on a related website, user interface, blogpost, about page, or product documentation. If you use
the Llama Materials or any outputs or results of the Llama Materials to create, train, fine tune, or
otherwise improve an AI model, which is distributed or made available, you shall also include “Llama” at
the beginning of any such AI model name.

      ii. If you receive Llama Materials, or any derivative works thereof, from a Licensee as part 
of an integrated end user product, then Section 2 of this Agreement will not apply to you.

      iii. You must retain in all copies of the Llama Materials that you distribute the following
attribution notice within a “Notice” text file distributed as a part of such copies: “Llama 3.1 is
licensed under the Llama 3.1 Community License, Copyright © Meta Platforms, Inc. All Rights
Reserved.”

      iv. Your use of the Llama Materials must comply with applicable laws and regulations
(including trade compliance laws and regulations) and adhere to the Acceptable Use Policy for the Llama
Materials (available at https://llama.meta.com/llama3_1/use-policy), which is hereby incorporated by
reference into this Agreement.

2. Additional Commercial Terms. If, on the Llama 3.1 version release date, the monthly active users
of the products or services made available by or for Licensee, or Licensee’s affiliates, is greater than 700
million monthly active users in the preceding calendar month, you must request a license from Meta,
which Meta may grant to you in its sole discretion, and you are not authorized to exercise any of the
rights under this Agreement unless or until Meta otherwise expressly grants you such rights.

3. Disclaimer of Warranty. UNLESS REQUIRED BY APPLICABLE LAW, THE LLAMA MATERIALS AND ANY
OUTPUT AND RESULTS THEREFROM ARE PROVIDED ON AN “AS IS” BASIS, WITHOUT WARRANTIES OF
ANY KIND, AND META DISCLAIMS ALL WARRANTIES OF ANY KIND, BOTH EXPRESS AND IMPLIED,
INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OF TITLE, NON-INFRINGEMENT,
MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. YOU ARE SOLELY RESPONSIBLE FOR
DETERMINING THE APPROPRIATENESS OF USING OR REDISTRIBUTING THE LLAMA MATERIALS AND
ASSUME ANY RISKS ASSOCIATED WITH YOUR USE OF THE LLAMA MATERIALS AND ANY OUTPUT AND
RESULTS.

4. Limitation of Liability. IN NO EVENT WILL META OR ITS AFFILIATES BE LIABLE UNDER ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, TORT, NEGLIGENCE, PRODUCTS LIABILITY, OR OTHERWISE, ARISING
OUT OF THIS AGREEMENT, FOR ANY LOST PROFITS OR ANY INDIRECT, SPECIAL, CONSEQUENTIAL,
INCIDENTAL, EXEMPLARY OR PUNITIVE DAMAGES, EVEN IF META OR ITS AFFILIATES HAVE BEEN ADVISED
OF THE POSSIBILITY OF ANY OF THE FOREGOING.

5. Intellectual Property.

  a. No trademark licenses are granted under this Agreement, and in connection with the Llama
Materials, neither Meta nor Licensee may use any name or mark owned by or associated with the other
or any of its affiliates, except as required for reasonable and customary use in describing and
redistributing the Llama Materials or as set forth in this Section 5(a). Meta hereby grants you a license to
use “Llama” (the “Mark”) solely as required to comply with the last sentence of Section 1.b.i. You will
comply with Meta’s brand guidelines (currently accessible at
https://about.meta.com/brand/resources/meta/company-brand/ ). All goodwill arising out of your use
of the Mark will inure to the benefit of Meta.

  b. Subject to Meta’s ownership of Llama Materials and derivatives made by or for Meta, with
respect to any derivative works and modifications of the Llama Materials that are made by you, as
between you and Meta, you are and will be the owner of such derivative works and modifications.

  c. If you institute litigation or other proceedings against Meta or any entity (including a
cross-claim or counterclaim in a lawsuit) alleging that the Llama Materials or Llama 3.1 outputs or
results, or any portion of any of the foregoing, constitutes infringement of intellectual property or other
rights owned or licensable by you, then any licenses granted to you under this Agreement shall
terminate as of the date such litigation or claim is filed or instituted. You will indemnify and hold
harmless Meta from and against any claim by any third party arising out of or related to your use or
distribution of the Llama Materials.

6. Term and Termination. The term of this Agreement will commence upon your acceptance of this
Agreement or access to the Llama Materials and will continue in full force and effect until terminated in
accordance with the terms and conditions herein. Meta may terminate this Agreement if you are in
breach of any term or condition of this Agreement. Upon termination of this Agreement, you shall delete
and cease use of the Llama Materials. Sections 3, 4 and 7 shall survive the termination of this
Agreement.

7. Governing Law and Jurisdiction. This Agreement will be governed and construed under the laws of
the State of California without regard to choice of law principles, and the UN Convention on Contracts
for the International Sale of Goods does not apply to this Agreement. The courts of California shall have
exclusive jurisdiction of any dispute arising out of this Agreement.
"""
CZXWXcRMTo8EmM8i4d
}


# NOTICE: You are obtaining the 'Llama-augment' model, or an upstream model used as a 'Llama-augment' model, by using this function: the 'Llama-augment' model is not, through this code itself, distributed to you (ie. you are likely receiving the 'Llama-augment' model from Soaring Distributions LLC regardless of where you obtained this code from).
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
	# https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF
	# https://web.archive.org/web/20250323003504/https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF
	# https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF
	# https://web.archive.org/web/20250105072418/https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF
	# https://huggingface.co/mlabonne/NeuralDaredevil-8B-abliterated
	# https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF
	# https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF/tree/main
	# https://web.archive.org/web/20250526124847/https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF
	# https://web.archive.org/web/20250206175259/https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF/tree/main
	#
	# Explicitly states 'License: llama3.1'. Readme files, etc, from repository does NOT contradict this.
	
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
	

	# Reducing 'Llama-augment' model size by more qunatization than Q4_K_M mostly benefits use cases possibly alongside other AI LLM models which may consume nearly all available RAM, VRAM, etc.
	
	# May or may not be more track record with this slightly different model, using Q4-K-M quantization.
	# https://huggingface.co/grimjim/Llama-3.1-8B-Instruct-abliterated_via_adapter-GGUF
	
	# Alternative quantization, especially IQ2-M, IQ4-XS. Beware Q4-K-M may have some community testing of important edge cases already.
	# https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/tree/main

	# Given the 'augment' use that has been proven, using an AI LLM similarly to 'sed', 'grep', etc, already requiring a second 'gibberish' detection step, slight degradation of reliability should cause no issues. Recommended quantizations are IQ3_XXS (~5% per ~67% less reliability), IQ2_XXS (~20% per 67% less reliability).
	#  The '~20% per 67%' less reliability is based on the idea that for a problem or problem set the AI LLM may solve correctly 67% of the time, the rate of correct solutions will be reduced by ~20% .
	#  https://raw.githubusercontent.com/matt-c1/llama-3-quant-comparison/refs/heads/main/plots/MMLU-Correctness-vs-Model-Size.svg
	# https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-i1-GGUF/tree/main


	
	# Default 'temperature' may have previously been 0.8 .
	# https://github.com/ollama/ollama/issues/6410?utm_source=chatgpt.com
	# https://github.com/ollama/ollama/blob/main/api/types.go#L657
	echo 'FROM ./NeuralDaredevil-8B-abliterated.Q3_K_M.gguf
PARAMETER num_ctx 6144

TEMPLATE "{{- range .Messages }}<|start_header_id|>{{ .Role }}<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- end }}<|start_header_id|>assistant<|end_header_id|>

"
PARAMETER num_ctx 6144
PARAMETER stop <|start_header_id|>
PARAMETER stop <|end_header_id|>
PARAMETER stop <|eot_id|>
PARAMETER temperature 0.7

' > Llama-augment.Modelfile

	_here_license-Llama-augment >> Llama-augment.Modelfile
	
	##wget 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
	#aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf'
	#[[ ! -e 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf' --disable-ipv6=true
	
	# DUBIOUS . May not be compatible with ollama , etc.
	##wget 'https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-i1-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ2_XXS.gguf'
	#aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf' 'https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-i1-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf'
	#[[ ! -e 'Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf' 'https://huggingface.co/mradermacher/Meta-Llama-3.1-8B-Instruct-abliterated-i1-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf' --disable-ipv6=true

	# DUBIOUS . May not be compatible with ollama , etc.
	##wget 'https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf'
	#aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf' 'https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf'
	#[[ ! -e 'Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf' 'https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf' --disable-ipv6=true

	##wget 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf'
	#aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf'
	#[[ ! -e 'meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf' 'https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF/resolve/main/meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf' --disable-ipv6=true

	#wget 'https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF/resolve/main/NeuralDaredevil-8B-abliterated.Q3_K_M.gguf'
	aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'NeuralDaredevil-8B-abliterated.Q3_K_M.gguf' 'https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF/resolve/main/NeuralDaredevil-8B-abliterated.Q3_K_M.gguf'
	[[ ! -e 'NeuralDaredevil-8B-abliterated.Q3_K_M.gguf' ]] && aria2c --log=- --log-level=info -x "3" --async-dns=false -o 'NeuralDaredevil-8B-abliterated.Q3_K_M.gguf' 'https://huggingface.co/QuantFactory/NeuralDaredevil-8B-abliterated-GGUF/resolve/main/NeuralDaredevil-8B-abliterated.Q3_K_M.gguf' --disable-ipv6=true
	
	if [[ ! -e 'NeuralDaredevil-8B-abliterated.Q3_K_M.gguf' ]]
	then
		_wget_githubRelease_join "soaringDistributions/Llama-augment_bundle" "" "NeuralDaredevil-8B-abliterated.Q3_K_M.gguf"
	fi
	
	_service_ollama
	
	! ollama create Llama-augment -f Llama-augment.Modelfile && _messagePlain_bad 'bad: FAIL: ollama create Llama-augment' && _messageFAIL
	
	if ! _if_cygwin
	then
		! echo | sudo -n tee /AI-Llama-augment > /dev/null && _messagePlain_bad 'bad: FAIL: echo | sudo -n tee /AI-Llama-augment' && _messageFAIL
	fi

	rm -f NeuralDaredevil-8B-abliterated.Q3_K_M.gguf
	rm -f meta-llama-3.1-8b-instruct-abliterated.Q2_K.gguf
	rm -f Meta-Llama-3.1-8B-Instruct-abliterated-IQ2_M.gguf
	rm -f Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ2_XXS.gguf
	rm -f Meta-Llama-3.1-8B-Instruct-abliterated.i1-IQ3_XXS.gguf
	rm -f llama-3.1-8b-instruct-abliterated.Q4_K_M.gguf
	rm -f Llama-augment.Modelfile
	
	_ollama_stop_augment
	
	
	cd "$functionEntryPWD"
	_stop
}
_setup_ollama_sequence() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_mustGetSudo

	_start
	
	echo 'setup: ollama: https://ollama.com/install.sh'

	cd "$safeTmp"

	local currentExitStatus="1"
	
	# DANGER: This upstream script, as with many, has been known to use 'rm' recursively without the safety checks of '_safeRMR' .
	# CAUTION: This upstream script may not catch error conditions upon failure, which may increase the size of dist/OS images built after such failures.
	curl -fsSL https://ollama.com/install.sh | sh
	currentExitStatus="$?"
	sleep 3

	# Apparently necessary to enable the service, due to systemctl not being usefully available within ChRoot.
	sudo -n mkdir -p /etc/systemd/system/default.target.wants/
	sudo -n ln -sf /etc/systemd/system/ollama.service /etc/systemd/system/default.target.wants/ollama.service

	cd "$functionEntryPWD"
	_stop "$currentExitStatus"
}
_setup_ollama() {
	#_wantGetDep sudo
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)

	[[ "$nonet" == "true" ]] && echo 'warn: nonet: skip: _setup_ollama' && return 0

	if ( [[ $(id -u) != 0 ]] || _if_cygwin )
	then
		[[ "$1" != "--force" ]] && find "$HOME"/.ubcore/.retest-ollama -type f -mtime -2 2>/dev/null | grep '.retest-ollama' > /dev/null 2>&1 && return 0

		rm -f "$HOME"/.ubcore/.retest-ollama > /dev/null 2>&1
		touch "$HOME"/.ubcore/.retest-ollama
		date +%s > "$HOME"/.ubcore/.retest-ollama
	fi


	if ! _if_cygwin
	then
		_messagePlain_request 'ignore: upstream progress ->'
		! "$scriptAbsoluteLocation" _setup_ollama_sequence && _messagePlain_bad 'bad: FAIL: _setup_ollama_sequence' && _messageFAIL
		_messagePlain_request 'ignore: <- upstream progress'
	fi
	
	type -p ollama > /dev/null 2>&1 && "$scriptAbsoluteLocation" _setup_ollama_model_augment_sequence
}

_test_ollama() {
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)

	if ! type -p ollama > /dev/null 2>&1 || ! [[ -e /AI-Llama-augment ]]
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
	local currentExitStatus
	currentExitStatus=1

	local currentPoints
	currentPoints=0
	
	if ! _ollama_run_augment "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ." | grep -i true > /dev/null
	then
		echo 'fail: _vector_ollama' && _messagePlain_bad 'fail: _vector_ollama: prompt for word true did not output word true'
	else
		currentExitStatus=0
		currentPoints=$((currentPoints+1))
	fi
	if _ollama_run_augment "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ." | grep -i false > /dev/null
	then
		echo 'fail: _vector_ollama' && _messagePlain_bad 'fail: _vector_ollama: prompt for word true instead included word false'
	else
		currentExitStatus=0
		currentPoints=$((currentPoints+1))
	fi
	
	if ! _ollama_run_augment "Please output the word false . Any other output accompanying the word false is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word false will be very helpful whereas any output other than the word false will be unhelpful . Please output the word false ." | grep -i false > /dev/null
	then
		echo 'fail: _vector_ollama' && _messagePlain_bad 'fail: _vector_ollama: prompt for word false did not output word false'
	else
		currentExitStatus=0
		currentPoints=$((currentPoints+1))
	fi
	if _ollama_run_augment "Please output the word false . Any other output accompanying the word false is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word false will be very helpful whereas any output other than the word false will be unhelpful . Please output the word false ." | grep -i true > /dev/null
	then
		echo 'fail: _vector_ollama' && _messagePlain_bad 'fail: _vector_ollama: prompt for word false instead included word true'
	else
		currentExitStatus=0
		currentPoints=$((currentPoints+1))
	fi


	# If NONE of the vector tests have succeeded, then FAIL . Normally, with an 'augment' LLM model, this should be so rare as to vastly more often indicate broken ollama installation, very broken/corrupted LLM model, very broken LLM configuration, insufficient disk space for model, etc.
	[[ "$currentExitStatus" != "0" ]] && _messageFAIL && _stop 1

	# At least two of the vector tests can apparently pass with a broken (or missing) AI model, and very basic vector tests with an 'augment' AI model are normally extremely reliable.
	[[ "$currentPoints" -lt 3 ]] && _messageFAIL && _stop 1
	#[[ "$currentPoints" -lt 4 ]] && _messageFAIL && _stop 1

	return 0
}
_vector_ollama() {
	#_mustGetSudo
	#export currentUser_ollama=$(_user_ollama)

	_service_ollama
	
	if _if_cygwin && ! type -p ollama > /dev/null 2>&1
	then
		echo 'warn: accepted: cygwin: missing: ollama'
		return 0
	fi

	if type -p ollama > /dev/null 2>&1
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
	_mustGetSudo
	_if_cygwin && return 0
	if ! sudo -n -u ollama bash -c 'type -p ollama'
	then
		echo 'warn: _service_ollama: missing: ollama'
		return 1
	fi
	
	if ! wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O - > /dev/null
	then
		sudo -n -u ollama ollama serve &
		while ! wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O - > /dev/null
		do
			echo "wait: ollama: service"
			sleep 1
		done
		sleep 45
	fi
	
	
	if ! wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O - > /dev/null 
	then
		echo 'fail: _service_ollama: ollama: 127.0.0.1:11434'
		return 1
	fi

	return 0
}

# Very unusual. Ensures service is available, if normal systemd service is not.
# WARNING: Should NOT run standalone service if systemd service is available. Thus, it is important to check if the service is already available (as would normally always be the case when booted with systemd available).
# Mostly, this is used to workaround very unusual dist/OS build and custom situations (ie. ChRoot, GitHub Actions, etc).
# CAUTION: This leaves a background process running, which must continue running (ie. not hangup) while other programs use it, and which must terminate upon shutdown , _closeChRoot , etc .
_service_ollama_augment() {
	local current_OLLAMA_HOST
	current_OLLAMA_HOST="$OLLAMA_HOST"
	[[ "$current_OLLAMA_HOST" == "" ]] && current_OLLAMA_HOST='127.0.0.1:11434'

	wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1 && return 0
	
	if _if_cygwin && ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		( nohup ollama ls > /dev/null 2>&1 & disown -r "$!" ) > /dev/null
		
		sleep 7
	fi

	if _if_cygwin && ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		return 1
	fi
	_if_cygwin && return 0

	if _if_wsl && ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		#( nohup ollama ls > /dev/null 2>&1 & disown -r "$!" ) > /dev/null
		#sleep 2
		
		##/mnt/c/Windows/System32/cmd.exe /C 'C:\q\p\zCore\infrastructure\ubiquitous_bash\_bin.bat' '/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubiquitous_bash.sh' '_bin' 'sleep' '45'
		##/mnt/c/Windows/System32/cmd.exe /C 'C:\q\p\zCore\infrastructure\ubiquitous_bash\_bin.bat' '/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubiquitous_bash.sh' '_bin' '_setup_wsl2_procedure-portproxy' > /dev/null 2>&1

		# ATTRIBUTION-AI: ChatGPT o3  2025-06-01

		#-Wait
		#,'start','""','/b'
		"$scriptAbsoluteLocation" _powershell -NoProfile -Command "Start-Process cmd.exe -ArgumentList '/C','C:\core\infrastructure\ubDistBuild\_bin.bat','_install_vm-wsl2-portForward','ubdist','notBootingAdmin' -Verb RunAs" > /dev/null 2>&1
		local currentIteration=0
		while ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1 && [[ "$currentIteration" -lt 45 ]]
		do
			currentIteration=$((currentIteration+1))
			sleep 1
		done

		sleep 3
	fi

	if _if_wsl && ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		return 1
	fi
	_if_wsl && return 0

	_mustGetSudo
	if ! sudo -n -u ollama bash -c 'type -p ollama' > /dev/null 2>&1
	then
		#echo 'warn: _service_ollama: missing: ollama'
		return 1
	fi
	
	if ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		# ATTENTION: This is basically how to not cause interactive bash shell issues starting a background service at Docker container runtime.
		# WARNING: May not be adequately tested.
		# ATTRIBUTION-AI: ChatGPT o3  2025-05-05  (partially)
		( echo | sudo -n -u ollama nohup ollama serve </dev/null >>/var/log/ollama.log 2>&1 & ) &> /dev/null
		while ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
		do
			sleep 1
		done
		stty echo
		stty sane
		stty echo
		
		#sudo -n -u ollama ollama serve &
		#while ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
		#do
			#echo "wait: ollama: service"
			#sleep 1
		#done
		sleep 3
	fi
	
	
	if ! wget --timeout=1 --tries=3 'http://'"$current_OLLAMA_HOST" -q -O - > /dev/null 2>&1
	then
		#echo 'fail: _service_ollama: ollama: 127.0.0.1:11434'
		return 1
	fi

	return 0
}

