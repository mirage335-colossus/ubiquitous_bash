
_gitBest_detect_github_procedure() {
	[[ "$current_gitBest_source_GitHub" == "FAIL" ]] && export current_gitBest_source_GitHub=""
	[[ "$current_gitBest_source_GitHub" != "" ]] && return
	
	_messagePlain_nominal 'init: _gitBest_detect_github_procedure'
	
	if [[ "$current_gitBest_source_GitHub" == "" ]]
	then
		_messagePlain_request 'performance: export current_gitBest_source_GitHub=$("'"$scriptAbsoluteLocation"'" _gitBest_detect_github_sequence | tail -n1)'
		
		if [[ -e "$HOME"/core ]] && [[ "$gitBestNoCore" != "true" ]]
		then
			export current_gitBest_source_GitHub="github_core"
		fi
		
		local currentSSHoutput
		# CAUTION: Disabling this presumes "$HOME"/.ssh/config for GitHub (possibly through 'CoreAutoSSH') is now not necessary to support by default.
		#  ATTENTION: Good assumption. GH_TOKEN/INPUT_GITHUB_TOKEN is now used by _gitBest within 'compendium' functions, etc, usually much safer and more convenient.
		#   Strongly Discouraged: Override with ops.sh if necessary.
		# || [[ -e "$HOME"/.ssh/config ]]
		if ( [[ -e "$HOME"/.ssh/id_rsa ]] || ( [[ ! -e "$HOME"/.ssh/id_ed25519_sk ]] && [[ ! -e "$HOME"/.ssh/ecdsa-sk ]] ) ) && currentSSHoutput=$(ssh -o StrictHostKeyChecking=no -o Compression=yes -o ConnectionAttempts=3 -o ServerAliveInterval=6 -o ServerAliveCountMax=9 -o ConnectTimeout="$netTimeout" -o PubkeyAuthentication=yes -o PasswordAuthentication=no git@github.com 2>&1 ; true) && _safeEcho_newline "$currentSSHoutput" | grep 'successfully authenticated'
		then
			export current_gitBest_source_GitHub="github_ssh"
			return
		fi
		_safeEcho_newline "$currentSSHoutput"
		
		# Exceptionally rare cases of 'github.com' accessed from within GitHub Actions runner (most surprisingly) not responding have apparently happened.
		local currentIteration
		for currentIteration in $(seq 1 2)
		do
			#if _checkPort github.com 443
			if wget -qO- https://github.com > /dev/null
			then
				export current_gitBest_source_GitHub="github_https"
				return
			fi
		done
		
		
		[[ "$current_gitBest_source_GitHub" == "" ]] && export current_gitBest_source_GitHub="FAIL"
		return 1
	fi
	return 0
}
_gitBest_detect_github_sequence() {
	_gitBest_detect_github_procedure "$@"
	_messagePlain_probe_var current_gitBest_source_GitHub
	echo "$current_gitBest_source_GitHub"
}
_gitBest_detect_github() {
	local currentOutput
	currentOutput=$("$scriptAbsoluteLocation" _gitBest_detect_github_sequence "$@")
	_safeEcho_newline "$currentOutput"
	export current_gitBest_source_GitHub=$(_safeEcho_newline "$currentOutput" | tail -n 1)
	[[ "$current_gitBest_source_GitHub" != "github_"* ]] && export current_gitBest_source_GitHub="FAIL"
	
	return 0
}
_gitBest_detect() {
	_gitBest_detect_github "$@"
}



_gitBest_override_config_insteadOf-core() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335/"$1".git git@github.com:mirage335/"$1"
}
_gitBest_override_config_insteadOf-core--colossus() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335-colossus/"$1".git git@github.com:mirage335-colossus/"$1"
}
_gitBest_override_config_insteadOf-core--gizmos() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:mirage335-gizmos/"$1".git git@github.com:mirage335-gizmos/"$1"
}
_gitBest_override_config_insteadOf-core--distllc() {
	git config --global url."file://""$realHome""/core/infrastructure/""$1".insteadOf git@github.com:soaringDistributions/"$1".git git@github.com:soaringDistributions/"$1"
}


