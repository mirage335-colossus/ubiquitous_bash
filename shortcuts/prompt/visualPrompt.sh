# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
_visualPrompt_promptCommand() {
	[[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber='0'
	#echo "$PS1_lineNumber"
	let PS1_lineNumber="$PS1_lineNumber"+1
	#export PS1_lineNumber

	PS1_lineNumberText="$PS1_lineNumber"
	if [[ "$PS1_lineNumber" == '1' ]]
	then
		# https://unix.stackexchange.com/questions/266921/is-it-possible-to-use-ansi-color-escape-codes-in-bash-here-documents
		PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\E[1;36m'1)
		#PS1_lineNumberText=$(echo -e -n '\[\033[01;36m\]'1)
		#PS1_lineNumberText=$(echo -e -n '\033[01;36m'1)
	fi
}

_visualPrompt() {
	local currentHostname
	currentHostname="$HOSTNAME"
	
	[[ -e /etc/hostname ]] && export currentHostname=$(cat /etc/hostname)

	local currentHostname_concatenate

	[[ "$RUNPOD_POD_ID" != "" ]] && currentHostname_concatenate='runpod--'

	if [[ -e /info_factoryName.txt ]]
	then
		currentHostname_concatenate=$(cat /info_factoryName.txt)
		currentHostname_concatenate="$currentHostname_concatenate"'--'
	fi

	[[ "$RUNPOD_POD_ID" != "" ]] && currentHostname_concatenate="$currentHostname_concatenate""$RUNPOD_POD_ID"'--'

	[[ "$RUNPOD_PUBLIC_IP" != "" ]] && currentHostname_concatenate="$currentHostname_concatenate""$RUNPOD_PUBLIC_IP"'--'
	#if [[ "$RUNPOD_PUBLIC_IP" != "" ]]
	#then
		#export currentHostname_concatenate="$currentHostname_concatenate"$(wget -qO- https://icanhazip.com/ | tr -dc '0-9a-fA-F:.')'--'
	#fi
	
	export currentHostname="$currentHostname_concatenate""$currentHostname"
	
	
	
	export currentChroot=
	[[ "$chrootName" != "" ]] && export currentChroot="$chrootName"
	#[[ "$VIRTUAL_ENV_PROMPT" != "" ]] && export currentChroot=python_"$VIRTUAL_ENV_PROMPT"
	
	
	#+%H:%M:%S\ %Y-%m-%d\ Q%q
	#+%H:%M:%S\ %b\ %d,\ %y

	#Long.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]--\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])-\[\033[01;36m\]-|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]-|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]-|\#) \[\033[36m\]>\[\033[00m\] '

	#Short.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])-\[\033[01;36m\]-\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\ .%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]+\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]+\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	#Truncated, 40 columns.
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|\#) \[\033[36m\]>\[\033[00m\] '
	
	
	# https://unix.stackexchange.com/questions/434409/make-a-bash-ps1-that-counts-streak-of-correct-commands
	
	#export PROMPT_COMMAND=$(declare -f _visualPrompt_promptCommand)' ; _visualPrompt_promptCommand'
	#export PROMPT_COMMAND='_visualPrompt_promptCommand () { [[ "$PS1_lineNumber" == "" ]] && PS1_lineNumber="0"; let PS1_lineNumber="$PS1_lineNumber"+1; PS1_lineNumberText="$PS1_lineNumber"; if [[ "$PS1_lineNumber" == "1" ]]; then PS1_lineNumberText=$(echo -e -n "'"\E[1;36m"'"1"'"\E[0m"'"); fi } ; _visualPrompt_promptCommand'
	
	export -f _visualPrompt_promptCommand
	export PROMPT_COMMAND=_visualPrompt_promptCommand
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]>\[\033[00m\] '
	
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$PS1_lineNumberText\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	export prompt_specialInfo=""

	# ATTRIBUTION-AI: ChatGPT o3 (high)  2025-05-06
	#We want to see 'RTX 2000 Ada 16GB' and 'RTX 4090 16GB' , not just 'RTX 2000 16GB' . Please revise.
	#
	# RTX 2000 Ada 16GB
	# RTX 2000 16GB
	#
	_filter_nvidia_smi_gpuInfo() {
		# write the capacities any way you like:
		#             ↓ commas, spaces or a mixture ↓
		local sizes='2,3,4,6,8,10,11,12,16,20,24,32,40,48,56,64,80,94,96,128,141,180,192,256,320,384,512,640,768,896,1024,1280,1536,1792,2048'

		awk -F', *' -v sizes="$sizes" '
			BEGIN {
				# accept both commas and blanks as separators
				n = split(sizes, S, /[ ,]+/)
			}
			{
				# ----- tidy up the model name -----
				name = $1
				gsub(/NVIDIA |GeForce |Laptop GPU|[[:space:]]+Generation/, "", name)
				gsub(/  +/, " ", name)
				sub(/^ +| +$/, "", name)

				# ----- MiB -> decimal GB -----
				mib   = $2 + 0
				bytes = mib * 1048576
				decGB = bytes / 1e9     # decimal gigabytes

				# pick the nearest marketing size
				best = S[1]
				diff = (decGB > S[1] ? decGB - S[1] : S[1] - decGB)

				for (i = 2; i <= n; i++) {
					d = (decGB > S[i] ? decGB - S[i] : S[i] - decGB)
					if (d < diff) { diff = d; best = S[i] }
				}

				printf "%s %dGB\n", name, best
			}'
	}


	if type nvidia-smi > /dev/null 2>&1
	then
		export prompt_specialInfo=$(
			nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits | _filter_nvidia_smi_gpuInfo
		)
	fi

	if _if_wsl && [[ -e "/mnt/c/Windows/System32/cmd.exe" ]] && /mnt/c/Windows/System32/cmd.exe /C where nvidia-smi > /dev/null 2>&1
	then
		export prompt_specialInfo=$(
			( cd /mnt/c ; /mnt/c/Windows/System32/cmd.exe /C nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits 2>/dev/null | _filter_nvidia_smi_gpuInfo )
		)
	fi

	if [[ "$SHELL" == *"/nix/store/"*"/bin/bash"* ]]
	then
		export prompt_specialInfo="nixShell"
	fi
	
	#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	
	
	
	#if _if_cygwin
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	#then
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	#else
		#export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_nixShell"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	#fi
	


	# NOTICE: ATTENTION: Bright colors. More compatible with older terminals (in theory).
	#
	# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
	# Slightly darker yellow will be more printable on white background (ie. Pandoc rendering from HTML from asciinema cat ).
	#01;33m
	#38;5;214m
	#
	#\[\033[01;33m\]
	#'\[\e[01;33m\e[38;5;214m\]'
	#'\[\033[01;33m\033[38;5;214m\]'
	if _if_cygwin
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	elif ( uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1 )
	then
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"-wsl2'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]\[\033[37m\]\w\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '
	else
		export PS1='\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[01;31m\]${?}:${currentChroot:+($currentChroot)}\[\033[01;33m\033[38;5;214m\]\u\[\033[01;32m\]@'"$currentHostname"'\[\033[01;36m\]\[\033[01;34m\])\[\033[01;36m\]\[\033[01;34m\]-'"$prompt_cloudNetName"'(\[\033[01;35m\]$(([[ "$VIRTUAL_ENV_PROMPT" != "" ]] && echo -n "$VIRTUAL_ENV_PROMPT") || date +%H:%M:%S\.%d)\[\033[01;34m\])\[\033[01;36m\]|\[\033[00m\]'"$prompt_specialInfo"'\n\[\033[01;40m\]\[\033[01;36m\]\[\033[01;34m\]|\[\033[37m\][\w]\[\033[00m\]\n\[\033[01;36m\]\[\033[01;34m\]|$([[ "$PS1_lineNumber" == "1" ]] && echo -e -n '"'"'\[\033[01;36m\]'"'"'$PS1_lineNumber || echo -e -n $PS1_lineNumber)\[\033[01;34m\]) \[\033[36m\]'""'>\[\033[00m\] '	
	fi

	# ATTRIBUTION-AI: ChatGPT o4-mini-high  2025-06-29 .
	echo -e "\033[01;40m\033[01;36m\033[01;34m|\033[01;31m0:(exampleChroot)\033[01;33m\033[38;5;214muser\033[01;32m@exampleHost\033[01;36m\033[01;34m)\033[01;36m\033[01;34m-cloudNet(\033[01;35mvenv\033[01;34m)\033[01;36m|\033[00mINFO\n\033[01;40m\033[01;36m\033[01;34m\033[37m/home/user\033[00m\n\033[01;36m\033[01;34m|1\033[01;34m \033[36m> \033[00m"



	# NOTICE: ATTENTION: Color saturation reduced. Similar benefits, delineating separate information strings and command prompts between commands.
	# Less distracting.
	#
	# Convert desired RGB values to 8-bit using AI LLM per a table .
	# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
	#
	# Consider the neutral, white, and most obnoxious color (usually the error color red).
	# Set Luma/Chroma, to match usual stock neutral color, white slightly brighter.
	# Then set obnoxious color Luma/Chroma at slightly lower than sufficient darkness/saturation to clearly distinguish the color.
	# Rotate a color wheel (eg. GIMP) to get the other colors.
	# Rotate color wheel slightly towards the direction of preferred approximation.
	#
	# Neutral - Luma 77, Chroma 0, R75 G75 B75 - bfbfbf
	# White (path) - Luma <83, Chroma 0, R81, G81, B81 - cfcfcf
	#
	# Blue (punctuation) - 7c7fb7
	#
	# *Red (exit status, chroot) - Luma 58, Chroma 25 - b77c7d
	#
	# Orange (user) - b7977c
	#
	# Green (hostname, wsl) - 7cb77d
	#
	# Magenta (date, venv) - b77cb6
	#
	# Cyan (punctuation) - 7cb4b7

	if false
	then
		clear ; echo -e "\
\033[1;48;5;16m\033[38;5;103m|\033[38;5;138m0:(exampleChroot)\
\033[38;5;179muser\033[38;5;108m@exampleHost\
\033[38;5;103m)\033[38;5;250m-cloudNet(\
\033[38;5;141mvenv\033[38;5;103m)|\033[0mINFO\n\
\033[1;48;5;16m\033[38;5;252m/home/user\033[0m\n\
\033[38;5;103m|1 \033[38;5;109m> \033[0m" ; sleep infinity
	fi




	
	#export PS1="$prompt_specialInfo""$PS1"
}


_request_visualPrompt() {
	_messagePlain_request 'export profileScriptLocation="'"$scriptAbsoluteLocation"'"'
	_messagePlain_request 'export profileScriptFolder="'"$scriptAbsoluteFolder"'"'
	_messagePlain_request ". "'"'"$scriptAbsoluteLocation"'"' --profile _importShortcuts
}
