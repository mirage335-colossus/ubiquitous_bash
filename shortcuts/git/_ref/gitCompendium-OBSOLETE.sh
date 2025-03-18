


_compendium_git-custom-repo() {
	! _openChRoot && _messageFAIL
	
	export INPUT_GITHUB_TOKEN="$GH_TOKEN"
	
	_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'"$1"' ; cd /home/user/core/'"$1"' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest clone --recursive --depth 1 git@github.com:'"$2"'/'"$3"'.git'
	if ! sudo -n ls "$globalVirtFS"/home/user/core/"$1"/"$3"
	then
		_messagePlain_bad 'bad: FAIL: missing: '/home/user/core/"$1"/"$3"
		_messageFAIL
		_stop 1
		return 1
	fi
	
	! _closeChRoot && _messageFAIL
}


_compendium_git-upgrade-repo() {
	_messageNormal '_git-upgrade-repo: '"$1"' '"$2"' '"$3"
	
	! _openChRoot && _messageFAIL
	
	export INPUT_GITHUB_TOKEN="$GH_TOKEN"

	#_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'"$1"/"$3"' ; cd /home/user/core/'"$1"/"$3"' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest pull ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest submodule update --init --recursive'

	_messagePlain_nominal 'git pull'
	_messagePlain_probe 'cd /home/user/core/'"$1"/"$3"' ; _gitBest pull'
	! _chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'"$1"/"$3"' ; cd /home/user/core/'"$1"/"$3"' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest pull' && _messageFAIL
	_messagePlain_nominal 'git submodule update --init --depth 1 --recursive'
	! _messagePlain_probe 'cd /home/user/core/'"$1"/"$3"' ; _gitBest submodule update --init --depth 1 --recursive'
	! _chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'"$1"/"$3"' ; cd /home/user/core/'"$1"/"$3"' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest submodule update --init --recursive' && _messageFAIL
	if ! sudo -n ls "$globalVirtFS"/home/user/core/"$1"/"$3"
	then
		_messagePlain_bad 'bad: FAIL: missing: '/home/user/core/"$1"/"$3"
		_messageFAIL
		_stop 1
		return 1
	fi
	
	! _closeChRoot && _messageFAIL
}


_compendium_git-custom-repo-org_procedure() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	rmdir /home/user/core/"$1" > /dev/null 2>&1
	[[ -e /home/user/core/"$1" ]] && _messageFAIL && _stop 1
	
	export INPUT_GITHUB_TOKEN="$GH_TOKEN"
	
	# set api key
	current_api_key="$GH_TOKEN"
	
	# set github user
	current_github_user="$2"
	
	mkdir -p /home/user/core/"$1"
	cd /home/user/core/"$1"
	
	local currentPage
	
	currentPage=1
	#while [[ "$currentPage" -le "5" ]]
	#do
		#_messagePlain_probe 'repository counts...'
		## get list of repository urls
		#curl -s -H 'Authorization: token '"$current_api_key" 'https://api.github.com/users/'"$current_github_user"'/repos?per_page=1000&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | wc -w
		
		#let currentPage="$currentPage"+1
	#done
	
	sleep 1
	
	local currentRepositoryNumber
	currentRepositoryNumber=1
	
	currentPage=1
	while [[ "$currentPage" -le "5" ]]
	do
		
		# https://platform.openai.com/playground/p/6it5h1B901jvAblUhdbsPHEN?model=text-davinci-003
		
		# ATTENTION: 'orgs' or 'users'
		#for repo in $(curl -s https://api.github.com/users/$current_github_user/repos?per_page=1000 | jq -r '.[].git_url'); do
		for currentRepository in $(curl -s -H 'Authorization: token '"$current_api_key" 'https://api.github.com/orgs/'"$current_github_user"'/repos?per_page=1000&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | sed 's/git:\/\/github.com\/'"$current_github_user"'\//git@github.com:'"$current_github_user"'\//g')
		do
			_messageNormal 'git clone --recursive '"$currentRepository"
			#_messageNormal 'git clone --mirror '"$currentRepository"
			_messagePlain_probe_var currentRepositoryNumber
			_gitBest clone --recursive "$currentRepository"
			#_gitBest clone --mirror "$currentRepository"
			#_messagePlain_probe_var currentRepositoryNumber
			let currentRepositoryNumber="$currentRepositoryNumber"+1
		done
		
		let currentPage="$currentPage"+1
	done
	
	
	cd "$functionEntryPWD"
}
_compendium_git-custom-repo-org() {
	! _openChRoot && _messageFAIL
	
	_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'' ; cd /home/user/core/'' ; /home/user/ubDistBuild/ubiquitous_bash.sh _git-custom-repo-org_procedure '"$1"' '"$2"
	
	! _closeChRoot && _messageFAIL
}