_gitBest_override_github-github_core() {
	_gitBest_override_config_insteadOf-core--colossus ubiquitous_bash
	_gitBest_override_config_insteadOf-core--colossus extendedInterface

	_gitBest_override_config_insteadOf-core--gizmos flightDeck
	_gitBest_override_config_insteadOf-core--gizmos kinematicBase-large

	_gitBest_override_config_insteadOf-core--distllc ubDistBuild
	_gitBest_override_config_insteadOf-core--distllc ubDistFetch
	
	_gitBest_override_config_insteadOf-core mirage335_documents
	_gitBest_override_config_insteadOf-core mirage335GizmoScience

	_gitBest_override_config_insteadOf-core scriptedIllustrator
	_gitBest_override_config_insteadOf-core arduinoUbiquitous
	
	_gitBest_override_config_insteadOf-core BOM_designer
	_gitBest_override_config_insteadOf-core CoreAutoSSH
	_gitBest_override_config_insteadOf-core coreoracle
	_gitBest_override_config_insteadOf-core flipKey
	_gitBest_override_config_insteadOf-core freecad-assembly2
	_gitBest_override_config_insteadOf-core Freerouting
	_gitBest_override_config_insteadOf-core gEDA_designer
	_gitBest_override_config_insteadOf-core metaBus
	_gitBest_override_config_insteadOf-core PanelBoard
	_gitBest_override_config_insteadOf-core PatchRap
	_gitBest_override_config_insteadOf-core PatchRap_LulzBot
	_gitBest_override_config_insteadOf-core PatchRap_to_CNC
	_gitBest_override_config_insteadOf-core pcb-ioAutorouter
	_gitBest_override_config_insteadOf-core RigidTable
	_gitBest_override_config_insteadOf-core SigBlockly-mod
	_gitBest_override_config_insteadOf-core stepperTester
	_gitBest_override_config_insteadOf-core TazIntermediate
	_gitBest_override_config_insteadOf-core translate2geda
	_gitBest_override_config_insteadOf-core webClient
	_gitBest_override_config_insteadOf-core zipTiePanel
}
_gitBest_override_github-github_https() {
	# && [[ "$1" == "push" ]]
	if [[ "$INPUT_GITHUB_TOKEN" == "" ]]
	then
		git config --global url."https://github.com/".insteadOf git@github.com:
	elif [[ "$INPUT_GITHUB_TOKEN" != "" ]]
	then
		git config --global url."https://""$INPUT_GITHUB_TOKEN""@github.com/".insteadOf git@github.com:
	fi
}



_gitBest_override_github() {
	_messagePlain_nominal 'init: _gitBest_override_github'
	
	cat "$realHome"/.gitconfig >> "$HOME"/.gitconfig
	
	if [[ "$current_gitBest_source_GitHub" == "github_core" ]]
	then
		_gitBest_override_github-github_core
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "github_https" ]]
	then
		_gitBest_override_github-github_https "$@"
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "github_ssh" ]]
	then
		_messagePlain_good 'good: preferred: github_ssh'
	fi
	
	if [[ "$current_gitBest_source_GitHub" == "FAIL" ]]
	then
		_messageError 'FAIL: missing: GitHub'
		_stop 1
	fi
	return 0
}








_gitBest_sequence() {
	_messagePlain_nominal 'init: _gitBest_sequence'
	
	_start scriptLocal_mkdir_disable
	
	export realHome="$HOME"
	export HOME="$safeTmp"/special_fakeHome
	mkdir -p "$HOME"
	
	_messagePlain_probe_var current_gitBest_source_GitHub
	_messagePlain_probe_var HOME
	
	
	_gitBest_override_github "$@"
	
	if ! [[ -e "$HOME"/.gitconfig ]]
	then
		_messagePlain_good 'good: write: overrides: none'
	else
		echo
		echo
		cat "$HOME"/.gitconfig
		echo
		echo
	fi
	
	
	_messagePlain_nominal 'init: git'
	
	local currentExitStatus
	git "$@"
	currentExitStatus="$?"


	export HOME="$realHome"
	if _if_cygwin
	then
		if [ "$1" = "clone" ]
		then
			_messagePlain_nominal 'init: git safe directory'

			# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-12  (partially)
			local currentDirectory
			local currentURL
			local currentArg=""
			local currentArg_previous=""
			for currentArg in "$@"
			do
				# Ignore parameters:
				#  begins with "-" dash
				#  preceeded by parameter taking an argument, but no argument or "="
				if [[ "$currentArg" != -* ]] && [[ "$currentArg" != "clone" ]] && [[ "$currentArg_previous" != "--template" ]] && [[ "$currentArg_previous" != "-o" ]] && [[ "$currentArg_previous" != "-b" ]] && [[ "$currentArg_previous" != "-u" ]] && [[ "$currentArg_previous" != "--reference" ]] && [[ "$currentArg_previous" != "--separate-git-dir" ]] && [[ "$currentArg_previous" != "--depth" ]] && [[ "$currentArg_previous" != "--jobs" ]] && [[ "$currentArg_previous" != "--filter" ]]
				then
					currentURL="$currentArg"
					echo "$currentURL"
					#break

					[[ -e "$currentArg" ]] && currentDirectory="$currentArg"
				fi
				currentArg_previous="$currentArg"
			done
		fi
		
		[[ "$currentDirectory" == "" ]] && [[ "$currentURL" != "" ]] && currentDirectory=$(basename --suffix=".git" "$currentURL")
		
		if [[ -e "$currentDirectory" ]]
		then
			_messagePlain_probe 'exists: '"$currentDirectory"
			if type _write_configure_git_safe_directory_if_admin_owned > /dev/null 2>&1
			then
				currentDirectory=$(_getAbsoluteLocation "$currentDirectory")
				_write_configure_git_safe_directory_if_admin_owned "$currentDirectory"
			fi
		fi
	fi
	
	_stop "$currentExitStatus"
}

_gitBest() {
	_messageNormal 'init: _gitBest'
	
	_gitBest_detect "$@"
	
	"$scriptAbsoluteLocation" _gitBest_sequence "$@"
}


_test_gitBest() {
	_wantGetDep stty
	_wantGetDep ssh
	
	_wantGetDep git
	
	#_wantGetDep nmap
	#_wantGetDep curl
	#_wantGetDep wget
}