_compendium_git-upgrade-repo-org_procedure() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	#rmdir /home/user/core/"$1" > /dev/null 2>&1
	#[[ -e /home/user/core/"$1" ]] && _messageFAIL && _stop 1
	
	export INPUT_GITHUB_TOKEN="$GH_TOKEN"
	
	# set api key
	current_api_key="$GH_TOKEN"
	
	# set github user
	current_github_user="$2"
	
	mkdir -p /home/user/core/"$1"
	! [[ -e /home/user/core/"$1" ]] && _messageFAIL && _stop 1
	! cd /home/user/core/"$1" && _messageFAIL && _stop 1
	
	local currentPage
	
	currentPage=1
	#while [[ "$currentPage" -le "5" ]]
	#do
		#_messagePlain_probe 'repository counts...'
		## get list of repository urls
		#curl -s -H 'Authorization: token '"$current_api_key" 'https://api.github.com/users/'"$current_github_user"'/repos?per_page=1000&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | wc -w
		
		#let currentPage="$currentPage"+1
	#done
	
	sleep 1
	
	local currentRepositoryNumber
	currentRepositoryNumber=1
	
	currentPage=1
	while [[ "$currentPage" -le "5" ]]
	do
		
		# https://platform.openai.com/playground/p/6it5h1B901jvAblUhdbsPHEN?model=text-davinci-003
		
		# ATTENTION: 'orgs' or 'users'
		#for repo in $(curl -s https://api.github.com/users/$current_github_user/repos?per_page=1000 | jq -r '.[].git_url'); do
		for currentRepository in $(curl -s -H 'Authorization: token '"$current_api_key" 'https://api.github.com/orgs/'"$current_github_user"'/repos?per_page=1000&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | sed 's/git:\/\/github.com\/'"$current_github_user"'\//git@github.com:'"$current_github_user"'\//g')
		do
			_messageNormal 'git upgrade: '"$currentRepository"
			_messagePlain_probe_var currentRepositoryNumber

			_messagePlain_nominal 'cd'
			cd /home/user/core/"$1"/"$currentRepository"
			! cd /home/user/core/"$1"/"$currentRepository" && _messageFAIL && _stop 1

			# In practice, this is not known to have any effect, not knowing the correct branch other than 'HEAD' reliably, and has been omitted in upgrade functions.
			#_messagePlain_nominal 'git checkout'
			! _messagePlain_probe_cmd git checkout "HEAD" && _messagePlain_bad 'fail: upgrade_repository: git checkout' && _messageFAIL

			_messagePlain_nominal 'git pull'
			! _messagePlain_probe_cmd _gitBest pull && _messagePlain_bad 'fail: upgrade_repository: git pull' && _messageFAIL

			_messagePlain_nominal 'git submodule update --init --depth 1 --recursive'
    		! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _messagePlain_bad 'fail: upgrade_repository: submodule update --init --depth 1 --recursive' && _messageFAIL

			
			! cd /home/user/core/"$1" && _messageFAIL && _stop 1
			let currentRepositoryNumber="$currentRepositoryNumber"+1
		done
		
		! cd /home/user/core/"$1" && _messageFAIL && _stop 1
		let currentPage="$currentPage"+1
	done
	
	! cd /home/user/core/"$1" && _messageFAIL && _stop 1
	
	cd "$functionEntryPWD"
}
_compendium_git-upgrade-repo-org() {
	! _openChRoot && _messageFAIL
	
	_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'' ; cd /home/user/core/'' ; /home/user/ubDistBuild/ubiquitous_bash.sh _git-upgrade-repo-org_procedure '"$1"' '"$2"
	
	! _closeChRoot && _messageFAIL
}
